#!/usr/bin/env python3
"""Apply S_SMRES multicycle divider to D32. HARD GATE: E3A_N20 e3b_unblocked.

Does not run XSim/Vivado. Does not program. PROGRAM=NO.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

BAG = Path(
    r"D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/26_C4_D32_BITEXACT_PHYSICAL"
)
DUT = Path(
    r"D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v2.sv"
)
N20 = BAG / "E3A_N20.json"
OLD_D32_SHA = "34d934935768baf1d20e7a5d8da49945554716df48bfa6c8e89c3443790819f6"

WIRES = """  logic signed [31:0] elut [0:TMAX-1];
  logic signed [31:0] eden, psum;
  logic               smres_div_go, smres_div_hold, smres_div_busy, smres_div_done;
  logic signed [31:0] smres_div_q;
  logic [5:0]         smres_div_idx;
"""

INST = """  assign vocab_ver_o = A7NG_C4D32_VOCAB_VER;

  a7ng_astra_c4_smres_div_mcycle u_smres_div (
    .clk(clk),
    .rst_n(rst_n),
    .start_i(smres_div_go),
    .elut_i(elut[ti]),
    .eden_i(eden),
    .idx_i(ti[5:0]),
    .busy_o(smres_div_busy),
    .done_o(smres_div_done),
    .q_o(smres_div_q),
    .idx_o(smres_div_idx)
  );
"""

RESET_EXTRA = """      ti <= 0; di <= 0; dj <= 0; fi <= 0; vi <= 0; posi <= 0;
      smres_div_go <= 1'b0;
      smres_div_hold <= 1'b0;
"""

OLD_RESET_TAIL = """      ti <= 0; di <= 0; dj <= 0; fi <= 0; vi <= 0; posi <= 0;
"""

OLD_SMRES = """        S_SMRES: begin
          if (eden == 32'sd0) attn[ti] <= 32'sd0;
          else attn[ti] <= (elut[ti] * 32'sd32767 + (eden / 32'sd2)) / eden;
          psum <= (ti == 0 ? 32'sd0 : psum) + ((eden == 32'sd0) ? 32'sd0 : ((elut[ti] * 32'sd32767 + (eden / 32'sd2)) / eden));
          if (ti == tlen - 1) st <= S_SMFIX;
          else ti <= ti + 1;
        end
"""

NEW_SMRES = """        S_SMRES: begin
          // Shared multicycle divider: one q for attn and psum. No combo /.
          if (!smres_div_hold) begin
            smres_div_go <= 1'b1;
            smres_div_hold <= 1'b1;
          end else begin
            smres_div_go <= 1'b0;
            if (smres_div_done) begin
              attn[ti] <= smres_div_q;
              psum <= (ti == 0 ? 32'sd0 : psum) + smres_div_q;
              smres_div_hold <= 1'b0;
              if (ti == tlen - 1) st <= S_SMFIX;
              else ti <= ti + 1;
            end
          end
        end
"""

OLD_WIRES = """  logic signed [31:0] elut [0:TMAX-1];
  logic signed [31:0] eden, psum;
"""

OLD_ASSIGN = """  assign vocab_ver_o = A7NG_C4D32_VOCAB_VER;
"""


def main() -> int:
    check_only = "--check-blocks" in sys.argv
    force = "--force-after-n20" in sys.argv
    if check_only:
        text = DUT.read_text(encoding="utf-8")
        ok = True
        for name, old in (
            ("wires", OLD_WIRES),
            ("assign", OLD_ASSIGN),
            ("reset", OLD_RESET_TAIL),
            ("smres", OLD_SMRES),
        ):
            hit = old in text
            print("BLOCK", name, "OK" if hit else "MISSING")
            ok = ok and hit
        return 0 if ok else 3
    if not N20.is_file():
        print("E3B_APPLY_BLOCKED missing", N20)
        return 2
    n20 = json.loads(N20.read_text(encoding="utf-8"))
    if not n20.get("e3b_unblocked"):
        print("E3B_APPLY_BLOCKED e3b_unblocked=false", n20.get("e3a"), n20.get("note"))
        return 2
    if not force:
        print("E3B_APPLY_DRYRUN would patch D32; pass --force-after-n20 to write")
        return 0
    text = DUT.read_text(encoding="utf-8")
    for name, old in (
        ("wires", OLD_WIRES),
        ("assign", OLD_ASSIGN),
        ("reset", OLD_RESET_TAIL),
        ("smres", OLD_SMRES),
    ):
        if old not in text:
            print("E3B_APPLY_FAIL missing block", name)
            return 3
    text = text.replace(OLD_WIRES, WIRES, 1)
    text = text.replace(OLD_ASSIGN, INST, 1)
    text = text.replace(OLD_RESET_TAIL, RESET_EXTRA, 1)
    text = text.replace(OLD_SMRES, NEW_SMRES, 1)
    DUT.write_text(text, encoding="utf-8")
    print("E3B_APPLY_WROTE", DUT, "old_sha_expected", OLD_D32_SHA)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
