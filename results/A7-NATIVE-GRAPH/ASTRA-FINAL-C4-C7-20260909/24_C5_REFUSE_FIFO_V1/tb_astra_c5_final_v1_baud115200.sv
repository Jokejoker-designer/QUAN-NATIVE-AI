`timescale 1ns / 1ps
// Default CLK_HZ/BAUD UART on final_v1. PROGRAM=NO. Not C5_MASTER.
// Instantiates DUT without CLK_HZ/BAUD override. One UNKNOWN → S_SAFE pin.
`include "a7ng_astra_c5_prod_top_final_v1.svh"
`include "a7ng_astra_c5_ddr_arb.svh"
`include "a7ng_astra_c3_held_out.svh"
`include "tb_oracles.svh"
module tb_astra_c5_final_v1_baud115200;
  localparam int CPB = (A7NG_C5P_CLK_HZ + A7NG_C5P_BAUD/2) / A7NG_C5P_BAUD;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS = 32;
  logic clk, rst_n, urx, utx;
  initial clk = 0;
  always #6 clk = ~clk;

  logic arvalid, arready, rvalid, rready, rlast;
  logic [27:0] araddr, awaddr, last_aw;
  logic [127:0] rdata, wdata;
  logic [1:0] rresp, bresp, last_c3rr, last_br, last_ckrr;
  logic [3:0] rid, bid;
  logic awvalid, awready, wvalid, wready, wlast, bvalid, bready;
  logic [15:0] wstrb;
  logic busy, done, dual, qid, a09, plant, c3res, pcmt, pacc, c3busy, pvalid, gdone, phit, ehas;
  logic crest, cbusy, pok, allow, aok;
  logic [5:0] seen;
  logic [2:0] owner;
  logic [15:0] nsw, nblk, nhw, nht, imask, nurx, nutx, nupd, ndup, nbad;
  logic [15:0] nrok, ncrc, nsess, nrng, nfrz, nlen, nstr, novf;
  logic [3:0] c3st, pph, cfail;
  logic [7:0] c3obj, glast, txn, gen, gnout;
  logic [19:0] c3ans, c3p0, c3p1;
  logic signed [15:0] pw0;
  logic signed [15:0] cw [0:31];

  logic [27:0] mk[0:SLOTS-1];
  logic [127:0] mv[0:SLOTS-1];
  logic mvld[0:SLOTS-1];
  int nslot, fail, i, guard, npin, t;
  logic [7:0] pinb [0:15];
  logic [3:0] cap_st;
  logic cap_v, cap_pok;
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
  function automatic logic [3:0] rid_of(input logic [27:0] a);
    rid_of = (a >= FACT_BASE) ? A7NG_C3_FACT_RID : 4'd1;
  endfunction

  assign arready = (mst == M_IDLE);
  assign awready = (mst == M_IDLE);
  assign wready  = (mst == M_W);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mst <= M_IDLE; rvalid <= 0; rdata <= 0; rresp <= 0; rlast <= 0; rid <= 0;
      bvalid <= 0; bresp <= 0; bid <= 0;
    end else unique case (mst)
      M_IDLE: begin
        bvalid <= 0; rvalid <= 0;
        if (awvalid && awready) mst <= M_W;
        else if (arvalid && arready) begin
          rvalid <= 1'b1;
          rdata <= mem_rd(araddr);
          rresp <= A7NG_C5P_OKAY;
          rlast <= 1'b1;
          rid <= rid_of(araddr);
          mst <= M_R;
        end
      end
      M_R: if (rvalid && rready) begin rvalid <= 1'b0; mst <= M_IDLE; end
      M_W: if (wvalid && wready) begin
        mem_wr(awaddr, wdata);
        bvalid <= 1'b1;
        bresp <= A7NG_C5P_OKAY;
        bid <= 4'd1;
        mst <= M_B;
      end
      M_B: if (bvalid && bready) begin bvalid <= 1'b0; mst <= M_IDLE; end
      default: mst <= M_IDLE;
    endcase
  end

  a7ng_astra_c5_prod_top_final_v1 u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .uart_rx_i(urx), .uart_tx_o(utx),
    .alias_wr_v_i(1'b0), .alias_wr_idx_i(3'd0),
    .alias_wr_key_i(20'd0), .alias_wr_sym_i(32'd0),
    .alias_wr_ovf_i(1'b0), .bank_r_i(1'b0),
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
    .c3_status_o(c3st), .c3_obj_o(c3obj),
    .c3_ans_o(c3ans), .c3_p0_o(c3p0), .c3_p1_o(c3p1),
    .c3_result_v_o(c3res), .c3_pend_cmt_o(pcmt),
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
    .last_c3_rresp_o(last_c3rr), .last_bresp_o(last_br), .last_ckpt_rresp_o(last_ckrr),
    .c3_proof_ok_o(pok), .answer_allowed_o(allow), .alias_ok_o(aok)
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
  task automatic pin_byte(output logic [7:0] d, output bit ok);
    integer g, b;
    begin
      ok = 1'b0; d = 8'd0;
      g = 0;
      while (utx && (g < 5000000)) begin @(posedge clk); g = g + 1; end
      if (utx) return;
      repeat (CPB/2) @(posedge clk);
      for (b = 0; b < 8; b = b + 1) begin
        repeat (CPB) @(posedge clk);
        d[b] = utx;
      end
      repeat (CPB) @(posedge clk);
      ok = 1'b1;
    end
  endtask
  task automatic pin_line;
    logic [7:0] d;
    bit ok;
    integer g;
    begin
      npin = 0; g = 0; ok = 1'b1;
      while (ok && (g < 16)) begin
        pin_byte(d, ok);
        if (!ok) begin
          if (first_div == "") first_div = "PIN_TIMEOUT";
          $display("FAIL PIN_TIMEOUT"); fail = fail + 1;
          return;
        end
        if (d == A7NG_C5P_EOL) return;
        if (npin < 16) pinb[npin] = d;
        npin = npin + 1;
        g = g + 1;
      end
      chk("PIN_NO_EOL", 1'b0);
    end
  endtask
  task automatic wait_until_done;
    begin
      cap_v = 0; cap_st = 4'hF; cap_pok = 0;
      guard = 0;
      while (!done && guard < 8000000) begin
        @(posedge clk);
        guard = guard + 1;
        if (c3res && !cap_v) begin cap_st = c3st; cap_pok = pok; cap_v = 1'b1; end
      end
      chk("NO_TIMEOUT", done && guard < 8000000);
    end
  endtask

  initial begin
    fail = 0; first_div = ""; nslot = 0;
    urx = 1'b1; rst_n = 0;
    for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 0;
    repeat (8) @(posedge clk); rst_n = 1; repeat (8) @(posedge clk);
    $display("C5_FINAL_V1_BAUD115200 PROGRAM=NO C5_MASTER=OPEN");
    $display("MEAS_BAUD CLK_HZ=%0d BAUD=%0d CPB=%0d NO_SIM_OVERRIDE=YES",
             A7NG_C5P_CLK_HZ, A7NG_C5P_BAUD, CPB);
    chk("CLK_DEFAULT", A7NG_C5P_CLK_HZ == 83333333);
    chk("BAUD_DEFAULT", A7NG_C5P_BAUD == 115200);
    chk("CPB_723", CPB == 723);
    guard = 0;
    while ((seen[0] !== 1'b1 || seen[3] !== 1'b1 || seen[4] !== 1'b1) && guard < 40000) begin
      @(posedge clk); guard = guard + 1;
    end
    chk("BOOT_IDX_LRN_LMD", seen[0] && seen[3] && seen[4] && guard < 40000);
    fork
      pin_line();
      begin
        uart_str("zzzzqqqqxxxx");
        guard = 0;
        while (done && guard < 200000) begin @(posedge clk); guard = guard + 1; end
        wait_until_done();
      end
    join
    $display("MEAS_Q npin=%0d nstr=%0d novf=%0d st=%0d", npin, nstr, novf, cap_st);
    for (t = 0; t < npin; t = t + 1) $display("PIN[%0d]=%0d", t, pinb[t]);
    chk("UNK_ST", cap_st == A7NG_C3_ST_UNKNOWN);
    chk("SAFE_PIN", (npin == 3) && (pinb[0] == 8'h6E) && (pinb[1] == 8'h6F) && (pinb[2] == 8'd0));
    chk("FIFO_MATCH", (nstr == 16'd3) && (novf == 16'd0));
    chk("HOST0", nht == 16'd0);
    if ((npin == 3) && (nstr == 16'd3) && (A7NG_C5P_BAUD == 115200))
      $display("CLASS_uart_115200_fifo HIT CPB=%0d", CPB);
    else $display("CLASS_uart_115200_fifo MISS");
    if (fail == 0) $display("ASTRA_C5_FINAL_V1_BAUD115200_XSIM_PASS");
    else $display("ASTRA_C5_FINAL_V1_BAUD115200_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=OPEN PROGRAM=NO");
    $finish;
  end
endmodule
