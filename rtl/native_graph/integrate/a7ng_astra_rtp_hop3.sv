// a7ng_astra_rtp_hop3.sv — exactly 3-hop from fetched descriptors. PROGRAM=NO.
`timescale 1ns / 1ps

module a7ng_astra_rtp_hop3 #(
  parameter int unsigned N_FACT     = 16,
  parameter int unsigned ID_W       = 20,
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
  output logic [ID_W-1:0] ans_o,
  output logic [ID_W-1:0] proof0_o,
  output logic [ID_W-1:0] proof1_o,
  output logic [ID_W-1:0] proof2_o,
  output logic [3:0]  status_o,
  output logic [7:0]  n_load_o,
  output logic [15:0] n_fact_ar_o,
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
  localparam logic [3:0] VER = 4'd1;
  localparam logic [3:0] ST_ANSWER = 4'd0, ST_UNKNOWN = 4'd1;
  typedef enum logic [3:0] { S_IDLE, S_WALK, S_AR, S_R, S_I, S_J, S_K, S_HOLD } st_t;
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
  logic [4:0] nc, fi, nf, ei, ej, ek;
  logic [19:0] fs [0:15], fo [0:15], fe [0:15];
  logic [7:0] fr [0:15];
  logic ft [0:15], fpv [0:15], fv [0:15];
  logic [7:0] r_subj, r_rel;
  logic [19:0] r_ans, r_p0, r_p1, r_p2;
  logic [3:0] r_st;
  logic [15:0] nfar, tocnt;
  logic found;
  integer kf;

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
  assign qse_tok_v = tok_valid_i && (st==S_IDLE);
  assign qse_fire = fire_i && (st==S_IDLE);
  assign tok_ready_o = qse_tok_r && (st==S_IDLE);
  assign cand_ready = (st==S_WALK);
  assign busy_o = (st!=S_IDLE);
  assign result_v_o = (st==S_HOLD);
  assign ans_o = r_ans;
  assign proof0_o = r_p0;
  assign proof1_o = r_p1;
  assign proof2_o = r_p2;
  assign status_o = r_st;
  assign n_load_o = {3'd0, nf};
  assign n_fact_ar_o = nfar;

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

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE; qse_retire <= 1'b0; f_arvalid <= 1'b0; f_araddr <= '0;
      nc <= '0; fi <= '0; nf <= '0; ei <= '0; ej <= '0; ek <= '0;
      nfar <= '0; tocnt <= '0; found <= 1'b0;
      r_subj <= '0; r_rel <= '0;
      r_ans <= '0; r_p0 <= '0; r_p1 <= '0; r_p2 <= '0; r_st <= ST_UNKNOWN;
    end else begin
      qse_retire <= 1'b0;
      unique case (st)
        S_IDLE: begin
          nc <= '0; fi <= '0; nf <= '0; nfar <= '0; found <= 1'b0; tocnt <= '0;
          for (kf = 0; kf < 16; kf = kf + 1) fv[kf] <= 1'b0;
          if (qse_valid) begin r_subj <= qse_subj; r_rel <= qse_rel; st <= S_WALK; end
        end
        S_WALK: begin
          if (cand_v && cand_ready && (nc < 5'd16)) begin
            cbuf[nc[3:0]] <= cand_id; nc <= nc + 1'b1;
          end
          if (w_done) begin qse_retire <= 1'b1; fi <= '0; st <= (nc==0) ? S_HOLD : S_AR; end
        end
        S_AR: begin
          f_araddr <= FACT_BASE + {cbuf[fi[3:0]], 4'd0}; f_arvalid <= 1'b1;
          tocnt <= tocnt + 16'd1;
          if (f_arready && f_arvalid) begin
            f_arvalid <= 1'b0; nfar <= nfar + 16'd1; tocnt <= '0; st <= S_R;
          end else if (tocnt >= TO_CYC[15:0]) begin
            f_arvalid <= 1'b0; tocnt <= '0;
            if (fi + 1'b1 == nc) begin ei <= '0; st <= S_I; end
            else begin fi <= fi + 1'b1; st <= S_AR; end
          end
        end
        S_R: begin
          tocnt <= tocnt + 16'd1;
          if (f_rvalid) begin
            if ((m_axi_rid==4'd2)&&(m_axi_rresp==2'b00)&&m_axi_rlast
                && (m_axi_rdata[75:72]==VER)&&m_axi_rdata[70]
                && (m_axi_rdata[67:48]==cbuf[fi[3:0]]) && (nf<5'd16)) begin
              fs[nf[3:0]] <= m_axi_rdata[19:0];
              fo[nf[3:0]] <= m_axi_rdata[39:20];
              fr[nf[3:0]] <= m_axi_rdata[47:40];
              fe[nf[3:0]] <= m_axi_rdata[67:48];
              ft[nf[3:0]] <= m_axi_rdata[68];
              fpv[nf[3:0]] <= m_axi_rdata[69];
              fv[nf[3:0]] <= 1'b1;
              nf <= nf + 1'b1;
            end
            tocnt <= '0;
            if (fi + 1'b1 == nc) begin ei <= '0; st <= S_I; end
            else begin fi <= fi + 1'b1; st <= S_AR; end
          end else if (tocnt >= TO_CYC[15:0]) begin
            tocnt <= '0;
            if (fi + 1'b1 == nc) begin ei <= '0; st <= S_I; end
            else begin fi <= fi + 1'b1; st <= S_AR; end
          end
        end
        S_I: if (ei >= nf) begin
          r_st <= found ? ST_ANSWER : ST_UNKNOWN;
          if (!found) begin r_ans <= '0; r_p0 <= '0; r_p1 <= '0; r_p2 <= '0; end
          st <= S_HOLD;
        end else begin ej <= '0; st <= S_J; end
        S_J: if (ej >= nf) begin ei <= ei + 1'b1; st <= S_I; end
        else begin ek <= '0; st <= S_K; end
        S_K: if (ek >= nf) begin ej <= ej + 1'b1; st <= S_J; end
        else begin
          if (fv[ei[3:0]] && fv[ej[3:0]] && fv[ek[3:0]]
              && ft[ei[3:0]] && ft[ej[3:0]] && ft[ek[3:0]]
              && fpv[ei[3:0]] && fpv[ej[3:0]] && fpv[ek[3:0]]
              && (fr[ei[3:0]]==r_rel) && (fr[ej[3:0]]==r_rel) && (fr[ek[3:0]]==r_rel)
              && (fs[ei[3:0]]=={{12{1'b0}}, r_subj})
              && (fs[ej[3:0]]==fo[ei[3:0]])
              && (fs[ek[3:0]]==fo[ej[3:0]])
              && (fo[ek[3:0]] != {{12{1'b0}}, r_subj})) begin
            found <= 1'b1;
            r_ans <= fo[ek[3:0]];
            r_p0 <= fe[ei[3:0]]; r_p1 <= fe[ej[3:0]]; r_p2 <= fe[ek[3:0]];
          end
          ek <= ek + 1'b1;
        end
        S_HOLD: if (retire_i) st <= S_IDLE;
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
