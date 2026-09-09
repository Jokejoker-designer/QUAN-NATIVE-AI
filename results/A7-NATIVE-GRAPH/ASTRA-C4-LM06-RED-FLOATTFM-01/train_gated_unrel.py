#!/usr/bin/env python3
"""Add unrelated-safe 'no' to gated dual-attn snap. PROGRAM=NO. Not C4_MASTER.
R attn frozen from snap_gated_b. F opcode trains copy + refuse.
"""
from __future__ import annotations

import json
from pathlib import Path

import numpy as np

from train_float import (
    EOS,
    HELD_ENT,
    Net,
    decode_i,
    eval_rows,
    make_split,
    make_unrel,
    pack16,
    rname,
)
from train_float_best import restore, snapshot
from train_gated import (
    copy_attn,
    eval_gated,
    install_attn,
    scores,
    tf_dual,
    tf_step,
    zeros_g,
)
from train_gated import row_f


def row_u(rng):
    src, dst = rname(rng), rname(rng)
    while dst == src:
        dst = rname(rng)
    other = rname(rng)
    while other in (src, dst):
        other = rname(rng)
    return pack16(f"F {dst} {src}>{other}"), "no"


def decode_gated_i(n: Net, ctx: bytes, evid: bool, f_attn, r_attn):
    if not evid:
        return [ord("n"), ord("o"), EOS]
    wq, wk, wv = r_attn if ctx[:1] == b"R" else f_attn
    saved = copy_attn(n)
    install_attn(n, wq, wk, wv)
    out = decode_i(n, ctx, evid)
    install_attn(n, *saved)
    return out


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(19)
    n = Net(rng)
    z = np.load(bag / "snap_gated_b.npz")
    restore(n, {k: z[k] for k in ("We", "Wq", "Wk", "Wv", "W1", "W2", "by", "Pe")})
    f_attn = (z["WqF"].copy(), z["WkF"].copy(), z["WvF"].copy())
    r_attn = (z["WqR"].copy(), z["WkR"].copy(), z["WvR"].copy())
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    hg0 = eval_gated(n, held_g, f_attn, r_attn)
    hu0 = eval_gated(n, held_u, f_attn, r_attn)
    f0, r0 = scores(hg0)
    print(f"U_LOAD F={f0} R={r0} held={hg0['acc']:.3f} hall={hu0['hall']}/{hu0['n']}", flush=True)
    adam_shared = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    adam_f = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    data_rng = np.random.default_rng(21)
    best = {
        "g": hg0["acc"],
        "u": 0.0,
        "hall": 1.0,
        "snap": snapshot(n),
        "f_attn": (f_attn[0].copy(), f_attn[1].copy(), f_attn[2].copy()),
        "r_attn": (r_attn[0].copy(), r_attn[1].copy(), r_attn[2].copy()),
    }
    hist = []
    freeze_shared = True
    for ep in range(36):
        if ep == 12 and best["u"] < 0.95:
            freeze_shared = False
            print("U_UNFREEZE_SHARED", flush=True)
        lr = 0.004 if ep < 18 else 0.0015
        tot = tf_ok = tf_n = 0
        for _ in range(96):
            mode = int(data_rng.integers(0, 3))
            if mode == 0:
                ctx, ans = row_u(data_rng)
            else:
                ctx, ans = row_f(data_rng)
            install_attn(n, *f_attn)
            if freeze_shared:
                loss, a, b = tf_step(n, ctx.encode(), [ord(c) for c in ans] + [EOS], adam_f, lr, True)
            else:
                loss, a, b = tf_dual(n, ctx.encode(), [ord(c) for c in ans] + [EOS], adam_shared, adam_f, lr)
            f_attn = copy_attn(n)
            tot += loss
            tf_ok += a
            tf_n += b
        install_attn(n, *f_attn)
        hg = eval_gated(n, held_g, f_attn, r_attn)
        hu = eval_gated(n, held_u, f_attn, r_attn)
        n_f, n_r = scores(hg)
        hall = hu["hall"] / hu["n"] if hu["n"] else 1.0
        rec = {
            "ep": ep,
            "tf": tf_ok / tf_n,
            "held": hg["acc"],
            "f": n_f,
            "r": n_r,
            "unrel": hu["acc"],
            "hall": hall,
            "freeze_shared": freeze_shared,
        }
        hist.append(rec)
        print(
            f"UNREL EP {ep} tf={rec['tf']:.3f} F={n_f} R={n_r} unrel={hu['acc']:.3f} hall={hall:.3f}",
            flush=True,
        )
        if n_f < 11 or n_r < 7:
            restore(n, best["snap"])
            f_attn = (best["f_attn"][0].copy(), best["f_attn"][1].copy(), best["f_attn"][2].copy())
            r_attn = (best["r_attn"][0].copy(), best["r_attn"][1].copy(), best["r_attn"][2].copy())
            continue
        better_u = hu["acc"] > best["u"] or (hu["acc"] == best["u"] and hall < best["hall"])
        if better_u and hg["acc"] >= 0.90:
            best = {
                "g": hg["acc"],
                "u": hu["acc"],
                "hall": hall,
                "snap": snapshot(n),
                "f_attn": (f_attn[0].copy(), f_attn[1].copy(), f_attn[2].copy()),
                "r_attn": (r_attn[0].copy(), r_attn[1].copy(), r_attn[2].copy()),
            }
        if hg["acc"] >= 0.90 and hu["acc"] >= 0.95 and hall <= 0.05:
            break
    restore(n, best["snap"])
    f_attn, r_attn = best["f_attn"], best["r_attn"]
    hg = eval_gated(n, held_g, f_attn, r_attn)
    hu = eval_gated(n, held_u, f_attn, r_attn)
    n_f, n_r = scores(hg)
    hall = hu["hall"] / hu["n"] if hu["n"] else 1.0

    def fn_i(net, ctx, evid):
        return decode_gated_i(net, ctx, evid, f_attn, r_attn)

    hg_i = eval_rows(n, held_g, fn_i)
    hu_i = eval_rows(n, held_u, fn_i)
    np.savez(
        bag / "snap_gated_unrel.npz",
        **snapshot(n),
        WqF=f_attn[0],
        WkF=f_attn[1],
        WvF=f_attn[2],
        WqR=r_attn[0],
        WkR=r_attn[1],
        WvR=r_attn[2],
    )
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "mode": "gated_dual_attn_unrel",
        "program": "NO",
        "c4_master": False,
        "two_ckpt_mux": False,
        "load_f": f0,
        "load_r": r0,
        "held_float": hg["acc"],
        "held_f_ok": n_f,
        "held_r_ok": n_r,
        "unrel_float": hu["acc"],
        "hall_float": hall,
        "lang_90_95_5_float": hg["acc"] >= 0.90 and hu["acc"] >= 0.95 and hall <= 0.05,
        "held_int": hg_i["acc"],
        "unrel_int": hu_i["acc"],
        "hall_int": hu_i["hall"] / hu_i["n"] if hu_i["n"] else 1.0,
        "lang_90_95_5_int": hg_i["acc"] >= 0.90 and hu_i["acc"] >= 0.95 and (hu_i["hall"] / hu_i["n"] if hu_i["n"] else 1.0) <= 0.05,
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"]],
        "unrel_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hu["samples"]],
    }
    (bag / "TRAIN_METRICS_GATED_UNREL.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(
        "SUMMARY",
        json.dumps(
            {
                "held_f": n_f,
                "held_r": n_r,
                "unrel": hu["acc"],
                "hall": hall,
                "float_90_95_5": out["lang_90_95_5_float"],
                "int_90_95_5": out["lang_90_95_5_int"],
                "held_int": hg_i["acc"],
            }
        ),
        flush=True,
    )


if __name__ == "__main__":
    main()
