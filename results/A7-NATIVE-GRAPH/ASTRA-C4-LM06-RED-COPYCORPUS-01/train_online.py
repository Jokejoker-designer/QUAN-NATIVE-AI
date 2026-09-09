#!/usr/bin/env python3
"""Online random QUERY/PROOF copy task. PROGRAM=NO.
No name inventory: each train row is a fresh 4-gram. Frozen held-out unchanged.
"""
from __future__ import annotations

import hashlib
import json
import string
import sys
from pathlib import Path

import numpy as np

sys.path.insert(
    0,
    r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-BPTT-01",
)

from train_ste import (  # noqa: E402
    EOS,
    HELD_ENT,
    Cfg,
    Net,
    adam_update,
    decode_i,
    embed_row,
    eval_rows,
    forward_step,
    make_split,
    make_unrel,
    pack16,
    pack_w,
    softmax,
    tf_acc,
    zeros_g,
)
from train_corpus import train_seq  # noqa: E402

BAG = Path(__file__).resolve().parent
LETTERS = list(string.ascii_lowercase)


def rname(rng: np.random.Generator) -> str:
    return "".join(str(rng.choice(LETTERS)) for _ in range(4))


def fresh_row(rng: np.random.Generator) -> dict:
    src = rname(rng)
    dst = rname(rng)
    while dst == src:
        dst = rname(rng)
    mode = int(rng.integers(0, 3))
    if mode == 0:
        return {"ctx": pack16(f"F {dst} {src}>{dst}"), "ans": src, "unrel": False}
    if mode == 1:
        return {"ctx": pack16(f"R {src} {src}>{dst}"), "ans": dst, "unrel": False}
    other = rname(rng)
    while other in (src, dst):
        other = rname(rng)
    return {"ctx": pack16(f"F {dst} {src}>{other}"), "ans": "no", "unrel": True}


def main():
    cfg = Cfg("d16_pe", 16, 32, True, 30, 0.01)
    rng_net = np.random.default_rng(11)
    net = Net(cfg, rng_net)
    adam = {"t": 0, "m": zeros_g(net), "v": zeros_g(net)}
    rng = np.random.default_rng(21)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    hist = []
    bs = 192
    for ep in range(cfg.epochs):
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = fresh_row(rng)
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_seq(net, r["ctx"].encode(), tgt, adam)
            tot += loss
            tf_ok += a
            tf_n += b
        if ep % 5 == 0 or ep == cfg.epochs - 1:
            hg = eval_rows(net, held_g)
            rec = {
                "ep": ep,
                "loss": tot / bs,
                "tf": tf_ok / tf_n if tf_n else 0.0,
                "held": hg["acc"],
                "held_ok": hg["ok"],
            }
            hist.append(rec)
            print(
                f"online EP {ep} loss={rec['loss']:.3f} tf={rec['tf']:.3f} "
                f"held={hg['acc']:.3f} ({hg['ok']}/{hg['n']})",
                flush=True,
            )
            if hg["acc"] >= 0.90:
                break
    hg = eval_rows(net, held_g)
    hu = eval_rows(net, held_u)
    safe = decode_i(net, b"F hose pump>hose", False)
    hall_rate = hu["hall"] / hu["n"] if hu["n"] else 1.0
    w = pack_w(net)
    hex_path = BAG / "ckpt_online_d16_pe.hex"
    hex_path.write_text("\n".join(f"{(x & 0xFF):02x}" for x in w) + "\n", encoding="ascii")
    out = {
        "bag": "ASTRA-C4-LM06-RED-COPYCORPUS-01",
        "mode": "online_random_4gram",
        "program": "NO",
        "c4_master": False,
        "held_g": hg["acc"],
        "held_g_ok": hg["ok"],
        "held_g_n": hg["n"],
        "held_u": hu["acc"],
        "hall_rate": hall_rate,
        "tf_held": tf_acc(net, held_g),
        "safe_no": safe == [ord("n"), ord("o"), EOS],
        "lang_90": hg["acc"] >= 0.90,
        "lang_safe95": bool(safe == [ord("n"), ord("o"), EOS]) and hu["acc"] >= 0.95,
        "lang_hall5": hall_rate <= 0.05,
        "tinygpt": False,
        "rtl_hex_unedited": True,
        "hex_sha256": hashlib.sha256(hex_path.read_bytes()).hexdigest(),
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"][:8]],
        "unrel_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hu["samples"][:4]],
    }
    (BAG / "TRAIN_METRICS_ONLINE.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("lang_90", "held_g", "tf_held", "hall_rate")}), flush=True)
    print("held", out["held_samples"][:4], flush=True)


if __name__ == "__main__":
    main()
