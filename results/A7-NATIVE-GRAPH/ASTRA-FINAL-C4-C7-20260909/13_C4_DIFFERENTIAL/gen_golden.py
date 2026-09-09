#!/usr/bin/env python3
"""Emit GOLDEN.svh from frozen IntegerModel BEFORE xvlog."""
from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, r"D:\FPGA\C4_RESCUE_20260909")
from quantize_c4_parity import IntegerModel, load_model
from train_c4_balance_90 import historic_rows

CKPT = Path(r"D:\FPGA\C4_RESCUE_20260909\EXPERIMENTS\F_COPY_BALANCED_01\runs\fr_balanced_01\best_dev.npz")
MAN = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-FINAL-C4-C7-20260909\10_C4_MODEL_FREEZE\ptq_fcopy_w8a12\quant_manifest.json")
OUT = Path(__file__).resolve().parent / "GOLDEN.svh"
JSON_OUT = Path(__file__).resolve().parent / "GOLDEN.json"


def fmt_ctx(s):
    b = list(s.encode("ascii"))
    assert len(b) == 16
    return ", ".join(f"8'd{x}" for x in b)


def fmt_tok(ts):
    pad = list(ts) + [0] * 8
    return ", ".join(f"8'd{int(x)}" for x in pad[:8])


def main():
    m = load_model(CKPT)
    man = json.loads(MAN.read_text(encoding="utf-8"))
    im = IntegerModel(m, man["activation_scales"], int(man["activation_bits"]))
    cases = []
    for r in historic_rows():
        if r["group"] not in ("F", "R"):
            continue
        ctx = list(r["ctx"].encode())
        tok = im.decode(ctx)
        cases.append(dict(name=r["ctx"], ctx=r["ctx"], group=r["group"], allowed=1, zero=0, tokens=tok, kind="supported"))
    # replaced source on first F
    f0 = next(r for r in historic_rows() if r["group"] == "F")
    old = f0["ctx"][7:11]
    new = old[1:] + old[0]
    ctx_r = f0["ctx"][:7] + new + f0["ctx"][11:]
    tok_r = im.decode(list(ctx_r.encode()))
    cases.append(dict(name="replaced_src", ctx=ctx_r, group="F", allowed=1, zero=0, tokens=tok_r, kind="replaced"))
    cases.append(dict(name="safe", ctx=f0["ctx"], group="U", allowed=0, zero=0, tokens=[ord("n"), ord("o"), 0], kind="safe"))
    cases.append(dict(name="zero_w", ctx=f0["ctx"], group="F", allowed=1, zero=1, tokens=[0], kind="zero"))
    n = len(cases)
    lines = [
        "`ifndef A7NG_C4D32_GOLDEN_SVH",
        "`define A7NG_C4D32_GOLDEN_SVH",
        f"localparam int A7NG_C4D32_NCASE = {n};",
        "localparam logic [7:0] A7NG_C4D32_GCTX [0:A7NG_C4D32_NCASE-1][0:15] = '{",
    ]
    for i, c in enumerate(cases):
        comma = "," if i + 1 < n else ""
        lines.append(f"  '{{{fmt_ctx(c['ctx'])}}}{comma}  // {c['name']}")
    lines.append("};")
    lines.append("localparam logic [7:0] A7NG_C4D32_GTOK [0:A7NG_C4D32_NCASE-1][0:7] = '{")
    for i, c in enumerate(cases):
        comma = "," if i + 1 < n else ""
        lines.append(f"  '{{{fmt_tok(c['tokens'])}}}{comma}")
    lines.append("};")
    ns = ", ".join(str(len(c["tokens"])) for c in cases)
    al = ", ".join(str(c["allowed"]) for c in cases)
    zw = ", ".join(str(c["zero"]) for c in cases)
    lines += [
        f"localparam int A7NG_C4D32_GN [0:A7NG_C4D32_NCASE-1] = '{{{ns}}};",
        f"localparam bit A7NG_C4D32_GALLOW [0:A7NG_C4D32_NCASE-1] = '{{{al}}};",
        f"localparam bit A7NG_C4D32_GZERO [0:A7NG_C4D32_NCASE-1] = '{{{zw}}};",
        "`endif",
        "",
    ]
    OUT.write_text("\n".join(lines), encoding="ascii")
    JSON_OUT.write_text(json.dumps(dict(checkpoint=str(CKPT), manifest=str(MAN), cases=[{**c, "tokens": [int(t) for t in c["tokens"]]} for c in cases]), indent=2), encoding="utf-8")
    print("WROTE", OUT, "n", n)


if __name__ == "__main__":
    main()
