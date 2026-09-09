`timescale 1ns / 1ps
// ASTRA-C5-HELDOUT-TRANSFER-01. PROGRAM=NO. Bag-local TB (test-only plant).
// Same C5 production hierarchy. Held-out PRE vs POST dest change. Modeled AXI.
`include "a7ng_astra_c5_prod_top.svh"
`include "a7ng_astra_c5_ddr_arb.svh"
`include "tb_oracles.svh"
module tb_astra_c5_heldout_transfer;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam logic [27:0] POST_TR = POST_HEAP;
  localparam logic [27:0] POST_HO = POST_HEAP + 28'd16;
  localparam int SLOTS = 96;
  localparam int CPB = (A7NG_C5P_CLK_HZ + A7NG_C5P_BAUD/2) / A7NG_C5P_BAUD;
  localparam int K0_TR = 16'h0A22;
  localparam int K0_HO = 16'h0623;
  localparam int PRE_DST = 144;
  localparam int POST_DST = 112;
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
  logic [19:0] c3ans, c3p0, c3p1;
  logic signed [15:0] pw0;
  logic [27:0] last_aw;

  logic [27:0] mk[0:SLOTS-1];
  logic [127:0] mv[0:SLOTS-1];
  logic mvld[0:SLOTS-1];
  int nslot, fail, i, guard;
  logic [3:0] cap_st;
  logic [19:0] cap_ans, cap_p0, cap_p1;
  logic cap_v;
  logic [19:0] pre_ans, post_ans;
  logic signed [15:0] w0_pre;
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
  function automatic logic [127:0] dir_pack(input int count, input logic [27:0] post);
    dir_pack = {48'd0, 16'd7, 16'd0, count[15:0], 4'd0, post};
  endfunction
  function automatic logic [127:0] fact_pack(
      input int s, o, r, e, conf, trans, pol, fctx);
    fact_pack = {28'd0, conf[7:0], fctx[7:0], 4'd1, 1'b0, 1'b1, pol[0], trans[0],
                 e[19:0], r[7:0], o[19:0], s[19:0]};
  endfunction
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl * 65536 + (key & 12'hFFF) * 16;
  endfunction
  function automatic logic [27:0] fact_addr(input int e);
    fact_addr = FACT_BASE + (e << 4);
  endfunction

  assign arready = (mst == M_IDLE);
  assign awready = (mst == M_IDLE);
  assign wready  = (mst == M_W);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mst <= M_IDLE; rvalid <= 0; rlast <= 0; rdata <= 0; bvalid <= 0;
    end else unique case (mst)
      M_IDLE: begin
        bvalid <= 0; rvalid <= 0;
        if (awvalid && awready) mst <= M_W;
        else if (arvalid && arready) begin
          rlast <= 1'b1; rvalid <= 1'b1;
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
    .c3_status_o(c3st), .c3_obj_o(c3obj),
    .c3_ans_o(c3ans), .c3_p0_o(c3p0), .c3_p1_o(c3p1),
    .c3_result_v_o(c3res), .c3_pend_cmt_o(pcmt),
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
  task automatic uart_ctl(input logic [7:0] c);
    begin
      uart_byte(c);
      uart_byte(A7NG_C5P_EOL);
    end
  endtask
  task automatic wait_done(input string tag);
    begin
      guard = 0; cap_v = 0; cap_st = 4'hF; cap_ans = 20'd0; cap_p0 = 20'd0; cap_p1 = 20'd0;
      while (!done && guard < 400000) begin
        @(posedge clk);
        guard = guard + 1;
        if (c3res && !cap_v) begin
          cap_st = c3st; cap_ans = c3ans; cap_p0 = c3p0; cap_p1 = c3p1; cap_v = 1'b1;
        end
      end
      chk(tag, done && guard < 400000);
    end
  endtask
  task automatic wr_f(input int e, s, o, r, conf, trans, pol, fctx);
    mem_wr(fact_addr(e), fact_pack(s, o, r, e, conf, trans, pol, fctx));
  endtask
  task automatic plant_all;
    logic [127:0] btr, bho;
    begin
      btr = 128'd0;
      btr[31:0] = 32'd16; btr[63:32] = 32'd17; btr[95:64] = 32'd20; btr[127:96] = 32'd21;
      bho = 128'd0;
      bho[31:0] = 32'd256; bho[63:32] = 32'd257; bho[95:64] = 32'd258; bho[127:96] = 32'd259;
      mem_wr(dir_addr(0, K0_TR), dir_pack(4, POST_TR));
      mem_wr(POST_TR, btr);
      mem_wr(dir_addr(0, K0_HO), dir_pack(4, POST_HO));
      mem_wr(POST_HO, bho);
      wr_f(16, 10, 48, 2, 40, 1, 1, 0);
      wr_f(17, 48, 96, 2, 40, 1, 1, 0);
      wr_f(20, 10, 49, 2, 200, 1, 1, 0);
      wr_f(21, 49, 64, 2, 200, 1, 1, 0);
      wr_f(256, 6, 50, 3, 40, 1, 1, 0);
      wr_f(257, 50, PRE_DST, 3, 40, 1, 1, 0);
      wr_f(258, 6, 51, 3, 220, 1, 1, 0);
      wr_f(259, 51, POST_DST, 3, 220, 1, 1, 0);
    end
  endtask

  initial begin
    fail = 0; first_div = ""; nslot = 0; pre_ans = 20'd0; post_ans = 20'd0; w0_pre = 16'sd0;
    urx = 1'b1; rst_n = 0;
    for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 0;
    plant_all();
    repeat (8) @(posedge clk); rst_n = 1; repeat (8) @(posedge clk);
    $display("C5_HELDOUT_TRANSFER PROGRAM=NO BOARD_PASS=REJECT train_subj=10 hold_subj=6 MIG=NO");
    $display("CLASS_entities_disjoint HIT train={10} hold={6}");
    guard = 0;
    while ((seen[0] !== 1'b1 || seen[3] !== 1'b1 || seen[4] !== 1'b1) && guard < 4000) begin
      @(posedge clk); guard = guard + 1;
    end
    chk("BOOT_IDX_LRN_LMD", seen[0] && seen[3] && seen[4] && guard < 4000);
    repeat (20) @(posedge clk);

    uart_ctl(A7NG_C5P_CMD_FREEZE);
    repeat (20) @(posedge clk);
    uart_str("ahu connects indirect");
    wait_done("PRE_DONE");
    pre_ans = cap_ans; w0_pre = pw0;
    $display("MEAS PRE st=%0d ans=%0d p0=%0d p1=%0d w0=%0d", cap_st, cap_ans, cap_p0, cap_p1, pw0);
    if ((cap_st == A7NG_C5P_ST_ANSWER) && (cap_ans == PRE_DST[19:0]) && (cap_p0 == 20'd256))
      $display("CLASS_heldout_pre HIT ans=%0d p0=%0d", cap_ans, cap_p0);
    else $display("CLASS_heldout_pre MISS st=%0d ans=%0d p0=%0d", cap_st, cap_ans, cap_p0);
    chk("PRE_DISTRACTOR", (cap_st == A7NG_C5P_ST_ANSWER) && (cap_ans == PRE_DST[19:0]) && (cap_p0 == 20'd256));

    uart_ctl(A7NG_C5P_CMD_LEARN);
    repeat (20) @(posedge clk);
    uart_str("pump requires indirect");
    wait_done("TRAIN_DONE");
    $display("MEAS TRAIN st=%0d ans=%0d p0=%0d p1=%0d w0=%0d pvalid=%0d", cap_st, cap_ans, cap_p0, cap_p1, pw0, pvalid);
    if (pvalid && (pw0 !== w0_pre))
      $display("CLASS_reward_update HIT w0=%0d pre=%0d", pw0, w0_pre);
    else $display("CLASS_reward_update MISS w0=%0d pre=%0d pvalid=%0d", pw0, w0_pre, pvalid);
    chk("TRAIN_ANSWER", cap_st == A7NG_C5P_ST_ANSWER);
    chk("REWARD_W0", pvalid && (pw0 !== w0_pre));

    uart_str("ahu connects indirect");
    wait_done("POST_DONE");
    post_ans = cap_ans;
    $display("MEAS POST st=%0d ans=%0d p0=%0d p1=%0d", cap_st, cap_ans, cap_p0, cap_p1);
    if ((cap_st == A7NG_C5P_ST_ANSWER) && (cap_ans == POST_DST[19:0]) && (cap_p0 == 20'd258))
      $display("CLASS_heldout_post HIT ans=%0d p0=%0d", cap_ans, cap_p0);
    else $display("CLASS_heldout_post MISS st=%0d ans=%0d p0=%0d", cap_st, cap_ans, cap_p0);
    chk("POST_GOLD", (cap_st == A7NG_C5P_ST_ANSWER) && (cap_ans == POST_DST[19:0]) && (cap_p0 == 20'd258));
    if (post_ans !== pre_ans)
      $display("CLASS_heldout_changed HIT pre=%0d post=%0d", pre_ans, post_ans);
    else $display("CLASS_heldout_changed MISS pre=%0d post=%0d", pre_ans, post_ans);
    chk("PRE_NE_POST", post_ans !== pre_ans);

    if (!dual && (nsw != 0)) $display("CLASS_one_ddr_owner HIT nsw=%0d dual=%0d", nsw, dual);
    else $display("CLASS_one_ddr_owner MISS nsw=%0d dual=%0d", nsw, dual);
    if (!qid) $display("CLASS_no_qid_map HIT");
    else $display("CLASS_no_qid_map MISS");
    if (nhw == 16'd0) $display("CLASS_no_host_winner HIT");
    else $display("CLASS_no_host_winner MISS n=%0d", nhw);
    if (!a09) $display("CLASS_no_a09_top HIT");
    else $display("CLASS_no_a09_top MISS");
    if (!plant) $display("CLASS_no_plant_in_dut HIT");
    else $display("CLASS_no_plant_in_dut MISS");
    chk("DUAL0", !dual);
    chk("NOQID", !qid);
    chk("NOHOST", nhw == 16'd0);
    chk("NOA09", !a09);
    chk("NOPLANT", !plant);

    if (fail == 0) $display("ASTRA_C5_HELDOUT_TRANSFER_XSIM_PASS");
    else $display("ASTRA_C5_HELDOUT_TRANSFER_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO quality=MODELED_AXI_HELDOUT_PRE_POST_NOT_MIG");
    $finish;
  end
endmodule
