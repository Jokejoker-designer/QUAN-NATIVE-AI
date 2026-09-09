// a7ng_astra_c5_prod_top_c4p.sv — ASTRA-C5-PROD-TOP-C3PROOF-01.
// PROGRAM=NO. New named production hierarchy. Instantiates UART, live C3 wrap,
// C5 arb, C2 persist, BYTE256 ctxcopy. PROOF bytes from FPGA dict of C3 ans.
// Does not edit KEEP, live prod_top, C3 wrap, TinyGPT, compose, dict DUT, mig.prj.
// Does not stamp C5_MASTER or BOARD_PASS.
`timescale 1ns / 1ps
`include "a7ng_astra_c5_ddr_arb.svh"
`include "a7ng_astra_c5_prod_top.svh"
`include "a7ng_astra_c3_held_out.svh"
`include "a7ng_astra_c2_persist_commit.svh"
`include "a7ng_astra_c4_lm06_byte256_ctxcopy.svh"
`include "a7ng_astra_c4_lm06_byte256_c3proof.svh"

module a7ng_astra_c5_axi1b_c4p (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [3:0]  s_arid,
  input  logic [27:0] s_araddr,
  input  logic [7:0]  s_arlen,
  input  logic        s_arvalid,
  output logic        s_arready,
  output logic [3:0]  s_rid,
  output logic [127:0] s_rdata,
  output logic [1:0]  s_rresp,
  output logic        s_rlast,
  output logic        s_rvalid,
  input  logic        s_rready,
  output logic        req_o,
  output logic        arvalid_o,
  output logic [27:0] araddr_o,
  input  logic        arready_i,
  input  logic        rvalid_i,
  input  logic [127:0] rdata_i,
  output logic        rready_o,
  output logic [2:0]  cli_o
);
  typedef enum logic [1:0] { S_IDLE, S_AR, S_R, S_HOLD } st_t;
  st_t st;
  logic [27:0] addr;
  logic [7:0]  rem;
  logic [3:0]  id;
  logic [2:0]  cli;
  logic [127:0] bufd;
  logic last_q;
  logic mig_got;

  assign cli_o = cli;
  assign req_o = (st != S_IDLE);
  assign arvalid_o = (st == S_AR) && !mig_got;
  assign araddr_o = addr;
  assign s_arready = (st == S_AR) && mig_got;
  assign rready_o = (st == S_R) || ((st == S_AR) && !mig_got && rvalid_i);
  assign s_rid = id;
  assign s_rdata = bufd;
  assign s_rresp = 2'b00;
  assign s_rlast = last_q;
  assign s_rvalid = (st == S_HOLD);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      addr <= 28'd0;
      rem <= 8'd0;
      id <= 4'd0;
      cli <= A7NG_C5_QDIR;
      bufd <= 128'd0;
      last_q <= 1'b0;
      mig_got <= 1'b0;
    end else unique case (st)
      S_IDLE: begin
        mig_got <= 1'b0;
        if (s_arvalid) begin
          addr <= s_araddr;
          rem <= s_arlen;
          id <= s_arid;
          cli <= (s_araddr >= A7NG_C5P_FACT_BASE) ? A7NG_C5_DESC : A7NG_C5_QDIR;
          st <= S_AR;
        end
      end
      S_AR: begin
        if (!mig_got) begin
          if (arready_i) mig_got <= 1'b1;
        end else if (!s_arvalid) begin
          st <= S_R;
        end
      end
      S_R: begin
        if (rvalid_i) begin
          bufd <= rdata_i;
          last_q <= (rem == 8'd0);
          st <= S_HOLD;
        end
      end
      S_HOLD: begin
        if (s_rready) begin
          if (rem == 8'd0) st <= S_IDLE;
          else begin
            rem <= rem - 8'd1;
            addr <= addr + 28'd16;
            mig_got <= 1'b0;
            st <= S_AR;
          end
        end
      end
      default: st <= S_IDLE;
    endcase
  end
endmodule

module a7ng_astra_c5_prod_top_c4p (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [15:0] live_epoch_i,
  input  logic        uart_rx_i,
  output logic        uart_tx_o,
  output logic        m_arvalid_o,
  output logic [27:0] m_araddr_o,
  input  logic        m_arready_i,
  input  logic        m_rvalid_i,
  input  logic [127:0] m_rdata_i,
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
  output logic [7:0]  gen_tok0_o,
  output logic        parser_hit_o,
  output logic        evid_has_o,
  output logic [27:0] last_aw_o
);
  typedef enum logic [3:0] {
    ST_BOOT0, ST_BOOT1, ST_BOOT2, ST_WLOAD, ST_UART, ST_DRAIN, ST_WAITQ,
    ST_PERS, ST_GEN, ST_TXNL, ST_DONE
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

  logic rx_valid;
  logic [7:0] rx_data;
  logic tx_start, tx_busy, tx_line;
  logic [7:0] tx_data;

  logic c3_tok_v, c3_tok_r, c3_fire, c3_retire, c3_busy, c3_res;
  logic c3_pacc, c3_pcmt, c3_tbl, c3_rew_v;
  logic signed [3:0] c3_rew;
  logic [7:0] c3_tok, c3_txn, c3_gen, c3_obj, c3_ctx, c3_subj;
  logic [1:0] c3_sel;
  logic [19:0] c3_ans, c3_p0, c3_p1;
  logic [4:0] c3_npath;
  logic [3:0] c3_st;
  logic [15:0] c3_nhw, c3_nha, c3_nupd, c3_ndup, c3_nbad;
  logic signed [15:0] c3_vb, c3_vs, c3_w [0:31];
  logic signed [7:0] c3_phi0, c3_pphi [0:31];
  logic [3:0] c3_arid, c3_rid;
  logic [27:0] c3_ara;
  logic [7:0] c3_arlen;
  logic [2:0] c3_arsz;
  logic [1:0] c3_arb, c3_rr;
  logic c3_arv, c3_arr, c3_rlast, c3_rv, c3_rrdy;
  logic [127:0] c3_rdata;

  logic adp_req, adp_arv, adp_arr;
  logic [27:0] adp_ara;
  logic [2:0] adp_cli;
  logic adp_rready, arb_rready;

  logic p_clr, p_rel, p_ret, p_uv, p_ur, p_lk, p_hit, p_busy, p_pv;
  logic [3:0] p_ph, p_fc;
  logic [19:0] p_us, p_urx, p_uo, p_uc;
  logic [7:0] p_ug, p_ut, p_usch;
  logic signed [3:0] p_urew;
  logic signed [15:0] p_lw0, p_pw0;
  logic [19:0] p_ps, p_pr, p_po, p_pc;
  logic [7:0] p_pg, p_pt, p_psch;
  logic [15:0] p_nupd, p_ndup, p_nst, p_nsch, p_nf;
  logic [3:0] p_awid, p_arid, p_bid, p_rid;
  logic [27:0] p_awa, p_ara;
  logic [7:0] p_awlen, p_arlen;
  logic [2:0] p_awsz, p_arsz;
  logic [1:0] p_awb, p_arb, p_br, p_rr;
  logic p_awv, p_awr, p_wv, p_wr, p_wl, p_bv, p_brdy, p_arv, p_arr, p_rv, p_rl, p_rrdy;
  logic [127:0] p_wd, p_rd;
  logic ckpt_hv;
  logic [127:0] ckpt_hd;
  logic [15:0] p_wstrb;

  logic g_go, g_ret, g_ldv, g_busy, g_done, g_tv, g_eos, g_mask;
  logic [1:0] g_sel;
  logic [5:0] g_idx;
  logic signed [15:0] g_w;
  logic [7:0] g_obj, g_rel, g_tok, g_nout, g_pr0, g_pr1, g_pr2, g_tok0;
  logic g_has;
  logic [9:0] g_head;
  logic [15:0] g_nhost;

  logic [7:0] rxf [0:31];
  logic [5:0] rwr, rrd;
  logic [5:0] rcnt;
  logic [15:0] n_urx, n_utx;
  logic [7:0] last_gen;
  logic parser_hit, evid_has_q;
  logic [2:0] boot_cli;
  logic [27:0] boot_ara;
  logic boot_arv, boot_got;
  logic [2:0] wsel;
  logic nl_pend;
  logic [27:0] last_aw;
  logic [1:0] c3_ctrl;
  logic ctl_line, line_seen, rew_sent, reload_pend;
  integer ki;

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
  assign persist_valid_o = p_pv;
  assign persist_w0_o = p_pw0;
  assign persist_phase_o = p_ph;
  assign gen_done_o = g_done;
  assign gen_last_o = last_gen;
  assign gen_tok0_o = g_tok0;
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
  assign p_rr = 2'b00;
  assign p_rl = 1'b1;
  assign p_rid = 4'd2;
  assign p_bid = 4'd1;
  assign p_br = 2'b00;

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
    if ((pst == ST_PERS) || (pst == ST_DRAIN) || reload_pend || p_busy
        || p_arv || p_awv || p_wv) begin
      req[A7NG_C5_CKPT] = 1'b1;
      s_arv[A7NG_C5_CKPT] = p_arv;
      s_ara[A7NG_C5_CKPT] = p_ara;
    end
  end

  uart_rx #(.CLK_HZ(A7NG_C5P_CLK_HZ), .BAUD(A7NG_C5P_BAUD)) u_urx (
    .clk(clk), .rst_n(rst_n), .rx(uart_rx_i), .data(rx_data), .valid(rx_valid)
  );
  uart_tx #(.CLK_HZ(A7NG_C5P_CLK_HZ), .BAUD(A7NG_C5P_BAUD)) u_utx (
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

  a7ng_astra_c5_axi1b_c4p u_adp (
    .clk(clk), .rst_n(rst_n),
    .s_arid(c3_arid), .s_araddr(c3_ara), .s_arlen(c3_arlen),
    .s_arvalid(c3_arv), .s_arready(c3_arr),
    .s_rid(c3_rid), .s_rdata(c3_rdata), .s_rresp(c3_rr),
    .s_rlast(c3_rlast), .s_rvalid(c3_rv), .s_rready(c3_rrdy),
    .req_o(adp_req), .arvalid_o(adp_arv), .araddr_o(adp_ara),
    .arready_i(adp_arr), .rvalid_i(s_rv[adp_cli]), .rdata_i(s_rd),
    .rready_o(adp_rready), .cli_o(adp_cli)
  );

  a7ng_astra_c3_held_out u_c3 (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_epoch_i), .ctrl_i(c3_ctrl),
    .tok_valid_i(c3_tok_v), .tok_ready_o(c3_tok_r), .tok_i(c3_tok),
    .fire_i(c3_fire), .retire_i(c3_retire),
    .rew_v_i(c3_rew_v), .rew_i(c3_rew), .rew_txn_i(c3_txn), .rew_gen_i(c3_gen),
    .load_v_i(1'b0), .load_idx_i(5'd0), .load_w_i(16'sd0),
    .busy_o(c3_busy), .result_v_o(c3_res),
    .pend_acc_o(c3_pacc), .pend_cmt_o(c3_pcmt),
    .txn_id_o(c3_txn), .gen_o(c3_gen), .sel_idx_o(c3_sel),
    .ans_o(c3_ans), .proof0_o(c3_p0), .proof1_o(c3_p1),
    .n_path_o(c3_npath), .status_o(c3_st), .obj_o(c3_obj), .ctx_o(c3_ctx),
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

  a7ng_astra_c2_persist_commit u_c2 (
    .clk(clk), .rst_n(rst_n),
    .persist_clr_i(p_clr), .reload_i(p_rel), .retire_i(p_ret),
    .upd_valid_i(p_uv), .upd_ready_o(p_ur),
    .upd_subj_i(p_us), .upd_rel_i(p_urx), .upd_obj_i(p_uo), .upd_ctx_i(p_uc),
    .upd_gen_i(p_ug), .upd_txn_i(p_ut), .upd_schema_i(p_usch), .upd_rew_i(p_urew),
    .lk_go_i(p_lk), .lk_subj_i(20'd0), .lk_rel_i(20'd0), .lk_obj_i(20'd0), .lk_ctx_i(20'd0),
    .lk_hit_o(p_hit),
    .busy_o(p_busy), .phase_o(p_ph), .fail_code_o(p_fc),
    .live_w0_o(p_lw0),
    .persist_valid_o(p_pv),
    .persist_subj_o(p_ps), .persist_rel_o(p_pr), .persist_obj_o(p_po), .persist_ctx_o(p_pc),
    .persist_gen_o(p_pg), .persist_txn_o(p_pt), .persist_schema_o(p_psch),
    .persist_w0_o(p_pw0),
    .n_upd_o(p_nupd), .n_dup_o(p_ndup), .n_stale_o(p_nst), .n_schema_o(p_nsch),
    .n_false_o(p_nf),
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

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ckpt_hv <= 1'b0;
      ckpt_hd <= 128'd0;
    end else if (owner != A7NG_C5_CKPT) begin
      ckpt_hv <= 1'b0;
    end else if (ckpt_hv && p_rrdy) begin
      if (m_rvalid_i && arb_rready) begin
        ckpt_hd <= m_rdata_i;
        ckpt_hv <= 1'b1;
      end else ckpt_hv <= 1'b0;
    end else if (!ckpt_hv && m_rvalid_i && arb_rready) begin
      ckpt_hv <= 1'b1;
      ckpt_hd <= m_rdata_i;
    end
  end

  logic [7:0] g_mat_q0, g_mat_p0;
  logic [3:0] g_vver;

  a7ng_astra_c4_lm06_byte256_ctxcopy u_gen (
    .clk(clk), .rst_n(rst_n), .go_i(g_go), .retire_i(g_ret),
    .load_v_i(g_ldv), .load_sel_i(g_sel), .load_w_i(g_w),
    .proof0_i(g_pr0), .proof1_i(g_pr1), .proof2_i(g_pr2),
    .evid_has_i(g_has),
    .busy_o(g_busy), .done_o(g_done), .tok_valid_o(g_tv), .tok_o(g_tok), .eos_o(g_eos),
    .head10_o(g_head), .masked_hi_o(g_mask), .n_host_tok_o(g_nhost), .n_out_o(g_nout),
    .mat_q0_o(g_mat_q0), .mat_p0_o(g_mat_p0), .vocab_ver_o(g_vver)
  );

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
      g_tok0 <= 8'd0;
      g_pr0 <= 8'd0;
      g_pr1 <= 8'd0;
      g_pr2 <= 8'd0;
      parser_hit <= 1'b0;
      evid_has_q <= 1'b0;
      boot_cli <= A7NG_C5_IDX;
      boot_ara <= A7NG_C5_IDX_BASE;
      boot_arv <= 1'b0;
      boot_got <= 1'b0;
      wsel <= 3'd0;
      nl_pend <= 1'b0;
      c3_tok_v <= 1'b0;
      c3_tok <= 8'd0;
      c3_fire <= 1'b0;
      c3_retire <= 1'b0;
      c3_rew_v <= 1'b0;
      c3_rew <= 4'sd3;
      p_clr <= 1'b0;
      p_rel <= 1'b0;
      p_ret <= 1'b0;
      p_uv <= 1'b0;
      p_lk <= 1'b0;
      p_us <= 20'd0;
      p_urx <= 20'd0;
      p_uo <= 20'd0;
      p_uc <= 20'd0;
      p_ug <= 8'd0;
      p_ut <= 8'd0;
      p_usch <= A7NG_C2_SCHEMA_VER;
      p_urew <= 4'sd3;
      g_go <= 1'b0;
      g_ret <= 1'b0;
      g_ldv <= 1'b0;
      g_sel <= 2'd0;
      g_idx <= 6'd0;
      g_w <= 16'sd0;
      g_obj <= 8'd0;
      g_rel <= 8'd2;
      g_has <= 1'b0;
      tx_start <= 1'b0;
      tx_data <= 8'd0;
      last_aw <= 28'd0;
      c3_ctrl <= 2'd0;
      ctl_line <= 1'b0;
      line_seen <= 1'b0;
      rew_sent <= 1'b0;
      reload_pend <= 1'b0;
    end else begin
      c3_tok_v <= 1'b0;
      c3_fire <= 1'b0;
      c3_retire <= 1'b0;
      c3_rew_v <= 1'b0;
      p_clr <= 1'b0;
      p_rel <= 1'b0;
      p_uv <= 1'b0;
      p_ret <= 1'b0;
      g_go <= 1'b0;
      g_ret <= 1'b0;
      g_ldv <= 1'b0;
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
            end else pst <= ST_WLOAD;
          end
        end
        ST_WLOAD: begin
          g_ldv <= 1'b1;
          unique case (wsel)
            3'd0: begin g_sel <= A7NG_C4X_LD_COPY; g_w <= 16'sd50; end
            3'd1: begin g_sel <= A7NG_C4X_LD_SAFE;  g_w <= 16'sd80; end
            default: begin g_sel <= A7NG_C4X_LD_EOS; g_w <= 16'sd200; end
          endcase
          if (wsel == 3'd2) pst <= ST_UART;
          else wsel <= wsel + 3'd1;
        end
        ST_UART: begin
          if ((rcnt != 6'd0) && (rxf[rrd[4:0]] == A7NG_C5P_EOL)) begin
            rrd <= rrd + 6'd1;
            if (ctl_line) begin
              ctl_line <= 1'b0;
              line_seen <= 1'b0;
              if (reload_pend) begin
                reload_pend <= 1'b0;
                pst <= ST_DRAIN;
              end
            end else begin
              parser_hit <= 1'b1;
              c3_fire <= 1'b1;
              line_seen <= 1'b0;
              pst <= ST_WAITQ;
            end
          end else if ((rcnt != 6'd0) && !line_seen &&
                       ((rxf[rrd[4:0]] == A7NG_C5P_CMD_FLUSH) ||
                        (rxf[rrd[4:0]] == A7NG_C5P_CMD_RELOAD) ||
                        (rxf[rrd[4:0]] == A7NG_C5P_CMD_FREEZE) ||
                        (rxf[rrd[4:0]] == A7NG_C5P_CMD_LEARN))) begin
            line_seen <= 1'b1;
            ctl_line <= 1'b1;
            unique case (rxf[rrd[4:0]])
              A7NG_C5P_CMD_FLUSH:  p_clr <= 1'b1;
              A7NG_C5P_CMD_RELOAD: begin p_rel <= 1'b1; reload_pend <= 1'b1; end
              A7NG_C5P_CMD_FREEZE: c3_ctrl <= 2'd1;
              A7NG_C5P_CMD_LEARN:  c3_ctrl <= 2'd0;
              default: begin end
            endcase
            rrd <= rrd + 6'd1;
          end else if ((rcnt != 6'd0) && (rxf[rrd[4:0]] != A7NG_C5P_EOL) && c3_tok_r) begin
            line_seen <= 1'b1;
            c3_tok_v <= 1'b1;
            c3_tok <= rxf[rrd[4:0]];
            rrd <= rrd + 6'd1;
          end
        end
        ST_DRAIN: begin
          if ((p_ph == A7NG_C2_PH_PERSISTED) || (p_ph == A7NG_C2_PH_FAILED)) begin
            p_ret <= 1'b1;
            pst <= ST_UART;
          end
        end
        ST_WAITQ: begin
          if (c3_res || rew_sent) begin
            if ((c3_st == A7NG_C5P_ST_ANSWER) && (c3_ctrl == 2'd0)) begin
              if (!rew_sent) begin
                evid_has_q <= 1'b1;
                g_obj <= c3_ans[7:0];
                g_rel <= 8'd2;
                g_has <= 1'b1;
                g_pr0 <= a7ng_c4p_ch(c3_ans[7:0], 0);
                g_pr1 <= a7ng_c4p_ch(c3_ans[7:0], 1);
                g_pr2 <= a7ng_c4p_ch(c3_ans[7:0], 2);
                p_us <= {12'd0, c3_subj};
                p_urx <= 20'd2;
                p_uo <= {12'd0, c3_obj};
                p_uc <= {12'd0, c3_ctx};
                p_ug <= c3_gen;
                p_ut <= c3_txn;
                c3_rew_v <= 1'b1;
                rew_sent <= 1'b1;
              end else if (c3_pcmt) begin
                rew_sent <= 1'b0;
                pst <= ST_PERS;
              end
            end else if ((c3_st == A7NG_C5P_ST_ANSWER) && (c3_ctrl != 2'd0)) begin
              if (!rew_sent) begin
                c3_rew_v <= 1'b1;
                rew_sent <= 1'b1;
                evid_has_q <= 1'b1;
                g_obj <= c3_ans[7:0];
                g_rel <= 8'd2;
                g_has <= 1'b1;
                g_pr0 <= a7ng_c4p_ch(c3_ans[7:0], 0);
                g_pr1 <= a7ng_c4p_ch(c3_ans[7:0], 1);
                g_pr2 <= a7ng_c4p_ch(c3_ans[7:0], 2);
              end else begin
                rew_sent <= 1'b0;
                last_gen <= {4'd0, c3_st};
                nl_pend <= 1'b1;
                pst <= ST_TXNL;
              end
            end else begin
              rew_sent <= 1'b0;
              evid_has_q <= 1'b0;
              g_has <= 1'b0;
              last_gen <= {4'd0, c3_st};
              nl_pend <= 1'b1;
              pst <= ST_TXNL;
            end
          end
        end
        ST_PERS: begin
          if ((owner == A7NG_C5_CKPT) && p_ur && !p_busy && (p_ph == A7NG_C2_PH_IDLE))
            p_uv <= 1'b1;
          if ((p_ph == A7NG_C2_PH_PERSISTED) || (p_ph == A7NG_C2_PH_FAILED) || (p_pv === 1'b1))
            pst <= ST_GEN;
        end
        ST_GEN: begin
          if (!g_busy && !g_done) g_go <= 1'b1;
          if (g_tv) begin
            last_gen <= g_tok;
            if (g_tok0 == 8'd0) g_tok0 <= g_tok;
          end
          if (g_done) begin
            nl_pend <= 1'b1;
            pst <= ST_TXNL;
          end
        end
        ST_TXNL: begin
          if (g_tv) begin
            last_gen <= g_tok;
            if (g_tok0 == 8'd0) g_tok0 <= g_tok;
          end
          if (!tx_busy && !tx_start) begin
            if (nl_pend) begin
              tx_data <= last_gen;
              tx_start <= 1'b1;
              n_utx <= n_utx + 16'd1;
              nl_pend <= 1'b0;
            end else begin
              tx_data <= A7NG_C5P_EOL;
              tx_start <= 1'b1;
              n_utx <= n_utx + 16'd1;
              c3_retire <= 1'b1;
              p_ret <= 1'b1;
              g_ret <= 1'b1;
              pst <= ST_DONE;
            end
          end
        end
        ST_DONE: begin
          if (rcnt != 6'd0) pst <= ST_UART;
        end
        default: pst <= ST_BOOT0;
      endcase
    end
  end
endmodule
