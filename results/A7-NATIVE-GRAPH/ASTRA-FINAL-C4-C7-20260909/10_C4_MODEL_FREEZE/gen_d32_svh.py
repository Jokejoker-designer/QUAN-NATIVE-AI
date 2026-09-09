#!/usr/bin/env python3
"""Emit a7ng_astra_c4_lm06_d32_fr_v1.svh from frozen numerical contract."""
from __future__ import annotations

import json
from pathlib import Path

CONTRACT = Path(__file__).resolve().parent / "C4_D32_NUMERICAL_CONTRACT_V1.json"
OUT = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\rtl\native_graph\integrate\a7ng_astra_c4_lm06_d32_fr_v1.svh")


def main():
    c = json.loads(CONTRACT.read_text(encoding="utf-8"))
    q = c["quantization"]
    rq = q["requant"]
    lines = [
        "`ifndef A7NG_ASTRA_C4_LM06_D32_FR_V1_SVH",
        "`define A7NG_ASTRA_C4_LM06_D32_FR_V1_SVH",
        "// Generated from C4_D32_NUMERICAL_CONTRACT_V1. Do not hand-edit scales.",
        "// PROGRAM=NO. Not C4_MASTER. Not BOARD_PASS.",
        f"localparam int unsigned A7NG_C4D32_V          = {c['vocab_size']};",
        f"localparam int unsigned A7NG_C4D32_D          = {c['D']};",
        f"localparam int unsigned A7NG_C4D32_F          = {c['F']};",
        f"localparam int unsigned A7NG_C4D32_CTX        = {c['context_length']};",
        f"localparam int unsigned A7NG_C4D32_MAX_TOK    = {c['max_generation_length']};",
        f"localparam int unsigned A7NG_C4D32_TMAX       = {c['position_table_length']};",
        f"localparam int unsigned A7NG_C4D32_ABITS      = {q['activation_bits']};",
        "localparam int unsigned A7NG_C4D32_ALIM       = (1<<(A7NG_C4D32_ABITS-1))-1;",
        "localparam int unsigned A7NG_C4D32_LUT_N      = 4097;",
        "localparam logic [7:0]  A7NG_C4D32_EOS        = 8'd0;",
        "localparam logic [7:0]  A7NG_C4D32_CH_N       = 8'h6E;",
        "localparam logic [7:0]  A7NG_C4D32_CH_O       = 8'h6F;",
        "localparam logic [7:0]  A7NG_C4D32_OP_R       = 8'd82;",
        "localparam logic [3:0]  A7NG_C4D32_VOCAB_VER  = 4'd3;",
    ]
    for name, spec in rq.items():
        key = name.upper().replace("R", "R")
        ident = "A7NG_C4D32_RQ_" + name.upper()
        lines.append(f"localparam int unsigned {ident}_MUL = {spec['multiplier']};")
        lines.append(f"localparam int unsigned {ident}_SHR = {spec['right_shift']};")
    lines += [
        "`endif",
        "",
    ]
    OUT.write_text("\n".join(lines), encoding="ascii")
    print("WROTE", OUT)


if __name__ == "__main__":
    main()
