#!/usr/bin/env python3
"""PCGrad on one D=32 net: F-slot and R-slot grads projected. PROGRAM=NO.
Not a two-bank mux. One checkpoint. Frozen held-out unchanged.
"""
from __future__ import annotations

import json
from pathlib import Path

import numpy as np

from train_float import (
    EOS,
    HELD_ENT,
    TMAX,
    Net,
    adam_update,
    backward,
    decode_f,
    decode_i,
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


def grads_seq(n, ctx: bytes, tgt: list[int]):
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
        loss += float(-np.log(max(float(p[t]), 1e-12)))
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


def flatten(g):
    return np.concatenate([np.ravel(g[k]) for k in sorted(g.keys())])


def unflatten(g_template, vec):
    out = {}
    i = 0
    for k in sorted(g_template.keys()):
        n = g_template[k].size
        out[k] = vec[i : i + n].reshape(g_template[k].shape)
        i += n
    return out


def pcgrad(gf, gr):
    vf = flatten(gf)
    vr = flatten(gr)
    df = float(np.dot(vf, vr))
    if df < 0:
        nf = float(np.dot(vf, vf)) + 1e-12
        nr = float(np.dot(vr, vr)) + 1e-12
        vf = vf - (df / nr) * vr
        vr = vr - (df / nf) * flatten(gr)
    return unflatten(gf, vf + vr)


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(11)
    n = Net(rng)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    data_rng = np.random.default_rng(21)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    best_acc = -1.0
    best_snap = snapshot(n)
    hist = []
    steps = 80
    for ep in range(35):
        lr = 0.005 if ep < 18 else 0.0015
        tot = tf_ok = tf_n = 0
        for _ in range(steps):
            cf, af = row_f(data_rng)
            cr, ar = row_r(data_rng)
            gf, lf, a0, b0 = grads_seq(n, cf.encode(), [ord(c) for c in af] + [EOS])
            gr, lr_, a1, b1 = grads_seq(n, cr.encode(), [ord(c) for c in ar] + [EOS])
            g = pcgrad(gf, gr)
            adam_update(n, g, adam, lr)
            tot += lf + lr_
            tf_ok += a0 + a1
            tf_n += b0 + b1
        hg = eval_rows(n, held_g, decode_f)
        n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
        n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
        rec = {"ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "ok": hg["ok"], "f": n_f, "r": n_r}
        hist.append(rec)
        if hg["acc"] > best_acc:
            best_acc = hg["acc"]
            best_snap = snapshot(n)
        print(
            f"PCG EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} F={n_f} R={n_r} best={best_acc:.3f}",
            flush=True,
        )
        if hg["acc"] >= 0.90:
            best_snap = snapshot(n)
            break
    restore(n, best_snap)
    np.savez(bag / "snap_pcgrad.npz", **best_snap)
    hg = eval_rows(n, held_g, decode_f)
    hg_i = eval_rows(n, held_g, decode_i)
    hu = eval_rows(n, held_u, decode_f)
    n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
    n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
    hall = hu["hall"] / hu["n"] if hu["n"] else 1.0
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "pcgrad_fr_one_ckpt",
        "program": "NO",
        "c4_master": False,
        "best_held_float": best_acc,
        "held_float": hg["acc"],
        "held_float_ok": hg["ok"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "held_int": hg_i["acc"],
        "hall_float": hall,
        "lang_90_float": hg["acc"] >= 0.90,
        "lang_90_int": hg_i["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
    }
    (bag / "TRAIN_METRICS_PCG.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(
        "SUMMARY",
        json.dumps({k: out[k] for k in ("best_held_float", "held_f_ok", "held_r_ok", "held_int", "hall_float", "lang_90_float")}),
        flush=True,
    )


if __name__ == "__main__":
    main()
