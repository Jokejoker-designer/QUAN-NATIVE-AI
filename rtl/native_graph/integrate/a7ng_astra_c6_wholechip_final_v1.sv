`timescale 1ns / 1ps
// a7ng_astra_c6_wholechip_final_v1.sv — named C6 wrap. PROGRAM=NO.
// Instantiates a7ng_astra_c5_prod_top_final_v1 + official mig_native_wrap.
// Forwards MIG RRESP/RLAST/RID/BRESP/BID. Derives ARID from address so C3
// fact beats keep A7NG_C3_FACT_RID (live C6 tied ARID=0; that would fail RID law).
// Does not edit live a7ng_astra_c6_wholechip.sv / KEEP / MIG prj.
// alias_wr: FPGA boot from ENTITY_ALIAS_PROD_V1 (not host, not per-query).
// bank_r_i tied 0: WO forbids host/switch F/R.
// Not C6_MASTER. Not BOARD_PASS.

`include "a7ng_astra_c5_prod_top_final_v1.svh"
`include "a7ng_astra_c3_held_out.svh"

module a7ng_astra_c6_wholechip_final_v1 (
  input  logic        CLK100MHZ,
  input  logic [3:0]  sw,
  input  logic [3:0]  btn,
  output logic [3:0]  led,
  input  logic        uart_txd_in,
  output logic        uart_rxd_out,
  output logic [13:0] ddr3_addr,
  output logic [2:0]  ddr3_ba,
  output logic        ddr3_cas_n,
  output logic [0:0]  ddr3_ck_n,
  output logic [0:0]  ddr3_ck_p,
  output logic [0:0]  ddr3_cke,
  output logic [0:0]  ddr3_cs_n,
  output logic        ddr3_ras_n,
  output logic        ddr3_reset_n,
  output logic        ddr3_we_n,
  inout  logic [15:0] ddr3_dq,
  inout  logic [1:0]  ddr3_dqs_n,
  inout  logic [1:0]  ddr3_dqs_p,
  output logic [1:0]  ddr3_dm,
  output logic [0:0]  ddr3_odt
);
  logic clk166, clk200, clk_locked, btn0_166;
  logic ui_clk, ui_rst, calib, mig_mmcm;
  logic [23:0] mig_rst_hold;
  logic mig_rst_n;

  clk_arty_ddr u_clk (
    .clk100(CLK100MHZ),
    .rst(btn[0]),
    .clk_166(clk166),
    .clk_200(clk200),
    .locked(clk_locked)
  );

  sync_bits #(.WIDTH(1)) u_b0_166 (
    .clk(clk166),
    .rst_n(clk_locked),
    .async_in(btn[0]),
    .sync_out(btn0_166)
  );

  always_ff @(posedge clk166 or negedge clk_locked) begin
    if (!clk_locked) begin
      mig_rst_hold <= 24'hFF_FFFF;
      mig_rst_n    <= 1'b0;
    end else if (btn0_166) begin
      mig_rst_hold <= 24'hFF_FFFF;
      mig_rst_n    <= 1'b0;
    end else if (mig_rst_hold != 24'd0) begin
      mig_rst_hold <= mig_rst_hold - 24'd1;
      mig_rst_n    <= 1'b0;
    end else
      mig_rst_n <= 1'b1;
  end

  logic [3:0]   awid, arid, bid, rid;
  logic [27:0]  awaddr, araddr;
  logic [7:0]   awlen, arlen;
  logic [2:0]   awsize, arsize;
  logic [1:0]   awburst, arburst, bresp, rresp;
  logic         awvalid, awready, wlast, wvalid, wready, bvalid, bready;
  logic         arvalid, arready, rlast, rvalid, rready;
  logic [127:0] wdata, rdata;
  logic [15:0]  wstrb;

  logic        c5_arvalid, c5_arready, c5_rvalid, c5_rready;
  logic [27:0] c5_araddr;
  logic [127:0] c5_rdata;
  logic        c5_awvalid, c5_awready, c5_wvalid, c5_wready, c5_wlast;
  logic [27:0] c5_awaddr;
  logic [127:0] c5_wdata;
  logic [15:0] c5_wstrb;
  logic        c5_bvalid, c5_bready;
  logic        c5_done, c5_dual, c5_busy;
  logic [1:0]  c5_rst_sync;
  logic        c5_rst_n;
  logic signed [15:0] unused_w [0:31];

  assign awid    = 4'd1;
  assign arid    = (c5_araddr >= A7NG_C5P_FACT_BASE) ? A7NG_C3_FACT_RID : 4'd1;
  assign awlen   = 8'd0;
  assign arlen   = 8'd0;
  assign awsize  = 3'd4;
  assign arsize  = 3'd4;
  assign awburst = 2'b01;
  assign arburst = 2'b01;
  assign wstrb   = c5_wstrb;

  assign arvalid    = c5_arvalid;
  assign araddr     = c5_araddr;
  assign c5_arready = arready;
  assign c5_rvalid  = rvalid;
  assign c5_rdata   = rdata;
  assign rready     = c5_rready;

  assign awvalid    = c5_awvalid;
  assign awaddr     = c5_awaddr;
  assign c5_awready = awready;
  assign wvalid     = c5_wvalid;
  assign wdata      = c5_wdata;
  assign wlast      = c5_wlast;
  assign c5_wready  = wready;
  assign c5_bvalid  = bvalid;
  assign bready     = c5_bready;

  mig_native_wrap u_mig (
    .sys_clk_i(clk166),
    .clk_ref_i(clk200),
    .sys_rst_n(mig_rst_n),
    .ui_clk(ui_clk),
    .ui_rst(ui_rst),
    .init_calib_complete(calib),
    .mmcm_locked(mig_mmcm),
    .ddr3_addr(ddr3_addr),
    .ddr3_ba(ddr3_ba),
    .ddr3_cas_n(ddr3_cas_n),
    .ddr3_ck_n(ddr3_ck_n),
    .ddr3_ck_p(ddr3_ck_p),
    .ddr3_cke(ddr3_cke),
    .ddr3_cs_n(ddr3_cs_n),
    .ddr3_ras_n(ddr3_ras_n),
    .ddr3_reset_n(ddr3_reset_n),
    .ddr3_we_n(ddr3_we_n),
    .ddr3_dq(ddr3_dq),
    .ddr3_dqs_n(ddr3_dqs_n),
    .ddr3_dqs_p(ddr3_dqs_p),
    .ddr3_dm(ddr3_dm),
    .ddr3_odt(ddr3_odt),
    .s_axi_awid(awid),
    .s_axi_awaddr(awaddr),
    .s_axi_awlen(awlen),
    .s_axi_awsize(awsize),
    .s_axi_awburst(awburst),
    .s_axi_awvalid(awvalid),
    .s_axi_awready(awready),
    .s_axi_wdata(wdata),
    .s_axi_wstrb(wstrb),
    .s_axi_wlast(wlast),
    .s_axi_wvalid(wvalid),
    .s_axi_wready(wready),
    .s_axi_bid(bid),
    .s_axi_bresp(bresp),
    .s_axi_bvalid(bvalid),
    .s_axi_bready(bready),
    .s_axi_arid(arid),
    .s_axi_araddr(araddr),
    .s_axi_arlen(arlen),
    .s_axi_arsize(arsize),
    .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid),
    .s_axi_arready(arready),
    .s_axi_rid(rid),
    .s_axi_rdata(rdata),
    .s_axi_rresp(rresp),
    .s_axi_rlast(rlast),
    .s_axi_rvalid(rvalid),
    .s_axi_rready(rready)
  );

  always_ff @(posedge ui_clk) begin
    if (ui_rst || !calib)
      c5_rst_sync <= 2'b00;
    else
      c5_rst_sync <= {c5_rst_sync[0], 1'b1};
  end
  assign c5_rst_n = c5_rst_sync[1];

  logic        alias_wr_v;
  logic [2:0]  alias_wr_idx;
  logic [19:0] alias_wr_key;
  logic [31:0] alias_wr_sym;
  logic        alias_wr_ovf;
  logic        dict_lock /* synthesis keep = 1 */;

  a7ng_astra_c6_alias_boot_v1 u_alias_boot (
    .clk(ui_clk),
    .rst_n(c5_rst_n),
    .wr_v_o(alias_wr_v),
    .wr_idx_o(alias_wr_idx),
    .wr_key_o(alias_wr_key),
    .wr_sym_o(alias_wr_sym),
    .wr_ovf_o(alias_wr_ovf),
    .dict_lock_o(dict_lock)
  );

  a7ng_astra_c5_prod_top_final_v1 u_c5 (
    .clk(ui_clk),
    .rst_n(c5_rst_n),
    .live_epoch_i({12'h000, sw}),
    .uart_rx_i(uart_txd_in),
    .uart_tx_o(uart_rxd_out),
    .alias_wr_v_i(alias_wr_v),
    .alias_wr_idx_i(alias_wr_idx),
    .alias_wr_key_i(alias_wr_key),
    .alias_wr_sym_i(alias_wr_sym),
    .alias_wr_ovf_i(alias_wr_ovf),
    .bank_r_i(1'b0),
    .m_arvalid_o(c5_arvalid),
    .m_araddr_o(c5_araddr),
    .m_arready_i(c5_arready),
    .m_rvalid_i(c5_rvalid),
    .m_rdata_i(c5_rdata),
    .m_rresp_i(rresp),
    .m_rlast_i(rlast),
    .m_rid_i(rid),
    .m_rready_o(c5_rready),
    .m_awvalid_o(c5_awvalid),
    .m_awaddr_o(c5_awaddr),
    .m_awready_i(c5_awready),
    .m_wvalid_o(c5_wvalid),
    .m_wdata_o(c5_wdata),
    .m_wlast_o(c5_wlast),
    .m_wstrb_o(c5_wstrb),
    .m_wready_i(c5_wready),
    .m_bvalid_i(c5_bvalid),
    .m_bresp_i(bresp),
    .m_bid_i(bid),
    .m_bready_o(c5_bready),
    .busy_o(c5_busy),
    .done_o(c5_done),
    .seen_gnt_o(),
    .owner_o(),
    .dual_err_o(c5_dual),
    .n_switch_o(),
    .n_block_o(),
    .n_host_winner_o(),
    .n_host_tok_o(),
    .qid_map_o(),
    .a09_o(),
    .plant_dut_o(),
    .inst_mask_o(),
    .n_uart_rx_o(),
    .n_uart_tx_o(),
    .c3_status_o(),
    .c3_obj_o(),
    .c3_ans_o(),
    .c3_p0_o(),
    .c3_p1_o(),
    .c3_result_v_o(),
    .c3_pend_cmt_o(),
    .persist_valid_o(),
    .persist_w0_o(),
    .persist_phase_o(),
    .gen_done_o(),
    .gen_last_o(),
    .parser_hit_o(),
    .evid_has_o(),
    .last_aw_o(),
    .c3_pend_acc_o(),
    .c3_busy_o(),
    .c3_txn_o(),
    .c3_gen_o(),
    .c3_nupd_o(),
    .c3_ndup_o(),
    .c3_nbad_o(),
    .c3_w_o(unused_w),
    .n_rew_ok_o(),
    .n_rew_crc_o(),
    .n_rew_sess_o(),
    .n_rew_range_o(),
    .n_rew_frz_o(),
    .n_rew_len_o(),
    .ckpt_restored_o(),
    .ckpt_busy_o(),
    .ckpt_fail_o(),
    .n_stream_o(),
    .n_fifo_ovf_o(),
    .gen_n_out_o(),
    .last_c3_rresp_o(),
    .last_bresp_o(),
    .last_ckpt_rresp_o(),
    .c3_proof_ok_o(),
    .answer_allowed_o(),
    .alias_ok_o()
  );

  assign led[0] = calib;
  assign led[1] = mig_mmcm & clk_locked;
  assign led[2] = c5_done;
  assign led[3] = c5_dual | c5_busy;
endmodule
