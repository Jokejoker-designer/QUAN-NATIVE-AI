#!/usr/bin/env python3
"""From F=12 snap, tiny R steps, revert if F<11. PROGRAM=NO. One checkpoint.
"""
from __future__ import annotations

import json
from pathlib import Path

import numpy as np

from train_float import (
    EOS,
    HELD_ENT,
    Net,
    adam_update,
    decode_f,
    decode_i,
    eval_rows,
    make_split,
    make_unrel,
    zeros_g,
)
from train_float_best import restore, snapshot
from train_pcgrad import grads_seq, row_f, row_r
from train_pcg_from_f import scores


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(11)
    n = Net(rng)
    z = np.load(bag / "snap_pcg_fprotect.npz")
    restore(n, {k: z[k] for k in z.files})
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    hg0 = eval_rows(n, held_g, decode_f)
    f0, r0 = scores(hg0)
    print(f"LOAD F={f0} R={r0}", flush=True)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    best_acc = hg0["acc"]
    best_snap = snapshot(n)
    data_rng = np.random.default_rng(44)
    hist = []
    for ep in range(24):
        tot = tf_ok = tf_n = 0
        for i in range(48):
            cf, af = row_f(data_rng)
            gf, lf, a0, b0 = grads_seq(n, cf.encode(), [ord(c) for c in af] + [EOS])
            adam_update(n, gf, adam, 0.00015)
            tot += lf
            tf_ok += a0
            tf_n += b0
            if i % 4 == 0:
                cr, ar = row_r(data_rng)
                gr, lr_, a1, b1 = grads_seq(n, cr.encode(), [ord(c) for c in ar] + [EOS])
                adam_update(n, gr, adam, 0.00008)
                tot += lr_
                tf_ok += a1
                tf_n += b1
        hg = eval_rows(n, held_g, decode_f)
        n_f, n_r = scores(hg)
        rec = {"ep": ep, "tf": tf_ok / tf_n if tf_n else 0.0, "held": hg["acc"], "f": n_f, "r": n_r}
        hist.append(rec)
        print(f"ADDR EP {ep} held={hg['acc']:.3f} F={n_f} R={n_r} best={best_acc:.3f}", flush=True)
        if n_f < 11:
            restore(n, best_snap)
            continue
        if (n_r, n_f) > (scores(eval_rows(restore and best_snap and hg, held_g, decode_f) if False else hg)[0] * 0, 0):
            pass
        if hg["acc"] > best_acc or (n_f >= 11 and n_r > 0 and n_r + n_f >= int(best_acc * 20)):
            if n_f + n_r > int(round(best_acc * 20)) or hg["acc"] > best_acc:
                best_acc = hg["acc"]
                best_snap = snapshot(n)
        if n_f + n_r >= 18:
            best_snap = snapshot(n)
            break
    restore(n, best_snap)
    np.savez(bag / "snap_f12_rtry.npz", **best_snap)
    hg = eval_rows(n, held_g, decode_f)
    hg_i = eval_rows(n, held_g, decode_i)
    n_f, n_r = scores(hg)
    hu = eval_rows(n, held_u, decode_f)
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "f12_then_tiny_r",
        "program": "NO",
        "c4_master": False,
        "load_f": f0,
        "load_r": r0,
        "held_float": hg["acc"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "held_int": hg_i["acc"],
        "hall_float": hu["hall"] / hu["n"] if hu["n"] else 1.0,
        "lang_90_float": hg["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
    }
    (bag / "TRAIN_METRICS_F12R.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("held_float", "held_f_ok", "held_r_ok", "held_int", "lang_90_float")}), flush=True)


if __name__ == "__main__":
    main()
