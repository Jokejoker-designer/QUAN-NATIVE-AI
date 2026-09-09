// a7ng_astra_f3r4_distinct_hold_phi.sv — ASTRA-F3-R4-DISTINCT-HOLD-PHI-01. PROGRAM=NO.
// New named ranker. Does not edit F2R-01/R2/R3/R4/R5, F3, F3-R2, or F3-R3 bags or frozen RTL.
// Instantiates frozen a7ng_shared_rank_sgd_q8_sym_f2r2. Shared 32-phi is
// non-ID (quality/flags/object-context). No gold, class-winner, or proof index.
// Legal hop beyond MAX_PATH sets ST_INCOMP (fifth path cap).
`timescale 1ns / 1ps
`include "a7ng_astra_f3r4_distinct_hold_phi.svh"

module a7ng_astra_f3r4_distinct_hold_phi #(
  parameter int unsigned ID_W       = 20,
  parameter int unsigned CAND_CAP   = 16,
  parameter int unsigned TO_CYC     = A7NG_F3R4_TO_CYC,
  parameter int unsigned MAX_PATH   = A7NG_F3R4_MAX_PATH,
  parameter logic [27:0] INDEX_BASE = 28'h0500_0000,
  parameter logic [27:0] FACT_BASE  = 28'h0580_0000
) (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [15:0] live_epoch_i,
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
  input  logic        load_v_i,
  input  logic [4:0]  load_idx_i,
  input  logic signed [15:0] load_w_i,
  output logic        busy_o,
  output logic        result_v_o,
  output logic        pend_acc_o,
  output logic        pend_cmt_o,
  output logic [7:0]  txn_id_o,
  output logic [7:0]  gen_o,
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
  output logic signed [7:0]  phi0_o,
  output logic signed [7:0]  pend_phi_o [0:31],
  output logic signed [15:0] w_o [0:31],
  output logic [15:0] n_upd_o,
  output logic [15:0] n_dup_o,
  output logic [15:0] n_bad_o,
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
  output logic        m_axi_rready
);
  typedef enum logic [3:0] {
    S_IDLE, S_WALK, S_AR, S_R, S_EI, S_EJ, S_ED, S_SC, S_SW, S_PICK, S_HOLD, S_UW
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
  logic fetch_mode, f_arvalid, f_arready, f_rvalid;
  logic [27:0] f_araddr;
  logic [4:0] nc, fi, nf, ei, ej, np, pi;
  logic [19:0] fs [0:15], fo [0:15], fe [0:15];
  logic [7:0]  fr [0:15], fcf [0:15], fcx [0:15];
  logic        ft [0:15], fpv [0:15], fv [0:15];
  logic [19:0] pp0 [0:3], pp1 [0:3], pans [0:3];
  logic [7:0]  pc1 [0:3], pc2 [0:3], px1 [0:3], px2 [0:3];
  logic        pt1 [0:3], pt2 [0:3], pp1v [0:3], pp2v [0:3], ph2 [0:3];
  logic signed [15:0] pv [0:3];
  logic signed [7:0]  phis [0:3][0:31];
  logic signed [7:0]  phi [0:31], pend_phi [0:31];
  logic [7:0] r_subj, r_obj, r_rel, r_ctx;
  logic r_ovf, r_neg, r_amb, r_two, r_obj_v, path_ovf;
  logic [3:0] r_st;
  logic [15:0] nupd, ndup, nbad, tocnt;
  logic signed [15:0] sgd_v, v_best, v_second;
  logic sgd_ready, sgd_done, sgd_go, sgd_upd, freeze_q;
  logic signed [3:0] rew_lat;
  logic [7:0] txn, pend_id, gen, pend_gen;
  logic pend_acc, pend_cmt, retire_hold;
  logic [1:0] sel_idx, c_best_idx;
  logic [19:0] best_a, best_p0, best_p1, c_best_a, c_best_p0, c_best_p1;
  logic signed [15:0] c_best_v, c_second_v;
  integer k, kf;

  assign load_from_tb_o = 1'b0;
  assign freeze_q = (ctrl_i != 2'd0);
  assign fetch_mode = (st==S_AR) || (st==S_R);
  assign m_axi_arid = fetch_mode ? A7NG_F3R4_FACT_RID : sp_arid;
  assign m_axi_araddr = fetch_mode ? f_araddr : sp_araddr;
  assign m_axi_arlen = fetch_mode ? 8'd0 : sp_arlen;
  assign m_axi_arsize = fetch_mode ? 3'd4 : sp_arsize;
  assign m_axi_arburst = fetch_mode ? 2'b01 : sp_arburst;
  assign m_axi_arvalid = fetch_mode ? f_arvalid : sp_arvalid;
  assign sp_arready = fetch_mode ? 1'b0 : m_axi_arready;
  assign f_arready = fetch_mode ? m_axi_arready : 1'b0;
  assign sp_rid = m_axi_rid;
  assign sp_rdata = m_axi_rdata;
  assign sp_rresp = m_axi_rresp;
  assign sp_rlast = m_axi_rlast;
  assign sp_rvalid = fetch_mode ? 1'b0 : m_axi_rvalid;
  assign f_rvalid = fetch_mode ? m_axi_rvalid : 1'b0;
  assign m_axi_rready = fetch_mode ? 1'b1 : sp_rready;
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
  assign sel_idx_o = sel_idx;
  assign ans_o = best_a;
  assign proof0_o = best_p0;
  assign proof1_o = best_p1;
  assign n_path_o = np;
  assign status_o = r_st;
  assign obj_o = r_obj;
  assign ctx_o = r_ctx;
  assign v_best_o = v_best;
  assign v_second_o = v_second;
  assign phi0_o = pend_phi[0];
  assign n_upd_o = nupd;
  assign n_dup_o = ndup;
  assign n_bad_o = nbad;

  genvar gi;
  generate for (gi = 0; gi < 32; gi = gi + 1) begin : g_ph
    assign pend_phi_o[gi] = pend_phi[gi];
  end endgenerate

  function automatic logic signed [7:0] fphi(
      input int unsigned idx,
      input logic [7:0] c1, c2, cx1, cx2, qctx,
      input logic t1, t2, p1, p2, hop2);
    logic [7:0] cmin;
    logic signed [7:0] r;
    logic ctxm;
    begin
      cmin = (c1 < c2) ? c1 : c2;
      ctxm = (cx1 == qctx) && (cx2 == qctx);
      r = 8'sd0;
      unique case (idx)
        0:  r = cmin[7:2];
        1:  r = (t1 && t2) ? 8'sd64 : 8'sd0;
        2:  r = (p1 && p2) ? 8'sd64 : 8'sd0;
        3:  r = ctxm ? 8'sd64 : 8'sd0;
        4:  r = ((cx1 != 8'd0) && (cx2 != 8'd0)) ? 8'sd64 : 8'sd0;
        5:  r = hop2 ? ((cx2 != 8'd0) ? 8'sd64 : 8'sd0)
                     : ((cx1 != 8'd0) ? 8'sd64 : 8'sd0);
        6:  r = hop2 ? 8'sd64 : 8'sd0;
        7:  r = (cmin >= 8'd128) ? 8'sd64 : 8'sd0;
        8:  r = (t1 && t2 && p1 && p2) ? 8'sd64 : 8'sd0;
        9:  r = ctxm ? cmin[7:2] : 8'sd0;
        10: r = c1[7:2];
        11: r = hop2 ? c2[7:2] : c1[7:2];
        12: r = (cx1 != cx2) ? 8'sd64 : 8'sd0;
        13: r = (cx1 == cx2) ? 8'sd64 : 8'sd0;
        14: r = hop2 ? 8'sd0 : 8'sd64;
        15: r = hop2 ? 8'sd64 : 8'sd0;
        default: r = 8'sd0;
      endcase
      fphi = r;
    end
  endfunction

  always_comb begin
    for (k = 0; k < 32; k = k + 1) phi[k] = 8'sd0;
    if (st==S_SC || st==S_SW) begin
      for (k = 0; k < 32; k = k + 1)
        phi[k] = fphi(k, pc1[pi[1:0]], pc2[pi[1:0]], px1[pi[1:0]], px2[pi[1:0]],
                      r_ctx, pt1[pi[1:0]], pt2[pi[1:0]],
                      pp1v[pi[1:0]], pp2v[pi[1:0]], ph2[pi[1:0]]);
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
      f_arvalid <= 1'b0; f_araddr <= '0;
      nc <= '0; fi <= '0; nf <= '0; ei <= '0; ej <= '0; np <= '0; pi <= '0;
      nupd <= '0; ndup <= '0; nbad <= '0; tocnt <= '0;
      r_subj <= '0; r_obj <= '0; r_rel <= '0; r_ctx <= '0;
      r_ovf <= 1'b0; r_neg <= 1'b0; r_amb <= 1'b0; r_two <= 1'b0; r_obj_v <= 1'b0;
      path_ovf <= 1'b0;
      r_st <= A7NG_F3R4_ST_UNKNOWN;
      txn <= 8'd0; pend_id <= 8'd0; gen <= 8'd0; pend_gen <= 8'd0;
      pend_acc <= 1'b0; pend_cmt <= 1'b0; retire_hold <= 1'b0; rew_lat <= '0;
      sel_idx <= '0; best_a <= '0; best_p0 <= '0; best_p1 <= '0;
      v_best <= '0; v_second <= '0;
      for (kf = 0; kf < 32; kf = kf + 1) pend_phi[kf] <= '0;
    end else begin
      qse_retire <= 1'b0; sgd_go <= 1'b0; sgd_upd <= 1'b0;
      unique case (st)
        S_IDLE: begin
          nc <= '0; fi <= '0; nf <= '0; np <= '0; tocnt <= '0;
          retire_hold <= 1'b0; f_arvalid <= 1'b0; path_ovf <= 1'b0;
          for (kf = 0; kf < 16; kf = kf + 1) fv[kf] <= 1'b0;
          best_a <= '0; best_p0 <= '0; best_p1 <= '0; v_best <= '0; v_second <= '0;
          r_st <= A7NG_F3R4_ST_UNKNOWN;
          if (qse_valid) begin
            r_subj <= qse_subj; r_obj <= qse_obj; r_rel <= qse_rel; r_ctx <= qse_ctx;
            r_two <= (qse_ctx == A7NG_F3R4_CTX_INDIRECT);
            r_obj_v <= (qse_obj != 8'd0);
            r_neg <= qse_neg; r_amb <= qse_amb; r_ovf <= 1'b0;
            path_ovf <= 1'b0;
            st <= S_WALK;
          end
        end
        S_WALK: begin
          if (cand_v && cand_ready && (nc < 5'd16)) begin
            cbuf[nc[3:0]] <= cand_id; nc <= nc + 1'b1;
          end
          if (w_done) begin
            r_ovf <= w_ovf; qse_retire <= 1'b1; fi <= '0;
            if (r_amb) begin r_st <= A7NG_F3R4_ST_AMB; st <= S_HOLD; end
            else if (r_neg) begin r_st <= A7NG_F3R4_ST_NEG; st <= S_HOLD; end
            else st <= (nc==0) ? S_HOLD : S_AR;
          end
        end
        S_AR: begin
          f_araddr <= FACT_BASE + {cbuf[fi[3:0]], 4'd0};
          f_arvalid <= 1'b1;
          tocnt <= tocnt + 16'd1;
          if (f_arready && f_arvalid) begin
            f_arvalid <= 1'b0; tocnt <= '0; st <= S_R;
          end else if (tocnt >= TO_CYC[15:0]) begin
            f_arvalid <= 1'b0; r_st <= A7NG_F3R4_ST_INCOMP; st <= S_HOLD;
          end
        end
        S_R: begin
          tocnt <= tocnt + 16'd1;
          if (f_rvalid) begin
            if ((m_axi_rid==A7NG_F3R4_FACT_RID) && (m_axi_rresp==A7NG_F3R4_RRESP_OK)
                && m_axi_rlast && (m_axi_rdata[75:72]==A7NG_F3R4_VER) && m_axi_rdata[70]
                && (m_axi_rdata[67:48]==cbuf[fi[3:0]]) && (nf < 5'd16)) begin
              fs[nf[3:0]] <= m_axi_rdata[19:0];
              fo[nf[3:0]] <= m_axi_rdata[39:20];
              fr[nf[3:0]] <= m_axi_rdata[47:40];
              fe[nf[3:0]] <= m_axi_rdata[67:48];
              ft[nf[3:0]] <= m_axi_rdata[68];
              fpv[nf[3:0]] <= m_axi_rdata[69];
              fcx[nf[3:0]] <= m_axi_rdata[83:76];
              fcf[nf[3:0]] <= m_axi_rdata[91:84];
              fv[nf[3:0]] <= 1'b1;
              nf <= nf + 1'b1;
            end
            tocnt <= '0;
            if (fi + 1'b1 == nc) begin ei <= '0; st <= S_EI; end
            else begin fi <= fi + 1'b1; st <= S_AR; end
          end else if (tocnt >= TO_CYC[15:0]) begin
            r_st <= A7NG_F3R4_ST_INCOMP; st <= S_HOLD;
          end
        end
        S_EI: begin
          if (r_ovf) begin r_st <= A7NG_F3R4_ST_INCOMP; st <= S_HOLD; end
          else if (ei >= nf) begin
            if (np == 0) begin r_st <= A7NG_F3R4_ST_UNKNOWN; st <= S_HOLD; end
            else if (path_ovf) begin r_st <= A7NG_F3R4_ST_INCOMP; st <= S_HOLD; end
            else begin pi <= '0; st <= S_SC; end
          end else if (r_two) begin ej <= '0; st <= S_EJ; end
          else st <= S_ED;
        end
        S_ED: begin
          if (fv[ei[3:0]]
              && (fr[ei[3:0]]==r_rel)
              && (fs[ei[3:0]]=={{12{1'b0}}, r_subj})
              && (fo[ei[3:0]] != {{12{1'b0}}, r_subj})
              && (!r_obj_v || (fo[ei[3:0]]=={{12{1'b0}}, r_obj}))
              && fpv[ei[3:0]]) begin
            if (np < MAX_PATH[4:0]) begin
              pp0[np[1:0]] <= fe[ei[3:0]];
              pp1[np[1:0]] <= 20'd0;
              pans[np[1:0]] <= fo[ei[3:0]];
              pc1[np[1:0]] <= fcf[ei[3:0]];
              pc2[np[1:0]] <= fcf[ei[3:0]];
              px1[np[1:0]] <= fcx[ei[3:0]];
              px2[np[1:0]] <= fcx[ei[3:0]];
              pt1[np[1:0]] <= ft[ei[3:0]];
              pt2[np[1:0]] <= 1'b0;
              pp1v[np[1:0]] <= fpv[ei[3:0]];
              pp2v[np[1:0]] <= fpv[ei[3:0]];
              ph2[np[1:0]] <= 1'b0;
              np <= np + 1'b1;
            end else path_ovf <= 1'b1;
          end
          ei <= ei + 1'b1;
          st <= S_EI;
        end
        S_EJ: begin
          if (ej >= nf) begin ei <= ei + 1'b1; st <= S_EI; end
          else begin
            if (fv[ei[3:0]] && fv[ej[3:0]] && ft[ei[3:0]] && ft[ej[3:0]]
                && fpv[ei[3:0]] && fpv[ej[3:0]]
                && (fr[ei[3:0]]==r_rel) && (fr[ej[3:0]]==r_rel)
                && (fs[ei[3:0]]=={{12{1'b0}}, r_subj})
                && (fs[ej[3:0]]==fo[ei[3:0]])
                && (fo[ej[3:0]] != {{12{1'b0}}, r_subj})
                && (!r_obj_v || (fo[ej[3:0]]=={{12{1'b0}}, r_obj}))) begin
              if (np < MAX_PATH[4:0]) begin
                pp0[np[1:0]] <= fe[ei[3:0]];
                pp1[np[1:0]] <= fe[ej[3:0]];
                pans[np[1:0]] <= fo[ej[3:0]];
                pc1[np[1:0]] <= fcf[ei[3:0]];
                pc2[np[1:0]] <= fcf[ej[3:0]];
                px1[np[1:0]] <= fcx[ei[3:0]];
                px2[np[1:0]] <= fcx[ej[3:0]];
                pt1[np[1:0]] <= ft[ei[3:0]];
                pt2[np[1:0]] <= ft[ej[3:0]];
                pp1v[np[1:0]] <= fpv[ei[3:0]];
                pp2v[np[1:0]] <= fpv[ej[3:0]];
                ph2[np[1:0]] <= 1'b1;
                np <= np + 1'b1;
              end else path_ovf <= 1'b1;
            end
            ej <= ej + 1'b1;
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
          v_best <= c_best_v; v_second <= c_second_v;
          best_a <= c_best_a; best_p0 <= c_best_p0; best_p1 <= c_best_p1;
          sel_idx <= c_best_idx;
          r_st <= A7NG_F3R4_ST_ANSWER;
          pend_id <= txn + 8'd1; txn <= txn + 8'd1;
          pend_gen <= gen + 8'd1; gen <= gen + 8'd1;
          pend_acc <= 1'b1; pend_cmt <= 1'b0;
          for (kf = 0; kf < 32; kf = kf + 1) pend_phi[kf] <= phis[c_best_idx][kf];
          st <= S_HOLD;
        end
        S_HOLD: begin
          f_arvalid <= 1'b0;
          if (rew_v_i) begin
            if (!pend_acc) nbad <= nbad + 16'd1;
            else if (rew_gen_i != pend_gen) nbad <= nbad + 16'd1;
            else if (rew_txn_i != pend_id) nbad <= nbad + 16'd1;
            else if ((rew_i < -4'sd3) || (rew_i > 4'sd3)) nbad <= nbad + 16'd1;
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
