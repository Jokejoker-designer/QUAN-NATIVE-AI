// tb_astra_c1_semantic_unseen_sro.sv — C1 N=256 unseen/non-grid SRO. PROGRAM=NO.
// Frozen QSE + ctx keys 124be808 + STREAM-02 walker in context wrapper 8255a798.
// Named lexicon law qse-v2-lex-semantic-16k-01 (copied df0e8833; not silent C0 59-word).
// poke_v=0. leftover A09 off. STREAM-02 14f75db7 not compiled as DUT.
// G_BYTES LSB-first: char0 at [7:0]; extract bytes[8*bi +: 8] only.
// PASS marker only if FAIL=0 AND unseen SRO gold hits AND fill-template control hits
// AND unbound does not emit {120,121,122} AND SEARCH_INCOMPLETE absent on gold_n>=1 retrieve.
// Gold miss on retrieve class = FAIL (incomp does not hide).
// Headline precision_all=TP/emit_n.
// MEM_DEPTH TB-only; FIRST_DIVERGENCE MEM if directory does not fit.
`timescale 1ns / 1ps

module tb_astra_c1_semantic_unseen_sro;
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
  logic [15:0] k0_cx, k1_cx, k2_cx, k3_cx;
  logic v0_cx, v1_cx, v2_cx, v3_cx, ctx_valid_cx;

  integer i, bi, qi, timeout, n_got, fail;
  integer n_host, nrel, incomp, n_miss;
  integer tp, fp_ev1, fp_fill0, den_ev1, prec_ev1_x1000, prec_all_x1000, rec_x1000;
  integer dir_bytes, post_bytes, disc_bytes;
  integer unrelated_empty, fill_n, fill_tp, unseen_tp, unbound_empty, unbound_no_leak;
  integer incomp_retrieve, fill_ids_ok;
  integer arlen_bad, leak_n, is_grid;
  logic [ID_W-1:0] got [0:31];
  logic found;

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

  a7ng_query_role_keys_ctx u_cx_qse (
    .subj_id_i(subj),
    .obj_id_i(obj),
    .rel_id_i(rel),
    .ctx_id_i(ctx),
    .k0_i(k0), .k1_i(k1),
    .k0_valid_i(v0), .k1_valid_i(v1),
    .k2_valid_i(v2), .k3_valid_i(v3),
    .k0_o(k0_cx), .k1_o(k1_cx), .k2_o(k2_cx), .k3_o(k3_cx),
    .k0_valid_o(v0_cx), .k1_valid_o(v1_cx),
    .k2_valid_o(v2_cx), .k3_valid_o(v3_cx),
    .ctx_valid_o(ctx_valid_cx)
  );

  a7ng_query_axi_sparse_intersect_context #(
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
      0: cname = "fill_template";
      1: cname = "unseen_sro";
      2: cname = "unbound_sro";
      3: cname = "unrelated";
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
      while (!q_done) begin
        @(posedge clk);
        if (arvalid && arready) begin
          if (araddr < DIR_LO || (araddr > DIR_HI && araddr < POST_HEAP))
            diverge("HIDDEN_FULL_SCAN", $sformatf("AR=%h", araddr));
          if (arlen != 8'd0)
            arlen_bad = arlen_bad + 1;
        end
        if (cand_v && cand_ready) begin
          if (n_got >= 32) diverge("CANDIDATE_ID_MISMATCH", "got overflow");
          got[n_got] = cand_id;
          n_got = n_got + 1;
        end
        timeout = timeout + 1;
        if (timeout > 200000) diverge("AXI_PROTOCOL_ERROR", "TIMEOUT");
      end
      @(posedge clk);
      if (arlen_bad != 0)
        diverge("AXI_PROTOCOL_ERROR", $sformatf("page_buffer_not_1_beat arlen_nz=%0d", arlen_bad));
    end
  endtask

  initial begin
    fail = 0;
    unrelated_empty = 0;
    fill_n = 0;
    fill_tp = 0;
    unseen_tp = 0;
    unbound_empty = 0;
    unbound_no_leak = 0;
    incomp_retrieve = 0;
    fill_ids_ok = 0;
    rst_n = 0;
    tok_v = 0; tok = 0; fire = 0; retire = 0;
    sp_tok_v = 0; sp_tok = 0; sp_fire = 0; sp_retire = 0; poke_v = 0;
    cand_ready = 1; live_epoch = 16'd7;
    pk0 = 0; pk1 = 0; pk2 = 0; pk3 = 0;
    pv0 = 0; pv1 = 0; pv2 = 0; pv3 = 0;
    if (G_N != 256)
      diverge("N_DROP", "G_N!=256 registered this bag");
    if (CAND_CAP >= G_N)
      diverge("SELECTIVITY_TAUTOLOGY", "CAND_CAP>=N");
    if (G_N_BUCKETS != 4096)
      diverge("DIR_WIDTH", "G_N_BUCKETS!=4096");
    if (MEM_DEPTH < (6144 + 4 * G_N_BUCKETS))
      diverge("MEM", "MEM_DEPTH too small for 4*4096 directory");
    if (G_UNSEEN_Q != 1)
      diverge("UNSEEN_IDX", "G_UNSEEN_Q!=1");
    if (G_UNBOUND_Q != 2)
      diverge("UNBOUND_IDX", "G_UNBOUND_Q!=2");
    if (G_UNRELATED_Q != 3)
      diverge("UNRELATED_IDX", "G_UNRELATED_Q!=3");
    if (G_UNSEEN_NID != 20'd123)
      diverge("UNSEEN_NID", "G_UNSEEN_NID!=123");
    if (G_FILL_GRID[0] != 20'd120 || G_FILL_GRID[1] != 20'd121 || G_FILL_GRID[2] != 20'd122)
      diverge("FILL_GRID", "G_FILL_GRID!={120,121,122}");
    for (i = 0; i < MEM_DEPTH; i = i + 1)
      u_mem.mem[i] = '0;
    repeat (8) @(posedge clk);
    rst_n = 1;
    repeat (4) @(posedge clk);
    for (i = 0; i < G_N_WR; i = i + 1) begin
      if (G_WR_I[i] >= MEM_DEPTH)
        diverge("MEM", $sformatf("write idx %0d >= MEM_DEPTH", G_WR_I[i]));
      u_mem.mem[G_WR_I[i]] = G_WR_D[i];
    end
    repeat (2) @(posedge clk);

    n_host = h_ent|h_int|h_hash|h_sh|h_bkt|h_cand|h_win|h_addr|h_rel|h_nxt|h_ans;
    if (n_host != 0) diverge("HOST_SEMANTIC_LEAK", "qse reset");
    if (poke_v !== 1'b0) diverge("HOST_SEMANTIC_LEAK", "poke_v!=0");

    $display("C1_SEMANTIC_UNSEEN_SRO_N=%0d N_BUCKETS=%0d CAND_CAP=%0d INDEX_HEAD=%0d LAW=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-16k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN MEM_DEPTH=%0d N_SUBJECTS=%0d N_RELS=%0d UNSEEN_SRO=1 FILL_GRID=120,121,122 UNSEEN_NID=123",
      G_N, G_N_BUCKETS, CAND_CAP, G_INDEX_HEAD, MEM_DEPTH, G_N_SUBJECTS, G_N_RELS);

    for (qi = 0; qi < G_NQ; qi = qi + 1) begin
      feed_qse(G_LEN[qi], G_BYTES[qi]);
      wait_qse();
      if (subj !== G_SUBJ[qi] || obj !== G_OBJ[qi] || rel !== G_REL[qi] || ctx !== G_CTX[qi])
        diverge("ROLE_COLLAPSE", $sformatf("q=%0d %s subj/obj/rel/ctx %0d %0d %0d %0d",
          qi, cname(qi), subj, obj, rel, ctx));
      if (k0 !== G_K0_PLAIN[qi] || k1 !== G_K1_PLAIN[qi])
        diverge("KEY_MISMATCH", $sformatf("q=%0d %s frozen k0k1 %h %h", qi, cname(qi), k0, k1));
      if (k0_cx !== G_K0[qi] || k1_cx !== G_K1[qi] || k2_cx !== G_K2[qi] || k3_cx !== G_K3[qi])
        diverge("KEY_MISMATCH", $sformatf("q=%0d %s ctx k %h %h %h %h", qi, cname(qi), k0_cx, k1_cx, k2_cx, k3_cx));
      if (ctx_valid_cx !== G_CTX_VALID[qi])
        diverge("KEY_MISMATCH", $sformatf("q=%0d %s ctx_valid %0d", qi, cname(qi), ctx_valid_cx));
      if (v0 !== G_V0[qi] || v1 !== G_V1[qi] || v2 !== G_V2[qi] || v3 !== G_V3[qi])
        diverge("VALIDITY_MISMATCH", $sformatf("q=%0d %s", qi, cname(qi)));
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

      if (qi == G_UNBOUND_Q) begin
        leak_n = 0;
        for (i = 0; i < n_got; i = i + 1) begin
          is_grid = 0;
          if (got[i] === G_FILL_GRID[0] || got[i] === G_FILL_GRID[1] || got[i] === G_FILL_GRID[2])
            is_grid = 1;
          if (is_grid) leak_n = leak_n + 1;
        end
        if (leak_n > 0) begin
          $display("FAIL UNBOUND_FILL_GRID_LEAK leak_n=%0d emit_n=%0d", leak_n, n_got);
          fail = fail + 1;
          unbound_no_leak = 0;
        end else begin
          unbound_no_leak = 1;
        end
      end

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
      incomp = 0;

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
        if (incomp)
          $display("SEARCH_INCOMPLETE class=%s missed=%0d (incomp does not hide gold miss)",
            cname(qi), n_miss);
      end else if (incomp) begin
        $display("SEARCH_INCOMPLETE class=%s gold_hit=1 trunc=%0d ovf=%0d q_incomp=%0d",
          cname(qi), n_trunc, q_ovf, q_incomp);
      end
      if (incomp && nrel >= 1)
        incomp_retrieve = 1;

      dir_bytes = n_dir * 16;
      post_bytes = n_post * 16;
      disc_bytes = n_dup * 4;

      if (qi == 0) begin
        fill_n = n_got;
        fill_tp = tp;
        if (fill_tp < 1) begin
          $display("FAIL FILL_TEMPLATE_GOLD_MISS tp=0");
          fail = fail + 1;
        end else begin
          $display("FILL_TEMPLATE_HIT tp=%0d emit_n=%0d", fill_tp, n_got);
        end
        fill_ids_ok = (n_got == 3);
        for (i = 0; i < n_got; i = i + 1)
          if (got[i] !== G_FILL_GRID[i]) fill_ids_ok = 0;
        if (!fill_ids_ok) begin
          $display("FAIL FILL_TEMPLATE_EMIT_NOT_FILL_GRID n=%0d", n_got);
          fail = fail + 1;
        end
      end
      if (qi == G_UNSEEN_Q) begin
        unseen_tp = tp;
        found = 1'b0;
        for (i = 0; i < n_got; i = i + 1)
          if (got[i] === G_UNSEEN_NID) found = 1'b1;
        if (unseen_tp < 1 || !found) begin
          $display("FAIL UNSEEN_SRO_GOLD_MISS tp=%0d nid=%0d", unseen_tp, G_UNSEEN_NID);
          fail = fail + 1;
        end else begin
          $display("UNSEEN_SRO_HIT tp=%0d emit_n=%0d nid=%0d", unseen_tp, n_got, G_UNSEEN_NID);
        end
        if (k0_cx === G_K0[0] && k1_cx === G_K1[0])
          diverge("KEY_MISMATCH", "unseen keys identical to fill-grid");
      end
      if (qi == G_UNBOUND_Q) begin
        if (n_got == 0) begin
          $display("UNBOUND_EMPTY_WALK gold_n=%0d emit_n=0", nrel);
          unbound_empty = 1;
        end else begin
          $display("UNBOUND_NONEMPTY emit_n=%0d (ok if not fill-grid; FAIL already if leak)", n_got);
          unbound_empty = 0;
        end
        if (k0_cx !== G_K0[0])
          diverge("KEY_MISMATCH", "unbound k0 does not share fill-grid k0");
        if (k1_cx === G_K1[0])
          diverge("KEY_MISMATCH", "unbound k1 identical to fill-grid");
      end

      if (qi == G_UNRELATED_Q) begin
        if (n_got != 0)
          diverge("CANDIDATE_ID_MISMATCH", "unrelated emit!=0");
        $display("CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=%0d emit_n=0 tp=0 fp_ev1=0 fp_fill0=0", nrel);
        unrelated_empty = 1;
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

      @(posedge clk); sp_retire <= 1'b1;
      @(posedge clk); sp_retire <= 1'b0;
      @(posedge clk);
    end

    $display("HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic");
    if (fail == 0 && unrelated_empty && (fill_tp > 0) && fill_ids_ok && (unseen_tp > 0) && unbound_empty && unbound_no_leak && (incomp_retrieve == 0)) begin
      $display("ASTRA_C1_SEMANTIC_UNSEEN_SRO_XSIM_PASS");
      $display("NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,PAGE_SKIP_MIX,N_16384_MASS,N_65536");
      $display("C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO");
      $display("REDUCTION_X1000=NOT_EMITTED");
    end else begin
      $display("ASTRA_C1_SEMANTIC_UNSEEN_SRO_XSIM_NO_MARKER fail=%0d unrelated_empty=%0d fill_tp=%0d fill_ids_ok=%0d unseen_tp=%0d unbound_empty=%0d unbound_no_leak=%0d incomp_retrieve=%0d",
        fail, unrelated_empty, fill_tp, fill_ids_ok, unseen_tp, unbound_empty, unbound_no_leak, incomp_retrieve);
      $display("NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,PAGE_SKIP_MIX,N_16384_MASS,N_65536");
      $display("C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO");
      $display("REDUCTION_X1000=NOT_EMITTED");
    end
    #20 $finish;
  end
endmodule
