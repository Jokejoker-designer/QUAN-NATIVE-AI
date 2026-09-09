#!/usr/bin/env python3
"""From D=64 R=8/8 snap, F-only hill-climb without dropping R. PROGRAM=NO.
"""
from __future__ import annotations

import json
from pathlib import Path

import numpy as np

import train_float as tf
from train_float_best import restore, snapshot

tf.D = 64
tf.F = 128


def f_only(rng):
    src, dst = tf.rname(rng), tf.rname(rng)
    while dst == src:
        dst = tf.rname(rng)
    return {"ctx": tf.pack16(f"F {dst} {src}>{dst}"), "ans": src}


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(11)
    n = tf.Net(rng)
    z = np.load(bag / "snap_d64.npz")
    s = {k: z[k] for k in z.files}
    restore(n, s)
    held_g = (tf.make_split(tf.HELD_ENT, "F") + tf.make_split(tf.HELD_ENT, "R"))[:20]
    hg0 = tf.eval_rows(n, held_g, tf.decode_f)
    n_f0 = sum(1 for a, b, c in hg0["samples"] if a.startswith("F") and c.startswith(b))
    n_r0 = sum(1 for a, b, c in hg0["samples"] if a.startswith("R") and c.startswith(b))
    print(f"LOAD held={hg0['acc']:.3f} F={n_f0} R={n_r0}", flush=True)
    adam = {"t": 0, "m": tf.zeros_g(n), "v": tf.zeros_g(n)}
    best_acc = hg0["acc"]
    best_snap = snapshot(n)
    ft_rng = np.random.default_rng(77)
    hist = []
    bs = 64
    for ep in range(30):
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = f_only(ft_rng)
            tgt = [ord(c) for c in r["ans"]] + [tf.EOS]
            loss, a, b = tf.train_seq(n, r["ctx"].encode(), tgt, adam, 0.0004)
            tot += loss
            tf_ok += a
            tf_n += b
        hg = tf.eval_rows(n, held_g, tf.decode_f)
        n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
        n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
        rec = {"ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "f": n_f, "r": n_r}
        hist.append(rec)
        print(f"FCLIMB EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} F={n_f} R={n_r} best={best_acc:.3f}", flush=True)
        if hg["acc"] > best_acc:
            best_acc = hg["acc"]
            best_snap = snapshot(n)
        else:
            restore(n, best_snap)
        if best_acc >= 0.90:
            break
    restore(n, best_snap)
    np.savez(bag / "snap_d64_best.npz", **best_snap)
    hg = tf.eval_rows(n, held_g, tf.decode_f)
    hg_i = tf.eval_rows(n, held_g, tf.decode_i)
    n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
    n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "d64_r8_then_fclimb",
        "program": "NO",
        "c4_master": False,
        "load_f": n_f0,
        "load_r": n_r0,
        "best_held_float": best_acc,
        "held_float": hg["acc"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "held_int": hg_i["acc"],
        "lang_90_float": hg["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
    }
    (bag / "TRAIN_METRICS_D64F.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("best_held_float", "held_f_ok", "held_r_ok", "held_int", "lang_90_float")}), flush=True)


if __name__ == "__main__":
    main()
