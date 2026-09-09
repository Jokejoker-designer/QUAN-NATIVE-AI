#!/usr/bin/env python3
"""Replay ep16 9/20 snapshot then low-lr F/R fine-tune. PROGRAM=NO.
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
    fresh_row,
    make_split,
    make_unrel,
    pack16,
    rname,
    train_seq,
    zeros_g,
)
from train_float_best import restore, snapshot


def fresh_fr(rng):
    src, dst = rname(rng), rname(rng)
    while dst == src:
        dst = rname(rng)
    u = float(rng.random())
    if u < 0.42:
        return {"ctx": pack16(f"F {dst} {src}>{dst}"), "ans": src, "unrel": False}
    if u < 0.84:
        return {"ctx": pack16(f"R {src} {src}>{dst}"), "ans": dst, "unrel": False}
    other = rname(rng)
    while other in (src, dst):
        other = rname(rng)
    return {"ctx": pack16(f"F {dst} {src}>{other}"), "ans": "no", "unrel": True}


def save_npz(path: Path, s: dict) -> None:
    np.savez(path, **s)


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(7)
    n = Net(rng)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    data_rng = np.random.default_rng(21)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    bs = 128
    best_acc = -1.0
    best_snap = snapshot(n)
    hist = []
    # Phase A: replay train_float_best ep 0-16
    for ep in range(17):
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = fresh_row(data_rng)
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_seq(n, r["ctx"].encode(), tgt, adam, 0.006)
            tot += loss
            tf_ok += a
            tf_n += b
        hg = eval_rows(n, held_g, decode_f)
        rec = {"phase": "A", "ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "ok": hg["ok"]}
        hist.append(rec)
        if hg["acc"] >= best_acc:
            best_acc = hg["acc"]
            best_snap = snapshot(n)
        print(f"A EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} ({hg['ok']}/20) best={best_acc:.3f}", flush=True)
    save_npz(bag / "snap_phaseA.npz", best_snap)
    restore(n, best_snap)
    # Phase B: balanced F/R, low lr, keep best (do not keep regressions)
    ft_rng = np.random.default_rng(99)
    for ep in range(40):
        lr = 0.0005 if ep < 20 else 0.0002
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = fresh_fr(ft_rng)
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_seq(n, r["ctx"].encode(), tgt, adam, lr)
            tot += loss
            tf_ok += a
            tf_n += b
        hg = eval_rows(n, held_g, decode_f)
        rec = {"phase": "B", "ep": ep, "tf": tf_ok / tf_n, "held": hg["acc"], "ok": hg["ok"]}
        hist.append(rec)
        if hg["acc"] > best_acc:
            best_acc = hg["acc"]
            best_snap = snapshot(n)
        else:
            restore(n, best_snap)
        print(
            f"B EP {ep} tf={rec['tf']:.3f} held={hg['acc']:.3f} ({hg['ok']}/20) best={best_acc:.3f}",
            flush=True,
        )
        if best_acc >= 0.90:
            break
    restore(n, best_snap)
    save_npz(bag / "snap_best.npz", best_snap)
    hg_f = eval_rows(n, held_g, decode_f)
    hg_i = eval_rows(n, held_g, decode_i)
    hu_f = eval_rows(n, held_u, decode_f)
    n_f = sum(1 for a, b, c in hg_f["samples"] if a.startswith("F") and c.startswith(b))
    n_r = sum(1 for a, b, c in hg_f["samples"] if a.startswith("R") and c.startswith(b))
    hall = hu_f["hall"] / hu_f["n"] if hu_f["n"] else 1.0
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "phaseA_replay_plus_finetune",
        "program": "NO",
        "c4_master": False,
        "best_held_float": best_acc,
        "held_float": hg_f["acc"],
        "held_float_ok": hg_f["ok"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "held_int": hg_i["acc"],
        "hall_float": hall,
        "lang_90_float": hg_f["acc"] >= 0.90,
        "lang_90_int": hg_i["acc"] >= 0.90,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg_f["samples"]],
        "unrel_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hu_f["samples"][:8]],
    }
    (bag / "TRAIN_METRICS_FT.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(
        "SUMMARY",
        json.dumps(
            {k: out[k] for k in ("best_held_float", "held_float", "held_f_ok", "held_r_ok", "held_int", "hall_float", "lang_90_float")}
        ),
        flush=True,
    )


if __name__ == "__main__":
    main()
