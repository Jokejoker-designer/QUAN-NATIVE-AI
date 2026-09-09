`timescale 1ns / 1ps
// ASTRA-C5-AUTO-REWARD-REGRESS-01. PROGRAM=NO.
// Falsifier on unedited prod_top. Modeled AXI. Not BOARD.
`include "a7ng_astra_c5_prod_top.svh"
`include "a7ng_astra_c5_ddr_arb.svh"
`include "tb_oracles.svh"
module tb_astra_c5_auto_reward_regress;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS = 96;
  localparam int CPB = (A7NG_C5P_CLK_HZ + A7NG_C5P_BAUD/2) / A7NG_C5P_BAUD;
  logic clk, rst_n, urx, utx;
  initial clk = 0;
  always #5 clk = ~clk;

  logic arvalid, arready, rvalid, rready, rlast;
  logic [27:0] araddr;
  logic [127:0] rdata;
  logic awvalid, awready, wvalid, wready, wlast, bvalid, bready;
  logic [27:0] awaddr;
  logic [127:0] wdata;
  logic busy, done, dual, qid, a09, plant, c3res, pcmt, pvalid, gdone, phit, ehas;
  logic [5:0] seen;
  logic [2:0] owner;
  logic [15:0] nsw, nblk, nhw, nht, imask, nurx, nutx;
  logic [3:0] c3st, pph;
  logic [7:0] c3obj, glast;
  logic signed [15:0] pw0;
  logic [27:0] last_aw;

  logic [27:0] mk[0:SLOTS-1];
  logic [127:0] mv[0:SLOTS-1];
  logic mvld[0:SLOTS-1];
  int nslot, fail, i, guard;
  logic signed [15:0] pw0_q1;
  string first_div;
  typedef enum logic [2:0] { M_IDLE, M_R, M_W, M_B } mst_t;
  mst_t mst;
  logic [7:0] rem;
  logic [27:0] ra;

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

  assign arready = (mst == M_IDLE);
  assign awready = (mst == M_IDLE);
  assign wready  = (mst == M_W);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mst <= M_IDLE; rvalid <= 0; rlast <= 0; rdata <= 0; rem <= 0; ra <= 0; bvalid <= 0;
    end else unique case (mst)
      M_IDLE: begin
        bvalid <= 0; rvalid <= 0;
        if (awvalid && awready) mst <= M_W;
        else if (arvalid && arready) begin
          ra <= araddr; rem <= 8'd0; rlast <= 1'b1; rvalid <= 1'b1;
          rdata <= mem_rd(araddr); mst <= M_R;
        end
      end
      M_R: if (rvalid && rready) begin
        rvalid <= 1'b0; mst <= M_IDLE;
      end
      M_W: if (wvalid && wready) begin
        mem_wr(awaddr, wdata);
        bvalid <= 1'b1; mst <= M_B;
      end
      M_B: if (bvalid && bready) begin
        bvalid <= 1'b0; mst <= M_IDLE;
      end
      default: mst <= M_IDLE;
    endcase
  end

  a7ng_astra_c5_prod_top u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .uart_rx_i(urx), .uart_tx_o(utx),
    .m_arvalid_o(arvalid), .m_araddr_o(araddr), .m_arready_i(arready),
    .m_rvalid_i(rvalid), .m_rdata_i(rdata), .m_rready_o(rready),
    .m_awvalid_o(awvalid), .m_awaddr_o(awaddr), .m_awready_i(awready),
    .m_wvalid_o(wvalid), .m_wdata_o(wdata), .m_wlast_o(wlast), .m_wready_i(wready),
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
    .last_aw_o(last_aw)
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
    integer k;
    begin
      for (k = 0; k < s.len(); k = k + 1) uart_byte(s[k]);
      uart_byte(A7NG_C5P_EOL);
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
    fail = 0; first_div = ""; nslot = 0; pw0_q1 = 0;
    urx = 1'b1; rst_n = 0;
    for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 0;
    plant_train0();
    repeat (8) @(posedge clk); rst_n = 1; repeat (8) @(posedge clk);
    $display("C5_AUTO_REWARD_REGRESS PROGRAM=NO BOARD_PASS=REJECT DUT=unedited_prod_top MIG=NO");
    $display("CLASS_no_uart_reward_frame HIT opcode=none (query ASCII only; 0x15 is LEARN not reward)");
    guard = 0;
    while ((seen[0] !== 1'b1 || seen[3] !== 1'b1 || seen[4] !== 1'b1) && guard < 4000) begin
      @(posedge clk); guard = guard + 1;
    end
    chk("BOOT_IDX_LRN_LMD", seen[0] && seen[3] && seen[4] && guard < 4000);
    repeat (20) @(posedge clk);
    uart_str("pump requires indirect");
    guard = 0;
    while (!done && guard < 200000) begin @(posedge clk); guard = guard + 1; end
    chk("NO_TIMEOUT_Q1", done && guard < 200000);
    pw0_q1 = pw0;
    $display("MEAS_Q1 nurx=%0d nutx=%0d st=%0d pcmt=%0d pvalid=%0d pph=%0d pw0=%0d",
      nurx, nutx, c3st, pcmt, pvalid, pph, pw0);

    if (pcmt) $display("CLASS_auto_rew_pcmt HIT");
    else $display("CLASS_auto_rew_pcmt MISS");
    if (pw0 == 16'sd3) $display("CLASS_auto_rew_w0 HIT pw0=%0d", pw0);
    else $display("CLASS_auto_rew_w0 MISS pw0=%0d", pw0);

    chk("PEND_Q1", pcmt);
    chk("W0_Q1", pw0 == 16'sd3);
    chk("PERS_Q1", pvalid || (pph == 4'd4));
    chk("ANSWER_Q1", c3st == 4'd0);

    uart_str("pump requires indirect");
    guard = 0;
    while (done && guard < 8000) begin @(posedge clk); guard = guard + 1; end
    chk("Q2_LEFT_DONE", !done && guard < 8000);
    guard = 0;
    while (!done && guard < 200000) begin @(posedge clk); guard = guard + 1; end
    chk("NO_TIMEOUT_Q2", done && guard < 200000);
    $display("MEAS_Q2 pcmt=%0d pw0=%0d extra=C2_stale_or_dup", pcmt, pw0);
    if (pw0 == 16'sd6) $display("CLASS_auto_rew_w0_q2 HIT pw0=%0d", pw0);
    else $display("CLASS_auto_rew_w0_q2 MISS pw0=%0d (C2 persist_w0 not a 32-weight bank)", pw0);

    if (fail == 0) $display("ASTRA_C5_AUTO_REWARD_REGRESS_XSIM_PASS");
    else $display("ASTRA_C5_AUTO_REWARD_REGRESS_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO quality=FALSIFIER_NOT_A_FIX");
    $finish;
  end
endmodule
