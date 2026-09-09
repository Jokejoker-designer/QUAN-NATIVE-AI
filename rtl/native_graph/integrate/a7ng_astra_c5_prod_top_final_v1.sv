// a7ng_astra_c5_prod_top_final_v1.sv
// Hand-built C5 hierarchy. PROGRAM=NO. C5_MASTER=OPEN. Not BOARD_PASS.
// RESP AXI adapter + STREAM tfifo + REWARD 0x16 + PENDING ckpt_pend
// + C4 wrap (alias 20-bit → mat V2 → gate → D32 V2 / S_SAFE).
// Does not instantiate grounded_gen. Does not auto +3.
// Production alias table OPEN (reset empty → miss → hardware n,o,EOS).
// Candidate SRC={12'b0,subj} DST=ans_o is NOT a frozen vocalization map.
// wrap.direction_i = C3 qse_dir (live extract is 2'd0). bank_r_i is TB-only;
// C6 must not drive it from sw[]. Parser reverse encoding besides 2'd0 is OPEN.
// Does not edit live prod_top / C6. Do not Copy-Item siblings.
`timescale 1ns / 1ps
`include "a7ng_astra_c5_ddr_arb.svh"
`include "a7ng_astra_c5_prod_top_final_v1.svh"
`include "a7ng_astra_c3_held_out.svh"
`include "a7ng_astra_c5_sgd32_ckpt_pend.svh"
`include "a7ng_astra_c4_entity_alias_v1.svh"
`include "a7ng_gate14_crc.svh"

module a7ng_astra_c5_prod_top_final_v1 #(
  parameter int unsigned CLK_HZ  = A7NG_C5P_CLK_HZ,
  parameter int unsigned BAUD    = A7NG_C5P_BAUD,
  parameter int unsigned ALIAS_N = A7NG_C4_ALIAS_N_TB
) (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [15:0] live_epoch_i,
  input  logic        uart_rx_i,
  output logic        uart_tx_o,
  input  logic        alias_wr_v_i,
  input  logic [2:0]  alias_wr_idx_i,
  input  logic [19:0] alias_wr_key_i,
  input  logic [31:0] alias_wr_sym_i,
  input  logic        alias_wr_ovf_i,
  input  logic        bank_r_i,
  output logic        m_arvalid_o,
  output logic [27:0] m_araddr_o,
  input  logic        m_arready_i,
  input  logic        m_rvalid_i,
  input  logic [127:0] m_rdata_i,
  input  logic [1:0]  m_rresp_i,
  input  logic        m_rlast_i,
  input  logic [3:0]  m_rid_i,
  output logic        m_rready_o,
  output logic        m_awvalid_o,
  output logic [27:0] m_awaddr_o,
  input  logic        m_awready_i,
  output logic        m_wvalid_o,
  output logic [127:0] m_wdata_o,
  output logic        m_wlast_o,
  output logic [15:0] m_wstrb_o,
  input  logic        m_wready_i,
  input  logic        m_bvalid_i,
  input  logic [1:0]  m_bresp_i,
  input  logic [3:0]  m_bid_i,
  output logic        m_bready_o,
  output logic        busy_o,
  output logic        done_o,
  output logic [5:0]  seen_gnt_o,
  output logic [2:0]  owner_o,
  output logic        dual_err_o,
  output logic [15:0] n_switch_o,
  output logic [15:0] n_block_o,
  output logic [15:0] n_host_winner_o,
  output logic [15:0] n_host_tok_o,
  output logic        qid_map_o,
  output logic        a09_o,
  output logic        plant_dut_o,
  output logic [15:0] inst_mask_o,
  output logic [15:0] n_uart_rx_o,
  output logic [15:0] n_uart_tx_o,
  output logic [3:0]  c3_status_o,
  output logic [7:0]  c3_obj_o,
  output logic [19:0] c3_ans_o,
  output logic [19:0] c3_p0_o,
  output logic [19:0] c3_p1_o,
  output logic        c3_result_v_o,
  output logic        c3_pend_cmt_o,
  output logic        persist_valid_o,
  output logic signed [15:0] persist_w0_o,
  output logic [3:0]  persist_phase_o,
  output logic        gen_done_o,
  output logic [7:0]  gen_last_o,
  output logic        parser_hit_o,
  output logic        evid_has_o,
  output logic [27:0] last_aw_o,
  output logic        c3_pend_acc_o,
  output logic        c3_busy_o,
  output logic [7:0]  c3_txn_o,
  output logic [7:0]  c3_gen_o,
  output logic [15:0] c3_nupd_o,
  output logic [15:0] c3_ndup_o,
  output logic [15:0] c3_nbad_o,
  output logic signed [15:0] c3_w_o [0:31],
  output logic [15:0] n_rew_ok_o,
  output logic [15:0] n_rew_crc_o,
  output logic [15:0] n_rew_sess_o,
  output logic [15:0] n_rew_range_o,
  output logic [15:0] n_rew_frz_o,
  output logic [15:0] n_rew_len_o,
  output logic        ckpt_restored_o,
  output logic        ckpt_busy_o,
  output logic [3:0]  ckpt_fail_o,
  output logic [15:0] n_stream_o,
  output logic [15:0] n_fifo_ovf_o,
  output logic [7:0]  gen_n_out_o,
  output logic [1:0]  last_c3_rresp_o,
  output logic [1:0]  last_bresp_o,
  output logic [1:0]  last_ckpt_rresp_o,
  output logic        c3_proof_ok_o,
  output logic        answer_allowed_o,
  output logic        alias_ok_o
);
  typedef enum logic [3:0] {
    ST_BOOT0, ST_BOOT1, ST_BOOT2, ST_UART, ST_DRAIN, ST_WAITQ,
    ST_PERS, ST_GEN, ST_TXNL, ST_DONE, ST_WAITSGD, ST_CLR, ST_RLPRE
  } pst_t;
  pst_t pst;

  logic [5:0] req, gnt, s_arv, s_arr, s_rv;
  logic [27:0] s_ara [0:5];
  logic [127:0] s_rd;
  logic [2:0] owner;
  logic dual;
  logic [15:0] n_sw, n_blk;
  logic [5:0] seen_gnt;
  logic dual_sticky;
  logic arb_rready;

  logic rx_valid;
  logic [7:0] rx_data;
  logic tx_start, tx_busy, tx_line;
  logic [7:0] tx_data;

  logic c3_tok_v, c3_tok_r, c3_fire, c3_retire, c3_busy, c3_res, c3_pacc, c3_pcmt, c3_tbl, c3_pok;
  logic [7:0] c3_tok, c3_txn, c3_gen, c3_obj, c3_ctx, c3_subj;
  logic [1:0] c3_dir;
  logic signed [3:0] c3_rew;
  logic c3_rew_v;
  logic [7:0] c3_rew_txn, c3_rew_gen;
  logic [1:0] c3_sel;
  logic [19:0] c3_ans, c3_p0, c3_p1;
  logic [4:0] c3_npath;
  logic [3:0] c3_st;
  logic [15:0] c3_nhw, c3_nha, c3_nupd, c3_ndup, c3_nbad;
  logic signed [15:0] c3_vb, c3_vs;
  logic signed [7:0] c3_phi0;
  logic signed [7:0] c3_pphi [0:31];
  logic signed [15:0] c3_w [0:31];
  logic [3:0] c3_arid, c3_rid;
  logic [27:0] c3_ara;
  logic [7:0] c3_arlen;
  logic [2:0] c3_arsz;
  logic [1:0] c3_arb, c3_rr;
  logic c3_arv, c3_arr, c3_rlast, c3_rv, c3_rrdy;
  logic [127:0] c3_rdata;

  logic adp_req, adp_arv, adp_arr, adp_rready;
  logic [27:0] adp_ara;
  logic [2:0] adp_cli;

  logic ck_go_p, ck_go_r, ck_ret, ck_clr, ck_busy, ck_pers, ck_rest, ck_ldv, ck_pldv, ck_pendld;
  logic [3:0] ck_ph, ck_fail;
  logic [4:0] ck_lidx, ck_pidx;
  logic signed [15:0] ck_lw;
  logic signed [7:0] ck_phi;
  logic [19:0] ck_p0, ck_p1, ck_ans;
  logic [1:0] ck_sel;
  logic [3:0] ck_st;
  logic [7:0] ck_txn, ck_gen;
  logic ck_pacc, ck_pcmt;
  logic [15:0] ck_seq, ck_crc;
  logic [3:0] p_awid, p_arid, p_bid, p_rid;
  logic [27:0] p_awa, p_ara;
  logic [7:0] p_awlen, p_arlen;
  logic [2:0] p_awsz, p_arsz;
  logic [1:0] p_awb, p_arb, p_br, p_rr;
  logic p_awv, p_awr, p_wv, p_wr, p_wl, p_bv, p_brdy, p_arv, p_arr, p_rv, p_rl, p_rrdy;
  logic [127:0] p_wd, p_rd;
  logic ckpt_hv;
  logic [127:0] ckpt_hd;
  logic [1:0] ckpt_hr;
  logic ckpt_hl;
  logic [3:0] ckpt_hid;
  logic [1:0] last_c3_rr, last_br, last_ck_rr;
  logic [15:0] p_wstrb;
  logic clr_ld;
  logic [4:0] clr_idx;
  logic [5:0] clr_n;
  logic flush_pend;
  logic [15:0] waitc;

  logic g_go, g_ret, g_busy, g_done, g_tv, g_eos;
  logic [7:0] g_tok, g_nout;
  logic [15:0] g_nhost;
  logic allow, mvalid, movf, aok, dknown;
  logic [3:0] g_vver;
  logic g_bank;
  logic [7:0] g_ctx [0:15];

  logic [19:0] akey [0:ALIAS_N-1];
  logic [31:0] asym [0:ALIAS_N-1];
  logic aval [0:ALIAS_N-1];
  logic aovf [0:ALIAS_N-1];

  logic [7:0] rxf [0:31];
  logic [5:0] rwr, rrd, rcnt;
  logic [15:0] n_urx, n_utx;
  logic [7:0] last_gen;
  logic [7:0] tfifo [0:7];
  logic [3:0] twr, trd, tcnt;
  logic [15:0] n_stream, n_ovf;
  logic parser_hit, evid_has_q;
  logic [2:0] boot_cli;
  logic [27:0] boot_ara, last_aw;
  logic boot_arv, boot_got;
  logic [1:0] c3_ctrl;
  logic ctl_line, line_seen, reload_pend, rew_act;
  logic [7:0] rew_buf [0:15];
  logic [3:0] rew_n;
  logic [15:0] n_rew_ok, n_rew_crc, n_rew_sess, n_rew_range, n_rew_frz, n_rew_len;
  integer ki, ri, rj;

  assign uart_tx_o = tx_line;
  assign qid_map_o = 1'b0;
  assign a09_o = 1'b0;
  assign plant_dut_o = 1'b0;
  assign inst_mask_o = A7NG_C5P_INST_MASK;
  assign seen_gnt_o = seen_gnt;
  assign owner_o = owner;
  assign dual_err_o = dual_sticky;
  assign n_switch_o = n_sw;
  assign n_block_o = n_blk;
  assign n_host_winner_o = c3_nhw;
  assign n_host_tok_o = g_nhost;
  assign n_uart_rx_o = n_urx;
  assign n_uart_tx_o = n_utx;
  assign c3_status_o = c3_st;
  assign c3_obj_o = c3_obj;
  assign c3_ans_o = c3_ans;
  assign c3_p0_o = c3_p0;
  assign c3_p1_o = c3_p1;
  assign c3_result_v_o = c3_res;
  assign c3_pend_cmt_o = c3_pcmt;
  assign c3_pend_acc_o = c3_pacc;
  assign c3_busy_o = c3_busy;
  assign c3_txn_o = c3_txn;
  assign c3_gen_o = c3_gen;
  assign c3_nupd_o = c3_nupd;
  assign c3_ndup_o = c3_ndup;
  assign c3_nbad_o = c3_nbad;
  assign n_rew_ok_o = n_rew_ok;
  assign n_rew_crc_o = n_rew_crc;
  assign n_rew_sess_o = n_rew_sess;
  assign n_rew_range_o = n_rew_range;
  assign n_rew_frz_o = n_rew_frz;
  assign n_rew_len_o = n_rew_len;
  assign c3_proof_ok_o = c3_pok;
  assign answer_allowed_o = allow;
  assign alias_ok_o = aok;
  genvar gw;
  generate for (gw = 0; gw < 32; gw = gw + 1) begin : g_c3w
    assign c3_w_o[gw] = c3_w[gw];
  end endgenerate
  assign persist_valid_o = ck_pers;
  assign persist_w0_o = c3_w[0];
  assign persist_phase_o = ck_ph;
  assign ckpt_restored_o = ck_rest;
  assign ckpt_busy_o = ck_busy;
  assign ckpt_fail_o = ck_fail;
  assign n_stream_o = n_stream;
  assign n_fifo_ovf_o = n_ovf;
  assign gen_n_out_o = g_nout;
  assign last_c3_rresp_o = last_c3_rr;
  assign last_bresp_o = last_br;
  assign last_ckpt_rresp_o = last_ck_rr;
  assign gen_done_o = g_done;
  assign gen_last_o = last_gen;
  assign parser_hit_o = parser_hit;
  assign evid_has_o = evid_has_q;
  assign last_aw_o = last_aw;
  assign m_rready_o = (owner == A7NG_C5_NONE)
    ? m_rvalid_i
    : (owner == A7NG_C5_CKPT)
      ? (arb_rready && (!ckpt_hv || p_rrdy))
      : (arb_rready && ((owner != adp_cli) || adp_rready));
  assign rcnt = rwr - rrd;
  assign busy_o = (pst != ST_DONE);
  assign done_o = (pst == ST_DONE);
  assign adp_arr = s_arr[adp_cli];
  assign p_arr = s_arr[A7NG_C5_CKPT];
  assign p_rd = ckpt_hd;
  assign p_rr = ckpt_hr;
  assign p_rl = ckpt_hl;
  assign p_rid = ckpt_hid;
  assign p_bid = m_bid_i;
  assign p_br = m_bresp_i;
  assign m_awvalid_o = (owner == A7NG_C5_CKPT) && p_awv;
  assign m_awaddr_o  = p_awa;
  assign p_awr       = (owner == A7NG_C5_CKPT) && m_awready_i;
  assign m_wvalid_o  = (owner == A7NG_C5_CKPT) && p_wv;
  assign m_wdata_o   = p_wd;
  assign m_wlast_o   = p_wl;
  assign m_wstrb_o   = p_wstrb;
  assign p_wr        = (owner == A7NG_C5_CKPT) && m_wready_i;
  assign p_bv        = (owner == A7NG_C5_CKPT) && m_bvalid_i;
  assign m_bready_o  = (owner == A7NG_C5_CKPT) && p_brdy;

  always_comb begin
    req = 6'd0;
    s_arv = 6'd0;
    for (ki = 0; ki < A7NG_C5_NCLI; ki = ki + 1) s_ara[ki] = 28'd0;
    if ((pst == ST_BOOT0) || (pst == ST_BOOT1) || (pst == ST_BOOT2)) begin
      req[boot_cli] = 1'b1;
      s_arv[boot_cli] = boot_arv;
      s_ara[boot_cli] = boot_ara;
    end
    if (adp_req) begin
      req[adp_cli] = 1'b1;
      s_arv[adp_cli] = adp_arv;
      s_ara[adp_cli] = adp_ara;
    end
    if ((pst == ST_PERS) || (pst == ST_DRAIN) || (pst == ST_RLPRE)
        || ck_busy || p_arv || p_awv || p_wv) begin
      req[A7NG_C5_CKPT] = 1'b1;
      s_arv[A7NG_C5_CKPT] = p_arv;
      s_ara[A7NG_C5_CKPT] = p_ara;
    end
  end

  uart_rx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) u_urx (
    .clk(clk), .rst_n(rst_n), .rx(uart_rx_i), .data(rx_data), .valid(rx_valid)
  );
  uart_tx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) u_utx (
    .clk(clk), .rst_n(rst_n), .start(tx_start), .data(tx_data), .tx(tx_line), .busy(tx_busy)
  );

  a7ng_astra_c5_ddr_arb u_arb (
    .clk(clk), .rst_n(rst_n),
    .req_i(req), .gnt_o(gnt), .owner_o(owner), .dual_err_o(dual),
    .n_switch_o(n_sw), .n_block_o(n_blk),
    .s_arvalid_i(s_arv), .s_araddr_i(s_ara), .s_arready_o(s_arr),
    .m_arvalid_o(m_arvalid_o), .m_araddr_o(m_araddr_o), .m_arready_i(m_arready_i),
    .m_rvalid_i(m_rvalid_i), .m_rdata_i(m_rdata_i), .m_rready_o(arb_rready),
    .s_rvalid_o(s_rv), .s_rdata_o(s_rd)
  );

  a7ng_astra_c5_axi1b_v1 u_adp (
    .clk(clk), .rst_n(rst_n),
    .s_arid(c3_arid), .s_araddr(c3_ara), .s_arlen(c3_arlen),
    .s_arvalid(c3_arv), .s_arready(c3_arr),
    .s_rid(c3_rid), .s_rdata(c3_rdata), .s_rresp(c3_rr),
    .s_rlast(c3_rlast), .s_rvalid(c3_rv), .s_rready(c3_rrdy),
    .req_o(adp_req), .arvalid_o(adp_arv), .araddr_o(adp_ara),
    .arready_i(adp_arr), .rvalid_i(s_rv[adp_cli]), .rdata_i(s_rd),
    .rresp_i(m_rresp_i), .rlast_i(m_rlast_i), .rid_i(m_rid_i),
    .rready_o(adp_rready), .cli_o(adp_cli)
  );

  a7ng_astra_c3_held_out_pendld u_c3 (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_epoch_i), .ctrl_i(c3_ctrl),
    .tok_valid_i(c3_tok_v), .tok_ready_o(c3_tok_r), .tok_i(c3_tok),
    .fire_i(c3_fire), .retire_i(c3_retire),
    .rew_v_i(c3_rew_v), .rew_i(c3_rew), .rew_txn_i(c3_rew_txn), .rew_gen_i(c3_rew_gen),
    .load_v_i(ck_ldv | clr_ld),
    .load_idx_i(ck_ldv ? ck_lidx : clr_idx),
    .load_w_i(ck_ldv ? ck_lw : 16'sd0),
    .phi_load_v_i(ck_pldv), .phi_idx_i(ck_pidx), .phi_w_i(ck_phi),
    .pend_load_v_i(ck_pendld),
    .pend_p0_i(ck_p0), .pend_p1_i(ck_p1), .pend_ans_i(ck_ans),
    .pend_sel_i(ck_sel), .pend_st_i(ck_st),
    .pend_txn_i(ck_txn), .pend_gen_i(ck_gen),
    .pend_acc_i(ck_pacc), .pend_cmt_i(ck_pcmt),
    .clr_pend_i(1'b0),
    .busy_o(c3_busy), .result_v_o(c3_res),
    .pend_acc_o(c3_pacc), .pend_cmt_o(c3_pcmt),
    .txn_id_o(c3_txn), .gen_o(c3_gen), .sel_idx_o(c3_sel),
    .ans_o(c3_ans), .proof0_o(c3_p0), .proof1_o(c3_p1),
    .n_path_o(c3_npath), .status_o(c3_st), .proof_ok_o(c3_pok),
    .direction_o(c3_dir),
    .obj_o(c3_obj), .ctx_o(c3_ctx),
    .subj_o(c3_subj), .n_host_winner_o(c3_nhw), .n_host_addr_o(c3_nha),
    .v_best_o(c3_vb), .v_second_o(c3_vs), .phi0_o(c3_phi0),
    .pend_phi_o(c3_pphi), .w_o(c3_w),
    .n_upd_o(c3_nupd), .n_dup_o(c3_ndup), .n_bad_o(c3_nbad),
    .load_from_tb_o(c3_tbl),
    .m_axi_arid(c3_arid), .m_axi_araddr(c3_ara), .m_axi_arlen(c3_arlen),
    .m_axi_arsize(c3_arsz), .m_axi_arburst(c3_arb),
    .m_axi_arvalid(c3_arv), .m_axi_arready(c3_arr),
    .m_axi_rid(c3_rid), .m_axi_rdata(c3_rdata), .m_axi_rresp(c3_rr),
    .m_axi_rlast(c3_rlast), .m_axi_rvalid(c3_rv), .m_axi_rready(c3_rrdy)
  );

  a7ng_astra_c5_sgd32_ckpt_pend u_ckpt (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_epoch_i),
    .go_persist_i(ck_go_p), .go_reload_i(ck_go_r),
    .retire_i(ck_ret), .clr_i(ck_clr),
    .w_i(c3_w), .phi_i(c3_pphi),
    .p0_i(c3_p0), .p1_i(c3_p1), .ans_i(c3_ans),
    .sel_i(c3_sel), .st_i(c3_st),
    .txn_i(c3_txn), .gen_i(c3_gen),
    .pend_acc_i(c3_pacc), .pend_cmt_i(c3_pcmt),
    .load_v_o(ck_ldv), .load_idx_o(ck_lidx), .load_w_o(ck_lw),
    .phi_load_v_o(ck_pldv), .phi_idx_o(ck_pidx), .phi_o(ck_phi),
    .pend_load_v_o(ck_pendld),
    .p0_o(ck_p0), .p1_o(ck_p1), .ans_o(ck_ans),
    .sel_o(ck_sel), .st_o(ck_st),
    .txn_o(ck_txn), .gen_o(ck_gen),
    .pend_acc_o(ck_pacc), .pend_cmt_o(ck_pcmt),
    .busy_o(ck_busy), .phase_o(ck_ph), .fail_o(ck_fail),
    .persisted_o(ck_pers), .restored_o(ck_rest),
    .seq_o(ck_seq), .crc_o(ck_crc),
    .m_axi_awid(p_awid), .m_axi_awaddr(p_awa), .m_axi_awlen(p_awlen),
    .m_axi_awsize(p_awsz), .m_axi_awburst(p_awb),
    .m_axi_awvalid(p_awv), .m_axi_awready(p_awr),
    .m_axi_wdata(p_wd), .m_axi_wstrb(p_wstrb), .m_axi_wlast(p_wl),
    .m_axi_wvalid(p_wv), .m_axi_wready(p_wr),
    .m_axi_bid(p_bid), .m_axi_bresp(p_br), .m_axi_bvalid(p_bv),
    .m_axi_bready(p_brdy),
    .m_axi_arid(p_arid), .m_axi_araddr(p_ara), .m_axi_arlen(p_arlen),
    .m_axi_arsize(p_arsz), .m_axi_arburst(p_arb),
    .m_axi_arvalid(p_arv), .m_axi_arready(p_arr),
    .m_axi_rid(p_rid), .m_axi_rdata(p_rd), .m_axi_rresp(p_rr),
    .m_axi_rlast(p_rl), .m_axi_rvalid(p_rv), .m_axi_rready(p_rrdy)
  );

  assign p_rv = ckpt_hv;

  a7ng_astra_c4_prod_wrap_v2 #(.ENT_W(20), .ALIAS_N(ALIAS_N)) u_c4 (
    .clk(clk), .rst_n(rst_n),
    .go_i(g_go), .retire_i(g_ret), .zero_w_i(1'b0),
    .c3_status_i(c3_st), .c3_npath_i(c3_npath), .c3_proof_ok_i(c3_pok),
    .direction_i(c3_dir), .bank_r_i(bank_r_i),
    .entity_src_i({12'd0, c3_subj}),
    .entity_dst_i(c3_ans),
    .alias_key_i(akey), .alias_sym_i(asym),
    .alias_valid_i(aval), .alias_ovf_i(aovf),
    .busy_o(g_busy), .done_o(g_done),
    .tok_valid_o(g_tv), .tok_o(g_tok), .eos_o(g_eos),
    .n_out_o(g_nout), .n_host_tok_o(g_nhost),
    .bank_r_o(g_bank), .vocab_ver_o(g_vver),
    .answer_allowed_o(allow), .mat_valid_o(mvalid), .mat_ovf_o(movf),
    .alias_ok_o(aok), .dir_known_o(dknown), .ctx_o(g_ctx)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ckpt_hv <= 1'b0;
      ckpt_hd <= 128'd0;
      ckpt_hr <= A7NG_C5P_OKAY;
      ckpt_hl <= 1'b0;
      ckpt_hid <= 4'd0;
    end else if (owner != A7NG_C5_CKPT) begin
      ckpt_hv <= 1'b0;
    end else if (ckpt_hv && p_rrdy) begin
      if (m_rvalid_i && arb_rready) begin
        ckpt_hd <= m_rdata_i;
        ckpt_hr <= m_rresp_i;
        ckpt_hl <= m_rlast_i;
        ckpt_hid <= m_rid_i;
        ckpt_hv <= 1'b1;
      end else ckpt_hv <= 1'b0;
    end else if (!ckpt_hv && m_rvalid_i && arb_rready) begin
      ckpt_hv <= 1'b1;
      ckpt_hd <= m_rdata_i;
      ckpt_hr <= m_rresp_i;
      ckpt_hl <= m_rlast_i;
      ckpt_hid <= m_rid_i;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      last_c3_rr <= A7NG_C5P_OKAY;
      last_br <= A7NG_C5P_OKAY;
      last_ck_rr <= A7NG_C5P_OKAY;
    end else begin
      if (c3_rv && c3_rrdy) last_c3_rr <= c3_rr;
      if (p_bv && p_brdy) last_br <= m_bresp_i;
      if (p_rv && p_rrdy) last_ck_rr <= p_rr;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (rj = 0; rj < ALIAS_N; rj = rj + 1) begin
        akey[rj] <= 20'd0;
        asym[rj] <= 32'd0;
        aval[rj] <= 1'b0;
        aovf[rj] <= 1'b0;
      end
    end else if (alias_wr_v_i) begin
      akey[alias_wr_idx_i] <= alias_wr_key_i;
      asym[alias_wr_idx_i] <= alias_wr_sym_i;
      aval[alias_wr_idx_i] <= 1'b1;
      aovf[alias_wr_idx_i] <= alias_wr_ovf_i;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pst <= ST_BOOT0;
      seen_gnt <= 6'd0;
      dual_sticky <= 1'b0;
      rwr <= 6'd0;
      rrd <= 6'd0;
      n_urx <= 16'd0;
      n_utx <= 16'd0;
      last_gen <= 8'd0;
      twr <= 4'd0;
      trd <= 4'd0;
      tcnt <= 4'd0;
      n_stream <= 16'd0;
      n_ovf <= 16'd0;
      parser_hit <= 1'b0;
      evid_has_q <= 1'b0;
      boot_cli <= A7NG_C5_IDX;
      boot_ara <= A7NG_C5_IDX_BASE;
      boot_arv <= 1'b0;
      boot_got <= 1'b0;
      c3_tok_v <= 1'b0;
      c3_tok <= 8'd0;
      c3_fire <= 1'b0;
      c3_retire <= 1'b0;
      c3_rew_v <= 1'b0;
      c3_rew <= 4'sd0;
      c3_rew_txn <= 8'd0;
      c3_rew_gen <= 8'd0;
      c3_ctrl <= 2'd0;
      ck_go_p <= 1'b0;
      ck_go_r <= 1'b0;
      ck_ret <= 1'b0;
      ck_clr <= 1'b0;
      clr_ld <= 1'b0;
      clr_idx <= 5'd0;
      clr_n <= 6'd0;
      flush_pend <= 1'b0;
      reload_pend <= 1'b0;
      waitc <= 16'd0;
      g_go <= 1'b0;
      g_ret <= 1'b0;
      tx_start <= 1'b0;
      tx_data <= 8'd0;
      last_aw <= 28'd0;
      ctl_line <= 1'b0;
      line_seen <= 1'b0;
      rew_act <= 1'b0;
      rew_n <= 4'd0;
      n_rew_ok <= 16'd0;
      n_rew_crc <= 16'd0;
      n_rew_sess <= 16'd0;
      n_rew_range <= 16'd0;
      n_rew_frz <= 16'd0;
      n_rew_len <= 16'd0;
      for (ri = 0; ri < 16; ri = ri + 1) rew_buf[ri] <= 8'd0;
      for (ri = 0; ri < 32; ri = ri + 1) rxf[ri] <= 8'd0;
      for (ri = 0; ri < 8; ri = ri + 1) tfifo[ri] <= 8'd0;
    end else begin
      c3_tok_v <= 1'b0;
      c3_fire <= 1'b0;
      c3_retire <= 1'b0;
      c3_rew_v <= 1'b0;
      ck_go_p <= 1'b0;
      ck_go_r <= 1'b0;
      ck_ret <= 1'b0;
      ck_clr <= 1'b0;
      clr_ld <= 1'b0;
      g_go <= 1'b0;
      g_ret <= 1'b0;
      tx_start <= 1'b0;
      seen_gnt <= seen_gnt | gnt;
      if (dual) dual_sticky <= 1'b1;
      if (m_awvalid_o && m_awready_i) last_aw <= m_awaddr_o;
      if (rx_valid && (rcnt < 6'd32)) begin
        rxf[rwr[4:0]] <= rx_data;
        rwr <= rwr + 6'd1;
        n_urx <= n_urx + 16'd1;
      end
      unique case (pst)
        ST_BOOT0, ST_BOOT1, ST_BOOT2: begin
          if (!boot_arv && !boot_got) boot_arv <= 1'b1;
          if (boot_arv && s_arr[boot_cli]) boot_arv <= 1'b0;
          if (s_rv[boot_cli]) boot_got <= 1'b1;
          if (boot_got) begin
            boot_got <= 1'b0;
            boot_arv <= 1'b0;
            if (pst == ST_BOOT0) begin
              boot_cli <= A7NG_C5_LRN;
              boot_ara <= A7NG_C5_IDX_BASE + 28'h30;
              pst <= ST_BOOT1;
            end else if (pst == ST_BOOT1) begin
              boot_cli <= A7NG_C5_LMD;
              boot_ara <= A7NG_C5_IDX_BASE + 28'h40;
              pst <= ST_BOOT2;
            end else pst <= ST_UART;
          end
        end
        ST_UART: begin
          if ((rcnt != 6'd0) && (rxf[rrd[4:0]] == A7NG_C5P_EOL)) begin
            rrd <= rrd + 6'd1;
            if (ctl_line && rew_act) begin
              rew_act <= 1'b0;
              rew_n <= 4'd0;
              ctl_line <= 1'b0;
              line_seen <= 1'b0;
              pst <= ST_DONE;
              begin : rew_parse
                logic [15:0] cgot, cexp;
                logic signed [7:0] sc;
                cexp = 16'hFFFF;
                cexp = crc16_byte(cexp, rew_buf[1]);
                cexp = crc16_byte(cexp, rew_buf[2]);
                cexp = crc16_byte(cexp, rew_buf[3]);
                cexp = crc16_byte(cexp, rew_buf[4]);
                cexp = crc16_byte(cexp, rew_buf[5]);
                cexp = crc16_byte(cexp, rew_buf[6]);
                cgot = {rew_buf[7], rew_buf[8]};
                sc = $signed(rew_buf[6]);
                if ((rew_n != 4'd9) || (rew_buf[0] != A7NG_C5P_REW_PLEN) ||
                    (rew_buf[1] != A7NG_C5P_REW_VER))
                  n_rew_len <= n_rew_len + 16'd1;
                else if ({rew_buf[2], rew_buf[3]} != live_epoch_i)
                  n_rew_sess <= n_rew_sess + 16'd1;
                else if (cexp != cgot)
                  n_rew_crc <= n_rew_crc + 16'd1;
                else if ((sc < -8'sd3) || (sc > 8'sd3))
                  n_rew_range <= n_rew_range + 16'd1;
                else if (c3_ctrl != 2'd0)
                  n_rew_frz <= n_rew_frz + 16'd1;
                else begin
                  c3_rew_txn <= rew_buf[4];
                  c3_rew_gen <= rew_buf[5];
                  c3_rew <= sc[3:0];
                  c3_rew_v <= 1'b1;
                  n_rew_ok <= n_rew_ok + 16'd1;
                  waitc <= 16'd0;
                  pst <= ST_WAITSGD;
                end
              end
            end else if (ctl_line) begin
              ctl_line <= 1'b0;
              line_seen <= 1'b0;
              if (flush_pend) begin
                flush_pend <= 1'b0;
                clr_n <= 6'd0;
                pst <= ST_CLR;
              end else if (reload_pend) begin
                reload_pend <= 1'b0;
                pst <= ST_RLPRE;
              end
            end else begin
              parser_hit <= 1'b1;
              c3_fire <= 1'b1;
              line_seen <= 1'b0;
              pst <= ST_WAITQ;
            end
          end else if ((rcnt != 6'd0) && rew_act &&
                       (rxf[rrd[4:0]] != A7NG_C5P_EOL)) begin
            if (rew_n < 4'd15) begin
              rew_buf[rew_n] <= rxf[rrd[4:0]];
              rew_n <= rew_n + 4'd1;
            end
            rrd <= rrd + 6'd1;
          end else if ((rcnt != 6'd0) && !line_seen &&
                       (rxf[rrd[4:0]] == A7NG_C5P_CMD_REWARD)) begin
            line_seen <= 1'b1;
            ctl_line <= 1'b1;
            rew_act <= 1'b1;
            rew_n <= 4'd0;
            rrd <= rrd + 6'd1;
          end else if ((rcnt != 6'd0) && !line_seen &&
                       ((rxf[rrd[4:0]] == A7NG_C5P_CMD_FLUSH) ||
                        (rxf[rrd[4:0]] == A7NG_C5P_CMD_RELOAD) ||
                        (rxf[rrd[4:0]] == A7NG_C5P_CMD_FREEZE) ||
                        (rxf[rrd[4:0]] == A7NG_C5P_CMD_LEARN))) begin
            line_seen <= 1'b1;
            ctl_line <= 1'b1;
            unique case (rxf[rrd[4:0]])
              A7NG_C5P_CMD_FLUSH:  flush_pend <= 1'b1;
              A7NG_C5P_CMD_RELOAD: reload_pend <= 1'b1;
              A7NG_C5P_CMD_FREEZE: c3_ctrl <= 2'd1;
              A7NG_C5P_CMD_LEARN:  c3_ctrl <= 2'd0;
              default: begin end
            endcase
            rrd <= rrd + 6'd1;
          end else if ((rcnt != 6'd0) && !rew_act &&
                       (rxf[rrd[4:0]] != A7NG_C5P_EOL) && c3_tok_r) begin
            line_seen <= 1'b1;
            c3_tok_v <= 1'b1;
            c3_tok <= rxf[rrd[4:0]];
            rrd <= rrd + 6'd1;
          end
        end
        ST_DRAIN: begin
          if (ck_rest || (ck_ph == A7NG_C5P_PH_FAILED) || (waitc >= 16'd4095))
            pst <= ST_DONE;
          else waitc <= waitc + 16'd1;
        end
        ST_WAITQ: begin
          if (c3_res) begin
            evid_has_q <= (c3_st == A7NG_C5P_ST_ANSWER) && c3_pok;
            twr <= 4'd0;
            trd <= 4'd0;
            tcnt <= 4'd0;
            n_stream <= 16'd0;
            pst <= ST_GEN;
          end
        end
        ST_WAITSGD: begin
          if (c3_pcmt) begin
            waitc <= 16'd0;
            pst <= ST_PERS;
          end else if (waitc >= 16'd1024)
            pst <= ST_DONE;
          else waitc <= waitc + 16'd1;
        end
        ST_PERS: begin
          if (ck_ph == A7NG_C5P_PH_FAILED)
            ck_ret <= 1'b1;
          else if ((owner == A7NG_C5_CKPT) && !ck_busy && (ck_ph == A7NG_C5P_PH_IDLE))
            ck_go_p <= 1'b1;
          if (ck_pers || (ck_ph == A7NG_C5P_PH_FAILED) || (waitc >= 16'd4095))
            pst <= ST_DONE;
          else waitc <= waitc + 16'd1;
        end
        ST_CLR: begin
          if (c3_busy) c3_retire <= 1'b1;
          else begin
            clr_ld <= 1'b1;
            clr_idx <= clr_n[4:0];
            if (clr_n == 6'd31) begin
              clr_n <= 6'd0;
              pst <= ST_DONE;
            end else clr_n <= clr_n + 6'd1;
          end
        end
        ST_RLPRE: begin
          if (c3_busy) c3_retire <= 1'b1;
          else if ((ck_ph == A7NG_C5P_PH_PERSISTED) ||
                   (ck_ph == A7NG_C5P_PH_READY) ||
                   (ck_ph == A7NG_C5P_PH_FAILED))
            ck_ret <= 1'b1;
          else if ((ck_ph == A7NG_C5P_PH_IDLE) && (owner == A7NG_C5_CKPT)) begin
            ck_go_r <= 1'b1;
            waitc <= 16'd0;
            pst <= ST_DRAIN;
          end
        end
        ST_GEN: begin
          if (!g_busy && !g_done) g_go <= 1'b1;
          if (g_tv) begin
            last_gen <= g_tok;
            if (tcnt != 4'd8) begin
              tfifo[twr[2:0]] <= g_tok;
              twr <= twr + 4'd1;
              tcnt <= tcnt + 4'd1;
            end else n_ovf <= n_ovf + 16'd1;
          end
          if (g_done) pst <= ST_TXNL;
        end
        ST_TXNL: begin
          if (!tx_busy && !tx_start) begin
            if (tcnt != 4'd0) begin
              tx_data <= tfifo[trd[2:0]];
              tx_start <= 1'b1;
              n_utx <= n_utx + 16'd1;
              n_stream <= n_stream + 16'd1;
              trd <= trd + 4'd1;
              tcnt <= tcnt - 4'd1;
            end else begin
              tx_data <= A7NG_C5P_EOL;
              tx_start <= 1'b1;
              n_utx <= n_utx + 16'd1;
              g_ret <= 1'b1;
              // Keep C3 S_HOLD pending until a later non-control UART line
              // (or FLUSH). Retiring here drops txn/gen before 0x16 reward.
              pst <= ST_DONE;
            end
          end
        end
        ST_DONE: begin
          if (rcnt != 6'd0) begin
            if ((rxf[rrd[4:0]] == A7NG_C5P_CMD_REWARD) ||
                (rxf[rrd[4:0]] == A7NG_C5P_CMD_FLUSH) ||
                (rxf[rrd[4:0]] == A7NG_C5P_CMD_RELOAD) ||
                (rxf[rrd[4:0]] == A7NG_C5P_CMD_FREEZE) ||
                (rxf[rrd[4:0]] == A7NG_C5P_CMD_LEARN))
              pst <= ST_UART;
            else begin
              if (c3_busy) c3_retire <= 1'b1;
              pst <= ST_UART;
            end
          end
        end
        default: pst <= ST_BOOT0;
      endcase
    end
  end
endmodule
