// a7ng_query_axi_sparse_page_skip.sv — ASTRA-C1-PAGE-SKIP-01
// Law: qse-v2-page-skip-01 (stream AND + posting page min/max skip)
// Frozen extract → relbind keys → frozen route gate.
// Frozen dir instantiated (C0 geometry; AXI idle — not the merge walker).
// Do NOT patch a7ng_sparse_dir_axi.sv. Page {min,max,nrec} lives in postings.
// Walker: sorted-nid two-pointer AND; header beat then data beats;
// skip remaining data AR/R when page.max < other cursor (block-max).
// CAND_CAP after emit only. 1-beat buffer (no full-page BRAM).
// Budget exhaust → q_incomplete_o. Do NOT union k0 with k1.
// Do NOT probe k2/k3. poke_v held 0 by TB. PROGRAM=NO.
`timescale 1ns / 1ps

module a7ng_query_axi_sparse_page_skip #(
  parameter int unsigned N_TABLES           = 4,
  parameter int unsigned N_BUCKETS          = 4096,
  parameter int unsigned CAND_CAP           = 64,
  parameter int unsigned ID_W               = 20,
  parameter logic [27:0] INDEX_BASE         = 28'h0500_0000,
  parameter int unsigned MERGE_POST_AR_MAX  = 256,
  parameter int unsigned PAGE_N             = 16
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
  output logic [15:0]          n_page_skip_o,
  output logic [15:0]          n_hdr_ar_o,

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
  localparam int unsigned PAGE_SHIFT = (PAGE_N <= 1) ? 1 : $clog2(PAGE_N);
  localparam int unsigned PAGE_DATA_BEATS = (PAGE_N + 3) / 4;
  localparam int unsigned PAGE_BEATS = PAGE_DATA_BEATS + 1;
  localparam int unsigned PAGE_BYTES = PAGE_BEATS * ENTRY_BYTES;

  logic [15:0] h_ent, h_int, h_hash, h_sh, h_bkt, h_cand, h_win, h_addr, h_rel, h_nxt, h_ans;
  logic [1:0]  dir_w, nhyp_w;
  logic        neg_w, amb_w, trip_w;
  logic [63:0] scue_w, ocue_w;
  logic [15:0] k0_ex, k1_ex, k2_ex, k3_ex;
  logic        v0_ex, v1_ex, v2_ex, v3_ex;
  logic        p0, p1, p2, p3;

  typedef enum logic [3:0] {
    S_IDLE, S_DISPATCH, S_ARDIR0, S_RDIR0, S_ARDIR1, S_RDIR1,
    S_NEXT, S_ARHDR, S_RHDR, S_ARPOST, S_RPOST, S_OUT, S_DONE
  } st_t;
  typedef enum logic [1:0] { M_AND, M_K0, M_K1, M_EMPTY } mode_t;
  st_t   st;
  mode_t mode;
  logic        issued, fetch_sel, adv0, adv1, skip0, skip1, acc_ovf, acc_incomp;
  logic [15:0] k0_r, k1_r, k2_r, k3_r;
  logic        v0_r, v1_r, v2_r, v3_r;
  logic [15:0] nemit, acc_ndup, acc_ntrunc, acc_ndir, acc_npost, acc_nskip, acc_nhdr;
  logic [3:0]  acc_pmask;

  logic [27:0] hbase0, hbase1, obase0, obase1;
  logic [15:0] hcnt0, hcnt1, ocnt0, ocnt1, tot0, tot1, pos0, pos1, occ0, occ1;
  logic        ovf0, ovf1, done0, done1, have0, have1;
  logic        hhdr0, hhdr1, dfetched0, dfetched1;
  logic [ID_W-1:0] hmin0, hmin1, hmax0, hmax1;
  logic [15:0] hnrec0, hnrec1, pstart0, pstart1;
  logic [3:0]  dbeat0, dbeat1;
  logic [127:0] beat0, beat1;
  logic [1:0]  lane0, lane1;
  logic [2:0]  nval0, nval1;
  logic [ID_W-1:0] id0, id1;
  logic [27:0] post_addr, dir_addr0, dir_addr1, hdr_addr, data_addr;
  logic [2:0]  nv_cur;
  logic [15:0] rem_page, pos_in, rem_reg;
  logic [27:0] rbase;
  logic [15:0] page_idx;
  logic [1:0]  ln0, ln1;
  logic [ID_W-1:0] other_lo0, other_lo1;
  logic        need_hdr0, need_hdr1, can_skip0, can_skip1;

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
  assign need_hdr0     = !done0 && !have0 && !hhdr0;
  assign need_hdr1     = !done1 && !have1 && !hhdr1;
  assign other_lo1     = have1 ? id1 : hmin1;
  assign other_lo0     = have0 ? id0 : hmin0;
  assign can_skip0     = hhdr0 && !have0 && !dfetched0 && (have1 || hhdr1)
                       && (hmax0 < other_lo1);
  assign can_skip1     = hhdr1 && !have1 && !dfetched1 && (have0 || hhdr0)
                       && (hmax1 < other_lo0);

  always_comb begin
    dir_addr0 = INDEX_BASE
              + (28'(k0_r[B_W-1:0]) * 28'(ENTRY_BYTES));
    dir_addr1 = INDEX_BASE
              + 28'(TABLE_BYTES)
              + (28'(k1_r[B_W-1:0]) * 28'(ENTRY_BYTES));
    if (!fetch_sel) begin
      if (pos0 < hcnt0) begin
        rbase  = hbase0;
        pos_in = pos0;
        rem_reg = hcnt0 - pos0;
      end else begin
        rbase  = obase0;
        pos_in = pos0 - hcnt0;
        rem_reg = ocnt0 - (pos0 - hcnt0);
      end
      page_idx = pos_in >> PAGE_SHIFT;
      hdr_addr = rbase + (28'(page_idx) * 28'(PAGE_BYTES));
      data_addr = hdr_addr + 28'(ENTRY_BYTES)
                + (28'(dbeat0) * 28'(ENTRY_BYTES));
      if (hhdr0)
        rem_page = hnrec0 - (pos0 - pstart0);
      else
        rem_page = rem_reg;
    end else begin
      if (pos1 < hcnt1) begin
        rbase  = hbase1;
        pos_in = pos1;
        rem_reg = hcnt1 - pos1;
      end else begin
        rbase  = obase1;
        pos_in = pos1 - hcnt1;
        rem_reg = ocnt1 - (pos1 - hcnt1);
      end
      page_idx = pos_in >> PAGE_SHIFT;
      hdr_addr = rbase + (28'(page_idx) * 28'(PAGE_BYTES));
      data_addr = hdr_addr + 28'(ENTRY_BYTES)
                + (28'(dbeat1) * 28'(ENTRY_BYTES));
      if (hhdr1)
        rem_page = hnrec1 - (pos1 - pstart1);
      else
        rem_page = rem_reg;
    end
    if (rem_page >= 16'd4)
      nv_cur = 3'd4;
    else
      nv_cur = rem_page[2:0];
    post_addr = data_addr;
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
      acc_nskip <= '0; acc_nhdr <= '0;
      acc_ovf <= 1'b0; acc_incomp <= 1'b0; acc_pmask <= '0;
      cand_v <= 1'b0; cand_id <= '0; q_done <= 1'b0;
      q_overflow_o <= 1'b0; q_incomplete_o <= 1'b0;
      n_emit_o <= '0; n_dup_o <= '0; n_trunc_o <= '0;
      n_dir_ar_o <= '0; n_post_ar_o <= '0; probed_mask_o <= '0;
      n_page_skip_o <= '0; n_hdr_ar_o <= '0;
      m_axi_arvalid <= 1'b0; m_axi_araddr <= '0; m_axi_arlen <= 8'd0;
      m_axi_rready <= 1'b0;
      hbase0 <= '0; hbase1 <= '0; obase0 <= '0; obase1 <= '0;
      hcnt0 <= '0; hcnt1 <= '0; ocnt0 <= '0; ocnt1 <= '0;
      tot0 <= '0; tot1 <= '0; pos0 <= '0; pos1 <= '0;
      ovf0 <= 1'b0; ovf1 <= 1'b0;
      done0 <= 1'b1; done1 <= 1'b1; have0 <= 1'b0; have1 <= 1'b0;
      hhdr0 <= 1'b0; hhdr1 <= 1'b0; dfetched0 <= 1'b0; dfetched1 <= 1'b0;
      hmin0 <= '0; hmin1 <= '0; hmax0 <= '0; hmax1 <= '0;
      hnrec0 <= '0; hnrec1 <= '0; pstart0 <= '0; pstart1 <= '0;
      dbeat0 <= '0; dbeat1 <= '0;
      beat0 <= '0; beat1 <= '0; lane0 <= '0; lane1 <= '0;
      nval0 <= '0; nval1 <= '0; id0 <= '0; id1 <= '0;
    end else begin
      q_done <= 1'b0;
      adv0 = 1'b0;
      adv1 = 1'b0;
      skip0 = 1'b0;
      skip1 = 1'b0;
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
            acc_nskip <= '0; acc_nhdr <= '0;
            acc_ovf <= 1'b0; acc_incomp <= 1'b0; acc_pmask <= '0;
            st <= S_DISPATCH;
          end else if (qse_valid_o && !issued) begin
            k0_r <= k0_o; k1_r <= k1_o; k2_r <= k2_o; k3_r <= k3_o;
            v0_r <= k0_valid_o; v1_r <= k1_valid_o;
            v2_r <= k2_valid_o; v3_r <= k3_valid_o;
            issued <= 1'b1;
            nemit <= '0;
            acc_ndup <= '0; acc_ntrunc <= '0; acc_ndir <= '0; acc_npost <= '0;
            acc_nskip <= '0; acc_nhdr <= '0;
            acc_ovf <= 1'b0; acc_incomp <= 1'b0; acc_pmask <= '0;
            st <= S_DISPATCH;
          end
        end

        S_DISPATCH: begin
          done0 <= 1'b1; done1 <= 1'b1;
          have0 <= 1'b0; have1 <= 1'b0;
          hhdr0 <= 1'b0; hhdr1 <= 1'b0;
          dfetched0 <= 1'b0; dfetched1 <= 1'b0;
          pos0 <= '0; pos1 <= '0;
          tot0 <= '0; tot1 <= '0;
          ovf0 <= 1'b0; ovf1 <= 1'b0;
          hcnt0 <= '0; hcnt1 <= '0; ocnt0 <= '0; ocnt1 <= '0;
          dbeat0 <= '0; dbeat1 <= '0;
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
            end else if (need_hdr0 || need_hdr1) begin
              if (acc_npost >= MERGE_POST_AR_MAX[15:0]) begin
                acc_incomp <= 1'b1;
                acc_ntrunc <= acc_ntrunc + 16'd1;
                st <= S_DONE;
              end else begin
                if (need_hdr0 && need_hdr1)
                  fetch_sel <= (occ0 <= occ1) ? 1'b0 : 1'b1;
                else if (need_hdr0)
                  fetch_sel <= 1'b0;
                else
                  fetch_sel <= 1'b1;
                st <= S_ARHDR;
              end
            end else if (can_skip0) begin
              skip0 = 1'b1;
            end else if (can_skip1) begin
              skip1 = 1'b1;
            end else if (hhdr0 && !have0 && !dfetched0 && have1 && (hmin0 > id1)) begin
              adv1 = 1'b1;
            end else if (hhdr1 && !have1 && !dfetched1 && have0 && (hmin1 > id0)) begin
              adv0 = 1'b1;
            end else if ((!have0 && hhdr0) || (!have1 && hhdr1)) begin
              if (acc_npost >= MERGE_POST_AR_MAX[15:0]) begin
                acc_incomp <= 1'b1;
                acc_ntrunc <= acc_ntrunc + 16'd1;
                st <= S_DONE;
              end else begin
                if (!have0 && hhdr0 && !have1 && hhdr1)
                  fetch_sel <= (occ0 <= occ1) ? 1'b0 : 1'b1;
                else if (!have0 && hhdr0)
                  fetch_sel <= 1'b0;
                else
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
            if (done0) begin
              st <= S_DONE;
            end else if (!have0 && !hhdr0) begin
              if (acc_npost >= MERGE_POST_AR_MAX[15:0]) begin
                acc_incomp <= 1'b1;
                acc_ntrunc <= acc_ntrunc + 16'd1;
                st <= S_DONE;
              end else begin
                fetch_sel <= 1'b0;
                st <= S_ARHDR;
              end
            end else if (!have0 && hhdr0) begin
              if (acc_npost >= MERGE_POST_AR_MAX[15:0]) begin
                acc_incomp <= 1'b1;
                acc_ntrunc <= acc_ntrunc + 16'd1;
                st <= S_DONE;
              end else begin
                fetch_sel <= 1'b0;
                st <= S_ARPOST;
              end
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
            if (done1) begin
              st <= S_DONE;
            end else if (!have1 && !hhdr1) begin
              if (acc_npost >= MERGE_POST_AR_MAX[15:0]) begin
                acc_incomp <= 1'b1;
                acc_ntrunc <= acc_ntrunc + 16'd1;
                st <= S_DONE;
              end else begin
                fetch_sel <= 1'b1;
                st <= S_ARHDR;
              end
            end else if (!have1 && hhdr1) begin
              if (acc_npost >= MERGE_POST_AR_MAX[15:0]) begin
                acc_incomp <= 1'b1;
                acc_ntrunc <= acc_ntrunc + 16'd1;
                st <= S_DONE;
              end else begin
                fetch_sel <= 1'b1;
                st <= S_ARPOST;
              end
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

        S_ARHDR: begin
          m_axi_araddr  <= hdr_addr;
          m_axi_arlen   <= 8'd0;
          m_axi_arvalid <= 1'b1;
          if (m_axi_arvalid && m_axi_arready) begin
            m_axi_arvalid <= 1'b0;
            acc_npost     <= acc_npost + 16'd1;
            acc_nhdr      <= acc_nhdr + 16'd1;
            st <= S_RHDR;
          end
        end

        S_RHDR: begin
          m_axi_rready <= 1'b1;
          if (m_axi_rvalid && m_axi_rready) begin
            m_axi_rready <= 1'b0;
            if (!fetch_sel) begin
              hmin0    <= m_axi_rdata[ID_W-1:0];
              hmax0    <= m_axi_rdata[32 +: ID_W];
              hnrec0   <= m_axi_rdata[79:64];
              pstart0  <= pos0;
              dbeat0   <= 4'd0;
              dfetched0<= 1'b0;
              if (m_axi_rdata[79:64] == 16'd0)
                done0 <= 1'b1;
              else
                hhdr0 <= 1'b1;
            end else begin
              hmin1    <= m_axi_rdata[ID_W-1:0];
              hmax1    <= m_axi_rdata[32 +: ID_W];
              hnrec1   <= m_axi_rdata[79:64];
              pstart1  <= pos1;
              dbeat1   <= 4'd0;
              dfetched1<= 1'b0;
              if (m_axi_rdata[79:64] == 16'd0)
                done1 <= 1'b1;
              else
                hhdr1 <= 1'b1;
            end
            st <= S_NEXT;
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
              beat0     <= m_axi_rdata;
              lane0     <= 2'd0;
              nval0     <= nv_cur;
              id0       <= m_axi_rdata[ID_W-1:0];
              dbeat0    <= dbeat0 + 4'd1;
              dfetched0 <= 1'b1;
              if (nv_cur == 3'd0)
                done0 <= 1'b1;
              else
                have0 <= 1'b1;
            end else begin
              beat1     <= m_axi_rdata;
              lane1     <= 2'd0;
              nval1     <= nv_cur;
              id1       <= m_axi_rdata[ID_W-1:0];
              dbeat1    <= dbeat1 + 4'd1;
              dfetched1 <= 1'b1;
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
          n_page_skip_o  <= acc_nskip;
          n_hdr_ar_o     <= acc_nhdr;
          st <= S_IDLE;
        end

        default: st <= S_IDLE;
      endcase

      if (skip0) begin
        pos0 <= pos0 + hnrec0;
        hhdr0 <= 1'b0;
        have0 <= 1'b0;
        dfetched0 <= 1'b0;
        acc_nskip <= acc_nskip + 16'd1;
        if ((pos0 + hnrec0) >= tot0)
          done0 <= 1'b1;
      end
      if (skip1) begin
        pos1 <= pos1 + hnrec1;
        hhdr1 <= 1'b0;
        have1 <= 1'b0;
        dfetched1 <= 1'b0;
        acc_nskip <= acc_nskip + 16'd1;
        if ((pos1 + hnrec1) >= tot1)
          done1 <= 1'b1;
      end
      if (adv0) begin
        pos0 <= pos0 + 16'd1;
        if ((pos0 + 16'd1) >= tot0) begin
          done0 <= 1'b1;
          have0 <= 1'b0;
          hhdr0 <= 1'b0;
          dfetched0 <= 1'b0;
        end else if (({1'b0, lane0} + 3'd1) < nval0) begin
          lane0 <= ln0;
          id0   <= beat0[32*ln0 +: ID_W];
          have0 <= 1'b1;
        end else begin
          have0 <= 1'b0;
          if ((pos0 + 16'd1 - pstart0) >= hnrec0) begin
            hhdr0 <= 1'b0;
            dfetched0 <= 1'b0;
          end
        end
      end
      if (adv1) begin
        pos1 <= pos1 + 16'd1;
        if ((pos1 + 16'd1) >= tot1) begin
          done1 <= 1'b1;
          have1 <= 1'b0;
          hhdr1 <= 1'b0;
          dfetched1 <= 1'b0;
        end else if (({1'b0, lane1} + 3'd1) < nval1) begin
          lane1 <= ln1;
          id1   <= beat1[32*ln1 +: ID_W];
          have1 <= 1'b1;
        end else begin
          have1 <= 1'b0;
          if ((pos1 + 16'd1 - pstart1) >= hnrec1) begin
            hhdr1 <= 1'b0;
            dfetched1 <= 1'b0;
          end
        end
      end
    end
  end
endmodule
