`timescale 1ps / 100fs
// tb_astra_c2_persist_mig.sv — ASTRA-C2-PERSIST-MIG-01. PROGRAM=NO.
// Official Digilent AXI MIG + ddr3_model. Does not edit mig.prj / KEEP persist RTL.
`include "a7ng_astra_c2_persist_mig.svh"

module tb_astra_c2_persist_mig;
  localparam COL_WIDTH   = 10;
  localparam DM_WIDTH    = 2;
  localparam DQ_WIDTH    = 16;
  localparam DQS_WIDTH   = 2;
  localparam ROW_WIDTH   = 14;
  localparam ADDR_WIDTH  = 28;
  localparam CLKIN_PERIOD = 6000;
  localparam real REFCLK_FREQ = 200.0;
  localparam real REFCLK_PERIOD = (1000000.0/(2*REFCLK_FREQ));
  localparam RESET_PERIOD = 200000;
  localparam RST_ACT_LOW = 1;
  localparam MEMORY_WIDTH = 16;
  localparam NUM_COMP = DQ_WIDTH/MEMORY_WIDTH;
  localparam real TPROP_DQS = 0.00;
  localparam real TPROP_DQS_RD = 0.00;
  localparam real TPROP_PCB_CTRL = 0.00;
  localparam real TPROP_PCB_DATA = 0.00;
  localparam real TPROP_PCB_DATA_RD = 0.00;

  reg sys_rst_n;
  wire sys_rst;
  reg sys_clk_i;
  reg clk_ref_i;
  wire init_calib_complete;
  wire ui_clk, ui_rst, mmcm_locked;
  wire ddr3_reset_n;
  wire [DQ_WIDTH-1:0]  ddr3_dq_fpga;
  wire [DQS_WIDTH-1:0] ddr3_dqs_p_fpga, ddr3_dqs_n_fpga;
  wire [ROW_WIDTH-1:0] ddr3_addr_fpga;
  wire [2:0]           ddr3_ba_fpga;
  wire ddr3_ras_n_fpga, ddr3_cas_n_fpga, ddr3_we_n_fpga;
  wire [0:0] ddr3_cke_fpga, ddr3_ck_p_fpga, ddr3_ck_n_fpga, ddr3_cs_n_fpga, ddr3_odt_fpga;
  wire [DM_WIDTH-1:0] ddr3_dm_fpga;
  wire [DQ_WIDTH-1:0]  ddr3_dq_sdram;
  reg  [ROW_WIDTH-1:0] ddr3_addr_sdram [0:1];
  reg  [2:0]           ddr3_ba_sdram [0:1];
  reg  ddr3_ras_n_sdram, ddr3_cas_n_sdram, ddr3_we_n_sdram;
  wire [0:0] ddr3_cs_n_sdram, ddr3_odt_sdram, ddr3_cke_sdram;
  wire [DM_WIDTH-1:0] ddr3_dm_sdram;
  wire [DQS_WIDTH-1:0] ddr3_dqs_p_sdram, ddr3_dqs_n_sdram;
  reg  [0:0] ddr3_ck_p_sdram, ddr3_ck_n_sdram;
  reg  [0:0] ddr3_cs_n_sdram_tmp, ddr3_odt_sdram_tmp;
  reg  [DM_WIDTH-1:0] ddr3_dm_sdram_tmp;
  reg  [0:0] ddr3_cke_sdram_r;

  logic persist_clr, reload, retire, upd_v, upd_r, lk_go, lk_hit, busy;
  logic [3:0] phase, fail_code;
  logic [19:0] us, ur, uo, uc, ls, lr, lo, lc, ps, pr, po, pc;
  logic [7:0] ug, ut, usch, pgen, ptxn, psch;
  logic signed [3:0] urew;
  logic signed [15:0] live_w0, p_w0;
  logic p_valid;
  logic [15:0] nupd, ndup, nstale, nsch, nfalse;
  logic [3:0] awid, arid, bid, rid;
  logic [27:0] awaddr, araddr, snap_aw;
  logic [7:0] awlen, arlen;
  logic [2:0] awsize, arsize;
  logic [1:0] awburst, arburst, bresp, rresp;
  logic awvalid, awready, wvalid, wready, wlast, bvalid, bready;
  logic arvalid, arready, rvalid, rready, rlast;
  logic [127:0] wdata, rdata;
  logic [15:0] wstrb;
  logic rst_n_ui;
  integer fail, g, n_false_tb;
  string first_div;

  assign sys_rst = RST_ACT_LOW ? sys_rst_n : ~sys_rst_n;
  assign rst_n_ui = ~ui_rst;

  initial begin
    sys_rst_n = 1'b0;
    #RESET_PERIOD sys_rst_n = 1'b1;
  end
  initial sys_clk_i = 1'b0;
  always sys_clk_i = #(CLKIN_PERIOD/2.0) ~sys_clk_i;
  initial clk_ref_i = 1'b0;
  always clk_ref_i = #REFCLK_PERIOD ~clk_ref_i;

  always @(*) begin
    ddr3_ck_p_sdram    <= #(TPROP_PCB_CTRL) ddr3_ck_p_fpga;
    ddr3_ck_n_sdram    <= #(TPROP_PCB_CTRL) ddr3_ck_n_fpga;
    ddr3_addr_sdram[0] <= #(TPROP_PCB_CTRL) ddr3_addr_fpga;
    ddr3_addr_sdram[1] <= #(TPROP_PCB_CTRL) ddr3_addr_fpga;
    ddr3_ba_sdram[0]   <= #(TPROP_PCB_CTRL) ddr3_ba_fpga;
    ddr3_ba_sdram[1]   <= #(TPROP_PCB_CTRL) ddr3_ba_fpga;
    ddr3_ras_n_sdram   <= #(TPROP_PCB_CTRL) ddr3_ras_n_fpga;
    ddr3_cas_n_sdram   <= #(TPROP_PCB_CTRL) ddr3_cas_n_fpga;
    ddr3_we_n_sdram    <= #(TPROP_PCB_CTRL) ddr3_we_n_fpga;
    ddr3_cke_sdram_r   <= #(TPROP_PCB_CTRL) ddr3_cke_fpga;
  end
  assign ddr3_cke_sdram = ddr3_cke_sdram_r;
  always @(*) ddr3_cs_n_sdram_tmp <= #(TPROP_PCB_CTRL) ddr3_cs_n_fpga;
  assign ddr3_cs_n_sdram = ddr3_cs_n_sdram_tmp;
  always @(*) ddr3_dm_sdram_tmp <= #(TPROP_PCB_DATA) ddr3_dm_fpga;
  assign ddr3_dm_sdram = ddr3_dm_sdram_tmp;
  always @(*) ddr3_odt_sdram_tmp <= #(TPROP_PCB_CTRL) ddr3_odt_fpga;
  assign ddr3_odt_sdram = ddr3_odt_sdram_tmp;

  genvar dqwd;
  generate
    for (dqwd = 0; dqwd < DQ_WIDTH; dqwd = dqwd+1) begin : dq_delay
      WireDelay #(.Delay_g(TPROP_PCB_DATA), .Delay_rd(TPROP_PCB_DATA_RD), .ERR_INSERT("OFF"))
        u_delay_dq (.A(ddr3_dq_fpga[dqwd]), .B(ddr3_dq_sdram[dqwd]),
                    .reset(sys_rst_n), .phy_init_done(init_calib_complete));
    end
  endgenerate
  genvar dqswd;
  generate
    for (dqswd = 0; dqswd < DQS_WIDTH; dqswd = dqswd+1) begin : dqs_delay
      WireDelay #(.Delay_g(TPROP_DQS), .Delay_rd(TPROP_DQS_RD), .ERR_INSERT("OFF"))
        u_dqs_p (.A(ddr3_dqs_p_fpga[dqswd]), .B(ddr3_dqs_p_sdram[dqswd]),
                 .reset(sys_rst_n), .phy_init_done(init_calib_complete));
      WireDelay #(.Delay_g(TPROP_DQS), .Delay_rd(TPROP_DQS_RD), .ERR_INSERT("OFF"))
        u_dqs_n (.A(ddr3_dqs_n_fpga[dqswd]), .B(ddr3_dqs_n_sdram[dqswd]),
                 .reset(sys_rst_n), .phy_init_done(init_calib_complete));
    end
  endgenerate

  always_ff @(posedge ui_clk) begin
    if (awvalid && awready) snap_aw <= awaddr;
  end

  mig_native_wrap u_mig (
    .sys_clk_i(sys_clk_i), .clk_ref_i(clk_ref_i), .sys_rst_n(sys_rst),
    .ui_clk(ui_clk), .ui_rst(ui_rst), .init_calib_complete(init_calib_complete),
    .mmcm_locked(mmcm_locked),
    .ddr3_addr(ddr3_addr_fpga), .ddr3_ba(ddr3_ba_fpga),
    .ddr3_cas_n(ddr3_cas_n_fpga), .ddr3_ck_n(ddr3_ck_n_fpga), .ddr3_ck_p(ddr3_ck_p_fpga),
    .ddr3_cke(ddr3_cke_fpga), .ddr3_cs_n(ddr3_cs_n_fpga),
    .ddr3_ras_n(ddr3_ras_n_fpga), .ddr3_reset_n(ddr3_reset_n), .ddr3_we_n(ddr3_we_n_fpga),
    .ddr3_dq(ddr3_dq_fpga), .ddr3_dqs_n(ddr3_dqs_n_fpga), .ddr3_dqs_p(ddr3_dqs_p_fpga),
    .ddr3_dm(ddr3_dm_fpga), .ddr3_odt(ddr3_odt_fpga),
    .s_axi_awid(awid), .s_axi_awaddr(awaddr), .s_axi_awlen(awlen),
    .s_axi_awsize(awsize), .s_axi_awburst(awburst),
    .s_axi_awvalid(awvalid), .s_axi_awready(awready),
    .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wlast(wlast),
    .s_axi_wvalid(wvalid), .s_axi_wready(wready),
    .s_axi_bid(bid), .s_axi_bresp(bresp), .s_axi_bvalid(bvalid), .s_axi_bready(bready),
    .s_axi_arid(arid), .s_axi_araddr(araddr), .s_axi_arlen(arlen),
    .s_axi_arsize(arsize), .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid), .s_axi_arready(arready),
    .s_axi_rid(rid), .s_axi_rdata(rdata), .s_axi_rresp(rresp),
    .s_axi_rlast(rlast), .s_axi_rvalid(rvalid), .s_axi_rready(rready)
  );

  genvar i;
  generate
    for (i = 0; i < NUM_COMP; i = i + 1) begin : gen_mem
      ddr3_model u_comp_ddr3 (
        .rst_n   (ddr3_reset_n),
        .ck      (ddr3_ck_p_sdram),
        .ck_n    (ddr3_ck_n_sdram),
        .cke     (ddr3_cke_sdram[0]),
        .cs_n    (ddr3_cs_n_sdram[0]),
        .ras_n   (ddr3_ras_n_sdram),
        .cas_n   (ddr3_cas_n_sdram),
        .we_n    (ddr3_we_n_sdram),
        .dm_tdqs (ddr3_dm_sdram[(2*(i+1)-1):(2*i)]),
        .ba      (ddr3_ba_sdram[0]),
        .addr    (ddr3_addr_sdram[0]),
        .dq      (ddr3_dq_sdram[16*(i+1)-1:16*(i)]),
        .dqs     (ddr3_dqs_p_sdram[(2*(i+1)-1):(2*i)]),
        .dqs_n   (ddr3_dqs_n_sdram[(2*(i+1)-1):(2*i)]),
        .tdqs_n  (),
        .odt     (ddr3_odt_sdram[0])
      );
    end
  endgenerate

  a7ng_astra_c2_persist_mig u_dut (
    .clk(ui_clk), .rst_n(rst_n_ui), .init_calib_complete_i(init_calib_complete),
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
    .persist_gen_o(pgen), .persist_txn_o(ptxn), .persist_schema_o(psch),
    .persist_w0_o(p_w0),
    .n_upd_o(nupd), .n_dup_o(ndup), .n_stale_o(nstale),
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
      for (k = 0; k < n; k = k + 1) @(posedge ui_clk);
    end
  endtask

  task automatic wait_phase(input logic [3:0] want, input int lim);
    begin
      g = 0;
      if (phase != want) begin
        while ((phase != want) && (g < lim)) begin
          @(posedge ui_clk);
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
      while (!upd_r && g < 400000) begin @(posedge ui_clk); g = g + 1; end
      if (!upd_r) div("NO_READY", "upd_ready");
      @(negedge ui_clk);
      upd_v = 1'b1;
      @(posedge ui_clk);
      @(negedge ui_clk);
      upd_v = 1'b0;
    end
  endtask

  task automatic pulse_retire;
    begin
      @(negedge ui_clk); retire = 1'b1;
      @(posedge ui_clk);
      @(negedge ui_clk); retire = 1'b0;
      wait_cyc(2);
    end
  endtask

  task automatic pulse_clr;
    begin
      @(negedge ui_clk); persist_clr = 1'b1;
      @(posedge ui_clk);
      @(negedge ui_clk); persist_clr = 1'b0;
      wait_cyc(2);
    end
  endtask

  initial begin
    fail = 0; n_false_tb = 0; first_div = "";
    persist_clr = 1'b0; reload = 1'b0; retire = 1'b0;
    upd_v = 1'b0; lk_go = 1'b0;
    us = '0; ur = '0; uo = '0; uc = '0; ug = '0; ut = '0; usch = '0; urew = '0;
    ls = '0; lr = '0; lo = '0; lc = '0;
    $display("C2_PERSIST_MIG PROGRAM=NO BOARD_PASS=NOT_CLAIMED DDR_QUERY_BOUND_FINAL=NOT_FROZEN MIG_XSIM=1");
    wait (init_calib_complete === 1'b1);
    $display("CLASS_mig_calib_complete HIT t=%0t", $time);
    wait_cyc(50);
    pulse_clr;

    us = 20'hC34FF; ur = 20'd4; uo = 20'd799998; uc = 20'hABCDE;
    ug = 8'd3; ut = 8'd7; usch = 8'd99; urew = 4'sd2;
    pulse_upd;
    wait_phase(A7NG_C2_PH_FAILED, 2000);
    if (fail_code != A7NG_C2_F_SCHEMA || p_valid)
      div("SCHEMA", $sformatf("code=%0d pvalid=%0d", fail_code, p_valid));
    else $display("CLASS_schema_mismatch HIT fail_code=%0d", fail_code);
    pulse_retire;

    usch = A7NG_C2_SCHEMA_VER;
    pulse_upd;
    wait_phase(A7NG_C2_PH_PERSISTED, 400000);
    if (!p_valid || ps != 20'hC34FF || po != 20'd799998 || pc != 20'hABCDE
        || pgen != 8'd3 || p_w0 != 16'sd2 || live_w0 != 16'sd2)
      div("MIG_PERSIST", $sformatf("ps=%h po=%0d w0=%0d", ps, po, p_w0));
    else $display("CLASS_persist_through_mig HIT subj=%h obj=%0d ctx=%h w0=%0d aw=%h",
                  ps, po, pc, p_w0, snap_aw);
    if (snap_aw != A7NG_C2_PERSIST_BASE || snap_aw[15:0] == 16'h34FF)
      div("LOW16_ADDR", $sformatf("aw=%h", snap_aw));
    else $display("CLASS_journal_addr_not_low16 HIT awaddr=%h", snap_aw);
    pulse_retire;

    ls = 20'h034FF; lr = 20'd4; lo = 20'd799998; lc = 20'hABCDE;
    @(posedge ui_clk);
    if (lk_hit) div("ALIAS", "low16 subject hit full-20 persist");
    else $display("CLASS_alias_attempt HIT lk_hit=0 low16=%h stored=%h", ls, ps);
    ls = 20'hC34FF;
    @(posedge ui_clk);
    if (!lk_hit) div("ALIAS_POS", "full-20 lookup miss");

    pulse_clr;
    if (p_valid) div("BRAM_CLR", "on-chip journal still valid");
    else $display("CLASS_bram_clear HIT");
    reload = 1'b1; @(posedge ui_clk); reload = 1'b0;
    wait_cyc(2);
    wait_phase(A7NG_C2_PH_PERSISTED, 400000);
    if (!p_valid || ps != 20'hC34FF || po != 20'd799998 || pc != 20'hABCDE
        || live_w0 != 16'sd2 || p_w0 != 16'sd2)
      div("RELOAD_MIG", $sformatf("ps=%h w0=%0d live=%0d", ps, p_w0, live_w0));
    else $display("CLASS_reload_from_mig HIT identity_exact w0=%0d", live_w0);
    pulse_retire;

    if (nfalse != 0 || n_false_tb != 0)
      div("FALSE_SUCCESS", $sformatf("dut=%0d tb=%0d", nfalse, n_false_tb));
    else $display("CLASS_false_success_zero HIT");

    $display("HEADLINE n_upd=%0d n_schema=%0d n_false=%0d calib=1", nupd, nsch, nfalse);
    if (fail == 0 && first_div == "") begin
      $display("RESULT=PASS_THIS_GATE_ONLY");
      $display("NOT_CLAIMED=BOARD_PASS,ACCEPT_BOARD,DDR_QUERY_BOUND_FINAL,C2_MASTER_CLOSED");
      $display("ASTRA_C2_PERSIST_MIG_XSIM_PASS");
    end else begin
      $display("RESULT=FAIL fail=%0d", fail);
      $display("ASTRA_C2_PERSIST_MIG_XSIM_PASS ABSENT");
    end
    $finish;
  end

  initial begin
    #200ms;
    $display("FIRST_DIVERGENCE MIG_TIMEOUT calib_or_persist hung");
    $display("RESULT=FAIL");
    $display("ASTRA_C2_PERSIST_MIG_XSIM_PASS ABSENT");
    $finish;
  end
endmodule
