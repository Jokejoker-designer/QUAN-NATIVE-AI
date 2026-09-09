`timescale 1ns / 1ps
// ASTRA-C5-AXI-ERRORS-04B. PROGRAM=NO.
// Named resp top. Modeled AXI RRESP/BRESP through adapters. Not BOARD.
// Sim override 8000/800; DUT defaults remain 83.333MHz/115200.
`include "a7ng_astra_c5_prod_top_resp.svh"
`include "a7ng_astra_c5_sgd32_ckpt.svh"
`include "a7ng_astra_c5_ddr_arb.svh"
`include "a7ng_gate14_crc.svh"
`include "tb_oracles.svh"
module tb_astra_c5_axi_errors_04b;
  localparam int unsigned SIM_CLK_HZ = 8000;
  localparam int unsigned SIM_BAUD   = 800;
  localparam int CPB = (SIM_CLK_HZ + SIM_BAUD/2) / SIM_BAUD;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS = 96;
  logic clk, rst_n, urx, utx;
  initial clk = 0;
  always #5 clk = ~clk;

  logic arvalid, arready, rvalid, rready, rlast;
  logic [27:0] araddr, awaddr, last_aw;
  logic [127:0] rdata, wdata;
  logic [1:0] rresp, bresp, last_c3rr, last_br, last_ckrr;
  logic [3:0] rid, bid;
  logic awvalid, awready, wvalid, wready, wlast, bvalid, bready;
  logic [15:0] wstrb, last_wstrb;
  logic busy, done, dual, qid, a09, plant, c3res, pcmt, pacc, c3busy, pvalid, gdone, phit, ehas;
  logic crest, cbusy;
  logic [5:0] seen;
  logic [2:0] owner;
  logic [15:0] nsw, nblk, nhw, nht, imask, nurx, nutx, nupd, ndup, nbad;
  logic [15:0] nrok, ncrc, nsess, nrng, nfrz, nlen, nstr, novf;
  logic [3:0] c3st, pph, cfail;
  logic [7:0] c3obj, glast, txn, gen, gnout;
  logic signed [15:0] pw0;
  logic signed [15:0] cw [0:31];

  logic [27:0] mk[0:SLOTS-1];
  logic [127:0] mv[0:SLOTS-1];
  logic mvld[0:SLOTS-1];
  int nslot, fail, i, guard, k;
  int n_ar, n_r, n_aw, n_w, n_b, aw_cnt, w_cnt;
  int inj_aw_stall, inj_w_stall, inj_b_stall, b_wait;
  logic [1:0] inj_rresp_fact, inj_rresp_ckpt, inj_bresp;
  logic signed [15:0] snap [0:31];
  string first_div;
  typedef enum logic [2:0] { M_IDLE, M_R, M_W, M_BSTALL, M_B } mst_t;
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
  function automatic logic [3:0] rid_of(input logic [27:0] a);
    rid_of = (a >= FACT_BASE) ? 4'd2 : 4'd1;
  endfunction
  function automatic logic [1:0] rresp_of(input logic [27:0] a);
    if (a >= A7NG_C5K_BASE) rresp_of = inj_rresp_ckpt;
    else if (a >= FACT_BASE) rresp_of = inj_rresp_fact;
    else rresp_of = A7NG_C5P_OKAY;
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

  assign arready = (mst == M_IDLE);
  assign awready = (mst == M_IDLE) && (aw_cnt >= inj_aw_stall);
  assign wready  = (mst == M_W) && (w_cnt >= inj_w_stall);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mst <= M_IDLE; rvalid <= 0; rdata <= 0; rresp <= 0; rlast <= 0; rid <= 0;
      bvalid <= 0; bresp <= 0; bid <= 0; last_wstrb <= 0;
      n_ar <= 0; n_r <= 0; n_aw <= 0; n_w <= 0; n_b <= 0;
      aw_cnt <= 0; w_cnt <= 0; b_wait <= 0;
    end else begin
      if (arvalid && arready) n_ar <= n_ar + 1;
      if (rvalid && rready) n_r <= n_r + 1;
      if (awvalid && awready) n_aw <= n_aw + 1;
      if (wvalid && wready) begin
        n_w <= n_w + 1;
        last_wstrb <= wstrb;
      end
      if (bvalid && bready) n_b <= n_b + 1;
      unique case (mst)
        M_IDLE: begin
          bvalid <= 0; rvalid <= 0;
          if (awvalid) begin
            if (aw_cnt >= inj_aw_stall) begin
              aw_cnt <= 0;
              w_cnt <= 0;
              mst <= M_W;
            end else aw_cnt <= aw_cnt + 1;
          end else if (arvalid && arready) begin
            rvalid <= 1'b1;
            rdata <= mem_rd(araddr);
            rresp <= rresp_of(araddr);
            rlast <= 1'b1;
            rid <= rid_of(araddr);
            mst <= M_R;
          end else aw_cnt <= 0;
        end
        M_R: if (rvalid && rready) begin rvalid <= 1'b0; mst <= M_IDLE; end
        M_W: begin
          if (wvalid) begin
            if (w_cnt >= inj_w_stall) begin
              mem_wr(awaddr, wdata);
              w_cnt <= 0;
              b_wait <= inj_b_stall;
              bresp <= inj_bresp;
              bid <= 4'd1;
              if (inj_b_stall == 0) begin
                bvalid <= 1'b1;
                mst <= M_B;
              end else mst <= M_BSTALL;
            end else w_cnt <= w_cnt + 1;
          end
        end
        M_BSTALL: begin
          if (b_wait == 0) begin
            bvalid <= 1'b1;
            mst <= M_B;
          end else b_wait <= b_wait - 1;
        end
        M_B: if (bvalid && bready) begin bvalid <= 1'b0; mst <= M_IDLE; end
        default: mst <= M_IDLE;
      endcase
    end
  end

  a7ng_astra_c5_prod_top_resp #(.CLK_HZ(SIM_CLK_HZ), .BAUD(SIM_BAUD)) u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .uart_rx_i(urx), .uart_tx_o(utx),
    .m_arvalid_o(arvalid), .m_araddr_o(araddr), .m_arready_i(arready),
    .m_rvalid_i(rvalid), .m_rdata_i(rdata), .m_rresp_i(rresp),
    .m_rlast_i(rlast), .m_rid_i(rid), .m_rready_o(rready),
    .m_awvalid_o(awvalid), .m_awaddr_o(awaddr), .m_awready_i(awready),
    .m_wvalid_o(wvalid), .m_wdata_o(wdata), .m_wlast_o(wlast), .m_wstrb_o(wstrb),
    .m_wready_i(wready),
    .m_bvalid_i(bvalid), .m_bresp_i(bresp), .m_bid_i(bid), .m_bready_o(bready),
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
    .n_rew_range_o(nrng), .n_rew_frz_o(nfrz), .n_rew_len_o(nlen),
    .ckpt_restored_o(crest), .ckpt_busy_o(cbusy), .ckpt_fail_o(cfail),
    .n_stream_o(nstr), .n_fifo_ovf_o(novf), .gen_n_out_o(gnout),
    .last_c3_rresp_o(last_c3rr), .last_bresp_o(last_br), .last_ckpt_rresp_o(last_ckrr)
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
      while (!done && guard < 400000) begin @(posedge clk); guard = guard + 1; end
      chk("NO_TIMEOUT", done && guard < 400000);
    end
  endtask
  task automatic wait_next_done;
    begin
      guard = 0;
      while (done && guard < 8000) begin @(posedge clk); guard = guard + 1; end
      wait_until_done();
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
    inj_rresp_fact = A7NG_C5P_OKAY;
    inj_rresp_ckpt = A7NG_C5P_OKAY;
    inj_bresp = A7NG_C5P_OKAY;
    inj_aw_stall = 0; inj_w_stall = 0; inj_b_stall = 0;
    urx = 1'b1; rst_n = 0;
    for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 0;
    plant_train0();
    repeat (8) @(posedge clk); rst_n = 1; repeat (8) @(posedge clk);
    $display("C5_AXI_ERRORS_04B PROGRAM=NO BOARD_PASS=REJECT DUT=prod_top_resp MIG=NO");
    $display("SIM_OVERRIDE CLK_HZ=%0d BAUD=%0d CPB=%0d FINAL_DEFAULTS=83333333/115200",
             SIM_CLK_HZ, SIM_BAUD, CPB);
    guard = 0;
    while ((seen[0] !== 1'b1 || seen[3] !== 1'b1 || seen[4] !== 1'b1) && guard < 4000) begin
      @(posedge clk); guard = guard + 1;
    end
    chk("BOOT_IDX_LRN_LMD", seen[0] && seen[3] && seen[4] && guard < 4000);
    repeat (20) @(posedge clk);

    inj_rresp_fact = A7NG_C5P_SLVERR;
    uart_str("pump requires indirect");
    wait_until_done();
    $display("MEAS_ADP last_c3rr=%0d st=%0d n_ar=%0d n_r=%0d", last_c3rr, c3st, n_ar, n_r);
    chk("ADP_SLVERR", last_c3rr === A7NG_C5P_SLVERR);
    if (last_c3rr === A7NG_C5P_SLVERR) $display("CLASS_adp_not_okay HIT last_c3rr=2");
    else $display("CLASS_adp_not_okay MISS last_c3rr=%0d", last_c3rr);
    inj_rresp_fact = A7NG_C5P_OKAY;

    uart_str("pump requires indirect");
    wait_next_done();
    $display("MEAS_QOK nupd=%0d st=%0d last_c3rr=%0d", nupd, c3st, last_c3rr);
    chk("QOK_NO_UPD", nupd == 16'd0);
    chk("QOK_C3RR", last_c3rr === A7NG_C5P_OKAY);

    inj_bresp = A7NG_C5P_SLVERR;
    uart_rew(txn, gen, 8'sd3, 1'b0, 16'd7);
    wait_next_done();
    $display("MEAS_BERR nupd=%0d pvalid=%0d fail=%0d last_br=%0d pph=%0d",
             nupd, pvalid, cfail, last_br, pph);
    chk("BERR_FAIL", cfail == A7NG_C5K_F_BRESP);
    chk("BERR_NOPERS", pvalid === 1'b0);
    chk("BERR_LAT", last_br === A7NG_C5P_SLVERR);
    if ((cfail == A7NG_C5K_F_BRESP) && !pvalid && (last_br === A7NG_C5P_SLVERR))
      $display("CLASS_bresp_slverr HIT");
    else $display("CLASS_bresp_slverr MISS fail=%0d pvalid=%0d br=%0d", cfail, pvalid, last_br);
    inj_bresp = A7NG_C5P_OKAY;

    uart_str("pump requires indirect");
    wait_next_done();
    chk("Q2_ST", c3st == A7NG_C5P_ST_ANSWER);

    inj_aw_stall = 3; inj_w_stall = 2; inj_b_stall = 8;
    uart_rew(txn, gen, 8'sd3, 1'b0, 16'd7);
    wait_next_done();
    $display("MEAS_BSTALL pvalid=%0d fail=%0d last_br=%0d wstrb=%h aw=%h nupd=%0d",
             pvalid, cfail, last_br, last_wstrb, last_aw, nupd);
    chk("STALL_PERS", pvalid === 1'b1);
    chk("STALL_OKAY", last_br === A7NG_C5P_OKAY);
    chk("STALL_WSTRB", last_wstrb === 16'hFFFF);
    if (pvalid && (last_br === A7NG_C5P_OKAY) && (last_wstrb === 16'hFFFF))
      $display("CLASS_b_stall HIT");
    else $display("CLASS_b_stall MISS pvalid=%0d br=%0d wstrb=%h", pvalid, last_br, last_wstrb);
    snap_w();
    inj_aw_stall = 0; inj_w_stall = 0; inj_b_stall = 0;

    uart_byte(A7NG_C5P_CMD_FLUSH); uart_byte(A7NG_C5P_EOL);
    wait_next_done();
    chk("CLR_ZERO", w_zero());

    inj_rresp_ckpt = A7NG_C5P_SLVERR;
    uart_byte(A7NG_C5P_CMD_RELOAD); uart_byte(A7NG_C5P_EOL);
    wait_next_done();
    $display("MEAS_RERR crest=%0d fail=%0d last_ckrr=%0d zero=%0d",
             crest, cfail, last_ckrr, w_zero());
    chk("RERR_FAIL", cfail == A7NG_C5K_F_RRESP);
    chk("RERR_NOREST", crest === 1'b0);
    chk("RERR_NOINST", w_zero());
    chk("RERR_LAT", last_ckrr === A7NG_C5P_SLVERR);
    if ((cfail == A7NG_C5K_F_RRESP) && !crest && w_zero() && (last_ckrr === A7NG_C5P_SLVERR))
      $display("CLASS_rresp_slverr HIT");
    else $display("CLASS_rresp_slverr MISS fail=%0d crest=%0d ckrr=%0d", cfail, crest, last_ckrr);
    inj_rresp_ckpt = A7NG_C5P_OKAY;

    uart_byte(A7NG_C5P_CMD_RELOAD); uart_byte(A7NG_C5P_EOL);
    wait_next_done();
    $display("MEAS_RLD crest=%0d fail=%0d weq=%0d w0=%0d last_ckrr=%0d",
             crest, cfail, w_eq(), cw[0], last_ckrr);
    chk("RLD_RESTORE", crest === 1'b1);
    chk("RLD_EXACT32", w_eq());
    chk("RLD_OKAY", last_ckrr === A7NG_C5P_OKAY);
    if (crest && w_eq() && (last_ckrr === A7NG_C5P_OKAY))
      $display("CLASS_okay_persist_reload HIT");
    else $display("CLASS_okay_persist_reload MISS crest=%0d weq=%0d fail=%0d", crest, w_eq(), cfail);

    $display("MEAS_COUNTS n_ar=%0d n_r=%0d n_aw=%0d n_w=%0d n_b=%0d", n_ar, n_r, n_aw, n_w, n_b);
    chk("NO_DROP_R", n_ar == n_r);
    chk("NO_DROP_W", (n_aw == n_w) && (n_w == n_b));
    if ((n_ar == n_r) && (n_aw == n_w) && (n_w == n_b))
      $display("CLASS_no_drop HIT ar=%0d aw=%0d", n_ar, n_aw);
    else $display("CLASS_no_drop MISS ar=%0d r=%0d aw=%0d w=%0d b=%0d", n_ar, n_r, n_aw, n_w, n_b);

    if (fail == 0) $display("ASTRA_C5_AXI_ERRORS_04B_XSIM_PASS");
    else $display("ASTRA_C5_AXI_ERRORS_04B_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO");
    $finish;
  end
endmodule
