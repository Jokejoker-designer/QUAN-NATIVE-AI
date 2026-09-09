// a7ng_astra_09_r2_cand_ovf.sv — ASTRA-09-R2-CAND-OVF-01. PROGRAM=NO.
// New named A09 revision. Does not patch frozen a7ng_astra_09_integ_path.sv.
// Instantiates frozen a7ng_shared_rank_sgd_q8_sym_f2r2. Not a wrap around leftover ans=4.
// ntrunc / q_overflow → DUT itself ST_INCOMP ans=0 p0=0. load_from_tb=0.
`timescale 1ns / 1ps
`include "a7ng_astra_09_integ_path.svh"
`include "a7ng_astra_09_r2_cand_ovf.svh"

module a7ng_astra_09_r2_cand_ovf #(
  parameter int unsigned ID_W       = 20,
  parameter int unsigned CAND_CAP   = A7NG_A09R2_CAND_CAP,
  parameter int unsigned TO_CYC     = A7NG_A09_TO_CYC,
  parameter int unsigned DRAIN_TO   = A7NG_A09_DRAIN_TO,
  parameter int unsigned MAX_PATH   = A7NG_A09R2_MAX_PATH,
  parameter logic [7:0]  TXN_MAX    = A7NG_A09_TXN_MAX,
  parameter logic [27:0] INDEX_BASE = 28'h0500_0000,
  parameter logic [27:0] FACT_BASE  = 28'h0580_0000
) (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [15:0] live_epoch_i,
  input  logic [15:0] sess_id_i,
  input  logic [1:0]  ctrl_i,
  input  logic        tok_valid_i,
  output logic        tok_ready_o,
  input  logic [7:0]  tok_i,
  input  logic        fire_i,
  input  logic        retire_i,
  input  logic        rew_v_i,
  input  logic signed [3:0] rew_i,
  input  logic [7:0]  rew_txn_i,
  input  logic [7:0]  rew_gen_i,
  input  logic [15:0] rew_epoch_i,
  input  logic        load_v_i,
  input  logic [4:0]  load_idx_i,
  input  logic signed [15:0] load_w_i,
  output logic        busy_o,
  output logic        result_v_o,
  output logic        pend_acc_o,
  output logic        pend_cmt_o,
  output logic [7:0]  txn_id_o,
  output logic [7:0]  gen_o,
  output logic [15:0] epoch_o,
  output logic [1:0]  sel_idx_o,
  output logic [ID_W-1:0] ans_o,
  output logic [ID_W-1:0] proof0_o,
  output logic [ID_W-1:0] proof1_o,
  output logic [4:0]  n_path_o,
  output logic [3:0]  status_o,
  output logic [7:0]  obj_o,
  output logic [7:0]  ctx_o,
  output logic signed [15:0] v_best_o,
  output logic signed [15:0] v_second_o,
  output logic signed [15:0] v_pred_o,
  output logic signed [7:0]  phi0_o,
  output logic signed [7:0]  pend_phi_o [0:31],
  output logic signed [15:0] w_o [0:31],
  output logic [15:0] n_upd_o,
  output logic [15:0] n_dup_o,
  output logic [15:0] n_bad_o,
  output logic [15:0] n_stale_o,
  output logic [15:0] n_oor_o,
  output logic [15:0] n_exh_o,
  output logic        txn_exh_o,
  output logic        load_from_tb_o,
  output logic [3:0]  m_axi_arid,
  output logic [27:0] m_axi_araddr,
  output logic [7:0]  m_axi_arlen,
  output logic [2:0]  m_axi_arsize,
  output logic [1:0]  m_axi_arburst,
  output logic        m_axi_arvalid,
  input  logic        m_axi_arready,
  input  logic [3:0]  m_axi_rid,
  input  logic [127:0] m_axi_rdata,
  input  logic [1:0]  m_axi_rresp,
  input  logic        m_axi_rlast,
  input  logic        m_axi_rvalid,
  output logic        m_axi_rready,
  output logic [15:0] n_ar_to_o,
  output logic [15:0] n_r_to_o,
  output logic [15:0] n_axi_err_o,
  output logic [15:0] n_drain_o,
  output logic [15:0] n_abandon_o,
  output logic        axi_ost_o,
  output logic        axi_abort_o,
  output logic [3:0]  ost_rid_o,
  output logic [15:0] dead_mask_o,
  output logic [15:0] n_trunc_o,
  output logic        r_ovf_o,
  output logic        w_ovf_o
);
  localparam logic [3:0] VER = 4'd1;
  localparam logic [3:0] ST_UNKNOWN = 4'd1, ST_CONFLICT = 4'd5, ST_INCOMP = 4'd6, ST_AMB = 4'd7, ST_NEG = 4'd8;
  localparam logic [7:0] CTX_INDIRECT = 8'd2;

  typedef enum logic [3:0] {
    S_IDLE, S_WALK, S_AR, S_R, S_DRAIN, S_ABORT,
    S_EI, S_EJ, S_ED, S_GUARD, S_SC, S_SW, S_PICK, S_HOLD, S_UW
  } st_t;
  st_t st;

  logic qse_tok_v, qse_tok_r, qse_fire, qse_retire, qse_valid, qse_busy, qse_acc;
  logic [7:0] qse_subj, qse_obj, qse_rel, qse_ctx;
  logic [1:0] qse_dir, qse_nhyp;
  logic qse_neg, qse_amb, qse_trip, qse_v0, qse_v1, qse_v2, qse_v3;
  logic [15:0] qse_k0, qse_k1, qse_k2, qse_k3, qse_nhost;
  logic [15:0] h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10;
  logic walk_ready, cand_v, cand_ready, w_done, w_ovf;
  logic [19:0] cand_id, cbuf [0:15];
  logic [15:0] w_emit, w_dup, w_trunc, w_ndir, w_npost;
  logic [3:0] w_pmask;
  logic [3:0] sp_arid; logic [27:0] sp_araddr; logic [7:0] sp_arlen;
  logic [2:0] sp_arsize; logic [1:0] sp_arburst;
  logic sp_arvalid, sp_arready, sp_rready, sp_rlast, sp_rvalid;
  logic [3:0] sp_rid; logic [127:0] sp_rdata; logic [1:0] sp_rresp;
  logic fetch_mode, f_arvalid, f_arready, f_rvalid, kill_r, fact_take;
  logic [27:0] f_araddr;
  logic [3:0]  f_arid, ost_rid;
  logic        axi_ost, axi_abort;
  logic [15:0] dead_mask, ndrain, naban;
  logic [4:0] nc, fi, nf, ei, ej, np, pi, n_legal;
  logic [19:0] fs [0:15], fo [0:15], fe [0:15];
  logic [7:0]  fr [0:15], fcf [0:15], fcx [0:15];
  logic        ft [0:15], fpv [0:15], fv [0:15];
  logic [19:0] pp0 [0:3], pp1 [0:3], pans [0:3];
  logic [7:0]  pc1 [0:3], pc2 [0:3];
  logic        pt1 [0:3], pt2 [0:3], pp1v [0:3], pp2v [0:3];
  logic signed [15:0] pv [0:3];
  logic signed [7:0]  phis [0:3][0:31];
  logic signed [7:0]  phi [0:31], pend_phi [0:31];
  logic [7:0] r_subj, r_obj, r_rel, r_ctx;
  logic r_ovf, r_neg, r_amb, r_axi, r_two, r_obj_v, r_dom, r_conf, have_pos, have_neg;
  logic [19:0] concl0, neg0;
  logic [3:0] r_st;
  logic [15:0] nfar, nfok, nferr, nfto, narto, tocnt, nupd, ndup, nbad, nstale, noor;
  logic signed [15:0] sgd_v, v_best, v_second, v_pred;
  logic sgd_ready, sgd_done, sgd_go, sgd_upd;
  logic signed [3:0] rew_lat;
  logic [7:0] txn, pend_id, gen, pend_gen;
  logic [15:0] pend_epoch, sess_epoch, nexh;
  logic pend_acc, pend_cmt, retire_hold, freeze_q, txn_exh;
  logic [1:0] sel_idx, c_best_idx;
  logic [19:0] best_a, best_p0, best_p1, c_best_a, c_best_p0, c_best_p1;
  logic signed [15:0] c_best_v, c_second_v;
  integer k, kf;
  logic walk_ovf;

  assign load_from_tb_o = 1'b0;
  assign walk_ovf = w_ovf || (w_trunc != 16'd0);
  assign n_trunc_o = w_trunc;
  assign r_ovf_o = r_ovf;
  assign w_ovf_o = w_ovf;
  assign fetch_mode = (st==S_AR)||(st==S_R)||(st==S_DRAIN);
  assign kill_r = m_axi_rvalid && dead_mask[m_axi_rid];
  assign fact_take = (st==S_R)||(st==S_DRAIN);
  assign m_axi_arid = fetch_mode ? f_arid : sp_arid;
  assign m_axi_araddr = fetch_mode ? f_araddr : sp_araddr;
  assign m_axi_arlen = fetch_mode ? 8'd0 : sp_arlen;
  assign m_axi_arsize = fetch_mode ? 3'd4 : sp_arsize;
  assign m_axi_arburst = fetch_mode ? 2'b01 : sp_arburst;
  assign m_axi_arvalid = fetch_mode ? f_arvalid : sp_arvalid;
  assign sp_arready = fetch_mode ? 1'b0 : m_axi_arready;
  assign f_arready = (st==S_AR) ? m_axi_arready : 1'b0;
  assign sp_rid = m_axi_rid;
  assign sp_rdata = m_axi_rdata;
  assign sp_rresp = m_axi_rresp;
  assign sp_rlast = m_axi_rlast;
  assign sp_rvalid = (!fetch_mode && !kill_r) ? m_axi_rvalid : 1'b0;
  assign f_rvalid = (st==S_R && !kill_r) ? m_axi_rvalid : 1'b0;
  assign m_axi_rready = (fact_take || kill_r) ? 1'b1 : (fetch_mode ? 1'b0 : sp_rready);
  assign qse_tok_v = tok_valid_i && (st==S_IDLE);
  assign qse_fire = fire_i && (st==S_IDLE);
  assign tok_ready_o = qse_tok_r && (st==S_IDLE);
  assign cand_ready = (st==S_WALK);
  assign busy_o = (st!=S_IDLE);
  assign result_v_o = (st==S_HOLD);
  assign pend_acc_o = pend_acc;
  assign pend_cmt_o = pend_cmt;
  assign txn_id_o = pend_id;
  assign gen_o = pend_gen;
  assign epoch_o = pend_epoch;
  assign n_exh_o = nexh;
  assign txn_exh_o = txn_exh;
  assign sel_idx_o = sel_idx;
  assign ans_o = best_a;
  assign proof0_o = best_p0;
  assign proof1_o = best_p1;
  assign n_path_o = n_legal;
  assign status_o = r_st;
  assign obj_o = r_obj;
  assign ctx_o = r_ctx;
  assign v_best_o = v_best;
  assign v_second_o = v_second;
  assign v_pred_o = v_pred;
  assign phi0_o = pend_phi[0];
  assign n_upd_o = nupd;
  assign n_dup_o = ndup;
  assign n_bad_o = nbad;
  assign n_stale_o = nstale;
  assign n_oor_o = noor;
  assign n_ar_to_o = narto;
  assign n_r_to_o = nfto;
  assign n_axi_err_o = nferr;
  assign n_drain_o = ndrain;
  assign n_abandon_o = naban;
  assign axi_ost_o = axi_ost;
  assign axi_abort_o = axi_abort;
  assign ost_rid_o = ost_rid;
  assign dead_mask_o = dead_mask;
  assign freeze_q = (ctrl_i != 2'd0);

  function automatic logic [3:0] next_fact_arid(input logic [15:0] dead);
    integer i;
    begin
      next_fact_arid = A7NG_A09_FACT_RID0;
      for (i = 15; i >= 2; i = i - 1)
        if (!dead[i]) next_fact_arid = i[3:0];
    end
  endfunction

  genvar gi;
  generate for (gi = 0; gi < 32; gi = gi + 1) begin : g_ph
    assign pend_phi_o[gi] = pend_phi[gi];
  end endgenerate

  function automatic logic signed [7:0] qphi0(input logic [7:0] c1, input logic [7:0] c2);
    logic [7:0] m;
    begin
      m = (c1 < c2) ? c1 : c2;
      qphi0 = m[7:2];
    end
  endfunction

  always_comb begin
    for (k = 0; k < 32; k = k + 1) phi[k] = 8'sd0;
    if (st==S_SC || st==S_SW) begin
      phi[0] = qphi0(pc1[pi[1:0]], pc2[pi[1:0]]);
      phi[1] = (pt1[pi[1:0]] && pt2[pi[1:0]]) ? 8'sd64 : 8'sd0;
      phi[2] = (pp1v[pi[1:0]] && pp2v[pi[1:0]]) ? 8'sd64 : 8'sd0;
      phi[3] = 8'sd64;
      phi[4] = 8'sd64;
    end else begin
      for (k = 0; k < 32; k = k + 1) phi[k] = pend_phi[k];
    end
    c_best_v = 16'sh8000; c_second_v = 16'sh8000;
    c_best_a = '0; c_best_p0 = 20'hFFFFF; c_best_p1 = 20'hFFFFF; c_best_idx = 2'd0;
    for (k = 0; k < 4; k = k + 1) begin
      if (k < np) begin
        if ((pv[k] > c_best_v)
            || ((pv[k]==c_best_v) && (pp0[k] < c_best_p0))
            || ((pv[k]==c_best_v) && (pp0[k]==c_best_p0) && (pp1[k] < c_best_p1))) begin
          c_second_v = c_best_v;
          c_best_v = pv[k];
          c_best_a = pans[k];
          c_best_p0 = pp0[k];
          c_best_p1 = pp1[k];
          c_best_idx = k[1:0];
        end else if (pv[k] >= c_second_v) begin
          c_second_v = pv[k];
        end
      end
    end
  end

  a7ng_query_axi_sparse #(
    .N_TABLES(4), .N_BUCKETS(4096), .CAND_CAP(CAND_CAP),
    .ID_W(20), .INDEX_BASE(INDEX_BASE), .LAW_SEL(1)
  ) u_sp (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_epoch_i),
    .tok_valid_i(qse_tok_v), .tok_ready_o(qse_tok_r), .tok_i(tok_i),
    .fire_i(qse_fire), .retire_i(qse_retire),
    .poke_v_i(1'b0),
    .poke_k0_i(16'd0), .poke_k1_i(16'd0), .poke_k2_i(16'd0), .poke_k3_i(16'd0),
    .poke_v0_i(1'b0), .poke_v1_i(1'b0), .poke_v2_i(1'b0), .poke_v3_i(1'b0),
    .qse_valid_o(qse_valid), .qse_busy_o(qse_busy), .qse_accepted_o(qse_acc),
    .entity_id_o(qse_subj), .intent_id_o(qse_obj),
    .relation_id_o(qse_rel), .context_id_o(qse_ctx),
    .k0_o(qse_k0), .k1_o(qse_k1), .k2_o(qse_k2), .k3_o(qse_k3),
    .k0_valid_o(qse_v0), .k1_valid_o(qse_v1), .k2_valid_o(qse_v2), .k3_valid_o(qse_v3),
    .direction_o(qse_dir), .negation_o(qse_neg), .ambiguity_o(qse_amb),
    .triple_valid_o(qse_trip), .n_hyp_o(qse_nhyp), .n_host_any_o(qse_nhost),
    .n_host_entity_o(h0), .n_host_intent_o(h1), .n_host_hash_o(h2),
    .n_host_shard_o(h3), .n_host_bucket_o(h4), .n_host_cand_o(h5),
    .n_host_winner_o(h6), .n_host_addr_o(h7), .n_host_relpath_o(h8),
    .n_host_next_o(h9), .n_host_answer_o(h10),
    .walk_ready_o(walk_ready),
    .cand_v(cand_v), .cand_ready(cand_ready), .cand_id(cand_id),
    .q_done(w_done), .q_overflow_o(w_ovf),
    .n_emit_o(w_emit), .n_dup_o(w_dup), .n_trunc_o(w_trunc),
    .n_dir_ar_o(w_ndir), .n_post_ar_o(w_npost), .probed_mask_o(w_pmask),
    .m_axi_arid(sp_arid), .m_axi_araddr(sp_araddr), .m_axi_arlen(sp_arlen),
    .m_axi_arsize(sp_arsize), .m_axi_arburst(sp_arburst),
    .m_axi_arvalid(sp_arvalid), .m_axi_arready(sp_arready),
    .m_axi_rid(sp_rid), .m_axi_rdata(sp_rdata), .m_axi_rresp(sp_rresp),
    .m_axi_rlast(sp_rlast), .m_axi_rvalid(sp_rvalid), .m_axi_rready(sp_rready)
  );

  a7ng_shared_rank_sgd_q8_sym_f2r2 u_sgd (
    .clk(clk), .rst_n(rst_n), .freeze_i(1'b0),
    .go_score_i(sgd_go), .go_upd_i(sgd_upd), .x_i(phi), .reward_i(rew_lat),
    .load_v_i(load_v_i && (st==S_IDLE)), .load_idx_i(load_idx_i), .load_w_i(load_w_i),
    .w_o(w_o), .ready_o(sgd_ready), .done_o(sgd_done), .v_q8_o(sgd_v)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE; qse_retire <= 1'b0; sgd_go <= 1'b0; sgd_upd <= 1'b0;
      f_arvalid <= 1'b0; f_araddr <= '0; f_arid <= A7NG_A09_FACT_RID0;
      axi_ost <= 1'b0; axi_abort <= 1'b0; ost_rid <= A7NG_A09_FACT_RID0;
      dead_mask <= 16'd0; ndrain <= '0; naban <= '0;
      nc <= '0; fi <= '0; nf <= '0; ei <= '0; ej <= '0; np <= '0; pi <= '0; n_legal <= '0;
      nfar <= '0; nfok <= '0; nferr <= '0; nfto <= '0; narto <= '0; tocnt <= '0;
      nupd <= '0; ndup <= '0; nbad <= '0; nstale <= '0; noor <= '0;
      r_subj <= '0; r_obj <= '0; r_rel <= '0; r_ctx <= '0;
      r_ovf <= 1'b0; r_neg <= 1'b0; r_amb <= 1'b0; r_axi <= 1'b0;
      r_two <= 1'b0; r_obj_v <= 1'b0; r_dom <= 1'b0; r_conf <= 1'b0;
      have_pos <= 1'b0; have_neg <= 1'b0; concl0 <= '0; neg0 <= '0;
      r_st <= ST_UNKNOWN;
      txn <= 8'd0; pend_id <= 8'd0; gen <= 8'd0; pend_gen <= 8'd0;
      pend_epoch <= A7NG_A09_EPOCH_INV; sess_epoch <= A7NG_A09_EPOCH_INV;
      nexh <= '0; txn_exh <= 1'b0;
      pend_acc <= 1'b0; pend_cmt <= 1'b0; retire_hold <= 1'b0; rew_lat <= '0;
      sel_idx <= '0; best_a <= '0; best_p0 <= '0; best_p1 <= '0;
      v_best <= '0; v_second <= '0; v_pred <= '0;
      for (kf = 0; kf < 32; kf = kf + 1) pend_phi[kf] <= '0;
    end else begin
      qse_retire <= 1'b0; sgd_go <= 1'b0; sgd_upd <= 1'b0;
      if (m_axi_rvalid && m_axi_rready && dead_mask[m_axi_rid]) begin
        ndrain <= ndrain + 16'd1;
        if (m_axi_rlast) dead_mask[m_axi_rid] <= 1'b0;
      end
      unique case (st)
        S_IDLE: begin
          nc <= '0; fi <= '0; nf <= '0; np <= '0; n_legal <= '0; r_axi <= 1'b0; tocnt <= '0;
          retire_hold <= 1'b0; r_conf <= 1'b0; have_pos <= 1'b0; have_neg <= 1'b0;
          f_arvalid <= 1'b0; axi_abort <= 1'b0; axi_ost <= 1'b0;
          for (kf = 0; kf < 16; kf = kf + 1) fv[kf] <= 1'b0;
          best_a <= '0; best_p0 <= '0; best_p1 <= '0; v_best <= '0; v_second <= '0;
          r_st <= ST_UNKNOWN;
          if (qse_valid) begin
            r_subj <= qse_subj; r_obj <= qse_obj; r_rel <= qse_rel; r_ctx <= qse_ctx;
            r_two <= (qse_ctx == CTX_INDIRECT);
            r_obj_v <= (qse_obj != 8'd0);
            r_dom <= (qse_ctx != 8'd0) && (qse_ctx != CTX_INDIRECT);
            r_neg <= qse_neg; r_amb <= qse_amb; r_ovf <= 1'b0;
            st <= S_WALK;
          end
        end
        S_WALK: begin
          if (cand_v && cand_ready && (nc < 5'd16)) begin
            cbuf[nc[3:0]] <= cand_id; nc <= nc + 1'b1;
          end
          if (w_done) begin
            r_ovf <= walk_ovf; qse_retire <= 1'b1; fi <= '0;
            if (r_amb) begin r_st <= ST_AMB; st <= S_HOLD; end
            else if (r_neg) begin r_st <= ST_NEG; st <= S_HOLD; end
            else if (walk_ovf) begin
              r_st <= ST_INCOMP;
              best_a <= '0; best_p0 <= '0; best_p1 <= '0; sel_idx <= '0;
              pend_acc <= 1'b0; pend_cmt <= 1'b0;
              np <= '0; n_legal <= '0;
              st <= S_HOLD;
            end
            else st <= (nc==0) ? S_HOLD : S_AR;
          end
        end
        S_AR: begin
          f_araddr <= FACT_BASE + {cbuf[fi[3:0]], 4'd0};
          if (!f_arvalid) f_arid <= next_fact_arid(dead_mask);
          f_arvalid <= 1'b1;
          tocnt <= tocnt + 16'd1;
          if (f_arready && f_arvalid) begin
            f_arvalid <= 1'b0; nfar <= nfar + 16'd1; tocnt <= '0;
            axi_ost <= 1'b1; ost_rid <= f_arid; st <= S_R;
          end else if (tocnt >= TO_CYC[15:0]) begin
            f_arvalid <= 1'b0; narto <= narto + 16'd1; r_axi <= 1'b1;
            axi_abort <= 1'b1; tocnt <= '0; st <= S_ABORT;
          end
        end
        S_R: begin
          tocnt <= tocnt + 16'd1;
          if (kill_r) begin
          end else if (f_rvalid) begin
            if (m_axi_rid == ost_rid) begin
              if (m_axi_rresp != A7NG_A09_RRESP_OK) begin
                nferr <= nferr + 16'd1; r_axi <= 1'b1; axi_abort <= 1'b1; tocnt <= '0;
                if (m_axi_rlast) begin axi_ost <= 1'b0; st <= S_ABORT; end
                else st <= S_DRAIN;
              end else if (!m_axi_rlast) begin
                nferr <= nferr + 16'd1; r_axi <= 1'b1; axi_abort <= 1'b1;
                tocnt <= '0; st <= S_DRAIN;
              end else if ((m_axi_rdata[75:72]==VER)&&m_axi_rdata[70]
                  && (m_axi_rdata[67:48]==cbuf[fi[3:0]]) && (nf<5'd16) && !axi_abort) begin
                fs[nf[3:0]] <= m_axi_rdata[19:0];
                fo[nf[3:0]] <= m_axi_rdata[39:20];
                fr[nf[3:0]] <= m_axi_rdata[47:40];
                fe[nf[3:0]] <= m_axi_rdata[67:48];
                ft[nf[3:0]] <= m_axi_rdata[68];
                fpv[nf[3:0]] <= m_axi_rdata[69];
                fcx[nf[3:0]] <= m_axi_rdata[83:76];
                fcf[nf[3:0]] <= m_axi_rdata[91:84];
                fv[nf[3:0]] <= 1'b1;
                nf <= nf + 1'b1; nfok <= nfok + 16'd1;
                axi_ost <= 1'b0; tocnt <= '0;
                if (fi + 1'b1 == nc) begin ei <= '0; st <= S_EI; end
                else begin fi <= fi + 1'b1; st <= S_AR; end
              end else begin
                nferr <= nferr + 16'd1; r_axi <= 1'b1; axi_abort <= 1'b1;
                axi_ost <= 1'b0; tocnt <= '0; st <= S_ABORT;
              end
            end else begin
              nferr <= nferr + 16'd1; r_axi <= 1'b1; axi_abort <= 1'b1;
              tocnt <= '0; st <= S_DRAIN;
            end
          end else if (tocnt >= TO_CYC[15:0]) begin
            nfto <= nfto + 16'd1; r_axi <= 1'b1; axi_abort <= 1'b1;
            tocnt <= '0; st <= S_DRAIN;
          end
        end
        S_DRAIN: begin
          f_arvalid <= 1'b0;
          tocnt <= tocnt + 16'd1;
          if (m_axi_rvalid && (m_axi_rid==ost_rid)) begin
            ndrain <= ndrain + 16'd1;
            if (m_axi_rlast) begin
              axi_ost <= 1'b0; tocnt <= '0; st <= S_ABORT;
            end
          end else if (tocnt >= DRAIN_TO[15:0]) begin
            dead_mask[ost_rid] <= 1'b1;
            axi_ost <= 1'b0; naban <= naban + 16'd1; tocnt <= '0; st <= S_ABORT;
          end
        end
        S_ABORT: begin
          f_arvalid <= 1'b0;
          r_st <= ST_INCOMP;
          best_a <= '0; best_p0 <= '0; best_p1 <= '0; sel_idx <= '0;
          pend_acc <= 1'b0; pend_cmt <= 1'b0;
          np <= '0; n_legal <= '0;
          axi_abort <= 1'b1;
          st <= S_HOLD;
        end
        S_EI: begin
          if (r_ovf || r_axi) begin
            r_st <= ST_INCOMP;
            best_a <= '0; best_p0 <= '0; best_p1 <= '0; sel_idx <= '0;
            pend_acc <= 1'b0; pend_cmt <= 1'b0;
            st <= S_HOLD;
          end
          else if (ei >= nf) st <= S_GUARD;
          else if (r_two) begin ej <= '0; st <= S_EJ; end
          else st <= S_ED;
        end
        S_ED: begin
          if (fv[ei[3:0]]
              && (fr[ei[3:0]]==r_rel)
              && (fs[ei[3:0]]=={{12{1'b0}}, r_subj})
              && (fo[ei[3:0]] != {{12{1'b0}}, r_subj})
              && (!r_obj_v || (fo[ei[3:0]]=={{12{1'b0}}, r_obj}))
              && (!r_dom || (fcx[ei[3:0]]==r_ctx))) begin
            if (!fpv[ei[3:0]]) begin
              if (have_pos && (fo[ei[3:0]]==concl0)) r_conf <= 1'b1;
              if (!have_neg) begin have_neg <= 1'b1; neg0 <= fo[ei[3:0]]; end
            end else begin
              if (have_pos && (fo[ei[3:0]] != concl0)) r_conf <= 1'b1;
              if (have_neg && (fo[ei[3:0]] == neg0)) r_conf <= 1'b1;
              if (!have_pos) begin have_pos <= 1'b1; concl0 <= fo[ei[3:0]]; end
              if (np < MAX_PATH[4:0]) begin
                pp0[np[1:0]] <= fe[ei[3:0]];
                pp1[np[1:0]] <= 20'd0;
                pans[np[1:0]] <= fo[ei[3:0]];
                pc1[np[1:0]] <= fcf[ei[3:0]];
                pc2[np[1:0]] <= fcf[ei[3:0]];
                pt1[np[1:0]] <= ft[ei[3:0]];
                pt2[np[1:0]] <= 1'b0;
                pp1v[np[1:0]] <= fpv[ei[3:0]];
                pp2v[np[1:0]] <= fpv[ei[3:0]];
                np <= np + 1'b1;
              end
              if (n_legal != 5'h1F) n_legal <= n_legal + 1'b1;
            end
          end
          ei <= ei + 1'b1;
          st <= S_EI;
        end
        S_EJ: begin
          if (ej >= nf) begin ei <= ei + 1'b1; st <= S_EI; end
          else begin
            if (fv[ei[3:0]] && fv[ej[3:0]] && ft[ei[3:0]] && ft[ej[3:0]]
                && (fr[ei[3:0]]==r_rel) && (fr[ej[3:0]]==r_rel)
                && (fs[ei[3:0]]=={{12{1'b0}}, r_subj})
                && (fs[ej[3:0]]==fo[ei[3:0]])
                && (fo[ej[3:0]] != {{12{1'b0}}, r_subj})
                && (!r_obj_v || (fo[ej[3:0]]=={{12{1'b0}}, r_obj}))
                && (!r_dom || ((fcx[ei[3:0]]==r_ctx) && (fcx[ej[3:0]]==r_ctx)))) begin
              if (!(fpv[ei[3:0]] && fpv[ej[3:0]])) begin
                if (have_pos && (fo[ej[3:0]]==concl0)) r_conf <= 1'b1;
                if (!have_neg) begin have_neg <= 1'b1; neg0 <= fo[ej[3:0]]; end
              end else begin
                if (have_pos && (fo[ej[3:0]] != concl0)) r_conf <= 1'b1;
                if (have_neg && (fo[ej[3:0]] == neg0)) r_conf <= 1'b1;
                if (!have_pos) begin have_pos <= 1'b1; concl0 <= fo[ej[3:0]]; end
                if (np < MAX_PATH[4:0]) begin
                  pp0[np[1:0]] <= fe[ei[3:0]];
                  pp1[np[1:0]] <= fe[ej[3:0]];
                  pans[np[1:0]] <= fo[ej[3:0]];
                  pc1[np[1:0]] <= fcf[ei[3:0]];
                  pc2[np[1:0]] <= fcf[ej[3:0]];
                  pt1[np[1:0]] <= ft[ei[3:0]];
                  pt2[np[1:0]] <= ft[ej[3:0]];
                  pp1v[np[1:0]] <= fpv[ei[3:0]];
                  pp2v[np[1:0]] <= fpv[ej[3:0]];
                  np <= np + 1'b1;
                end
                if (n_legal != 5'h1F) n_legal <= n_legal + 1'b1;
              end
            end
            ej <= ej + 1'b1;
          end
        end
        S_GUARD: begin
          if (n_legal > MAX_PATH[4:0]) begin
            r_st <= ST_INCOMP;
            best_a <= '0; best_p0 <= '0; best_p1 <= '0; sel_idx <= '0;
            st <= S_HOLD;
          end else if (r_conf) begin
            r_st <= ST_CONFLICT;
            best_a <= '0; best_p0 <= '0; best_p1 <= '0; sel_idx <= '0;
            st <= S_HOLD;
          end else if (np == 0) begin
            r_st <= ST_UNKNOWN;
            best_a <= '0; best_p0 <= '0; best_p1 <= '0;
            st <= S_HOLD;
          end else begin
            pi <= '0;
            st <= S_SC;
          end
        end
        S_SC: if (sgd_ready) begin sgd_go <= 1'b1; st <= S_SW; end
        S_SW: if (sgd_done) begin
          pv[pi[1:0]] <= sgd_v;
          for (kf = 0; kf < 32; kf = kf + 1) phis[pi[1:0]][kf] <= phi[kf];
          if (pi + 1'b1 == np) st <= S_PICK;
          else begin pi <= pi + 1'b1; st <= S_SC; end
        end
        S_PICK: begin
          v_best <= c_best_v; v_second <= c_second_v; v_pred <= c_best_v;
          best_a <= c_best_a; best_p0 <= c_best_p0; best_p1 <= c_best_p1;
          sel_idx <= c_best_idx;
          r_st <= 4'd0;
          if ((sess_id_i == A7NG_A09_EPOCH_INV) ||
              ((sess_id_i == sess_epoch) && (txn == TXN_MAX))) begin
            nexh <= nexh + 16'd1;
            txn_exh <= 1'b1;
            pend_acc <= 1'b0;
            pend_cmt <= 1'b0;
          end else begin
            txn_exh <= 1'b0;
            if (sess_id_i != sess_epoch) begin
              sess_epoch <= sess_id_i;
              pend_id <= 8'd1; txn <= 8'd1;
              pend_gen <= 8'd1; gen <= 8'd1;
            end else begin
              pend_id <= txn + 8'd1; txn <= txn + 8'd1;
              pend_gen <= gen + 8'd1; gen <= gen + 8'd1;
            end
            pend_epoch <= sess_id_i;
            pend_acc <= 1'b1; pend_cmt <= 1'b0;
            for (kf = 0; kf < 32; kf = kf + 1) pend_phi[kf] <= phis[c_best_idx][kf];
          end
          st <= S_HOLD;
        end
        S_HOLD: begin
          f_arvalid <= 1'b0;
          if (axi_abort || (r_st == ST_INCOMP)) begin
            r_st <= ST_INCOMP;
            best_a <= '0; best_p0 <= '0; best_p1 <= '0;
            pend_acc <= 1'b0;
          end else if (np==0 && r_st==ST_UNKNOWN) begin
            best_a <= '0; best_p0 <= '0; best_p1 <= '0;
          end
          if (rew_v_i) begin
            if (!pend_acc) nbad <= nbad + 16'd1;
            else if (rew_epoch_i != pend_epoch) nstale <= nstale + 16'd1;
            else if (rew_gen_i != pend_gen) nstale <= nstale + 16'd1;
            else if (rew_txn_i != pend_id) nbad <= nbad + 16'd1;
            else if ((rew_i < -4'sd3) || (rew_i > 4'sd3)) noor <= noor + 16'd1;
            else if (pend_cmt) ndup <= ndup + 16'd1;
            else if (freeze_q) begin
            end else if (sgd_ready) begin
              rew_lat <= rew_i;
              sgd_upd <= 1'b1;
              st <= S_UW;
            end
          end else if (retire_i) begin
            pend_acc <= 1'b0; st <= S_IDLE;
          end
        end
        S_UW: begin
          if (retire_i) retire_hold <= 1'b1;
          if (sgd_done) begin
            pend_cmt <= 1'b1; nupd <= nupd + 16'd1;
            if (retire_hold || retire_i) begin
              pend_acc <= 1'b0; st <= S_IDLE;
            end else st <= S_HOLD;
          end
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
