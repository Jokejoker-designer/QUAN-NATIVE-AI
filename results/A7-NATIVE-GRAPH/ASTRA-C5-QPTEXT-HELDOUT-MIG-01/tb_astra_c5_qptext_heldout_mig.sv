`timescale 1ps / 100fs
// ASTRA-C5-QPTEXT-HELDOUT-MIG-01. PROGRAM=NO. Bag-local TB (test-only plant).
// Existing a7ng_astra_c5_prod_top_c4q through official Digilent AXI MIG + ddr3_model.
// Held-out PRE vs POST dest change. Not BOARD. Not Master.
`include "a7ng_astra_c5_prod_top.svh"
`include "a7ng_astra_c5_ddr_arb.svh"
`include "a7ng_astra_c4_lm06_byte256_qptext.svh"
`include "tb_oracles.svh"

module tb_astra_c5_qptext_heldout_mig;
  localparam COL_WIDTH   = 10;
  localparam DM_WIDTH    = 2;
  localparam DQ_WIDTH    = 16;
  localparam DQS_WIDTH   = 2;
  localparam ROW_WIDTH   = 14;
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
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000;
  localparam logic [27:0] POST_HEAP  = 28'h0504_0000;
  localparam logic [27:0] FACT_BASE  = 28'h0580_0000;
  localparam logic [27:0] POST_TR    = POST_HEAP;
  localparam logic [27:0] POST_HO    = POST_HEAP + 28'd16;
  localparam int CPB = (A7NG_C5P_CLK_HZ + A7NG_C5P_BAUD/2) / A7NG_C5P_BAUD;
  localparam int unsigned BOOT_GUARD = 400000;
  localparam int unsigned Q_GUARD    = 4000000;
  localparam int K0_TR = 16'h0A22;
  localparam int K0_HO = 16'h0623;
  localparam int PRE_DST = 144;
  localparam int POST_DST = 112;

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

  logic plant, dut_rst_n;
  logic [3:0]  p_awid, p_bid;
  logic [27:0] p_awaddr;
  logic [7:0]  p_awlen;
  logic [2:0]  p_awsize;
  logic [1:0]  p_awburst, p_bresp;
  logic        p_awvalid, p_awready, p_wvalid, p_wready, p_wlast, p_bvalid, p_bready;
  logic [127:0] p_wdata;
  logic [15:0] p_wstrb;

  logic [3:0]  m_arid, m_rid, m_awid, m_bid;
  logic [27:0] c5_araddr, c5_awaddr, m_araddr, m_awaddr;
  logic [7:0]  m_arlen, m_awlen;
  logic [2:0]  m_arsize, m_awsize;
  logic [1:0]  m_arburst, m_awburst, m_rresp, m_bresp;
  logic        c5_arvalid, c5_arready, c5_rvalid, c5_rready;
  logic        c5_awvalid, c5_awready, c5_wvalid, c5_wready, c5_wlast, c5_bvalid, c5_bready;
  logic        m_arvalid, m_arready, m_rvalid, m_rready, m_rlast;
  logic        m_awvalid, m_awready, m_wvalid, m_wready, m_wlast, m_bvalid, m_bready;
  logic [127:0] c5_rdata, c5_wdata, m_rdata, m_wdata;
  logic [15:0] c5_wstrb, m_wstrb;

  logic urx, utx, busy, done, dual, qid, a09, plant_dut, c3res, pcmt, pvalid, gdone, phit, ehas;
  logic [5:0] seen;
  logic [2:0] owner;
  logic [15:0] nsw, nblk, nhw, nht, imask, nurx, nutx;
  logic [3:0] c3st, pph;
  logic [7:0] c3obj, glast, gtok0, gtok1;
  logic [19:0] c3ans, c3p0, c3p1;
  logic signed [15:0] pw0;
  logic [27:0] last_aw;
  int fail, i, guard;
  string first_div;
  logic [3:0] cap_st;
  logic [19:0] cap_ans, cap_p0, cap_p1;
  logic cap_v;
  logic [19:0] pre_ans, post_ans;
  logic signed [15:0] w0_pre;

  assign sys_rst = RST_ACT_LOW ? sys_rst_n : ~sys_rst_n;

  assign p_awready = plant ? m_awready : 1'b0;
  assign p_wready  = plant ? m_wready  : 1'b0;
  assign p_bvalid  = plant ? m_bvalid  : 1'b0;
  assign p_bid     = m_bid;
  assign p_bresp   = m_bresp;

  assign m_awid    = plant ? p_awid    : 4'd0;
  assign m_awaddr  = plant ? p_awaddr  : c5_awaddr;
  assign m_awlen   = plant ? p_awlen   : 8'd0;
  assign m_awsize  = plant ? p_awsize  : 3'd4;
  assign m_awburst = plant ? p_awburst : 2'b01;
  assign m_awvalid = plant ? p_awvalid : c5_awvalid;
  assign m_wdata   = plant ? p_wdata   : c5_wdata;
  assign m_wstrb   = plant ? p_wstrb   : c5_wstrb;
  assign m_wlast   = plant ? p_wlast   : c5_wlast;
  assign m_wvalid  = plant ? p_wvalid  : c5_wvalid;
  assign m_bready  = plant ? p_bready  : c5_bready;
  assign c5_awready = plant ? 1'b0 : m_awready;
  assign c5_wready  = plant ? 1'b0 : m_wready;
  assign c5_bvalid  = plant ? 1'b0 : m_bvalid;

  assign m_arid    = 4'd0;
  assign m_araddr  = plant ? 28'd0 : c5_araddr;
  assign m_arlen   = 8'd0;
  assign m_arsize  = 3'd4;
  assign m_arburst = 2'b01;
  assign m_arvalid = plant ? 1'b0 : c5_arvalid;
  assign c5_arready = plant ? 1'b0 : m_arready;
  assign c5_rdata  = m_rdata;
  assign c5_rvalid = plant ? 1'b0 : m_rvalid;
  assign m_rready  = plant ? 1'b1 : c5_rready;

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
    .s_axi_awid(m_awid), .s_axi_awaddr(m_awaddr), .s_axi_awlen(m_awlen),
    .s_axi_awsize(m_awsize), .s_axi_awburst(m_awburst),
    .s_axi_awvalid(m_awvalid), .s_axi_awready(m_awready),
    .s_axi_wdata(m_wdata), .s_axi_wstrb(m_wstrb), .s_axi_wlast(m_wlast),
    .s_axi_wvalid(m_wvalid), .s_axi_wready(m_wready),
    .s_axi_bid(m_bid), .s_axi_bresp(m_bresp), .s_axi_bvalid(m_bvalid), .s_axi_bready(m_bready),
    .s_axi_arid(m_arid), .s_axi_araddr(m_araddr), .s_axi_arlen(m_arlen),
    .s_axi_arsize(m_arsize), .s_axi_arburst(m_arburst),
    .s_axi_arvalid(m_arvalid), .s_axi_arready(m_arready),
    .s_axi_rid(m_rid), .s_axi_rdata(m_rdata), .s_axi_rresp(m_rresp),
    .s_axi_rlast(m_rlast), .s_axi_rvalid(m_rvalid), .s_axi_rready(m_rready)
  );

  genvar gi;
  generate
    for (gi = 0; gi < NUM_COMP; gi = gi + 1) begin : gen_mem
      ddr3_model u_comp_ddr3 (
        .rst_n   (ddr3_reset_n),
        .ck      (ddr3_ck_p_sdram),
        .ck_n    (ddr3_ck_n_sdram),
        .cke     (ddr3_cke_sdram[0]),
        .cs_n    (ddr3_cs_n_sdram[0]),
        .ras_n   (ddr3_ras_n_sdram),
        .cas_n   (ddr3_cas_n_sdram),
        .we_n    (ddr3_we_n_sdram),
        .dm_tdqs (ddr3_dm_sdram[(2*(gi+1)-1):(2*gi)]),
        .ba      (ddr3_ba_sdram[0]),
        .addr    (ddr3_addr_sdram[0]),
        .dq      (ddr3_dq_sdram[16*(gi+1)-1:16*(gi)]),
        .dqs     (ddr3_dqs_p_sdram[(2*(gi+1)-1):(2*gi)]),
        .dqs_n   (ddr3_dqs_n_sdram[(2*(gi+1)-1):(2*gi)]),
        .tdqs_n  (),
        .odt     (ddr3_odt_sdram[0])
      );
    end
  endgenerate

  a7ng_astra_c5_prod_top_c4q u_dut (
    .clk(ui_clk), .rst_n(dut_rst_n), .live_epoch_i(16'd7),
    .uart_rx_i(urx), .uart_tx_o(utx),
    .m_arvalid_o(c5_arvalid), .m_araddr_o(c5_araddr), .m_arready_i(c5_arready),
    .m_rvalid_i(c5_rvalid), .m_rdata_i(c5_rdata), .m_rready_o(c5_rready),
    .m_awvalid_o(c5_awvalid), .m_awaddr_o(c5_awaddr), .m_awready_i(c5_awready),
    .m_wvalid_o(c5_wvalid), .m_wdata_o(c5_wdata), .m_wlast_o(c5_wlast), .m_wstrb_o(c5_wstrb), .m_wready_i(c5_wready),
    .m_bvalid_i(c5_bvalid), .m_bready_o(c5_bready),
    .busy_o(busy), .done_o(done),
    .seen_gnt_o(seen), .owner_o(owner), .dual_err_o(dual),
    .n_switch_o(nsw), .n_block_o(nblk),
    .n_host_winner_o(nhw), .n_host_tok_o(nht),
    .qid_map_o(qid), .a09_o(a09), .plant_dut_o(plant_dut), .inst_mask_o(imask),
    .n_uart_rx_o(nurx), .n_uart_tx_o(nutx),
    .c3_status_o(c3st), .c3_obj_o(c3obj),
    .c3_ans_o(c3ans), .c3_p0_o(c3p0), .c3_p1_o(c3p1),
    .c3_result_v_o(c3res), .c3_pend_cmt_o(pcmt),
    .persist_valid_o(pvalid), .persist_w0_o(pw0), .persist_phase_o(pph),
    .gen_done_o(gdone), .gen_last_o(glast), .gen_tok0_o(gtok0), .gen_tok1_o(gtok1),
    .parser_hit_o(phit), .evid_has_o(ehas),
    .last_aw_o(last_aw)
  );
  defparam u_dut.u_c3.TO_CYC = 65535;

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div == "") first_div = tag;
        $display("FAIL %s", tag); fail = fail + 1;
      end else $display("PASS %s", tag);
    end
  endtask
  task automatic wait_ui(input int n);
    integer k;
    begin
      for (k = 0; k < n; k = k + 1) @(posedge ui_clk);
    end
  endtask
  task automatic axi_wr(input logic [27:0] a, input logic [127:0] d);
    begin
      plant = 1'b1;
      p_awid = 4'd0; p_awaddr = a; p_awlen = 8'd0; p_awsize = 3'd4; p_awburst = 2'b01;
      p_wdata = d; p_wstrb = 16'hFFFF; p_wlast = 1'b1; p_bready = 1'b1;
      p_awvalid = 1'b1; p_wvalid = 1'b1;
      while (p_awvalid || p_wvalid) begin
        @(posedge ui_clk);
        if (p_awvalid && m_awready) p_awvalid = 1'b0;
        if (p_wvalid && m_wready) begin p_wvalid = 1'b0; p_wlast = 1'b0; end
      end
      while (!m_bvalid) @(posedge ui_clk);
      @(posedge ui_clk);
    end
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
  task automatic uart_byte(input logic [7:0] d);
    integer b;
    begin
      urx = 1'b0; repeat (CPB) @(posedge ui_clk);
      for (b = 0; b < 8; b = b + 1) begin
        urx = d[b]; repeat (CPB) @(posedge ui_clk);
      end
      urx = 1'b1; repeat (CPB + 2) @(posedge ui_clk);
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
      while (!done && guard < Q_GUARD) begin
        @(posedge ui_clk);
        guard = guard + 1;
        if (c3res && !cap_v) begin
          cap_st = c3st; cap_ans = c3ans; cap_p0 = c3p0; cap_p1 = c3p1; cap_v = 1'b1;
        end
      end
      chk(tag, done && guard < Q_GUARD);
    end
  endtask
  task automatic wr_f(input int e, s, o, r, conf, trans, pol, fctx);
    axi_wr(fact_addr(e), fact_pack(s, o, r, e, conf, trans, pol, fctx));
  endtask
  task automatic plant_all;
    logic [127:0] btr, bho;
    begin
      btr = 128'd0;
      btr[31:0] = 32'd16; btr[63:32] = 32'd17; btr[95:64] = 32'd20; btr[127:96] = 32'd21;
      bho = 128'd0;
      bho[31:0] = 32'd256; bho[63:32] = 32'd257; bho[95:64] = 32'd258; bho[127:96] = 32'd259;
      axi_wr(dir_addr(0, K0_TR), dir_pack(4, POST_TR));
      axi_wr(POST_TR, btr);
      axi_wr(dir_addr(0, K0_HO), dir_pack(4, POST_HO));
      axi_wr(POST_HO, bho);
      wr_f(16, 10, 48, 2, 40, 1, 1, 0);
      wr_f(17, 48, 96, 2, 40, 1, 1, 0);
      wr_f(20, 10, 49, 2, 200, 1, 1, 0);
      wr_f(21, 49, 64, 2, 200, 1, 1, 0);
      wr_f(256, 6, 50, 3, 40, 1, 1, 0);
      wr_f(257, 50, PRE_DST, 3, 40, 1, 1, 0);
      wr_f(258, 6, 51, 3, 220, 1, 1, 0);
      wr_f(259, 51, POST_DST, 3, 220, 1, 1, 0);
      axi_wr(A7NG_C5_CKPT_BASE, 128'd0);
      plant = 1'b0;
      p_awvalid = 1'b0; p_wvalid = 1'b0; p_wlast = 1'b0;
      wait_ui(8);
    end
  endtask

  initial begin
    fail = 0; first_div = "";
    pre_ans = 20'd0; post_ans = 20'd0; w0_pre = 16'sd0;
    urx = 1'b1; dut_rst_n = 1'b0; plant = 1'b1;
    p_awvalid = 1'b0; p_wvalid = 1'b0; p_wlast = 1'b0; p_bready = 1'b1;
    p_awid = 4'd0; p_awaddr = 28'd0; p_awlen = 8'd0; p_awsize = 3'd4; p_awburst = 2'b01;
    p_wdata = 128'd0; p_wstrb = 16'hFFFF;
    $display("C5_QPTEXT_HELDOUT_MIG PROGRAM=NO BOARD_PASS=REJECT train_subj=10 hold_subj=6 MIG=YES TO_CYC_TB_DEFPARAM=65535 DUT=c4q");
    $display("CLASS_not_compose_renderer HIT dut=a7ng_astra_c5_prod_top_c4q");
    $display("CLASS_not_live_prod_top_dut HIT live_prod_top_unedited");
    wait (init_calib_complete === 1'b1);
    $display("CLASS_mig_calib_complete HIT t=%0t", $time);
    wait_ui(50);
    plant_all();
    dut_rst_n = 1'b1;
    wait_ui(16);
    $display("CLASS_entities_disjoint HIT train={10} hold={6}");
    guard = 0;
    while ((seen[0] !== 1'b1 || seen[3] !== 1'b1 || seen[4] !== 1'b1) && guard < BOOT_GUARD) begin
      @(posedge ui_clk); guard = guard + 1;
    end
    chk("BOOT_IDX_LRN_LMD", seen[0] && seen[3] && seen[4] && guard < BOOT_GUARD);
    wait_ui(20);

    uart_ctl(A7NG_C5P_CMD_FREEZE);
    wait_ui(20);
    uart_str("ahu connects indirect");
    wait_done("PRE_DONE");
    pre_ans = cap_ans; w0_pre = pw0;
    $display("MEAS PRE st=%0d ans=%0d p0=%0d p1=%0d w0=%0d", cap_st, cap_ans, cap_p0, cap_p1, pw0);
    if ((cap_st == A7NG_C5P_ST_ANSWER) && (cap_ans == PRE_DST[19:0]) && (cap_p0 == 20'd256))
      $display("CLASS_heldout_pre HIT ans=%0d p0=%0d", cap_ans, cap_p0);
    else $display("CLASS_heldout_pre MISS st=%0d ans=%0d p0=%0d", cap_st, cap_ans, cap_p0);
    chk("PRE_DISTRACTOR", (cap_st == A7NG_C5P_ST_ANSWER) && (cap_ans == PRE_DST[19:0]) && (cap_p0 == 20'd256));

    uart_ctl(A7NG_C5P_CMD_LEARN);
    wait_ui(20);
    uart_str("pump requires indirect");
    wait_done("TRAIN_DONE");
    $display("MEAS TRAIN st=%0d ans=%0d p0=%0d p1=%0d w0=%0d pvalid=%0d", cap_st, cap_ans, cap_p0, cap_p1, pw0, pvalid);
    if (pvalid && (pw0 !== w0_pre))
      $display("CLASS_reward_update HIT w0=%0d pre=%0d", pw0, w0_pre);
    else $display("CLASS_reward_update MISS w0=%0d pre=%0d pvalid=%0d", pw0, w0_pre, pvalid);
    chk("TRAIN_ANSWER", cap_st == A7NG_C5P_ST_ANSWER);
    chk("REWARD_W0", pvalid && (pw0 !== w0_pre));
    begin
      logic [7:0] gold0, glue;
      gold0 = a7ng_c4q_ch(C3_SHARED_DST[7:0], 0);
      glue = A7NG_C4Q_GLUE_DEF;
      if (gdone && (gtok0 === glue) && (gtok1 === gold0))
        $display("CLASS_gen_tok0_glue_from_weights HIT tok0=%0d tok1=%0d", gtok0, gtok1);
      else $display("CLASS_gen_tok0_glue_from_weights MISS tok0=%0d tok1=%0d", gtok0, gtok1);
    end

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
    if (!plant_dut) $display("CLASS_no_plant_in_dut HIT");
    else $display("CLASS_no_plant_in_dut MISS");
    chk("DUAL0", !dual);
    chk("NOQID", !qid);
    chk("NOHOST", nhw == 16'd0);
    chk("NOA09", !a09);
    chk("NOPLANT", !plant_dut);

    if (fail == 0) $display("ASTRA_C5_QPTEXT_HELDOUT_MIG_XSIM_PASS");
    else $display("ASTRA_C5_QPTEXT_HELDOUT_MIG_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO quality=MIG_PHY_C4Q_HELDOUT_PRE_POST UART_SIM_BAUD GLUE_PLUS_OBJECT");
    $finish;
  end

  initial begin
    #20s;
    $display("FIRST_DIVERGENCE MIG_TIMEOUT calib_or_qptext_heldout hung");
    $display("RESULT=FAIL");
    $display("ASTRA_C5_QPTEXT_HELDOUT_MIG_XSIM_PASS ABSENT");
    $finish;
  end
endmodule
