// tb_astra09_sparse.sv — tokens → LAW_SEL=1 sparse walk → 2-hop. PROGRAM=NO.
// No host subj/obj/winner poke. Walker plant IDs are not answers.
`timescale 1ns / 1ps

module tb_astra09_sparse;
  import a7ng_pkg::*;
  `include "query_cases.svh"

  localparam int unsigned MEM_DEPTH = 32768;
  localparam logic [27:0] POST_HEAP = 28'h05040000;
  localparam logic [27:0] DIR_LO = 28'h05000000;
  localparam logic [27:0] DIR_HI = 28'h0503FFF0;

  logic clk, rst_n, freeze, tok_v, tok_r, fire, retire, load_v, clr_v;
  logic load_trans, load_pol, busy, result_v, pkt_v, trip, two, k0v, k1v, k2v, k3v;
  logic skip, out_v, out_done;
  logic [7:0] tok, subj, obj, rel, ctx, ans, p0, p1, out_tok, ntok;
  logic [3:0] lidx, cidx, pmask;
  logic [7:0] ls, lr, lo, leid;
  logic [1:0] dirn;
  logic [15:0] k0, k1, k2, k3, live_epoch, ndir, npost, nemit;
  logic [2:0] st;
  logic signed [15:0] vq8;
  logic [15:0] h_ent, h_int, h_hash, h_sh, h_bkt, h_cand, h_win, h_addr, h_rel, h_nxt, h_ans;

  logic [3:0] arid;
  logic [27:0] araddr;
  logic [7:0] arlen;
  logic [2:0] arsize;
  logic [1:0] arburst;
  logic arvalid, arready, rlast, rvalid, rready;
  logic [3:0] ridb;
  logic [127:0] rdata;
  logic [1:0] rresp;

  integer fail, bi, tmo, nh, i, n_dar, n_par, n_valid;
  logic [27:0] dar [0:7];
  logic mon;

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

  a7ng_astra09_pipe dut (
    .clk(clk), .rst_n(rst_n), .freeze_i(freeze), .live_epoch_i(live_epoch),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .load_v(load_v), .load_idx(lidx),
    .load_s(ls), .load_r(lr), .load_o(lo), .load_eid(leid),
    .load_trans(load_trans), .load_pol(load_pol),
    .clr_v(clr_v), .clr_idx(cidx),
    .busy_o(busy), .result_v_o(result_v), .pkt_valid_o(pkt_v),
    .subj_id_o(subj), .obj_id_o(obj), .rel_id_o(rel), .ctx_id_o(ctx),
    .direction_o(dirn), .triple_valid_o(trip), .two_hop_o(two),
    .k0_o(k0), .k1_o(k1), .k2_o(k2), .k3_o(k3),
    .k0_valid_o(k0v), .k1_valid_o(k1v), .k2_valid_o(k2v), .k3_valid_o(k3v),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1), .status_o(st), .v_q8_o(vq8),
    .out_tok_v_o(out_v), .out_tok_o(out_tok), .out_done_o(out_done),
    .n_out_tok_o(ntok), .eng_skip_o(skip),
    .n_dir_ar_o(ndir), .n_post_ar_o(npost), .n_emit_o(nemit), .probed_mask_o(pmask),
    .n_host_entity_o(h_ent), .n_host_intent_o(h_int), .n_host_hash_o(h_hash),
    .n_host_shard_o(h_sh), .n_host_bucket_o(h_bkt), .n_host_cand_o(h_cand),
    .n_host_winner_o(h_win), .n_host_addr_o(h_addr), .n_host_relpath_o(h_rel),
    .n_host_next_o(h_nxt), .n_host_answer_o(h_ans),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(ridb), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  always @(posedge clk) begin
    if (mon && arvalid && arready) begin
      if (araddr >= POST_HEAP) begin
        n_par = n_par + 1;
      end else if (araddr >= DIR_LO && araddr <= DIR_HI) begin
        if (n_dar < 8)
          dar[n_dar] = araddr;
        n_dar = n_dar + 1;
      end else begin
        $display("FIRST_DIVERGENCE HIDDEN_FULL_SCAN AR=%h", araddr);
        fail = fail + 1;
        #20 $finish;
      end
    end
  end

  function automatic [15:0] host_or;
    host_or = h_ent | h_int | h_hash | h_sh | h_bkt | h_cand | h_win | h_addr | h_rel | h_nxt | h_ans;
  endfunction

  task automatic diverge(input string c, input string d);
    begin
      $display("FIRST_DIVERGENCE %s %s", c, d);
      fail = fail + 1;
      #20 $finish;
    end
  endtask

  task automatic feed(input int n, input logic [8*48-1:0] bytes);
    begin
      n_dar = 0; n_par = 0; mon = 1'b1;
      for (bi = 0; bi < n; bi = bi + 1) begin
        @(posedge clk);
        tok_v <= 1'b1;
        tok   <= bytes[8*bi +: 8];
        @(posedge clk);
        if (!tok_r) diverge("NOT_READY", "tok");
        tok_v <= 1'b0;
      end
      @(posedge clk);
      fire <= 1'b1;
      @(posedge clk);
      fire <= 1'b0;
    end
  endtask

  task automatic wait_res;
    begin
      tmo = 0;
      while (!result_v) begin
        @(posedge clk);
        tmo = tmo + 1;
        if (tmo > 20000) diverge("TIMEOUT", "result");
      end
    end
  endtask

  task automatic retire_res;
    begin
      @(posedge clk);
      retire <= 1'b1;
      @(posedge clk);
      retire <= 1'b0;
      tmo = 0;
      while (busy) begin
        @(posedge clk);
        tmo = tmo + 1;
        if (tmo > 200) diverge("TIMEOUT", "retire");
      end
      mon = 1'b0;
    end
  endtask

  task automatic load_e(
    input int idx, input int s, input int r, input int o, input int e,
    input int tr
  );
    begin
      while (busy) @(posedge clk);
      @(posedge clk);
      lidx <= idx[3:0];
      ls <= s[7:0]; lr <= r[7:0]; lo <= o[7:0]; leid <= e[7:0];
      load_trans <= tr[0]; load_pol <= 1'b1;
      load_v <= 1'b1;
      @(posedge clk);
      load_v <= 1'b0;
    end
  endtask

  task automatic clr_e(input int idx);
    begin
      while (busy) @(posedge clk);
      @(posedge clk);
      cidx <= idx[3:0];
      clr_v <= 1'b1;
      @(posedge clk);
      clr_v <= 1'b0;
    end
  endtask

  function automatic logic dir_ok(
    input logic [27:0] a,
    input logic [27:0] d0, d1, d2, d3
  );
    dir_ok = (a == d0 && d0 != 28'd0) || (a == d1 && d1 != 28'd0)
          || (a == d2 && d2 != 28'd0) || (a == d3 && d3 != 28'd0);
  endfunction

  task automatic check(
    input string name,
    input logic [7:0] es, eo, er, ecx,
    input logic [15:0] ek0, ek1, ek2, ek3,
    input logic ev0, ev1, ev2, ev3,
    input logic etwo, etrip, eskip,
    input logic [2:0] est,
    input logic [7:0] eans, ep0, ep1,
    input int endir, enem, enpost, envalid,
    input logic [3:0] epm,
    input logic [27:0] d0, d1, d2, d3,
    input int plant
  );
    begin
      wait_res();
      nh = host_or();
      n_valid = ev0 + ev1 + ev2 + ev3;
      $display("CASE %s subj=%0d obj=%0d rel=%0d ctx=%0d k0=%0d k1=%0d two=%0d trip=%0d st=%0d ans=%0d p0=%0d p1=%0d skip=%0d vq8=%0d nhost=%0d ndir=%0d nemit=%0d npost=%0d ntok=%0d pmask=%0d ndar=%0d npar=%0d",
        name, subj, obj, rel, ctx, k0, k1, two, trip, st, ans, p0, p1, skip, vq8, nh, ndir, nemit, npost, ntok, pmask, n_dar, n_par);
      if (subj !== es || obj !== eo || rel !== er || ctx !== ecx)
        diverge("ROLE_COLLAPSE", name);
      if (k0 !== ek0 || k1 !== ek1 || k2 !== ek2 || k3 !== ek3)
        diverge("KEY_MISMATCH", name);
      if (k0v !== ev0 || k1v !== ev1 || k2v !== ev2 || k3v !== ev3)
        diverge("VALIDITY_MISMATCH", name);
      if (two !== etwo || trip !== etrip || skip !== eskip)
        diverge("PACKET_FLAG", name);
      if (st !== est)
        diverge("STATUS", $sformatf("%s st=%0d exp=%0d", name, st, est));
      if (ans !== eans || p0 !== ep0 || p1 !== ep1)
        diverge("PROOF", $sformatf("%s ans/p %0d %0d %0d exp %0d %0d %0d",
          name, ans, p0, p1, eans, ep0, ep1));
      if (vq8 !== 16'sd0)
        diverge("RANK_FREEZE", $sformatf("%s v=%0d", name, vq8));
      if (nh !== 0)
        diverge("HOST_SEMANTIC_LEAK", name);
      if (dirn !== 2'd0)
        diverge("DIRECTION", name);
      if (ntok == 8'd0)
        diverge("NO_PROOF_BYTES", name);
      if (ndir !== endir[15:0] || nemit !== enem[15:0])
        diverge("WALK_COUNT", $sformatf("%s ndir=%0d exp=%0d nemit=%0d exp=%0d",
          name, ndir, endir, nemit, enem));
      if (ndir > envalid[15:0] || ndir > 16'd4)
        diverge("HIDDEN_FULL_SCAN", $sformatf("%s ndir=%0d nvalid=%0d", name, ndir, envalid));
      if (n_dar !== endir)
        diverge("HIDDEN_FULL_SCAN", $sformatf("%s ndar=%0d exp=%0d", name, n_dar, endir));
      if (n_dar > 4)
        diverge("HIDDEN_FULL_SCAN", $sformatf("%s ndar=%0d", name, n_dar));
      for (i = 0; i < n_dar; i = i + 1)
        if (!dir_ok(dar[i], d0, d1, d2, d3))
          diverge("HIDDEN_FULL_SCAN", $sformatf("%s AR=%h not in valid tables", name, dar[i]));
      if (pmask !== epm)
        diverge("WALK_MASK", $sformatf("%s pmask=%h exp=%h", name, pmask, epm));
      if (ans >= 8'd201)
        diverge("CANDIDATE_AS_ANSWER", $sformatf("%s ans=%0d plant=%0d", name, ans, plant));
      if (plant != 0 && ans == plant[7:0])
        diverge("CANDIDATE_AS_ANSWER", name);
      retire_res();
    end
  endtask

  initial begin
    fail = 0;
    rst_n = 0; freeze = 1; tok_v = 0; tok = 0; fire = 0; retire = 0;
    load_v = 0; clr_v = 0; load_trans = 0; load_pol = 1;
    lidx = 0; cidx = 0; ls = 0; lr = 0; lo = 0; leid = 0;
    live_epoch = 16'd7; mon = 0; n_dar = 0; n_par = 0;
    for (i = 0; i < MEM_DEPTH; i = i + 1)
      u_mem.mem[i] = '0;
    repeat (6) @(posedge clk);
    rst_n = 1;
    repeat (4) @(posedge clk);
    for (i = 0; i < G_N_WR; i = i + 1)
      u_mem.mem[G_WR_I[i]] = G_WR_D[i];
    repeat (2) @(posedge clk);

    if (host_or() != 16'd0) diverge("HOST_SEMANTIC_LEAK", "reset");

    load_e(0, A9_PUMP, A9_REL_REQ, A9_CHILLER, A9_E_AB, 1);
    load_e(1, A9_CHILLER, A9_REL_REQ, A9_COMP, A9_E_BC, 1);
    load_e(2, A9_PUMP, A9_REL_SUP, A9_CHILLER, A9_E_S0, 0);
    load_e(3, A9_CHILLER, A9_REL_SUP, A9_COND, A9_E_S1, 0);

    feed(C1_FWD_N, C1_FWD_B);
    check("C1_FWD", C1_FWD_SUBJ, C1_FWD_OBJ, C1_FWD_REL, C1_FWD_CTX,
      C1_FWD_K0, C1_FWD_K1, C1_FWD_K2, C1_FWD_K3,
      C1_FWD_K0V, C1_FWD_K1V, C1_FWD_K2V, C1_FWD_K3V,
      C1_FWD_TWO, C1_FWD_TRIP, C1_FWD_SKIP,
      C1_FWD_ST, C1_FWD_ANS, C1_FWD_P0, C1_FWD_P1,
      C1_FWD_NDIR, C1_FWD_NEMIT, C1_FWD_NPOST, C1_FWD_NVALID, C1_FWD_PMASK,
      C1_FWD_D0, C1_FWD_D1, C1_FWD_D2, C1_FWD_D3, C1_FWD_PLANT);

    feed(C1_REV_N, C1_REV_B);
    check("C1_REV", C1_REV_SUBJ, C1_REV_OBJ, C1_REV_REL, C1_REV_CTX,
      C1_REV_K0, C1_REV_K1, C1_REV_K2, C1_REV_K3,
      C1_REV_K0V, C1_REV_K1V, C1_REV_K2V, C1_REV_K3V,
      C1_REV_TWO, C1_REV_TRIP, C1_REV_SKIP,
      C1_REV_ST, C1_REV_ANS, C1_REV_P0, C1_REV_P1,
      C1_REV_NDIR, C1_REV_NEMIT, C1_REV_NPOST, C1_REV_NVALID, C1_REV_PMASK,
      C1_REV_D0, C1_REV_D1, C1_REV_D2, C1_REV_D3, C1_REV_PLANT);

    if (C1_FWD_K0 === C1_REV_K0 && C1_FWD_SUBJ === C1_REV_SUBJ)
      diverge("ROLE_COLLAPSE", "fwd/rev gold identical");
    if (C1_FWD_D0 === C1_REV_D0)
      diverge("ROLE_COLLAPSE", "fwd/rev dir0 identical");

    feed(C1_NTRANS_N, C1_NTRANS_B);
    check("C1_NTRANS", C1_NTRANS_SUBJ, C1_NTRANS_OBJ, C1_NTRANS_REL, C1_NTRANS_CTX,
      C1_NTRANS_K0, C1_NTRANS_K1, C1_NTRANS_K2, C1_NTRANS_K3,
      C1_NTRANS_K0V, C1_NTRANS_K1V, C1_NTRANS_K2V, C1_NTRANS_K3V,
      C1_NTRANS_TWO, C1_NTRANS_TRIP, C1_NTRANS_SKIP,
      C1_NTRANS_ST, C1_NTRANS_ANS, C1_NTRANS_P0, C1_NTRANS_P1,
      C1_NTRANS_NDIR, C1_NTRANS_NEMIT, C1_NTRANS_NPOST, C1_NTRANS_NVALID, C1_NTRANS_PMASK,
      C1_NTRANS_D0, C1_NTRANS_D1, C1_NTRANS_D2, C1_NTRANS_D3, C1_NTRANS_PLANT);
    if (st === 3'd0) diverge("NTRANS", "supplies 2hop claimed ANSWER");

    feed(C2_1HOP_N, C2_1HOP_B);
    check("C2_1HOP", C2_1HOP_SUBJ, C2_1HOP_OBJ, C2_1HOP_REL, C2_1HOP_CTX,
      C2_1HOP_K0, C2_1HOP_K1, C2_1HOP_K2, C2_1HOP_K3,
      C2_1HOP_K0V, C2_1HOP_K1V, C2_1HOP_K2V, C2_1HOP_K3V,
      C2_1HOP_TWO, C2_1HOP_TRIP, C2_1HOP_SKIP,
      C2_1HOP_ST, C2_1HOP_ANS, C2_1HOP_P0, C2_1HOP_P1,
      C2_1HOP_NDIR, C2_1HOP_NEMIT, C2_1HOP_NPOST, C2_1HOP_NVALID, C2_1HOP_PMASK,
      C2_1HOP_D0, C2_1HOP_D1, C2_1HOP_D2, C2_1HOP_D3, C2_1HOP_PLANT);

    feed(C3_2HOP_N, C3_2HOP_B);
    check("C3_2HOP", C3_2HOP_SUBJ, C3_2HOP_OBJ, C3_2HOP_REL, C3_2HOP_CTX,
      C3_2HOP_K0, C3_2HOP_K1, C3_2HOP_K2, C3_2HOP_K3,
      C3_2HOP_K0V, C3_2HOP_K1V, C3_2HOP_K2V, C3_2HOP_K3V,
      C3_2HOP_TWO, C3_2HOP_TRIP, C3_2HOP_SKIP,
      C3_2HOP_ST, C3_2HOP_ANS, C3_2HOP_P0, C3_2HOP_P1,
      C3_2HOP_NDIR, C3_2HOP_NEMIT, C3_2HOP_NPOST, C3_2HOP_NVALID, C3_2HOP_PMASK,
      C3_2HOP_D0, C3_2HOP_D1, C3_2HOP_D2, C3_2HOP_D3, C3_2HOP_PLANT);

    feed(C3_NO_AC_N, C3_NO_AC_B);
    check("C3_NO_AC", C3_NO_AC_SUBJ, C3_NO_AC_OBJ, C3_NO_AC_REL, C3_NO_AC_CTX,
      C3_NO_AC_K0, C3_NO_AC_K1, C3_NO_AC_K2, C3_NO_AC_K3,
      C3_NO_AC_K0V, C3_NO_AC_K1V, C3_NO_AC_K2V, C3_NO_AC_K3V,
      C3_NO_AC_TWO, C3_NO_AC_TRIP, C3_NO_AC_SKIP,
      C3_NO_AC_ST, C3_NO_AC_ANS, C3_NO_AC_P0, C3_NO_AC_P1,
      C3_NO_AC_NDIR, C3_NO_AC_NEMIT, C3_NO_AC_NPOST, C3_NO_AC_NVALID, C3_NO_AC_PMASK,
      C3_NO_AC_D0, C3_NO_AC_D1, C3_NO_AC_D2, C3_NO_AC_D3, C3_NO_AC_PLANT);
    if (C3_NO_AC_ST === 3'd0) diverge("EXAM_PAIR_STORED", "A→C 1hop ANSWER");

    feed(C4_UNREL_N, C4_UNREL_B);
    check("C4_UNREL", C4_UNREL_SUBJ, C4_UNREL_OBJ, C4_UNREL_REL, C4_UNREL_CTX,
      C4_UNREL_K0, C4_UNREL_K1, C4_UNREL_K2, C4_UNREL_K3,
      C4_UNREL_K0V, C4_UNREL_K1V, C4_UNREL_K2V, C4_UNREL_K3V,
      C4_UNREL_TWO, C4_UNREL_TRIP, C4_UNREL_SKIP,
      C4_UNREL_ST, C4_UNREL_ANS, C4_UNREL_P0, C4_UNREL_P1,
      C4_UNREL_NDIR, C4_UNREL_NEMIT, C4_UNREL_NPOST, C4_UNREL_NVALID, C4_UNREL_PMASK,
      C4_UNREL_D0, C4_UNREL_D1, C4_UNREL_D2, C4_UNREL_D3, C4_UNREL_PLANT);
    if (st === 3'd0) diverge("UNRELATED_ANSWER", "payroll ANSWER");
    if (nemit !== 16'd0 || ndir !== 16'd0) diverge("UNRELATED_ANSWER", "payroll walk");

    clr_e(1);
    feed(C5_MISS_N, C5_MISS_B);
    check("C5_MISS", C5_MISS_SUBJ, C5_MISS_OBJ, C5_MISS_REL, C5_MISS_CTX,
      C5_MISS_K0, C5_MISS_K1, C5_MISS_K2, C5_MISS_K3,
      C5_MISS_K0V, C5_MISS_K1V, C5_MISS_K2V, C5_MISS_K3V,
      C5_MISS_TWO, C5_MISS_TRIP, C5_MISS_SKIP,
      C5_MISS_ST, C5_MISS_ANS, C5_MISS_P0, C5_MISS_P1,
      C5_MISS_NDIR, C5_MISS_NEMIT, C5_MISS_NPOST, C5_MISS_NVALID, C5_MISS_PMASK,
      C5_MISS_D0, C5_MISS_D1, C5_MISS_D2, C5_MISS_D3, C5_MISS_PLANT);
    if (ans === A9_COMP) diverge("CAUSAL", "delete kept compressor");

    feed(C6_REV1_N, C6_REV1_B);
    check("C6_REV1", C6_REV1_SUBJ, C6_REV1_OBJ, C6_REV1_REL, C6_REV1_CTX,
      C6_REV1_K0, C6_REV1_K1, C6_REV1_K2, C6_REV1_K3,
      C6_REV1_K0V, C6_REV1_K1V, C6_REV1_K2V, C6_REV1_K3V,
      C6_REV1_TWO, C6_REV1_TRIP, C6_REV1_SKIP,
      C6_REV1_ST, C6_REV1_ANS, C6_REV1_P0, C6_REV1_P1,
      C6_REV1_NDIR, C6_REV1_NEMIT, C6_REV1_NPOST, C6_REV1_NVALID, C6_REV1_PMASK,
      C6_REV1_D0, C6_REV1_D1, C6_REV1_D2, C6_REV1_D3, C6_REV1_PLANT);
    if (ans === A9_CHILLER) diverge("WRONGDIR", "kept old object chiller");

    feed(C6_REV2_N, C6_REV2_B);
    check("C6_REV2", C6_REV2_SUBJ, C6_REV2_OBJ, C6_REV2_REL, C6_REV2_CTX,
      C6_REV2_K0, C6_REV2_K1, C6_REV2_K2, C6_REV2_K3,
      C6_REV2_K0V, C6_REV2_K1V, C6_REV2_K2V, C6_REV2_K3V,
      C6_REV2_TWO, C6_REV2_TRIP, C6_REV2_SKIP,
      C6_REV2_ST, C6_REV2_ANS, C6_REV2_P0, C6_REV2_P1,
      C6_REV2_NDIR, C6_REV2_NEMIT, C6_REV2_NPOST, C6_REV2_NVALID, C6_REV2_PMASK,
      C6_REV2_D0, C6_REV2_D1, C6_REV2_D2, C6_REV2_D3, C6_REV2_PLANT);
    if (ans === A9_PUMP) diverge("WRONGDIR", "2hop reverse kept pump");

    $display("ASTRA09_SPARSE_XSIM_PASS");
    $display("NOT_CLAIMED=board,nlu,gate14,ddr800k,lm_language,fullchip");
    $display("LM06_CLASS=LANGUAGE_UNPROVEN");
    $display("SPARSE_AXI=wired_law_sel_1");
    $display("V1_QSE_UNCHANGED=ede064f0");
    #20 $finish;
  end
endmodule
