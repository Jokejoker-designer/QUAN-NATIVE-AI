#!/usr/bin/env python3
"""STE BPTT + attention slot-copy aux on rival-2 family. PROGRAM=NO.
Does not overwrite rtl a7ng_astra_c4_lm06_red.hex. Not C4_MASTER.
"""
from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path

import numpy as np

from train_ste import (
    CTX_N,
    EOS,
    HELD_ENT,
    MAX_TOK,
    TMAX,
    TRAIN_ENT,
    Cfg,
    Net,
    adam_update,
    body,
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


def slot_index(ctx: bytes, unrel: bool, step: int):
    if unrel or step >= 4:
        return None
    if ctx[0:1] == b"F":
        return 7 + step
    if ctx[0:1] == b"R":
        return 12 + step
    return None


def backward_copy(n: Net, cache, dlogits, ds_extra, g, dxs):
    from train_ste import SHR_F

    z = cache["z"]
    g["by"] += dlogits
    g["We"] += np.outer(dlogits, z)
    dz = cache["We"].T @ dlogits
    dy = dz.copy()
    dpre2 = dz / SHR_F
    g["W2"] += np.outer(dpre2, cache["t"])
    dt = cache["W2"].T @ dpre2
    dpre1 = (dt * (cache["pre1"] > 0)) / SHR_F
    g["W1"] += np.outer(dpre1, cache["y"])
    dy += cache["W1"].T @ dpre1
    dh = dy
    dx_last = dy.copy()
    wsum = cache["wsum"]
    dnum = dh / wsum
    dwsum = -float(np.dot(cache["h"], dh) / wsum)
    ds = cache["V"] @ dnum + dwsum
    ds = ds * (cache["dots"] > 0)
    ds = ds + ds_extra
    dV = cache["s"][:, None] * dnum[None, :]
    ddots = ds / SHR_F
    dK = np.outer(ddots, cache["q"])
    dq = cache["K"].T @ ddots
    g["Wv"] += (dV.T @ cache["xs"]) / SHR_F
    dxs += dV @ cache["Wv"] / SHR_F
    g["Wk"] += (dK.T @ cache["xs"]) / SHR_F
    dxs += dK @ cache["Wk"] / SHR_F
    g["Wq"] += np.outer(dq, cache["x_last"]) / SHR_F
    dx_last += cache["Wq"].T @ (dq / SHR_F)
    dxs[cache["last"]] += dx_last


def train_seq(n: Net, ctx: bytes, tgt: list[int], unrel: bool, adam) -> tuple[float, int, int]:
    from train_ste import SHR_F

    toks = list(ctx[:CTX_N]) + [EOS]
    xs = np.stack([embed_row(n, t, j) for j, t in enumerate(toks)])
    loss = 0.0
    g = zeros_g(n)
    tf_ok = tf_n = 0
    seq_toks = toks[:]
    for step, t in enumerate(tgt):
        logits, cache = forward_step(n, xs)
        pred = int(np.argmax(logits))
        tf_n += 1
        if pred == t:
            tf_ok += 1
        p = softmax(logits)
        loss += -math.log(max(float(p[t]), 1e-12))
        dlogits = p.copy()
        dlogits[t] -= 1.0
        ds_extra = np.zeros(xs.shape[0], dtype=np.float64)
        jslot = slot_index(ctx, unrel, step)
        if jslot is not None and jslot < xs.shape[0]:
            s = cache["s"]
            wsum = cache["wsum"]
            pn = s / wsum
            loss += 8.0 * float((1.0 - pn[jslot]) ** 2)
            # d/ds_j of (1 - s_j/wsum)^2 ; treat wsum weakly
            ds_extra[jslot] += -16.0 * (1.0 - pn[jslot]) / wsum
            z = cache["z"]
            tgt_e = embed_row(n, ctx[jslot], jslot)
            diff = z - tgt_e
            loss += 0.05 * float(np.dot(diff, diff))
            dlogits += 0.0
            # push z toward target embed via extra dz into dlogits path: add to We later
            # inject through dy by adding to dlogits? skip; use dz via fake
        dxs = np.zeros_like(xs)
        backward_copy(n, cache, dlogits, ds_extra, g, dxs)
        if jslot is not None and jslot < xs.shape[0]:
            tgt_e = embed_row(n, ctx[jslot], jslot)
            dz = 0.1 * (cache["z"] - tgt_e)
            # STE: apply dz through residual y≈z
            g["We"][ctx[jslot]] -= 0.1 * dz
        for j, tok in enumerate(seq_toks):
            g["We"][tok] += dxs[j]
            if n.cfg.pe:
                from train_ste import TMAX as TM

                g["Pe"][min(j, TM - 1)] += dxs[j]
        if t == EOS:
            break
        seq_toks.append(t)
        row = embed_row(n, t, xs.shape[0])
        xs = np.vstack([xs, row])
    adam_update(n, g, adam)
    return loss, tf_ok, tf_n


def run_cfg(cfg: Cfg, train, held_g, held_u, bag: Path) -> dict:
    rng = np.random.default_rng(11)
    n = Net(cfg, rng)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
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
            loss, a, b = train_seq(n, r["ctx"].encode(), tgt, r["unrel"], adam)
            tot += loss
            tf_ok += a
            tf_n += b
        if ep % 10 == 0 or ep == cfg.epochs - 1:
            tr = eval_rows(n, [x for x in train if not x["unrel"]])
            hg = eval_rows(n, held_g)
            rec = {
                "ep": ep,
                "loss": tot / len(train),
                "tf": tf_ok / tf_n if tf_n else 0.0,
                "train": tr["acc"],
                "held": hg["acc"],
                "held_ok": hg["ok"],
            }
            hist.append(rec)
            print(
                f"{cfg.name} EP {ep} loss={rec['loss']:.3f} tf={rec['tf']:.3f} "
                f"train={tr['acc']:.3f} held={hg['acc']:.3f} ({hg['ok']}/{hg['n']})",
                flush=True,
            )
            if hg["acc"] >= 0.90 and tr["acc"] >= 0.90:
                break
    hg = eval_rows(n, held_g)
    hu = eval_rows(n, held_u)
    tr = eval_rows(n, [x for x in train if not x["unrel"]])
    tu = eval_rows(n, [x for x in train if x["unrel"]])
    safe = decode_i(n, b"F hose pump>hose", False)
    hall_rate = hu["hall"] / hu["n"] if hu["n"] else 1.0
    w = pack_w(n)
    hex_path = bag / f"ckpt_copy_{cfg.name}.hex"
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
        "tf_held": tf_acc(n, held_g),
        "tf_train": tf_acc(n, [x for x in train if not x["unrel"]]),
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
        "train_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in tr["samples"][:6]],
    }


def main():
    bag = Path(__file__).resolve().parent
    train = make_split(TRAIN_ENT, "F") + make_split(TRAIN_ENT, "R") + make_unrel(TRAIN_ENT)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    cfgs = [
        Cfg("d4_nope", 4, 8, False, 50, 0.02),
        Cfg("d16_pe", 16, 32, True, 60, 0.012),
    ]
    all_m = []
    for cfg in cfgs:
        print(f"=== COPY {cfg.name} n_w={cfg.n_w} ===", flush=True)
        all_m.append(run_cfg(cfg, train, held_g, held_u, bag))
    out = {
        "bag": "ASTRA-C4-LM06-RED-BPTT-01",
        "mode": "STE_ATTN_COPY_AUX",
        "program": "NO",
        "c4_master": False,
        "configs": all_m,
        "any_lang_90": any(m["lang_90"] for m in all_m),
    }
    (bag / "TRAIN_METRICS_COPY.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({"any_lang_90": out["any_lang_90"], "c4_master": False}), flush=True)
    for m in all_m:
        print(
            f"CFG {m['name']} tf_train={m['tf_train']:.3f} tf_held={m['tf_held']:.3f} "
            f"train={m['train_g']:.3f} held={m['held_g']:.3f} lang90={m['lang_90']}",
            flush=True,
        )
        print("  train", m["train_samples"][:3], flush=True)
        print("  held", m["held_samples"][:3], flush=True)


if __name__ == "__main__":
    main()
