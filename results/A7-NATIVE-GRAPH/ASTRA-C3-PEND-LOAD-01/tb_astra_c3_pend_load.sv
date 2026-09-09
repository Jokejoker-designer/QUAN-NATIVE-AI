`timescale 1ns / 1ps
// ASTRA-C3-PEND-LOAD-01. PROGRAM=NO. Named C3 + ckpt_pend. Modeled AXI.
`include "a7ng_astra_c3_held_out.svh"
`include "a7ng_astra_c5_sgd32_ckpt_pend.svh"
module tb_astra_c3_pend_load;
  logic clk, rst_n;
  initial clk = 0;
  always #5 clk = ~clk;

  logic signed [15:0] ww [0:31];
  logic signed [15:0] snap [0:31];
  logic signed [7:0]  phi_o [0:31];
  logic signed [7:0]  phi_snap [0:31];
  logic tb_ld, ck_ld, phi_ld, pend_ld, go_p, go_r, ret_ck, clr_ck;
  logic tb_phi, tb_pend, clr_pend, c3_ret;
  logic [4:0] tb_idx, ck_idx, phi_idx, tb_phi_idx;
  logic signed [15:0] tb_w, ck_w;
  logic signed [7:0]  phi_w, tb_phi_w;
  logic [19:0] ck_p0, ck_p1, ck_ans, c3_p0, c3_p1, c3_ans;
  logic [19:0] snap_p0, snap_p1, snap_ans;
  logic [1:0]  ck_sel, c3_sel, snap_sel;
  logic [3:0]  ck_st, c3_st, snap_st;
  logic [7:0]  ck_txn, ck_gen, c3_txn, c3_gen, snap_txn, snap_gen;
  logic        ck_acc, ck_cmt, c3_acc, c3_cmt, snap_acc, snap_cmt;
  logic ck_busy, pers, rest, c3_busy, c3_resv, tok_r;
  logic [3:0] ph, fail;
  logic [15:0] seq, crco, nupd, ndup, nbad, nhw, nha;
  logic signed [15:0] vb, vs;
  logic signed [7:0] phi0;
  logic [4:0] npath;
  logic [7:0] obj, ctx, subj;
  logic lftb;

  logic awv, awr, wv, wr, wlast, bv, br;
  logic [27:0] awa, ara, c3_ara;
  logic [127:0] wd, rd;
  logic [15:0] wstrb;
  logic [1:0] bresp, rresp, c3_arb;
  logic arv, arr, rv, rr, rlast, c3_arv, c3_arr, c3_rv, c3_rr, c3_rl;
  logic [3:0] bid, rid, awid, arid, c3_arid, c3_rid;
  logic [7:0] awlen, arlen, c3_arlen;
  logic [2:0] awsz, arsz, c3_arsz;
  logic [1:0] awb, arb;
  logic [127:0] mem [0:15];
  logic [127:0] c3_rd;
  logic [1:0] c3_rresp;
  int failn, i, guard;
  string first_div;
  typedef enum logic [1:0] { M_IDLE, M_W, M_B, M_R } mst_t;
  mst_t mst;

  assign c3_arr = 1'b1;
  assign c3_rv = 1'b0;
  assign c3_rd = 128'd0;
  assign c3_rresp = 2'b00;
  assign c3_rl = 1'b0;
  assign c3_rid = 4'd0;

  a7ng_astra_c3_held_out_pendld u_c3 (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7), .ctrl_i(2'd0),
    .tok_valid_i(1'b0), .tok_ready_o(tok_r), .tok_i(8'd0),
    .fire_i(1'b0), .retire_i(c3_ret),
    .rew_v_i(1'b0), .rew_i(4'sd0), .rew_txn_i(8'd0), .rew_gen_i(8'd0),
    .load_v_i(ck_ld | tb_ld),
    .load_idx_i(ck_ld ? ck_idx : tb_idx),
    .load_w_i(ck_ld ? ck_w : tb_w),
    .phi_load_v_i(phi_ld | tb_phi),
    .phi_idx_i(phi_ld ? phi_idx : tb_phi_idx),
    .phi_w_i(phi_ld ? phi_w : tb_phi_w),
    .pend_load_v_i(pend_ld | tb_pend),
    .pend_p0_i(pend_ld ? ck_p0 : 20'd799999),
    .pend_p1_i(pend_ld ? ck_p1 : 20'd112),
    .pend_ans_i(pend_ld ? ck_ans : 20'd144),
    .pend_sel_i(pend_ld ? ck_sel : 2'd1),
    .pend_st_i(pend_ld ? ck_st : 4'd9),
    .pend_txn_i(pend_ld ? ck_txn : 8'hA5),
    .pend_gen_i(pend_ld ? ck_gen : 8'h3C),
    .pend_acc_i(pend_ld ? ck_acc : 1'b1),
    .pend_cmt_i(pend_ld ? ck_cmt : 1'b0),
    .clr_pend_i(clr_pend),
    .busy_o(c3_busy), .result_v_o(c3_resv),
    .pend_acc_o(c3_acc), .pend_cmt_o(c3_cmt),
    .txn_id_o(c3_txn), .gen_o(c3_gen), .sel_idx_o(c3_sel),
    .ans_o(c3_ans), .proof0_o(c3_p0), .proof1_o(c3_p1),
    .n_path_o(npath), .status_o(c3_st),
    .obj_o(obj), .ctx_o(ctx), .subj_o(subj),
    .n_host_winner_o(nhw), .n_host_addr_o(nha),
    .v_best_o(vb), .v_second_o(vs), .phi0_o(phi0),
    .pend_phi_o(phi_o), .w_o(ww),
    .n_upd_o(nupd), .n_dup_o(ndup), .n_bad_o(nbad), .load_from_tb_o(lftb),
    .m_axi_arid(c3_arid), .m_axi_araddr(c3_ara), .m_axi_arlen(c3_arlen),
    .m_axi_arsize(c3_arsz), .m_axi_arburst(c3_arb),
    .m_axi_arvalid(c3_arv), .m_axi_arready(c3_arr),
    .m_axi_rid(c3_rid), .m_axi_rdata(c3_rd), .m_axi_rresp(c3_rresp),
    .m_axi_rlast(c3_rl), .m_axi_rvalid(c3_rv), .m_axi_rready(c3_rr)
  );

  a7ng_astra_c5_sgd32_ckpt_pend u_ck (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .go_persist_i(go_p), .go_reload_i(go_r), .retire_i(ret_ck), .clr_i(clr_ck),
    .w_i(ww), .phi_i(phi_o),
    .p0_i(c3_p0), .p1_i(c3_p1), .ans_i(c3_ans),
    .sel_i(c3_sel), .st_i(c3_st), .txn_i(c3_txn), .gen_i(c3_gen),
    .pend_acc_i(c3_acc), .pend_cmt_i(c3_cmt),
    .load_v_o(ck_ld), .load_idx_o(ck_idx), .load_w_o(ck_w),
    .phi_load_v_o(phi_ld), .phi_idx_o(phi_idx), .phi_o(phi_w),
    .pend_load_v_o(pend_ld),
    .p0_o(ck_p0), .p1_o(ck_p1), .ans_o(ck_ans),
    .sel_o(ck_sel), .st_o(ck_st), .txn_o(ck_txn), .gen_o(ck_gen),
    .pend_acc_o(ck_acc), .pend_cmt_o(ck_cmt),
    .busy_o(ck_busy), .phase_o(ph), .fail_o(fail),
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
        bresp <= 2'b00;
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
      while ((ph != p) && (ph != A7NG_C5P_PH_FAILED) && guard < 40000) begin
        @(posedge clk); guard = guard + 1;
      end
    end
  endtask
  task automatic tb_load_w(input logic signed [15:0] base, input bit zero);
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
  task automatic plant_phi();
    begin
      for (i = 0; i < 32; i = i + 1) begin
        @(posedge clk);
        tb_phi_idx <= i[4:0];
        tb_phi_w <= 8'(i[7:0] * 8'd7 - 8'd40);
        tb_phi <= 1'b1;
        @(posedge clk);
        tb_phi <= 1'b0;
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
  function automatic bit match_phi();
    integer t; begin
      match_phi = 1'b1;
      for (t = 0; t < 32; t = t + 1) if (phi_o[t] !== phi_snap[t]) match_phi = 1'b0;
    end
  endfunction
  function automatic bit match_pend();
    begin
      match_pend = (c3_p0 === snap_p0) && (c3_p1 === snap_p1) &&
                   (c3_ans === snap_ans) && (c3_sel === snap_sel) &&
                   (c3_st === snap_st) && (c3_txn === snap_txn) &&
                   (c3_gen === snap_gen) && (c3_acc === snap_acc) &&
                   (c3_cmt === snap_cmt);
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
      pend0 = (c3_p0 === 20'd0) && (c3_p1 === 20'd0) && (c3_ans === 20'd0) &&
              (c3_acc === 1'b0) && (c3_cmt === 1'b0);
      for (t = 0; t < 32; t = t + 1) if (phi_o[t] !== 8'sd0) pend0 = 1'b0;
    end
  endfunction

  initial begin
    failn = 0; first_div = ""; rst_n = 0;
    go_p = 0; go_r = 0; ret_ck = 0; clr_ck = 0; tb_ld = 0; tb_idx = 0; tb_w = 0;
    tb_phi = 0; tb_pend = 0; clr_pend = 0; c3_ret = 0; tb_phi_idx = 0; tb_phi_w = 0;
    for (i = 0; i < 16; i = i + 1) mem[i] = 128'd0;
    repeat (4) @(posedge clk); rst_n = 1; repeat (8) @(posedge clk);
    $display("C3_PEND_LOAD PROGRAM=NO BOARD_PASS=REJECT KEEP_C3=UNEDITED MIG=NO");

    tb_load_w(16'sd40, 1'b0);
    plant_phi();
    @(posedge clk); tb_pend <= 1'b1; @(posedge clk); tb_pend <= 1'b0;
    repeat (4) @(posedge clk);
    for (i = 0; i < 32; i = i + 1) begin snap[i] = ww[i]; phi_snap[i] = phi_o[i]; end
    snap_p0 = c3_p0; snap_p1 = c3_p1; snap_ans = c3_ans;
    snap_sel = c3_sel; snap_st = c3_st; snap_txn = c3_txn; snap_gen = c3_gen;
    snap_acc = c3_acc; snap_cmt = c3_cmt;
    $display("MEAS_BASE w0=%0d p0=%0d phi0=%0d st=%0d acc=%0d hold=%0d",
             ww[0], c3_p0, phi_o[0], c3_st, c3_acc, c3_resv);
    chk("BASE_NZ", (ww[0] != 0) && (c3_p0 == 20'd799999) && (phi_o[0] != phi_o[31]) && c3_resv);

    @(posedge clk); go_p <= 1; @(posedge clk); go_p <= 0;
    wait_ph(A7NG_C5P_PH_PERSISTED);
    chk("PERS", pers);
    @(posedge clk); ret_ck <= 1; @(posedge clk); ret_ck <= 0; wait (!ck_busy);

    @(posedge clk); c3_ret <= 1; @(posedge clk); c3_ret <= 0;
    repeat (4) @(posedge clk);
    @(posedge clk); clr_pend <= 1; @(posedge clk); clr_pend <= 0;
    tb_load_w(16'sd0, 1'b1);
    chk("CLEARED", all0() && pend0() && !c3_busy);

    @(posedge clk); go_r <= 1; @(posedge clk); go_r <= 0;
    wait_ph(A7NG_C5P_PH_READY);
    repeat (4) @(posedge clk);
    chk("REST", rest);
    chk("EXACT32", match32());
    chk("EXACT_PHI", match_phi());
    chk("EXACT_PEND", match_pend());
    if (match32() && rest) $display("CLASS_exact32_reload HIT");
    else $display("CLASS_exact32_reload MISS");
    if (match_phi() && match_pend() && rest && c3_resv)
      $display("CLASS_c3_pend_phi_reload HIT");
    else $display("CLASS_c3_pend_phi_reload MISS p0=%0d", c3_p0);

    if (failn == 0) $display("ASTRA_C3_PEND_LOAD_XSIM_PASS");
    else $display("ASTRA_C3_PEND_LOAD_XSIM_FAIL n=%0d first=%s", failn, first_div);
    $display("C3_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO KEEP_C3=UNEDITED");
    $finish;
  end
endmodule
