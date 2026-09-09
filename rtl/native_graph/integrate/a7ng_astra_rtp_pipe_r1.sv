// a7ng_astra_rtp_pipe_r1.sv — RTP-R1. PROGRAM=NO.
// Original a7ng_astra_rtp_pipe.sv is frozen PASS_NARROW; this revision only.
// Fetch: RID/RRESP/RLAST/timeout. rtp-desc-v1 20-bit IDs. ovf/neg/amb → status.
`timescale 1ns / 1ps

module a7ng_astra_rtp_pipe_r1 #(
  parameter int unsigned N_EDGES    = 16,
  parameter int unsigned ID_W       = 20,
  parameter int unsigned WALK_ID_W  = 20,
  parameter int unsigned CAND_CAP   = 16,
  parameter int unsigned TO_CYC     = 64,
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
  output logic [3:0]  status_o,
  output logic [7:0]  n_cand_o,
  output logic [7:0]  n_load_o,
  output logic [15:0] n_fact_ar_o,
  output logic [15:0] n_fact_ok_o,
  output logic [15:0] n_fact_err_o,
  output logic [15:0] n_fact_to_o,
  output logic [15:0] n_dir_ar_o,
  output logic [15:0] n_host_any_o,
  output logic        ovf_o,
  output logic        neg_o,
  output logic        amb_o,
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
  localparam logic [3:0] ST_UNKNOWN = 4'd1;
  localparam logic [3:0] ST_INCOMP  = 4'd6;
  localparam logic [3:0] ST_AMB     = 4'd7;
  localparam logic [3:0] ST_NEG     = 4'd8;
  localparam logic [3:0] VER        = 4'd1;
  localparam int unsigned CW = (CAND_CAP <= 1) ? 1 : $clog2(CAND_CAP);

  typedef enum logic [3:0] {
    S_IDLE, S_WALK, S_CLR, S_AR, S_R, S_ISSUE, S_QWAIT, S_HOLD
  } st_t;
  st_t st;

  logic qse_tok_v, qse_tok_r, qse_fire, qse_retire;
  logic qse_busy, qse_acc, qse_valid;
  logic [7:0] qse_subj, qse_obj, qse_rel, qse_ctx;
  logic [1:0] qse_dir, qse_nhyp;
  logic qse_neg, qse_amb, qse_trip;
  logic [15:0] qse_k0, qse_k1, qse_k2, qse_k3, qse_nhost;
  logic qse_v0, qse_v1, qse_v2, qse_v3;
  logic [15:0] h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10;
  logic walk_ready, cand_v, cand_ready, w_done, w_ovf;
  logic [WALK_ID_W-1:0] cand_id;
  logic [15:0] w_emit, w_dup, w_trunc, w_ndir, w_npost;
  logic [3:0] w_pmask;

  logic [3:0] sp_arid; logic [27:0] sp_araddr; logic [7:0] sp_arlen;
  logic [2:0] sp_arsize; logic [1:0] sp_arburst;
  logic sp_arvalid, sp_arready, sp_rready, sp_rlast, sp_rvalid;
  logic [3:0] sp_rid; logic [127:0] sp_rdata; logic [1:0] sp_rresp;

  logic fetch_mode, f_arvalid, f_arready, f_rready, f_rvalid;
  logic [27:0] f_araddr;
  logic [WALK_ID_W-1:0] cbuf [0:CAND_CAP-1];
  logic [CW:0] nc, fi, ci;
  logic [7:0] nload;
  logic [15:0] nfar, nfok, nferr, nfto, tocnt;
  logic r_ovf, r_neg, r_amb, r_axi, r_two, r_v0;
  logic [7:0] r_subj, r_obj, r_rel, r_ctx;
  logic [ID_W-1:0] r_ans, r_p0, r_p1;
  logic [3:0] r_st;
  logic [15:0] r_ndir;

  logic eng_load, eng_clr, eng_qv, eng_ready, eng_ans_v;
  logic [3:0] eng_lidx, eng_cidx;
  logic [ID_W-1:0] eng_s, eng_o, eng_e, eng_ans, eng_p0, eng_p1;
  logic [7:0] eng_r, eng_scan;
  logic eng_t, eng_p;
  logic [2:0] eng_st;

  logic beat_ok;
  logic [ID_W-1:0] want_id;

  assign load_from_tb_o = 1'b0;
  assign fetch_mode = (st == S_AR) || (st == S_R);
  assign m_axi_arid    = fetch_mode ? 4'd2 : sp_arid;
  assign m_axi_araddr  = fetch_mode ? f_araddr : sp_araddr;
  assign m_axi_arlen   = fetch_mode ? 8'd0 : sp_arlen;
  assign m_axi_arsize  = fetch_mode ? 3'd4 : sp_arsize;
  assign m_axi_arburst = fetch_mode ? 2'b01 : sp_arburst;
  assign m_axi_arvalid = fetch_mode ? f_arvalid : sp_arvalid;
  assign sp_arready    = fetch_mode ? 1'b0 : m_axi_arready;
  assign f_arready     = fetch_mode ? m_axi_arready : 1'b0;
  assign sp_rid   = m_axi_rid;
  assign sp_rdata = m_axi_rdata;
  assign sp_rresp = m_axi_rresp;
  assign sp_rlast = m_axi_rlast;
  assign sp_rvalid = fetch_mode ? 1'b0 : m_axi_rvalid;
  assign f_rvalid  = fetch_mode ? m_axi_rvalid : 1'b0;
  assign m_axi_rready = fetch_mode ? f_rready : sp_rready;
  assign f_rready = 1'b1;

  assign qse_tok_v = tok_valid_i && (st == S_IDLE);
  assign qse_fire  = fire_i && (st == S_IDLE);
  assign tok_ready_o = qse_tok_r && (st == S_IDLE);
  assign cand_ready = (st == S_WALK);
  assign busy_o = (st != S_IDLE);
  assign result_v_o = (st == S_HOLD);
  assign subj_id_o = r_subj;
  assign obj_id_o  = r_obj;
  assign rel_id_o  = r_rel;
  assign ctx_id_o  = r_ctx;
  assign ans_o     = r_ans;
  assign proof0_o  = r_p0;
  assign proof1_o  = r_p1;
  assign status_o  = r_st;
  assign n_cand_o  = {3'd0, nc[4:0]};
  assign n_load_o  = nload;
  assign n_fact_ar_o = nfar;
  assign n_fact_ok_o = nfok;
  assign n_fact_err_o = nferr;
  assign n_fact_to_o = nfto;
  assign n_dir_ar_o = r_ndir;
  assign n_host_any_o = qse_nhost;
  assign ovf_o = r_ovf;
  assign neg_o = r_neg;
  assign amb_o = r_amb;

  assign want_id = cbuf[fi[CW-1:0]];
  assign beat_ok = f_rvalid
                && (m_axi_rid == 4'd2)
                && (m_axi_rresp == 2'b00)
                && m_axi_rlast
                && (m_axi_rdata[75:72] == VER)
                && m_axi_rdata[70]
                && (m_axi_rdata[67:48] == want_id);

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
    .load_s(eng_s), .load_r({{(ID_W-8){1'b0}}, eng_r}), .load_o(eng_o), .load_eid(eng_e),
    .load_trans(eng_t), .load_pol(eng_p),
    .clr_v(eng_clr), .clr_idx(eng_cidx),
    .q_v(eng_qv),
    .q_s({{(ID_W-8){1'b0}}, r_subj}),
    .q_r({{(ID_W-8){1'b0}}, r_rel}),
    .q_o({{(ID_W-8){1'b0}}, r_obj}),
    .q_obj_valid(r_obj != 8'd0), .q_two_hop(r_two),
    .q_budget(8'd0), .q_max_hop(4'd0),
    .q_ready(eng_ready), .ans_v(eng_ans_v), .ans_o(eng_ans),
    .proof0(eng_p0), .proof1(eng_p1), .status_o(eng_st), .scan_used_o(eng_scan)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE; qse_retire <= 1'b0;
      eng_load <= 1'b0; eng_clr <= 1'b0; eng_qv <= 1'b0;
      eng_lidx <= '0; eng_cidx <= '0;
      eng_s <= '0; eng_r <= '0; eng_o <= '0; eng_e <= '0;
      eng_t <= 1'b1; eng_p <= 1'b1;
      f_arvalid <= 1'b0; f_araddr <= '0;
      nc <= '0; fi <= '0; ci <= '0; nload <= '0;
      nfar <= '0; nfok <= '0; nferr <= '0; nfto <= '0; tocnt <= '0;
      r_subj <= '0; r_obj <= '0; r_rel <= '0; r_ctx <= '0;
      r_two <= 1'b0; r_v0 <= 1'b0; r_ovf <= 1'b0; r_neg <= 1'b0; r_amb <= 1'b0; r_axi <= 1'b0;
      r_ans <= '0; r_p0 <= '0; r_p1 <= '0; r_st <= ST_UNKNOWN; r_ndir <= '0;
    end else begin
      qse_retire <= 1'b0; eng_load <= 1'b0; eng_clr <= 1'b0; eng_qv <= 1'b0;
      unique case (st)
        S_IDLE: begin
          nc <= '0; fi <= '0; ci <= '0; nload <= '0;
          nfar <= '0; nfok <= '0; nferr <= '0; nfto <= '0; tocnt <= '0;
          f_arvalid <= 1'b0; r_axi <= 1'b0;
          if (qse_valid) begin
            r_subj <= qse_subj; r_obj <= qse_obj; r_rel <= qse_rel; r_ctx <= qse_ctx;
            r_two <= (qse_ctx == CTX_INDIRECT); r_v0 <= qse_v0;
            r_neg <= qse_neg; r_amb <= qse_amb; r_ovf <= 1'b0;
            r_ans <= '0; r_p0 <= '0; r_p1 <= '0; r_st <= ST_UNKNOWN;
            st <= S_WALK;
          end
        end
        S_WALK: begin
          if (cand_v && cand_ready && (nc < CAND_CAP[CW:0])) begin
            cbuf[nc[CW-1:0]] <= cand_id;
            nc <= nc + 1'b1;
          end
          if (w_done) begin
            r_ndir <= w_ndir; r_ovf <= w_ovf;
            qse_retire <= 1'b1; ci <= '0; st <= S_CLR;
          end
        end
        S_CLR: begin
          eng_clr <= 1'b1; eng_cidx <= ci[3:0];
          if (ci[3:0] == 4'd15) begin
            fi <= '0;
            if (r_amb) begin r_st <= ST_AMB; st <= S_HOLD; end
            else if (r_neg) begin r_st <= ST_NEG; st <= S_HOLD; end
            else st <= (nc == 0) ? S_ISSUE : S_AR;
          end else ci <= ci + 1'b1;
        end
        S_AR: begin
          f_araddr <= FACT_BASE + {cbuf[fi[CW-1:0]], 4'd0};
          f_arvalid <= 1'b1;
          if (f_arready && f_arvalid) begin
            f_arvalid <= 1'b0; nfar <= nfar + 16'd1; tocnt <= '0; st <= S_R;
          end
        end
        S_R: begin
          tocnt <= tocnt + 16'd1;
          if (f_rvalid) begin
            if (beat_ok) begin
              eng_load <= 1'b1; eng_lidx <= nload[3:0];
              eng_s <= m_axi_rdata[19:0];
              eng_o <= m_axi_rdata[39:20];
              eng_r <= m_axi_rdata[47:40];
              eng_e <= m_axi_rdata[67:48];
              eng_t <= m_axi_rdata[68]; eng_p <= m_axi_rdata[69];
              nload <= nload + 8'd1; nfok <= nfok + 16'd1;
            end else begin
              nferr <= nferr + 16'd1; r_axi <= 1'b1;
            end
            if (fi + 1'b1 == nc) st <= S_ISSUE;
            else begin fi <= fi + 1'b1; st <= S_AR; end
          end else if (tocnt >= TO_CYC[15:0]) begin
            nfto <= nfto + 16'd1; r_axi <= 1'b1;
            if (fi + 1'b1 == nc) st <= S_ISSUE;
            else begin fi <= fi + 1'b1; st <= S_AR; end
          end
        end
        S_ISSUE: begin
          if (r_ovf || r_axi) begin
            r_st <= ST_INCOMP; r_ans <= '0; r_p0 <= '0; r_p1 <= '0; st <= S_HOLD;
          end else if (!r_v0) begin
            r_st <= ST_UNKNOWN; st <= S_HOLD;
          end else if (eng_ready) begin
            eng_qv <= 1'b1; st <= S_QWAIT;
          end
        end
        S_QWAIT: begin
          if (eng_ans_v) begin
            r_ans <= eng_ans; r_p0 <= eng_p0; r_p1 <= eng_p1;
            r_st <= {1'b0, eng_st};
            st <= S_HOLD;
          end
        end
        S_HOLD: if (retire_i) st <= S_IDLE;
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
