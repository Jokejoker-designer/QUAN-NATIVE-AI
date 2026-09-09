// a7ng_astra_06_r3_multi_slot.sv — ASTRA-06-R3-MULTI-SLOT-01. PROGRAM=NO.
// New named DUT. Does not patch a7ng_astra_06_warm_persist.sv, a7ng_astra_06_r2*.sv, or F2R/F3 RTL.
// Instantiates frozen a7ng_shared_rank_sgd_q8_sym_f2r2.
// On-chip persist CAP_N>=2. REFUSE_ALL_UNCOMMITTED / EVICT_OLDEST_COMMITTED_LOWEST_TXN.
`timescale 1ns / 1ps
`include "a7ng_astra_06_r3_multi_slot.svh"

module a7ng_astra_06_r3_multi_slot #(
  parameter int unsigned ID_W       = 20,
  parameter int unsigned CAND_CAP   = 16,
  parameter int unsigned TO_CYC     = A7NG_A06R3_TO_CYC,
  parameter int unsigned DRAIN_TO   = A7NG_A06R3_DRAIN_TO,
  parameter int unsigned MAX_PATH   = 4,
  parameter logic [7:0]  TXN_MAX    = A7NG_A06R3_TXN_MAX,
  parameter int unsigned CAP_N      = A7NG_A06R3_CAP_N,
  parameter logic [7:0]  SCHEMA_VER = A7NG_A06R3_SCHEMA_VER,
  parameter logic [27:0] INDEX_BASE = 28'h0500_0000,
  parameter logic [27:0] FACT_BASE  = 28'h0580_0000
) (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        persist_en_i,
  input  logic        restore_en_i,
  input  logic        persist_clr_i,
  input  logic        reload_i,
  input  logic [1:0]  slot_sel_i,
  input  logic [7:0]  schema_i,
  input  logic        schema_poke_i,
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
  output logic        persist_valid_o,
  output logic        persist_acc_o,
  output logic        persist_cmt_o,
  output logic        reload_busy_o,
  output logic [15:0] persist_epoch_o,
  output logic [7:0]  persist_gen_o,
  output logic [7:0]  persist_txn_o,
  output logic signed [15:0] persist_w0_o,
  output logic signed [15:0] persist_vpred_o,
  output logic signed [7:0]  persist_phi0_o,
  output logic [ID_W-1:0] persist_ans_o,
  output logic [ID_W-1:0] persist_p0_o,
  output logic [ID_W-1:0] persist_p1_o,
  output logic [7:0]  persist_ver_o,
  output logic        cap_full_o,
  output logic [7:0]  cap_n_o,
  output logic [7:0]  n_persist_o,
  output logic        victim_v_o,
  output logic [1:0]  victim_idx_o,
  output logic [7:0]  victim_txn_o,
  output logic [1:0]  live_slot_o,
  output logic        s0_valid_o,
  output logic        s0_acc_o,
  output logic        s0_cmt_o,
  output logic [7:0]  s0_txn_o,
  output logic [7:0]  s0_gen_o,
  output logic signed [7:0]  s0_phi0_o,
  output logic signed [15:0] s0_w0_o,
  output logic [ID_W-1:0] s0_ans_o,
  output logic [ID_W-1:0] s0_p0_o,
  output logic [ID_W-1:0] s0_p1_o,
  output logic        s1_valid_o,
  output logic        s1_acc_o,
  output logic        s1_cmt_o,
  output logic [7:0]  s1_txn_o,
  output logic [7:0]  s1_gen_o,
  output logic signed [7:0]  s1_phi0_o,
  output logic signed [15:0] s1_w0_o,
  output logic [ID_W-1:0] s1_ans_o,
  output logic [ID_W-1:0] s1_p0_o,
  output logic [ID_W-1:0] s1_p1_o,
  output logic [15:0] n_cap_ref_o,
  output logic [15:0] n_cap_evict_o,
  output logic [15:0] n_schema_rej_o,
  output logic [15:0] n_rl_auto_o,
  output logic [15:0] n_rl_cmd_o
);
  localparam logic [3:0] VER = 4'd1;
  localparam logic [3:0] ST_UNKNOWN = 4'd1, ST_CONFLICT = 4'd5, ST_INCOMP = 4'd6, ST_AMB = 4'd7, ST_NEG = 4'd8;
  localparam logic [7:0] CTX_INDIRECT = 8'd2;

  typedef enum logic [3:0] {
    S_IDLE, S_WALK, S_AR, S_R, S_DRAIN, S_ABORT,
    S_EI, S_EJ, S_ED, S_GUARD, S_SC, S_SW, S_PICK, S_HOLD, S_UW, S_RELOAD
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
  integer k, kf, pk;
  logic        need_rl, pick_ok, cap_full, schema_ok, keep_proof;
  logic        p_valid, p_acc, p_cmt;
  logic [15:0] p_epoch, p_sess_epoch;
  logic [7:0]  p_gen, p_txn, p_ver;
  logic [1:0]  p_sel;
  logic [4:0]  rl_idx;
  logic [1:0]  rl_slot, live_slot, inst_idx, free_idx, vic_idx, obs_sel;
  logic        has_free, has_vic, inst_refuse, inst_evict;
  logic [7:0]  occ_n, occ_cmt, vic_txn;
  logic signed [15:0] p_vpred;
  logic signed [15:0] p_w [0:31];
  logic signed [7:0]  p_phi [0:31];
  logic [19:0] p_ans, p_p0, p_p1;
  logic        ps_valid [0:1];
  logic        ps_acc [0:1];
  logic        ps_cmt [0:1];
  logic [15:0] ps_epoch [0:1];
  logic [15:0] ps_sess_epoch [0:1];
  logic [7:0]  ps_gen [0:1];
  logic [7:0]  ps_txn [0:1];
  logic [7:0]  ps_ver [0:1];
  logic [1:0]  ps_sel [0:1];
  logic signed [15:0] ps_vpred [0:1];
  logic signed [15:0] ps_w [0:1][0:31];
  logic signed [7:0]  ps_phi [0:1][0:31];
  logic [19:0] ps_ans [0:1];
  logic [19:0] ps_p0 [0:1];
  logic [19:0] ps_p1 [0:1];
  logic        sgd_load_v;
  logic [4:0]  sgd_load_idx;
  logic signed [15:0] sgd_load_w;
  logic [15:0] n_cap_ref, n_cap_evict, n_schema_rej, n_rl_auto, n_rl_cmd;
  integer si, kj;

  assign load_from_tb_o = 1'b0;
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
  assign qse_tok_v = tok_valid_i && (st==S_IDLE) && !(need_rl && p_valid && restore_en_i && schema_ok);
  assign qse_fire = fire_i && (st==S_IDLE) && !(need_rl && p_valid && restore_en_i && schema_ok);
  assign tok_ready_o = qse_tok_r && (st==S_IDLE) && !(need_rl && p_valid && restore_en_i && schema_ok);
  assign cand_ready = (st==S_WALK);
  assign busy_o = (st!=S_IDLE) || (need_rl && p_valid && restore_en_i && schema_ok);
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
  assign obs_sel = (slot_sel_i == 2'd1) ? 2'd1 : 2'd0;
  assign p_valid = ps_valid[obs_sel];
  assign p_acc = ps_acc[obs_sel];
  assign p_cmt = ps_cmt[obs_sel];
  assign p_epoch = ps_epoch[obs_sel];
  assign p_sess_epoch = ps_sess_epoch[obs_sel];
  assign p_gen = ps_gen[obs_sel];
  assign p_txn = ps_txn[obs_sel];
  assign p_ver = ps_ver[obs_sel];
  assign p_sel = ps_sel[obs_sel];
  assign p_vpred = ps_vpred[obs_sel];
  assign p_ans = ps_ans[obs_sel];
  assign p_p0 = ps_p0[obs_sel];
  assign p_p1 = ps_p1[obs_sel];
  assign persist_valid_o = p_valid;
  assign persist_acc_o = p_acc;
  assign persist_cmt_o = p_cmt;
  assign reload_busy_o = (st==S_RELOAD) ||
                         (need_rl && p_valid && restore_en_i && schema_ok) ||
                         (reload_i && p_valid && schema_ok);
  assign persist_epoch_o = p_epoch;
  assign persist_gen_o = p_gen;
  assign persist_txn_o = p_txn;
  assign persist_w0_o = (obs_sel==2'd1) ? ps_w[1][0] : ps_w[0][0];
  assign persist_vpred_o = p_vpred;
  assign persist_phi0_o = (obs_sel==2'd1) ? ps_phi[1][0] : ps_phi[0][0];
  assign persist_ans_o = p_ans;
  assign persist_p0_o = p_p0;
  assign persist_p1_o = p_p1;
  assign persist_ver_o = p_ver;
  assign cap_full_o = cap_full;
  assign cap_n_o = 8'(CAP_N);
  assign n_persist_o = occ_n;
  assign victim_v_o = has_vic;
  assign victim_idx_o = vic_idx;
  assign victim_txn_o = vic_txn;
  assign live_slot_o = live_slot;
  assign s0_valid_o = ps_valid[0];
  assign s0_acc_o = ps_acc[0];
  assign s0_cmt_o = ps_cmt[0];
  assign s0_txn_o = ps_txn[0];
  assign s0_gen_o = ps_gen[0];
  assign s0_phi0_o = ps_phi[0][0];
  assign s0_w0_o = ps_w[0][0];
  assign s0_ans_o = ps_ans[0];
  assign s0_p0_o = ps_p0[0];
  assign s0_p1_o = ps_p1[0];
  assign s1_valid_o = ps_valid[1];
  assign s1_acc_o = ps_acc[1];
  assign s1_cmt_o = ps_cmt[1];
  assign s1_txn_o = ps_txn[1];
  assign s1_gen_o = ps_gen[1];
  assign s1_phi0_o = ps_phi[1][0];
  assign s1_w0_o = ps_w[1][0];
  assign s1_ans_o = ps_ans[1];
  assign s1_p0_o = ps_p0[1];
  assign s1_p1_o = ps_p1[1];
  assign schema_ok = p_valid && (p_ver == SCHEMA_VER);
  assign n_cap_ref_o = n_cap_ref;
  assign n_cap_evict_o = n_cap_evict;
  assign n_schema_rej_o = n_schema_rej;
  assign n_rl_auto_o = n_rl_auto;
  assign n_rl_cmd_o = n_rl_cmd;
  assign pick_ok = (st==S_PICK) && (sess_id_i != A7NG_A06R3_EPOCH_INV) &&
                   !((sess_id_i == sess_epoch) && (txn == TXN_MAX)) &&
                   !(persist_en_i && inst_refuse);
  assign sgd_load_v = (st==S_RELOAD) || (load_v_i && (st==S_IDLE) && !(need_rl && p_valid && restore_en_i && schema_ok));
  assign sgd_load_idx = (st==S_RELOAD) ? rl_idx : load_idx_i;
  assign sgd_load_w = (st==S_RELOAD) ?
                      ((rl_slot==2'd1) ? ps_w[1][rl_idx] : ps_w[0][rl_idx]) : load_w_i;

  function automatic logic [3:0] next_fact_arid(input logic [15:0] dead);
    integer i;
    begin
      next_fact_arid = A7NG_A06R3_FACT_RID0;
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
    occ_n = 8'd0;
    occ_cmt = 8'd0;
    has_free = 1'b0;
    free_idx = 2'd0;
    has_vic = 1'b0;
    vic_idx = 2'd0;
    vic_txn = 8'hFF;
    for (kj = 0; kj < CAP_N; kj = kj + 1) begin
      if (ps_valid[kj]) begin
        occ_n = occ_n + 8'd1;
        if (ps_cmt[kj]) begin
          occ_cmt = occ_cmt + 8'd1;
          if (!has_vic || (ps_txn[kj] < vic_txn) ||
              ((ps_txn[kj] == vic_txn) && (kj[1:0] < vic_idx))) begin
            has_vic = 1'b1;
            vic_idx = kj[1:0];
            vic_txn = ps_txn[kj];
          end
        end
      end else if (!has_free) begin
        has_free = 1'b1;
        free_idx = kj[1:0];
      end
    end
    cap_full = (occ_n == 8'(CAP_N)) && (occ_cmt == 8'd0);
    inst_refuse = cap_full;
    inst_evict = (occ_n == 8'(CAP_N)) && has_vic;
    inst_idx = has_free ? free_idx : vic_idx;
    for (kj = 0; kj < 32; kj = kj + 1)
      p_phi[kj] = (obs_sel==2'd1) ? ps_phi[1][kj] : ps_phi[0][kj];
    for (kj = 0; kj < 32; kj = kj + 1)
      p_w[kj] = (obs_sel==2'd1) ? ps_w[1][kj] : ps_w[0][kj];
  end

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
    .load_v_i(sgd_load_v), .load_idx_i(sgd_load_idx), .load_w_i(sgd_load_w),
    .w_o(w_o), .ready_o(sgd_ready), .done_o(sgd_done), .v_q8_o(sgd_v)
  );

  always_ff @(posedge clk) begin
    if (persist_clr_i) begin
      for (si = 0; si < CAP_N; si = si + 1) begin
        ps_valid[si] <= 1'b0; ps_acc[si] <= 1'b0; ps_cmt[si] <= 1'b0;
        ps_epoch[si] <= A7NG_A06R3_EPOCH_INV;
        ps_sess_epoch[si] <= A7NG_A06R3_EPOCH_INV;
        ps_gen[si] <= 8'd0; ps_txn[si] <= 8'd0; ps_sel[si] <= 2'd0;
        ps_ver[si] <= SCHEMA_VER;
        ps_vpred[si] <= 16'sd0;
        ps_ans[si] <= '0; ps_p0[si] <= '0; ps_p1[si] <= '0;
        for (pk = 0; pk < 32; pk = pk + 1) begin
          ps_w[si][pk] <= 16'sd0;
          ps_phi[si][pk] <= 8'sd0;
        end
      end
    end else if (persist_en_i) begin
      if (schema_poke_i && (obs_sel < 2'(CAP_N)))
        ps_ver[obs_sel] <= schema_i;
      if (pick_ok) begin
        ps_valid[inst_idx] <= 1'b1;
        ps_acc[inst_idx] <= 1'b1;
        ps_cmt[inst_idx] <= 1'b0;
        ps_ver[inst_idx] <= schema_i;
        ps_epoch[inst_idx] <= sess_id_i;
        ps_sess_epoch[inst_idx] <= sess_id_i;
        if (sess_id_i != sess_epoch) begin
          ps_gen[inst_idx] <= 8'd1; ps_txn[inst_idx] <= 8'd1;
        end else begin
          ps_gen[inst_idx] <= gen + 8'd1; ps_txn[inst_idx] <= txn + 8'd1;
        end
        ps_sel[inst_idx] <= c_best_idx;
        ps_vpred[inst_idx] <= c_best_v;
        ps_ans[inst_idx] <= c_best_a;
        ps_p0[inst_idx] <= c_best_p0;
        ps_p1[inst_idx] <= c_best_p1;
        for (pk = 0; pk < 32; pk = pk + 1) begin
          ps_phi[inst_idx][pk] <= phis[c_best_idx][pk];
          ps_w[inst_idx][pk] <= 16'sd0;
        end
      end
      if ((st == S_UW) && sgd_done && ps_valid[live_slot]) begin
        ps_cmt[live_slot] <= 1'b1;
        for (pk = 0; pk < 32; pk = pk + 1) ps_w[live_slot][pk] <= w_o[pk];
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE; qse_retire <= 1'b0; sgd_go <= 1'b0; sgd_upd <= 1'b0;
      f_arvalid <= 1'b0; f_araddr <= '0; f_arid <= A7NG_A06R3_FACT_RID0;
      axi_ost <= 1'b0; axi_abort <= 1'b0; ost_rid <= A7NG_A06R3_FACT_RID0;
      dead_mask <= 16'd0; ndrain <= '0; naban <= '0;
      nc <= '0; fi <= '0; nf <= '0; ei <= '0; ej <= '0; np <= '0; pi <= '0; n_legal <= '0;
      nfar <= '0; nfok <= '0; nferr <= '0; nfto <= '0; narto <= '0; tocnt <= '0;
      nupd <= '0; ndup <= '0; nbad <= '0; nstale <= '0; noor <= '0;
      n_cap_ref <= '0; n_cap_evict <= '0; n_schema_rej <= '0;
      n_rl_auto <= '0; n_rl_cmd <= '0;
      r_subj <= '0; r_obj <= '0; r_rel <= '0; r_ctx <= '0;
      r_ovf <= 1'b0; r_neg <= 1'b0; r_amb <= 1'b0; r_axi <= 1'b0;
      r_two <= 1'b0; r_obj_v <= 1'b0; r_dom <= 1'b0; r_conf <= 1'b0;
      have_pos <= 1'b0; have_neg <= 1'b0; concl0 <= '0; neg0 <= '0;
      r_st <= ST_UNKNOWN;
      txn <= 8'd0; pend_id <= 8'd0; gen <= 8'd0; pend_gen <= 8'd0;
      pend_epoch <= A7NG_A06R3_EPOCH_INV; sess_epoch <= A7NG_A06R3_EPOCH_INV;
      nexh <= '0; txn_exh <= 1'b0;
      pend_acc <= 1'b0; pend_cmt <= 1'b0; retire_hold <= 1'b0; rew_lat <= '0;
      sel_idx <= '0; best_a <= '0; best_p0 <= '0; best_p1 <= '0;
      v_best <= '0; v_second <= '0; v_pred <= '0;
      need_rl <= 1'b1; rl_idx <= 5'd0; keep_proof <= 1'b0;
      live_slot <= 2'd0; rl_slot <= 2'd0;
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
          if (!keep_proof) begin
            best_a <= '0; best_p0 <= '0; best_p1 <= '0;
          end
          v_best <= '0; v_second <= '0;
          r_st <= ST_UNKNOWN;
          if (need_rl && p_valid && restore_en_i && schema_ok && sgd_ready) begin
            need_rl <= 1'b0;
            rl_idx <= 5'd0;
            rl_slot <= obs_sel;
            n_rl_auto <= n_rl_auto + 16'd1;
            st <= S_RELOAD;
          end else if (need_rl && p_valid && restore_en_i && !schema_ok) begin
            need_rl <= 1'b0;
            n_schema_rej <= n_schema_rej + 16'd1;
          end else if (need_rl && !p_valid) begin
            need_rl <= 1'b0;
          end else if (need_rl && !restore_en_i) begin
            need_rl <= 1'b0;
          end else if (reload_i && p_valid && schema_ok && sgd_ready) begin
            need_rl <= 1'b0;
            rl_idx <= 5'd0;
            rl_slot <= obs_sel;
            n_rl_cmd <= n_rl_cmd + 16'd1;
            st <= S_RELOAD;
          end else if (reload_i && p_valid && !schema_ok) begin
            need_rl <= 1'b0;
            n_schema_rej <= n_schema_rej + 16'd1;
          end else if (rew_v_i) begin
            if (!pend_acc && ((pend_epoch == A7NG_A06R3_EPOCH_INV) || (rew_epoch_i != pend_epoch)))
              nstale <= nstale + 16'd1;
            else if (!pend_acc) nbad <= nbad + 16'd1;
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
          end else if (qse_valid) begin
            keep_proof <= 1'b0;
            best_a <= '0; best_p0 <= '0; best_p1 <= '0;
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
            r_ovf <= w_ovf; qse_retire <= 1'b1; fi <= '0;
            if (r_amb) begin r_st <= ST_AMB; st <= S_HOLD; end
            else if (r_neg) begin r_st <= ST_NEG; st <= S_HOLD; end
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
              if (m_axi_rresp != A7NG_A06R3_RRESP_OK) begin
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
          if (r_ovf || r_axi) begin r_st <= ST_INCOMP; st <= S_HOLD; end
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
          if ((sess_id_i == A7NG_A06R3_EPOCH_INV) ||
              ((sess_id_i == sess_epoch) && (txn == TXN_MAX))) begin
            nexh <= nexh + 16'd1;
            txn_exh <= 1'b1;
            pend_acc <= 1'b0;
            pend_cmt <= 1'b0;
          end else if (persist_en_i && inst_refuse) begin
            n_cap_ref <= n_cap_ref + 16'd1;
            txn_exh <= 1'b0;
            pend_acc <= 1'b0;
            pend_cmt <= 1'b0;
          end else begin
            txn_exh <= 1'b0;
            if (persist_en_i && inst_evict)
              n_cap_evict <= n_cap_evict + 16'd1;
            if (persist_en_i)
              live_slot <= inst_idx;
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
          if (axi_abort) begin
            r_st <= ST_INCOMP;
            best_a <= '0; best_p0 <= '0; best_p1 <= '0;
            pend_acc <= 1'b0;
          end else if (np==0 && r_st==ST_UNKNOWN) begin
            best_a <= '0; best_p0 <= '0; best_p1 <= '0;
          end
          if (rew_v_i) begin
            if (!pend_acc && ((pend_epoch == A7NG_A06R3_EPOCH_INV) || (rew_epoch_i != pend_epoch)))
              nstale <= nstale + 16'd1;
            else if (!pend_acc) nbad <= nbad + 16'd1;
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
        S_RELOAD: begin
          if (rl_idx == 5'd31) begin
            pend_epoch <= ps_epoch[rl_slot];
            pend_gen <= ps_gen[rl_slot];
            pend_id <= ps_txn[rl_slot];
            gen <= ps_gen[rl_slot];
            txn <= ps_txn[rl_slot];
            sess_epoch <= ps_sess_epoch[rl_slot];
            pend_acc <= ps_acc[rl_slot];
            pend_cmt <= ps_cmt[rl_slot];
            sel_idx <= ps_sel[rl_slot];
            v_pred <= ps_vpred[rl_slot];
            best_a <= ps_ans[rl_slot];
            best_p0 <= ps_p0[rl_slot];
            best_p1 <= ps_p1[rl_slot];
            keep_proof <= 1'b1;
            live_slot <= rl_slot;
            for (kf = 0; kf < 32; kf = kf + 1) pend_phi[kf] <= ps_phi[rl_slot][kf];
            st <= S_IDLE;
          end else rl_idx <= rl_idx + 5'd1;
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
