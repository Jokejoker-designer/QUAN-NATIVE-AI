// a7ng_astra09_pipe.sv — ASTRA-09 + SPARSE09_GLUE. PROGRAM=NO.
// raw bytes → qse-v2-role-00 (LAW_SEL=1) → 4×4096 AXI sparse walk → 2-hop → frozen rank → proof.
// Walker is on the exam path. 2-hop still uses loaded edges, not walker IDs as answers.
// Host must not supply subject/object/winner/answer. poke_v_i tied off.
// qse-v1 keys UNCHANGED. LM06 composer is datapath only (LANGUAGE_UNPROVEN).
`timescale 1ns / 1ps

module a7ng_astra09_pipe #(
  parameter int unsigned N_EDGES   = 16,
  parameter int unsigned ID_W      = 8,
  parameter int unsigned WALK_ID_W = 20,
  parameter int unsigned CAND_CAP  = 16,
  parameter logic [27:0] INDEX_BASE = 28'h0500_0000
) (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        freeze_i,
  input  logic [15:0] live_epoch_i,
  input  logic        tok_valid_i,
  output logic        tok_ready_o,
  input  logic [7:0]  tok_i,
  input  logic        fire_i,
  input  logic        retire_i,
  input  logic        load_v,
  input  logic [3:0]  load_idx,
  input  logic [ID_W-1:0] load_s,
  input  logic [ID_W-1:0] load_r,
  input  logic [ID_W-1:0] load_o,
  input  logic [ID_W-1:0] load_eid,
  input  logic        load_trans,
  input  logic        load_pol,
  input  logic        clr_v,
  input  logic [3:0]  clr_idx,
  output logic        busy_o,
  output logic        result_v_o,
  output logic        pkt_valid_o,
  output logic [7:0]  subj_id_o,
  output logic [7:0]  obj_id_o,
  output logic [7:0]  rel_id_o,
  output logic [7:0]  ctx_id_o,
  output logic [1:0]  direction_o,
  output logic        triple_valid_o,
  output logic        two_hop_o,
  output logic [15:0] k0_o,
  output logic [15:0] k1_o,
  output logic [15:0] k2_o,
  output logic [15:0] k3_o,
  output logic        k0_valid_o,
  output logic        k1_valid_o,
  output logic        k2_valid_o,
  output logic        k3_valid_o,
  output logic [ID_W-1:0] ans_o,
  output logic [ID_W-1:0] proof0_o,
  output logic [ID_W-1:0] proof1_o,
  output logic [2:0]  status_o,
  output logic signed [15:0] v_q8_o,
  output logic        out_tok_v_o,
  output logic [7:0]  out_tok_o,
  output logic        out_done_o,
  output logic [7:0]  n_out_tok_o,
  output logic        eng_skip_o,
  output logic [15:0] n_dir_ar_o,
  output logic [15:0] n_post_ar_o,
  output logic [15:0] n_emit_o,
  output logic [3:0]  probed_mask_o,
  output logic [15:0] n_host_entity_o,
  output logic [15:0] n_host_intent_o,
  output logic [15:0] n_host_hash_o,
  output logic [15:0] n_host_shard_o,
  output logic [15:0] n_host_bucket_o,
  output logic [15:0] n_host_cand_o,
  output logic [15:0] n_host_winner_o,
  output logic [15:0] n_host_addr_o,
  output logic [15:0] n_host_relpath_o,
  output logic [15:0] n_host_next_o,
  output logic [15:0] n_host_answer_o,
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
  localparam logic [7:0] CTX_INDIRECT = 8'd2;
  localparam logic [2:0] ST_UNKNOWN   = 3'd1;

  typedef enum logic [3:0] {
    S_IDLE, S_WALK, S_ISSUE, S_QWAIT, S_SCORE_GO, S_SCORE_W, S_COMP_GO, S_COMP_W, S_HOLD
  } st_t;
  st_t st;

  logic        qse_tok_v, qse_tok_r, qse_fire, qse_retire;
  logic        qse_busy, qse_acc, qse_valid;
  logic [7:0]  qse_subj, qse_obj, qse_rel, qse_ctx;
  logic [1:0]  qse_dir, qse_nhyp;
  logic        qse_neg, qse_amb, qse_trip;
  logic [15:0] qse_k0, qse_k1, qse_k2, qse_k3, qse_nhost;
  logic        qse_v0, qse_v1, qse_v2, qse_v3;
  logic [15:0] h_ent, h_int, h_hash, h_sh, h_bkt, h_cand, h_win, h_addr, h_rel, h_nxt, h_ans;

  logic        walk_ready, cand_v, cand_ready, w_done, w_ovf;
  logic [WALK_ID_W-1:0] cand_id;
  logic [15:0] w_emit, w_dup, w_trunc, w_ndir, w_npost;
  logic [3:0]  w_pmask;

  logic        eng_load, eng_clr, eng_qv, eng_ready, eng_ans_v;
  logic [ID_W-1:0] eng_ans, eng_p0, eng_p1;
  logic [2:0]  eng_st;
  logic [7:0]  eng_scan;

  logic        sgd_ready, sgd_done, sgd_go;
  logic signed [15:0] sgd_v;
  logic signed [7:0]  phi [0:31];

  logic        cmp_start, cmp_busy, cmp_tok_v, cmp_done, cmp_lm;
  logic [7:0]  cmp_tok;

  logic [7:0]  r_subj, r_obj, r_rel, r_ctx;
  logic [1:0]  r_dir;
  logic        r_trip, r_v0, r_v1, r_v2, r_v3, r_two, r_skip;
  logic [15:0] r_k0, r_k1, r_k2, r_k3, r_ndir, r_npost, r_nemit;
  logic [3:0]  r_pmask;
  logic [ID_W-1:0] r_ans, r_p0, r_p1;
  logic [2:0]  r_st;
  logic signed [15:0] r_vq8;
  logic [7:0]  r_ntok;
  integer      fi;

  assign qse_tok_v   = tok_valid_i && (st == S_IDLE);
  assign qse_fire    = fire_i && (st == S_IDLE);
  assign tok_ready_o = qse_tok_r && (st == S_IDLE);
  assign eng_load    = load_v && (st == S_IDLE);
  assign eng_clr     = clr_v && (st == S_IDLE);
  assign cand_ready  = 1'b1;
  assign busy_o      = (st != S_IDLE);
  assign result_v_o  = (st == S_HOLD);
  assign pkt_valid_o = (st != S_IDLE);
  assign subj_id_o   = r_subj;
  assign obj_id_o    = r_obj;
  assign rel_id_o    = r_rel;
  assign ctx_id_o    = r_ctx;
  assign direction_o = r_dir;
  assign triple_valid_o = r_trip;
  assign two_hop_o   = r_two;
  assign k0_o        = r_k0;
  assign k1_o        = r_k1;
  assign k2_o        = r_k2;
  assign k3_o        = r_k3;
  assign k0_valid_o  = r_v0;
  assign k1_valid_o  = r_v1;
  assign k2_valid_o  = r_v2;
  assign k3_valid_o  = r_v3;
  assign ans_o       = r_ans;
  assign proof0_o    = r_p0;
  assign proof1_o    = r_p1;
  assign status_o    = r_st;
  assign v_q8_o      = r_vq8;
  assign out_tok_v_o = cmp_tok_v;
  assign out_tok_o   = cmp_tok;
  assign out_done_o  = cmp_done;
  assign n_out_tok_o = r_ntok;
  assign eng_skip_o  = r_skip;
  assign n_dir_ar_o  = r_ndir;
  assign n_post_ar_o = r_npost;
  assign n_emit_o    = r_nemit;
  assign probed_mask_o = r_pmask;
  assign n_host_entity_o  = h_ent;
  assign n_host_intent_o  = h_int;
  assign n_host_hash_o    = h_hash;
  assign n_host_shard_o   = h_sh;
  assign n_host_bucket_o  = h_bkt;
  assign n_host_cand_o    = h_cand;
  assign n_host_winner_o  = h_win;
  assign n_host_addr_o    = h_addr;
  assign n_host_relpath_o = h_rel;
  assign n_host_next_o    = h_nxt;
  assign n_host_answer_o  = h_ans;

  a7ng_query_axi_sparse #(
    .N_TABLES(4), .N_BUCKETS(4096), .CAND_CAP(CAND_CAP),
    .ID_W(WALK_ID_W), .INDEX_BASE(INDEX_BASE), .LAW_SEL(1)
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
    .k0_valid_o(qse_v0), .k1_valid_o(qse_v1),
    .k2_valid_o(qse_v2), .k3_valid_o(qse_v3),
    .direction_o(qse_dir), .negation_o(qse_neg), .ambiguity_o(qse_amb),
    .triple_valid_o(qse_trip), .n_hyp_o(qse_nhyp),
    .n_host_any_o(qse_nhost),
    .n_host_entity_o(h_ent), .n_host_intent_o(h_int), .n_host_hash_o(h_hash),
    .n_host_shard_o(h_sh), .n_host_bucket_o(h_bkt), .n_host_cand_o(h_cand),
    .n_host_winner_o(h_win), .n_host_addr_o(h_addr), .n_host_relpath_o(h_rel),
    .n_host_next_o(h_nxt), .n_host_answer_o(h_ans),
    .walk_ready_o(walk_ready),
    .cand_v(cand_v), .cand_ready(cand_ready), .cand_id(cand_id),
    .q_done(w_done), .q_overflow_o(w_ovf),
    .n_emit_o(w_emit), .n_dup_o(w_dup), .n_trunc_o(w_trunc),
    .n_dir_ar_o(w_ndir), .n_post_ar_o(w_npost), .probed_mask_o(w_pmask),
    .m_axi_arid(m_axi_arid), .m_axi_araddr(m_axi_araddr), .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize), .m_axi_arburst(m_axi_arburst),
    .m_axi_arvalid(m_axi_arvalid), .m_axi_arready(m_axi_arready),
    .m_axi_rid(m_axi_rid), .m_axi_rdata(m_axi_rdata), .m_axi_rresp(m_axi_rresp),
    .m_axi_rlast(m_axi_rlast), .m_axi_rvalid(m_axi_rvalid), .m_axi_rready(m_axi_rready)
  );

  a7ng_rel_engine_2hop #(.N_EDGES(N_EDGES), .ID_W(ID_W)) u_eng (
    .clk(clk), .rst_n(rst_n),
    .load_v(eng_load), .load_idx(load_idx),
    .load_s(load_s), .load_r(load_r), .load_o(load_o), .load_eid(load_eid),
    .load_trans(load_trans), .load_pol(load_pol),
    .clr_v(eng_clr), .clr_idx(clr_idx),
    .q_v(eng_qv), .q_s(r_subj), .q_r(r_rel), .q_o(r_obj),
    .q_obj_valid(r_v1), .q_two_hop(r_two),
    .q_budget(8'd0), .q_max_hop(4'd0),
    .q_ready(eng_ready), .ans_v(eng_ans_v), .ans_o(eng_ans),
    .proof0(eng_p0), .proof1(eng_p1), .status_o(eng_st), .scan_used_o(eng_scan)
  );

  a7ng_shared_rank_sgd_q8 u_sgd (
    .clk(clk), .rst_n(rst_n), .freeze_i(freeze_i),
    .go_score_i(sgd_go), .go_upd_i(1'b0), .x_i(phi), .reward_i(3'sd0),
    .ready_o(sgd_ready), .done_o(sgd_done), .v_q8_o(sgd_v)
  );

  a7ng_evidence_compose u_cmp (
    .clk(clk), .rst_n(rst_n), .start_i(cmp_start),
    .evid_id0_i({8'd0, r_subj, r_rel, r_obj}),
    .evid_id1_i({16'd0, r_p0, r_p1}),
    .evid_id2_i({16'd0, r_vq8}),
    .entity_i(r_ans[7:0]), .intent_i({5'd0, r_st}),
    .busy_o(cmp_busy), .tok_valid_o(cmp_tok_v), .tok_o(cmp_tok),
    .done_o(cmp_done), .lm_path_active_o(cmp_lm)
  );

  always_comb begin
    for (fi = 0; fi < 32; fi = fi + 1)
      phi[fi] = 8'sd0;
    phi[0]  = r_v0 ? 8'sd64 : 8'sd0;
    phi[1]  = r_v1 ? 8'sd64 : 8'sd0;
    phi[2]  = (r_rel != 8'd0) ? 8'sd64 : 8'sd0;
    phi[3]  = 8'sd64;
    phi[4]  = (r_ctx != 8'd0) ? 8'sd32 : 8'sd0;
    phi[5]  = 8'sd64;
    phi[6]  = (r_st == 3'd0) ? 8'sd64 : 8'sd0;
    phi[7]  = (r_st == 3'd5) ? 8'sd64 : 8'sd0;
    phi[8]  = r_two ? 8'sd2 : 8'sd1;
    phi[9]  = (r_st == 3'd0) ? 8'sd64 : 8'sd0;
    phi[10] = (r_st == 3'd5) ? 8'sd64 : 8'sd0;
    phi[11] = 8'sd32;
    phi[12] = ((r_rel != 8'd0) && (r_ctx != 8'd0)) ? 8'sd32 : 8'sd0;
    phi[13] = r_v0 ? 8'sd32 : 8'sd0;
    phi[14] = (r_v0 && r_v1) ? 8'sd32 : 8'sd0;
    phi[15] = (r_st == 3'd0) ? 8'sd64 : 8'sd0;
    phi[16] = (r_two && (r_p1 != {ID_W{1'b0}}) && (r_st == 3'd0)) ? 8'sd64 : 8'sd0;
    phi[19] = (r_p0 != {ID_W{1'b0}}) ? 8'sd64 : 8'sd0;
    phi[20] = (r_p1 != {ID_W{1'b0}}) ? 8'sd64 : 8'sd0;
    phi[21] = 8'sd32;
    phi[22] = 8'sd32;
    phi[25] = (r_st == 3'd6) ? 8'sd64 : 8'sd0;
    phi[26] = ((r_st == 3'd2) || (r_st == 3'd3)) ? 8'sd64 : 8'sd0;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      qse_retire <= 1'b0;
      eng_qv <= 1'b0;
      sgd_go <= 1'b0;
      cmp_start <= 1'b0;
      r_subj <= '0; r_obj <= '0; r_rel <= '0; r_ctx <= '0;
      r_dir <= 2'd0; r_trip <= 1'b0;
      r_v0 <= 1'b0; r_v1 <= 1'b0; r_v2 <= 1'b0; r_v3 <= 1'b0;
      r_two <= 1'b0; r_skip <= 1'b0;
      r_k0 <= '0; r_k1 <= '0; r_k2 <= '0; r_k3 <= '0;
      r_ndir <= '0; r_npost <= '0; r_nemit <= '0; r_pmask <= '0;
      r_ans <= '0; r_p0 <= '0; r_p1 <= '0; r_st <= ST_UNKNOWN;
      r_vq8 <= '0; r_ntok <= 8'd0;
    end else begin
      qse_retire <= 1'b0;
      eng_qv <= 1'b0;
      sgd_go <= 1'b0;
      cmp_start <= 1'b0;
      if (cmp_tok_v)
        r_ntok <= r_ntok + 8'd1;
      unique case (st)
        S_IDLE: begin
          if (qse_valid) begin
            r_subj <= qse_subj; r_obj <= qse_obj; r_rel <= qse_rel; r_ctx <= qse_ctx;
            r_dir <= qse_dir; r_trip <= qse_trip;
            r_v0 <= qse_v0; r_v1 <= qse_v1; r_v2 <= qse_v2; r_v3 <= qse_v3;
            r_k0 <= qse_k0; r_k1 <= qse_k1; r_k2 <= qse_k2; r_k3 <= qse_k3;
            r_two <= (qse_ctx == CTX_INDIRECT);
            r_skip <= 1'b0;
            r_ans <= '0; r_p0 <= '0; r_p1 <= '0; r_st <= ST_UNKNOWN;
            r_vq8 <= '0; r_ntok <= 8'd0;
            r_ndir <= '0; r_npost <= '0; r_nemit <= '0; r_pmask <= '0;
            st <= S_WALK;
          end
        end
        S_WALK: begin
          if (w_done) begin
            r_ndir <= w_ndir;
            r_npost <= w_npost;
            r_nemit <= w_emit;
            r_pmask <= w_pmask;
            qse_retire <= 1'b1;
            st <= S_ISSUE;
          end
        end
        S_ISSUE: begin
          if (!r_v0) begin
            r_skip <= 1'b1;
            r_st <= ST_UNKNOWN;
            r_ans <= '0; r_p0 <= '0; r_p1 <= '0;
            st <= S_SCORE_GO;
          end else if (eng_ready) begin
            eng_qv <= 1'b1;
            st <= S_QWAIT;
          end
        end
        S_QWAIT: begin
          if (eng_ans_v) begin
            r_ans <= eng_ans; r_p0 <= eng_p0; r_p1 <= eng_p1; r_st <= eng_st;
            st <= S_SCORE_GO;
          end
        end
        S_SCORE_GO: begin
          if (sgd_ready) begin
            sgd_go <= 1'b1;
            st <= S_SCORE_W;
          end
        end
        S_SCORE_W: begin
          if (sgd_done) begin
            r_vq8 <= sgd_v;
            st <= S_COMP_GO;
          end
        end
        S_COMP_GO: begin
          cmp_start <= 1'b1;
          st <= S_COMP_W;
        end
        S_COMP_W: begin
          if (cmp_done)
            st <= S_HOLD;
        end
        S_HOLD: begin
          if (retire_i)
            st <= S_IDLE;
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
