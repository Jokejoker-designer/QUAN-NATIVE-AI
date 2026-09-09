#!/usr/bin/env python3
"""From-scratch D=32 with F/R slot attention aux. PROGRAM=NO.
Slot B (7-10) for F, slot C (12-15) for R. Keep best held. Copy-safe restore.
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


def fresh_fr(rng):
    src, dst = rname(rng), rname(rng)
    while dst == src:
        dst = rname(rng)
    if float(rng.random()) < 0.5:
        return {"ctx": pack16(f"F {dst} {src}>{dst}"), "ans": src, "unrel": False, "slot": 7}
    return {"ctx": pack16(f"R {src} {src}>{dst}"), "ans": dst, "unrel": False, "slot": 12}


def train_seq_aux(n, ctx, tgt, slot, adam, lr, aux_w: float):
    from train_float import TMAX

    toks = list(ctx[:16]) + [EOS]
    xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
    seq = toks[:]
    g = zeros_g(n)
    loss = 0.0
    tf_ok = tf_n = 0
    for step, t in enumerate(tgt):
        logits, cache = forward(n, xs)
        pred = int(np.argmax(logits))
        tf_n += 1
        tf_ok += int(pred == t)
        p = softmax(logits)
        loss += -math.log(max(float(p[t]), 1e-12))
        dlogits = p.copy()
        dlogits[t] -= 1.0
        da_extra = np.zeros(xs.shape[0], dtype=np.float64)
        j = None
        if slot is not None and step < 4:
            j = slot + step
            if 0 <= j < xs.shape[0]:
                a_j = float(cache["a"][j])
                loss += aux_w * (1.0 - a_j) ** 2
                da_extra[j] += -2.0 * aux_w * (1.0 - a_j)
        dxs = np.zeros_like(xs)
        backward(n, cache, dlogits, g, dxs)
        if j is not None and 0 <= j < xs.shape[0]:
            a = cache["a"]
            da = da_extra
            s = a * (da - np.dot(da, a))
            ddots = s / cache["scale"]
            dK = np.outer(ddots, cache["q"])
            dq = cache["K"].T @ ddots
            g["Wk"] += dK.T @ cache["xs"]
            dxs += dK @ n.Wk
            g["Wq"] += np.outer(dq, cache["x_last"])
            dxs[-1] += n.Wq.T @ dq
        for jtok, tok in enumerate(seq):
            g["We"][tok] += dxs[jtok]
            g["Pe"][min(jtok, TMAX - 1)] += dxs[jtok]
        if t == EOS:
            break
        seq.append(t)
        xs = np.vstack([xs, embed(n, t, xs.shape[0])])
    adam_update(n, g, adam, lr)
    return loss, tf_ok, tf_n


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
    bs = 128
    for ep in range(45):
        lr = 0.006 if ep < 20 else (0.002 if ep < 32 else 0.0007)
        aux_w = 4.0 if ep < 25 else 2.0
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = fresh_fr(data_rng)
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_seq_aux(n, r["ctx"].encode(), tgt, r["slot"], adam, lr, aux_w)
            tot += loss
            tf_ok += a
            tf_n += b
        hg = eval_rows(n, held_g, decode_f)
        n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
        n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
        rec = {"ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "ok": hg["ok"], "f": n_f, "r": n_r}
        hist.append(rec)
        if hg["acc"] > best_acc:
            best_acc = hg["acc"]
            best_snap = snapshot(n)
        if ep % 3 == 0 or hg["ok"] > 0 or ep == 44:
            print(
                f"AUX EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} "
                f"F={n_f} R={n_r} best={best_acc:.3f}",
                flush=True,
            )
        if hg["acc"] >= 0.90:
            best_snap = snapshot(n)
            break
    restore(n, best_snap)
    np.savez(bag / "snap_aux.npz", **best_snap)
    hg = eval_rows(n, held_g, decode_f)
    hg_i = eval_rows(n, held_g, decode_i)
    hu = eval_rows(n, held_u, decode_f)
    n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
    n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
    hall = hu["hall"] / hu["n"] if hu["n"] else 1.0
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "slot_attn_aux_fr",
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
        "unrel_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hu["samples"][:6]],
    }
    (bag / "TRAIN_METRICS_AUX.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(
        "SUMMARY",
        json.dumps(
            {
                k: out[k]
                for k in (
                    "best_held_float",
                    "held_f_ok",
                    "held_r_ok",
                    "held_int",
                    "hall_float",
                    "lang_90_float",
                )
            }
        ),
        flush=True,
    )
    print("samples", out["held_samples"][:6], flush=True)


if __name__ == "__main__":
    main()
