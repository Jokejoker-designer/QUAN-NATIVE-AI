// a7ng_query_axi_sparse_intersect.sv — ASTRA-C1-KEY-INTERSECT-01
// Law: qse-v2-intersect-01
// Frozen extract → relbind keys → frozen route gate + frozen sparse dir.
// Emit k0∩k1 when both valid. Do NOT union k0 with k1. Do NOT probe k2/k3.
// Does not edit extract / lexicon / sparse / dir / gate / relbind.
// Keys/valids are FPGA-owned. poke_v held 0 by TB. PROGRAM=NO.
`timescale 1ns / 1ps

module a7ng_query_axi_sparse_intersect #(
  parameter int unsigned N_TABLES   = 4,
  parameter int unsigned N_BUCKETS  = 4096,
  parameter int unsigned CAND_CAP   = 64,
  parameter int unsigned ID_W       = 20,
  parameter logic [27:0] INDEX_BASE = 28'h0500_0000
) (
  input  logic                 clk,
  input  logic                 rst_n,
  input  logic [15:0]          live_epoch_i,

  input  logic                 tok_valid_i,
  output logic                 tok_ready_o,
  input  logic [7:0]           tok_i,
  input  logic                 fire_i,
  input  logic                 retire_i,

  input  logic                 poke_v_i,
  input  logic [15:0]          poke_k0_i,
  input  logic [15:0]          poke_k1_i,
  input  logic [15:0]          poke_k2_i,
  input  logic [15:0]          poke_k3_i,
  input  logic                 poke_v0_i,
  input  logic                 poke_v1_i,
  input  logic                 poke_v2_i,
  input  logic                 poke_v3_i,

  output logic                 qse_valid_o,
  output logic                 qse_busy_o,
  output logic                 qse_accepted_o,
  output logic [7:0]           entity_id_o,
  output logic [7:0]           intent_id_o,
  output logic [7:0]           relation_id_o,
  output logic [7:0]           context_id_o,
  output logic [15:0]          k0_o,
  output logic [15:0]          k1_o,
  output logic [15:0]          k2_o,
  output logic [15:0]          k3_o,
  output logic                 k0_valid_o,
  output logic                 k1_valid_o,
  output logic                 k2_valid_o,
  output logic                 k3_valid_o,
  output logic [1:0]           direction_o,
  output logic                 negation_o,
  output logic                 ambiguity_o,
  output logic                 triple_valid_o,
  output logic [1:0]           n_hyp_o,
  output logic [15:0]          n_host_any_o,
  output logic [15:0]          n_host_entity_o,
  output logic [15:0]          n_host_intent_o,
  output logic [15:0]          n_host_hash_o,
  output logic [15:0]          n_host_shard_o,
  output logic [15:0]          n_host_bucket_o,
  output logic [15:0]          n_host_cand_o,
  output logic [15:0]          n_host_winner_o,
  output logic [15:0]          n_host_addr_o,
  output logic [15:0]          n_host_relpath_o,
  output logic [15:0]          n_host_next_o,
  output logic [15:0]          n_host_answer_o,

  output logic                 walk_ready_o,
  output logic                 cand_v,
  input  logic                 cand_ready,
  output logic [ID_W-1:0]      cand_id,
  output logic                 q_done,
  output logic                 q_overflow_o,
  output logic [15:0]          n_emit_o,
  output logic [15:0]          n_dup_o,
  output logic [15:0]          n_trunc_o,
  output logic [15:0]          n_dir_ar_o,
  output logic [15:0]          n_post_ar_o,
  output logic [3:0]           probed_mask_o,

  output logic [3:0]           m_axi_arid,
  output logic [27:0]          m_axi_araddr,
  output logic [7:0]           m_axi_arlen,
  output logic [2:0]           m_axi_arsize,
  output logic [1:0]           m_axi_arburst,
  output logic                 m_axi_arvalid,
  input  logic                 m_axi_arready,
  input  logic [3:0]           m_axi_rid,
  input  logic [127:0]         m_axi_rdata,
  input  logic [1:0]           m_axi_rresp,
  input  logic                 m_axi_rlast,
  input  logic                 m_axi_rvalid,
  output logic                 m_axi_rready
);
  localparam int unsigned C_W = (CAND_CAP <= 1) ? 1 : $clog2(CAND_CAP);

  logic [15:0] h_ent, h_int, h_hash, h_sh, h_bkt, h_cand, h_win, h_addr, h_rel, h_nxt, h_ans;
  logic [1:0]  dir_w, nhyp_w;
  logic        neg_w, amb_w, trip_w;
  logic [63:0] scue_w, ocue_w;
  logic [15:0] k0_ex, k1_ex, k2_ex, k3_ex;
  logic        v0_ex, v1_ex, v2_ex, v3_ex;
  logic        p0, p1, p2, p3;

  logic        w_q_ready, w_q_v, w_q_done, w_ovf;
  logic        w_cand_v, w_cand_ready;
  logic [ID_W-1:0] w_cand_id;
  logic [15:0] w_n_emit, w_n_dup, w_n_trunc, w_n_dir, w_n_post;
  logic [3:0]  w_pmask;
  logic        w_v0, w_v1, w_v2, w_v3;

  typedef enum logic [3:0] {
    S_IDLE, S_DISPATCH, S_ISSUE0, S_WALK0, S_WAIT1, S_ISSUE1, S_WALK1,
    S_SCAN, S_OUT, S_DONE
  } st_t;
  typedef enum logic [1:0] { M_AND, M_K0, M_K1 } mode_t;
  st_t   st;
  mode_t mode;
  logic        issued;
  logic [15:0] k0_r, k1_r, k2_r, k3_r;
  logic        v0_r, v1_r, v2_r, v3_r;
  logic [ID_W-1:0] buf0 [0:CAND_CAP-1];
  logic [ID_W-1:0] buf1 [0:CAND_CAP-1];
  logic [15:0] n0, n1, si, nemit, acc_ndup, acc_ntrunc, acc_ndir, acc_npost;
  logic        acc_ovf;
  logic [3:0]  acc_pmask;
  logic        in_b;
  integer      ji;

  a7ng_query_role_extract u_qse (
    .clk(clk), .rst_n(rst_n),
    .tok_valid_i(tok_valid_i), .tok_ready_o(tok_ready_o), .tok_i(tok_i),
    .fire_i(fire_i), .retire_i(retire_i),
    .busy_o(qse_busy_o), .accepted_o(qse_accepted_o), .valid_o(qse_valid_o),
    .subj_id_o(entity_id_o), .obj_id_o(intent_id_o),
    .rel_id_o(relation_id_o), .ctx_id_o(context_id_o),
    .direction_o(dir_w), .negation_o(neg_w), .ambiguity_o(amb_w),
    .triple_valid_o(trip_w), .n_hyp_o(nhyp_w),
    .subj_cue_o(scue_w), .obj_cue_o(ocue_w), .rel_cue_o(), .ctx_cue_o(),
    .crc16_dbg_o(), .k0_o(k0_ex), .k1_o(k1_ex), .k2_o(k2_ex), .k3_o(k3_ex),
    .k0_valid_o(v0_ex), .k1_valid_o(v1_ex),
    .k2_valid_o(v2_ex), .k3_valid_o(v3_ex),
    .valid_mask_o(),
    .n_host_entity_o(h_ent), .n_host_intent_o(h_int), .n_host_hash_o(h_hash),
    .n_host_shard_o(h_sh), .n_host_bucket_o(h_bkt), .n_host_cand_o(h_cand),
    .n_host_winner_o(h_win), .n_host_addr_o(h_addr), .n_host_relpath_o(h_rel),
    .n_host_next_o(h_nxt), .n_host_answer_o(h_ans)
  );

  a7ng_query_role_keys_relbind u_relbind (
    .rel_id_i(relation_id_o),
    .subj_cue_i(scue_w),
    .obj_cue_i(ocue_w),
    .k0_i(k0_ex), .k1_i(k1_ex),
    .k0_valid_i(v0_ex), .k1_valid_i(v1_ex),
    .k2_valid_i(v2_ex), .k3_valid_i(v3_ex),
    .k0_o(k0_o), .k1_o(k1_o), .k2_o(k2_o), .k3_o(k3_o),
    .k0_valid_o(k0_valid_o), .k1_valid_o(k1_valid_o),
    .k2_valid_o(k2_valid_o), .k3_valid_o(k3_valid_o)
  );

  assign direction_o    = dir_w;
  assign negation_o     = neg_w;
  assign ambiguity_o    = amb_w;
  assign triple_valid_o = trip_w;
  assign n_hyp_o        = nhyp_w;
  assign n_host_any_o = h_ent | h_int | h_hash | h_sh | h_bkt | h_cand
                      | h_win | h_addr | h_rel | h_nxt | h_ans;
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

  a7ng_route_valid_gate u_vg (
    .k0_valid_i(v0_r), .k0_i(k0_r),
    .k1_valid_i(v1_r), .k1_i(k1_r),
    .k2_valid_i(v2_r), .k2_i(k2_r),
    .k3_valid_i(v3_r), .k3_i(k3_r),
    .probe0_o(p0), .probe1_o(p1), .probe2_o(p2), .probe3_o(p3),
    .insert0_o(), .insert1_o(), .insert2_o(), .insert3_o(),
    .bucket0_o(), .bucket1_o(), .bucket2_o(), .bucket3_o()
  );

  // Per-walk valids: k0 only or k1 only. Never union k2/k3.
  assign w_v0 = ((st == S_ISSUE0) || (st == S_WALK0)) ? p0 : 1'b0;
  assign w_v1 = ((st == S_ISSUE1) || (st == S_WALK1)) ? p1 : 1'b0;
  assign w_v2 = 1'b0;
  assign w_v3 = 1'b0;
  assign w_q_v = (st == S_ISSUE0) || (st == S_ISSUE1);
  assign w_cand_ready = 1'b1;

  a7ng_sparse_dir_axi #(
    .N_TABLES(N_TABLES), .N_BUCKETS(N_BUCKETS), .CAND_CAP(CAND_CAP),
    .ID_W(ID_W), .INDEX_BASE(INDEX_BASE)
  ) u_walk (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_epoch_i),
    .q_v(w_q_v), .q_ready(w_q_ready),
    .k0_i(k0_r), .k1_i(k1_r), .k2_i(k2_r), .k3_i(k3_r),
    .k0_valid_i(w_v0), .k1_valid_i(w_v1), .k2_valid_i(w_v2), .k3_valid_i(w_v3),
    .cand_v(w_cand_v), .cand_ready(w_cand_ready), .cand_id(w_cand_id),
    .q_done(w_q_done), .q_overflow_o(w_ovf),
    .n_emit_o(w_n_emit), .n_dup_o(w_n_dup), .n_trunc_o(w_n_trunc),
    .n_dir_ar_o(w_n_dir), .n_post_ar_o(w_n_post), .probed_mask_o(w_pmask),
    .m_axi_arid(m_axi_arid), .m_axi_araddr(m_axi_araddr), .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize), .m_axi_arburst(m_axi_arburst),
    .m_axi_arvalid(m_axi_arvalid), .m_axi_arready(m_axi_arready),
    .m_axi_rid(m_axi_rid), .m_axi_rdata(m_axi_rdata), .m_axi_rresp(m_axi_rresp),
    .m_axi_rlast(m_axi_rlast), .m_axi_rvalid(m_axi_rvalid), .m_axi_rready(m_axi_rready)
  );

  assign walk_ready_o = (st == S_IDLE) && w_q_ready;

  always_comb begin
    in_b = 1'b0;
    for (ji = 0; ji < CAND_CAP; ji = ji + 1)
      if ((ji < 32'(n1)) && (buf1[ji] == buf0[si[C_W-1:0]]))
        in_b = 1'b1;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      mode <= M_AND;
      issued <= 1'b0;
      k0_r <= '0; k1_r <= '0; k2_r <= '0; k3_r <= '0;
      v0_r <= 1'b0; v1_r <= 1'b0; v2_r <= 1'b0; v3_r <= 1'b0;
      n0 <= '0; n1 <= '0; si <= '0; nemit <= '0;
      acc_ndup <= '0; acc_ntrunc <= '0; acc_ndir <= '0; acc_npost <= '0;
      acc_ovf <= 1'b0; acc_pmask <= '0;
      cand_v <= 1'b0; cand_id <= '0; q_done <= 1'b0;
      q_overflow_o <= 1'b0;
      n_emit_o <= '0; n_dup_o <= '0; n_trunc_o <= '0;
      n_dir_ar_o <= '0; n_post_ar_o <= '0; probed_mask_o <= '0;
    end else begin
      q_done <= 1'b0;
      if (cand_v && cand_ready)
        cand_v <= 1'b0;
      if (retire_i)
        issued <= 1'b0;

      unique case (st)
        S_IDLE: begin
          cand_v <= 1'b0;
          if (w_q_ready && poke_v_i) begin
            k0_r <= poke_k0_i; k1_r <= poke_k1_i;
            k2_r <= poke_k2_i; k3_r <= poke_k3_i;
            v0_r <= poke_v0_i; v1_r <= poke_v1_i;
            v2_r <= poke_v2_i; v3_r <= poke_v3_i;
            n0 <= '0; n1 <= '0; si <= '0; nemit <= '0;
            acc_ndup <= '0; acc_ntrunc <= '0; acc_ndir <= '0; acc_npost <= '0;
            acc_ovf <= 1'b0; acc_pmask <= '0;
            st <= S_DISPATCH;
          end else if (w_q_ready && qse_valid_o && !issued) begin
            k0_r <= k0_o; k1_r <= k1_o; k2_r <= k2_o; k3_r <= k3_o;
            v0_r <= k0_valid_o; v1_r <= k1_valid_o;
            v2_r <= k2_valid_o; v3_r <= k3_valid_o;
            issued <= 1'b1;
            n0 <= '0; n1 <= '0; si <= '0; nemit <= '0;
            acc_ndup <= '0; acc_ntrunc <= '0; acc_ndir <= '0; acc_npost <= '0;
            acc_ovf <= 1'b0; acc_pmask <= '0;
            st <= S_DISPATCH;
          end
        end

        S_DISPATCH: begin
          // p0/p1 follow latched bind-state via frozen gate. Ignore p2/p3.
          if (p0 && p1) begin
            mode <= M_AND;
            st <= S_ISSUE0;
          end else if (p0) begin
            mode <= M_K0;
            st <= S_ISSUE0;
          end else if (p1) begin
            mode <= M_K1;
            st <= S_ISSUE1;
          end else begin
            st <= S_DONE;
          end
        end

        S_ISSUE0: begin
          st <= S_WALK0;
        end

        S_WALK0: begin
          if (w_cand_v && w_cand_ready && (n0 < CAND_CAP[15:0])) begin
            buf0[n0[C_W-1:0]] <= w_cand_id;
            n0 <= n0 + 16'd1;
          end
          if (w_q_done) begin
            acc_ndup   <= acc_ndup + w_n_dup;
            acc_ntrunc <= acc_ntrunc + w_n_trunc;
            acc_ndir   <= acc_ndir + w_n_dir;
            acc_npost  <= acc_npost + w_n_post;
            acc_ovf    <= acc_ovf | w_ovf;
            acc_pmask  <= acc_pmask | w_pmask;
            if (mode == M_AND)
              st <= S_WAIT1;
            else begin
              si <= '0;
              st <= S_SCAN;
            end
          end
        end

        S_WAIT1: begin
          if (w_q_ready)
            st <= S_ISSUE1;
        end

        S_ISSUE1: begin
          st <= S_WALK1;
        end

        S_WALK1: begin
          if (w_cand_v && w_cand_ready && (n1 < CAND_CAP[15:0])) begin
            buf1[n1[C_W-1:0]] <= w_cand_id;
            n1 <= n1 + 16'd1;
          end
          if (w_q_done) begin
            acc_ndup   <= acc_ndup + w_n_dup;
            acc_ntrunc <= acc_ntrunc + w_n_trunc;
            acc_ndir   <= acc_ndir + w_n_dir;
            acc_npost  <= acc_npost + w_n_post;
            acc_ovf    <= acc_ovf | w_ovf;
            acc_pmask  <= acc_pmask | w_pmask;
            si <= '0;
            st <= S_SCAN;
          end
        end

        S_SCAN: begin
          cand_v <= 1'b0;
          if (mode == M_AND) begin
            if (si >= n0)
              st <= S_DONE;
            else if (in_b) begin
              if (nemit >= CAND_CAP[15:0]) begin
                acc_ntrunc <= acc_ntrunc + 16'd1;
                si <= si + 16'd1;
              end else begin
                cand_id <= buf0[si[C_W-1:0]];
                cand_v  <= 1'b1;
                st <= S_OUT;
              end
            end else
              si <= si + 16'd1;
          end else if (mode == M_K0) begin
            if (si >= n0)
              st <= S_DONE;
            else if (nemit >= CAND_CAP[15:0]) begin
              acc_ntrunc <= acc_ntrunc + 16'd1;
              si <= si + 16'd1;
            end else begin
              cand_id <= buf0[si[C_W-1:0]];
              cand_v  <= 1'b1;
              st <= S_OUT;
            end
          end else begin
            if (si >= n1)
              st <= S_DONE;
            else if (nemit >= CAND_CAP[15:0]) begin
              acc_ntrunc <= acc_ntrunc + 16'd1;
              si <= si + 16'd1;
            end else begin
              cand_id <= buf1[si[C_W-1:0]];
              cand_v  <= 1'b1;
              st <= S_OUT;
            end
          end
        end

        S_OUT: begin
          if (cand_v && cand_ready) begin
            cand_v <= 1'b0;
            nemit  <= nemit + 16'd1;
            si     <= si + 16'd1;
            st     <= S_SCAN;
          end
        end

        S_DONE: begin
          cand_v <= 1'b0;
          q_done <= 1'b1;
          q_overflow_o <= acc_ovf;
          n_emit_o <= nemit;
          n_dup_o <= acc_ndup;
          n_trunc_o <= acc_ntrunc;
          n_dir_ar_o <= acc_ndir;
          n_post_ar_o <= acc_npost;
          probed_mask_o <= acc_pmask;
          st <= S_IDLE;
        end

        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
