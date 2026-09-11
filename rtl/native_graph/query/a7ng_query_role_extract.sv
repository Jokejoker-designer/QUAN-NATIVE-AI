// a7ng_query_role_extract.sv — ASTRA-03 ROLE-AWARE-QUERY
// Law: qse-v2-role-00
// Streaming tokenizer → exact word lookup → FSM grammar (max two hypotheses).
// Packet identity is subject/object/relation/direction, NOT min-ID bag-of-words.
// HDC/XOR is cue-only. PROGRAM=NO.
`timescale 1ns / 1ps
`include "a7ng_gate14_crc.svh"
`include "qse_role_lexicon.svh"
`include "a7ng_op_dir_pkg.svh"

module a7ng_query_role_extract (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        tok_valid_i,
  output logic        tok_ready_o,
  input  logic [7:0]  tok_i,
  input  logic        fire_i,
  input  logic        retire_i,
  output logic        busy_o,
  output logic        accepted_o,
  output logic        valid_o,
  output logic [7:0]  subj_id_o,
  output logic [7:0]  obj_id_o,
  output logic [7:0]  rel_id_o,
  output logic [7:0]  ctx_id_o,
  output logic [1:0]  direction_o,
  output logic        negation_o,
  output logic        ambiguity_o,
  output logic        triple_valid_o,
  output logic [1:0]  n_hyp_o,
  output logic [63:0] subj_cue_o,
  output logic [63:0] obj_cue_o,
  output logic [63:0] rel_cue_o,
  output logic [63:0] ctx_cue_o,
  output logic [15:0] crc16_dbg_o,
  output logic [15:0] k0_o,
  output logic [15:0] k1_o,
  output logic [15:0] k2_o,
  output logic [15:0] k3_o,
  output logic        k0_valid_o,
  output logic        k1_valid_o,
  output logic        k2_valid_o,
  output logic        k3_valid_o,
  output logic [3:0]  valid_mask_o,
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
  output logic [15:0] n_host_answer_o
);
  import a7ng_pkg::*;

  localparam int unsigned MAX_BYTES = 48;
  localparam int unsigned MAX_WORDS = 8;
  localparam logic [1:0] ST_IDLE = 2'd0;
  localparam logic [1:0] ST_SUBJ = 2'd1;
  localparam logic [1:0] ST_REL  = 2'd2;
  localparam logic [1:0] ST_OBJ  = 2'd3;
  localparam logic [7:0] CLS_ENTITY = 8'd1;
  localparam logic [7:0] CLS_REL    = 8'd2;
  localparam logic [7:0] CLS_CTX    = 8'd3;
  localparam logic [7:0] CLS_RELCTX = 8'd4;
  localparam logic [7:0] CLS_NEG    = 8'd5;
  localparam logic [7:0] CLS_SKIP   = 8'd6;

  logic [7:0]  n_bytes, n_words, wlen;
  logic [95:0] wbuf;
  logic [15:0] crc_acc;
  logic [7:0]  sid, oid, rid, xid;
  cue_t        scue, ocue, rcue, xcue;
  logic        sh, oh, rh, xh, neg, amb, hyp_alt;
  logic [1:0]  pst, dir;

  assign n_host_entity_o  = 16'd0;
  assign n_host_intent_o  = 16'd0;
  assign n_host_hash_o    = 16'd0;
  assign n_host_shard_o   = 16'd0;
  assign n_host_bucket_o  = 16'd0;
  assign n_host_cand_o    = 16'd0;
  assign n_host_winner_o  = 16'd0;
  assign n_host_addr_o    = 16'd0;
  assign n_host_relpath_o = 16'd0;
  assign n_host_next_o    = 16'd0;
  assign n_host_answer_o  = 16'd0;

  assign tok_ready_o  = rst_n && !valid_o && (n_bytes < MAX_BYTES[7:0]) && (n_words < MAX_WORDS[7:0]);
  assign busy_o       = valid_o;
  assign k0_o         = {subj_id_o, rel_id_o};
  assign k1_o         = {obj_id_o, rel_id_o};
  assign k2_o         = subj_cue_o[15:0];
  assign k3_o         = obj_cue_o[15:0];
  assign valid_mask_o = {k3_valid_o, k2_valid_o, k1_valid_o, k0_valid_o};

  function automatic logic [7:0] lc(input logic [7:0] t);
    if ((t >= 8'h41) && (t <= 8'h5A))
      return t + 8'h20;
    return t;
  endfunction

  function automatic cue_t bindb(input cue_t c, input logic [7:0] b);
    return ng_rotl1(c) ^ {56'd0, b};
  endfunction

  logic        do_flush, do_fire, do_space;
  logic        hit;
  logic [7:0]  hcls, hid, cls;
  cue_t        bcue;
  logic [7:0]  sid_n, oid_n, rid_n, xid_n;
  cue_t        scue_n, ocue_n, rcue_n, xcue_n;
  logic        sh_n, oh_n, rh_n, xh_n, neg_n, amb_n, hyp_alt_n;
  logic [1:0]  pst_n, dir_n;
  integer      li, bi;

  assign do_space = tok_valid_i && tok_ready_o && (tok_i == 8'h20) && (wlen != 8'd0);
  assign do_fire  = fire_i && !valid_o && ((wlen != 8'd0) || (n_words != 8'd0) || (n_bytes != 8'd0));
  assign do_flush = do_space || (do_fire && (wlen != 8'd0));

  always_comb begin
    hit  = 1'b0;
    hcls = 8'd0;
    hid  = 8'd0;
    for (li = 0; li < QSE2_N_LEX; li = li + 1) begin
      if ((wlen == QSE2_LEN[li]) && (wbuf == QSE2_WORD[li])) begin
        if (!hit) begin
          hit  = 1'b1;
          hcls = QSE2_CLS[li];
          hid  = QSE2_ID[li];
        end else if ((QSE2_CLS[li] == hcls) && (QSE2_ID[li] < hid))
          hid = QSE2_ID[li];
      end
    end
    bcue = 64'd0;
    for (bi = 0; bi < 12; bi = bi + 1)
      if (bi < wlen)
        bcue = bindb(bcue, wbuf[8*bi +: 8]);

    sid_n = sid; oid_n = oid; rid_n = rid; xid_n = xid;
    scue_n = scue; ocue_n = ocue; rcue_n = rcue; xcue_n = xcue;
    sh_n = sh; oh_n = oh; rh_n = rh; xh_n = xh;
    neg_n = neg; amb_n = amb; hyp_alt_n = hyp_alt; pst_n = pst;
    dir_n = dir;
    cls = hcls;

    if (do_flush) begin
      if (hit && (hcls == CLS_RELCTX)) begin
        hyp_alt_n = 1'b1;
        if (pst == ST_SUBJ)
          cls = CLS_REL;
        else
          cls = CLS_CTX;
      end
      if ((!hit) || (cls == CLS_SKIP)) begin
        if (!hit)
          xcue_n = xcue ^ bcue;
      end else if (cls == CLS_NEG) begin
        neg_n = 1'b1;
      end else if (cls == CLS_CTX) begin
        if (!xh) xid_n = hid;
        xcue_n = xcue ^ bcue;
        xh_n = 1'b1;
      end else if (cls == CLS_ENTITY) begin
        if (rh && !sh && !oh) begin
          oid_n  = hid;
          ocue_n = bcue;
          oh_n   = 1'b1;
          pst_n  = ST_OBJ;
          dir_n  = A7NG_OP_R_INVERSE;
        end else if (!sh) begin
          sid_n  = hid;
          scue_n = bcue;
          sh_n   = 1'b1;
          pst_n  = rh ? ST_REL : ST_SUBJ;
          dir_n  = A7NG_OP_F_SVO_AS_WRITTEN;
        end else if (rh && !oh) begin
          oid_n  = hid;
          ocue_n = bcue;
          oh_n   = 1'b1;
          pst_n  = ST_OBJ;
        end else if (!oh) begin
          oid_n  = hid;
          ocue_n = bcue;
          oh_n   = 1'b1;
          amb_n  = 1'b1;
          pst_n  = ST_OBJ;
        end else
          amb_n = 1'b1;
      end else if (cls == CLS_REL) begin
        if (!rh) begin
          rid_n  = hid;
          rcue_n = bcue;
          rh_n   = 1'b1;
          if (sh)
            pst_n = ST_REL;
        end else
          amb_n = 1'b1;
      end else
        xcue_n = xcue ^ bcue;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      n_bytes <= 8'd0; n_words <= 8'd0; wlen <= 8'd0; wbuf <= 96'd0;
      crc_acc <= 16'hFFFF;
      sid <= 8'd0; oid <= 8'd0; rid <= 8'd0; xid <= 8'd0;
      scue <= 64'd0; ocue <= 64'd0; rcue <= 64'd0; xcue <= 64'd0;
      sh <= 1'b0; oh <= 1'b0; rh <= 1'b0; xh <= 1'b0;
      neg <= 1'b0; amb <= 1'b0; hyp_alt <= 1'b0; pst <= ST_IDLE;
      dir <= A7NG_OP_F_SVO_AS_WRITTEN;
      accepted_o <= 1'b0;
      valid_o <= 1'b0;
      subj_id_o <= 8'd0; obj_id_o <= 8'd0; rel_id_o <= 8'd0; ctx_id_o <= 8'd0;
      direction_o <= A7NG_OP_F_SVO_AS_WRITTEN;
      negation_o <= 1'b0; ambiguity_o <= 1'b0; triple_valid_o <= 1'b0;
      n_hyp_o <= 2'd1;
      subj_cue_o <= 64'd0; obj_cue_o <= 64'd0; rel_cue_o <= 64'd0; ctx_cue_o <= 64'd0;
      crc16_dbg_o <= 16'd0;
      k0_valid_o <= 1'b0; k1_valid_o <= 1'b0; k2_valid_o <= 1'b0; k3_valid_o <= 1'b0;
    end else begin
      accepted_o <= 1'b0;
      if (valid_o) begin
        if (retire_i) begin
          valid_o <= 1'b0;
          n_bytes <= 8'd0; n_words <= 8'd0; wlen <= 8'd0; wbuf <= 96'd0;
          crc_acc <= 16'hFFFF;
          sid <= 8'd0; oid <= 8'd0; rid <= 8'd0; xid <= 8'd0;
          scue <= 64'd0; ocue <= 64'd0; rcue <= 64'd0; xcue <= 64'd0;
          sh <= 1'b0; oh <= 1'b0; rh <= 1'b0; xh <= 1'b0;
          neg <= 1'b0; amb <= 1'b0; hyp_alt <= 1'b0; pst <= ST_IDLE;
          dir <= A7NG_OP_F_SVO_AS_WRITTEN;
          direction_o <= A7NG_OP_F_SVO_AS_WRITTEN;
          k0_valid_o <= 1'b0; k1_valid_o <= 1'b0; k2_valid_o <= 1'b0; k3_valid_o <= 1'b0;
        end
      end else if (tok_valid_i && tok_ready_o) begin
        crc_acc <= crc16_byte(crc_acc, tok_i);
        n_bytes <= n_bytes + 8'd1;
        if (tok_i == 8'h20) begin
          if (wlen != 8'd0) begin
            sid <= sid_n; oid <= oid_n; rid <= rid_n; xid <= xid_n;
            scue <= scue_n; ocue <= ocue_n; rcue <= rcue_n; xcue <= xcue_n;
            sh <= sh_n; oh <= oh_n; rh <= rh_n; xh <= xh_n;
            neg <= neg_n; amb <= amb_n; hyp_alt <= hyp_alt_n; pst <= pst_n;
            dir <= dir_n;
            n_words <= n_words + 8'd1;
            wlen <= 8'd0;
            wbuf <= 96'd0;
          end
        end else if (wlen < QSE2_MAX_WORD[7:0]) begin
          wbuf[8*wlen +: 8] <= lc(tok_i);
          wlen <= wlen + 8'd1;
        end
      end else if (do_fire) begin
        subj_id_o      <= sid_n;
        obj_id_o       <= oid_n;
        rel_id_o       <= rid_n;
        ctx_id_o       <= xid_n;
        negation_o     <= neg_n;
        ambiguity_o    <= amb_n;
        triple_valid_o <= sh_n & rh_n & oh_n;
        direction_o   <= dir_n;
        n_hyp_o        <= hyp_alt_n ? 2'd2 : 2'd1;
        subj_cue_o     <= scue_n;
        obj_cue_o      <= ocue_n;
        rel_cue_o      <= rcue_n;
        ctx_cue_o      <= xcue_n;
        crc16_dbg_o    <= crc_acc;
        sid <= sid_n; oid <= oid_n; rid <= rid_n; xid <= xid_n;
        scue <= scue_n; ocue <= ocue_n; rcue <= rcue_n; xcue <= xcue_n;
        sh <= sh_n; oh <= oh_n; rh <= rh_n; xh <= xh_n;
        neg <= neg_n; amb <= amb_n; hyp_alt <= hyp_alt_n; pst <= pst_n;
        dir <= dir_n;
        k0_valid_o <= sh_n & rh_n;
        k1_valid_o <= oh_n & rh_n;
        k2_valid_o <= sh_n;
        k3_valid_o <= oh_n;
        valid_o    <= 1'b1;
        accepted_o <= 1'b1;
        wlen <= 8'd0;
        wbuf <= 96'd0;
      end
    end
  end
endmodule
