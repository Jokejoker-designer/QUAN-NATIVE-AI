// a7ng_astra_rtp_pipe.sv — RETRIEVAL_TO_PROOF_CAUSALITY. PROGRAM=NO.
// cand_id → AXI descriptor fetch → internal engine load → 2-hop proof.
// TB must not load_v the edge table as query authority.
// Does not retarget a7ng_astra09_pipe. LM06 not integrated.
`timescale 1ns / 1ps

module a7ng_astra_rtp_pipe #(
  parameter int unsigned N_EDGES    = 16,
  parameter int unsigned ID_W       = 8,
  parameter int unsigned WALK_ID_W  = 20,
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
  output logic        busy_o,
  output logic        result_v_o,
  output logic [7:0]  subj_id_o,
  output logic [7:0]  obj_id_o,
  output logic [7:0]  rel_id_o,
  output logic [7:0]  ctx_id_o,
  output logic [ID_W-1:0] ans_o,
  output logic [ID_W-1:0] proof0_o,
  output logic [ID_W-1:0] proof1_o,
  output logic [2:0]  status_o,
  output logic [7:0]  n_cand_o,
  output logic [7:0]  n_load_o,
  output logic [15:0] n_dir_ar_o,
  output logic [15:0] n_host_any_o,
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
  localparam logic [7:0] CTX_INDIRECT = 8'd2;
  localparam logic [2:0] ST_UNKNOWN   = 3'd1;

  typedef enum logic [3:0] {
    S_IDLE, S_WALK, S_CLR, S_AR, S_R, S_ISSUE, S_QWAIT, S_HOLD
  } st_t;
  st_t st;

  logic        qse_tok_v, qse_tok_r, qse_fire, qse_retire;
  logic        qse_busy, qse_acc, qse_valid;
  logic [7:0]  qse_subj, qse_obj, qse_rel, qse_ctx;
  logic [1:0]  qse_dir;
  logic        qse_neg, qse_amb, qse_trip;
  logic [1:0]  qse_nhyp;
  logic [15:0] qse_k0, qse_k1, qse_k2, qse_k3, qse_nhost;
  logic        qse_v0, qse_v1, qse_v2, qse_v3;
  logic [15:0] h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10;

  logic        walk_ready, cand_v, cand_ready, w_done, w_ovf;
  logic [WALK_ID_W-1:0] cand_id;
  logic [15:0] w_emit, w_dup, w_trunc, w_ndir, w_npost;
  logic [3:0]  w_pmask;

  logic [3:0]  sp_arid; logic [27:0] sp_araddr; logic [7:0] sp_arlen;
  logic [2:0]  sp_arsize; logic [1:0] sp_arburst;
  logic        sp_arvalid, sp_arready, sp_rready;
  logic [3:0]  sp_rid; logic [127:0] sp_rdata; logic [1:0] sp_rresp;
  logic        sp_rlast, sp_rvalid;

  logic        fetch_mode;
  logic [3:0]  f_arid; logic [27:0] f_araddr; logic [7:0] f_arlen;
  logic [2:0]  f_arsize; logic [1:0] f_arburst;
  logic        f_arvalid, f_arready, f_rready;
  logic        f_rvalid;

  logic [WALK_ID_W-1:0] cbuf [0:CAND_CAP-1];
  logic [4:0]  nc, fi, ci;
  logic [7:0]  nload;

  logic        eng_load, eng_clr, eng_qv, eng_ready, eng_ans_v;
  logic [3:0]  eng_lidx, eng_cidx;
  logic [ID_W-1:0] eng_s, eng_r, eng_o, eng_e, eng_ans, eng_p0, eng_p1;
  logic        eng_t, eng_p;
  logic [2:0]  eng_st;
  logic [7:0]  eng_scan;

  logic [7:0]  r_subj, r_obj, r_rel, r_ctx;
  logic        r_two, r_v0;
  logic [ID_W-1:0] r_ans, r_p0, r_p1;
  logic [2:0]  r_st;
  logic [15:0] r_ndir;
  logic [127:0] beat;

  assign load_from_tb_o = 1'b0;
  assign fetch_mode = (st == S_AR) || (st == S_R);

  assign m_axi_arid    = fetch_mode ? f_arid    : sp_arid;
  assign m_axi_araddr  = fetch_mode ? f_araddr  : sp_araddr;
  assign m_axi_arlen   = fetch_mode ? f_arlen   : sp_arlen;
  assign m_axi_arsize  = fetch_mode ? f_arsize  : sp_arsize;
  assign m_axi_arburst = fetch_mode ? f_arburst : sp_arburst;
  assign m_axi_arvalid = fetch_mode ? f_arvalid : sp_arvalid;
  assign sp_arready    = fetch_mode ? 1'b0 : m_axi_arready;
  assign f_arready     = fetch_mode ? m_axi_arready : 1'b0;
  assign sp_rid        = m_axi_rid;
  assign sp_rdata      = m_axi_rdata;
  assign sp_rresp      = m_axi_rresp;
  assign sp_rlast      = m_axi_rlast;
  assign sp_rvalid     = fetch_mode ? 1'b0 : m_axi_rvalid;
  assign f_rvalid      = fetch_mode ? m_axi_rvalid : 1'b0;
  assign m_axi_rready  = fetch_mode ? f_rready : sp_rready;

  assign qse_tok_v   = tok_valid_i && (st == S_IDLE);
  assign qse_fire    = fire_i && (st == S_IDLE);
  assign tok_ready_o = qse_tok_r && (st == S_IDLE);
  assign cand_ready  = (st == S_WALK);
  assign busy_o      = (st != S_IDLE);
  assign result_v_o  = (st == S_HOLD);
  assign subj_id_o   = r_subj;
  assign obj_id_o    = r_obj;
  assign rel_id_o    = r_rel;
  assign ctx_id_o    = r_ctx;
  assign ans_o       = r_ans;
  assign proof0_o    = r_p0;
  assign proof1_o    = r_p1;
  assign status_o    = r_st;
  assign n_cand_o    = {3'd0, nc};
  assign n_load_o    = nload;
  assign n_dir_ar_o  = r_ndir;
  assign n_host_any_o = qse_nhost;

  assign f_arid    = 4'd2;
  assign f_arlen   = 8'd0;
  assign f_arsize  = 3'd4;
  assign f_arburst = 2'b01;
  assign f_rready  = 1'b1;

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

  a7ng_rel_engine_2hop #(.N_EDGES(N_EDGES), .ID_W(ID_W)) u_eng (
    .clk(clk), .rst_n(rst_n),
    .load_v(eng_load), .load_idx(eng_lidx),
    .load_s(eng_s), .load_r(eng_r), .load_o(eng_o), .load_eid(eng_e),
    .load_trans(eng_t), .load_pol(eng_p),
    .clr_v(eng_clr), .clr_idx(eng_cidx),
    .q_v(eng_qv), .q_s(r_subj), .q_r(r_rel), .q_o(r_obj),
    .q_obj_valid(r_obj != 8'd0), .q_two_hop(r_two),
    .q_budget(8'd0), .q_max_hop(4'd0),
    .q_ready(eng_ready), .ans_v(eng_ans_v), .ans_o(eng_ans),
    .proof0(eng_p0), .proof1(eng_p1), .status_o(eng_st), .scan_used_o(eng_scan)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      qse_retire <= 1'b0;
      eng_load <= 1'b0; eng_clr <= 1'b0; eng_qv <= 1'b0;
      eng_lidx <= '0; eng_cidx <= '0;
      eng_s <= '0; eng_r <= '0; eng_o <= '0; eng_e <= '0;
      eng_t <= 1'b1; eng_p <= 1'b1;
      f_arvalid <= 1'b0; f_araddr <= '0;
      nc <= '0; fi <= '0; ci <= '0; nload <= '0;
      r_subj <= '0; r_obj <= '0; r_rel <= '0; r_ctx <= '0;
      r_two <= 1'b0; r_v0 <= 1'b0;
      r_ans <= '0; r_p0 <= '0; r_p1 <= '0; r_st <= ST_UNKNOWN;
      r_ndir <= '0; beat <= '0;
    end else begin
      qse_retire <= 1'b0;
      eng_load <= 1'b0;
      eng_clr <= 1'b0;
      eng_qv <= 1'b0;
      unique case (st)
        S_IDLE: begin
          nc <= '0; fi <= '0; ci <= '0; nload <= '0;
          f_arvalid <= 1'b0;
          if (qse_valid) begin
            r_subj <= qse_subj; r_obj <= qse_obj;
            r_rel <= qse_rel; r_ctx <= qse_ctx;
            r_two <= (qse_ctx == CTX_INDIRECT);
            r_v0 <= qse_v0;
            r_ans <= '0; r_p0 <= '0; r_p1 <= '0; r_st <= ST_UNKNOWN;
            st <= S_WALK;
          end
        end
        S_WALK: begin
          if (cand_v && cand_ready && (nc < CAND_CAP[4:0])) begin
            cbuf[nc] <= cand_id;
            nc <= nc + 5'd1;
          end
          if (w_done) begin
            r_ndir <= w_ndir;
            qse_retire <= 1'b1;
            ci <= '0;
            st <= S_CLR;
          end
        end
        S_CLR: begin
          eng_clr <= 1'b1;
          eng_cidx <= ci[3:0];
          if (ci == 5'd15) begin
            fi <= '0;
            st <= (nc == 5'd0) ? S_ISSUE : S_AR;
          end else
            ci <= ci + 5'd1;
        end
        S_AR: begin
          f_araddr <= FACT_BASE + {cbuf[fi], 4'd0};
          f_arvalid <= 1'b1;
          if (f_arready && f_arvalid) begin
            f_arvalid <= 1'b0;
            st <= S_R;
          end
        end
        S_R: begin
          if (f_rvalid) begin
            beat <= m_axi_rdata;
            if (m_axi_rdata[34]) begin
              eng_load <= 1'b1;
              eng_lidx <= nload[3:0];
              eng_s <= m_axi_rdata[7:0];
              eng_r <= m_axi_rdata[15:8];
              eng_o <= m_axi_rdata[23:16];
              eng_e <= m_axi_rdata[31:24];
              eng_t <= m_axi_rdata[32];
              eng_p <= m_axi_rdata[33];
              nload <= nload + 8'd1;
            end
            if (fi + 5'd1 == nc)
              st <= S_ISSUE;
            else begin
              fi <= fi + 5'd1;
              st <= S_AR;
            end
          end
        end
        S_ISSUE: begin
          if (!r_v0) begin
            r_st <= ST_UNKNOWN;
            st <= S_HOLD;
          end else if (eng_ready) begin
            eng_qv <= 1'b1;
            st <= S_QWAIT;
          end
        end
        S_QWAIT: begin
          if (eng_ans_v) begin
            r_ans <= eng_ans; r_p0 <= eng_p0; r_p1 <= eng_p1; r_st <= eng_st;
            st <= S_HOLD;
          end
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
