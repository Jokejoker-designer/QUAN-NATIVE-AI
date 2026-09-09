// tb_astra_c1_dir_full16.sv — C1 N_BUCKETS=65536 qse-v2-stream-intersect-02. PROGRAM=NO.
// Frozen QSE + relbind keys + STREAM-02 walker instantiated .N_BUCKETS(65536). poke_v=0.
// leftover A09 off. G_BYTES LSB-first: char0 at [7:0]; extract bytes[8*bi +: 8] only.
// ONE UNKNOWN: 12-bit-alias pair must retrieve intended nid only (no collision emit).
// Gold miss on retrieve class = FAIL (incomp does not hide). SEARCH_INCOMPLETE on
// gold_n>=1 retrieve class FAILS the bag (no PASS marker).
// Distractor: G_GOLD_EXCLUDED=1; leak=FAIL not tp. Headline precision_all=TP/emit_n.
// MEM_DEPTH TB-only for 4*65536*16 directory + postings.
`timescale 1ns / 1ps

module tb_astra_c1_dir_full16;
  import a7ng_pkg::*;
  `include "query_gold.svh"

  localparam int unsigned ID_W = 20;
  localparam int unsigned CAND_CAP = G_CAND_CAP;
  localparam int unsigned MEM_DEPTH = G_MEM_DEPTH;
  localparam logic [27:0] POST_HEAP = G_POST_HEAP;
  localparam logic [27:0] DIR_LO = G_DIR_LO;
  localparam logic [27:0] DIR_HI = G_DIR_HI;

  logic clk, rst_n;
  logic tok_v, tok_r, fire, retire, busy, acc, valid;
  logic [7:0] tok, subj, obj, rel, ctx;
  logic [1:0] dir, nhyp;
  logic neg, amb, trip;
  logic [63:0] sc, oc, rc, xc;
  logic [15:0] crc, k0, k1, k2, k3;
  logic v0, v1, v2, v3;
  logic [3:0] vmask;
  logic [15:0] h_ent, h_int, h_hash, h_sh, h_bkt, h_cand, h_win, h_addr, h_rel, h_nxt, h_ans;

  logic sp_tok_v, sp_tok_r, sp_fire, sp_retire, poke_v;
  logic qse_valid, qse_busy, qse_acc;
  logic [7:0] sp_tok, sp_eid, sp_iid, sp_rid, sp_xid;
  logic [15:0] sp_k0, sp_k1, sp_k2, sp_k3, n_host_any, live_epoch;
  logic sp_v0, sp_v1, sp_v2, sp_v3;
  logic [1:0] sp_dir, sp_nhyp;
  logic sp_neg, sp_amb, sp_trip;
  logic walk_ready, cand_v, cand_ready, q_done, q_ovf, q_incomp;
  logic [15:0] n_emit, n_dup, n_trunc, n_dir, n_post;
  logic [3:0] pmask;
  logic [ID_W-1:0] cand_id;
  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst; logic arvalid, arready;
  logic [3:0] ridb; logic [127:0] rdata; logic [1:0] rresp;
  logic rlast, rvalid, rready;
  logic [15:0] pk0, pk1, pk2, pk3;
  logic pv0, pv1, pv2, pv3;
  logic [15:0] h_ent2, h_int2, h_hash2, h_sh2, h_bkt2, h_cand2;
  logic [15:0] h_win2, h_addr2, h_rel2, h_nxt2, h_ans2;
  logic [15:0] k0_rb, k1_rb, k2_rb, k3_rb;
  logic v0_rb, v1_rb, v2_rb, v3_rb;

  integer i, bi, qi, timeout, n_got, fail;
  integer n_host, nrel, incomp, n_miss, leak_n;
  integer tp, fp_ev1, fp_fill0, den_ev1, prec_ev1_x1000, prec_all_x1000, rec_x1000;
  integer dir_bytes, post_bytes, disc_bytes;
  integer unrelated_empty, wc_not_sel, dist_gold_ok, dist_excl_ok, dist_no_leak;
  integer keys_match, emit_match, direct_n, direct_tp;
  integer arlen_bad, incomp_retrieve;
  integer alias_high_hit, alias_no_low, alias_low_ok, alias_no_high, alias_ar_high;
  integer saw_high_key_ar;
  logic [ID_W-1:0] got [0:31];
  logic [ID_W-1:0] direct_got [0:31];
  logic found, found_low, found_high;
  logic [27:0] dir_key0;

  a7ng_query_role_extract u_qse (
    .clk(clk), .rst_n(rst_n),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .busy_o(busy), .accepted_o(acc), .valid_o(valid),
    .subj_id_o(subj), .obj_id_o(obj), .rel_id_o(rel), .ctx_id_o(ctx),
    .direction_o(dir), .negation_o(neg), .ambiguity_o(amb), .triple_valid_o(trip),
    .n_hyp_o(nhyp),
    .subj_cue_o(sc), .obj_cue_o(oc), .rel_cue_o(rc), .ctx_cue_o(xc),
    .crc16_dbg_o(crc), .k0_o(k0), .k1_o(k1), .k2_o(k2), .k3_o(k3),
    .k0_valid_o(v0), .k1_valid_o(v1), .k2_valid_o(v2), .k3_valid_o(v3),
    .valid_mask_o(vmask),
    .n_host_entity_o(h_ent), .n_host_intent_o(h_int), .n_host_hash_o(h_hash),
    .n_host_shard_o(h_sh), .n_host_bucket_o(h_bkt), .n_host_cand_o(h_cand),
    .n_host_winner_o(h_win), .n_host_addr_o(h_addr), .n_host_relpath_o(h_rel),
    .n_host_next_o(h_nxt), .n_host_answer_o(h_ans)
  );

  a7ng_axi_mem_model #(.DEPTH_WORDS(MEM_DEPTH)) u_mem (
    .clk(clk), .rst_n(rst_n),
    .s_axi_awid(4'd0), .s_axi_awaddr(28'd0), .s_axi_awlen(8'd0),
    .s_axi_awsize(3'd4), .s_axi_awburst(2'b01),
    .s_axi_awvalid(1'b0), .s_axi_awready(),
    .s_axi_wdata(128'd0), .s_axi_wstrb(16'h0), .s_axi_wlast(1'b0),
    .s_axi_wvalid(1'b0), .s_axi_wready(),
    .s_axi_bid(), .s_axi_bresp(), .s_axi_bvalid(), .s_axi_bready(1'b1),
    .s_axi_arid(arid), .s_axi_araddr(araddr), .s_axi_arlen(arlen),
    .s_axi_arsize(arsize), .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid), .s_axi_arready(arready),
    .s_axi_rid(ridb), .s_axi_rdata(rdata), .s_axi_rresp(rresp),
    .s_axi_rlast(rlast), .s_axi_rvalid(rvalid), .s_axi_rready(rready)
  );

  a7ng_query_role_keys_relbind u_rb_qse (
    .rel_id_i(rel),
    .subj_cue_i(sc),
    .obj_cue_i(oc),
    .k0_i(k0), .k1_i(k1),
    .k0_valid_i(v0), .k1_valid_i(v1),
    .k2_valid_i(v2), .k3_valid_i(v3),
    .k0_o(k0_rb), .k1_o(k1_rb), .k2_o(k2_rb), .k3_o(k3_rb),
    .k0_valid_o(v0_rb), .k1_valid_o(v1_rb),
    .k2_valid_o(v2_rb), .k3_valid_o(v3_rb)
  );

  a7ng_query_axi_sparse_stream_intersect #(
    .N_TABLES(4), .N_BUCKETS(G_N_BUCKETS), .CAND_CAP(CAND_CAP),
    .ID_W(ID_W), .INDEX_BASE(NG_DDR_INDEX_BASE),
    .MERGE_POST_AR_MAX(256)
  ) u_sp (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_epoch),
    .tok_valid_i(sp_tok_v), .tok_ready_o(sp_tok_r), .tok_i(sp_tok),
    .fire_i(sp_fire), .retire_i(sp_retire),
    .poke_v_i(poke_v),
    .poke_k0_i(pk0), .poke_k1_i(pk1), .poke_k2_i(pk2), .poke_k3_i(pk3),
    .poke_v0_i(pv0), .poke_v1_i(pv1), .poke_v2_i(pv2), .poke_v3_i(pv3),
    .qse_valid_o(qse_valid), .qse_busy_o(qse_busy), .qse_accepted_o(qse_acc),
    .entity_id_o(sp_eid), .intent_id_o(sp_iid), .relation_id_o(sp_rid), .context_id_o(sp_xid),
    .k0_o(sp_k0), .k1_o(sp_k1), .k2_o(sp_k2), .k3_o(sp_k3),
    .k0_valid_o(sp_v0), .k1_valid_o(sp_v1), .k2_valid_o(sp_v2), .k3_valid_o(sp_v3),
    .direction_o(sp_dir), .negation_o(sp_neg), .ambiguity_o(sp_amb),
    .triple_valid_o(sp_trip), .n_hyp_o(sp_nhyp),
    .n_host_any_o(n_host_any),
    .n_host_entity_o(h_ent2), .n_host_intent_o(h_int2), .n_host_hash_o(h_hash2),
    .n_host_shard_o(h_sh2), .n_host_bucket_o(h_bkt2), .n_host_cand_o(h_cand2),
    .n_host_winner_o(h_win2), .n_host_addr_o(h_addr2), .n_host_relpath_o(h_rel2),
    .n_host_next_o(h_nxt2), .n_host_answer_o(h_ans2),
    .walk_ready_o(walk_ready),
    .cand_v(cand_v), .cand_ready(cand_ready), .cand_id(cand_id),
    .q_done(q_done), .q_overflow_o(q_ovf), .q_incomplete_o(q_incomp),
    .n_emit_o(n_emit), .n_dup_o(n_dup), .n_trunc_o(n_trunc),
    .n_dir_ar_o(n_dir), .n_post_ar_o(n_post), .probed_mask_o(pmask),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(ridb), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  function automatic string cname(input int q);
    case (q)
      0: cname = "direct";
      1: cname = "paraphrase";
      2: cname = "role_reversal";
      3: cname = "wrong_relation";
      4: cname = "wrong_context";
      5: cname = "distractor";
      6: cname = "unrelated";
      7: cname = "high_occupancy";
      8: cname = "overflow_page";
      9: cname = "high_id_sentinel";
      10: cname = "late_gold";
      11: cname = "alias_high";
      12: cname = "alias_low";
      default: cname = "unknown_class";
    endcase
  endfunction

  task automatic diverge(input string code, input string d);
    begin
      $display("FIRST_DIVERGENCE %s %s", code, d);
      fail = fail + 1;
      #20 $finish;
    end
  endtask

  task automatic feed_qse(input int n, input logic [8*48-1:0] bytes);
    begin
      for (bi = 0; bi < n; bi = bi + 1) begin
        @(posedge clk);
        tok_v <= 1'b1;
        tok   <= bytes[8*bi +: 8];
        @(posedge clk);
        if (!tok_r) diverge("KEY_MISMATCH", "QSE_NOT_READY");
        tok_v <= 1'b0;
      end
      @(posedge clk); fire <= 1'b1;
      @(posedge clk); fire <= 1'b0;
    end
  endtask

  task automatic feed_sp(input int n, input logic [8*48-1:0] bytes);
    begin
      for (bi = 0; bi < n; bi = bi + 1) begin
        @(posedge clk);
        sp_tok_v <= 1'b1;
        sp_tok   <= bytes[8*bi +: 8];
        @(posedge clk);
        if (!sp_tok_r) diverge("KEY_MISMATCH", "SP_NOT_READY");
        sp_tok_v <= 1'b0;
      end
      @(posedge clk); sp_fire <= 1'b1;
      @(posedge clk); sp_fire <= 1'b0;
    end
  endtask

  task automatic wait_qse;
    begin
      timeout = 0;
      while (!valid) begin
        @(posedge clk);
        timeout = timeout + 1;
        if (timeout > 64) diverge("KEY_MISMATCH", "QSE_NO_VALID");
      end
    end
  endtask

  task automatic observe_walk;
    begin
      n_got = 0; timeout = 0; cand_ready = 1'b1; arlen_bad = 0;
      saw_high_key_ar = 0;
      while (!q_done) begin
        @(posedge clk);
        if (arvalid && arready) begin
          if (araddr < DIR_LO || (araddr > DIR_HI && araddr < POST_HEAP))
            diverge("HIDDEN_FULL_SCAN", $sformatf("AR=%h", araddr));
          if (arlen != 8'd0)
            arlen_bad = arlen_bad + 1;
          if ((araddr >= DIR_LO) && (araddr <= DIR_HI) && (araddr < (DIR_LO + 28'h100000))) begin
            dir_key0 = (araddr - DIR_LO) >> 4;
            if (dir_key0 >= 28'd4096)
              saw_high_key_ar = 1;
          end
        end
        if (cand_v && cand_ready) begin
          if (n_got >= 32) diverge("CANDIDATE_ID_MISMATCH", "got overflow");
          got[n_got] = cand_id;
          n_got = n_got + 1;
        end
        timeout = timeout + 1;
        if (timeout > 500000) diverge("AXI_PROTOCOL_ERROR", "TIMEOUT");
      end
      @(posedge clk);
      if (arlen_bad != 0)
        diverge("AXI_PROTOCOL_ERROR", $sformatf("page_buffer_not_1_beat arlen_nz=%0d", arlen_bad));
    end
  endtask

  initial begin
    fail = 0;
    unrelated_empty = 0;
    wc_not_sel = 0;
    dist_gold_ok = 0;
    dist_excl_ok = 0;
    dist_no_leak = 0;
    leak_n = 0;
    direct_n = 0;
    direct_tp = 0;
    incomp_retrieve = 0;
    alias_high_hit = 0;
    alias_no_low = 0;
    alias_low_ok = 0;
    alias_no_high = 0;
    alias_ar_high = 0;
    rst_n = 0;
    tok_v = 0; tok = 0; fire = 0; retire = 0;
    sp_tok_v = 0; sp_tok = 0; sp_fire = 0; sp_retire = 0; poke_v = 0;
    cand_ready = 1; live_epoch = 16'd7;
    pk0 = 0; pk1 = 0; pk2 = 0; pk3 = 0;
    pv0 = 0; pv1 = 0; pv2 = 0; pv3 = 0;
    if (CAND_CAP >= G_N)
      diverge("SELECTIVITY_TAUTOLOGY", "CAND_CAP>=N");
    if (G_N_BUCKETS != 65536)
      diverge("DIR_WIDTH", "G_N_BUCKETS!=65536");
    if (G_NREL[5] < 1)
      diverge("DISTRACTOR_EMPTY_GOLD", "gold_n<1");
    if (G_GOLD_EXCLUDED[5] !== 1'b1)
      diverge("DISTRACTOR_POLARITY", "G_GOLD_EXCLUDED[5]!=1");
    if (G_ALIAS_HIGH_Q != 11)
      diverge("ALIAS_HIGH_IDX", "G_ALIAS_HIGH_Q!=11");
    if (G_K0[G_ALIAS_HIGH_Q][15:12] == 4'd0)
      diverge("ALIAS_HIGH_KEY_NO_HIGH_NIBBLE", "k0 bits[15:12]==0");
    if ((G_K0[G_ALIAS_HIGH_Q] & 16'h0FFF) !== (G_K0[G_ALIAS_LOW_Q] & 16'h0FFF))
      diverge("ALIAS_12BIT_MISMATCH", "k0 low-12 differ");
    if ((G_K1[G_ALIAS_HIGH_Q] & 16'h0FFF) !== (G_K1[G_ALIAS_LOW_Q] & 16'h0FFF))
      diverge("ALIAS_12BIT_MISMATCH", "k1 low-12 differ");
    if (G_K0[G_ALIAS_HIGH_Q] === G_K0[G_ALIAS_LOW_Q])
      diverge("ALIAS_16BIT_SAME", "k0 high==low");
    dist_gold_ok = 1;
    dist_excl_ok = 1;
    for (i = 0; i < MEM_DEPTH; i = i + 1)
      u_mem.mem[i] = '0;
    repeat (8) @(posedge clk);
    rst_n = 1;
    repeat (4) @(posedge clk);
    for (i = 0; i < G_N_WR; i = i + 1)
      u_mem.mem[G_WR_I[i]] = G_WR_D[i];
    repeat (2) @(posedge clk);

    n_host = h_ent|h_int|h_hash|h_sh|h_bkt|h_cand|h_win|h_addr|h_rel|h_nxt|h_ans;
    if (n_host != 0) diverge("HOST_SEMANTIC_LEAK", "qse reset");
    if (poke_v !== 1'b0) diverge("HOST_SEMANTIC_LEAK", "poke_v!=0");

    $display("C1_DIR_FULL16_N=%0d N_BUCKETS=%0d CAND_CAP=%0d INDEX_HEAD=%0d LAW=qse-v2-stream-intersect-02 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN MEM_DEPTH=%0d",
      G_N, G_N_BUCKETS, CAND_CAP, G_INDEX_HEAD, MEM_DEPTH);

    for (qi = 0; qi < G_NQ; qi = qi + 1) begin
      feed_qse(G_LEN[qi], G_BYTES[qi]);
      wait_qse();
      if (subj !== G_SUBJ[qi] || obj !== G_OBJ[qi] || rel !== G_REL[qi] || ctx !== G_CTX[qi])
        diverge("ROLE_COLLAPSE", $sformatf("q=%0d %s subj/obj/rel/ctx %0d %0d %0d %0d",
          qi, cname(qi), subj, obj, rel, ctx));
      if (k0 !== G_K0[qi] || k1 !== G_K1[qi])
        diverge("KEY_MISMATCH", $sformatf("q=%0d %s frozen k0k1 %h %h", qi, cname(qi), k0, k1));
      if (k0_rb !== G_K0[qi] || k1_rb !== G_K1[qi] || k2_rb !== G_K2[qi] || k3_rb !== G_K3[qi])
        diverge("KEY_MISMATCH", $sformatf("q=%0d %s relbind k %h %h %h %h", qi, cname(qi), k0_rb, k1_rb, k2_rb, k3_rb));
      if (v0 !== G_V0[qi] || v1 !== G_V1[qi] || v2 !== G_V2[qi] || v3 !== G_V3[qi])
        diverge("VALIDITY_MISMATCH", $sformatf("q=%0d %s", qi, cname(qi)));
      if (qi == 0 && k2_rb === k2)
        diverge("KEY_MISMATCH", "relbind k2 identical to frozen cue k2");
      n_host = h_ent|h_int|h_hash|h_sh|h_bkt|h_cand|h_win|h_addr|h_rel|h_nxt|h_ans;
      if (n_host != 0) diverge("HOST_SEMANTIC_LEAK", $sformatf("qse q=%0d", qi));
      if (poke_v !== 1'b0) diverge("HOST_SEMANTIC_LEAK", $sformatf("poke_v q=%0d", qi));
      @(posedge clk); retire <= 1'b1;
      @(posedge clk); retire <= 1'b0;
      @(posedge clk);

      while (!walk_ready) @(posedge clk);
      feed_sp(G_LEN[qi], G_BYTES[qi]);
      timeout = 0;
      while (!qse_valid) begin
        @(posedge clk);
        timeout = timeout + 1;
        if (timeout > 64) diverge("KEY_MISMATCH", $sformatf("SP_NO_VALID q=%0d", qi));
      end
      if (sp_k0 !== G_K0[qi] || sp_k1 !== G_K1[qi] || sp_k2 !== G_K2[qi] || sp_k3 !== G_K3[qi])
        diverge("KEY_MISMATCH", $sformatf("sparse q=%0d %s", qi, cname(qi)));
      if (n_host_any != 0) diverge("HOST_SEMANTIC_LEAK", $sformatf("sparse q=%0d", qi));
      observe_walk();
      if (n_got != G_NEMIT[qi] || n_emit != G_NEMIT[qi])
        diverge("CANDIDATE_ID_MISMATCH", $sformatf("q=%0d %s emit %0d exp %0d", qi, cname(qi), n_got, G_NEMIT[qi]));
      for (i = 0; i < n_got; i = i + 1)
        if (got[i] !== G_EMIT[qi][i])
          diverge("CANDIDATE_ID_MISMATCH", $sformatf("q=%0d %s i=%0d act=%0d exp=%0d",
            qi, cname(qi), i, got[i], G_EMIT[qi][i]));
      if (n_got >= G_N)
        diverge("SELECTIVITY_TAUTOLOGY", $sformatf("q=%0d emit>=N", qi));

      nrel = G_NREL[qi];
      tp = 0;
      fp_ev1 = 0;
      fp_fill0 = 0;
      n_miss = 0;
      leak_n = 0;
      incomp = 0;

      if (G_GOLD_EXCLUDED[qi]) begin
        if (nrel < 1)
          diverge("DISTRACTOR_EMPTY_GOLD", "gold_n<1 at CLASS");
        for (i = 0; i < nrel; i = i + 1) begin
          found = 1'b0;
          for (bi = 0; bi < n_got; bi = bi + 1)
            if (got[bi] === G_RELEVANT[qi][i]) found = 1'b1;
          if (found) leak_n = leak_n + 1;
        end
        for (i = 0; i < n_got; i = i + 1) begin
          if (got[i] >= G_N)
            diverge("CANDIDATE_ID_MISMATCH", $sformatf("id>=N q=%0d id=%0d", qi, got[i]));
          else if (G_EVIDENCE[got[i]] == 0)
            fp_fill0 = fp_fill0 + 1;
          else
            fp_ev1 = fp_ev1 + 1;
        end
        tp = 0;
        rec_x1000 = -1;
        den_ev1 = tp + fp_ev1;
        if (n_got == 0) prec_all_x1000 = -1;
        else prec_all_x1000 = (tp * 1000) / n_got;
        if (den_ev1 == 0) prec_ev1_x1000 = -1;
        else prec_ev1_x1000 = (tp * 1000) / den_ev1;
      end else begin
        for (i = 0; i < nrel; i = i + 1) begin
          found = 1'b0;
          for (bi = 0; bi < n_got; bi = bi + 1)
            if (got[bi] === G_RELEVANT[qi][i]) found = 1'b1;
          if (found) tp = tp + 1;
          else n_miss = n_miss + 1;
        end
        for (i = 0; i < n_got; i = i + 1) begin
          found = 1'b0;
          for (bi = 0; bi < nrel; bi = bi + 1)
            if (got[i] === G_RELEVANT[qi][bi]) found = 1'b1;
          if (!found) begin
            if (got[i] >= G_N)
              diverge("CANDIDATE_ID_MISMATCH", $sformatf("id>=N q=%0d id=%0d", qi, got[i]));
            else if (G_EVIDENCE[got[i]] == 0)
              fp_fill0 = fp_fill0 + 1;
            else
              fp_ev1 = fp_ev1 + 1;
          end
        end
        den_ev1 = tp + fp_ev1;
        if (n_got == 0) prec_all_x1000 = -1;
        else prec_all_x1000 = (tp * 1000) / n_got;
        if (den_ev1 == 0) prec_ev1_x1000 = -1;
        else prec_ev1_x1000 = (tp * 1000) / den_ev1;
        if (nrel == 0) rec_x1000 = -1;
        else rec_x1000 = (tp * 1000) / nrel;
        if ((n_trunc > 0) || q_incomp)
          incomp = 1;
        if (n_miss > 0 && nrel >= 1) begin
          $display("FAIL GOLD_MISS class=%s missed=%0d trunc=%0d ovf=%0d incomp=%0d",
            cname(qi), n_miss, n_trunc, q_ovf, incomp);
          fail = fail + 1;
          if (incomp) begin
            $display("SEARCH_INCOMPLETE class=%s missed=%0d (incomp does not hide gold miss)",
              cname(qi), n_miss);
            incomp_retrieve = 1;
          end
        end else if (incomp && nrel >= 1) begin
          $display("SEARCH_INCOMPLETE class=%s gold_n=%0d gold_hit=1 trunc=%0d ovf=%0d q_incomp=%0d",
            cname(qi), nrel, n_trunc, q_ovf, q_incomp);
          $display("FAIL SEARCH_INCOMPLETE_ON_RETRIEVE class=%s gold_n>=1 (does not PASS)",
            cname(qi));
          fail = fail + 1;
          incomp_retrieve = 1;
        end
      end
      dir_bytes = n_dir * 16;
      post_bytes = n_post * 16;
      disc_bytes = n_dup * 4;

      if (qi == 0) begin
        direct_n = n_got;
        direct_tp = tp;
        for (i = 0; i < n_got; i = i + 1)
          direct_got[i] = got[i];
        if (direct_tp < 1) begin
          $display("FAIL DIRECT_GOLD_MISS tp=0");
          fail = fail + 1;
        end
        found = 1'b1;
        for (i = 0; i < nrel; i = i + 1) begin
          if (G_RELEVANT[qi][i] == 20'd110 || G_RELEVANT[qi][i] == 20'd144 || G_RELEVANT[qi][i] == 20'd145) begin
            found = 1'b0;
            for (bi = 0; bi < n_got; bi = bi + 1)
              if (got[bi] === G_RELEVANT[qi][i]) found = 1'b1;
            if (!found) begin
              $display("FAIL DIRECT_CONTROL_GOLD_MISS id=%0d", G_RELEVANT[qi][i]);
              fail = fail + 1;
            end
          end
        end
      end

      if (qi == 4) begin
        keys_match = (k0_rb === G_K0[0] && k1_rb === G_K1[0] && k2_rb === G_K2[0] && k3_rb === G_K3[0]);
        emit_match = (n_got == direct_n);
        if (emit_match)
          for (i = 0; i < n_got; i = i + 1)
            if (got[i] !== direct_got[i]) emit_match = 0;
        $display("NOT_SELECTIVE class=wrong_context k0=%0d k1=%0d k2=%0d k3=%0d vs_direct k0=%0d k1=%0d k2=%0d k3=%0d keys_match=%0d emit_match=%0d law=qse-v2-stream-intersect-02 xid_not_directory_key",
          k0_rb, k1_rb, k2_rb, k3_rb, G_K0[0], G_K1[0], G_K2[0], G_K3[0], keys_match, emit_match);
        wc_not_sel = 1;
      end

      if (qi == G_ALIAS_HIGH_Q) begin
        found_high = 1'b0;
        found_low = 1'b0;
        for (i = 0; i < n_got; i = i + 1) begin
          if (got[i] === G_ALIAS_HIGH_ID) found_high = 1'b1;
          if (got[i] === G_ALIAS_LOW_ID) found_low = 1'b1;
        end
        if (!found_high) begin
          $display("FAIL ALIAS_HIGH_MISS id=%0d emit_n=%0d", G_ALIAS_HIGH_ID, n_got);
          fail = fail + 1;
        end else begin
          alias_high_hit = 1;
          $display("FULL16_HIT id=%0d k0=%0d k1=%0d", G_ALIAS_HIGH_ID, k0_rb, k1_rb);
        end
        if (found_low) begin
          $display("FAIL ALIAS_12BIT_COLLISION_EMIT low_id=%0d high_id=%0d", G_ALIAS_LOW_ID, G_ALIAS_HIGH_ID);
          fail = fail + 1;
        end else begin
          alias_no_low = 1;
          $display("FULL16_NO_12BIT_COLLISION low_alias_id=%0d excluded_from_high_emit=1", G_ALIAS_LOW_ID);
        end
        if (G_ALIAS12_WOULD_COLLIDE[qi])
          $display("ALIAS12_WOULD_COLLIDE k0_high=%0d k0_low=%0d share12=%0d low_id=%0d high_id=%0d",
            G_K0[G_ALIAS_HIGH_Q], G_K0[G_ALIAS_LOW_Q],
            (G_K0[G_ALIAS_HIGH_Q] & 16'h0FFF), G_ALIAS_LOW_ID, G_ALIAS_HIGH_ID);
        if (saw_high_key_ar == 0) begin
          $display("FAIL ALIAS_HIGH_NO_HIGH_NIBBLE_AR");
          fail = fail + 1;
        end else begin
          alias_ar_high = 1;
          $display("DIR16_AR_HIGH_NIBBLE table0_key_ge_4096=1");
        end
      end

      if (qi == G_ALIAS_LOW_Q) begin
        found_high = 1'b0;
        found_low = 1'b0;
        for (i = 0; i < n_got; i = i + 1) begin
          if (got[i] === G_ALIAS_HIGH_ID) found_high = 1'b1;
          if (got[i] === G_ALIAS_LOW_ID) found_low = 1'b1;
        end
        if (!found_low) begin
          $display("FAIL ALIAS_LOW_MISS id=%0d", G_ALIAS_LOW_ID);
          fail = fail + 1;
        end else alias_low_ok = 1;
        if (found_high) begin
          $display("FAIL ALIAS_LOW_EMITTED_HIGH id=%0d", G_ALIAS_HIGH_ID);
          fail = fail + 1;
        end else alias_no_high = 1;
      end

      if (qi == 6) begin
        if (n_got != 0)
          diverge("CANDIDATE_ID_MISMATCH", "unrelated emit!=0");
        $display("CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=%0d emit_n=0 tp=0 fp_ev1=0 fp_fill0=0", nrel);
        unrelated_empty = 1;
      end else if (G_GOLD_EXCLUDED[qi]) begin
        if (leak_n > 0) begin
          $display("FAIL DISTRACTOR_LEAK leak_n=%0d emit_n=%0d fp_ev1=%0d fp_fill0=%0d gold_n=%0d",
            leak_n, n_got, fp_ev1, fp_fill0, nrel);
          fail = fail + 1;
        end else begin
          dist_no_leak = 1;
        end
        $display("CLASS_distractor gold_n=%0d emit_n=%0d leak_n=%0d tp=0 fp_ev1=%0d fp_fill0=%0d prec_ev1_x1000=%0d prec_all_x1000=%0d rec_undef=1 occ=%0d ovf=%0d trunc=%0d dirB=%0d postB=%0d discB=%0d descB=0 incomp=0 gold_polarity=excluded",
          nrel, n_got, leak_n, fp_ev1, fp_fill0, prec_ev1_x1000, prec_all_x1000,
          G_OCC[qi], q_ovf, n_trunc, dir_bytes, post_bytes, disc_bytes);
      end else begin
        if (prec_ev1_x1000 < 0)
          $display("CLASS_%s gold_n=%0d emit_n=%0d tp=%0d fp_ev1=%0d fp_fill0=%0d prec_ev1_undef=1 prec_all_x1000=%0d rec_x1000=%0d occ=%0d ovf=%0d trunc=%0d dirB=%0d postB=%0d discB=%0d descB=0 incomp=%0d",
            cname(qi), nrel, n_got, tp, fp_ev1, fp_fill0, prec_all_x1000, rec_x1000,
            G_OCC[qi], q_ovf, n_trunc, dir_bytes, post_bytes, disc_bytes, incomp);
        else if (rec_x1000 < 0)
          $display("CLASS_%s gold_n=%0d emit_n=%0d tp=%0d fp_ev1=%0d fp_fill0=%0d prec_ev1_x1000=%0d prec_all_x1000=%0d rec_undef=1 occ=%0d ovf=%0d trunc=%0d dirB=%0d postB=%0d discB=%0d descB=0 incomp=%0d",
            cname(qi), nrel, n_got, tp, fp_ev1, fp_fill0, prec_ev1_x1000, prec_all_x1000,
            G_OCC[qi], q_ovf, n_trunc, dir_bytes, post_bytes, disc_bytes, incomp);
        else
          $display("CLASS_%s gold_n=%0d emit_n=%0d tp=%0d fp_ev1=%0d fp_fill0=%0d prec_ev1_x1000=%0d prec_all_x1000=%0d rec_x1000=%0d occ=%0d ovf=%0d trunc=%0d dirB=%0d postB=%0d discB=%0d descB=0 incomp=%0d",
            cname(qi), nrel, n_got, tp, fp_ev1, fp_fill0, prec_ev1_x1000, prec_all_x1000, rec_x1000,
            G_OCC[qi], q_ovf, n_trunc, dir_bytes, post_bytes, disc_bytes, incomp);
      end
      $display("EMIT_%s n=%0d", cname(qi), n_got);
      for (i = 0; i < n_got; i = i + 1) begin
        if (got[i] < G_N)
          $display("  CAND %s i=%0d id=%0d ev=%0d", cname(qi), i, got[i], G_EVIDENCE[got[i]]);
        else
          $display("  CAND %s i=%0d id=%0d ev=-1", cname(qi), i, got[i]);
      end

      if (qi == 9) begin
        found = 1'b0;
        for (i = 0; i < n_got; i = i + 1)
          if (got[i] == G_SENTINEL_ID) found = 1'b1;
        if (!found) begin
          $display("FAIL GOLD_MISS class=high_id_sentinel id=%0d", G_SENTINEL_ID);
          fail = fail + 1;
        end
      end
      if (qi == 7 && G_OCC[qi] <= CAND_CAP)
        diverge("SELECTIVITY_TAUTOLOGY", "high_occupancy occ<=cap");
      if (qi == 8 && q_ovf !== 1'b1)
        diverge("OVERFLOW_MISS", "overflow_page q_overflow=0");

      @(posedge clk); sp_retire <= 1'b1;
      @(posedge clk); sp_retire <= 1'b0;
      @(posedge clk);
    end

    $display("HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic");
    if (fail == 0 && dist_gold_ok && dist_excl_ok && dist_no_leak && unrelated_empty && wc_not_sel
        && (direct_tp > 0) && alias_high_hit && alias_no_low && alias_low_ok && alias_no_high
        && alias_ar_high && (incomp_retrieve == 0)) begin
      $display("ASTRA_C1_DIR_FULL16_XSIM_PASS");
      $display("NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,N_16384,PAGE_SKIP,CONTEXT_KEYS");
      $display("C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO");
      $display("REDUCTION_X1000=NOT_EMITTED");
    end else begin
      $display("ASTRA_C1_DIR_FULL16_XSIM_NO_MARKER fail=%0d dist_gold_ok=%0d dist_excl_ok=%0d dist_no_leak=%0d unrelated_empty=%0d wc_not_sel=%0d direct_tp=%0d alias_high_hit=%0d alias_no_low=%0d alias_low_ok=%0d alias_no_high=%0d alias_ar_high=%0d incomp_retrieve=%0d",
        fail, dist_gold_ok, dist_excl_ok, dist_no_leak, unrelated_empty, wc_not_sel, direct_tp,
        alias_high_hit, alias_no_low, alias_low_ok, alias_no_high, alias_ar_high, incomp_retrieve);
      $display("NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,N_16384,PAGE_SKIP,CONTEXT_KEYS");
      $display("C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO");
      $display("REDUCTION_X1000=NOT_EMITTED");
    end
    #20 $finish;
  end
endmodule
