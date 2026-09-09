#!/usr/bin/env python3
from pathlib import Path

src = Path(__file__).with_name("tb_astra_c1_semantic_800k.sv")
t = src.read_text(encoding="utf-8")
t = t.replace("module tb_astra_c1_semantic_800k", "module tb_astra_c1_n65536_scale")
t = t.replace(
    "// tb_astra_c1_semantic_800k.sv — C1 SEMANTIC-800K.",
    "// tb_astra_c1_n65536_scale.sv — C1 N65536 SCALE.",
)
t = t.replace(
    "AND HIGH_ID_HIT nid=799999",
    "AND LATE_GOLD_HIT nid=65534 AND HIGH_ID_HIT nid=65535",
)
t = t.replace(
    "integer emit_has_131, high_hit, high_tp;",
    "integer emit_has_131, high_hit, high_tp, late_hit, late_tp, red_vs_n, red_vs_occ;",
)
t = t.replace(
    """    else if (q == G_HIGH_Q)
      cname = "high_id_sentinel";
    else if (q == G_UNRELATED_Q)
      cname = "unrelated";""",
    """    else if (q == G_LATE_Q)
      cname = "late_gold";
    else if (q == G_HIGH_Q)
      cname = "high_id_sentinel";
    else if (q == G_UNRELATED_Q)
      cname = "unrelated";""",
)
t = t.replace(
    'if (G_N != 800000)\n      diverge("N_DROP", "G_N!=800000 do_not_silently_drop_to_N16k_or_N256");',
    'if (G_N != 65536)\n      diverge("N_DROP", "G_N!=65536 do_not_silently_drop_N");',
)
t = t.replace(
    'if (G_NQ != 4)\n      diverge("NQ", "G_NQ!=4 (fill+nl_synonym+high_id+unrelated)");',
    'if (G_NQ != 5)\n      diverge("NQ", "G_NQ!=5 (fill+nl+late+high+unrelated)");',
)
t = t.replace(
    'if (G_HIGH_Q != 2)\n      diverge("HIGH_IDX", "G_HIGH_Q!=2");\n    if (G_UNRELATED_Q != 3)\n      diverge("UNRELATED_IDX", "G_UNRELATED_Q!=3");',
    'if (G_LATE_Q != 2)\n      diverge("LATE_IDX", "G_LATE_Q!=2");\n    if (G_HIGH_Q != 3)\n      diverge("HIGH_IDX", "G_HIGH_Q!=3");\n    if (G_UNRELATED_Q != 4)\n      diverge("UNRELATED_IDX", "G_UNRELATED_Q!=4");',
)
t = t.replace(
    'if (G_SEN_NID != 20\'d799999)\n      diverge("SENTINEL", "G_SEN_NID!=799999");',
    'if (G_SEN_NID != 20\'d65535)\n      diverge("SENTINEL", "G_SEN_NID!=65535");',
)
t = t.replace("high_hit = 0;\n    rst_n = 0;", "high_hit = 0;\n    late_hit = 0;\n    late_tp = 0;\n    rst_n = 0;")
old_banner = (
    '$display("C1_SEMANTIC_800K_N=%0d N_BUCKETS=%0d CAND_CAP=%0d INDEX_HEAD=%0d LAW=qse-v2-relctx-synonym-01 CTX=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-800k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN PROC_MEM=1 N_ADDRESSABLE=800000 N_SUBJECTS=%0d N_RELS=%0d FILL_GRID=120,121,122 FILL_K0=%0d FILL_K1=%0d SEN_NID=799999",'
)
new_banner = (
    '$display("C1_N65536_SCALE_N=%0d N_BUCKETS=%0d CAND_CAP=%0d INDEX_HEAD=%0d LAW=qse-v2-relctx-synonym-01 CTX=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-800k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN PROC_MEM=1 N_ADDRESSABLE=65536 N_SUBJECTS=%0d N_RELS=%0d FILL_GRID=120,121,122 FILL_K0=%0d FILL_K1=%0d SEN_NID=65535 LATE_NID=65534",'
)
if old_banner not in t:
    raise SystemExit("banner not found")
t = t.replace(old_banner, new_banner)
old_hi = """      if (qi == G_HIGH_Q) begin
        high_tp = tp;
        high_hit = 0;
        for (i = 0; i < n_got; i = i + 1)
          if (got[i] === G_SEN_NID) high_hit = 1;
        if (high_hit && (n_got == 1) && (got[0] === G_SEN_NID))
          $display("HIGH_ID_HIT nid=799999 emit_n=%0d tp=%0d", n_got, high_tp);
        else begin
          $display("FAIL HIGH_ID_MISS nid_want=799999 emit_n=%0d", n_got);
          fail = fail + 1;
          high_hit = 0;
        end
      end"""
new_hi = """      if (qi == G_LATE_Q) begin
        late_tp = tp;
        late_hit = 0;
        for (i = 0; i < n_got; i = i + 1)
          if (got[i] === 20'd65534) late_hit = 1;
        if (late_hit && (n_got == 1) && (got[0] === 20'd65534))
          $display("LATE_GOLD_HIT nid=65534 emit_n=%0d tp=%0d", n_got, late_tp);
        else begin
          $display("FAIL LATE_GOLD_MISS nid_want=65534 emit_n=%0d", n_got);
          fail = fail + 1;
          late_hit = 0;
        end
      end
      if (qi == G_HIGH_Q) begin
        high_tp = tp;
        high_hit = 0;
        for (i = 0; i < n_got; i = i + 1)
          if (got[i] === G_SEN_NID) high_hit = 1;
        if (high_hit && (n_got == 1) && (got[0] === G_SEN_NID))
          $display("HIGH_ID_HIT nid=%0d emit_n=%0d tp=%0d", G_SEN_NID, n_got, high_tp);
        else begin
          $display("FAIL HIGH_ID_MISS nid_want=%0d emit_n=%0d", G_SEN_NID, n_got);
          fail = fail + 1;
          high_hit = 0;
        end
      end"""
if old_hi not in t:
    raise SystemExit("high_id block not found")
t = t.replace(old_hi, new_hi)
old_em = '      $display("EMIT_%s n=%0d", cname(qi), n_got);'
new_em = """      if (G_OCC[qi] > 0)
        red_vs_n = (1000 * (G_N - G_OCC[qi])) / G_N;
      else
        red_vs_n = 1000;
      if (G_OCC[qi] > 0)
        red_vs_occ = (1000 * (G_OCC[qi] - n_got)) / G_OCC[qi];
      else
        red_vs_occ = 0;
      $display("REDUCTION_VS_N_X1000=%0d REDUCTION_VS_OCC_X1000=%0d class=%s occ=%0d emit_n=%0d N=%0d TOTAL_AXI_BYTES=%0d",
        red_vs_n, red_vs_occ, cname(qi), G_OCC[qi], n_got, G_N, dir_bytes + post_bytes);
      $display("EMIT_%s n=%0d", cname(qi), n_got);"""
if old_em not in t:
    raise SystemExit("emit display not found")
t = t.replace(old_em, new_em, 1)
old_end = """    $display("N800K_SUMMARY fill_tp=%0d nl_hit=%0d high_hit=%0d emit_has_131=%0d incomp_retrieve=%0d fail=%0d G_N=%0d",
      fill_tp, nl_hit, high_hit, emit_has_131, incomp_retrieve, fail, G_N);
    if ((fail == 0) && unrelated_empty && (fill_tp > 0) && fill_ids_ok && (keys_match == 0) && keys_match_syn && nl_hit && (nl_tp >= 3) && (emit_has_131 == 0) && high_hit && (incomp_retrieve == 0) && (G_N == 800000)) begin
      $display("ASTRA_C1_SEMANTIC_800K_XSIM_PASS");
      $display("NOT_CLAIMED=BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,MASTER_95,ACCEPT_BOARD");
      $display("BOARD_PASS=NOT_CLAIMED PROGRAM=NO CAND_CAP_FINAL=NOT_FROZEN");
      $display("REDUCTION_X1000=NOT_EMITTED");
    end else begin
      $display("ASTRA_C1_SEMANTIC_800K_XSIM_NO_MARKER fail=%0d unrelated_empty=%0d fill_tp=%0d fill_ids_ok=%0d keys_match_frozen=%0d keys_match_syn=%0d nl_hit=%0d nl_tp=%0d emit_has_131=%0d high_hit=%0d incomp_retrieve=%0d G_N=%0d",
        fail, unrelated_empty, fill_tp, fill_ids_ok, keys_match, keys_match_syn, nl_hit, nl_tp, emit_has_131, high_hit, incomp_retrieve, G_N);
      $display("NOT_CLAIMED=BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,MASTER_95,ACCEPT_BOARD");
      $display("BOARD_PASS=NOT_CLAIMED PROGRAM=NO CAND_CAP_FINAL=NOT_FROZEN");
      $display("REDUCTION_X1000=NOT_EMITTED");
    end"""
new_end = """    $display("N65536_SUMMARY fill_tp=%0d nl_hit=%0d late_hit=%0d high_hit=%0d emit_has_131=%0d incomp_retrieve=%0d fail=%0d G_N=%0d",
      fill_tp, nl_hit, late_hit, high_hit, emit_has_131, incomp_retrieve, fail, G_N);
    if ((fail == 0) && unrelated_empty && (fill_tp > 0) && fill_ids_ok && (keys_match == 0) && keys_match_syn && nl_hit && (nl_tp >= 3) && (emit_has_131 == 0) && late_hit && high_hit && (incomp_retrieve == 0) && (G_N == 65536)) begin
      $display("ASTRA_C1_N65536_SCALE_XSIM_PASS");
      $display("NOT_CLAIMED=BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,MASTER_95,ACCEPT_BOARD,C1_800K_CLOSE");
      $display("BOARD_PASS=NOT_CLAIMED PROGRAM=NO CAND_CAP_FINAL=NOT_FROZEN");
    end else begin
      $display("ASTRA_C1_N65536_SCALE_XSIM_NO_MARKER fail=%0d unrelated_empty=%0d fill_tp=%0d fill_ids_ok=%0d keys_match_frozen=%0d keys_match_syn=%0d nl_hit=%0d late_hit=%0d high_hit=%0d incomp_retrieve=%0d G_N=%0d",
        fail, unrelated_empty, fill_tp, fill_ids_ok, keys_match, keys_match_syn, nl_hit, late_hit, high_hit, incomp_retrieve, G_N);
      $display("NOT_CLAIMED=BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,MASTER_95,ACCEPT_BOARD,C1_800K_CLOSE");
      $display("BOARD_PASS=NOT_CLAIMED PROGRAM=NO CAND_CAP_FINAL=NOT_FROZEN");
    end"""
if old_end not in t:
    raise SystemExit("end marker block not found")
t = t.replace(old_end, new_end)
out = Path(__file__).with_name("tb_astra_c1_n65536_scale.sv")
out.write_text(t, encoding="utf-8")
print("wrote", out, "not_emitted", "NOT_EMITTED" in t)
