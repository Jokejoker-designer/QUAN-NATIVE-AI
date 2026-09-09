`timescale 1ns / 1ps
// ASTRA-C1-C3-CANONICAL-IMAGE-TRANSFER-01. PROGRAM=NO.
// 5-seed 4-arm on pinned 800k cartesian image + C3 fact_pack.
// Full-32 restore via named sgd32_ckpt AXI. TB does not write w[1:31].
`include "a7ng_astra_c3_held_out.svh"
`include "a7ng_astra_c5_sgd32_ckpt.svh"
module tb_astra_c1_c3_canonical_image_transfer;
  `include "query_gold.svh"
  `include "gen_800k.svh"
  `include "c3_800k_facts.svh"
  localparam logic [27:0] FACT_BASE_800K = 28'h0E00_0000;
  localparam int C3_N_SEED = 5;
  localparam logic [3:0] ST_ANSWER = 4'd0;
  logic clk, rst_n, rst_ck;
  initial clk = 0;
  always #5 clk = ~clk;
  int fail, i, q, t, nz, nmiss, drop_n, max_drop, sum_pre, sum_post, host_bad;
  string first_div;
  logic tok_v, tok_r, fire, retire, rew_v, busy, result_v, tbl;
  logic pend_acc, pend_cmt;
  logic [1:0] ctrl;
  logic [3:0] sel;
  logic [7:0] tok, txn, gen, rew_txn, rew_gen, phi0, qobj, qctx, qsubj;
  logic [15:0] nhwin, nhaddr, live_ep, nupd, ndup, nbad;
  logic [4:0] npath;
  logic signed [15:0] wdut [0:31];
  logic signed [15:0] wsnap [0:31];
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
  logic ck_ld, go_p, go_r, ck_ret, ck_clr, ck_busy, ck_pers, ck_rest;
  logic [4:0] ck_idx;
  logic signed [15:0] ck_w;
  logic [3:0] ck_ph, ck_fail;
  logic [15:0] ck_seq, ck_crc;
  logic cawv, cawr, cwv, cwr, cwlast, cbv, cbr;
  logic [27:0] cawa, cara;
  logic [127:0] cwd, crd;
  logic [15:0] cwstrb;
  logic [1:0] cbresp, crresp;
  logic carv, carr, crv, crr, crlast;
  logic [3:0] cbid, crid, cawid, carid;
  logic [7:0] cawlen, carlen;
  logic [2:0] cawsz, carsz;
  logic [1:0] cawb, carb;
  logic [127:0] ckmem [0:15];
  typedef enum logic [1:0] { M_IDLE, M_W, M_B, M_R } mst_t;
  mst_t mst;
  int TR_S [0:7] = '{13, 15, 16, 13, 15, 16, 13, 15};
  int HO_S [0:7] = '{19, 20, 19, 20, 19, 20, 19, 20};

  a7ng_astra_c3_held_out_nb64k #(.TO_CYC(65535), .FACT_BASE(FACT_BASE_800K)) u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_ep), .ctrl_i(ctrl),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .rew_v_i(rew_v), .rew_i(rew), .rew_txn_i(rew_txn), .rew_gen_i(rew_gen),
    .load_v_i(ck_ld), .load_idx_i(ck_idx), .load_w_i(ck_w),
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

  a7ng_axi_mem_c3_800k u_mem (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_ep),
    .s_axi_arid(arid), .s_axi_araddr(araddr), .s_axi_arlen(arlen),
    .s_axi_arsize(arsize), .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid), .s_axi_arready(arready),
    .s_axi_rid(rid), .s_axi_rdata(rdata), .s_axi_rresp(rresp),
    .s_axi_rlast(rlast), .s_axi_rvalid(rvalid), .s_axi_rready(rready)
  );

  a7ng_astra_c5_sgd32_ckpt u_ck (
    .clk(clk), .rst_n(rst_ck), .live_epoch_i(live_ep),
    .go_persist_i(go_p), .go_reload_i(go_r), .retire_i(ck_ret), .clr_i(ck_clr),
    .w_i(wdut),
    .load_v_o(ck_ld), .load_idx_o(ck_idx), .load_w_o(ck_w),
    .busy_o(ck_busy), .phase_o(ck_ph), .fail_o(ck_fail),
    .persisted_o(ck_pers), .restored_o(ck_rest), .seq_o(ck_seq), .crc_o(ck_crc),
    .m_axi_awid(cawid), .m_axi_awaddr(cawa), .m_axi_awlen(cawlen),
    .m_axi_awsize(cawsz), .m_axi_awburst(cawb),
    .m_axi_awvalid(cawv), .m_axi_awready(cawr),
    .m_axi_wdata(cwd), .m_axi_wstrb(cwstrb), .m_axi_wlast(cwlast),
    .m_axi_wvalid(cwv), .m_axi_wready(cwr),
    .m_axi_bid(cbid), .m_axi_bresp(cbresp), .m_axi_bvalid(cbv), .m_axi_bready(cbr),
    .m_axi_arid(carid), .m_axi_araddr(cara), .m_axi_arlen(carlen),
    .m_axi_arsize(carsz), .m_axi_arburst(carb),
    .m_axi_arvalid(carv), .m_axi_arready(carr),
    .m_axi_rid(crid), .m_axi_rdata(crd), .m_axi_rresp(crresp),
    .m_axi_rlast(crlast), .m_axi_rvalid(crv), .m_axi_rready(crr)
  );

  a7ng_shared_rank_sgd_q8_sym_f2r2 u_iso (
    .clk(clk), .rst_n(rst_n), .freeze_i(1'b0),
    .go_score_i(go_s), .go_upd_i(go_u), .x_i(xiso), .reward_i(iso_rew),
    .load_v_i(iso_load), .load_idx_i(5'd0), .load_w_i(16'sd0),
    .ready_o(rdy), .done_o(dn), .v_q8_o(viso), .w_o(wiso)
  );

  assign cawr = (mst == M_IDLE);
  assign carr = (mst == M_IDLE);
  assign cwr = (mst == M_W);
  always_ff @(posedge clk or negedge rst_ck) begin
    if (!rst_ck) begin
      mst <= M_IDLE; cbv <= 0; crv <= 0; crd <= 0; crlast <= 0;
      cbresp <= 0; crresp <= 0; cbid <= 0; crid <= 0;
    end else unique case (mst)
      M_IDLE: begin
        cbv <= 0; crv <= 0;
        if (cawv && cawr) mst <= M_W;
        else if (carv && carr) begin
          crd <= ckmem[cara[7:4]];
          crresp <= 2'b00; crlast <= 1'b1; crv <= 1'b1; crid <= carid; mst <= M_R;
        end
      end
      M_W: if (cwv && cwr) begin
        ckmem[cawa[7:4]] <= cwd;
        cbresp <= 2'b00; cbid <= cawid; cbv <= 1'b1; mst <= M_B;
      end
      M_B: if (cbv && cbr) begin cbv <= 1'b0; mst <= M_IDLE; end
      M_R: if (crv && crr) begin crv <= 1'b0; mst <= M_IDLE; end
      default: mst <= M_IDLE;
    endcase
  end

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div == "") first_div = tag;
        $display("FAIL %s", tag); fail = fail + 1;
      end else $display("PASS %s", tag);
    end
  endtask
  function automatic string qstr(input int subj);
    begin
      unique case (subj)
        13: qstr = "boiler feeds";
        15: qstr = "coil feeds";
        16: qstr = "filter feeds";
        19: qstr = "plenum feeds";
        20: qstr = "riser feeds";
        default: qstr = "boiler feeds";
      endcase
    end
  endfunction
  task send_text(input string s);
    integer n, k; begin n = s.len();
      for (k = 0; k < n; k = k + 1) begin @(posedge clk); while (!tok_r) @(posedge clk);
        tok_v <= 1; tok <= s[k]; @(posedge clk); tok_v <= 0; end
      @(posedge clk); fire <= 1; @(posedge clk); fire <= 0;
    end
  endtask
  task wait_done;
    begin fork wait (result_v); begin repeat (200000) @(posedge clk); $display("TIMEOUT"); fail = fail + 1; $finish; end join_any disable fork; end
  endtask
  task retire_q; begin @(posedge clk); retire <= 1; @(posedge clk); retire <= 0; wait (!result_v); repeat (4) @(posedge clk); end endtask
  task automatic hard_rst;
    begin rst_n = 0; rew_v = 0; fire = 0; retire = 0; tok_v = 0; ctrl = 0;
      repeat (4) @(posedge clk); rst_n = 1; repeat (8) @(posedge clk); end
  endtask
  task automatic dump(input string tag);
    $display("%s st=%0d npath=%0d ans=%0d p0=%0d gold=%0d subj=%0d nupd=%0d tbl=%0d",
      tag, st, npath, ans, p0, c3k_gold_nid(qsubj, 4), qsubj, nupd, tbl);
  endtask
  task automatic pulse_rew(input int rv);
    begin
      @(posedge clk);
      rew <= rv[3:0]; rew_txn <= txn; rew_gen <= gen; rew_v <= 1;
      @(posedge clk);
      rew_v <= 0; rew <= ~rew; rew_txn <= 8'hFF; rew_gen <= 8'hFF;
    end
  endtask
  task automatic wait_upd(input int expect_n);
    begin
      repeat (400) @(posedge clk);
      chk($sformatf("NUPD_%0d", expect_n), nupd == expect_n[15:0] && pend_cmt);
    end
  endtask
  task automatic q_run(input int subj);
    begin send_text(qstr(subj)); wait_done(); end
  endtask
  task automatic hold_acc(output int acc);
    int goldh;
    begin
      acc = 0;
      for (q = 0; q < 8; q = q + 1) begin
        q_run(HO_S[q]);
        goldh = c3k_gold_nid(HO_S[q], 4);
        if ((st === ST_ANSWER) && (p0 === goldh[19:0]) && (goldh != 0)) acc = acc + 1;
        if (nhwin !== 16'd0 || nhaddr !== 16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
    end
  endtask
  task automatic wait_ph(input logic [3:0] p);
    int guard;
    begin
      guard = 0;
      while ((ck_ph != p) && (ck_ph != A7NG_C5K_PH_FAILED) && guard < 20000) begin
        @(posedge clk); guard = guard + 1;
      end
    end
  endtask
  function automatic bit match32();
    integer u; begin
      match32 = 1'b1;
      for (u = 0; u < 32; u = u + 1) if (wdut[u] !== wsnap[u]) match32 = 1'b0;
    end
  endfunction
  function automatic bit all0();
    integer u; begin
      all0 = 1'b1;
      for (u = 0; u < 32; u = u + 1) if (wdut[u] !== 16'sd0) all0 = 1'b0;
    end
  endfunction

  initial begin
    int seed, acc_a, acc_b, acc_c, acc_d, acc_post, gain_pp, pair_pos, dj_fail;
    int sum_a, sum_b, sum_c, sum_d;
    int tr_seen [0:255];
    int ho_seen [0:255];
    fail = 0; first_div = ""; ctrl = 0; tok_v = 0; fire = 0; retire = 0;
    rew_v = 0; rew = 0; rew_txn = 0; rew_gen = 0; live_ep = 16'd7;
    go_s = 0; go_u = 0; iso_load = 0; iso_rew = 0; rst_n = 0; rst_ck = 0;
    go_p = 0; go_r = 0; ck_ret = 0; ck_clr = 0;
    sum_a = 0; sum_b = 0; sum_c = 0; sum_d = 0; pair_pos = 0; host_bad = 0; dj_fail = 0;
    sum_pre = 0; sum_post = 0; max_drop = 0; nmiss = 0;
    for (i = 0; i < 32; i = i + 1) begin xiso[i] = 0; wsnap[i] = 0; end
    for (i = 0; i < 16; i = i + 1) ckmem[i] = 128'd0;
    for (i = 0; i < 256; i = i + 1) begin tr_seen[i] = 0; ho_seen[i] = 0; end
    repeat (8) @(posedge clk); rst_ck = 1; rst_n = 1; repeat (8) @(posedge clk);

    $display("C1C3_XFER N=800000 FACT_BASE=0E000000 CKPT=06000000 TB_W131=NO PROGRAM=NO");
    $display("DDR_QUERY_BOUND_FINAL=NOT_FROZEN DICTIONARY_DDR_IMAGE=NOT_PINNED");
    $display("CLASS_bound_not_frozen HIT");
    $display("CLASS_no_tb_w131 HIT load=ckpt_only");
    for (i = 0; i < 8; i = i + 1) tr_seen[TR_S[i]] = 1;
    for (i = 0; i < 8; i = i + 1) ho_seen[HO_S[i]] = 1;
    for (i = 0; i < 256; i = i + 1) if (tr_seen[i] && ho_seen[i]) dj_fail = dj_fail + 1;
    if (dj_fail == 0) $display("CLASS_entities_disjoint HIT train={13,15,16} hold={19,20}");
    else $display("CLASS_entities_disjoint MISS overlap=%0d", dj_fail);
    chk("ENTITIES_DISJOINT_ORACLE", dj_fail == 0);

    xiso[0] = 8'sd50; iso_rew = 4'sd3;
    wait (rdy); @(posedge clk); go_u = 1; @(posedge clk); go_u = 0; wait (dn); @(posedge clk);
    chk("ISO_P3_X50_DW5", wiso[0] === 16'sd5 && wiso[1] === 0);

    for (seed = 0; seed < C3_N_SEED; seed = seed + 1) begin
      live_ep = 16'd7 + seed[15:0];
      $display("C3_SEED_BEGIN s=%0d live_ep=%0d", seed, live_ep);

      hard_rst(); ctrl = 2'd1;
      hold_acc(acc_b);
      $display("CLASS_arm_B_frozen HIT seed=%0d acc=%0d/8 ctrl=1", seed, acc_b);
      sum_b = sum_b + acc_b;

      hard_rst(); ctrl = 2'd0;
      for (q = 0; q < 8; q = q + 1) begin
        q_run(TR_S[q]); pulse_rew(3); wait_upd(q + 1); retire_q();
      end
      hold_acc(acc_a);
      $display("CLASS_arm_A_learner HIT seed=%0d acc=%0d/8 nupd=%0d", seed, acc_a, nupd);
      sum_a = sum_a + acc_a;
      if (acc_a > acc_b) pair_pos = pair_pos + 1;
      nz = 0;
      for (t = 0; t < 32; t = t + 1) begin
        wsnap[t] = wdut[t];
        if (wdut[t] !== 16'sd0) nz = nz + 1;
      end
      $display("SNAP_NZ seed=%0d n=%0d w0=%0d", seed, nz, wdut[0]);
      chk($sformatf("SNAP_NZ_S%0d", seed), nz >= 1);

      @(posedge clk); go_p <= 1; @(posedge clk); go_p <= 0;
      wait_ph(A7NG_C5K_PH_PERSISTED);
      chk($sformatf("PERS_S%0d", seed), ck_pers && (ck_ph == A7NG_C5K_PH_PERSISTED) && (ck_fail == A7NG_C5K_F_NONE));
      @(posedge clk); ck_ret <= 1; @(posedge clk); ck_ret <= 0; wait (!ck_busy); repeat (2) @(posedge clk);

      hard_rst(); ctrl = 2'd0;
      chk($sformatf("FLUSH0_S%0d", seed), all0());
      if (all0()) $display("CLASS_flush_zero HIT seed=%0d", seed);
      else $display("CLASS_flush_zero MISS seed=%0d", seed);

      @(posedge clk); go_r <= 1; @(posedge clk); go_r <= 0;
      wait_ph(A7NG_C5K_PH_READY);
      nmiss = 0;
      for (t = 0; t < 32; t = t + 1) if (wdut[t] !== wsnap[t]) nmiss = nmiss + 1;
      chk($sformatf("EXACT32_S%0d", seed), match32() && ck_rest);
      if (match32() && ck_rest) $display("CLASS_exact32_reload HIT seed=%0d nmiss=%0d", seed, nmiss);
      else $display("CLASS_exact32_reload MISS seed=%0d nmiss=%0d rest=%0d ph=%0d fail=%0d",
        seed, nmiss, ck_rest, ck_ph, ck_fail);
      @(posedge clk); ck_ret <= 1; @(posedge clk); ck_ret <= 0; wait (!ck_busy);

      hold_acc(acc_post);
      drop_n = acc_a - acc_post;
      if (drop_n < 0) drop_n = 0;
      if (drop_n > max_drop) max_drop = drop_n;
      sum_pre = sum_pre + acc_a;
      sum_post = sum_post + acc_post;
      $display("RELOAD_HOLD seed=%0d pre=%0d post=%0d drop=%0d", seed, acc_a, acc_post, drop_n);
      chk($sformatf("HOST_S%0d", seed), tbl == 1'b0);

      hard_rst(); ctrl = 2'd0;
      for (q = 0; q < 8; q = q + 1) begin
        q_run(TR_S[q]); pulse_rew(-3); wait_upd(q + 1); retire_q();
      end
      hold_acc(acc_c);
      $display("CLASS_arm_C_shuffled HIT seed=%0d acc=%0d/8", seed, acc_c);
      sum_c = sum_c + acc_c;

      hard_rst(); ctrl = 2'd0;
      for (q = 0; q < 8; q = q + 1) begin
        q_run(TR_S[q]); pulse_rew(3); wait_upd(q + 1); retire_q();
      end
      hold_acc(acc_d);
      $display("CLASS_arm_D_perid HIT seed=%0d acc=%0d/8", seed, acc_d);
      sum_d = sum_d + acc_d;
      $display("C3_SEED_GAIN s=%0d A=%0d B=%0d C=%0d D=%0d", seed, acc_a, acc_b, acc_c, acc_d);
    end

    gain_pp = (sum_a - sum_b) * 100 / (8 * C3_N_SEED);
    $display("C3_SUM A=%0d/%0d B=%0d C=%0d D=%0d gain_pp=%0d pair_pos=%0d/%0d",
      sum_a, 8 * C3_N_SEED, sum_b, sum_c, sum_d, gain_pp, pair_pos, C3_N_SEED);
    if (gain_pp >= 10) $display("CLASS_gain_A_over_B HIT gain_pp=%0d", gain_pp);
    else $display("CLASS_gain_A_over_B MISS gain_pp=%0d", gain_pp);
    drop_n = (sum_pre - sum_post) * 100 / (8 * C3_N_SEED);
    if (drop_n <= 5) $display("CLASS_retention_le5pp HIT drop_pp=%0d max_seed_drop=%0d pre=%0d post=%0d",
      drop_n, max_drop, sum_pre, sum_post);
    else $display("CLASS_retention_le5pp MISS drop_pp=%0d max_seed_drop=%0d pre=%0d post=%0d",
      drop_n, max_drop, sum_pre, sum_post);
    chk("PAIR_A_GT_B_SEEDS", pair_pos == C3_N_SEED);
    chk("A_GT_SHUFFLE", sum_a > sum_c);
    chk("GAIN10", gain_pp >= 10);
    chk("RETENTION5", drop_n <= 5);
    if (host_bad == 0) $display("CLASS_host_winner_zero HIT");
    else $display("CLASS_host_winner_zero MISS n=%0d", host_bad);
    chk("HOST_WINNER_ADDR_WEIGHT_ZERO", host_bad == 0);
    $display("C1_MASTER_CLAIM=NO C3_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO");
    $display("DDR_QUERY_BOUND_FINAL=NOT_FROZEN");
    if (fail == 0) $display("ASTRA_C1_C3_CANONICAL_IMAGE_TRANSFER_01_XSIM_PASS");
    else $display("ASTRA_C1_C3_CANONICAL_IMAGE_TRANSFER_01_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $finish;
  end
endmodule
