// a7ng_astra_rtp_f2.sv — two legal proofs, rank BEFORE select, scalar reward AFTER.
// PROGRAM=NO. Does not retarget RTP-0/R1 pipes. LM06 not integrated.
`timescale 1ns / 1ps

module a7ng_astra_rtp_f2 #(
  parameter int unsigned N_FACT     = 16,
  parameter int unsigned N_PATH     = 4,
  parameter int unsigned ID_W       = 20,
  parameter int unsigned CAND_CAP   = 16,
  parameter logic [27:0] INDEX_BASE = 28'h0500_0000,
  parameter logic [27:0] FACT_BASE  = 28'h0580_0000
) (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [15:0] live_epoch_i,
  input  logic        tok_valid_i,
  output logic        tok_ready_o,
  input  logic [7:0]  tok_i,
  input  logic        fire_i,
  input  logic        retire_i,
  input  logic        freeze_i,
  input  logic        rew_v_i,
  input  logic signed [2:0] rew_i,
  output logic        busy_o,
  output logic        result_v_o,
  output logic        rew_ready_o,
  output logic [ID_W-1:0] ans_o,
  output logic [ID_W-1:0] proof0_o,
  output logic [ID_W-1:0] proof1_o,
  output logic [ID_W-1:0] mid_o,
  output logic [3:0]  n_path_o,
  output logic signed [15:0] v_sel_o,
  output logic signed [15:0] v_alt_o,
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
  localparam int unsigned CW = 4;
  localparam logic [3:0] VER = 4'd1;
  localparam logic [7:0] CTX_INDIRECT = 8'd2;

  typedef enum logic [3:0] {
    S_IDLE, S_WALK, S_AR, S_R, S_EI, S_EJ, S_SC, S_SW, S_PICK, S_HOLD, S_UPD, S_UW
  } st_t;
  st_t st;

  logic qse_tok_v, qse_tok_r, qse_fire, qse_retire, qse_valid, qse_busy, qse_acc;
  logic [7:0] qse_subj, qse_obj, qse_rel, qse_ctx;
  logic [1:0] qse_dir, qse_nhyp;
  logic qse_neg, qse_amb, qse_trip, qse_v0, qse_v1, qse_v2, qse_v3;
  logic [15:0] qse_k0, qse_k1, qse_k2, qse_k3, qse_nhost;
  logic [15:0] h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10;
  logic walk_ready, cand_v, cand_ready, w_done, w_ovf;
  logic [19:0] cand_id;
  logic [15:0] w_emit, w_dup, w_trunc, w_ndir, w_npost;
  logic [3:0] w_pmask;
  logic [3:0] sp_arid; logic [27:0] sp_araddr; logic [7:0] sp_arlen;
  logic [2:0] sp_arsize; logic [1:0] sp_arburst;
  logic sp_arvalid, sp_arready, sp_rready, sp_rlast, sp_rvalid;
  logic [3:0] sp_rid; logic [127:0] sp_rdata; logic [1:0] sp_rresp;
  logic fetch_mode, f_arvalid, f_arready, f_rready, f_rvalid;
  logic [27:0] f_araddr;
  logic [19:0] cbuf [0:15];
  logic [CW:0] nc, fi;
  logic [4:0]  nf, ei, ej, np, pi;
  logic [19:0] fs [0:15], fo [0:15], fe [0:15];
  logic [7:0]  fr [0:15];
  logic        ft [0:15], fpv [0:15], fv [0:15];
  logic [19:0] pp0 [0:3], pp1 [0:3], pans [0:3], pmid [0:3];
  logic signed [15:0] pv [0:3];
  logic [7:0] r_subj, r_rel;
  logic signed [7:0] phi [0:31];
  logic signed [7:0] xsel [0:31];
  logic sgd_ready, sgd_done, sgd_go, sgd_upd;
  logic signed [15:0] sgd_v;
  logic signed [15:0] best_v, alt_v;
  logic [19:0] best_a, best_p0, best_p1, best_m;
  logic signed [15:0] c_best_v, c_alt_v;
  logic [19:0] c_best_a, c_best_p0, c_best_p1, c_best_m;
  integer k, kf;

  assign load_from_tb_o = 1'b0;
  assign fetch_mode = (st==S_AR)||(st==S_R);
  assign m_axi_arid = fetch_mode ? 4'd2 : sp_arid;
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
  assign f_rready = 1'b1;
  assign qse_tok_v = tok_valid_i && (st==S_IDLE);
  assign qse_fire = fire_i && (st==S_IDLE);
  assign tok_ready_o = qse_tok_r && (st==S_IDLE);
  assign cand_ready = (st==S_WALK);
  assign busy_o = (st!=S_IDLE);
  assign result_v_o = (st==S_HOLD);
  assign rew_ready_o = (st==S_HOLD);
  assign ans_o = best_a;
  assign proof0_o = best_p0;
  assign proof1_o = best_p1;
  assign mid_o = best_m;
  assign n_path_o = np[3:0];
  assign v_sel_o = best_v;
  assign v_alt_o = alt_v;

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

  a7ng_shared_rank_sgd_q8 u_sgd (
    .clk(clk), .rst_n(rst_n), .freeze_i(freeze_i),
    .go_score_i(sgd_go), .go_upd_i(sgd_upd), .x_i(phi), .reward_i(rew_i),
    .ready_o(sgd_ready), .done_o(sgd_done), .v_q8_o(sgd_v)
  );

  always_comb begin
    for (k = 0; k < 32; k = k + 1) phi[k] = 8'sd0;
    if (st==S_SC || st==S_SW) begin
      phi[0] = (pmid[pi[1:0]] == 20'd1) ? 8'sd64 : 8'sd0;
      phi[1] = (pmid[pi[1:0]] == 20'd8) ? 8'sd64 : 8'sd0;
      phi[2] = 8'sd0;
    end else begin
      for (k = 0; k < 32; k = k + 1) phi[k] = xsel[k];
    end
    c_best_v = 16'sh8000; c_alt_v = 16'sh8000;
    c_best_a = '0; c_best_p0 = 20'hFFFFF; c_best_p1 = '0; c_best_m = '0;
    for (k = 0; k < 4; k = k + 1) begin
      if (k < np) begin
        if ((pv[k] > c_best_v) || ((pv[k]==c_best_v) && (pp0[k] < c_best_p0))) begin
          c_alt_v = c_best_v;
          c_best_v = pv[k]; c_best_a = pans[k]; c_best_p0 = pp0[k];
          c_best_p1 = pp1[k]; c_best_m = pmid[k];
        end else if (pv[k] < c_best_v)
          c_alt_v = pv[k];
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE; qse_retire <= 1'b0; sgd_go <= 1'b0; sgd_upd <= 1'b0;
      f_arvalid <= 1'b0; f_araddr <= '0;
      nc <= '0; fi <= '0; nf <= '0; ei <= '0; ej <= '0; np <= '0; pi <= '0;
      r_subj <= '0; r_rel <= '0;
      best_a <= '0; best_p0 <= '0; best_p1 <= '0; best_m <= '0;
      best_v <= '0; alt_v <= '0;
      for (kf = 0; kf < 32; kf = kf + 1) xsel[kf] <= '0;
    end else begin
      qse_retire <= 1'b0; sgd_go <= 1'b0; sgd_upd <= 1'b0;
      unique case (st)
        S_IDLE: begin
          nc <= '0; fi <= '0; nf <= '0; np <= '0;
          for (kf = 0; kf < 16; kf = kf + 1) fv[kf] <= 1'b0;
          if (qse_valid) begin
            r_subj <= qse_subj; r_rel <= qse_rel; st <= S_WALK;
          end
        end
        S_WALK: begin
          if (cand_v && cand_ready && (nc < 5'd16)) begin
            cbuf[nc[3:0]] <= cand_id; nc <= nc + 1'b1;
          end
          if (w_done) begin qse_retire <= 1'b1; fi <= '0; st <= (nc==0) ? S_HOLD : S_AR; end
        end
        S_AR: begin
          f_araddr <= FACT_BASE + {cbuf[fi[3:0]], 4'd0}; f_arvalid <= 1'b1;
          if (f_arready && f_arvalid) begin f_arvalid <= 1'b0; st <= S_R; end
        end
        S_R: begin
          if (f_rvalid) begin
            if ((m_axi_rid==4'd2) && (m_axi_rresp==2'b00) && m_axi_rlast
                && (m_axi_rdata[75:72]==VER) && m_axi_rdata[70]
                && (m_axi_rdata[67:48]==cbuf[fi[3:0]]) && (nf < 5'd16)) begin
              fs[nf[3:0]] <= m_axi_rdata[19:0];
              fo[nf[3:0]] <= m_axi_rdata[39:20];
              fr[nf[3:0]] <= m_axi_rdata[47:40];
              fe[nf[3:0]] <= m_axi_rdata[67:48];
              ft[nf[3:0]] <= m_axi_rdata[68];
              fpv[nf[3:0]] <= m_axi_rdata[69];
              fv[nf[3:0]] <= 1'b1;
              nf <= nf + 1'b1;
            end
            if (fi + 1'b1 == nc) begin ei <= '0; ej <= '0; np <= '0; st <= S_EI; end
            else begin fi <= fi + 1'b1; st <= S_AR; end
          end
        end
        S_EI: begin
          if (ei >= nf) begin pi <= '0; st <= (np==0) ? S_HOLD : S_SC; end
          else begin ej <= '0; st <= S_EJ; end
        end
        S_EJ: begin
          if (ej >= nf) begin ei <= ei + 1'b1; st <= S_EI; end
          else begin
            if (fv[ei[3:0]] && fv[ej[3:0]] && ft[ei[3:0]] && fpv[ei[3:0]] && fpv[ej[3:0]]
                && (fr[ei[3:0]]==r_rel) && (fr[ej[3:0]]==r_rel)
                && (fs[ei[3:0]]=={{12{1'b0}}, r_subj})
                && (fs[ej[3:0]]==fo[ei[3:0]])
                && (fo[ej[3:0]] != {{12{1'b0}}, r_subj})
                && (np < 5'd4)) begin
              pp0[np[1:0]] <= fe[ei[3:0]];
              pp1[np[1:0]] <= fe[ej[3:0]];
              pans[np[1:0]] <= fo[ej[3:0]];
              pmid[np[1:0]] <= fo[ei[3:0]];
              np <= np + 1'b1;
            end
            ej <= ej + 1'b1;
          end
        end
        S_SC: if (sgd_ready) begin sgd_go <= 1'b1; st <= S_SW; end
        S_SW: if (sgd_done) begin
          pv[pi[1:0]] <= sgd_v;
          if (pi + 1'b1 == np) st <= S_PICK;
          else begin pi <= pi + 1'b1; st <= S_SC; end
        end
        S_PICK: begin
          best_v <= c_best_v; alt_v <= c_alt_v;
          best_a <= c_best_a; best_p0 <= c_best_p0;
          best_p1 <= c_best_p1; best_m <= c_best_m;
          xsel[0] <= (c_best_m==20'd1) ? 8'sd64 : 8'sd0;
          xsel[1] <= (c_best_m==20'd8) ? 8'sd64 : 8'sd0;
          xsel[2] <= 8'sd0;
          st <= S_HOLD;
        end
        S_HOLD: begin
          if (rew_v_i && sgd_ready) begin sgd_upd <= 1'b1; st <= S_UW; end
          else if (retire_i) st <= S_IDLE;
        end
        S_UW: if (sgd_done) st <= S_HOLD;
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
