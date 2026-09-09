// tb_astra03_role_query.sv — qse-v2-role-00 packets + walker. PROGRAM=NO.
`timescale 1ns / 1ps

module tb_astra03_role_query;
  import a7ng_pkg::*;
  `include "query_gold.svh"

  localparam int unsigned ID_W = 20;
  localparam int unsigned CAND_CAP = 16;
  localparam int unsigned MEM_DEPTH = 32768;
  localparam logic [27:0] POST_HEAP = 28'h05040000;
  localparam logic [27:0] DIR_LO = 28'h05000000;
  localparam logic [27:0] DIR_HI = 28'h0503FFF0;

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

  logic v1_tok_v, v1_tok_r, v1_fire, v1_retire, v1_busy, v1_acc, v1_valid;
  logic [7:0] v1_tok, v1_eid, v1_iid, v1_rid, v1_xid;
  logic [63:0] v1_ec, v1_ic, v1_rc, v1_xc;
  logic [15:0] v1_crc, v1_k0, v1_k1, v1_k2, v1_k3;
  logic v1_v0, v1_v1, v1_v2, v1_v3;
  logic [15:0] v1_h0, v1_h1, v1_h2, v1_h3, v1_h4, v1_h5, v1_h6, v1_h7, v1_h8, v1_h9, v1_h10;

  logic sp_tok_v, sp_tok_r, sp_fire, sp_retire, poke_v;
  logic qse_valid, qse_busy, qse_acc;
  logic [7:0] sp_tok, sp_eid, sp_iid, sp_rid, sp_xid;
  logic [15:0] sp_k0, sp_k1, sp_k2, sp_k3, n_host_any, live_epoch;
  logic sp_v0, sp_v1, sp_v2, sp_v3;
  logic walk_ready, cand_v, cand_ready, q_done, q_ovf;
  logic [15:0] n_emit, n_dup, n_trunc, n_dir, n_post;
  logic [3:0] pmask;
  logic [ID_W-1:0] cand_id;
  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst; logic arvalid, arready;
  logic [3:0] ridb; logic [127:0] rdata; logic [1:0] rresp;
  logic rlast, rvalid, rready;
  logic [15:0] pk0, pk1, pk2, pk3;
  logic pv0, pv1, pv2, pv3;

  integer i, bi, qi, pi, timeout, n_got, fail;
  integer n_host;
  logic [15:0] hold_k0_a [0:31];
  logic [15:0] hold_k1_a [0:31];
  logic [15:0] hold_k0_b [0:31];
  logic [15:0] hold_k1_b [0:31];
  logic [7:0]  hold_s_a [0:31];
  logic [7:0]  hold_o_a [0:31];
  logic [ID_W-1:0] got [0:31];
  logic [15:0] v1_ab_k0, v1_ab_k1, v1_ab_k2, v1_ab_k3;

  a7ng_query_role_extract u_v2 (
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

  a7ng_query_struct_extract u_v1 (
    .clk(clk), .rst_n(rst_n),
    .tok_valid_i(v1_tok_v), .tok_ready_o(v1_tok_r), .tok_i(v1_tok),
    .fire_i(v1_fire), .retire_i(v1_retire),
    .busy_o(v1_busy), .accepted_o(v1_acc), .valid_o(v1_valid),
    .entity_id_o(v1_eid), .intent_id_o(v1_iid), .relation_id_o(v1_rid), .context_id_o(v1_xid),
    .entity_cue_o(v1_ec), .intent_cue_o(v1_ic), .relation_cue_o(v1_rc), .context_cue_o(v1_xc),
    .crc16_dbg_o(v1_crc), .k0_o(v1_k0), .k1_o(v1_k1), .k2_o(v1_k2), .k3_o(v1_k3),
    .k0_valid_o(v1_v0), .k1_valid_o(v1_v1), .k2_valid_o(v1_v2), .k3_valid_o(v1_v3),
    .n_host_entity_o(v1_h0), .n_host_intent_o(v1_h1), .n_host_hash_o(v1_h2),
    .n_host_shard_o(v1_h3), .n_host_bucket_o(v1_h4), .n_host_cand_o(v1_h5),
    .n_host_winner_o(v1_h6), .n_host_addr_o(v1_h7), .n_host_relpath_o(v1_h8),
    .n_host_next_o(v1_h9), .n_host_answer_o(v1_h10)
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

  a7ng_query_axi_sparse #(
    .N_TABLES(4), .N_BUCKETS(4096), .CAND_CAP(CAND_CAP),
    .ID_W(ID_W), .INDEX_BASE(NG_DDR_INDEX_BASE), .LAW_SEL(1)
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
    .n_host_any_o(n_host_any),
    .walk_ready_o(walk_ready),
    .cand_v(cand_v), .cand_ready(cand_ready), .cand_id(cand_id),
    .q_done(q_done), .q_overflow_o(q_ovf),
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

  task automatic diverge(input string code, input string d);
    begin
      $display("FIRST_DIVERGENCE %s %s", code, d);
      fail = fail + 1;
      #20 $finish;
    end
  endtask

  task automatic feed_v2(input int n, input logic [8*48-1:0] bytes);
    begin
      for (bi = 0; bi < n; bi = bi + 1) begin
        @(posedge clk);
        tok_v <= 1'b1;
        tok   <= bytes[8*bi +: 8];
        @(posedge clk);
        if (!tok_r) diverge("KEY_MISMATCH", "V2_NOT_READY");
        tok_v <= 1'b0;
      end
      @(posedge clk); fire <= 1'b1;
      @(posedge clk); fire <= 1'b0;
    end
  endtask

  task automatic feed_v1(input int n, input logic [8*48-1:0] bytes);
    begin
      for (bi = 0; bi < n; bi = bi + 1) begin
        @(posedge clk);
        v1_tok_v <= 1'b1;
        v1_tok   <= bytes[8*bi +: 8];
        @(posedge clk);
        if (!v1_tok_r) diverge("KEY_MISMATCH", "V1_NOT_READY");
        v1_tok_v <= 1'b0;
      end
      @(posedge clk); v1_fire <= 1'b1;
      @(posedge clk); v1_fire <= 1'b0;
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

  task automatic wait_v2;
    begin
      timeout = 0;
      while (!valid) begin
        @(posedge clk);
        timeout = timeout + 1;
        if (timeout > 64) diverge("KEY_MISMATCH", "V2_NO_VALID");
      end
    end
  endtask

  task automatic wait_v1;
    begin
      timeout = 0;
      while (!v1_valid) begin
        @(posedge clk);
        timeout = timeout + 1;
        if (timeout > 64) diverge("KEY_MISMATCH", "V1_NO_VALID");
      end
    end
  endtask

  task automatic observe_walk;
    begin
      n_got = 0; timeout = 0; cand_ready = 1'b1;
      while (!q_done) begin
        @(posedge clk);
        if (arvalid && arready) begin
          if (araddr < DIR_LO || (araddr > DIR_HI && araddr < POST_HEAP))
            diverge("HIDDEN_FULL_SCAN", $sformatf("AR=%h", araddr));
        end
        if (cand_v && cand_ready) begin
          got[n_got] = cand_id;
          n_got = n_got + 1;
        end
        timeout = timeout + 1;
        if (timeout > 80000) diverge("AXI_PROTOCOL_ERROR", "TIMEOUT");
      end
      @(posedge clk);
    end
  endtask

  initial begin
    fail = 0;
    rst_n = 0;
    tok_v = 0; tok = 0; fire = 0; retire = 0;
    v1_tok_v = 0; v1_tok = 0; v1_fire = 0; v1_retire = 0;
    sp_tok_v = 0; sp_tok = 0; sp_fire = 0; sp_retire = 0; poke_v = 0;
    cand_ready = 1; live_epoch = 16'd7;
    pk0 = 0; pk1 = 0; pk2 = 0; pk3 = 0;
    pv0 = 0; pv1 = 0; pv2 = 0; pv3 = 0;
    for (i = 0; i < MEM_DEPTH; i = i + 1)
      u_mem.mem[i] = '0;
    repeat (8) @(posedge clk);
    rst_n = 1;
    repeat (4) @(posedge clk);
    for (i = 0; i < G_N_WR; i = i + 1)
      u_mem.mem[G_WR_I[i]] = G_WR_D[i];
    repeat (2) @(posedge clk);

    n_host = h_ent|h_int|h_hash|h_sh|h_bkt|h_cand|h_win|h_addr|h_rel|h_nxt|h_ans;
    if (n_host != 0) diverge("HOST_SEMANTIC_LEAK", "v2 reset");

    for (qi = 0; qi < G_N; qi = qi + 1) begin
      feed_v2(G_LEN[qi], G_BYTES[qi]);
      wait_v2();
      if (subj !== G_SUBJ[qi] || obj !== G_OBJ[qi] || rel !== G_REL[qi])
        diverge("ROLE_COLLAPSE", $sformatf("q=%0d subj/obj/rel %0d %0d %0d exp %0d %0d %0d",
          qi, subj, obj, rel, G_SUBJ[qi], G_OBJ[qi], G_REL[qi]));
      if (k0 !== G_K0[qi] || k1 !== G_K1[qi] || k2 !== G_K2[qi] || k3 !== G_K3[qi])
        diverge("KEY_MISMATCH", $sformatf("q=%0d k %h %h %h %h", qi, k0, k1, k2, k3));
      if (v0 !== G_V0[qi] || v1 !== G_V1[qi] || v2 !== G_V2[qi] || v3 !== G_V3[qi])
        diverge("VALIDITY_MISMATCH", $sformatf("q=%0d", qi));
      if (neg !== G_NEG[qi] || amb !== G_AMB[qi] || trip !== G_TRIP[qi])
        diverge("ROLE_COLLAPSE", $sformatf("q=%0d flags neg/amb/trip %0d %0d %0d", qi, neg, amb, trip));
      if (dir !== 2'd0) diverge("ROLE_COLLAPSE", "direction not as-written");
      n_host = h_ent|h_int|h_hash|h_sh|h_bkt|h_cand|h_win|h_addr|h_rel|h_nxt|h_ans;
      if (n_host != 0) diverge("HOST_SEMANTIC_LEAK", $sformatf("q=%0d", qi));
      $display("V2_Q %0d subj=%0d obj=%0d rel=%0d k0=%h k1=%h trip=%0d amb=%0d",
        qi, subj, obj, rel, k0, k1, trip, amb);
      @(posedge clk); retire <= 1'b1;
      @(posedge clk); retire <= 1'b0;
      @(posedge clk);
    end

    for (pi = 0; pi < G_N_PAIRS; pi = pi + 1) begin
      if (G_K0[G_PAIR_A[pi]] === G_K0[G_PAIR_B[pi]] &&
          G_K1[G_PAIR_A[pi]] === G_K1[G_PAIR_B[pi]] &&
          G_SUBJ[G_PAIR_A[pi]] === G_SUBJ[G_PAIR_B[pi]])
        diverge("ROLE_COLLAPSE", $sformatf("pair %0d identical gold", pi));
      $display("PAIR_DIFF_OK i=%0d subj %0d/%0d obj %0d/%0d k0 %h/%h",
        pi, G_SUBJ[G_PAIR_A[pi]], G_SUBJ[G_PAIR_B[pi]],
        G_OBJ[G_PAIR_A[pi]], G_OBJ[G_PAIR_B[pi]],
        G_K0[G_PAIR_A[pi]], G_K0[G_PAIR_B[pi]]);
    end

    feed_v1(G_V1_CLEN, G_V1_CBYTES);
    wait_v1();
    if (v1_eid !== G_V1_CEID) diverge("KEY_MISMATCH", $sformatf("v1 chiller eid %0d", v1_eid));
    if (v1_k0 !== G_V1_CK0 || v1_k1 !== G_V1_CK1 || v1_k2 !== G_V1_CK2 || v1_k3 !== G_V1_CK3)
      diverge("KEY_MISMATCH", $sformatf("v1 chiller k %h %h %h %h", v1_k0, v1_k1, v1_k2, v1_k3));
    if (v1_v0 !== G_V1_CV0 || v1_v1 !== G_V1_CV1 || v1_v2 !== G_V1_CV2 || v1_v3 !== G_V1_CV3)
      diverge("VALIDITY_MISMATCH", "v1 chiller valid");
    if (v1_h0|v1_h1|v1_h2|v1_h3|v1_h4|v1_h5|v1_h6|v1_h7|v1_h8|v1_h9|v1_h10)
      diverge("HOST_SEMANTIC_LEAK", "v1 chiller");
    $display("V1_SMOKE_CHILLER eid=%0d k0=%h k2=%h n_host=0", v1_eid, v1_k0, v1_k2);
    @(posedge clk); v1_retire <= 1'b1;
    @(posedge clk); v1_retire <= 1'b0;
    @(posedge clk);

    feed_v1(G_V1_ABLEN, G_V1_ABBYTES);
    wait_v1();
    if (v1_k0 !== G_V1_ABK0 || v1_k1 !== G_V1_ABK1 || v1_k2 !== G_V1_ABK2 || v1_k3 !== G_V1_ABK3)
      diverge("KEY_MISMATCH", "v1 ab keys");
    v1_ab_k0 = v1_k0; v1_ab_k1 = v1_k1; v1_ab_k2 = v1_k2; v1_ab_k3 = v1_k3;
    @(posedge clk); v1_retire <= 1'b1;
    @(posedge clk); v1_retire <= 1'b0;
    @(posedge clk);
    feed_v1(G_V1_BALEN, G_V1_BABYTES);
    wait_v1();
    if (v1_k0 !== v1_ab_k0 || v1_k1 !== v1_ab_k1 || v1_k2 !== v1_ab_k2 || v1_k3 !== v1_ab_k3)
      diverge("KEY_MISMATCH", "v1 control did not collapse");
    $display("V1_CONTROL_ROLE_COLLAPSE k0=%h k1=%h k2=%h k3=%h", v1_k0, v1_k1, v1_k2, v1_k3);
    @(posedge clk); v1_retire <= 1'b1;
    @(posedge clk); v1_retire <= 1'b0;
    @(posedge clk);

    for (qi = 0; qi < G_N; qi = qi + 1) begin
      while (!walk_ready) @(posedge clk);
      feed_sp(G_LEN[qi], G_BYTES[qi]);
      timeout = 0;
      while (!qse_valid) begin
        @(posedge clk);
        timeout = timeout + 1;
        if (timeout > 64) diverge("KEY_MISMATCH", "SP_NO_VALID");
      end
      if (sp_k0 !== G_K0[qi] || sp_k1 !== G_K1[qi] || sp_k2 !== G_K2[qi] || sp_k3 !== G_K3[qi])
        diverge("KEY_MISMATCH", $sformatf("sparse q=%0d", qi));
      if (n_host_any != 0) diverge("HOST_SEMANTIC_LEAK", "sparse");
      observe_walk();
      if (n_got != G_NEMIT[qi] || n_emit != G_NEMIT[qi])
        diverge("CANDIDATE_ID_MISMATCH", $sformatf("q=%0d emit %0d exp %0d", qi, n_got, G_NEMIT[qi]));
      for (i = 0; i < n_got; i = i + 1)
        if (got[i] !== G_EMIT[qi][i])
          diverge("CANDIDATE_ID_MISMATCH", $sformatf("q=%0d i=%0d act=%0d exp=%0d", qi, i, got[i], G_EMIT[qi][i]));
      $display("WALK_Q %0d emit=%0d dir=%0d", qi, n_got, n_dir);
      @(posedge clk); sp_retire <= 1'b1;
      @(posedge clk); sp_retire <= 1'b0;
      @(posedge clk);
    end

    if (fail == 0) begin
      $display("ASTRA03_ROLE_AWARE_XSIM_PASS");
      $display("NOT_CLAIMED=open_nlu,board,Gate14,2hop");
    end
    #20 $finish;
  end
endmodule
