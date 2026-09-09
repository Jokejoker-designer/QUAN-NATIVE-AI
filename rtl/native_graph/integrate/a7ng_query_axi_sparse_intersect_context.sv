// a7ng_query_axi_sparse_intersect_context.sv — ASTRA-C1-CONTEXT-02
// Law: qse-v2-intersect-context-02
// Frozen extract → NEW ctx key bind → frozen route gate.
// Frozen dir instantiated (C0 geometry; AXI idle — not the merge walker).
// Walker = STREAM-02 two-pointer (instantiate-not-edit 14f75db7; this file is
// a thin named wrapper: same merge FSM, ctx keys instead of relbind).
// Do NOT edit a7ng_query_axi_sparse_stream_intersect.sv.
// Do NOT union k0 with k1. Do NOT probe k2/k3. Do NOT load full posting BRAM.
// Do NOT patch C0 dir/extract/lexicon/sparse. poke_v held 0 by TB. PROGRAM=NO.
`timescale 1ns / 1ps

module a7ng_query_axi_sparse_intersect_context #(
  parameter int unsigned N_TABLES           = 4,
  parameter int unsigned N_BUCKETS          = 4096,
  parameter int unsigned CAND_CAP           = 64,
  parameter int unsigned ID_W               = 20,
  parameter logic [27:0] INDEX_BASE         = 28'h0500_0000,
  parameter int unsigned MERGE_POST_AR_MAX  = 256
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
  output logic                 q_incomplete_o,
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
  localparam int unsigned ENTRY_BYTES = 16;
  localparam int unsigned TABLE_BYTES = N_BUCKETS * ENTRY_BYTES;
  localparam int unsigned B_W = (N_BUCKETS <= 1) ? 1 : $clog2(N_BUCKETS);

  logic [15:0] h_ent, h_int, h_hash, h_sh, h_bkt, h_cand, h_win, h_addr, h_rel, h_nxt, h_ans;
  logic [1:0]  dir_w, nhyp_w;
  logic        neg_w, amb_w, trip_w;
  logic [63:0] scue_w, ocue_w;
  logic [15:0] k0_ex, k1_ex, k2_ex, k3_ex;
  logic        v0_ex, v1_ex, v2_ex, v3_ex;
  logic        p0, p1, p2, p3;

  typedef enum logic [3:0] {
    S_IDLE, S_DISPATCH, S_ARDIR0, S_RDIR0, S_ARDIR1, S_RDIR1,
    S_NEXT, S_ARPOST, S_RPOST, S_OUT, S_DONE
  } st_t;
  typedef enum logic [1:0] { M_AND, M_K0, M_K1, M_EMPTY } mode_t;
  st_t   st;
  mode_t mode;
  logic        issued, fetch_sel, adv0, adv1, acc_ovf, acc_incomp;
  logic [15:0] k0_r, k1_r, k2_r, k3_r;
  logic        v0_r, v1_r, v2_r, v3_r;
  logic [15:0] nemit, acc_ndup, acc_ntrunc, acc_ndir, acc_npost;
  logic [3:0]  acc_pmask;

  logic [27:0] hbase0, hbase1, obase0, obase1;
  logic [15:0] hcnt0, hcnt1, ocnt0, ocnt1, tot0, tot1, pos0, pos1, occ0, occ1;
  logic        ovf0, ovf1, done0, done1, have0, have1;
  logic [127:0] beat0, beat1;
  logic [1:0]  lane0, lane1;
  logic [2:0]  nval0, nval1;
  logic [ID_W-1:0] id0, id1;
  logic [27:0] post_addr, dir_addr0, dir_addr1;
  logic [2:0]  nv_cur;
  logic [15:0] rem_cur;
  logic [1:0]  ln0, ln1;

  logic [3:0]  d_arid;
  logic [27:0] d_araddr;
  logic [7:0]  d_arlen;
  logic [2:0]  d_arsize;
  logic [1:0]  d_arburst;
  logic        d_arvalid, d_rready, d_q_ready, d_cand_v, d_q_done, d_ovf;
  logic [ID_W-1:0] d_cand_id;
  logic [15:0] d_n_emit, d_n_dup, d_n_trunc, d_n_dir, d_n_post;
  logic [3:0]  d_pmask;

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

  a7ng_query_role_keys_ctx u_ctx (
    .subj_id_i(entity_id_o),
    .obj_id_i(intent_id_o),
    .rel_id_i(relation_id_o),
    .ctx_id_i(context_id_o),
    .k0_i(k0_ex), .k1_i(k1_ex),
    .k0_valid_i(v0_ex), .k1_valid_i(v1_ex),
    .k2_valid_i(v2_ex), .k3_valid_i(v3_ex),
    .k0_o(k0_o), .k1_o(k1_o), .k2_o(k2_o), .k3_o(k3_o),
    .k0_valid_o(k0_valid_o), .k1_valid_o(k1_valid_o),
    .k2_valid_o(k2_valid_o), .k3_valid_o(k3_valid_o),
    .ctx_valid_o()
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

  // Frozen C0 dir: instantiated for hash-gate geometry. AXI idle. Not the walker.
  a7ng_sparse_dir_axi #(
    .N_TABLES(N_TABLES), .N_BUCKETS(N_BUCKETS), .CAND_CAP(CAND_CAP),
    .ID_W(ID_W), .INDEX_BASE(INDEX_BASE)
  ) u_dir_frozen (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_epoch_i),
    .q_v(1'b0), .q_ready(d_q_ready),
    .k0_i(k0_r), .k1_i(k1_r), .k2_i(k2_r), .k3_i(k3_r),
    .k0_valid_i(1'b0), .k1_valid_i(1'b0), .k2_valid_i(1'b0), .k3_valid_i(1'b0),
    .cand_v(d_cand_v), .cand_ready(1'b1), .cand_id(d_cand_id),
    .q_done(d_q_done), .q_overflow_o(d_ovf),
    .n_emit_o(d_n_emit), .n_dup_o(d_n_dup), .n_trunc_o(d_n_trunc),
    .n_dir_ar_o(d_n_dir), .n_post_ar_o(d_n_post), .probed_mask_o(d_pmask),
    .m_axi_arid(d_arid), .m_axi_araddr(d_araddr), .m_axi_arlen(d_arlen),
    .m_axi_arsize(d_arsize), .m_axi_arburst(d_arburst),
    .m_axi_arvalid(d_arvalid), .m_axi_arready(1'b0),
    .m_axi_rid(4'd0), .m_axi_rdata(128'd0), .m_axi_rresp(2'b00),
    .m_axi_rlast(1'b0), .m_axi_rvalid(1'b0), .m_axi_rready(d_rready)
  );

  assign walk_ready_o  = (st == S_IDLE);
  assign m_axi_arid    = 4'd1;
  assign m_axi_arsize  = 3'd4;
  assign m_axi_arburst = 2'b01;
  assign occ0          = hcnt0 + ocnt0;
  assign occ1          = hcnt1 + ocnt1;
  assign ln0           = lane0 + 2'd1;
  assign ln1           = lane1 + 2'd1;

  always_comb begin
    dir_addr0 = INDEX_BASE
              + (28'(k0_r[B_W-1:0]) * 28'(ENTRY_BYTES));
    dir_addr1 = INDEX_BASE
              + 28'(TABLE_BYTES)
              + (28'(k1_r[B_W-1:0]) * 28'(ENTRY_BYTES));
    if (!fetch_sel) begin
      if (pos0 < hcnt0)
        post_addr = hbase0 + (28'(pos0 >> 2) << 4);
      else
        post_addr = obase0 + (28'((pos0 - hcnt0) >> 2) << 4);
      if (pos0 < hcnt0)
        rem_cur = hcnt0 - pos0;
      else
        rem_cur = ocnt0 - (pos0 - hcnt0);
    end else begin
      if (pos1 < hcnt1)
        post_addr = hbase1 + (28'(pos1 >> 2) << 4);
      else
        post_addr = obase1 + (28'((pos1 - hcnt1) >> 2) << 4);
      if (pos1 < hcnt1)
        rem_cur = hcnt1 - pos1;
      else
        rem_cur = ocnt1 - (pos1 - hcnt1);
    end
    if (rem_cur >= 16'd4)
      nv_cur = 3'd4;
    else
      nv_cur = rem_cur[2:0];
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      mode <= M_EMPTY;
      issued <= 1'b0;
      fetch_sel <= 1'b0;
      k0_r <= '0; k1_r <= '0; k2_r <= '0; k3_r <= '0;
      v0_r <= 1'b0; v1_r <= 1'b0; v2_r <= 1'b0; v3_r <= 1'b0;
      nemit <= '0;
      acc_ndup <= '0; acc_ntrunc <= '0; acc_ndir <= '0; acc_npost <= '0;
      acc_ovf <= 1'b0; acc_incomp <= 1'b0; acc_pmask <= '0;
      cand_v <= 1'b0; cand_id <= '0; q_done <= 1'b0;
      q_overflow_o <= 1'b0; q_incomplete_o <= 1'b0;
      n_emit_o <= '0; n_dup_o <= '0; n_trunc_o <= '0;
      n_dir_ar_o <= '0; n_post_ar_o <= '0; probed_mask_o <= '0;
      m_axi_arvalid <= 1'b0; m_axi_araddr <= '0; m_axi_arlen <= 8'd0;
      m_axi_rready <= 1'b0;
      hbase0 <= '0; hbase1 <= '0; obase0 <= '0; obase1 <= '0;
      hcnt0 <= '0; hcnt1 <= '0; ocnt0 <= '0; ocnt1 <= '0;
      tot0 <= '0; tot1 <= '0; pos0 <= '0; pos1 <= '0;
      ovf0 <= 1'b0; ovf1 <= 1'b0;
      done0 <= 1'b1; done1 <= 1'b1; have0 <= 1'b0; have1 <= 1'b0;
      beat0 <= '0; beat1 <= '0; lane0 <= '0; lane1 <= '0;
      nval0 <= '0; nval1 <= '0; id0 <= '0; id1 <= '0;
    end else begin
      q_done <= 1'b0;
      adv0 = 1'b0;
      adv1 = 1'b0;
      if (cand_v && cand_ready)
        cand_v <= 1'b0;
      if (retire_i)
        issued <= 1'b0;

      unique case (st)
        S_IDLE: begin
          cand_v <= 1'b0;
          m_axi_arvalid <= 1'b0;
          m_axi_rready  <= 1'b0;
          if (poke_v_i) begin
            k0_r <= poke_k0_i; k1_r <= poke_k1_i;
            k2_r <= poke_k2_i; k3_r <= poke_k3_i;
            v0_r <= poke_v0_i; v1_r <= poke_v1_i;
            v2_r <= poke_v2_i; v3_r <= poke_v3_i;
            nemit <= '0;
            acc_ndup <= '0; acc_ntrunc <= '0; acc_ndir <= '0; acc_npost <= '0;
            acc_ovf <= 1'b0; acc_incomp <= 1'b0; acc_pmask <= '0;
            st <= S_DISPATCH;
          end else if (qse_valid_o && !issued) begin
            k0_r <= k0_o; k1_r <= k1_o; k2_r <= k2_o; k3_r <= k3_o;
            v0_r <= k0_valid_o; v1_r <= k1_valid_o;
            v2_r <= k2_valid_o; v3_r <= k3_valid_o;
            issued <= 1'b1;
            nemit <= '0;
            acc_ndup <= '0; acc_ntrunc <= '0; acc_ndir <= '0; acc_npost <= '0;
            acc_ovf <= 1'b0; acc_incomp <= 1'b0; acc_pmask <= '0;
            st <= S_DISPATCH;
          end
        end

        S_DISPATCH: begin
          done0 <= 1'b1; done1 <= 1'b1;
          have0 <= 1'b0; have1 <= 1'b0;
          pos0 <= '0; pos1 <= '0;
          tot0 <= '0; tot1 <= '0;
          ovf0 <= 1'b0; ovf1 <= 1'b0;
          hcnt0 <= '0; hcnt1 <= '0; ocnt0 <= '0; ocnt1 <= '0;
          if (p0 && p1) begin
            mode <= M_AND;
            st <= S_ARDIR0;
          end else if (p0) begin
            mode <= M_K0;
            fetch_sel <= 1'b0;
            st <= S_ARDIR0;
          end else if (p1) begin
            mode <= M_K1;
            fetch_sel <= 1'b1;
            st <= S_ARDIR1;
          end else begin
            mode <= M_EMPTY;
            st <= S_DONE;
          end
        end

        S_ARDIR0: begin
          m_axi_araddr  <= dir_addr0;
          m_axi_arlen   <= 8'd0;
          m_axi_arvalid <= 1'b1;
          if (m_axi_arvalid && m_axi_arready) begin
            m_axi_arvalid <= 1'b0;
            m_axi_rready  <= 1'b1;
            acc_ndir      <= acc_ndir + 16'd1;
            acc_pmask[0]  <= 1'b1;
            st <= S_RDIR0;
          end
        end

        S_RDIR0: begin
          m_axi_rready <= 1'b1;
          if (m_axi_rvalid && m_axi_rready) begin
            m_axi_rready <= 1'b0;
            hbase0 <= m_axi_rdata[27:0];
            hcnt0  <= m_axi_rdata[47:32];
            ovf0   <= m_axi_rdata[48];
            obase0 <= m_axi_rdata[107:80];
            ocnt0  <= m_axi_rdata[123:108];
            tot0   <= m_axi_rdata[47:32] + m_axi_rdata[123:108];
            acc_ovf <= acc_ovf | m_axi_rdata[48];
            if ((m_axi_rdata[79:64] != live_epoch_i) ||
                ((m_axi_rdata[47:32] + m_axi_rdata[123:108]) == 16'd0))
              done0 <= 1'b1;
            else
              done0 <= 1'b0;
            if (mode == M_AND)
              st <= S_ARDIR1;
            else
              st <= S_NEXT;
          end
        end

        S_ARDIR1: begin
          m_axi_araddr  <= dir_addr1;
          m_axi_arlen   <= 8'd0;
          m_axi_arvalid <= 1'b1;
          if (m_axi_arvalid && m_axi_arready) begin
            m_axi_arvalid <= 1'b0;
            m_axi_rready  <= 1'b1;
            acc_ndir      <= acc_ndir + 16'd1;
            acc_pmask[1]  <= 1'b1;
            st <= S_RDIR1;
          end
        end

        S_RDIR1: begin
          m_axi_rready <= 1'b1;
          if (m_axi_rvalid && m_axi_rready) begin
            m_axi_rready <= 1'b0;
            hbase1 <= m_axi_rdata[27:0];
            hcnt1  <= m_axi_rdata[47:32];
            ovf1   <= m_axi_rdata[48];
            obase1 <= m_axi_rdata[107:80];
            ocnt1  <= m_axi_rdata[123:108];
            tot1   <= m_axi_rdata[47:32] + m_axi_rdata[123:108];
            acc_ovf <= acc_ovf | m_axi_rdata[48];
            if ((m_axi_rdata[79:64] != live_epoch_i) ||
                ((m_axi_rdata[47:32] + m_axi_rdata[123:108]) == 16'd0))
              done1 <= 1'b1;
            else
              done1 <= 1'b0;
            st <= S_NEXT;
          end
        end

        S_NEXT: begin
          cand_v <= 1'b0;
          m_axi_arvalid <= 1'b0;
          m_axi_rready  <= 1'b0;
          if (mode == M_AND) begin
            if (done0 || done1) begin
              st <= S_DONE;
            end else if (!have0 && !done0) begin
              if (acc_npost >= MERGE_POST_AR_MAX[15:0]) begin
                acc_incomp <= 1'b1;
                acc_ntrunc <= acc_ntrunc + 16'd1;
                st <= S_DONE;
              end else begin
                if (!have1 && !done1)
                  fetch_sel <= (occ0 <= occ1) ? 1'b0 : 1'b1;
                else
                  fetch_sel <= 1'b0;
                st <= S_ARPOST;
              end
            end else if (!have1 && !done1) begin
              if (acc_npost >= MERGE_POST_AR_MAX[15:0]) begin
                acc_incomp <= 1'b1;
                acc_ntrunc <= acc_ntrunc + 16'd1;
                st <= S_DONE;
              end else begin
                fetch_sel <= 1'b1;
                st <= S_ARPOST;
              end
            end else if (id0 == id1) begin
              if (nemit >= CAND_CAP[15:0]) begin
                acc_ntrunc <= acc_ntrunc + 16'd1;
                acc_incomp <= 1'b1;
                st <= S_DONE;
              end else begin
                cand_id <= id0;
                cand_v  <= 1'b1;
                st <= S_OUT;
              end
            end else if (id0 < id1) begin
              adv0 = 1'b1;
            end else begin
              adv1 = 1'b1;
            end
          end else if (mode == M_K0) begin
            if (!have0 && !done0) begin
              if (acc_npost >= MERGE_POST_AR_MAX[15:0]) begin
                acc_incomp <= 1'b1;
                acc_ntrunc <= acc_ntrunc + 16'd1;
                st <= S_DONE;
              end else begin
                fetch_sel <= 1'b0;
                st <= S_ARPOST;
              end
            end else if (done0) begin
              st <= S_DONE;
            end else if (nemit >= CAND_CAP[15:0]) begin
              acc_ntrunc <= acc_ntrunc + 16'd1;
              acc_incomp <= 1'b1;
              st <= S_DONE;
            end else begin
              cand_id <= id0;
              cand_v  <= 1'b1;
              st <= S_OUT;
            end
          end else if (mode == M_K1) begin
            if (!have1 && !done1) begin
              if (acc_npost >= MERGE_POST_AR_MAX[15:0]) begin
                acc_incomp <= 1'b1;
                acc_ntrunc <= acc_ntrunc + 16'd1;
                st <= S_DONE;
              end else begin
                fetch_sel <= 1'b1;
                st <= S_ARPOST;
              end
            end else if (done1) begin
              st <= S_DONE;
            end else if (nemit >= CAND_CAP[15:0]) begin
              acc_ntrunc <= acc_ntrunc + 16'd1;
              acc_incomp <= 1'b1;
              st <= S_DONE;
            end else begin
              cand_id <= id1;
              cand_v  <= 1'b1;
              st <= S_OUT;
            end
          end else begin
            st <= S_DONE;
          end
        end

        S_ARPOST: begin
          m_axi_araddr  <= post_addr;
          m_axi_arlen   <= 8'd0;
          m_axi_arvalid <= 1'b1;
          if (m_axi_arvalid && m_axi_arready) begin
            m_axi_arvalid <= 1'b0;
            acc_npost     <= acc_npost + 16'd1;
            st <= S_RPOST;
          end
        end

        S_RPOST: begin
          m_axi_rready <= 1'b1;
          if (m_axi_rvalid && m_axi_rready) begin
            m_axi_rready <= 1'b0;
            if (!fetch_sel) begin
              beat0 <= m_axi_rdata;
              lane0 <= 2'd0;
              nval0 <= nv_cur;
              id0   <= m_axi_rdata[ID_W-1:0];
              if (nv_cur == 3'd0)
                done0 <= 1'b1;
              else
                have0 <= 1'b1;
            end else begin
              beat1 <= m_axi_rdata;
              lane1 <= 2'd0;
              nval1 <= nv_cur;
              id1   <= m_axi_rdata[ID_W-1:0];
              if (nv_cur == 3'd0)
                done1 <= 1'b1;
              else
                have1 <= 1'b1;
            end
            st <= S_NEXT;
          end
        end

        S_OUT: begin
          if (cand_v && cand_ready) begin
            cand_v <= 1'b0;
            nemit  <= nemit + 16'd1;
            if (mode == M_AND) begin
              adv0 = 1'b1;
              adv1 = 1'b1;
            end else if (mode == M_K0) begin
              adv0 = 1'b1;
            end else begin
              adv1 = 1'b1;
            end
            st <= S_NEXT;
          end
        end

        S_DONE: begin
          cand_v <= 1'b0;
          q_done <= 1'b1;
          q_overflow_o   <= acc_ovf;
          q_incomplete_o <= acc_incomp;
          n_emit_o       <= nemit;
          n_dup_o        <= acc_ndup;
          n_trunc_o      <= acc_ntrunc;
          n_dir_ar_o     <= acc_ndir;
          n_post_ar_o    <= acc_npost;
          probed_mask_o  <= acc_pmask;
          st <= S_IDLE;
        end

        default: st <= S_IDLE;
      endcase

      if (adv0) begin
        pos0 <= pos0 + 16'd1;
        if ((pos0 + 16'd1) >= tot0) begin
          done0 <= 1'b1;
          have0 <= 1'b0;
        end else if (({1'b0, lane0} + 3'd1) < nval0) begin
          lane0 <= ln0;
          id0   <= beat0[32*ln0 +: ID_W];
          have0 <= 1'b1;
        end else begin
          have0 <= 1'b0;
        end
      end
      if (adv1) begin
        pos1 <= pos1 + 16'd1;
        if ((pos1 + 16'd1) >= tot1) begin
          done1 <= 1'b1;
          have1 <= 1'b0;
        end else if (({1'b0, lane1} + 3'd1) < nval1) begin
          lane1 <= ln1;
          id1   <= beat1[32*ln1 +: ID_W];
          have1 <= 1'b1;
        end else begin
          have1 <= 1'b0;
        end
      end
    end
  end
endmodule
