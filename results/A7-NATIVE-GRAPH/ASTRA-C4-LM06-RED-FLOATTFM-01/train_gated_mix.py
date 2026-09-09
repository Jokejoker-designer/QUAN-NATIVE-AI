#!/usr/bin/env python3
"""From-scratch gated dual-attn with F/R/unrel mix. PROGRAM=NO.
Phase M: opcode gate only.
Phase D: F-path adds learned mismatch delta into Q from bytes 2:6 vs 12:16.
Not a host next-token. Not two-ckpt mux. Not C4_MASTER.
"""
from __future__ import annotations

import json
from pathlib import Path

import numpy as np

from train_float import (
    D,
    EOS,
    HELD_ENT,
    MAX_TOK,
    TMAX,
    Net,
    backward,
    embed,
    eval_rows,
    forward,
    make_split,
    make_unrel,
    pack16,
    rname,
    softmax,
    zeros_g,
)
from train_float_best import restore, snapshot
from train_gated import (
    SHARED_KEYS,
    adam_subset,
    copy_attn,
    install_attn,
    new_attn,
    scores,
)
from train_gated_unrel import decode_gated_i, row_u


def row_f(rng):
    src, dst = rname(rng), rname(rng)
    while dst == src:
        dst = rname(rng)
    return pack16(f"F {dst} {src}>{dst}"), src


def row_r(rng):
    src, dst = rname(rng), rname(rng)
    while dst == src:
        dst = rname(rng)
    return pack16(f"R {src} {src}>{dst}"), dst


def mismatch_vec(xs: np.ndarray) -> np.ndarray:
    a = xs[2:6].mean(axis=0)
    b = xs[12:16].mean(axis=0)
    return a - b


def forward_delta(n: Net, xs: np.ndarray, use_delta: bool):
    if not use_delta:
        return forward(n, xs)
    logits, cache = forward(n, xs)
    q = cache["q"] + n.Wd @ mismatch_vec(xs)
    K = cache["K"]
    V = cache["V"]
    scale = cache["scale"]
    dots = (K @ q) / scale
    a = softmax(dots)
    h = a @ V
    y = cache["x_last"] + h
    t = np.maximum(n.W1 @ y, 0.0)
    z = y + n.W2 @ t
    logits = n.by + (n.We @ z)
    cache = dict(cache)
    cache.update({"q": q, "dots": dots, "a": a, "h": h, "y": y, "t": t, "z": z, "use_delta": True, "dvec": mismatch_vec(xs)})
    return logits, cache


def decode_fn(n, f_attn, r_attn, use_delta):
    def fn(net, ctx, evid):
        if not evid:
            return [ord("n"), ord("o"), EOS]
        r = ctx[:1] == b"R"
        install_attn(net, *(r_attn if r else f_attn))
        toks = list(ctx[:16]) + [EOS]
        xs = np.stack([embed(net, t, j) for j, t in enumerate(toks)])
        out = []
        for _ in range(MAX_TOK):
            logits, _ = forward_delta(net, xs, use_delta and not r)
            tok = int(np.argmax(logits))
            out.append(tok)
            if tok == EOS:
                break
            xs = np.vstack([xs, embed(net, tok, xs.shape[0])])
        return out

    return fn


def eval_all(n, held_g, held_u, f_attn, r_attn, use_delta):
    fn = decode_fn(n, f_attn, r_attn, use_delta)
    hg = eval_rows(n, held_g, fn)
    hu = eval_rows(n, held_u, fn)
    n_f, n_r = scores(hg)
    hall = hu["hall"] / hu["n"] if hu["n"] else 1.0
    return hg, hu, n_f, n_r, hall


def grads_delta(n: Net, ctx: bytes, tgt: list[int], use_delta: bool):
    toks = list(ctx[:16]) + [EOS]
    xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
    seq = toks[:]
    g = zeros_g(n)
    g["Wd"] = np.zeros_like(n.Wd)
    loss = tf_ok = tf_n = 0
    r = ctx[:1] == b"R"
    for t in tgt:
        logits, cache = forward_delta(n, xs, use_delta and not r)
        pred = int(np.argmax(logits))
        tf_n += 1
        tf_ok += int(pred == t)
        p = softmax(logits)
        loss += -np.log(max(float(p[t]), 1e-12))
        dlogits = p.copy()
        dlogits[t] -= 1.0
        dxs = np.zeros_like(xs)
        backward(n, cache, dlogits, g, dxs)
        if cache.get("use_delta"):
            a = cache["a"]
            da = cache["V"] @ (n.We.T @ dlogits)
            s = a * (da - np.dot(da, a))
            ddots = s / cache["scale"]
            dq = cache["K"].T @ ddots
            g["Wd"] += np.outer(dq, cache["dvec"])
        for j, tok in enumerate(seq):
            g["We"][tok] += dxs[j]
            g["Pe"][min(j, TMAX - 1)] += dxs[j]
        if t == EOS:
            break
        seq.append(t)
        xs = np.vstack([xs, embed(n, t, xs.shape[0])])
    return g, loss, tf_ok, tf_n


def adam_wd(n, g, adam, lr):
    b1, b2, eps = 0.9, 0.999, 1e-8
    adam["t"] += 1
    step = adam["t"]
    gk = np.clip(g["Wd"], -20, 20)
    adam["m"] = b1 * adam["m"] + (1 - b1) * gk
    adam["v"] = b2 * adam["v"] + (1 - b2) * (gk * gk)
    mhat = adam["m"] / (1 - b1 ** step)
    vhat = adam["v"] / (1 - b2 ** step)
    n.Wd -= lr * mhat / (np.sqrt(vhat) + eps)
    np.clip(n.Wd, -32, 32, out=n.Wd)


def train_phase(bag: Path, use_delta: bool, tag: str, held_g, held_u):
    rng = np.random.default_rng(23 if use_delta else 17)
    n = Net(rng)
    n.Wd = rng.normal(0, 0.05, (D, D))
    f_attn = copy_attn(n)
    n.Wq, n.Wk, n.Wv = new_attn(rng)
    r_attn = copy_attn(n)
    adam_shared = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    adam_f = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    adam_r = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    adam_d = {"t": 0, "m": np.zeros_like(n.Wd), "v": np.zeros_like(n.Wd)}
    data_rng = np.random.default_rng(21)
    best = None
    hist = []
    for ep in range(50):
        lr = 0.006 if ep < 24 else 0.002
        tot = tf_ok = tf_n = 0
        for _ in range(96):
            mode = int(data_rng.integers(0, 3))
            if mode == 0:
                ctx, ans = row_f(data_rng)
                install_attn(n, *f_attn)
                g, loss, a, b = grads_delta(n, ctx.encode(), [ord(c) for c in ans] + [EOS], use_delta)
                adam_subset(n, g, adam_shared, lr, SHARED_KEYS)
                adam_subset(n, g, adam_f, lr, ("Wq", "Wk", "Wv"))
                if use_delta:
                    adam_wd(n, g, adam_d, lr)
                f_attn = copy_attn(n)
            elif mode == 1:
                ctx, ans = row_r(data_rng)
                install_attn(n, *r_attn)
                g, loss, a, b = grads_delta(n, ctx.encode(), [ord(c) for c in ans] + [EOS], False)
                adam_subset(n, g, adam_shared, lr, SHARED_KEYS)
                adam_subset(n, g, adam_r, lr, ("Wq", "Wk", "Wv"))
                r_attn = copy_attn(n)
            else:
                ctx, ans = row_u(data_rng)
                install_attn(n, *f_attn)
                g, loss, a, b = grads_delta(n, ctx.encode(), [ord(c) for c in ans] + [EOS], use_delta)
                adam_subset(n, g, adam_shared, lr, SHARED_KEYS)
                adam_subset(n, g, adam_f, lr, ("Wq", "Wk", "Wv"))
                if use_delta:
                    adam_wd(n, g, adam_d, lr)
                f_attn = copy_attn(n)
            tot += loss
            tf_ok += a
            tf_n += b
        hg, hu, n_f, n_r, hall = eval_all(n, held_g, held_u, f_attn, r_attn, use_delta)
        rec = {
            "ep": ep,
            "tf": tf_ok / tf_n,
            "held": hg["acc"],
            "f": n_f,
            "r": n_r,
            "unrel": hu["acc"],
            "hall": hall,
        }
        hist.append(rec)
        print(
            f"{tag} EP {ep} tf={rec['tf']:.3f} F={n_f} R={n_r} unrel={hu['acc']:.3f} hall={hall:.3f}",
            flush=True,
        )
        metric = (hg["acc"] + hu["acc"] - hall, n_f + n_r)
        if best is None or metric > best["metric"]:
            best = {
                "metric": metric,
                "snap": snapshot(n),
                "Wd": n.Wd.copy(),
                "f_attn": (f_attn[0].copy(), f_attn[1].copy(), f_attn[2].copy()),
                "r_attn": (r_attn[0].copy(), r_attn[1].copy(), r_attn[2].copy()),
                "g": hg["acc"],
                "u": hu["acc"],
                "hall": hall,
                "f": n_f,
                "r": n_r,
            }
        if hg["acc"] >= 0.90 and hu["acc"] >= 0.95 and hall <= 0.05:
            break
    restore(n, best["snap"])
    n.Wd = best["Wd"]
    f_attn, r_attn = best["f_attn"], best["r_attn"]
    hg, hu, n_f, n_r, hall = eval_all(n, held_g, held_u, f_attn, r_attn, use_delta)
    fn_i = decode_gated_i

    def wrap_i(net, ctx, evid):
        return fn_i(net, ctx, evid, f_attn, r_attn)

    hg_i = eval_rows(n, held_g, wrap_i)
    hu_i = eval_rows(n, held_u, wrap_i)
    np.savez(
        bag / f"snap_gated_{tag}.npz",
        **snapshot(n),
        Wd=n.Wd,
        WqF=f_attn[0],
        WkF=f_attn[1],
        WvF=f_attn[2],
        WqR=r_attn[0],
        WkR=r_attn[1],
        WvR=r_attn[2],
    )
    return {
        "mode": tag,
        "use_delta": use_delta,
        "held_float": hg["acc"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "unrel_float": hu["acc"],
        "hall_float": hall,
        "lang_90_95_5_float": hg["acc"] >= 0.90 and hu["acc"] >= 0.95 and hall <= 0.05,
        "held_int": hg_i["acc"],
        "unrel_int": hu_i["acc"],
        "hall_int": hu_i["hall"] / hu_i["n"] if hu_i["n"] else 1.0,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
        "unrel_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hu["samples"][:6]],
    }


def main():
    bag = Path(__file__).resolve().parent
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    m = train_phase(bag, False, "mix", held_g, held_u)
    d = train_phase(bag, True, "delta", held_g, held_u)
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "program": "NO",
        "c4_master": False,
        "two_ckpt_mux": False,
        "mix": m,
        "delta": d,
        "lang_90_95_5_float": bool(m["lang_90_95_5_float"] or d["lang_90_95_5_float"]),
    }
    (bag / "TRAIN_METRICS_GATED_MIX.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(
        "SUMMARY",
        json.dumps(
            {
                "mix_f": m["held_f_ok"],
                "mix_r": m["held_r_ok"],
                "mix_u": m["unrel_float"],
                "mix_h": m["hall_float"],
                "mix_hit": m["lang_90_95_5_float"],
                "del_f": d["held_f_ok"],
                "del_r": d["held_r_ok"],
                "del_u": d["unrel_float"],
                "del_h": d["hall_float"],
                "del_hit": d["lang_90_95_5_float"],
            }
        ),
        flush=True,
    )


if __name__ == "__main__":
    main()
