#!/usr/bin/env python3
"""Frozen F=12 net + learned R-only query bias. PROGRAM=NO. One checkpoint.
F path is unchanged when ctx[0]!='R'. Not a two-bank mux.
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
    decode_i,
    embed,
    eval_rows,
    make_split,
    make_unrel,
    pack16,
    rname,
    softmax,
    zeros_g,
)
from train_float import backward as backward_base
from train_float import forward as forward_base
from train_pcg_from_f import scores
from train_float_best import restore, snapshot


def forward_film(n: Net, xs: np.ndarray, r_flag: bool):
    logits, cache = forward_base(n, xs)
    if not r_flag:
        cache["r_flag"] = False
        return logits, cache
    q = cache["q"] + n.qR
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
    cache.update({"q": q, "dots": dots, "a": a, "h": h, "y": y, "t": t, "z": z, "r_flag": True})
    return logits, cache


def decode_film(n: Net, ctx: bytes, evid: bool) -> list[int]:
    if not evid:
        return [ord("n"), ord("o"), EOS]
    r_flag = ctx[:1] == b"R"
    toks = list(ctx[:16]) + [EOS]
    xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
    out = []
    for _ in range(MAX_TOK):
        logits, _ = forward_film(n, xs, r_flag)
        tok = int(np.argmax(logits))
        out.append(tok)
        if tok == EOS:
            break
        xs = np.vstack([xs, embed(n, tok, xs.shape[0])])
    return out


def grads_r(n: Net, ctx: bytes, tgt: list[int]):
    r_flag = True
    toks = list(ctx[:16]) + [EOS]
    xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
    gq = np.zeros(D, dtype=np.float64)
    loss = 0.0
    tf_ok = tf_n = 0
    for t in tgt:
        logits, cache = forward_film(n, xs, r_flag)
        pred = int(np.argmax(logits))
        tf_n += 1
        tf_ok += int(pred == t)
        p = softmax(logits)
        loss += -math.log(max(float(p[t]), 1e-12))
        dlogits = p.copy()
        dlogits[t] -= 1.0
        dxs = np.zeros_like(xs)
        dummy_g = zeros_g(n)
        backward_base(n, cache, dlogits, dummy_g, dxs)
        a = cache["a"]
        da = cache["V"] @ (n.We.T @ dlogits)
        s = a * (da - np.dot(da, a))
        ddots = s / cache["scale"]
        dq = cache["K"].T @ ddots
        gq += dq
        if t == EOS:
            break
        xs = np.vstack([xs, embed(n, t, xs.shape[0])])
    return gq, loss, tf_ok, tf_n


def row_r(rng):
    src, dst = rname(rng), rname(rng)
    while dst == src:
        dst = rname(rng)
    return pack16(f"R {src} {src}>{dst}"), dst


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(11)
    n = Net(rng)
    z = np.load(bag / "snap_pcg_fprotect.npz")
    restore(n, {k: z[k] for k in z.files})
    n.qR = rng.normal(0, 2.0, D)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    hg0 = eval_rows(n, held_g, decode_film)
    f0, r0 = scores(hg0)
    print(f"LOAD F={f0} R={r0} held={hg0['acc']:.3f}", flush=True)
    m = np.zeros(D)
    v = np.zeros(D)
    data_rng = np.random.default_rng(21)
    best_acc = hg0["acc"]
    best_q = n.qR.copy()
    hist = []
    lr = 0.05
    for ep in range(40):
        tot = tf_ok = tf_n = 0
        for _ in range(96):
            ctx, ans = row_r(data_rng)
            gq, loss, a, b = grads_r(n, ctx.encode(), [ord(c) for c in ans] + [EOS])
            gq = np.clip(gq, -20, 20)
            m = 0.9 * m + 0.1 * gq
            v = 0.999 * v + 0.001 * (gq * gq)
            n.qR -= lr * m / (np.sqrt(v) + 1e-8)
            np.clip(n.qR, -32, 32, out=n.qR)
            tot += loss
            tf_ok += a
            tf_n += b
        hg = eval_rows(n, held_g, decode_film)
        n_f, n_r = scores(hg)
        rec = {"ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "f": n_f, "r": n_r}
        hist.append(rec)
        print(f"FILM EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} F={n_f} R={n_r} best={best_acc:.3f}", flush=True)
        if n_f < 12:
            n.qR = best_q.copy()
            continue
        if hg["acc"] > best_acc:
            best_acc = hg["acc"]
            best_q = n.qR.copy()
        if hg["acc"] >= 0.90:
            best_q = n.qR.copy()
            break
    n.qR = best_q
    np.savez(bag / "snap_film.npz", **snapshot(n), qR=n.qR)
    hg = eval_rows(n, held_g, decode_film)
    hu = eval_rows(n, held_u, decode_film)
    n_f, n_r = scores(hg)
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "frozen_f12_r_query_bias",
        "program": "NO",
        "c4_master": False,
        "load_f": f0,
        "load_r": r0,
        "best_held_float": best_acc,
        "held_float": hg["acc"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "hall_float": hu["hall"] / hu["n"] if hu["n"] else 1.0,
        "lang_90_float": hg["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
    }
    (bag / "TRAIN_METRICS_FILM.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("best_held_float", "held_f_ok", "held_r_ok", "hall_float", "lang_90_float")}), flush=True)


if __name__ == "__main__":
    main()
