`timescale 1ns / 1ps
// tb_astra_c2_persist_multi_slot.sv — ASTRA-C2-PERSIST-MULTI-SLOT-01. PROGRAM=NO.
// Modeled AXI journal array, not MIG. Does not compile C0/C1 KEEP or persist-commit as DUT.
`include "a7ng_astra_c2_persist_multi_slot.svh"

module tb_astra_c2_persist_multi_slot;
  logic clk, rst_n;
  initial clk = 1'b0;
  always #5 clk = ~clk;

  logic persist_clr, reload, retire, upd_v, upd_r, lk_go, lk_hit, busy, cap_full;
  logic [3:0] phase, fail_code;
  logic [19:0] us, ur, uo, uc, ls, lr, lo, lc;
  logic [7:0] ug, ut, usch, occ;
  logic signed [3:0] urew;
  logic signed [15:0] live_w0, s0_w0, s1_w0;
  logic s0_valid, s0_dirty, s1_valid, s1_dirty;
  logic [19:0] s0_subj, s0_obj, s0_ctx, s1_subj, s1_obj, s1_ctx;
  logic [1:0] s0_axi, s1_axi;
  logic [15:0] nupd, nhit, nmiss, nevict, nwb, nstale, nsch, nfalse;
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
  typedef enum logic [2:0] { MX_IDLE, MX_W, MX_B, MX_AR, MX_R } mx_t;
  mx_t mx;
  integer fail, g, n_false_tb;
  integer low16_bad = 0;
  string first_div;

  assign awready = (mx == MX_IDLE);
  assign wready  = (mx == MX_W);
  assign arready = (mx == MX_IDLE);
  assign bid = 4'd1;
  assign rid = 4'd2;
  assign bresp = 2'b00;
  assign rresp = 2'b00;
  assign rlast = 1'b1;
  assign rdata = jmem[ar_idx];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mx <= MX_IDLE;
      bvalid <= 1'b0;
      rvalid <= 1'b0;
      aw_idx <= 2'd0;
      ar_idx <= 2'd0;
    end else unique case (mx)
      MX_IDLE: begin
        bvalid <= 1'b0;
        rvalid <= 1'b0;
        if (awvalid && awready) begin
          aw_idx <= awaddr[5:4];
          last_aw <= awaddr;
          mx <= MX_W;
        end else if (arvalid && arready) begin
          ar_idx <= araddr[5:4];
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
      jmem[aw_idx] <= wdata;
      if (awaddr[15:0] == wdata[19:0]) low16_bad <= low16_bad + 1;
    end
  end

  a7ng_astra_c2_persist_multi_slot u_dut (
    .clk(clk), .rst_n(rst_n),
    .persist_clr_i(persist_clr), .reload_i(reload), .retire_i(retire),
    .upd_valid_i(upd_v), .upd_ready_o(upd_r),
    .upd_subj_i(us), .upd_rel_i(ur), .upd_obj_i(uo), .upd_ctx_i(uc),
    .upd_gen_i(ug), .upd_txn_i(ut), .upd_schema_i(usch), .upd_rew_i(urew),
    .lk_go_i(lk_go), .lk_subj_i(ls), .lk_rel_i(lr), .lk_obj_i(lo), .lk_ctx_i(lc),
    .lk_hit_o(lk_hit),
    .busy_o(busy), .phase_o(phase), .fail_code_o(fail_code),
    .live_w0_o(live_w0),
    .occ_o(occ), .cap_full_o(cap_full),
    .s0_valid_o(s0_valid), .s0_dirty_o(s0_dirty),
    .s0_subj_o(s0_subj), .s0_obj_o(s0_obj), .s0_ctx_o(s0_ctx),
    .s0_w0_o(s0_w0), .s0_axi_o(s0_axi),
    .s1_valid_o(s1_valid), .s1_dirty_o(s1_dirty),
    .s1_subj_o(s1_subj), .s1_obj_o(s1_obj), .s1_ctx_o(s1_ctx),
    .s1_w0_o(s1_w0), .s1_axi_o(s1_axi),
    .n_upd_o(nupd), .n_hit_o(nhit), .n_miss_o(nmiss),
    .n_evict_o(nevict), .n_wb_o(nwb), .n_stale_o(nstale),
    .n_schema_o(nsch), .n_false_o(nfalse),
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

  task automatic pulse_clr;
    begin
      @(negedge clk); persist_clr = 1'b1;
      @(posedge clk);
      @(negedge clk); persist_clr = 1'b0;
      wait_cyc(2);
    end
  endtask

  task automatic do_lk(
      input logic [19:0] s, r, o, c,
      input logic want_hit, input string tag);
    begin
      ls = s; lr = r; lo = o; lc = c;
      @(posedge clk);
      if (lk_hit !== want_hit)
        div("LK", $sformatf("%s hit=%0d want=%0d", tag, lk_hit, want_hit));
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

    $display("C2_PERSIST_MULTI_SLOT CAP_N=2 N_AXI=4 SCHEMA=1 ID_W=20 PROGRAM=NO BOARD_PASS=NOT_CLAIMED DDR_QUERY_BOUND_FINAL=NOT_FROZEN MIG=NO AXI_JOURNAL=1");

    if (s0_valid || s1_valid || (live_w0 != 16'sd0) || (phase != A7NG_C2MS_PH_IDLE) || (occ != 8'd0))
      div("RST_BEFORE", $sformatf("occ=%0d s0v=%0d live=%0d ph=%0d", occ, s0_valid, live_w0, phase));
    else $display("CLASS_reset_before_update HIT");

    us = 20'd13; ur = 20'd4; uo = 20'd14; uc = 20'd0;
    ug = 8'd1; ut = 8'd1; usch = 8'd99; urew = 4'sd1;
    pulse_upd;
    wait_phase(A7NG_C2MS_PH_FAILED, 200);
    if (fail_code != A7NG_C2MS_F_SCHEMA || s0_valid)
      div("SCHEMA", $sformatf("code=%0d s0v=%0d", fail_code, s0_valid));
    else $display("CLASS_schema_mismatch HIT fail_code=%0d n_schema=%0d", fail_code, nsch);
    pulse_retire;

    usch = A7NG_C2MS_SCHEMA_VER; urew = 4'sd1;
    pulse_upd;
    wait_phase(A7NG_C2MS_PH_RECEIVED, 40);
    wait_phase(A7NG_C2MS_PH_ACCEPTED, 40);
    wait_phase(A7NG_C2MS_PH_COMMITTED, 80);
    wait_phase(A7NG_C2MS_PH_PERSISTED, 400);
    if (!s0_valid || s0_subj != 20'd13 || s0_obj != 20'd14 || s0_w0 != 16'sd1
        || occ != 8'd1 || last_aw != A7NG_C2MS_PERSIST_BASE)
      div("MISS_A", $sformatf("s0=%0h w0=%0d occ=%0d aw=%h", s0_subj, s0_w0, occ, last_aw));
    else $display("CLASS_miss_allocate HIT subj=%0d w0=%0d occ=%0d awaddr=%h",
                  s0_subj, s0_w0, occ, last_aw);
    pulse_retire;

    do_lk(20'd13, 20'd4, 20'd14, 20'd0, 1'b1, "A");
    if (occ != 8'd1) div("HIT_OCC", $sformatf("occ=%0d", occ));
    else $display("CLASS_cache_hit HIT occ=%0d", occ);

    ug = 8'd2;
    pulse_upd;
    wait_phase(A7NG_C2MS_PH_FAILED, 200);
    if (fail_code != A7NG_C2MS_F_STALE_GEN || s0_w0 != 16'sd1)
      div("STALE_GEN", $sformatf("code=%0d w0=%0d", fail_code, s0_w0));
    else $display("CLASS_wrong_generation HIT n_stale=%0d", nstale);
    pulse_retire;
    ug = 8'd1; ut = 8'd2;

    pulse_upd;
    wait_phase(A7NG_C2MS_PH_COMMITTED, 200);
    if (!s0_dirty || s0_w0 != 16'sd2 || jmem[0][119:104] != 16'sd1 || occ != 8'd1)
      div("DIRTY", $sformatf("dirty=%0d w0=%0d jw0=%0d", s0_dirty, s0_w0, $signed(jmem[0][119:104])));
    else $display("CLASS_in_place_dirty HIT cache_w0=%0d axi0_w0=%0d dirty=1", s0_w0, $signed(jmem[0][119:104]));
    pulse_retire;

    us = 20'hC34FF; ur = 20'd4; uo = 20'd799998; uc = 20'hABCDE;
    ug = 8'd3; ut = 8'd7; urew = 4'sd2;
    pulse_upd;
    wait_phase(A7NG_C2MS_PH_PERSISTED, 400);
    if (!s1_valid || s1_subj != 20'hC34FF || s1_obj != 20'd799998 || s1_ctx != 20'hABCDE
        || s1_w0 != 16'sd2 || occ != 8'd2 || !cap_full)
      div("MULTI", $sformatf("s1=%h w0=%0d occ=%0d cap=%0d", s1_subj, s1_w0, occ, cap_full));
    else begin
      $display("CLASS_multi_slot HIT s0A=%0d s1B=%h occ=2", s0_subj, s1_subj);
      $display("CLASS_full_capacity HIT cap_full=%0d", cap_full);
      $display("CLASS_high_id_identity HIT subj=%h obj=%0d ctx=%h w0=%0d",
               s1_subj, s1_obj, s1_ctx, s1_w0);
    end
    do_lk(20'd13, 20'd4, 20'd14, 20'd0, 1'b1, "A_still");
    do_lk(20'hC34FF, 20'd4, 20'd799998, 20'hABCDE, 1'b1, "B");
    pulse_retire;

    us = 20'd20; ur = 20'd5; uo = 20'd21; uc = 20'd1;
    ug = 8'd1; ut = 8'd9; urew = 4'sd1;
    pulse_upd;
    wait_phase(A7NG_C2MS_PH_PERSISTED, 800);
    if (s0_subj != 20'd20 || s0_obj != 20'd21 || s0_w0 != 16'sd1
        || s1_subj != 20'hC34FF || s1_w0 != 16'sd2 || occ != 8'd2 || nevict != 16'd1)
      div("EVICT", $sformatf("s0=%0d s1=%h occ=%0d ne=%0d", s0_subj, s1_subj, occ, nevict));
    else $display("CLASS_dirty_eviction HIT victimA_out C_in s0=%0d s1=%h n_evict=%0d n_wb=%0d",
                  s0_subj, s1_subj, nevict, nwb);
    if (jmem[0][19:0] != 20'd13 || $signed(jmem[0][119:104]) != 16'sd2 || !jmem[0][120]
        || jmem[2][19:0] != 20'd20 || $signed(jmem[2][119:104]) != 16'sd1)
      div("WB", $sformatf("j0s=%0h j0w=%0d j2s=%0h", jmem[0][19:0], $signed(jmem[0][119:104]), jmem[2][19:0]));
    else $display("CLASS_writeback_completion HIT axi0_A_w0=2 axi2_C_w0=1");
    if ((s0_subj == s1_subj) || (s0_subj == 20'd13 && s0_obj != 20'd14))
      n_false_tb = n_false_tb + 1;
    else $display("CLASS_identity_not_mixed HIT");
    do_lk(20'd13, 20'd4, 20'd14, 20'd0, 1'b0, "A_evicted");
    do_lk(20'hC34FF, 20'd4, 20'd799998, 20'hABCDE, 1'b1, "B_stay");
    do_lk(20'd20, 20'd5, 20'd21, 20'd1, 1'b1, "C");
    pulse_retire;

    ls = 20'h034FF; lr = 20'd4; lo = 20'd799998; lc = 20'hABCDE;
    @(posedge clk);
    if (lk_hit) div("ALIAS", "low16 subject hit full-20 persist");
    else $display("CLASS_alias_attempt HIT lk_hit=0 low16=%h stored=%h", ls, s1_subj);
    do_lk(20'hC34FF, 20'd4, 20'd799998, 20'hABCDE, 1'b1, "B_full20");

    if (low16_bad != 0)
      div("LOW16_ADDR", $sformatf("collisions=%0d last_aw=%h", low16_bad, last_aw));
    else $display("CLASS_journal_addr_not_low16 HIT last_aw=%h", last_aw);

    pulse_clr;
    if (s0_valid || s1_valid) div("BRAM_CLR", "on-chip slots still valid");
    reload = 1'b1; @(posedge clk); reload = 1'b0;
    wait_cyc(2);
    wait_phase(A7NG_C2MS_PH_PERSISTED, 800);
    if (!s0_valid || s0_subj != 20'd13 || s0_w0 != 16'sd2
        || !s1_valid || s1_subj != 20'hC34FF || s1_w0 != 16'sd2)
      div("RELOAD", $sformatf("s0=%0h w0=%0d s1=%h w1=%0d", s0_subj, s0_w0, s1_subj, s1_w0));
    else $display("CLASS_reload_after_clr HIT A_w0=%0d B_w0=%0d C_cache_miss_expected", s0_w0, s1_w0);
    do_lk(20'd20, 20'd5, 20'd21, 20'd1, 1'b0, "C_axi_only");
    pulse_retire;

    if (nfalse != 0 || n_false_tb != 0)
      div("FALSE_SUCCESS", $sformatf("dut=%0d tb=%0d", nfalse, n_false_tb));
    else $display("CLASS_false_success_zero HIT");

    $display("HEADLINE n_upd=%0d n_hit=%0d n_miss=%0d n_evict=%0d n_wb=%0d n_stale=%0d n_schema=%0d n_false=%0d",
             nupd, nhit, nmiss, nevict, nwb, nstale, nsch, nfalse);
    if (fail == 0 && first_div == "") begin
      $display("RESULT=PASS_THIS_GATE_ONLY");
      $display("NOT_CLAIMED=BOARD_PASS,ACCEPT_BOARD,DDR_QUERY_BOUND_FINAL,MIG,C2_MASTER_CLOSED");
      $display("ASTRA_C2_PERSIST_MULTI_SLOT_XSIM_PASS");
    end else begin
      $display("RESULT=FAIL fail=%0d", fail);
      $display("ASTRA_C2_PERSIST_MULTI_SLOT_XSIM_PASS ABSENT");
    end
    $finish;
  end
endmodule
