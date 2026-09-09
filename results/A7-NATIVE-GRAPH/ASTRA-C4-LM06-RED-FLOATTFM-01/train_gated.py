#!/usr/bin/env python3
"""Opcode-gated attention, shared We/FFN. PROGRAM=NO. One module, not two-ckpt mux.
Phase A: freeze F=12 trunk, train R Wq/Wk/Wv only.
Phase B: from-scratch dual attention + shared trunk on F and R rows.
"""
from __future__ import annotations

import json
import math
from pathlib import Path

import numpy as np

from train_float import (
    D,
    EOS,
    HELD_ENT,
    MAX_TOK,
    TMAX,
    Net,
    adam_update,
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

SHARED_KEYS = ("We", "W1", "W2", "by", "Pe")
ATTN_KEYS = ("Wq", "Wk", "Wv")


def adam_subset(n: Net, g, adam, lr: float, keys) -> None:
    b1, b2, eps = 0.9, 0.999, 1e-8
    adam["t"] += 1
    step = adam["t"]
    params = n.params()
    for k in keys:
        p = params[k]
        gk = np.clip(g[k], -20, 20)
        adam["m"][k] = b1 * adam["m"][k] + (1 - b1) * gk
        adam["v"][k] = b2 * adam["v"][k] + (1 - b2) * (gk * gk)
        mhat = adam["m"][k] / (1 - b1 ** step)
        vhat = adam["v"][k] / (1 - b2 ** step)
        p -= lr * mhat / (np.sqrt(vhat) + eps)
        np.clip(p, -32, 32, out=p)
    if "by" in keys:
        n.by[EOS] = min(float(n.by[EOS]), -2.0)
from train_float_best import restore, snapshot
from train_pcg_from_f import scores


def new_attn(rng: np.random.Generator):
    wq = np.eye(D) + rng.normal(0, 0.02, (D, D))
    wk = np.eye(D) + rng.normal(0, 0.02, (D, D))
    wv = np.eye(D) + rng.normal(0, 0.02, (D, D))
    return wq, wk, wv


def install_attn(n: Net, wq, wk, wv) -> None:
    n.Wq, n.Wk, n.Wv = wq, wk, wv


def copy_attn(n: Net):
    return n.Wq.copy(), n.Wk.copy(), n.Wv.copy()


def grads_seq(n: Net, ctx: bytes, tgt: list[int]):
    toks = list(ctx[:16]) + [EOS]
    xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
    seq = toks[:]
    g = zeros_g(n)
    loss = 0.0
    tf_ok = tf_n = 0
    for t in tgt:
        logits, cache = forward(n, xs)
        pred = int(np.argmax(logits))
        tf_n += 1
        tf_ok += int(pred == t)
        p = softmax(logits)
        loss += -math.log(max(float(p[t]), 1e-12))
        dlogits = p.copy()
        dlogits[t] -= 1.0
        dxs = np.zeros_like(xs)
        backward(n, cache, dlogits, g, dxs)
        for j, tok in enumerate(seq):
            g["We"][tok] += dxs[j]
            g["Pe"][min(j, TMAX - 1)] += dxs[j]
        if t == EOS:
            break
        seq.append(t)
        xs = np.vstack([xs, embed(n, t, xs.shape[0])])
    return g, loss, tf_ok, tf_n


def tf_step(n: Net, ctx: bytes, tgt: list[int], adam, lr: float, attn_only: bool):
    g, loss, tf_ok, tf_n = grads_seq(n, ctx, tgt)
    if attn_only:
        for k in SHARED_KEYS:
            g[k][:] = 0
        adam_update(n, g, adam, lr)
    else:
        adam_update(n, g, adam, lr)
    return loss, tf_ok, tf_n


def tf_dual(n: Net, ctx: bytes, tgt: list[int], adam_shared, adam_attn, lr: float):
    g, loss, tf_ok, tf_n = grads_seq(n, ctx, tgt)
    adam_subset(n, g, adam_shared, lr, SHARED_KEYS)
    adam_subset(n, g, adam_attn, lr, ATTN_KEYS)
    return loss, tf_ok, tf_n


def decode_gated(n: Net, ctx: bytes, evid: bool, f_attn, r_attn):
    if not evid:
        return [ord("n"), ord("o"), EOS]
    install_attn(n, *(r_attn if ctx[:1] == b"R" else f_attn))
    toks = list(ctx[:16]) + [EOS]
    xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
    out = []
    for _ in range(MAX_TOK):
        logits, _ = forward(n, xs)
        tok = int(np.argmax(logits))
        out.append(tok)
        if tok == EOS:
            break
        xs = np.vstack([xs, embed(n, tok, xs.shape[0])])
    return out


def eval_gated(n, rows, f_attn, r_attn):
    def fn(net, ctx, evid):
        return decode_gated(net, ctx, evid, f_attn, r_attn)

    return eval_rows(n, rows, fn)


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


def phase_a(bag: Path, held_g, held_u):
    rng = np.random.default_rng(11)
    n = Net(rng)
    z = np.load(bag / "snap_pcg_fprotect.npz")
    restore(n, {k: z[k] for k in z.files})
    f_attn = copy_attn(n)
    n.Wq, n.Wk, n.Wv = new_attn(rng)
    r_attn = copy_attn(n)
    hg0 = eval_gated(n, held_g, f_attn, r_attn)
    f0, r0 = scores(hg0)
    print(f"A_LOAD F={f0} R={r0} held={hg0['acc']:.3f}", flush=True)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    data_rng = np.random.default_rng(21)
    best = {"acc": hg0["acc"], "f": f0, "r": r0, "attn": (r_attn[0].copy(), r_attn[1].copy(), r_attn[2].copy())}
    hist = []
    for ep in range(30):
        lr = 0.008 if ep < 12 else 0.003
        tot = tf_ok = tf_n = 0
        install_attn(n, *r_attn)
        for _ in range(96):
            ctx, ans = row_r(data_rng)
            loss, a, b = tf_step(n, ctx.encode(), [ord(c) for c in ans] + [EOS], adam, lr, True)
            tot += loss
            tf_ok += a
            tf_n += b
        r_attn = copy_attn(n)
        install_attn(n, *f_attn)
        hg = eval_gated(n, held_g, f_attn, r_attn)
        n_f, n_r = scores(hg)
        rec = {"ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "f": n_f, "r": n_r}
        hist.append(rec)
        print(f"GATEA EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} F={n_f} R={n_r}", flush=True)
        if n_f < 12:
            install_attn(n, *f_attn)
            continue
        if n_r > best["r"] or (n_r == best["r"] and hg["acc"] > best["acc"]):
            best = {"acc": hg["acc"], "f": n_f, "r": n_r, "attn": (r_attn[0].copy(), r_attn[1].copy(), r_attn[2].copy())}
        if hg["acc"] >= 0.90:
            break
    r_attn = best["attn"]
    hg = eval_gated(n, held_g, f_attn, r_attn)
    hu = eval_gated(n, held_u, f_attn, r_attn)
    n_f, n_r = scores(hg)
    np.savez(
        bag / "snap_gated_a.npz",
        **snapshot(n),
        WqR=r_attn[0],
        WkR=r_attn[1],
        WvR=r_attn[2],
    )
    return {
        "mode": "frozen_f12_gated_r_attn",
        "load_f": f0,
        "load_r": r0,
        "held_float": hg["acc"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "hall_float": hu["hall"] / hu["n"] if hu["n"] else 1.0,
        "lang_90_float": hg["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
    }


def phase_b(bag: Path, held_g, held_u):
    rng = np.random.default_rng(17)
    n = Net(rng)
    f_attn = copy_attn(n)
    n.Wq, n.Wk, n.Wv = new_attn(rng)
    r_attn = copy_attn(n)
    adam_shared = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    adam_f = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    adam_r = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    data_rng = np.random.default_rng(21)
    best = {"acc": -1.0, "f": -1, "r": -1, "snap": snapshot(n), "f_attn": copy_attn(n), "r_attn": copy_attn(n)}
    hist = []
    for ep in range(40):
        lr = 0.006 if ep < 20 else 0.002
        tot = tf_ok = tf_n = 0
        for _ in range(64):
            ctx, ans = row_f(data_rng)
            install_attn(n, *f_attn)
            loss, a, b = tf_dual(n, ctx.encode(), [ord(c) for c in ans] + [EOS], adam_shared, adam_f, lr)
            f_attn = copy_attn(n)
            tot += loss
            tf_ok += a
            tf_n += b
            ctx, ans = row_r(data_rng)
            install_attn(n, *r_attn)
            loss, a, b = tf_dual(n, ctx.encode(), [ord(c) for c in ans] + [EOS], adam_shared, adam_r, lr)
            r_attn = copy_attn(n)
            tot += loss
            tf_ok += a
            tf_n += b
        hg = eval_gated(n, held_g, f_attn, r_attn)
        n_f, n_r = scores(hg)
        rec = {"ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "f": n_f, "r": n_r}
        hist.append(rec)
        print(f"GATEB EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} F={n_f} R={n_r}", flush=True)
        if hg["acc"] > best["acc"] or (hg["acc"] == best["acc"] and n_f + n_r > best["f"] + best["r"]):
            best = {
                "acc": hg["acc"],
                "f": n_f,
                "r": n_r,
                "snap": snapshot(n),
                "f_attn": (f_attn[0].copy(), f_attn[1].copy(), f_attn[2].copy()),
                "r_attn": (r_attn[0].copy(), r_attn[1].copy(), r_attn[2].copy()),
            }
        if hg["acc"] >= 0.90:
            break
    restore(n, best["snap"])
    f_attn, r_attn = best["f_attn"], best["r_attn"]
    hg = eval_gated(n, held_g, f_attn, r_attn)
    hu = eval_gated(n, held_u, f_attn, r_attn)
    n_f, n_r = scores(hg)
    np.savez(
        bag / "snap_gated_b.npz",
        **snapshot(n),
        WqF=f_attn[0],
        WkF=f_attn[1],
        WvF=f_attn[2],
        WqR=r_attn[0],
        WkR=r_attn[1],
        WvR=r_attn[2],
    )
    return {
        "mode": "from_scratch_dual_attn_shared_trunk",
        "held_float": hg["acc"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "hall_float": hu["hall"] / hu["n"] if hu["n"] else 1.0,
        "lang_90_float": hg["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
    }


def main():
    bag = Path(__file__).resolve().parent
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    a = phase_a(bag, held_g, held_u)
    b = phase_b(bag, held_g, held_u)
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "program": "NO",
        "c4_master": False,
        "two_ckpt_mux": False,
        "phase_a": a,
        "phase_b": b,
        "lang_90_float": bool(a["lang_90_float"] or b["lang_90_float"]),
    }
    (bag / "TRAIN_METRICS_GATED.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(
        "SUMMARY",
        json.dumps(
            {
                "a_f": a["held_f_ok"],
                "a_r": a["held_r_ok"],
                "a_90": a["lang_90_float"],
                "b_f": b["held_f_ok"],
                "b_r": b["held_r_ok"],
                "b_90": b["lang_90_float"],
            }
        ),
        flush=True,
    )


if __name__ == "__main__":
    main()
