#!/usr/bin/env python3
"""Diverse local QUERY/PROOF copy corpus on rival-2 family. PROGRAM=NO.
ASTRA-C4-LM06-RED-COPYCORPUS-01. Frozen held-out still hose/drum/vent/bolt.
Does not overwrite rtl a7ng_astra_c4_lm06_red.hex. Not C4_MASTER. Not TinyGPT.
"""
from __future__ import annotations

import hashlib
import json
import string
import sys
from pathlib import Path

import numpy as np

BPTT = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-BPTT-01")
sys.path.insert(0, str(BPTT))

from train_ste import (  # noqa: E402
    EOS,
    HELD_ENT,
    TRAIN_ENT,
    Cfg,
    Net,
    adam_update,
    decode_i,
    embed_row,
    eval_rows,
    forward_step,
    make_split,
    make_unrel,
    pack_w,
    softmax,
    tf_acc,
    zeros_g,
)

BAG = Path(__file__).resolve().parent


def random_ents(n: int, rng: np.random.Generator) -> list[str]:
    banned = set(TRAIN_ENT) | set(HELD_ENT)
    letters = list(string.ascii_lowercase)
    out = []
    seen = set(banned)
    while len(out) < n:
        name = "".join(str(rng.choice(letters)) for _ in range(4))
        if name in seen:
            continue
        seen.add(name)
        out.append(name)
    return out


def train_seq(n: Net, ctx: bytes, tgt: list[int], adam) -> tuple[float, int, int]:
    toks = list(ctx[:16]) + [EOS]
    xs = np.stack([embed_row(n, t, j) for j, t in enumerate(toks)])
    loss = 0.0
    g = zeros_g(n)
    tf_ok = tf_n = 0
    seq_toks = toks[:]
    for t in tgt:
        logits, cache = forward_step(n, xs)
        pred = int(np.argmax(logits))
        tf_n += 1
        tf_ok += int(pred == t)
        p = softmax(logits)
        loss += -float(np.log(max(float(p[t]), 1e-12)))
        dlogits = p.copy()
        dlogits[t] -= 1.0
        dxs = np.zeros_like(xs)
        from train_ste import backward_step

        backward_step(n, cache, dlogits, g, dxs)
        for j, tok in enumerate(seq_toks):
            g["We"][tok] += dxs[j]
            if n.cfg.pe:
                g["Pe"][min(j, 23)] += dxs[j]
        if t == EOS:
            break
        seq_toks.append(t)
        xs = np.vstack([xs, embed_row(n, t, xs.shape[0])])
    adam_update(n, g, adam)
    return loss, tf_ok, tf_n


def run_cfg(cfg: Cfg, train, held_g, held_u) -> dict:
    rng = np.random.default_rng(11)
    net = Net(cfg, rng)
    adam = {"t": 0, "m": zeros_g(net), "v": zeros_g(net)}
    hist = []
    order = np.arange(len(train))
    py = np.random.default_rng(13)
    for ep in range(cfg.epochs):
        py.shuffle(order)
        tot = 0.0
        tf_ok = tf_n = 0
        for idx in order:
            r = train[int(idx)]
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_seq(net, r["ctx"].encode(), tgt, adam)
            tot += loss
            tf_ok += a
            tf_n += b
        if ep % 8 == 0 or ep == cfg.epochs - 1:
            tr = eval_rows(net, [x for x in train if not x["unrel"]][:80])
            hg = eval_rows(net, held_g)
            rec = {
                "ep": ep,
                "loss": tot / len(train),
                "tf": tf_ok / tf_n if tf_n else 0.0,
                "train_sub": tr["acc"],
                "held": hg["acc"],
                "held_ok": hg["ok"],
            }
            hist.append(rec)
            print(
                f"{cfg.name} EP {ep} loss={rec['loss']:.3f} tf={rec['tf']:.3f} "
                f"train80={tr['acc']:.3f} held={hg['acc']:.3f} ({hg['ok']}/{hg['n']})",
                flush=True,
            )
            if hg["acc"] >= 0.90 and tr["acc"] >= 0.90:
                break
    hg = eval_rows(net, held_g)
    hu = eval_rows(net, held_u)
    tr = eval_rows(net, [x for x in train if not x["unrel"]][:120])
    tu = eval_rows(net, [x for x in train if x["unrel"]][:48])
    safe = decode_i(net, b"F hose pump>hose", False)
    hall_rate = hu["hall"] / hu["n"] if hu["n"] else 1.0
    w = pack_w(net)
    hex_path = BAG / f"ckpt_{cfg.name}.hex"
    hex_path.write_text("\n".join(f"{(x & 0xFF):02x}" for x in w) + "\n", encoding="ascii")
    return {
        "name": cfg.name,
        "d": cfg.d,
        "f": cfg.f,
        "pe": cfg.pe,
        "n_w": cfg.n_w,
        "train_g": tr["acc"],
        "held_g": hg["acc"],
        "held_g_ok": hg["ok"],
        "held_g_n": hg["n"],
        "held_u": hu["acc"],
        "hall_rate": hall_rate,
        "train_u": tu["acc"],
        "tf_held": tf_acc(net, held_g),
        "tf_train": tf_acc(net, [x for x in train if not x["unrel"]][:80]),
        "safe_no": safe == [ord("n"), ord("o"), EOS],
        "lang_90": hg["acc"] >= 0.90,
        "lang_safe95": bool(safe == [ord("n"), ord("o"), EOS]) and hu["acc"] >= 0.95,
        "lang_hall5": hall_rate <= 0.05,
        "cloud": False,
        "tinygpt": False,
        "c4_master": False,
        "rtl_hex_unedited": True,
        "hex_sha256": hashlib.sha256(hex_path.read_bytes()).hexdigest(),
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"][:8]],
        "train_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in tr["samples"][:4]],
    }


def main():
    rng = np.random.default_rng(3)
    extra = random_ents(8, rng)
    train_ents = TRAIN_ENT + extra
    train = make_split(train_ents, "F") + make_split(train_ents, "R") + make_unrel(train_ents)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    print("train_ents", train_ents, "n_train", len(train), flush=True)
    cfgs = [
        Cfg("d4_nope", 4, 8, False, 24, 0.02),
        Cfg("d16_pe", 16, 32, True, 24, 0.01),
    ]
    all_m = []
    for cfg in cfgs:
        print(f"=== CORPUS {cfg.name} n_w={cfg.n_w} ===", flush=True)
        all_m.append(run_cfg(cfg, train, held_g, held_u))
    out = {
        "bag": "ASTRA-C4-LM06-RED-COPYCORPUS-01",
        "program": "NO",
        "c4_master": False,
        "train_ents": train_ents,
        "held_ents": HELD_ENT,
        "n_train": len(train),
        "configs": all_m,
        "any_lang_90": any(m["lang_90"] for m in all_m),
        "frozen_held": True,
    }
    (BAG / "TRAIN_METRICS.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({"any_lang_90": out["any_lang_90"], "c4_master": False}), flush=True)
    for m in all_m:
        print(
            f"CFG {m['name']} tf_train={m['tf_train']:.3f} tf_held={m['tf_held']:.3f} "
            f"train={m['train_g']:.3f} held={m['held_g']:.3f} lang90={m['lang_90']}",
            flush=True,
        )
        print("  held", m["held_samples"][:3], flush=True)


if __name__ == "__main__":
    main()
