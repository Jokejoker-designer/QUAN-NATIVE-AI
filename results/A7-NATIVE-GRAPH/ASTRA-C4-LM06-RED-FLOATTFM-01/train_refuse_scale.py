#!/usr/bin/env python3
"""Copy-logit vs refuse-bias margin on We-identity gate. PROGRAM=NO. Not C4_MASTER."""
from __future__ import annotations

import json
from pathlib import Path

import numpy as np

from train_float import EOS, HELD_ENT, make_split, make_unrel
from train_refuse_probe import decode_bias, load_gated, metrics


def main():
    bag = Path(__file__).resolve().parent
    n, f_attn, r_attn = load_gated(bag)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    rows = []
    for scale in (8, 16, 32, 48, 64, 96, 128):
        b_no = np.zeros(256, dtype=np.float64)
        b_no[ord("n")] = scale
        b_no[ord("o")] = scale
        b_no[EOS] = scale / 2
        fn = lambda net, ctx, evid, s=scale, b=b_no: decode_bias(
            net, ctx, evid, f_attn, r_attn, "we", 32.0, -1.0, b
        )
        rec = metrics(n, held_g, held_u, fn)
        row = {"scale": scale, "f": rec["f"], "r": rec["r"], "unrel": rec["unrel"], "hall": rec["hall"], "hit": rec["lang_90_95_5"]}
        rows.append(row)
        print("SCALE", row, flush=True)
    prev = json.loads((bag / "TRAIN_METRICS_REFUSE.json").read_text(encoding="utf-8"))
    prev["we_identity_bias_scale"] = rows
    prev["c4_master"] = False
    (bag / "TRAIN_METRICS_REFUSE.json").write_text(json.dumps(prev, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
