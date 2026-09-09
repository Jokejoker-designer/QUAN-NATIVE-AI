#!/usr/bin/env python3
"""R-only fine-tune from saved 9/20 snap. PROGRAM=NO. Copy-safe restore.
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
    decode_i,
    eval_rows,
    make_split,
    make_unrel,
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
    return {"ctx": pack16(f"R {src} {src}>{dst}"), "ans": dst, "unrel": False}


def main():
    bag = Path(__file__).resolve().parent
    snap_path = bag / "snap_best.npz"
    z = np.load(snap_path)
    s = {k: z[k] for k in z.files}
    rng = np.random.default_rng(7)
    n = Net(rng)
    restore(n, s)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    hg0 = eval_rows(n, held_g, decode_f)
    print(f"LOAD held={hg0['acc']:.3f} ({hg0['ok']}/20)", flush=True)
    best_acc = hg0["acc"]
    best_snap = snapshot(n)
    ft_rng = np.random.default_rng(123)
    hist = []
    bs = 96
    for ep in range(25):
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = r_only(ft_rng)
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_seq(n, r["ctx"].encode(), tgt, adam, 0.00035)
            tot += loss
            tf_ok += a
            tf_n += b
        hg = eval_rows(n, held_g, decode_f)
        n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
        n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
        rec = {"ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "ok": hg["ok"], "f": n_f, "r": n_r}
        hist.append(rec)
        print(f"RONLY EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} F={n_f} R={n_r} best={best_acc:.3f}", flush=True)
        if hg["acc"] > best_acc:
            best_acc = hg["acc"]
            best_snap = snapshot(n)
        else:
            restore(n, best_snap)
        if best_acc >= 0.90:
            break
    restore(n, best_snap)
    np.savez(bag / "snap_best.npz", **best_snap)
    hg_f = eval_rows(n, held_g, decode_f)
    hg_i = eval_rows(n, held_g, decode_i)
    hu_f = eval_rows(n, held_u, decode_f)
    n_f = sum(1 for a, b, c in hg_f["samples"] if a.startswith("F") and c.startswith(b))
    n_r = sum(1 for a, b, c in hg_f["samples"] if a.startswith("R") and c.startswith(b))
    hall = hu_f["hall"] / hu_f["n"] if hu_f["n"] else 1.0
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "r_only_from_snap",
        "program": "NO",
        "c4_master": False,
        "load_held": hg0["acc"],
        "best_held_float": best_acc,
        "held_float": hg_f["acc"],
        "held_float_ok": hg_f["ok"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "held_int": hg_i["acc"],
        "hall_float": hall,
        "lang_90_float": hg_f["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg_f["samples"]],
    }
    (bag / "TRAIN_METRICS_RONLY.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("load_held", "best_held_float", "held_f_ok", "held_r_ok", "held_int", "lang_90_float")}), flush=True)


if __name__ == "__main__":
    main()
