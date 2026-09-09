`timescale 1ns / 1ps
// ASTRA-C5-SGD32-CKPT-01. PROGRAM=NO. Unit TB. Modeled AXI. Not BOARD.
`include "a7ng_astra_c5_sgd32_ckpt.svh"
module tb_astra_c5_sgd32_ckpt;
  logic clk, rst_n;
  initial clk = 0;
  always #5 clk = ~clk;

  logic signed [15:0] ww [0:31];
  logic signed [15:0] snap [0:31];
  logic tb_ld, ck_ld, go_p, go_r, ret, clr;
  logic [4:0] tb_idx, ck_idx;
  logic signed [15:0] tb_w, ck_w;
  logic busy, pers, rest;
  logic [3:0] ph, fail;
  logic [15:0] seq, crco;
  logic freeze, sgd_rdy, sgd_done;
  logic signed [15:0] vq;
  logic signed [7:0] dummy_x [0:31];

  logic awv, awr, wv, wr, wlast, bv, br;
  logic [27:0] awa;
  logic [127:0] wd;
  logic [15:0] wstrb;
  logic [1:0] bresp;
  logic arv, arr, rv, rr, rlast;
  logic [27:0] ara;
  logic [127:0] rd;
  logic [1:0] rresp;
  logic [3:0] bid, rid, awid, arid;
  logic [7:0] awlen, arlen;
  logic [2:0] awsz, arsz;
  logic [1:0] awb, arb;

  logic [127:0] mem [0:15];
  logic inj_berr, inj_crc;
  int failn, i, guard;
  string first_div;
  typedef enum logic [1:0] { M_IDLE, M_W, M_B, M_R } mst_t;
  mst_t mst;

  a7ng_shared_rank_sgd_q8_sym_f2r2 u_sgd (
    .clk(clk), .rst_n(rst_n), .freeze_i(freeze),
    .go_score_i(1'b0), .go_upd_i(1'b0), .x_i(dummy_x), .reward_i(4'sd0),
    .load_v_i(ck_ld | tb_ld),
    .load_idx_i(ck_ld ? ck_idx : tb_idx),
    .load_w_i(ck_ld ? ck_w : tb_w),
    .w_o(ww), .ready_o(sgd_rdy), .done_o(sgd_done), .v_q8_o(vq)
  );

  a7ng_astra_c5_sgd32_ckpt u_ck (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .go_persist_i(go_p), .go_reload_i(go_r), .retire_i(ret), .clr_i(clr),
    .w_i(ww),
    .load_v_o(ck_ld), .load_idx_o(ck_idx), .load_w_o(ck_w),
    .busy_o(busy), .phase_o(ph), .fail_o(fail),
    .persisted_o(pers), .restored_o(rest), .seq_o(seq), .crc_o(crco),
    .m_axi_awid(awid), .m_axi_awaddr(awa), .m_axi_awlen(awlen),
    .m_axi_awsize(awsz), .m_axi_awburst(awb),
    .m_axi_awvalid(awv), .m_axi_awready(awr),
    .m_axi_wdata(wd), .m_axi_wstrb(wstrb), .m_axi_wlast(wlast),
    .m_axi_wvalid(wv), .m_axi_wready(wr),
    .m_axi_bid(bid), .m_axi_bresp(bresp), .m_axi_bvalid(bv), .m_axi_bready(br),
    .m_axi_arid(arid), .m_axi_araddr(ara), .m_axi_arlen(arlen),
    .m_axi_arsize(arsz), .m_axi_arburst(arb),
    .m_axi_arvalid(arv), .m_axi_arready(arr),
    .m_axi_rid(rid), .m_axi_rdata(rd), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rv), .m_axi_rready(rr)
  );

  assign awr = (mst == M_IDLE);
  assign arr = (mst == M_IDLE);
  assign wr  = (mst == M_W);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mst <= M_IDLE; bv <= 0; rv <= 0; rd <= 0; rlast <= 0; bresp <= 0; rresp <= 0;
      bid <= 0; rid <= 0;
    end else unique case (mst)
      M_IDLE: begin
        bv <= 0; rv <= 0;
        if (awv && awr) mst <= M_W;
        else if (arv && arr) begin
          rd <= mem[ara[7:4]];
          rresp <= 2'b00; rlast <= 1'b1; rv <= 1'b1; rid <= arid; mst <= M_R;
        end
      end
      M_W: if (wv && wr) begin
        mem[awa[7:4]] <= wd;
        bresp <= inj_berr ? 2'b10 : 2'b00;
        bid <= awid; bv <= 1'b1; mst <= M_B;
      end
      M_B: if (bv && br) begin bv <= 1'b0; mst <= M_IDLE; end
      M_R: if (rv && rr) begin rv <= 1'b0; mst <= M_IDLE; end
      default: mst <= M_IDLE;
    endcase
  end

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div == "") first_div = tag;
        $display("FAIL %s", tag); failn = failn + 1;
      end else $display("PASS %s", tag);
    end
  endtask
  task automatic wait_ph(input logic [3:0] p);
    begin
      guard = 0;
      while ((ph != p) && (ph != A7NG_C5K_PH_FAILED) && guard < 20000) begin
        @(posedge clk); guard = guard + 1;
      end
    end
  endtask
  task automatic tb_load_all(input logic signed [15:0] base, input bit zero);
    begin
      for (i = 0; i < 32; i = i + 1) begin
        @(posedge clk);
        tb_idx <= i[4:0];
        tb_w <= zero ? 16'sd0 : (base + i[15:0] * 16'sd13) * (i[0] ? -16'sd1 : 16'sd1);
        tb_ld <= 1'b1;
        @(posedge clk);
        tb_ld <= 1'b0;
      end
      repeat (2) @(posedge clk);
    end
  endtask
  function automatic bit match32();
    integer t; begin
      match32 = 1'b1;
      for (t = 0; t < 32; t = t + 1) if (ww[t] !== snap[t]) match32 = 1'b0;
    end
  endfunction
  function automatic bit all0();
    integer t; begin
      all0 = 1'b1;
      for (t = 0; t < 32; t = t + 1) if (ww[t] !== 16'sd0) all0 = 1'b0;
    end
  endfunction

  initial begin
    failn = 0; first_div = ""; rst_n = 0; freeze = 0;
    go_p = 0; go_r = 0; ret = 0; clr = 0; tb_ld = 0; tb_idx = 0; tb_w = 0;
    inj_berr = 0; inj_crc = 0;
    for (i = 0; i < 32; i = i + 1) dummy_x[i] = 8'sd0;
    for (i = 0; i < 16; i = i + 1) mem[i] = 128'd0;
    repeat (4) @(posedge clk); rst_n = 1; repeat (4) @(posedge clk);
    $display("C5_SGD32_CKPT PROGRAM=NO BOARD_PASS=REJECT C2_KEEP=UNEDITED MIG=NO");

    tb_load_all(16'sd40, 1'b0);
    for (i = 0; i < 32; i = i + 1) snap[i] = ww[i];
    $display("MEAS_BASE w0=%0d w31=%0d", ww[0], ww[31]);
    chk("BASE_NZ", (ww[0] != 0) && (ww[17] != 0) && (ww[31] != 0));

    @(posedge clk); go_p <= 1; @(posedge clk); go_p <= 0;
    wait_ph(A7NG_C5K_PH_PERSISTED);
    chk("PERS", pers && (ph == A7NG_C5K_PH_PERSISTED));
    @(posedge clk); ret <= 1; @(posedge clk); ret <= 0; wait (!busy); repeat (2) @(posedge clk);

    tb_load_all(16'sd0, 1'b1);
    chk("CLEARED", all0());

    @(posedge clk); go_r <= 1; @(posedge clk); go_r <= 0;
    wait_ph(A7NG_C5K_PH_READY);
    chk("REST", rest && (ph == A7NG_C5K_PH_READY));
    chk("EXACT32", match32());
    if (match32() && rest) $display("CLASS_exact32_reload HIT");
    else $display("CLASS_exact32_reload MISS");
    @(posedge clk); ret <= 1; @(posedge clk); ret <= 0; wait (!busy);

    tb_load_all(16'sd0, 1'b1);
    mem[1] <= mem[1] ^ 128'h1;
    @(posedge clk); go_r <= 1; @(posedge clk); go_r <= 0;
    wait_ph(A7NG_C5K_PH_FAILED);
    chk("CRC_FAIL", fail == A7NG_C5K_F_CRC);
    chk("CRC_NO_REST", !rest);
    chk("CRC_STILL0", all0());
    if ((fail == A7NG_C5K_F_CRC) && all0() && !rest) $display("CLASS_crc_no_install HIT");
    else $display("CLASS_crc_no_install MISS fail=%0d rest=%0d", fail, rest);
    @(posedge clk); ret <= 1; @(posedge clk); ret <= 0; wait (!busy);

    inj_berr = 1;
    tb_load_all(16'sd40, 1'b0);
    @(posedge clk); go_p <= 1; @(posedge clk); go_p <= 0;
    wait_ph(A7NG_C5K_PH_FAILED);
    chk("BRESP_FAIL", fail == A7NG_C5K_F_BRESP);
    chk("BRESP_NO_PERS", !pers);
    if ((fail == A7NG_C5K_F_BRESP) && !pers) $display("CLASS_bresp_no_persist HIT");
    else $display("CLASS_bresp_no_persist MISS fail=%0d pers=%0d", fail, pers);

    if (failn == 0) $display("ASTRA_C5_SGD32_CKPT_XSIM_PASS");
    else $display("ASTRA_C5_SGD32_CKPT_XSIM_FAIL n=%0d first=%s", failn, first_div);
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO PERSIST_SCHEMA_VERSION=NOT_FROZEN 01B_TOP=OPEN");
    $finish;
  end
endmodule
