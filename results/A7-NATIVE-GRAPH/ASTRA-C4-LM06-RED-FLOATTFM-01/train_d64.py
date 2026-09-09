#!/usr/bin/env python3
"""D=64 same-family scale, balanced F/R, keep best held. PROGRAM=NO.
"""
from __future__ import annotations

import json
from pathlib import Path

import numpy as np

import train_float as tf
from train_float_best import restore, snapshot

tf.D = 64
tf.F = 128


def fresh_fr(rng):
    src, dst = tf.rname(rng), tf.rname(rng)
    while dst == src:
        dst = tf.rname(rng)
    if float(rng.random()) < 0.5:
        return {"ctx": tf.pack16(f"F {dst} {src}>{dst}"), "ans": src}
    return {"ctx": tf.pack16(f"R {src} {src}>{dst}"), "ans": dst}


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(11)
    n = tf.Net(rng)
    adam = {"t": 0, "m": tf.zeros_g(n), "v": tf.zeros_g(n)}
    data_rng = np.random.default_rng(21)
    held_g = (tf.make_split(tf.HELD_ENT, "F") + tf.make_split(tf.HELD_ENT, "R"))[:20]
    best_acc = -1.0
    best_snap = snapshot(n)
    hist = []
    bs = 96
    for ep in range(40):
        lr = 0.005 if ep < 18 else 0.0015
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = fresh_fr(data_rng)
            tgt = [ord(c) for c in r["ans"]] + [tf.EOS]
            loss, a, b = tf.train_seq(n, r["ctx"].encode(), tgt, adam, lr)
            tot += loss
            tf_ok += a
            tf_n += b
        hg = tf.eval_rows(n, held_g, tf.decode_f)
        n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
        n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
        rec = {"ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "ok": hg["ok"], "f": n_f, "r": n_r}
        hist.append(rec)
        if hg["acc"] > best_acc:
            best_acc = hg["acc"]
            best_snap = snapshot(n)
        if ep % 4 == 0 or hg["ok"] > 0 or ep == 39:
            print(f"D64 EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} F={n_f} R={n_r} best={best_acc:.3f}", flush=True)
        if hg["acc"] >= 0.90:
            best_snap = snapshot(n)
            break
    restore(n, best_snap)
    np.savez(bag / "snap_d64.npz", **best_snap)
    hg = tf.eval_rows(n, held_g, tf.decode_f)
    hg_i = tf.eval_rows(n, held_g, tf.decode_i)
    n_f = sum(1 for a, b, c in hg["samples"] if a.startswith("F") and c.startswith(b))
    n_r = sum(1 for a, b, c in hg["samples"] if a.startswith("R") and c.startswith(b))
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "d64_balanced",
        "d": 64,
        "program": "NO",
        "c4_master": False,
        "best_held_float": best_acc,
        "held_float": hg["acc"],
        "held_float_ok": hg["ok"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "held_int": hg_i["acc"],
        "lang_90_float": hg["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
    }
    (bag / "TRAIN_METRICS_D64.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("best_held_float", "held_f_ok", "held_r_ok", "held_int", "lang_90_float")}), flush=True)


if __name__ == "__main__":
    main()
