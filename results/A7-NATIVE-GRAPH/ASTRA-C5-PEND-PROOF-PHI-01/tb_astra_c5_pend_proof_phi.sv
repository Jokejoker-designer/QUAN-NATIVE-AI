`timescale 1ns / 1ps
// ASTRA-C5-PEND-PROOF-PHI-01. PROGRAM=NO. Unit TB. Modeled AXI. Not BOARD.
`include "a7ng_astra_c5_sgd32_ckpt_pend.svh"
module tb_astra_c5_pend_proof_phi;
  logic clk, rst_n;
  initial clk = 0;
  always #5 clk = ~clk;

  logic signed [15:0] ww [0:31];
  logic signed [15:0] snap [0:31];
  logic signed [7:0]  phi_live [0:31];
  logic signed [7:0]  phi_snap [0:31];
  logic signed [7:0]  dummy_x [0:31];
  logic tb_ld, ck_ld, phi_ld, pend_ld, go_p, go_r, ret, clr;
  logic tb_phi_wr, tb_pend_wr, tb_pend_clr;
  logic [4:0] tb_idx, ck_idx, phi_idx, tb_phi_idx;
  logic signed [7:0] tb_phi;
  logic signed [15:0] tb_w, ck_w;
  logic signed [7:0]  phi_w;
  logic [19:0] live_p0, live_p1, live_ans, ck_p0, ck_p1, ck_ans;
  logic [19:0] snap_p0, snap_p1, snap_ans;
  logic [1:0]  live_sel, ck_sel, snap_sel;
  logic [3:0]  live_st, ck_st, snap_st;
  logic [7:0]  live_txn, live_gen, ck_txn, ck_gen, snap_txn, snap_gen;
  logic        live_acc, live_cmt, ck_acc, ck_cmt, snap_acc, snap_cmt;
  logic busy, pers, rest, freeze, sgd_rdy, sgd_done;
  logic [3:0] ph, fail;
  logic [15:0] seq, crco;
  logic signed [15:0] vq;

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
  logic inj_berr;
  int failn, i, kp, guard;
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

  a7ng_astra_c5_sgd32_ckpt_pend u_ck (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .go_persist_i(go_p), .go_reload_i(go_r), .retire_i(ret), .clr_i(clr),
    .w_i(ww), .phi_i(phi_live),
    .p0_i(live_p0), .p1_i(live_p1), .ans_i(live_ans),
    .sel_i(live_sel), .st_i(live_st), .txn_i(live_txn), .gen_i(live_gen),
    .pend_acc_i(live_acc), .pend_cmt_i(live_cmt),
    .load_v_o(ck_ld), .load_idx_o(ck_idx), .load_w_o(ck_w),
    .phi_load_v_o(phi_ld), .phi_idx_o(phi_idx), .phi_o(phi_w),
    .pend_load_v_o(pend_ld),
    .p0_o(ck_p0), .p1_o(ck_p1), .ans_o(ck_ans),
    .sel_o(ck_sel), .st_o(ck_st), .txn_o(ck_txn), .gen_o(ck_gen),
    .pend_acc_o(ck_acc), .pend_cmt_o(ck_cmt),
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

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      live_p0 <= 20'd0; live_p1 <= 20'd0; live_ans <= 20'd0;
      live_sel <= 2'd0; live_st <= 4'd0; live_txn <= 8'd0; live_gen <= 8'd0;
      live_acc <= 1'b0; live_cmt <= 1'b0;
      for (kp = 0; kp < 32; kp = kp + 1) phi_live[kp] <= 8'sd0;
    end else begin
      if (tb_pend_clr) begin
        live_p0 <= 20'd0; live_p1 <= 20'd0; live_ans <= 20'd0;
        live_sel <= 2'd0; live_st <= 4'd0; live_txn <= 8'd0; live_gen <= 8'd0;
        live_acc <= 1'b0; live_cmt <= 1'b0;
        for (kp = 0; kp < 32; kp = kp + 1) phi_live[kp] <= 8'sd0;
      end else begin
        if (tb_phi_wr) phi_live[tb_phi_idx] <= tb_phi;
        else if (phi_ld) phi_live[phi_idx] <= phi_w;
        if (tb_pend_wr) begin
          live_p0 <= 20'd799999; live_p1 <= 20'd112; live_ans <= 20'd144;
          live_sel <= 2'd1; live_st <= 4'd9; live_txn <= 8'hA5; live_gen <= 8'h3C;
          live_acc <= 1'b1; live_cmt <= 1'b0;
        end else if (pend_ld) begin
          live_p0 <= ck_p0; live_p1 <= ck_p1; live_ans <= ck_ans;
          live_sel <= ck_sel; live_st <= ck_st; live_txn <= ck_txn; live_gen <= ck_gen;
          live_acc <= ck_acc; live_cmt <= ck_cmt;
        end
      end
    end
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
      while ((ph != p) && (ph != A7NG_C5P_PH_FAILED) && guard < 40000) begin
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
  task automatic plant_pend();
    begin
      for (i = 0; i < 32; i = i + 1) begin
        @(posedge clk);
        tb_phi_idx <= i[4:0];
        tb_phi <= 8'(i[7:0] * 8'd7 - 8'd40);
        tb_phi_wr <= 1'b1;
        @(posedge clk);
        tb_phi_wr <= 1'b0;
      end
      @(posedge clk); tb_pend_wr <= 1'b1; @(posedge clk); tb_pend_wr <= 1'b0;
      repeat (2) @(posedge clk);
    end
  endtask
  task automatic clear_pend();
    begin
      @(posedge clk); tb_pend_clr <= 1'b1; @(posedge clk); tb_pend_clr <= 1'b0;
      repeat (2) @(posedge clk);
    end
  endtask
  function automatic bit match32();
    integer t; begin
      match32 = 1'b1;
      for (t = 0; t < 32; t = t + 1) if (ww[t] !== snap[t]) match32 = 1'b0;
    end
  endfunction
  function automatic bit match_phi();
    integer t; begin
      match_phi = 1'b1;
      for (t = 0; t < 32; t = t + 1) if (phi_live[t] !== phi_snap[t]) match_phi = 1'b0;
    end
  endfunction
  function automatic bit match_pend();
    begin
      match_pend = (live_p0 === snap_p0) && (live_p1 === snap_p1) &&
                   (live_ans === snap_ans) && (live_sel === snap_sel) &&
                   (live_st === snap_st) && (live_txn === snap_txn) &&
                   (live_gen === snap_gen) && (live_acc === snap_acc) &&
                   (live_cmt === snap_cmt);
    end
  endfunction
  function automatic bit all0();
    integer t; begin
      all0 = 1'b1;
      for (t = 0; t < 32; t = t + 1) if (ww[t] !== 16'sd0) all0 = 1'b0;
    end
  endfunction
  function automatic bit pend0();
    integer t; begin
      pend0 = (live_p0 === 20'd0) && (live_p1 === 20'd0) && (live_ans === 20'd0) &&
              (live_sel === 2'd0) && (live_st === 4'd0) && (live_txn === 8'd0) &&
              (live_gen === 8'd0) && (live_acc === 1'b0) && (live_cmt === 1'b0);
      for (t = 0; t < 32; t = t + 1) if (phi_live[t] !== 8'sd0) pend0 = 1'b0;
    end
  endfunction

  initial begin
    failn = 0; first_div = ""; rst_n = 0; freeze = 0;
    go_p = 0; go_r = 0; ret = 0; clr = 0; tb_ld = 0; tb_idx = 0; tb_w = 0;
    tb_phi_wr = 0; tb_pend_wr = 0; tb_pend_clr = 0; tb_phi_idx = 0; tb_phi = 0;
    inj_berr = 0;
    for (i = 0; i < 32; i = i + 1) dummy_x[i] = 8'sd0;
    for (i = 0; i < 16; i = i + 1) mem[i] = 128'd0;
    repeat (4) @(posedge clk); rst_n = 1; repeat (4) @(posedge clk);
    $display("C5_PEND_PROOF_PHI PROGRAM=NO BOARD_PASS=REJECT C2_KEEP=UNEDITED MIG=NO");

    tb_load_all(16'sd40, 1'b0);
    plant_pend();
    for (i = 0; i < 32; i = i + 1) begin snap[i] = ww[i]; phi_snap[i] = phi_live[i]; end
    snap_p0 = live_p0; snap_p1 = live_p1; snap_ans = live_ans;
    snap_sel = live_sel; snap_st = live_st; snap_txn = live_txn; snap_gen = live_gen;
    snap_acc = live_acc; snap_cmt = live_cmt;
    $display("MEAS_BASE w0=%0d w31=%0d p0=%0d phi0=%0d phi31=%0d",
             ww[0], ww[31], live_p0, phi_live[0], phi_live[31]);
    chk("BASE_NZ", (ww[0] != 0) && (ww[17] != 0) && (live_p0 == 20'd799999) &&
        (phi_live[0] != phi_live[31]) && (live_st == 4'd9));

    @(posedge clk); go_p <= 1; @(posedge clk); go_p <= 0;
    wait_ph(A7NG_C5P_PH_PERSISTED);
    chk("PERS", pers && (ph == A7NG_C5P_PH_PERSISTED));
    @(posedge clk); ret <= 1; @(posedge clk); ret <= 0; wait (!busy); repeat (2) @(posedge clk);

    tb_load_all(16'sd0, 1'b1);
    clear_pend();
    chk("CLEARED", all0() && pend0());

    @(posedge clk); go_r <= 1; @(posedge clk); go_r <= 0;
    wait_ph(A7NG_C5P_PH_READY);
    chk("REST", rest && (ph == A7NG_C5P_PH_READY));
    chk("EXACT32", match32());
    chk("EXACT_PHI", match_phi());
    chk("EXACT_PEND", match_pend());
    if (match32() && rest) $display("CLASS_exact32_reload HIT");
    else $display("CLASS_exact32_reload MISS");
    if (match_phi() && match_pend() && rest) $display("CLASS_exact_pend_phi_reload HIT");
    else $display("CLASS_exact_pend_phi_reload MISS p0=%0d", live_p0);
    @(posedge clk); ret <= 1; @(posedge clk); ret <= 0; wait (!busy);

    tb_load_all(16'sd0, 1'b1);
    clear_pend();
    mem[5] <= mem[5] ^ 128'h1;
    @(posedge clk); go_r <= 1; @(posedge clk); go_r <= 0;
    wait_ph(A7NG_C5P_PH_FAILED);
    chk("CRC_FAIL", fail == A7NG_C5P_F_CRC);
    chk("CRC_NO_REST", !rest);
    chk("CRC_STILL0", all0() && pend0());
    if ((fail == A7NG_C5P_F_CRC) && all0() && pend0() && !rest)
      $display("CLASS_crc_no_install HIT");
    else $display("CLASS_crc_no_install MISS fail=%0d rest=%0d", fail, rest);
    @(posedge clk); ret <= 1; @(posedge clk); ret <= 0; wait (!busy);

    mem[0][31:24] <= 8'd1;
    @(posedge clk); go_r <= 1; @(posedge clk); go_r <= 0;
    wait_ph(A7NG_C5P_PH_FAILED);
    chk("SCHEMA_FAIL", fail == A7NG_C5P_F_SCHEMA);
    chk("SCHEMA_NO_REST", !rest);
    if ((fail == A7NG_C5P_F_SCHEMA) && !rest) $display("CLASS_schema1_reject HIT");
    else $display("CLASS_schema1_reject MISS fail=%0d", fail);
    @(posedge clk); ret <= 1; @(posedge clk); ret <= 0; wait (!busy);

    inj_berr = 1;
    tb_load_all(16'sd40, 1'b0);
    plant_pend();
    @(posedge clk); go_p <= 1; @(posedge clk); go_p <= 0;
    wait_ph(A7NG_C5P_PH_FAILED);
    chk("BRESP_FAIL", fail == A7NG_C5P_F_BRESP);
    chk("BRESP_NO_PERS", !pers);
    if ((fail == A7NG_C5P_F_BRESP) && !pers) $display("CLASS_bresp_no_persist HIT");
    else $display("CLASS_bresp_no_persist MISS fail=%0d pers=%0d", fail, pers);

    if (failn == 0) $display("ASTRA_C5_PEND_PROOF_PHI_XSIM_PASS");
    else $display("ASTRA_C5_PEND_PROOF_PHI_XSIM_FAIL n=%0d first=%s", failn, first_div);
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO PERSIST_SCHEMA_VERSION=NOT_FROZEN");
    $finish;
  end
endmodule
