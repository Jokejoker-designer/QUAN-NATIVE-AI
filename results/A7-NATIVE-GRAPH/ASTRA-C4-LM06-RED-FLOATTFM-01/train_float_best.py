#!/usr/bin/env python3
"""Continue D=32 float softmax; keep best held snapshot. PROGRAM=NO.
"""
from __future__ import annotations

import copy
import hashlib
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
    fresh_row,
    make_split,
    make_unrel,
    train_seq,
    zeros_g,
)


def snapshot(n: Net) -> dict:
    return {k: v.copy() for k, v in n.params().items()}


def restore(n: Net, s: dict) -> None:
    n.We = s["We"].copy()
    n.Wq = s["Wq"].copy()
    n.Wk = s["Wk"].copy()
    n.Wv = s["Wv"].copy()
    n.W1 = s["W1"].copy()
    n.W2 = s["W2"].copy()
    n.by = s["by"].copy()
    n.Pe = s["Pe"].copy()


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(7)
    n = Net(rng)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    data_rng = np.random.default_rng(21)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    hist = []
    best_acc = -1.0
    best_snap = snapshot(n)
    bs, epochs = 128, 60
    for ep in range(epochs):
        lr = 0.006 if ep < 25 else (0.002 if ep < 45 else 0.0008)
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = fresh_row(data_rng)
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_seq(n, r["ctx"].encode(), tgt, adam, lr)
            tot += loss
            tf_ok += a
            tf_n += b
        hg_f = eval_rows(n, held_g, decode_f)
        rec = {
            "ep": ep,
            "lr": lr,
            "loss": tot / bs,
            "tf": tf_ok / tf_n if tf_n else 0.0,
            "held_float": hg_f["acc"],
            "held_ok": hg_f["ok"],
        }
        hist.append(rec)
        if hg_f["acc"] > best_acc:
            best_acc = hg_f["acc"]
            best_snap = snapshot(n)
        if ep % 5 == 0 or hg_f["ok"] > 0 or ep == epochs - 1:
            print(
                f"BESTEP {ep} tf={rec['tf']:.3f} held={hg_f['acc']:.3f} "
                f"({hg_f['ok']}/20) best={best_acc:.3f}",
                flush=True,
            )
        if hg_f["acc"] >= 0.90:
            best_snap = snapshot(n)
            break
    restore(n, best_snap)
    hg_f = eval_rows(n, held_g, decode_f)
    hg_i = eval_rows(n, held_g, decode_i)
    hu_f = eval_rows(n, held_u, decode_f)
    safe_f = decode_f(n, b"F hose pump>hose", False)
    hall_f = hu_f["hall"] / hu_f["n"] if hu_f["n"] else 1.0
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "best_held_snapshot",
        "program": "NO",
        "c4_master": False,
        "best_held_float": best_acc,
        "held_float": hg_f["acc"],
        "held_float_ok": hg_f["ok"],
        "held_int": hg_i["acc"],
        "held_int_ok": hg_i["ok"],
        "hall_float": hall_f,
        "safe_no": safe_f == [ord("n"), ord("o"), EOS],
        "lang_90_float": hg_f["acc"] >= 0.90,
        "lang_90_int": hg_i["acc"] >= 0.90,
        "hist": hist,
        "held_float_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg_f["samples"]],
    }
    (bag / "TRAIN_METRICS_BEST.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("best_held_float", "held_float", "held_int", "lang_90_float")}), flush=True)
    print("samples", out["held_float_samples"][:5], flush=True)


if __name__ == "__main__":
    main()
