`timescale 1ns / 1ps
// ASTRA-C5-EXPLICIT-REWARD-AND-FULLSTATE-01A. PROGRAM=NO.
// Named rew top. Modeled AXI. Not BOARD. Does not close 01B.
`include "a7ng_astra_c5_prod_top_rew.svh"
`include "a7ng_astra_c5_ddr_arb.svh"
`include "a7ng_gate14_crc.svh"
`include "tb_oracles.svh"
module tb_astra_c5_explicit_reward_01a;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS = 96;
  localparam int CPB = (A7NG_C5P_CLK_HZ + A7NG_C5P_BAUD/2) / A7NG_C5P_BAUD;
  logic clk, rst_n, urx, utx;
  initial clk = 0;
  always #5 clk = ~clk;

  logic arvalid, arready, rvalid, rready;
  logic [27:0] araddr, awaddr, last_aw;
  logic [127:0] rdata, wdata;
  logic awvalid, awready, wvalid, wready, wlast, bvalid, bready;
  logic [15:0] wstrb;
  logic busy, done, dual, qid, a09, plant, c3res, pcmt, pacc, c3busy, pvalid, gdone, phit, ehas;
  logic [5:0] seen;
  logic [2:0] owner;
  logic [15:0] nsw, nblk, nhw, nht, imask, nurx, nutx, nupd, ndup, nbad;
  logic [15:0] nrok, ncrc, nsess, nrng, nfrz, nlen;
  logic [3:0] c3st, pph;
  logic [7:0] c3obj, glast, txn, gen;
  logic signed [15:0] pw0;
  logic signed [15:0] cw [0:31];

  logic [27:0] mk[0:SLOTS-1];
  logic [127:0] mv[0:SLOTS-1];
  logic mvld[0:SLOTS-1];
  int nslot, fail, i, guard, k;
  logic signed [15:0] snap [0:31];
  logic signed [15:0] snap2 [0:31];
  int nupd_a, ndup_a, nbad_a, ncrc_a, nfrz_a;
  string first_div;
  typedef enum logic [2:0] { M_IDLE, M_R, M_W, M_B } mst_t;
  mst_t mst;

  function automatic integer slot_of(input logic [27:0] a);
    integer s; begin slot_of = -1; for (s = 0; s < SLOTS; s = s + 1) if (mvld[s] && mk[s] == a) slot_of = s; end
  endfunction
  function automatic logic [127:0] mem_rd(input logic [27:0] a);
    integer s; begin s = slot_of(a); mem_rd = (s >= 0) ? mv[s] : 128'd0; end
  endfunction
  task automatic mem_wr(input logic [27:0] a, input logic [127:0] d);
    integer s; begin s = slot_of(a); if (s < 0) begin s = nslot; nslot = nslot + 1; end mk[s] = a; mv[s] = d; mvld[s] = 1; end
  endtask
  function automatic logic [127:0] dir_pack(input int count);
    dir_pack = {48'd0, 16'd7, 16'd0, count[15:0], 4'd0, POST_HEAP};
  endfunction
  function automatic logic [127:0] fact_pack(
      input int s, o, r, e, conf, trans, pol, fctx);
    fact_pack = {28'd0, conf[7:0], fctx[7:0], 4'd1, 1'b0, 1'b1, pol[0], trans[0],
                 e[19:0], r[7:0], o[19:0], s[19:0]};
  endfunction
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl * 65536 + (key & 12'hFFF) * 16;
  endfunction
  function automatic bit w_eq();
    integer t; begin
      w_eq = 1'b1;
      for (t = 0; t < 32; t = t + 1) if (cw[t] !== snap[t]) w_eq = 1'b0;
    end
  endfunction
  function automatic bit w_zero();
    integer t; begin
      w_zero = 1'b1;
      for (t = 0; t < 32; t = t + 1) if (cw[t] !== 16'sd0) w_zero = 1'b0;
    end
  endfunction
  task automatic snap_w;
    integer t; begin for (t = 0; t < 32; t = t + 1) snap[t] = cw[t]; end
  endtask
  task automatic snap2_w;
    integer t; begin for (t = 0; t < 32; t = t + 1) snap2[t] = cw[t]; end
  endtask

  assign arready = (mst == M_IDLE);
  assign awready = (mst == M_IDLE);
  assign wready  = (mst == M_W);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mst <= M_IDLE; rvalid <= 0; rdata <= 0; bvalid <= 0;
    end else unique case (mst)
      M_IDLE: begin
        bvalid <= 0; rvalid <= 0;
        if (awvalid && awready) mst <= M_W;
        else if (arvalid && arready) begin
          rvalid <= 1'b1; rdata <= mem_rd(araddr); mst <= M_R;
        end
      end
      M_R: if (rvalid && rready) begin rvalid <= 1'b0; mst <= M_IDLE; end
      M_W: if (wvalid && wready) begin mem_wr(awaddr, wdata); bvalid <= 1'b1; mst <= M_B; end
      M_B: if (bvalid && bready) begin bvalid <= 1'b0; mst <= M_IDLE; end
      default: mst <= M_IDLE;
    endcase
  end

  a7ng_astra_c5_prod_top_rew u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .uart_rx_i(urx), .uart_tx_o(utx),
    .m_arvalid_o(arvalid), .m_araddr_o(araddr), .m_arready_i(arready),
    .m_rvalid_i(rvalid), .m_rdata_i(rdata), .m_rready_o(rready),
    .m_awvalid_o(awvalid), .m_awaddr_o(awaddr), .m_awready_i(awready),
    .m_wvalid_o(wvalid), .m_wdata_o(wdata), .m_wlast_o(wlast), .m_wstrb_o(wstrb),
    .m_wready_i(wready),
    .m_bvalid_i(bvalid), .m_bready_o(bready),
    .busy_o(busy), .done_o(done),
    .seen_gnt_o(seen), .owner_o(owner), .dual_err_o(dual),
    .n_switch_o(nsw), .n_block_o(nblk),
    .n_host_winner_o(nhw), .n_host_tok_o(nht),
    .qid_map_o(qid), .a09_o(a09), .plant_dut_o(plant), .inst_mask_o(imask),
    .n_uart_rx_o(nurx), .n_uart_tx_o(nutx),
    .c3_status_o(c3st), .c3_obj_o(c3obj), .c3_result_v_o(c3res), .c3_pend_cmt_o(pcmt),
    .persist_valid_o(pvalid), .persist_w0_o(pw0), .persist_phase_o(pph),
    .gen_done_o(gdone), .gen_last_o(glast), .parser_hit_o(phit), .evid_has_o(ehas),
    .last_aw_o(last_aw),
    .c3_pend_acc_o(pacc), .c3_busy_o(c3busy),
    .c3_txn_o(txn), .c3_gen_o(gen),
    .c3_nupd_o(nupd), .c3_ndup_o(ndup), .c3_nbad_o(nbad),
    .c3_w_o(cw),
    .n_rew_ok_o(nrok), .n_rew_crc_o(ncrc), .n_rew_sess_o(nsess),
    .n_rew_range_o(nrng), .n_rew_frz_o(nfrz), .n_rew_len_o(nlen)
  );

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div == "") first_div = tag;
        $display("FAIL %s", tag); fail = fail + 1;
      end else $display("PASS %s", tag);
    end
  endtask
  task automatic uart_byte(input logic [7:0] d);
    integer b;
    begin
      urx = 1'b0; repeat (CPB) @(posedge clk);
      for (b = 0; b < 8; b = b + 1) begin
        urx = d[b]; repeat (CPB) @(posedge clk);
      end
      urx = 1'b1; repeat (CPB + 2) @(posedge clk);
    end
  endtask
  task automatic uart_str(input string s);
    integer u;
    begin
      for (u = 0; u < s.len(); u = u + 1) uart_byte(s[u]);
      uart_byte(A7NG_C5P_EOL);
    end
  endtask
  task automatic uart_rew(
      input logic [7:0] txi, input logic [7:0] gxi,
      input logic signed [7:0] sc, input bit bad_crc, input logic [15:0] sess);
    logic [7:0] bb [0:8];
    logic [15:0] c;
    integer u;
    begin
      bb[0] = A7NG_C5P_REW_PLEN;
      bb[1] = A7NG_C5P_REW_VER;
      bb[2] = sess[15:8];
      bb[3] = sess[7:0];
      bb[4] = txi;
      bb[5] = gxi;
      bb[6] = sc;
      c = 16'hFFFF;
      for (u = 1; u <= 6; u = u + 1) c = crc16_byte(c, bb[u]);
      if (bad_crc) c = c ^ 16'h0001;
      bb[7] = c[15:8];
      bb[8] = c[7:0];
      uart_byte(A7NG_C5P_CMD_REWARD);
      for (u = 0; u <= 8; u = u + 1) uart_byte(bb[u]);
      uart_byte(A7NG_C5P_EOL);
    end
  endtask
  task automatic wait_until_done;
    begin
      guard = 0;
      while (!done && guard < 200000) begin @(posedge clk); guard = guard + 1; end
      chk("NO_TIMEOUT", done && guard < 200000);
    end
  endtask
  task automatic wait_next_done;
    begin
      guard = 0;
      while (done && guard < 8000) begin @(posedge clk); guard = guard + 1; end
      wait_until_done();
    end
  endtask
  task automatic wait_nupd(input int want);
    begin
      guard = 0;
      while ((nupd != want[15:0]) && guard < 20000) begin @(posedge clk); guard = guard + 1; end
      chk("NUPD_WAIT", nupd == want[15:0] && guard < 20000);
    end
  endtask
  task automatic plant_index(input int nfact, input int k0, input int k1, input int k2);
    begin
      mem_wr(dir_addr(0, k0), dir_pack(nfact));
      mem_wr(dir_addr(1, k1), dir_pack(nfact));
      mem_wr(dir_addr(2, k2), dir_pack(nfact));
    end
  endtask
  task automatic plant_post8(
      input int e0, input int e1, input int e2, input int e3,
      input int e4, input int e5, input int e6, input int e7);
    logic [127:0] b0, b1;
    begin
      b0 = e3; b0 = (b0 << 32) | e2; b0 = (b0 << 32) | e1; b0 = (b0 << 32) | e0;
      b1 = e7; b1 = (b1 << 32) | e6; b1 = (b1 << 32) | e5; b1 = (b1 << 32) | e4;
      mem_wr(POST_HEAP, b0);
      mem_wr(POST_HEAP + 28'd16, b1);
    end
  endtask
  task automatic wr_f(input int e, s, o, r, conf, trans, pol, fctx);
    mem_wr(FACT_BASE + (e << 4), fact_pack(s, o, r, e, conf, trans, pol, fctx));
  endtask
  task automatic plant_train0;
    int subj, rel, k0, k1, k2, g0, g1, d0, d1, s0, s1, pf0, pf1;
    begin
      subj = C3_W_SUBJ[0]; rel = C3_W_REL[0];
      k0 = C3_W_K0[0]; k1 = C3_W_K1[0]; k2 = C3_W_K2[0];
      g0 = C3_TR_G0[0]; g1 = g0 + 1; d0 = g0 + 2; d1 = g0 + 3;
      s0 = 32'h200; s1 = 32'h201; pf0 = 32'h300; pf1 = 32'h301;
      plant_post8(g0, g1, d0, d1, s0, s1, pf0, pf1);
      plant_index(8, k0, k1, k2);
      wr_f(g0, subj, 32'h30, rel, C3_TR_CONF_W[0], 1, 1, C3_TR_CX1);
      wr_f(g1, 32'h30, C3_SHARED_DST, rel, C3_TR_CONF_W[0], 1, 1, C3_TR_CX2);
      wr_f(d0, subj, 32'h38, rel, C3_TR_CONF_W[0], 1, 1, C3_TR_CX1);
      wr_f(d1, 32'h38, 32'h90, rel, C3_TR_CONF_W[0], 1, 1, C3_TR_CX2);
      wr_f(s0, subj, C3_SHARED_MID, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(s1, C3_SHARED_MID, C3_SHARED_BG_DST, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf0, subj, 32'hA0, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf1, 32'hA0, 32'hB0, rel, C3_EXTRA_CONF, 1, 1, 0);
    end
  endtask

  initial begin
    fail = 0; first_div = ""; nslot = 0;
    urx = 1'b1; rst_n = 0;
    for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 0;
    plant_train0();
    repeat (8) @(posedge clk); rst_n = 1; repeat (8) @(posedge clk);
    $display("C5_EXPLICIT_REWARD_01A PROGRAM=NO BOARD_PASS=REJECT DUT=prod_top_rew MIG=NO");
    guard = 0;
    while ((seen[0] !== 1'b1 || seen[3] !== 1'b1 || seen[4] !== 1'b1) && guard < 4000) begin
      @(posedge clk); guard = guard + 1;
    end
    chk("BOOT_IDX_LRN_LMD", seen[0] && seen[3] && seen[4] && guard < 4000);
    repeat (20) @(posedge clk);

    uart_str("pump requires indirect");
    wait_until_done();
    $display("MEAS_Q1 nupd=%0d pcmt=%0d pacc=%0d txn=%0d gen=%0d st=%0d", nupd, pcmt, pacc, txn, gen, c3st);
    chk("Q1_NO_UPD", nupd == 16'd0);
    chk("Q1_NO_CMT", pcmt == 1'b0);
    chk("Q1_W0", w_zero());
    if ((nupd == 16'd0) && !pcmt) $display("CLASS_query_no_sgd HIT");
    else $display("CLASS_query_no_sgd MISS nupd=%0d pcmt=%0d", nupd, pcmt);
    snap_w();

    uart_str("pump requires indirect");
    wait_next_done();
    $display("MEAS_Q2 nupd=%0d pcmt=%0d txn=%0d gen=%0d", nupd, pcmt, txn, gen);
    chk("Q2_NO_UPD", nupd == 16'd0);
    chk("Q2_W_EQ", w_eq());
    if ((nupd == 16'd0) && w_eq()) $display("CLASS_w32_delta0_two_infer HIT");
    else $display("CLASS_w32_delta0_two_infer MISS");

    nupd_a = nupd; ndup_a = ndup; nbad_a = nbad;
    uart_rew(txn, gen, 8'sd3, 1'b0, 16'd7);
    wait_nupd(1);
    chk("PLUS3_CMT", pcmt == 1'b1);
    if (nupd == 16'd1) $display("CLASS_rew_plus3 HIT nupd=1");
    else $display("CLASS_rew_plus3 MISS nupd=%0d", nupd);
    snap2_w();
    $display("MEAS_W0_AFTER_P3 w0=%0d", cw[0]);

    uart_rew(txn, gen, 8'sd3, 1'b0, 16'd7);
    guard = 0;
    while ((ndup == ndup_a[15:0]) && guard < 20000) begin @(posedge clk); guard = guard + 1; end
    chk("DUP_NDUP", ndup == ndup_a[15:0] + 16'd1);
    chk("DUP_NUPD", nupd == 16'd1);
    for (k = 0; k < 32; k = k + 1) snap[k] = snap2[k];
    chk("DUP_W", w_eq());
    if ((ndup == ndup_a[15:0] + 16'd1) && (nupd == 16'd1)) $display("CLASS_rew_dup HIT");
    else $display("CLASS_rew_dup MISS ndup=%0d nupd=%0d", ndup, nupd);

    ncrc_a = ncrc;
    uart_rew(txn, gen, 8'sd3, 1'b1, 16'd7);
    guard = 0;
    while ((ncrc == ncrc_a[15:0]) && guard < 20000) begin @(posedge clk); guard = guard + 1; end
    chk("CRC_CNT", ncrc == ncrc_a[15:0] + 16'd1);
    chk("CRC_NUPD", nupd == 16'd1);
    if ((ncrc == ncrc_a[15:0] + 16'd1) && (nupd == 16'd1)) $display("CLASS_rew_crc HIT");
    else $display("CLASS_rew_crc MISS");

    nbad_a = nbad;
    uart_rew(txn, gen + 8'd1, 8'sd3, 1'b0, 16'd7);
    guard = 0;
    while ((nbad == nbad_a[15:0]) && guard < 20000) begin @(posedge clk); guard = guard + 1; end
    chk("STALE_NBAD", nbad == nbad_a[15:0] + 16'd1);
    chk("STALE_NUPD", nupd == 16'd1);
    if ((nbad == nbad_a[15:0] + 16'd1) && (nupd == 16'd1)) $display("CLASS_rew_stale HIT");
    else $display("CLASS_rew_stale MISS");

    uart_str("pump requires indirect");
    wait_next_done();
    uart_rew(txn, gen, 8'sd0, 1'b0, 16'd7);
    wait_nupd(2);
    if (nupd == 16'd2) $display("CLASS_rew_zero HIT");
    else $display("CLASS_rew_zero MISS nupd=%0d", nupd);

    uart_str("pump requires indirect");
    wait_next_done();
    uart_rew(txn, gen, -8'sd3, 1'b0, 16'd7);
    wait_nupd(3);
    if (nupd == 16'd3) $display("CLASS_rew_minus3 HIT");
    else $display("CLASS_rew_minus3 MISS nupd=%0d", nupd);

    uart_str("pump requires indirect");
    wait_next_done();
    uart_byte(A7NG_C5P_CMD_FREEZE); uart_byte(A7NG_C5P_EOL);
    guard = 0; while (done && guard < 8000) begin @(posedge clk); guard = guard + 1; end
    nfrz_a = nfrz;
    uart_rew(txn, gen, 8'sd3, 1'b0, 16'd7);
    guard = 0;
    while ((nfrz == nfrz_a[15:0]) && guard < 20000) begin @(posedge clk); guard = guard + 1; end
    chk("FRZ_CNT", nfrz == nfrz_a[15:0] + 16'd1);
    chk("FRZ_NUPD", nupd == 16'd3);
    if ((nfrz == nfrz_a[15:0] + 16'd1) && (nupd == 16'd3)) $display("CLASS_rew_frz HIT");
    else $display("CLASS_rew_frz MISS nfrz=%0d nupd=%0d", nfrz, nupd);

    $display("MEAS_W32");
    for (k = 0; k < 32; k = k + 1) $display("W[%0d]=%0d", k, cw[k]);

    if (fail == 0) $display("ASTRA_C5_EXPLICIT_REWARD_01A_XSIM_PASS");
    else $display("ASTRA_C5_EXPLICIT_REWARD_01A_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO 01B=OPEN quality=EXPLICIT_UART_REWARD_NOT_FULL_DDR_RESTORE");
    $finish;
  end
endmodule
