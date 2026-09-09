`timescale 1ns / 1ps
// tb_astra_c2_persist_ddr_stall.sv — ASTRA-C2-PERSIST-DDR-STALL-01. PROGRAM=NO.
// Stalling AXI slave, not MIG. Does not compile KEEP persist DUTs.
`include "a7ng_astra_c2_persist_ddr_stall.svh"

module tb_astra_c2_persist_ddr_stall;
  logic clk, rst_n;
  initial clk = 1'b0;
  always #5 clk = ~clk;

  logic persist_clr, reload, retire, upd_v, upd_r, lk_go, lk_hit, busy, dirty;
  logic [3:0] phase, fail_code;
  logic [19:0] us, ur, uo, uc, ls, lr, lo, lc, ps, pr, po, pc;
  logic [7:0] ug, ut, usch, pgen;
  logic signed [3:0] urew;
  logic signed [15:0] live_w0, p_w0;
  logic p_valid;
  logic [1:0] p_axi, last_axi;
  logic [15:0] nupd, nhit, nwb, nstale, nsch, nfalse, naw, nw, nb;
  logic [3:0] awid, arid, bid, rid;
  logic [27:0] awaddr, araddr;
  logic [7:0] awlen, arlen;
  logic [2:0] awsize, arsize;
  logic [1:0] awburst, arburst, bresp, rresp;
  logic awvalid, awready, wvalid, wready, wlast, bvalid, bready;
  logic arvalid, arready, rvalid, rready, rlast;
  logic [127:0] wdata, rdata;
  logic [15:0] wstrb;

  logic [127:0] jmem [0:3];
  logic [1:0] aw_idx, ar_idx;
  logic [27:0] last_aw;
  logic [7:0] cfg_aw = 8'(A7NG_C2ST_STALL_AW);
  logic [7:0] cfg_w  = 8'(A7NG_C2ST_STALL_W);
  logic [7:0] cfg_b  = 8'(A7NG_C2ST_STALL_B);
  logic [7:0] cfg_ar = 8'(A7NG_C2ST_STALL_AR);
  logic [7:0] cfg_r  = 8'(A7NG_C2ST_STALL_R);
  logic [7:0] aw_left = 8'(A7NG_C2ST_STALL_AW);
  logic [7:0] w_left = 8'd0;
  logic [7:0] b_left = 8'd0;
  logic [7:0] ar_left = 8'(A7NG_C2ST_STALL_AR);
  logic [7:0] r_left = 8'd0;
  logic [127:0] w_first;
  logic w_got;
  integer w_unstable = 0;
  integer low16_bad = 0;
  integer saw_early_persist = 0;
  typedef enum logic [2:0] { MX_IDLE, MX_W, MX_B, MX_AR, MX_R } mx_t;
  mx_t mx;
  integer fail, g, n_false_tb;
  string first_div;

  assign awready = (mx == MX_IDLE) && (aw_left == 8'd0);
  assign wready  = (mx == MX_W) && (w_left == 8'd0);
  assign arready = (mx == MX_IDLE) && (ar_left == 8'd0);
  assign bvalid  = (mx == MX_B) && (b_left == 8'd0);
  assign rvalid  = (mx == MX_R) && (r_left == 8'd0);
  assign bid = 4'd1;
  assign rid = 4'd2;
  assign bresp = 2'b00;
  assign rresp = 2'b00;
  assign rlast = 1'b1;
  assign rdata = jmem[ar_idx];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mx <= MX_IDLE;
      aw_idx <= 2'd0;
      ar_idx <= 2'd0;
      w_got <= 1'b0;
      aw_left <= cfg_aw;
      ar_left <= cfg_ar;
      w_left <= 8'd0;
      b_left <= 8'd0;
      r_left <= 8'd0;
    end else unique case (mx)
      MX_IDLE: begin
        w_got <= 1'b0;
        if (awvalid && (aw_left != 8'd0)) begin
          aw_left <= aw_left - 8'd1;
          if (phase == A7NG_C2ST_PH_PERSISTED) saw_early_persist <= saw_early_persist + 1;
        end else if (awvalid && awready) begin
          aw_idx <= awaddr[5:4];
          last_aw <= awaddr;
          w_left <= cfg_w;
          mx <= MX_W;
        end else if (arvalid && (ar_left != 8'd0)) begin
          ar_left <= ar_left - 8'd1;
        end else if (arvalid && arready) begin
          ar_idx <= araddr[5:4];
          r_left <= cfg_r;
          mx <= MX_R;
        end
      end
      MX_W: begin
        if (wvalid && (w_left != 8'd0)) begin
          w_left <= w_left - 8'd1;
          if (!w_got) begin
            w_first <= wdata;
            w_got <= 1'b1;
          end else if (wdata !== w_first) w_unstable <= w_unstable + 1;
          if (phase == A7NG_C2ST_PH_PERSISTED) saw_early_persist <= saw_early_persist + 1;
        end else if (wvalid && wready) begin
          if (w_got && (wdata !== w_first)) w_unstable <= w_unstable + 1;
          b_left <= cfg_b;
          mx <= MX_B;
        end
      end
      MX_B: begin
        if (b_left != 8'd0) begin
          b_left <= b_left - 8'd1;
          if (phase == A7NG_C2ST_PH_PERSISTED) saw_early_persist <= saw_early_persist + 1;
        end else if (bvalid && bready) begin
          mx <= MX_IDLE;
          aw_left <= cfg_aw;
          ar_left <= cfg_ar;
        end
      end
      MX_R: begin
        if (r_left != 8'd0) r_left <= r_left - 8'd1;
        else if (rvalid && rready) begin
          mx <= MX_IDLE;
          aw_left <= cfg_aw;
          ar_left <= cfg_ar;
        end
      end
      default: mx <= MX_IDLE;
    endcase
  end

  always_ff @(posedge clk) begin
    if (mx == MX_W && wvalid && wready) begin
      jmem[aw_idx] <= wdata;
      if (awaddr[15:0] == wdata[19:0]) low16_bad <= low16_bad + 1;
    end
  end

  a7ng_astra_c2_persist_ddr_stall u_dut (
    .clk(clk), .rst_n(rst_n),
    .persist_clr_i(persist_clr), .reload_i(reload), .retire_i(retire),
    .upd_valid_i(upd_v), .upd_ready_o(upd_r),
    .upd_subj_i(us), .upd_rel_i(ur), .upd_obj_i(uo), .upd_ctx_i(uc),
    .upd_gen_i(ug), .upd_txn_i(ut), .upd_schema_i(usch), .upd_rew_i(urew),
    .lk_go_i(lk_go), .lk_subj_i(ls), .lk_rel_i(lr), .lk_obj_i(lo), .lk_ctx_i(lc),
    .lk_hit_o(lk_hit),
    .busy_o(busy), .phase_o(phase), .fail_code_o(fail_code),
    .live_w0_o(live_w0), .dirty_o(dirty),
    .persist_valid_o(p_valid),
    .persist_subj_o(ps), .persist_rel_o(pr), .persist_obj_o(po), .persist_ctx_o(pc),
    .persist_gen_o(pgen), .persist_w0_o(p_w0), .persist_axi_o(p_axi),
    .last_axi_o(last_axi),
    .n_upd_o(nupd), .n_hit_o(nhit), .n_wb_o(nwb), .n_stale_o(nstale),
    .n_schema_o(nsch), .n_false_o(nfalse),
    .n_aw_stall_o(naw), .n_w_stall_o(nw), .n_b_stall_o(nb),
    .m_axi_awid(awid), .m_axi_awaddr(awaddr), .m_axi_awlen(awlen),
    .m_axi_awsize(awsize), .m_axi_awburst(awburst),
    .m_axi_awvalid(awvalid), .m_axi_awready(awready),
    .m_axi_wdata(wdata), .m_axi_wstrb(wstrb), .m_axi_wlast(wlast),
    .m_axi_wvalid(wvalid), .m_axi_wready(wready),
    .m_axi_bid(bid), .m_axi_bresp(bresp), .m_axi_bvalid(bvalid),
    .m_axi_bready(bready),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  task automatic div(input string code, input string detail);
    begin
      if (first_div == "") first_div = {code, " ", detail};
      $display("FIRST_DIVERGENCE %s %s", code, detail);
      fail = fail + 1;
    end
  endtask

  task automatic wait_cyc(input int n);
    integer k;
    begin
      for (k = 0; k < n; k = k + 1) @(posedge clk);
    end
  endtask

  task automatic wait_phase(input logic [3:0] want, input int lim);
    begin
      g = 0;
      if (phase != want) begin
        while ((phase != want) && (g < lim)) begin
          @(posedge clk);
          g = g + 1;
        end
        if (phase != want)
          div("TO_PHASE", $sformatf("want=%0d got=%0d", want, phase));
      end
    end
  endtask

  task automatic pulse_upd;
    begin
      g = 0;
      while (!upd_r && g < 8000) begin @(posedge clk); g = g + 1; end
      if (!upd_r) div("NO_READY", "upd_ready");
      @(negedge clk);
      upd_v = 1'b1;
      @(posedge clk);
      @(negedge clk);
      upd_v = 1'b0;
    end
  endtask

  task automatic pulse_retire;
    begin
      @(negedge clk); retire = 1'b1;
      @(posedge clk);
      @(negedge clk); retire = 1'b0;
      wait_cyc(2);
    end
  endtask

  task automatic pulse_clr;
    begin
      @(negedge clk); persist_clr = 1'b1;
      @(posedge clk);
      @(negedge clk); persist_clr = 1'b0;
      wait_cyc(2);
    end
  endtask

  task automatic hard_rst;
    begin
      rst_n = 1'b0;
      wait_cyc(4);
      rst_n = 1'b1;
      wait_cyc(2);
    end
  endtask

  initial begin
    fail = 0; n_false_tb = 0; first_div = "";
    rst_n = 1'b0; persist_clr = 1'b0; reload = 1'b0; retire = 1'b0;
    upd_v = 1'b0; lk_go = 1'b0;
    us = '0; ur = '0; uo = '0; uc = '0; ug = '0; ut = '0; usch = '0; urew = '0;
    ls = '0; lr = '0; lo = '0; lc = '0;
    wait_cyc(4);
    rst_n = 1'b1;
    wait_cyc(2);
    pulse_clr;

    $display("C2_PERSIST_DDR_STALL N=1 N_AXI=2 STALL_AW=%0d STALL_W=%0d STALL_B=%0d STALL_AR=%0d STALL_R=%0d PROGRAM=NO BOARD_PASS=NOT_CLAIMED MIG=NO",
             A7NG_C2ST_STALL_AW, A7NG_C2ST_STALL_W, A7NG_C2ST_STALL_B, A7NG_C2ST_STALL_AR, A7NG_C2ST_STALL_R);

    if (p_valid || (live_w0 != 16'sd0) || (phase != A7NG_C2ST_PH_IDLE))
      div("RST_BEFORE", $sformatf("pvalid=%0d live=%0d ph=%0d", p_valid, live_w0, phase));
    else $display("CLASS_reset_before_update HIT");

    us = 20'd13; ur = 20'd4; uo = 20'd14; uc = 20'd0;
    ug = 8'd1; ut = 8'd1; usch = 8'd99; urew = 4'sd1;
    pulse_upd;
    wait_phase(A7NG_C2ST_PH_FAILED, 200);
    if (fail_code != A7NG_C2ST_F_SCHEMA || p_valid)
      div("SCHEMA", $sformatf("code=%0d pvalid=%0d", fail_code, p_valid));
    else $display("CLASS_schema_mismatch HIT fail_code=%0d", fail_code);
    pulse_retire;

    usch = A7NG_C2ST_SCHEMA_VER;
    pulse_upd;
    wait_phase(A7NG_C2ST_PH_COMMITTED, 80);
    wait_phase(A7NG_C2ST_PH_PERSISTED, 2000);
    if (!p_valid || ps != 20'd13 || po != 20'd14 || p_w0 != 16'sd1 || last_aw != A7NG_C2ST_PERSIST_BASE)
      div("PERSIST_A", $sformatf("ps=%0h w0=%0d aw=%h", ps, p_w0, last_aw));
    if (naw < 16'(A7NG_C2ST_STALL_AW))
      div("AW_STALL", $sformatf("n_aw_stall=%0d want>=%0d", naw, A7NG_C2ST_STALL_AW));
    else $display("CLASS_aw_stall HIT n_aw_stall=%0d", naw);
    if (nw < 16'(A7NG_C2ST_STALL_W))
      div("W_STALL", $sformatf("n_w_stall=%0d want>=%0d", nw, A7NG_C2ST_STALL_W));
    else $display("CLASS_w_stall HIT n_w_stall=%0d", nw);
    if (nb < 16'(A7NG_C2ST_STALL_B))
      div("B_STALL", $sformatf("n_b_stall=%0d want>=%0d", nb, A7NG_C2ST_STALL_B));
    else $display("CLASS_b_stall HIT n_b_stall=%0d", nb);
    if (w_unstable != 0) div("WDATA", $sformatf("unstable=%0d", w_unstable));
    else $display("CLASS_wdata_stable HIT");
    if (saw_early_persist != 0) div("EARLY_P", $sformatf("n=%0d", saw_early_persist));
    else $display("CLASS_not_persisted_before_b HIT");
    pulse_retire;

    pulse_upd;
    wait_phase(A7NG_C2ST_PH_COMMITTED, 200);
    if (!dirty || live_w0 != 16'sd2 || p_w0 != 16'sd1 || $signed(jmem[0][119:104]) != 16'sd1)
      div("DIRTY", $sformatf("dirty=%0d live=%0d p=%0d j=%0d", dirty, live_w0, p_w0, $signed(jmem[0][119:104])));
    else $display("CLASS_in_place_dirty HIT live=%0d axi0=%0d p_w0=%0d", live_w0, $signed(jmem[0][119:104]), p_w0);
    pulse_retire;

    us = 20'hC34FF; ur = 20'd4; uo = 20'd799998; uc = 20'hABCDE;
    ug = 8'd3; ut = 8'd7; urew = 4'sd2;
    pulse_upd;
    wait_phase(A7NG_C2ST_PH_PERSISTED, 4000);
    if (!p_valid || ps != 20'hC34FF || po != 20'd799998 || pc != 20'hABCDE || p_w0 != 16'sd2
        || nwb != 16'd1
        || jmem[0][19:0] != 20'd13 || $signed(jmem[0][119:104]) != 16'sd2
        || jmem[1][19:0] != 20'hC34FF || $signed(jmem[1][119:104]) != 16'sd2)
      div("WB_STALL", $sformatf("ps=%h w0=%0d nwb=%0d j0=%0h j1=%h", ps, p_w0, nwb, jmem[0][19:0], jmem[1][19:0]));
    else begin
      $display("CLASS_writeback_after_stall HIT axi0_A_w0=2 axi1_B_w0=2 n_wb=%0d", nwb);
      $display("CLASS_high_id_identity HIT subj=%h obj=%0d ctx=%h w0=%0d", ps, po, pc, p_w0);
    end
    pulse_retire;

    ls = 20'h034FF; lr = 20'd4; lo = 20'd799998; lc = 20'hABCDE;
    @(posedge clk);
    if (lk_hit) div("ALIAS", "low16 subject hit full-20 persist");
    else $display("CLASS_alias_attempt HIT lk_hit=0 low16=%h stored=%h", ls, ps);
    ls = 20'hC34FF;
    @(posedge clk);
    if (!lk_hit) div("ALIAS_POS", "full-20 lookup miss");

    if (low16_bad != 0)
      div("LOW16_ADDR", $sformatf("collisions=%0d last_aw=%h", low16_bad, last_aw));
    else $display("CLASS_journal_addr_not_low16 HIT last_aw=%h", last_aw);

    us = 20'd20; ur = 20'd5; uo = 20'd21; uc = 20'd1;
    ug = 8'd1; ut = 8'd9; urew = 4'sd1;
    pulse_upd;
    g = 0;
    while (!awvalid && g < 400) begin @(posedge clk); g = g + 1; end
    if (!awvalid || awready)
      div("RST_STALL_SETUP", $sformatf("awv=%0d awr=%0d ph=%0d", awvalid, awready, phase));
    wait_cyc(3);
    hard_rst;
    if (ps != 20'hC34FF || po != 20'd799998 || live_w0 != 16'sd0 || p_w0 != 16'sd2
        || $signed(jmem[1][119:104]) != 16'sd2)
      div("RST_DURING", $sformatf("ps=%h live=%0d pw0=%0d", ps, live_w0, p_w0));
    else $display("CLASS_reset_during_stall HIT journal_kept_B live_w0=0");

    pulse_clr;
    if (p_valid) div("BRAM_CLR", "on-chip persist still valid");
    reload = 1'b1; @(posedge clk); reload = 1'b0;
    wait_cyc(2);
    wait_phase(A7NG_C2ST_PH_PERSISTED, 2000);
    if (!p_valid || ps != 20'hC34FF || po != 20'd799998 || pc != 20'hABCDE
        || live_w0 != 16'sd2 || p_w0 != 16'sd2)
      div("RELOAD", $sformatf("ps=%h w0=%0d live=%0d", ps, p_w0, live_w0));
    else $display("CLASS_reload_after_stall HIT identity_exact w0=%0d last_axi=%0d", live_w0, last_axi);
    pulse_retire;

    if (nfalse != 0 || n_false_tb != 0)
      div("FALSE_SUCCESS", $sformatf("dut=%0d tb=%0d", nfalse, n_false_tb));
    else $display("CLASS_false_success_zero HIT");

    $display("HEADLINE n_upd=%0d n_hit=%0d n_wb=%0d n_aw_stall=%0d n_w_stall=%0d n_b_stall=%0d n_schema=%0d n_false=%0d",
             nupd, nhit, nwb, naw, nw, nb, nsch, nfalse);
    if (fail == 0 && first_div == "") begin
      $display("RESULT=PASS_THIS_GATE_ONLY");
      $display("NOT_CLAIMED=BOARD_PASS,ACCEPT_BOARD,DDR_QUERY_BOUND_FINAL,MIG,C2_MASTER_CLOSED");
      $display("ASTRA_C2_PERSIST_DDR_STALL_XSIM_PASS");
    end else begin
      $display("RESULT=FAIL fail=%0d", fail);
      $display("ASTRA_C2_PERSIST_DDR_STALL_XSIM_PASS ABSENT");
    end
    $finish;
  end
endmodule
