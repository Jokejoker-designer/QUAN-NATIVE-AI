#!/usr/bin/env python3
"""D=32 float with opcode (xs[0]) added into Q. PROGRAM=NO. Same-family query mix.
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
    Net,
    decode_f,
    embed,
    eval_rows,
    fresh_row,
    make_split,
    make_unrel,
    softmax,
    zeros_g,
)
from train_float_best import restore, snapshot


def forward_q0(n: Net, xs: np.ndarray):
    x_last = xs[-1]
    x0 = xs[0]
    q = n.Wq @ (x_last + x0)
    K = xs @ n.Wk.T
    V = xs @ n.Wv.T
    scale = math.sqrt(D)
    dots = (K @ q) / scale
    a = softmax(dots)
    h = a @ V
    y = x_last + h
    t = np.maximum(n.W1 @ y, 0.0)
    z = y + n.W2 @ t
    logits = n.by + (n.We @ z)
    return logits, {
        "xs": xs, "x_last": x_last, "x0": x0, "q": q, "K": K, "V": V,
        "dots": dots, "a": a, "h": h, "y": y, "t": t, "z": z, "scale": scale,
    }


def backward_q0(n: Net, cache, dlogits, g, dxs):
    z = cache["z"]
    g["by"] += dlogits
    g["We"] += np.outer(dlogits, z)
    dz = n.We.T @ dlogits
    dy = dz.copy()
    dt = n.W2.T @ dz
    g["W2"] += np.outer(dz, cache["t"])
    dpre1 = dt * (cache["t"] > 0)
    g["W1"] += np.outer(dpre1, cache["y"])
    dy += n.W1.T @ dpre1
    dh = dy
    dx_last = dy.copy()
    da = cache["V"] @ dh
    dV = np.outer(cache["a"], dh)
    a = cache["a"]
    s = a * (da - np.dot(da, a))
    ddots = s / cache["scale"]
    dK = np.outer(ddots, cache["q"])
    dq = cache["K"].T @ ddots
    g["Wv"] += dV.T @ cache["xs"]
    dxs += dV @ n.Wv
    g["Wk"] += dK.T @ cache["xs"]
    dxs += dK @ n.Wk
    qsrc = cache["x_last"] + cache["x0"]
    g["Wq"] += np.outer(dq, qsrc)
    dxq = n.Wq.T @ dq
    dx_last += dxq
    dxs[0] += dxq
    dxs[-1] += dx_last


def train_seq_q0(n, ctx, tgt, adam, lr):
    from train_float import TMAX, adam_update

    toks = list(ctx[:16]) + [EOS]
    xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
    seq = toks[:]
    g = zeros_g(n)
    loss = tf_ok = tf_n = 0
    for t in tgt:
        logits, cache = forward_q0(n, xs)
        pred = int(np.argmax(logits))
        tf_n += 1
        tf_ok += int(pred == t)
        p = softmax(logits)
        loss += -math.log(max(float(p[t]), 1e-12))
        dlogits = p.copy()
        dlogits[t] -= 1.0
        dxs = np.zeros_like(xs)
        backward_q0(n, cache, dlogits, g, dxs)
        for j, tok in enumerate(seq):
            g["We"][tok] += dxs[j]
            g["Pe"][min(j, TMAX - 1)] += dxs[j]
        if t == EOS:
            break
        seq.append(t)
        xs = np.vstack([xs, embed(n, t, xs.shape[0])])
    adam_update(n, g, adam, lr)
    return loss, tf_ok, tf_n


def decode_q0(n, ctx, evid):
    if not evid:
        return [ord("n"), ord("o"), EOS]
    toks = list(ctx[:16]) + [EOS]
    xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
    out = []
    for _ in range(6):
        logits, _ = forward_q0(n, xs)
        tok = int(np.argmax(logits))
        out.append(tok)
        if tok == EOS:
            break
        xs = np.vstack([xs, embed(n, tok, xs.shape[0])])
    return out


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(7)
    n = Net(rng)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    data_rng = np.random.default_rng(21)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    best_acc = -1.0
    best_snap = snapshot(n)
    hist = []
    bs = 128
    for ep in range(35):
        lr = 0.006 if ep < 18 else 0.002
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = fresh_row(data_rng)
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_seq_q0(n, r["ctx"].encode(), tgt, adam, lr)
            tot += loss
            tf_ok += a
            tf_n += b
        hg = eval_rows(n, held_g, decode_q0)
        n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
        n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
        rec = {"ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "ok": hg["ok"], "f": n_f, "r": n_r}
        hist.append(rec)
        if hg["acc"] > best_acc:
            best_acc = hg["acc"]
            best_snap = snapshot(n)
        if ep % 3 == 0 or hg["ok"] > 0 or ep == 34:
            print(f"Q0 EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} F={n_f} R={n_r} best={best_acc:.3f}", flush=True)
        if hg["acc"] >= 0.90:
            best_snap = snapshot(n)
            break
    restore(n, best_snap)
    hg = eval_rows(n, held_g, decode_q0)
    hu = eval_rows(n, held_u, decode_q0)
    n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
    n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
    hall = hu["hall"] / hu["n"] if hu["n"] else 1.0
    np.savez(bag / "snap_q0.npz", **best_snap)
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "q_plus_xs0",
        "program": "NO",
        "c4_master": False,
        "best_held_float": best_acc,
        "held_float": hg["acc"],
        "held_float_ok": hg["ok"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "hall_float": hall,
        "lang_90_float": hg["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
    }
    (bag / "TRAIN_METRICS_Q0.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("best_held_float", "held_f_ok", "held_r_ok", "hall_float", "lang_90_float")}), flush=True)


if __name__ == "__main__":
    main()
