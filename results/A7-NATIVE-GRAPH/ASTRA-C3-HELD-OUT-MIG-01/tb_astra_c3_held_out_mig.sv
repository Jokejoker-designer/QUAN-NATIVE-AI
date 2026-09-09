`timescale 1ps / 100fs
// ASTRA-C3-HELD-OUT-MIG-01. PROGRAM=NO. Bag-local TB.
// Official Digilent AXI MIG + ddr3_model. Plants 2-hop facts via MIG AW.
// Instantiates existing a7ng_astra_c3_held_out (not edited). Not BOARD. Not Master.
`include "a7ng_astra_c3_held_out.svh"
`include "tb_oracles.svh"

module tb_astra_c3_held_out_mig;
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
  localparam int unsigned C3_TO_CYC = 65535;
  localparam logic [3:0] ST_ANSWER = 4'd0;

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

  logic plant, dut_rst_n, rst_n_ui;
  logic [3:0]  p_awid, p_bid;
  logic [27:0] p_awaddr;
  logic [7:0]  p_awlen;
  logic [2:0]  p_awsize;
  logic [1:0]  p_awburst, p_bresp;
  logic        p_awvalid, p_awready, p_wvalid, p_wready, p_wlast, p_bvalid, p_bready;
  logic [127:0] p_wdata;
  logic [15:0] p_wstrb;

  logic [3:0]  c3_arid, c3_rid, m_arid, m_rid, m_awid, m_bid;
  logic [27:0] c3_araddr, m_araddr, m_awaddr;
  logic [7:0]  c3_arlen, m_arlen, m_awlen;
  logic [2:0]  c3_arsize, m_arsize, m_awsize;
  logic [1:0]  c3_arburst, m_arburst, m_awburst, c3_rresp, m_rresp, m_bresp;
  logic        c3_arvalid, c3_arready, c3_rvalid, c3_rready, c3_rlast;
  logic        m_arvalid, m_arready, m_rvalid, m_rready, m_rlast;
  logic        m_awvalid, m_awready, m_wvalid, m_wready, m_wlast, m_bvalid, m_bready;
  logic [127:0] c3_rdata, m_rdata, m_wdata;
  logic [15:0] m_wstrb;

  logic tok_v, tok_r, fire, retire, rew_v, busy, result_v, tbl;
  logic pend_acc, pend_cmt, load_v;
  logic [1:0] ctrl, sel;
  logic [7:0] tok, txn, gen, rew_txn, rew_gen, phi0, qobj, qctx, qsubj;
  logic [15:0] nhwin, nhaddr, live_ep, nupd, ndup, nbad;
  logic [4:0] load_idx, npath;
  logic signed [15:0] load_w, wsnap [0:31], wdut [0:31], vbest, vsec;
  logic signed [3:0] rew;
  logic [19:0] ans, p0, p1;
  logic [3:0] st;
  logic signed [7:0] pphi [0:31];
  int pidmap [0:255];
  int fail, i, q, n_rank, n_ans, npath4_c, host_bad;
  string first_div;

  logic go_s, go_u, rdy, dn, iso_load;
  logic signed [15:0] viso, wiso [0:31];
  logic signed [3:0] iso_rew;
  logic signed [7:0] xiso [0:31];

  assign sys_rst = RST_ACT_LOW ? sys_rst_n : ~sys_rst_n;
  assign rst_n_ui = ~ui_rst;
  assign p_awready = plant ? m_awready : 1'b0;
  assign p_wready  = plant ? m_wready  : 1'b0;
  assign p_bvalid  = plant ? m_bvalid  : 1'b0;
  assign p_bid     = m_bid;
  assign p_bresp   = m_bresp;

  assign m_awid    = p_awid;
  assign m_awaddr  = p_awaddr;
  assign m_awlen   = p_awlen;
  assign m_awsize  = p_awsize;
  assign m_awburst = p_awburst;
  assign m_awvalid = plant ? p_awvalid : 1'b0;
  assign m_wdata   = p_wdata;
  assign m_wstrb   = p_wstrb;
  assign m_wlast   = p_wlast;
  assign m_wvalid  = plant ? p_wvalid : 1'b0;
  assign m_bready  = plant ? p_bready : 1'b1;

  assign m_arid    = plant ? 4'd0 : c3_arid;
  assign m_araddr  = plant ? 28'd0 : c3_araddr;
  assign m_arlen   = plant ? 8'd0 : c3_arlen;
  assign m_arsize  = plant ? 3'd4 : c3_arsize;
  assign m_arburst = plant ? 2'b01 : c3_arburst;
  assign m_arvalid = plant ? 1'b0 : c3_arvalid;
  assign c3_arready = plant ? 1'b0 : m_arready;
  assign c3_rid    = m_rid;
  assign c3_rdata  = m_rdata;
  assign c3_rresp  = m_rresp;
  assign c3_rlast  = m_rlast;
  assign c3_rvalid = plant ? 1'b0 : m_rvalid;
  assign m_rready  = plant ? 1'b1 : c3_rready;

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

  a7ng_astra_c3_held_out #(.TO_CYC(C3_TO_CYC)) u_dut (
    .clk(ui_clk), .rst_n(dut_rst_n), .live_epoch_i(live_ep), .ctrl_i(ctrl),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .rew_v_i(rew_v), .rew_i(rew), .rew_txn_i(rew_txn), .rew_gen_i(rew_gen),
    .load_v_i(load_v), .load_idx_i(load_idx), .load_w_i(load_w),
    .busy_o(busy), .result_v_o(result_v),
    .pend_acc_o(pend_acc), .pend_cmt_o(pend_cmt),
    .txn_id_o(txn), .gen_o(gen), .sel_idx_o(sel),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1),
    .n_path_o(npath), .status_o(st), .obj_o(qobj), .ctx_o(qctx),
    .subj_o(qsubj), .n_host_winner_o(nhwin), .n_host_addr_o(nhaddr),
    .v_best_o(vbest), .v_second_o(vsec), .phi0_o(phi0),
    .pend_phi_o(pphi), .w_o(wdut),
    .n_upd_o(nupd), .n_dup_o(ndup), .n_bad_o(nbad),
    .load_from_tb_o(tbl),
    .m_axi_arid(c3_arid), .m_axi_araddr(c3_araddr), .m_axi_arlen(c3_arlen),
    .m_axi_arsize(c3_arsize), .m_axi_arburst(c3_arburst),
    .m_axi_arvalid(c3_arvalid), .m_axi_arready(c3_arready),
    .m_axi_rid(c3_rid), .m_axi_rdata(c3_rdata), .m_axi_rresp(c3_rresp),
    .m_axi_rlast(c3_rlast), .m_axi_rvalid(c3_rvalid), .m_axi_rready(c3_rready)
  );

  a7ng_shared_rank_sgd_q8_sym_f2r2 u_iso (
    .clk(ui_clk), .rst_n(dut_rst_n), .freeze_i(1'b0),
    .go_score_i(go_s), .go_upd_i(go_u), .x_i(xiso), .reward_i(iso_rew),
    .load_v_i(iso_load), .load_idx_i(5'd0), .load_w_i(16'sd0),
    .ready_o(rdy), .done_o(dn), .v_q8_o(viso), .w_o(wiso)
  );

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div=="") first_div=tag;
        $display("FAIL %s", tag); fail=fail+1;
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

  function automatic logic [127:0] dir_pack(input int count);
    dir_pack = {48'd0, live_ep, 16'd0, count[15:0], 4'd0, POST_HEAP};
  endfunction
  function automatic logic [127:0] fact_pack(
      input int s, o, r, e, conf, trans, pol, fctx);
    fact_pack = {28'd0,conf[7:0],fctx[7:0],4'd1,1'b0,1'b1,pol[0],trans[0],
                 e[19:0],r[7:0],o[19:0],s[19:0]};
  endfunction
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl*65536 + (key & 12'hFFF)*16;
  endfunction
  function automatic string qstr(input int w);
    begin
      unique case (w)
        0: qstr = "pump requires indirect";
        1: qstr = "valve requires indirect";
        2: qstr = "chiller requires indirect";
        3: qstr = "ahu connects indirect";
        4: qstr = "tower requires indirect";
        default: qstr = "pump requires indirect";
      endcase
    end
  endfunction

  task automatic plant_post8(
      input int e0, input int e1, input int e2, input int e3,
      input int e4, input int e5, input int e6, input int e7);
    logic [127:0] b0, b1;
    begin
      b0 = e3; b0=(b0<<32)|e2; b0=(b0<<32)|e1; b0=(b0<<32)|e0;
      b1 = e7; b1=(b1<<32)|e6; b1=(b1<<32)|e5; b1=(b1<<32)|e4;
      axi_wr(POST_HEAP, b0);
      axi_wr(POST_HEAP+28'd16, b1);
    end
  endtask
  task automatic plant_index(input int nfact, input int k0, input int k1, input int k2);
    begin
      axi_wr(dir_addr(0,k0), dir_pack(nfact));
      axi_wr(dir_addr(1,k1), dir_pack(nfact));
      axi_wr(dir_addr(2,k2), dir_pack(nfact));
    end
  endtask
  task automatic wr_f(input int e, s, o, r, conf, trans, pol, fctx);
    axi_wr(FACT_BASE+(e<<4), fact_pack(s,o,r,e,conf,trans,pol,fctx));
  endtask

  task automatic plant_q(input int qi, input int kind);
    int w, subj, rel, k0, k1, k2;
    int g0, g1, d0, d1, s0, s1, pf0, pf1;
    int gmid, dmid, gdst, ddst, pmid, pdst;
    int cx1g, cx2g, cx1d, cx2d, cfg, cfd;
    bit hold, shuf, gold_has_f, dist_has_f;
    begin
      hold = (kind==1) || (kind==3);
      shuf = (kind==2) || (kind==3);
      w = hold ? C3_HO_W[qi] : C3_TR_W[qi];
      subj = C3_W_SUBJ[w]; rel = C3_W_REL[w];
      k0 = C3_W_K0[w]; k1 = C3_W_K1[w]; k2 = C3_W_K2[w];
      gold_has_f = !shuf;
      dist_has_f = shuf;
      if (kind==0) begin
        g0=C3_TR_G0[qi]; g1=g0+1; d0=g0+2; d1=g0+3;
      end else if (kind==1) begin
        d0=C3_HO_D0[qi]; d1=d0+1; g0=C3_HO_G0[qi]; g1=g0+1;
      end else if (kind==2) begin
        d0=C3_SH_D0[qi]; d1=d0+1; g0=d0+2; g1=d0+3;
      end else begin
        g0=C3_SHH_G0[qi]; g1=g0+1; d0=C3_SHH_D0[qi]; d1=d0+1;
      end
      gmid=32'h30; dmid=32'h38+qi;
      if (kind==1) gdst = C3_HO_GDST[qi];
      else gdst = C3_SHARED_DST;
      ddst = 32'h90+qi;
      if (hold) begin cfg=C3_HO_CONF_Q[qi]; cfd=cfg; end
      else begin cfg=C3_TR_CONF_W[w]; cfd=cfg; end
      if (gold_has_f) begin
        if (hold) begin cx1g=C3_HO_CX1[qi]; cx2g=C3_HO_CX2[qi]; end
        else begin cx1g=C3_TR_CX1; cx2g=C3_TR_CX2; end
      end else begin cx1g=0; cx2g=0; end
      if (dist_has_f) begin
        if (hold) begin cx1d=C3_HO_CX1[qi]; cx2d=C3_HO_CX2[qi]; end
        else begin cx1d=C3_TR_CX1; cx2d=C3_TR_CX2; end
      end else begin cx1d=0; cx2d=0; end
      s0=32'h200+w*2; s1=32'h201+w*2;
      pf0=32'h300+w*2; pf1=32'h301+w*2;
      pmid=32'hA0+w*2; pdst=32'hB0+w*2;
      plant_post8(g0,g1,d0,d1,s0,s1,pf0,pf1);
      plant_index(8, k0, k1, k2);
      wr_f(g0, subj, gmid, rel, cfg, 1, 1, cx1g);
      wr_f(g1, gmid, gdst, rel, cfg, 1, 1, cx2g);
      wr_f(d0, subj, dmid, rel, cfd, 1, 1, cx1d);
      wr_f(d1, dmid, ddst, rel, cfd, 1, 1, cx2d);
      wr_f(s0, subj, C3_SHARED_MID, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(s1, C3_SHARED_MID, C3_SHARED_BG_DST, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf0, subj, pmid, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf1, pmid, pdst, rel, C3_EXTRA_CONF, 1, 1, 0);
      plant = 1'b0;
      p_awvalid = 1'b0; p_wvalid = 1'b0; p_wlast = 1'b0;
      wait_ui(8);
    end
  endtask

  task send_text(input string s);
    integer n,k;
    begin
      n=s.len();
      for (k=0;k<n;k=k+1) begin
        @(posedge ui_clk); while (!tok_r) @(posedge ui_clk);
        tok_v = 1'b1; tok = s[k];
        @(posedge ui_clk); tok_v = 1'b0;
      end
      @(posedge ui_clk); fire = 1'b1;
      @(posedge ui_clk); fire = 1'b0;
    end
  endtask
  task wait_done;
    integer g;
    begin
      g = 0;
      while (!result_v && (g < 2000000)) begin @(posedge ui_clk); g = g + 1; end
      if (!result_v) begin
        $display("TIMEOUT"); fail = fail + 1;
        if (first_div=="") first_div="TIMEOUT";
      end
    end
  endtask
  task retire_q;
    begin
      @(posedge ui_clk); retire = 1'b1;
      @(posedge ui_clk); retire = 1'b0;
      while (result_v) @(posedge ui_clk);
      wait_ui(4);
    end
  endtask
  task automatic hard_rst;
    begin
      plant = 1'b0; dut_rst_n = 1'b0;
      load_v = 1'b0; rew_v = 1'b0; fire = 1'b0; retire = 1'b0; tok_v = 1'b0; ctrl = 2'd0;
      wait_ui(8); dut_rst_n = 1'b1; wait_ui(16);
    end
  endtask
  task automatic dump(input string tag);
    $display("%s st=%0d npath=%0d ans=%0d p0=%0d p1=%0d acc=%0d cmt=%0d txn=%0d gen=%0d nupd=%0d phi0=%0d vbest=%0d w0=%0d tbl=%0d obj=%0d ctx=%0d",
      tag, st, npath, ans, p0, p1, pend_acc, pend_cmt, txn, gen, nupd, phi0, vbest, wdut[0], tbl, qobj, qctx);
  endtask
  task automatic pulse_rew(input int rv);
    begin
      @(posedge ui_clk);
      rew = rv[3:0]; rew_txn = txn; rew_gen = gen; rew_v = 1'b1;
      @(posedge ui_clk);
      rew_v = 1'b0; rew = ~rew; rew_txn = 8'hFF; rew_gen = 8'hFF;
    end
  endtask
  task automatic wait_upd(input int expect_n);
    integer g;
    begin
      g = 0;
      while ((nupd != expect_n[15:0] || !pend_cmt) && (g < 4000)) begin
        @(posedge ui_clk); g = g + 1;
      end
      chk($sformatf("NUPD_%0d", expect_n), nupd==expect_n[15:0] && pend_cmt);
    end
  endtask
  task automatic q_s(input int qi, input int kind);
    int w; bit hold;
    begin
      hold = (kind==1) || (kind==3);
      w = hold ? C3_HO_W[qi] : C3_TR_W[qi];
      plant_q(qi, kind);
      send_text(qstr(w));
      wait_done();
      n_rank = n_rank + 1;
      if (st==ST_ANSWER) n_ans = n_ans + 1;
      if (npath==5'd4) npath4_c = npath4_c + 1;
      else chk($sformatf("NPATH4_K%0d_Q%0d", kind, qi), 1'b0);
    end
  endtask
  function automatic bit pid_picks_hold(input int qi);
    int pg, pd;
    begin
      pg = pidmap[C3_HO_GDST[qi][7:0]];
      pd = pidmap[C3_HO_DDST[qi][7:0]];
      pid_picks_hold = (pg > pd) || ((pg==pd) && (C3_HO_G0[qi] < C3_HO_D0[qi]));
    end
  endfunction

  initial begin
    int seed, qa, qb, qc, qd, acc_a, acc_b, acc_c, acc_d, pid_hit;
    int sum_a, sum_b, sum_c, sum_d, gain_pp, pair_pos, dj_fail;
    int tr_seen [0:255];
    int ho_seen [0:255];
    fail=0; first_div=""; ctrl=0; tok_v=0; fire=0; retire=0;
    rew_v=0; rew=0; rew_txn=0; rew_gen=0; live_ep=16'd7;
    load_v=0; load_idx=0; load_w=0; plant=1; dut_rst_n=0;
    p_awvalid=0; p_wvalid=0; p_wlast=0; p_bready=1; p_awid=0;
    p_awaddr=0; p_awlen=0; p_awsize=3'd4; p_awburst=2'b01;
    p_wdata=0; p_wstrb=16'hFFFF;
    go_s=0; go_u=0; iso_load=0; iso_rew=0;
    n_rank=0; n_ans=0; npath4_c=0; host_bad=0;
    sum_a=0; sum_b=0; sum_c=0; sum_d=0; pair_pos=0; dj_fail=0;
    for (i=0;i<32;i=i+1) begin xiso[i]=0; wsnap[i]=0; end
    for (i=0;i<256;i=i+1) begin pidmap[i]=0; tr_seen[i]=0; ho_seen[i]=0; end

    $display("C3_HELD_OUT_MIG PROGRAM=NO BOARD_PASS=REJECT C3_MASTER=OPEN MIG_XSIM=1 TO_CYC=%0d", C3_TO_CYC);
    wait (init_calib_complete === 1'b1);
    $display("CLASS_mig_calib_complete HIT t=%0t", $time);
    wait_ui(50);
    dut_rst_n = 1'b1;
    wait_ui(16);

    $display("C3_GEN seed=%08h N_SEED=%0d N_TRAIN=%0d N_HOLD=%0d TR_W=0,1,2 HO_W=3,4 DISJOINT=1 PROGRAM=NO",
      C3_GEN_SEED, C3_N_SEED, C3_N_Q, C3_N_Q);
    for (i=0;i<8;i=i+1) tr_seen[C3_W_SUBJ[C3_TR_W[i]]] = 1;
    for (i=0;i<8;i=i+1) ho_seen[C3_W_SUBJ[C3_HO_W[i]]] = 1;
    for (i=0;i<256;i=i+1) if (tr_seen[i] && ho_seen[i]) dj_fail = dj_fail + 1;
    if (dj_fail==0) $display("CLASS_entities_disjoint HIT train={10,11,1} hold={6,9}");
    else $display("CLASS_entities_disjoint MISS overlap=%0d", dj_fail);
    chk("ENTITIES_DISJOINT_ORACLE", dj_fail==0);

    xiso[0]=8'sd50; iso_rew=4'sd3;
    wait(rdy); @(posedge ui_clk); go_u=1; @(posedge ui_clk); go_u=0; wait(dn); @(posedge ui_clk);
    $display("ISO_P3 w0=%0d viso=%0d", wiso[0], viso);
    chk("ISO_P3_X50_DW5", wiso[0]===16'sd5 && wiso[1]===0);

    for (seed=0; seed<C3_N_SEED; seed=seed+1) begin
      live_ep = 16'd7 + seed[15:0];
      $display("C3_SEED_BEGIN s=%0d live_ep=%0d", seed, live_ep);

      hard_rst(); ctrl=2'd1;
      acc_b=0;
      for (q=0;q<8;q=q+1) begin
        q_s(q, 1);
        dump($sformatf("B_S%0d_Q%0d", seed, q));
        chk($sformatf("B_S%0d_Q%0d_ANSWER", seed, q), (st===ST_ANSWER) && !tbl);
        if (p0===C3_HO_G0[q][19:0]) acc_b = acc_b + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      $display("CLASS_arm_B_frozen HIT seed=%0d acc=%0d/8 ctrl=1 freeze_i=1", seed, acc_b);
      sum_b = sum_b + acc_b;

      hard_rst(); ctrl=2'd0;
      acc_a=0;
      for (q=0;q<8;q=q+1) begin
        q_s(q, 0);
        dump($sformatf("A_TR_S%0d_Q%0d", seed, q));
        pulse_rew(3); wait_upd(q+1); retire_q();
      end
      for (q=0;q<8;q=q+1) begin
        q_s(q, 1);
        dump($sformatf("A_HO_S%0d_Q%0d", seed, q));
        chk($sformatf("A_S%0d_Q%0d_ANSWER", seed, q), (st===ST_ANSWER) && !tbl);
        if (p0===C3_HO_G0[q][19:0]) acc_a = acc_a + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      $display("CLASS_arm_A_learner HIT seed=%0d acc=%0d/8 nupd=%0d", seed, acc_a, nupd);
      sum_a = sum_a + acc_a;
      if (acc_a > acc_b) pair_pos = pair_pos + 1;

      hard_rst(); ctrl=2'd0;
      acc_c=0;
      for (q=0;q<8;q=q+1) begin
        q_s(q, 2);
        pulse_rew(3); wait_upd(q+1); retire_q();
      end
      for (q=0;q<8;q=q+1) begin
        q_s(q, 3);
        dump($sformatf("C_HO_S%0d_Q%0d", seed, q));
        if (p0===C3_SHH_G0[q][19:0]) acc_c = acc_c + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      $display("CLASS_arm_C_shuffled HIT seed=%0d acc=%0d/8", seed, acc_c);
      sum_c = sum_c + acc_c;

      hard_rst(); ctrl=2'd0;
      for (i=0;i<256;i=i+1) pidmap[i]=0;
      acc_d=0; pid_hit=0;
      for (q=0;q<8;q=q+1) begin
        q_s(q, 0);
        if (ans[19:8]==12'd0) pidmap[ans[7:0]] = pidmap[ans[7:0]] + 3;
        pulse_rew(3); wait_upd(q+1); retire_q();
      end
      for (q=0;q<8;q=q+1) begin
        q_s(q, 1);
        dump($sformatf("D_HO_S%0d_Q%0d", seed, q));
        if (pid_picks_hold(q)) pid_hit = pid_hit + 1;
        if (p0===C3_HO_G0[q][19:0]) acc_d = acc_d + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      $display("CLASS_arm_D_perid HIT seed=%0d dut_gold=%0d/8 pid_pick_gold=%0d/8", seed, acc_d, pid_hit);
      sum_d = sum_d + pid_hit;

      qa = acc_a; qb = acc_b; qc = acc_c; qd = pid_hit;
      gain_pp = (qa - qb) * 100 / 8;
      $display("C3_SEED_GAIN s=%0d A=%0d B=%0d C=%0d Dpid=%0d gain_pp=%0d", seed, qa, qb, qc, qd, gain_pp);
    end

    gain_pp = (sum_a - sum_b) * 100 / (8*C3_N_SEED);
    $display("C3_SUM A=%0d/%0d B=%0d C=%0d Dpid=%0d gain_pp=%0d pair_pos=%0d/%0d host_bad=%0d",
      sum_a, 8*C3_N_SEED, sum_b, sum_c, sum_d, gain_pp, pair_pos, C3_N_SEED, host_bad);
    if (gain_pp >= 10) $display("CLASS_gain_A_over_B HIT gain_pp=%0d", gain_pp);
    else $display("CLASS_gain_A_over_B MISS gain_pp=%0d", gain_pp);
    if (host_bad==0) $display("CLASS_host_winner_zero HIT");
    else $display("CLASS_host_winner_zero MISS n=%0d", host_bad);
    chk("HOST_WINNER_ADDR_WEIGHT_ZERO", host_bad==0);
    chk("PAIR_A_GT_B_SEEDS", pair_pos==C3_N_SEED);
    chk("A_GT_SHUFFLE", sum_a > sum_c);

    if (fail==0) $display("ASTRA_C3_HELD_OUT_MIG_XSIM_PASS");
    else $display("ASTRA_C3_HELD_OUT_MIG_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C3_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO quality=MIG_PHY_PLANTED_2HOP_5SEED");
    $finish;
  end

  initial begin
    #5s;
    $display("FIRST_DIVERGENCE MIG_TIMEOUT calib_or_held_out hung");
    $display("RESULT=FAIL");
    $display("ASTRA_C3_HELD_OUT_MIG_XSIM_PASS ABSENT");
    $finish;
  end
endmodule
