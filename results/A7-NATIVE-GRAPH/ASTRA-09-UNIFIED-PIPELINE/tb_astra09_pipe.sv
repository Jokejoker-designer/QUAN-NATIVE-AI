// tb_astra09_pipe.sv — one connected path, bytes in, no host subj/obj/winner poke. PROGRAM=NO.
`timescale 1ns / 1ps

module tb_astra09_pipe;
  `include "query_cases.svh"

  logic clk, rst_n, freeze, tok_v, tok_r, fire, retire, load_v, clr_v;
  logic load_trans, load_pol, busy, result_v, pkt_v, trip, two, k0v, k1v;
  logic skip, out_v, out_done;
  logic [7:0] tok, subj, obj, rel, ctx, ans, p0, p1, out_tok, ntok;
  logic [3:0] lidx, cidx;
  logic [7:0] ls, lr, lo, leid;
  logic [1:0] dirn;
  logic [15:0] k0, k1;
  logic [2:0] st;
  logic signed [15:0] vq8;
  logic [15:0] h_ent, h_int, h_hash, h_sh, h_bkt, h_cand, h_win, h_addr, h_rel, h_nxt, h_ans;
  integer fail, bi, tmo, nh;

  a7ng_astra09_pipe dut (
    .clk(clk), .rst_n(rst_n), .freeze_i(freeze),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .load_v(load_v), .load_idx(lidx),
    .load_s(ls), .load_r(lr), .load_o(lo), .load_eid(leid),
    .load_trans(load_trans), .load_pol(load_pol),
    .clr_v(clr_v), .clr_idx(cidx),
    .busy_o(busy), .result_v_o(result_v), .pkt_valid_o(pkt_v),
    .subj_id_o(subj), .obj_id_o(obj), .rel_id_o(rel), .ctx_id_o(ctx),
    .direction_o(dirn), .triple_valid_o(trip), .two_hop_o(two),
    .k0_o(k0), .k1_o(k1), .k0_valid_o(k0v), .k1_valid_o(k1v),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1), .status_o(st), .v_q8_o(vq8),
    .out_tok_v_o(out_v), .out_tok_o(out_tok), .out_done_o(out_done),
    .n_out_tok_o(ntok), .eng_skip_o(skip),
    .n_host_entity_o(h_ent), .n_host_intent_o(h_int), .n_host_hash_o(h_hash),
    .n_host_shard_o(h_sh), .n_host_bucket_o(h_bkt), .n_host_cand_o(h_cand),
    .n_host_winner_o(h_win), .n_host_addr_o(h_addr), .n_host_relpath_o(h_rel),
    .n_host_next_o(h_nxt), .n_host_answer_o(h_ans)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

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
        if (tmo > 8000) diverge("TIMEOUT", "result");
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

  task automatic check(
    input string name,
    input logic [7:0] es, eo, er, ecx,
    input logic [15:0] ek0, ek1,
    input logic etwo, etrip, eskip,
    input logic [2:0] est,
    input logic [7:0] eans, ep0, ep1
  );
    begin
      wait_res();
      nh = host_or();
      $display("CASE %s subj=%0d obj=%0d rel=%0d ctx=%0d k0=%0d k1=%0d two=%0d trip=%0d st=%0d ans=%0d p0=%0d p1=%0d skip=%0d vq8=%0d nhost=%0d ntok=%0d",
        name, subj, obj, rel, ctx, k0, k1, two, trip, st, ans, p0, p1, skip, vq8, nh, ntok);
      if (subj !== es || obj !== eo || rel !== er || ctx !== ecx)
        diverge("ROLE_COLLAPSE", name);
      if (k0 !== ek0 || k1 !== ek1)
        diverge("KEY_MISMATCH", name);
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
      retire_res();
    end
  endtask

  initial begin
    fail = 0;
    rst_n = 0; freeze = 1; tok_v = 0; tok = 0; fire = 0; retire = 0;
    load_v = 0; clr_v = 0; load_trans = 0; load_pol = 1;
    lidx = 0; cidx = 0; ls = 0; lr = 0; lo = 0; leid = 0;
    repeat (6) @(posedge clk);
    rst_n = 1;
    repeat (4) @(posedge clk);

    if (host_or() != 16'd0) diverge("HOST_SEMANTIC_LEAK", "reset");

    load_e(0, A9_PUMP, A9_REL_REQ, A9_CHILLER, A9_E_AB, 1);
    load_e(1, A9_CHILLER, A9_REL_REQ, A9_COMP, A9_E_BC, 1);
    load_e(2, A9_PUMP, A9_REL_SUP, A9_CHILLER, A9_E_S0, 0);
    load_e(3, A9_CHILLER, A9_REL_SUP, A9_COND, A9_E_S1, 0);

    feed(C1_FWD_N, C1_FWD_B);
    check("C1_FWD", C1_FWD_SUBJ, C1_FWD_OBJ, C1_FWD_REL, C1_FWD_CTX,
      C1_FWD_K0, C1_FWD_K1, C1_FWD_TWO, C1_FWD_TRIP, C1_FWD_SKIP,
      C1_FWD_ST, C1_FWD_ANS, C1_FWD_P0, C1_FWD_P1);

    feed(C1_REV_N, C1_REV_B);
    check("C1_REV", C1_REV_SUBJ, C1_REV_OBJ, C1_REV_REL, C1_REV_CTX,
      C1_REV_K0, C1_REV_K1, C1_REV_TWO, C1_REV_TRIP, C1_REV_SKIP,
      C1_REV_ST, C1_REV_ANS, C1_REV_P0, C1_REV_P1);

    if (C1_FWD_K0 === C1_REV_K0 && C1_FWD_SUBJ === C1_REV_SUBJ)
      diverge("ROLE_COLLAPSE", "fwd/rev gold identical");

    feed(C1_NTRANS_N, C1_NTRANS_B);
    check("C1_NTRANS", C1_NTRANS_SUBJ, C1_NTRANS_OBJ, C1_NTRANS_REL, C1_NTRANS_CTX,
      C1_NTRANS_K0, C1_NTRANS_K1, C1_NTRANS_TWO, C1_NTRANS_TRIP, C1_NTRANS_SKIP,
      C1_NTRANS_ST, C1_NTRANS_ANS, C1_NTRANS_P0, C1_NTRANS_P1);
    if (st === 3'd0) diverge("NTRANS", "supplies 2hop claimed ANSWER");

    feed(C2_1HOP_N, C2_1HOP_B);
    check("C2_1HOP", C2_1HOP_SUBJ, C2_1HOP_OBJ, C2_1HOP_REL, C2_1HOP_CTX,
      C2_1HOP_K0, C2_1HOP_K1, C2_1HOP_TWO, C2_1HOP_TRIP, C2_1HOP_SKIP,
      C2_1HOP_ST, C2_1HOP_ANS, C2_1HOP_P0, C2_1HOP_P1);

    feed(C3_2HOP_N, C3_2HOP_B);
    check("C3_2HOP", C3_2HOP_SUBJ, C3_2HOP_OBJ, C3_2HOP_REL, C3_2HOP_CTX,
      C3_2HOP_K0, C3_2HOP_K1, C3_2HOP_TWO, C3_2HOP_TRIP, C3_2HOP_SKIP,
      C3_2HOP_ST, C3_2HOP_ANS, C3_2HOP_P0, C3_2HOP_P1);

    feed(C3_NO_AC_N, C3_NO_AC_B);
    check("C3_NO_AC", C3_NO_AC_SUBJ, C3_NO_AC_OBJ, C3_NO_AC_REL, C3_NO_AC_CTX,
      C3_NO_AC_K0, C3_NO_AC_K1, C3_NO_AC_TWO, C3_NO_AC_TRIP, C3_NO_AC_SKIP,
      C3_NO_AC_ST, C3_NO_AC_ANS, C3_NO_AC_P0, C3_NO_AC_P1);
    if (C3_NO_AC_ST === 3'd0) diverge("EXAM_PAIR_STORED", "A→C 1hop ANSWER");

    feed(C4_UNREL_N, C4_UNREL_B);
    check("C4_UNREL", C4_UNREL_SUBJ, C4_UNREL_OBJ, C4_UNREL_REL, C4_UNREL_CTX,
      C4_UNREL_K0, C4_UNREL_K1, C4_UNREL_TWO, C4_UNREL_TRIP, C4_UNREL_SKIP,
      C4_UNREL_ST, C4_UNREL_ANS, C4_UNREL_P0, C4_UNREL_P1);

    clr_e(1);
    feed(C5_MISS_N, C5_MISS_B);
    check("C5_MISS", C5_MISS_SUBJ, C5_MISS_OBJ, C5_MISS_REL, C5_MISS_CTX,
      C5_MISS_K0, C5_MISS_K1, C5_MISS_TWO, C5_MISS_TRIP, C5_MISS_SKIP,
      C5_MISS_ST, C5_MISS_ANS, C5_MISS_P0, C5_MISS_P1);
    if (ans === A9_COMP) diverge("CAUSAL", "delete kept compressor");

    feed(C6_REV1_N, C6_REV1_B);
    check("C6_REV1", C6_REV1_SUBJ, C6_REV1_OBJ, C6_REV1_REL, C6_REV1_CTX,
      C6_REV1_K0, C6_REV1_K1, C6_REV1_TWO, C6_REV1_TRIP, C6_REV1_SKIP,
      C6_REV1_ST, C6_REV1_ANS, C6_REV1_P0, C6_REV1_P1);
    if (ans === A9_CHILLER) diverge("WRONGDIR", "kept old object chiller");

    feed(C6_REV2_N, C6_REV2_B);
    check("C6_REV2", C6_REV2_SUBJ, C6_REV2_OBJ, C6_REV2_REL, C6_REV2_CTX,
      C6_REV2_K0, C6_REV2_K1, C6_REV2_TWO, C6_REV2_TRIP, C6_REV2_SKIP,
      C6_REV2_ST, C6_REV2_ANS, C6_REV2_P0, C6_REV2_P1);
    if (ans === A9_PUMP) diverge("WRONGDIR", "2hop reverse kept pump");

    $display("ASTRA09_UNIFIED_XSIM_PASS");
    $display("NOT_CLAIMED=board,nlu,gate14,ddr800k,lm_language");
    $display("LM06_CLASS=LANGUAGE_UNPROVEN");
    #20 $finish;
  end
endmodule
