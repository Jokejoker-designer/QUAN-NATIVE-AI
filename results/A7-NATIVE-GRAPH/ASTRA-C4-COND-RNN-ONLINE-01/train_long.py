#!/usr/bin/env python3
"""Longer online Elman H=32 STE. PROGRAM=NO. ASTRA-C4-COND-RNN-ONLINE-01.
Does not edit KEEP Elman DUT. Not C4_MASTER.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np

from train_online_elman import (
    EOS,
    HELD_ENT,
    N_W,
    Net,
    decode_i,
    eval_rows,
    fresh_row,
    make_split,
    make_unrel,
    pack_w,
    train_one,
)


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(11)
    m = Net(rng)
    data_rng = np.random.default_rng(21)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    hist = []
    bs, epochs = 256, 80
    for ep in range(epochs):
        lr = 0.04 if ep < 30 else (0.02 if ep < 55 else 0.01)
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = fresh_row(data_rng)
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_one(m, r["ctx"].encode(), tgt, lr)
            tot += loss
            tf_ok += a
            tf_n += b
        if ep % 8 == 0 or ep == epochs - 1:
            hg = eval_rows(m, held_g)
            rec = {
                "ep": ep,
                "lr": lr,
                "loss": tot / bs,
                "tf": tf_ok / tf_n if tf_n else 0.0,
                "held": hg["acc"],
                "held_ok": hg["ok"],
            }
            hist.append(rec)
            print(
                f"LONG EP {ep} lr={lr} loss={rec['loss']:.3f} tf={rec['tf']:.3f} "
                f"held={hg['acc']:.3f} ({hg['ok']}/{hg['n']})",
                flush=True,
            )
            if hg["acc"] >= 0.90:
                break
    hg = eval_rows(m, held_g)
    hu = eval_rows(m, held_u)
    safe = decode_i(m, b"F hose pump>hose", False)
    hall_rate = hu["hall"] / hu["n"] if hu["n"] else 1.0
    w = pack_w(m)
    hex_path = bag / "ckpt_elman_h32_online_long.hex"
    hex_path.write_text("\n".join(f"{(x & 0xFF):02x}" for x in w) + "\n", encoding="ascii")
    out = {
        "bag": "ASTRA-C4-COND-RNN-ONLINE-01",
        "mode": "long_80x256",
        "n_w": N_W,
        "program": "NO",
        "c4_master": False,
        "held_g": hg["acc"],
        "held_g_ok": hg["ok"],
        "held_g_n": hg["n"],
        "held_u": hu["acc"],
        "hall_rate": hall_rate,
        "safe_no": safe == [ord("n"), ord("o"), EOS],
        "lang_90": hg["acc"] >= 0.90,
        "lang_safe95": bool(safe == [ord("n"), ord("o"), EOS]) and hu["acc"] >= 0.95,
        "lang_hall5": hall_rate <= 0.05,
        "keep_elman_unedited": True,
        "hex_sha256": hashlib.sha256(hex_path.read_bytes()).hexdigest(),
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"][:8]],
    }
    (bag / "TRAIN_METRICS_LONG.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("lang_90", "held_g", "hall_rate")}), flush=True)
    print("held", out["held_samples"][:4], flush=True)
    if hist:
        print("tf_last", hist[-1]["tf"], "tf_max", max(h["tf"] for h in hist), flush=True)


if __name__ == "__main__":
    main()
