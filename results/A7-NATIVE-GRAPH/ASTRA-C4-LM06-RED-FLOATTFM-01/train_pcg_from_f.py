#!/usr/bin/env python3
"""PCGrad from F=9 snap, protect F>=8, try add R. PROGRAM=NO. One checkpoint.
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
)
from train_float_best import restore, snapshot
from train_pcgrad import grads_seq, pcgrad, row_f, row_r
from train_float import zeros_g


def scores(hg):
    n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
    n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
    return n_f, n_r


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(11)
    n = Net(rng)
    z = np.load(bag / "snap_best.npz")
    restore(n, {k: z[k] for k in z.files})
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    hg0 = eval_rows(n, held_g, decode_f)
    f0, r0 = scores(hg0)
    print(f"LOAD F={f0} R={r0} held={hg0['acc']:.3f}", flush=True)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    best_acc = hg0["acc"]
    best_snap = snapshot(n)
    data_rng = np.random.default_rng(33)
    hist = []
    for ep in range(28):
        tot = tf_ok = tf_n = 0
        for _ in range(64):
            cf, af = row_f(data_rng)
            cr, ar = row_r(data_rng)
            gf, lf, a0, b0 = grads_seq(n, cf.encode(), [ord(c) for c in af] + [EOS])
            gr, lr_, a1, b1 = grads_seq(n, cr.encode(), [ord(c) for c in ar] + [EOS])
            for k in gf:
                gf[k] = gf[k] * 2.5
            g = pcgrad(gf, gr)
            adam_update(n, g, adam, 0.0008)
            tot += lf + lr_
            tf_ok += a0 + a1
            tf_n += b0 + b1
        hg = eval_rows(n, held_g, decode_f)
        n_f, n_r = scores(hg)
        rec = {"ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "f": n_f, "r": n_r}
        hist.append(rec)
        print(f"PCGF EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} F={n_f} R={n_r} best={best_acc:.3f}", flush=True)
        if n_f < 8:
            restore(n, best_snap)
            continue
        if hg["acc"] > best_acc:
            best_acc = hg["acc"]
            best_snap = snapshot(n)
        if hg["acc"] >= 0.90:
            best_snap = snapshot(n)
            break
    restore(n, best_snap)
    np.savez(bag / "snap_pcg_fprotect.npz", **best_snap)
    hg = eval_rows(n, held_g, decode_f)
    hg_i = eval_rows(n, held_g, decode_i)
    hu = eval_rows(n, held_u, decode_f)
    n_f, n_r = scores(hg)
    hall = hu["hall"] / hu["n"] if hu["n"] else 1.0
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "pcgrad_from_f9_protect",
        "program": "NO",
        "c4_master": False,
        "load_f": f0,
        "load_r": r0,
        "best_held_float": best_acc,
        "held_float": hg["acc"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "held_int": hg_i["acc"],
        "hall_float": hall,
        "lang_90_float": hg["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
    }
    (bag / "TRAIN_METRICS_PCGF.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("best_held_float", "held_f_ok", "held_r_ok", "held_int", "lang_90_float")}), flush=True)


if __name__ == "__main__":
    main()
