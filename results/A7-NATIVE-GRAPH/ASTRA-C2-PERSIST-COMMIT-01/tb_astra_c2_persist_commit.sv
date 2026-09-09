`timescale 1ns / 1ps
// tb_astra_c2_persist_commit.sv — ASTRA-C2-PERSIST-COMMIT-01. PROGRAM=NO.
// Modeled AXI journal, not MIG. Does not compile C0/C1 KEEP as DUT.
`include "a7ng_astra_c2_persist_commit.svh"

module tb_astra_c2_persist_commit;
  logic clk, rst_n;
  initial clk = 1'b0;
  always #5 clk = ~clk;

  logic persist_clr, reload, retire, upd_v, upd_r, lk_go, lk_hit, busy;
  logic [3:0] phase, fail_code;
  logic [19:0] us, ur, uo, uc, ls, lr, lo, lc;
  logic [7:0] ug, ut, usch;
  logic signed [3:0] urew;
  logic signed [15:0] live_w0, p_w0;
  logic p_valid;
  logic [19:0] ps, pr, po, pc;
  logic [7:0] pg, pt, psch;
  logic [15:0] nupd, ndup, nstale, nsch, nfalse;
  logic [3:0] awid, arid, bid, rid;
  logic [27:0] awaddr, araddr;
  logic [7:0] awlen, arlen;
  logic [2:0] awsize, arsize;
  logic [1:0] awburst, arburst, bresp, rresp;
  logic awvalid, awready, wvalid, wready, wlast, bvalid, bready;
  logic arvalid, arready, rvalid, rready, rlast;
  logic [127:0] wdata, rdata;
  logic [15:0] wstrb;

  logic [127:0] jmem;
  logic jvalid;
  typedef enum logic [2:0] { MX_IDLE, MX_W, MX_B, MX_AR, MX_R } mx_t;
  mx_t mx;
  integer fail, g, n_false_tb;
  string first_div;

  assign awready = (mx == MX_IDLE);
  assign wready  = (mx == MX_W);
  assign arready = (mx == MX_IDLE);
  assign bid = 4'd1;
  assign rid = 4'd2;
  assign bresp = 2'b00;
  assign rresp = 2'b00;
  assign rlast = 1'b1;
  assign rdata = jmem;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mx <= MX_IDLE;
      bvalid <= 1'b0;
      rvalid <= 1'b0;
    end else unique case (mx)
      MX_IDLE: begin
        bvalid <= 1'b0;
        rvalid <= 1'b0;
        if (awvalid && awready) mx <= MX_W;
        else if (arvalid && arready) begin
          rvalid <= 1'b1;
          mx <= MX_R;
        end
      end
      MX_W: if (wvalid && wready) begin
        bvalid <= 1'b1;
        mx <= MX_B;
      end
      MX_B: if (bvalid && bready) begin
        bvalid <= 1'b0;
        mx <= MX_IDLE;
      end
      MX_R: if (rvalid && rready) begin
        rvalid <= 1'b0;
        mx <= MX_IDLE;
      end
      default: mx <= MX_IDLE;
    endcase
  end

  always_ff @(posedge clk) begin
    if (mx == MX_W && wvalid && wready) begin
      jmem <= wdata;
      jvalid <= 1'b1;
    end
  end

  a7ng_astra_c2_persist_commit u_dut (
    .clk(clk), .rst_n(rst_n),
    .persist_clr_i(persist_clr), .reload_i(reload), .retire_i(retire),
    .upd_valid_i(upd_v), .upd_ready_o(upd_r),
    .upd_subj_i(us), .upd_rel_i(ur), .upd_obj_i(uo), .upd_ctx_i(uc),
    .upd_gen_i(ug), .upd_txn_i(ut), .upd_schema_i(usch), .upd_rew_i(urew),
    .lk_go_i(lk_go), .lk_subj_i(ls), .lk_rel_i(lr), .lk_obj_i(lo), .lk_ctx_i(lc),
    .lk_hit_o(lk_hit),
    .busy_o(busy), .phase_o(phase), .fail_code_o(fail_code),
    .live_w0_o(live_w0),
    .persist_valid_o(p_valid),
    .persist_subj_o(ps), .persist_rel_o(pr), .persist_obj_o(po), .persist_ctx_o(pc),
    .persist_gen_o(pg), .persist_txn_o(pt), .persist_schema_o(psch),
    .persist_w0_o(p_w0),
    .n_upd_o(nupd), .n_dup_o(ndup), .n_stale_o(nstale), .n_schema_o(nsch),
    .n_false_o(nfalse),
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
      if (phase == want) begin
      end else begin
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
      while (!upd_r && g < 4000) begin @(posedge clk); g = g + 1; end
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
    wait_cyc(4);

    $display("C2_PERSIST_COMMIT N=1 SCHEMA=1 ID_W=20 PROGRAM=NO BOARD_PASS=NOT_CLAIMED DDR_QUERY_BOUND_FINAL=NOT_FROZEN MIG=NO AXI_JOURNAL=1");

    // reset before update
    hard_rst;
    if (p_valid || (live_w0 != 16'sd0) || (phase != A7NG_C2_PH_IDLE))
      div("RST_BEFORE", "live/journal not idle-clean on first rst");
    else $display("CLASS_reset_before_update HIT");

    // schema mismatch
    us = 20'd13; ur = 20'd4; uo = 20'd14; uc = 20'd0;
    ug = 8'd1; ut = 8'd1; usch = 8'd99; urew = 4'sd1;
    pulse_upd;
    wait_phase(A7NG_C2_PH_FAILED, 200);
    if (fail_code != A7NG_C2_F_SCHEMA || p_valid)
      div("SCHEMA", $sformatf("code=%0d pvalid=%0d", fail_code, p_valid));
    else $display("CLASS_schema_mismatch HIT fail_code=%0d n_schema=%0d", fail_code, nsch);
    pulse_retire;

    // happy commit
    usch = A7NG_C2_SCHEMA_VER; urew = 4'sd1;
    pulse_upd;
    wait_phase(A7NG_C2_PH_RECEIVED, 40);
    wait_phase(A7NG_C2_PH_ACCEPTED, 40);
    wait_phase(A7NG_C2_PH_COMMITTED, 80);
    wait_phase(A7NG_C2_PH_PERSISTED, 200);
    if (!p_valid || ps != 20'd13 || pr != 20'd4 || po != 20'd14 || pc != 20'd0
        || pg != 8'd1 || p_w0 != 16'sd1 || live_w0 != 16'sd1 || awaddr[15:0] == 16'h000D)
      div("HAPPY", $sformatf("ps=%0h po=%0h w0=%0d aw=%h", ps, po, p_w0, awaddr));
    else $display("CLASS_happy_commit HIT subj=%0d rel=%0d obj=%0d ctx=%0d gen=%0d w0=%0d awaddr=%h",
                  ps, pr, po, pc, pg, p_w0, awaddr);
    if (phase == A7NG_C2_PH_PERSISTED && (ps != 20'd13 || p_w0 != live_w0))
      n_false_tb = n_false_tb + 1;
    pulse_retire;

    // duplicate
    pulse_upd;
    wait_phase(A7NG_C2_PH_FAILED, 200);
    if (fail_code != A7NG_C2_F_DUP || p_w0 != 16'sd1)
      div("DUP", $sformatf("code=%0d w0=%0d", fail_code, p_w0));
    else $display("CLASS_duplicate_reward HIT n_dup=%0d w0_unchanged=%0d", ndup, p_w0);
    pulse_retire;

    // wrong generation
    ug = 8'd2;
    pulse_upd;
    wait_phase(A7NG_C2_PH_FAILED, 200);
    if (fail_code != A7NG_C2_F_STALE_GEN || p_w0 != 16'sd1)
      div("STALE_GEN", $sformatf("code=%0d w0=%0d", fail_code, p_w0));
    else $display("CLASS_wrong_generation HIT n_stale=%0d", nstale);
    pulse_retire;
    ug = 8'd1;

    // high-id (overwrites single journal slot)
    us = 20'hC34FF; ur = 20'd4; uo = 20'd799998; uc = 20'hABCDE;
    ug = 8'd3; ut = 8'd7; urew = 4'sd2;
    pulse_upd;
    wait_phase(A7NG_C2_PH_PERSISTED, 400);
    if (!p_valid || ps != 20'hC34FF || po != 20'd799998 || pc != 20'hABCDE
        || pg != 8'd3 || p_w0 != 16'sd3)
      div("HIGH_ID", $sformatf("ps=%h po=%0d ctx=%h w0=%0d", ps, po, pc, p_w0));
    else $display("CLASS_high_id_identity HIT subj=%h obj=%0d ctx=%h gen=%0d w0=%0d",
                  ps, po, pc, pg, p_w0);
    pulse_retire;

    // alias attempt: low16 of 0xC34FF must not hit
    ls = 20'h034FF; lr = 20'd4; lo = 20'd799998; lc = 20'hABCDE;
    @(posedge clk);
    if (lk_hit) div("ALIAS", "low16 subject hit full-20 persist");
    else $display("CLASS_alias_attempt HIT lk_hit=0 low16=%h stored=%h", ls, ps);
    ls = 20'hC34FF; lc = 20'hABCDE;
    @(posedge clk);
    if (!lk_hit) div("ALIAS_POS", "full-20 lookup miss");
    else $display("CLASS_alias_full20_hit HIT");

    // reset during ACCEPTED of a new identity — journal must stay high-id
    us = 20'd13; ur = 20'd4; uo = 20'd14; uc = 20'd0;
    ug = 8'd4; ut = 8'd8; urew = 4'sd1;
    pulse_upd;
    wait_phase(A7NG_C2_PH_ACCEPTED, 80);
    hard_rst;
    if (ps != 20'hC34FF || po != 20'd799998 || live_w0 != 16'sd0)
      div("RST_DURING", $sformatf("ps=%h live=%0d", ps, live_w0));
    else $display("CLASS_reset_during_update HIT journal_kept_highid live_w0=0");

    // BRAM/on-chip clear then AXI reload
    persist_clr = 1'b1; @(posedge clk); persist_clr = 1'b0; wait_cyc(2);
    if (p_valid) div("BRAM_CLR", "on-chip journal still valid");
    hard_rst;
    reload = 1'b1; @(posedge clk); reload = 1'b0;
    wait_cyc(2);
    wait_phase(A7NG_C2_PH_PERSISTED, 400);
    if (!p_valid || ps != 20'hC34FF || po != 20'd799998 || pc != 20'hABCDE
        || live_w0 != 16'sd3 || p_w0 != 16'sd3)
      div("RELOAD", $sformatf("ps=%h w0=%0d live=%0d", ps, p_w0, live_w0));
    else $display("CLASS_reset_after_commit_reload HIT identity_exact w0=%0d", live_w0);
    pulse_retire;

    if (awaddr != A7NG_C2_PERSIST_BASE)
      div("LOW16_ADDR", $sformatf("awaddr=%h", awaddr));
    else $display("CLASS_journal_addr_not_low16 HIT awaddr=%h", awaddr);

    if (nfalse != 0 || n_false_tb != 0)
      div("FALSE_SUCCESS", $sformatf("dut=%0d tb=%0d", nfalse, n_false_tb));
    else $display("CLASS_false_success_zero HIT");

    $display("HEADLINE n_upd=%0d n_dup=%0d n_stale=%0d n_schema=%0d n_false=%0d",
             nupd, ndup, nstale, nsch, nfalse);
    if (fail == 0 && first_div == "") begin
      $display("RESULT=PASS_THIS_GATE_ONLY");
      $display("NOT_CLAIMED=BOARD_PASS,ACCEPT_BOARD,DDR_QUERY_BOUND_FINAL,MIG,C2_MASTER_CLOSED");
      $display("ASTRA_C2_PERSIST_COMMIT_XSIM_PASS");
    end else begin
      $display("RESULT=FAIL fail=%0d", fail);
      $display("ASTRA_C2_PERSIST_COMMIT_XSIM_PASS ABSENT");
    end
    $finish;
  end
endmodule
