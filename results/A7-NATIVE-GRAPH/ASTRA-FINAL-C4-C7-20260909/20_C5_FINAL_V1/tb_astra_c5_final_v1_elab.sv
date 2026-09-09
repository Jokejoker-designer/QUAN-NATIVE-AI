`timescale 1ns / 1ps
// Elaborate-only. PROGRAM=NO. Not C5_MASTER. Not BOARD_PASS.
module tb_astra_c5_final_v1_elab;
  logic clk, rst_n;
  logic [15:0] epoch;
  logic uart_rx, uart_tx;
  logic awv, arr, wv, brdy, arv, rrdy, busy, done;
  logic [27:0] awa, ara;
  logic [127:0] wd, rd;
  logic [15:0] wstrb;
  logic [1:0] rresp, bresp;
  logic rlast, rvalid, bvalid, arready, awready, wready;
  logic [3:0] rid, bid;
  logic signed [15:0] wdummy [0:31];

  a7ng_astra_c5_prod_top_final_v1 #(
    .CLK_HZ(8000),
    .BAUD(800)
  ) u_dut (
    .clk(clk),
    .rst_n(rst_n),
    .live_epoch_i(epoch),
    .uart_rx_i(uart_rx),
    .uart_tx_o(uart_tx),
    .alias_wr_v_i(1'b0),
    .alias_wr_idx_i(3'd0),
    .alias_wr_key_i(20'd0),
    .alias_wr_sym_i(32'd0),
    .alias_wr_ovf_i(1'b0),
    .bank_r_i(1'b0),
    .m_arvalid_o(arv),
    .m_araddr_o(ara),
    .m_arready_i(arready),
    .m_rvalid_i(rvalid),
    .m_rdata_i(rd),
    .m_rresp_i(rresp),
    .m_rlast_i(rlast),
    .m_rid_i(rid),
    .m_rready_o(rrdy),
    .m_awvalid_o(awv),
    .m_awaddr_o(awa),
    .m_awready_i(awready),
    .m_wvalid_o(wv),
    .m_wdata_o(wd),
    .m_wlast_o(),
    .m_wstrb_o(wstrb),
    .m_wready_i(wready),
    .m_bvalid_i(bvalid),
    .m_bresp_i(bresp),
    .m_bid_i(bid),
    .m_bready_o(brdy),
    .busy_o(busy),
    .done_o(done),
    .seen_gnt_o(),
    .owner_o(),
    .dual_err_o(),
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
    .c3_w_o(wdummy),
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

  initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    epoch = 16'd1;
    uart_rx = 1'b1;
    arready = 1'b0;
    rvalid = 1'b0;
    rd = 128'd0;
    rresp = 2'b00;
    rlast = 1'b1;
    rid = 4'd0;
    awready = 1'b0;
    wready = 1'b0;
    bvalid = 1'b0;
    bresp = 2'b00;
    bid = 4'd0;
    $display("C5_FINAL_V1_ELAB PROGRAM=NO C5_MASTER=OPEN BOARD_PASS=OPEN");
    $display("PROD_DICT=OPEN C6_SWITCH=NO PROGRAM=NO");
    $display("ASTRA_C5_FINAL_V1_ELAB_OK");
    $finish;
  end
endmodule
