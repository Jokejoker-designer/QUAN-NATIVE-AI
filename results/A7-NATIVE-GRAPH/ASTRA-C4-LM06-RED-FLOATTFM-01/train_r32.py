#!/usr/bin/env python3
"""D=32 R-only from scratch. PROGRAM=NO. Pair with F-slot snap_best if R hits 8.
"""
from __future__ import annotations

import json
from pathlib import Path

import numpy as np

from train_float import (
    EOS,
    HELD_ENT,
    Net,
    decode_f,
    eval_rows,
    make_split,
    pack16,
    rname,
    train_seq,
    zeros_g,
)
from train_float_best import restore, snapshot


def r_only(rng):
    src, dst = rname(rng), rname(rng)
    while dst == src:
        dst = rname(rng)
    return {"ctx": pack16(f"R {src} {src}>{dst}"), "ans": dst}


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(13)
    n = Net(rng)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    data_rng = np.random.default_rng(21)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    best_acc = -1.0
    best_r = -1
    best_snap = snapshot(n)
    hist = []
    bs = 128
    for ep in range(30):
        lr = 0.006 if ep < 16 else 0.002
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = r_only(data_rng)
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_seq(n, r["ctx"].encode(), tgt, adam, lr)
            tot += loss
            tf_ok += a
            tf_n += b
        hg = eval_rows(n, held_g, decode_f)
        n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
        n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
        rec = {"ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "f": n_f, "r": n_r}
        hist.append(rec)
        if n_r > best_r or (n_r == best_r and hg["acc"] > best_acc):
            best_r = n_r
            best_acc = hg["acc"]
            best_snap = snapshot(n)
        print(f"R32 EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} F={n_f} R={n_r} bestR={best_r}", flush=True)
        if best_r >= 8 and n_f >= 9:
            break
    restore(n, best_snap)
    np.savez(bag / "snap_r32.npz", **best_snap)
    hg = eval_rows(n, held_g, decode_f)
    n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
    n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "d32_r_only",
        "program": "NO",
        "c4_master": False,
        "held_float": hg["acc"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "lang_90_float": hg["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
    }
    (bag / "TRAIN_METRICS_R32.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("held_float", "held_f_ok", "held_r_ok")}), flush=True)


if __name__ == "__main__":
    main()
