#!/usr/bin/env python3
"""Create ASTRA-C1-CAND-CAP-SWEEP-01 from frozen N800000-SCALE-01 gold.

Does not regenerate GOLDEN. Does not edit SEMANTIC-800K-01.
"""
from __future__ import annotations

import shutil
from pathlib import Path

SRC = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C1-N800000-SCALE-01")
DST = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C1-CAND-CAP-SWEEP-01")

COPY = [
    "GOLDEN.json",
    "query_gold.svh",
    "corpus.json",
    "GOLD_HASH_PRE_XVLOG.txt",
    "qse_role_lexicon_semantic_800k.svh",
    "qse_role_lexicon.svh",
    "qse_relctx_synonym_01.svh",
    "gen_800k.svh",
    "a7ng_axi_mem_proc_800k.sv",
]


def main() -> int:
    if (DST / "xsim.log").exists():
        print("REFUSE overwrite existing sweep xsim.log")
        return 4
    DST.mkdir(parents=True, exist_ok=True)
    for name in COPY:
        shutil.copy2(SRC / name, DST / name)

    tb = (SRC / "tb_astra_c1_n800000_scale.sv").read_text(encoding="utf-8")
    tb = tb.replace("tb_astra_c1_n800000_scale", "tb_astra_c1_cand_cap_sweep")
    tb = tb.replace(
        "module tb_astra_c1_cand_cap_sweep;",
        "module tb_astra_c1_cand_cap_sweep #(\n"
        "    parameter int unsigned CAND_CAP_SWEEP = 16\n"
        "  );",
    )
    tb = tb.replace(
        "localparam int unsigned CAND_CAP = G_CAND_CAP;",
        "localparam int unsigned CAND_CAP = CAND_CAP_SWEEP;",
    )
    tb = tb.replace(
        '    $display("C1_N800000_SCALE_N=%0d N_BUCKETS=%0d CAND_CAP=%0d INDEX_HEAD=%0d LAW=qse-v2-relctx-synonym-01 CTX=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-800k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN PROC_MEM=1 N_ADDRESSABLE=800000 N_SUBJECTS=%0d N_RELS=%0d FILL_GRID=120,121,122 FILL_K0=%0d FILL_K1=%0d SEN_NID=799999 LATE_NID=799998",\n'
        "      G_N, G_N_BUCKETS, CAND_CAP, G_INDEX_HEAD, G_N_SUBJECTS, G_N_RELS, G_FILL_K0, G_FILL_K1);",
        '    $display("C1_CAND_CAP_SWEEP_N=%0d N_BUCKETS=%0d CAND_CAP=%0d INDEX_HEAD=%0d LAW=qse-v2-relctx-synonym-01 CTX=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-800k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN PROC_MEM=1 N_ADDRESSABLE=800000 N_SUBJECTS=%0d N_RELS=%0d FILL_GRID=120,121,122 FILL_K0=%0d FILL_K1=%0d SEN_NID=799999 LATE_NID=799998",\n'
        "      G_N, G_N_BUCKETS, CAND_CAP, G_INDEX_HEAD, G_N_SUBJECTS, G_N_RELS, G_FILL_K0, G_FILL_K1);\n"
        '    $display("CAND_CAP_SWEEP_POINT cap=%0d G_CAND_CAP_GOLD=%0d CAND_CAP_FINAL=NOT_FROZEN", CAND_CAP, G_CAND_CAP);',
    )
    tb = tb.replace(
        '      $display("ASTRA_C1_N800000_SCALE_XSIM_PASS");',
        '      $display("ASTRA_C1_CAND_CAP_SWEEP_XSIM_PASS cap=%0d", CAND_CAP);',
    )
    tb = tb.replace(
        '      $display("ASTRA_C1_N800000_SCALE_XSIM_NO_MARKER fail=%0d unrelated_empty=%0d fill_tp=%0d fill_ids_ok=%0d keys_match_frozen=%0d keys_match_syn=%0d nl_hit=%0d late_hit=%0d high_hit=%0d incomp_retrieve=%0d G_N=%0d",',
        '      $display("ASTRA_C1_CAND_CAP_SWEEP_XSIM_NO_MARKER cap=%0d fail=%0d unrelated_empty=%0d fill_tp=%0d fill_ids_ok=%0d keys_match_frozen=%0d keys_match_syn=%0d nl_hit=%0d late_hit=%0d high_hit=%0d incomp_retrieve=%0d G_N=%0d",\n'
        "        CAND_CAP,",
    )
    (DST / "tb_astra_c1_cand_cap_sweep.sv").write_text(tb, encoding="utf-8")
    print("sweep bag files ready", DST)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
