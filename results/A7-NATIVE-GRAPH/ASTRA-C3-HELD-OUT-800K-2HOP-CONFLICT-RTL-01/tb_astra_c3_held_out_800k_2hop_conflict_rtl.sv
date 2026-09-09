`timescale 1ns / 1ps
// ASTRA-C3-HELD-OUT-800K-2HOP-CONFLICT-RTL-01. PROGRAM=NO. Bag-local TB.
// 5-seed 4-arm on 800k cartesian facts + ctx-folded k0 overlay, live CONFLICT C3 copy.
// Two positive dests must still rank. Not MIG. Not BOARD.
`include "a7ng_astra_c3_held_out.svh"
module tb_astra_c3_held_out_800k_2hop_conflict_rtl;
  `include "query_gold.svh"
  `include "gen_800k.svh"
  `include "c3_800k_facts.svh"
  `include "c3_800k_2hop.svh"
  localparam logic [27:0] FACT_BASE_800K = 28'h0E00_0000;
  localparam int C3_N_Q = 8;
  localparam int C3_N_SEED = 5;
  localparam logic [3:0] ST_ANSWER=4'd0;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  int fail, i, q;
  string first_div;
  logic tok_v, tok_r, fire, retire, rew_v, busy, result_v, tbl;
  logic pend_acc, pend_cmt, load_v;
  logic [1:0] ctrl;
  logic [3:0] sel;
  logic [7:0] tok, txn, gen, rew_txn, rew_gen, phi0, qobj, qctx, qsubj;
  logic [15:0] nhwin, nhaddr, live_ep, nupd, ndup, nbad;
  logic [4:0] load_idx, npath;
  logic signed [15:0] load_w, wdut [0:31];
  logic signed [3:0] rew;
  logic [19:0] ans, p0, p1;
  logic [3:0] st;
  logic signed [15:0] vbest, vsec;
  logic signed [7:0] pphi [0:31];
  logic go_s, go_u, rdy, dn, iso_load;
  logic signed [15:0] viso, wiso [0:31];
  logic signed [7:0] xiso [0:31];
  logic signed [3:0] iso_rew;
  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst;
  logic arvalid, arready, rready, rlast, rvalid;
  logic [3:0] rid; logic [127:0] rdata; logic [1:0] rresp;
    int TR_S [0:7] = '{13,15,16,13,15,16,13,15};
    int HO_S [0:7] = '{19,20,19,20,19,20,19,20};
    int twohop_ok, n_conf;

  a7ng_astra_c3_held_out_nb64k #(.TO_CYC(65535), .FACT_BASE(FACT_BASE_800K)) u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_ep), .ctrl_i(ctrl),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .rew_v_i(rew_v), .rew_i(rew), .rew_txn_i(rew_txn), .rew_gen_i(rew_gen),
    .load_v_i(load_v), .load_idx_i(load_idx), .load_w_i(load_w),
    .busy_o(busy), .result_v_o(result_v),
    .pend_acc_o(pend_acc), .pend_cmt_o(pend_cmt),
    .txn_id_o(txn), .gen_o(gen), .sel_idx_o(sel),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1),
    .n_path_o(npath), .status_o(st), .obj_o(qobj), .ctx_o(qctx),
    .subj_o(qsubj), .n_host_winner_o(nhwin), .n_host_addr_o(nhaddr),
    .v_best_o(vbest), .v_second_o(vsec), .phi0_o(phi0),
    .pend_phi_o(pphi), .w_o(wdut),
    .n_upd_o(nupd), .n_dup_o(ndup), .n_bad_o(nbad),
    .load_from_tb_o(tbl),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  a7ng_axi_mem_c3_800k_2hop u_mem (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_ep),
    .s_axi_arid(arid), .s_axi_araddr(araddr), .s_axi_arlen(arlen),
    .s_axi_arsize(arsize), .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid), .s_axi_arready(arready),
    .s_axi_rid(rid), .s_axi_rdata(rdata), .s_axi_rresp(rresp),
    .s_axi_rlast(rlast), .s_axi_rvalid(rvalid), .s_axi_rready(rready)
  );

  a7ng_shared_rank_sgd_q8_sym_f2r2 u_iso (
    .clk(clk), .rst_n(rst_n), .freeze_i(1'b0),
    .go_score_i(go_s), .go_upd_i(go_u), .x_i(xiso), .reward_i(iso_rew),
    .load_v_i(iso_load), .load_idx_i(5'd0), .load_w_i(16'sd0),
    .ready_o(rdy), .done_o(dn), .v_q8_o(viso), .w_o(wiso)
  );

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div=="") first_div=tag;
        $display("FAIL %s", tag); fail=fail+1;
      end else $display("PASS %s", tag);
    end
  endtask
  function automatic string qstr(input int subj);
    begin
      unique case (subj)
        13: qstr = "boiler feeds indirect";
        15: qstr = "coil feeds indirect";
        16: qstr = "filter feeds indirect";
        19: qstr = "plenum feeds indirect";
        20: qstr = "riser feeds indirect";
        default: qstr = "boiler feeds indirect";
      endcase
    end
  endfunction
  function automatic bit gold_hit();
    begin
      gold_hit = (st===ST_ANSWER)
              && (ans===C3K2_GOLD_DEST[19:0])
              && (p0===c3k2_gold_p0(qsubj)[19:0])
              && (p1===C3K2_GOLD_P1[19:0])
              && (qctx===A7NG_C3_CTX_INDIRECT);
    end
  endfunction
  task send_text(input string s);
    integer n,k; begin n=s.len();
      for(k=0;k<n;k=k+1) begin @(posedge clk); while(!tok_r) @(posedge clk);
        tok_v<=1; tok<=s[k]; @(posedge clk); tok_v<=0; end
      @(posedge clk); fire<=1; @(posedge clk); fire<=0;
    end
  endtask
  task wait_done;
    begin fork wait(result_v); begin repeat(200000) @(posedge clk); $display("TIMEOUT"); fail=fail+1; $finish; end join_any disable fork; end
  endtask
  task retire_q; begin @(posedge clk); retire<=1; @(posedge clk); retire<=0; wait(!result_v); repeat(4) @(posedge clk); end endtask
  task automatic hard_rst;
    begin rst_n=0; load_v=0; rew_v=0; fire=0; retire=0; tok_v=0; ctrl=0;
      repeat(4) @(posedge clk); rst_n=1; repeat(8) @(posedge clk); end
  endtask
  task automatic dump(input string tag);
    $display("%s st=%0d npath=%0d ans=%0d p0=%0d p1=%0d gold_p0=%0d subj=%0d obj=%0d ctx=%0d nupd=%0d tbl=%0d",
      tag, st, npath, ans, p0, p1, c3k2_gold_p0(qsubj), qsubj, qobj, qctx, nupd, tbl);
  endtask
  task automatic pulse_rew(input int rv);
    begin
      @(posedge clk);
      rew<=rv[3:0]; rew_txn<=txn; rew_gen<=gen; rew_v<=1;
      @(posedge clk);
      rew_v<=0; rew<=~rew; rew_txn<=8'hFF; rew_gen<=8'hFF;
    end
  endtask
  task automatic wait_upd(input int expect_n);
    begin
      repeat(400) @(posedge clk);
      chk($sformatf("NUPD_%0d", expect_n), nupd==expect_n[15:0] && pend_cmt);
    end
  endtask
  task automatic q_run(input int subj);
    begin
      send_text(qstr(subj));
      wait_done();
    end
  endtask

  initial begin
    int seed, acc_a, acc_b, acc_c, acc_d, gain_pp, pair_pos, host_bad, dj_fail;
    int sum_a, sum_b, sum_c, sum_d;
    int tr_seen [0:255];
    int ho_seen [0:255];
    fail=0; first_div=""; ctrl=0; tok_v=0; fire=0; retire=0;
    rew_v=0; rew=0; rew_txn=0; rew_gen=0; live_ep=16'd7;
    load_v=0; load_idx=0; load_w=0; twohop_ok=0; n_conf=0;
    go_s=0; go_u=0; iso_load=0; iso_rew=0; rst_n=0;
    sum_a=0; sum_b=0; sum_c=0; sum_d=0; pair_pos=0; host_bad=0; dj_fail=0;
    for(i=0;i<32;i=i+1) xiso[i]=0;
    for(i=0;i<256;i=i+1) begin tr_seen[i]=0; ho_seen[i]=0; end
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    $display("C3_800K_2HOP_CONFLICT_RTL N=800000 FACT_BASE=0E000000 CTX_K0_OVERLAY=1 TO_CYC=65535 TR={13,15,16} HO={19,20} PROGRAM=NO BOARD_PASS=REJECT");
    for (i=0;i<8;i=i+1) tr_seen[TR_S[i]] = 1;
    for (i=0;i<8;i=i+1) ho_seen[HO_S[i]] = 1;
    for (i=0;i<256;i=i+1) if (tr_seen[i] && ho_seen[i]) dj_fail = dj_fail + 1;
    if (dj_fail==0) $display("CLASS_entities_disjoint HIT train={13,15,16} hold={19,20}");
    else $display("CLASS_entities_disjoint MISS overlap=%0d", dj_fail);
    chk("ENTITIES_DISJOINT_ORACLE", dj_fail==0);

    xiso[0]=8'sd50; iso_rew=4'sd3;
    wait(rdy); @(posedge clk); go_u=1; @(posedge clk); go_u=0; wait(dn); @(posedge clk);
    $display("ISO_P3 w0=%0d viso=%0d", wiso[0], viso);
    chk("ISO_P3_X50_DW5", wiso[0]===16'sd5 && wiso[1]===0);

    for (seed=0; seed<C3_N_SEED; seed=seed+1) begin
      live_ep = 16'd7 + seed[15:0];
      $display("C3_SEED_BEGIN s=%0d live_ep=%0d", seed, live_ep);

      hard_rst(); ctrl=2'd1;
      acc_b=0;
      for (q=0;q<8;q=q+1) begin
        q_run(HO_S[q]);
        dump($sformatf("B_S%0d_Q%0d", seed, q));
        if ((qctx===A7NG_C3_CTX_INDIRECT) && (p1!==20'd0)) twohop_ok = twohop_ok + 1;
        if (st===A7NG_C3_ST_CONFLICT) n_conf = n_conf + 1;
        if (gold_hit()) acc_b = acc_b + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      $display("CLASS_arm_B_frozen HIT seed=%0d acc=%0d/8 ctrl=1", seed, acc_b);
      sum_b = sum_b + acc_b;

      hard_rst(); ctrl=2'd0;
      acc_a=0;
      for (q=0;q<8;q=q+1) begin
        q_run(TR_S[q]);
        pulse_rew(3); wait_upd(q+1); retire_q();
      end
      for (q=0;q<8;q=q+1) begin
        q_run(HO_S[q]);
        dump($sformatf("A_HO_S%0d_Q%0d", seed, q));
        if (gold_hit()) acc_a = acc_a + 1;
        if (st===A7NG_C3_ST_CONFLICT) n_conf = n_conf + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      $display("CLASS_arm_A_learner HIT seed=%0d acc=%0d/8 nupd=%0d", seed, acc_a, nupd);
      sum_a = sum_a + acc_a;
      if (acc_a > acc_b) pair_pos = pair_pos + 1;

      hard_rst(); ctrl=2'd0;
      acc_c=0;
      for (q=0;q<8;q=q+1) begin
        q_run(TR_S[q]);
        pulse_rew(-3); wait_upd(q+1); retire_q();
      end
      for (q=0;q<8;q=q+1) begin
        q_run(HO_S[q]);
        dump($sformatf("C_HO_S%0d_Q%0d", seed, q));
        if (gold_hit()) acc_c = acc_c + 1;
        if (st===A7NG_C3_ST_CONFLICT) n_conf = n_conf + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      $display("CLASS_arm_C_shuffled HIT seed=%0d acc=%0d/8", seed, acc_c);
      sum_c = sum_c + acc_c;

      hard_rst(); ctrl=2'd0;
      acc_d=0;
      for (q=0;q<8;q=q+1) begin
        q_run(TR_S[q]);
        pulse_rew(3); wait_upd(q+1); retire_q();
      end
      for (q=0;q<8;q=q+1) begin
        q_run(HO_S[q]);
        dump($sformatf("D_HO_S%0d_Q%0d", seed, q));
        if (gold_hit()) acc_d = acc_d + 1;
        if (st===A7NG_C3_ST_CONFLICT) n_conf = n_conf + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      $display("CLASS_arm_D_perid HIT seed=%0d acc=%0d/8", seed, acc_d);
      sum_d = sum_d + acc_d;

      $display("C3_SEED_GAIN s=%0d A=%0d B=%0d C=%0d D=%0d", seed, acc_a, acc_b, acc_c, acc_d);
    end

    gain_pp = (sum_a - sum_b) * 100 / (8*C3_N_SEED);
    $display("C3_SUM A=%0d/%0d B=%0d C=%0d D=%0d gain_pp=%0d pair_pos=%0d/%0d host_bad=%0d twohop_ctx=%0d n_conf=%0d",
      sum_a, 8*C3_N_SEED, sum_b, sum_c, sum_d, gain_pp, pair_pos, C3_N_SEED, host_bad, twohop_ok, n_conf);
    if (gain_pp >= 10) $display("CLASS_gain_A_over_B HIT gain_pp=%0d", gain_pp);
    else $display("CLASS_gain_A_over_B MISS gain_pp=%0d", gain_pp);
    if (host_bad==0) $display("CLASS_host_winner_zero HIT");
    else $display("CLASS_host_winner_zero MISS n=%0d", host_bad);
    if (twohop_ok==8*C3_N_SEED) $display("CLASS_two_hop_indirect HIT n=%0d", twohop_ok);
    else $display("CLASS_two_hop_indirect MISS n=%0d", twohop_ok);
    if (n_conf==0) $display("CLASS_no_false_conflict HIT n_conf=0");
    else $display("CLASS_no_false_conflict MISS n_conf=%0d", n_conf);
    chk("HOST_WINNER_ADDR_WEIGHT_ZERO", host_bad==0);
    chk("PAIR_A_GT_B_SEEDS", pair_pos==C3_N_SEED);
    chk("A_GT_SHUFFLE", sum_a > sum_c);
    chk("GAIN10", gain_pp>=10);
    chk("TWO_HOP_CTX_INDIRECT", twohop_ok==8*C3_N_SEED);
    chk("NO_FALSE_CONFLICT", n_conf==0);

    if (fail==0) $display("ASTRA_C3_HELD_OUT_800K_2HOP_CONFLICT_RTL_XSIM_PASS");
    else $display("ASTRA_C3_HELD_OUT_800K_2HOP_CONFLICT_RTL_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C3_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO quality=800K_CARTESIAN_2HOP_LIVE_CONFLICT_RTL_NOT_MIG");
    $finish;
  end
endmodule
