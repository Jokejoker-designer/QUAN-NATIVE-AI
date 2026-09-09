// a7ng_query_role_parse.sv — draft only. ASTRA-03 authority is
// a7ng_query_role_extract.sv / qse-v2-role-00 (not compiled in ASTRA-03 TB).
// Position-ordered SVO packet. Does not edit qse-v1. PROGRAM=NO.
// First entity=subject, relation word, second entity=object.
// FORBIDDEN: lowest-ID pick among entities; exam-phrase ROM.
`timescale 1ns / 1ps
`include "qse_role_lexicon.svh"

module a7ng_query_role_parse (
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
  output logic [7:0]  subject_id_o,
  output logic [7:0]  object_id_o,
  output logic [7:0]  relation_id_o,
  output logic [1:0]  direction_o,
  output logic        negation_o,
  output logic        ambiguous_o,
  output logic        subj_valid_o,
  output logic        obj_valid_o,
  output logic        rel_valid_o,
  output logic [15:0] n_host_any_o
);
  localparam int unsigned MAX_BYTES = 48;
  localparam int unsigned MAX_WORDS = 8;

  logic [7:0]  n_bytes, n_words, wlen;
  logic [95:0] wbuf;
  logic [7:0]  subj, obj, rel;
  logic        sv, ov, rv, neg, amb;

  logic        hit;
  logic [7:0]  hcls, hid;
  logic [7:0]  subj_n, obj_n, rel_n;
  logic        sv_n, ov_n, rv_n, neg_n, amb_n;
  logic        do_flush, do_fire, do_space;
  integer      li;

  assign n_host_any_o = 16'd0;
  assign tok_ready_o  = rst_n && !valid_o && (n_bytes < MAX_BYTES[7:0]) && (n_words < MAX_WORDS[7:0]);
  assign busy_o       = valid_o;
  assign direction_o  = 2'd0; // as-written SVO; reverse voice is a later grammar

  function automatic logic [7:0] lc(input logic [7:0] t);
    if ((t >= 8'h41) && (t <= 8'h5A))
      return t + 8'h20;
    return t;
  endfunction

  assign do_space = tok_valid_i && tok_ready_o && (tok_i == 8'h20) && (wlen != 8'd0);
  assign do_fire  = fire_i && !valid_o && ((wlen != 8'd0) || (n_words != 8'd0) || (n_bytes != 8'd0));
  assign do_flush = do_space || (do_fire && (wlen != 8'd0));

  always_comb begin
    hit  = 1'b0;
    hcls = 8'd0;
    hid  = 8'd0;
    for (li = 0; li < ROLE_N_LEX; li = li + 1) begin
      if ((wlen == ROLE_LEN[li]) && (wbuf == ROLE_WORD[li])) begin
        if (!hit) begin
          hit  = 1'b1;
          hcls = ROLE_CLS[li];
          hid  = ROLE_ID[li];
        end
      end
    end
    subj_n = subj; obj_n = obj; rel_n = rel;
    sv_n = sv; ov_n = ov; rv_n = rv; neg_n = neg; amb_n = amb;
    if (do_flush && hit) begin
      if (hcls == 8'd1) begin
        if (!sv_n) begin
          subj_n = hid;
          sv_n   = 1'b1;
        end else if (!ov_n) begin
          obj_n = hid;
          ov_n  = 1'b1;
        end else
          amb_n = 1'b1;
      end else if (hcls == 8'd2) begin
        if (!rv_n) begin
          rel_n = hid;
          rv_n  = 1'b1;
        end else
          amb_n = 1'b1;
      end else if (hcls == 8'd4) begin
        neg_n = 1'b1;
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      n_bytes <= 8'd0; n_words <= 8'd0; wlen <= 8'd0; wbuf <= 96'd0;
      subj <= 8'd0; obj <= 8'd0; rel <= 8'd0;
      sv <= 1'b0; ov <= 1'b0; rv <= 1'b0; neg <= 1'b0; amb <= 1'b0;
      accepted_o <= 1'b0; valid_o <= 1'b0;
      subject_id_o <= 8'd0; object_id_o <= 8'd0; relation_id_o <= 8'd0;
      negation_o <= 1'b0; ambiguous_o <= 1'b0;
      subj_valid_o <= 1'b0; obj_valid_o <= 1'b0; rel_valid_o <= 1'b0;
    end else begin
      accepted_o <= 1'b0;
      if (valid_o) begin
        if (retire_i) begin
          valid_o <= 1'b0;
          n_bytes <= 8'd0; n_words <= 8'd0; wlen <= 8'd0; wbuf <= 96'd0;
          subj <= 8'd0; obj <= 8'd0; rel <= 8'd0;
          sv <= 1'b0; ov <= 1'b0; rv <= 1'b0; neg <= 1'b0; amb <= 1'b0;
          subj_valid_o <= 1'b0; obj_valid_o <= 1'b0; rel_valid_o <= 1'b0;
        end
      end else if (tok_valid_i && tok_ready_o) begin
        n_bytes <= n_bytes + 8'd1;
        if (tok_i == 8'h20) begin
          if (wlen != 8'd0) begin
            subj <= subj_n; obj <= obj_n; rel <= rel_n;
            sv <= sv_n; ov <= ov_n; rv <= rv_n; neg <= neg_n; amb <= amb_n;
            n_words <= n_words + 8'd1;
            wlen <= 8'd0;
            wbuf <= 96'd0;
          end
        end else if (wlen < ROLE_MAX_WORD[7:0]) begin
          wbuf[8*wlen +: 8] <= lc(tok_i);
          wlen <= wlen + 8'd1;
        end
      end else if (do_fire) begin
        subject_id_o  <= subj_n;
        object_id_o   <= obj_n;
        relation_id_o <= rel_n;
        negation_o    <= neg_n;
        ambiguous_o   <= amb_n;
        subj_valid_o  <= sv_n;
        obj_valid_o   <= ov_n;
        rel_valid_o   <= rv_n;
        subj <= subj_n; obj <= obj_n; rel <= rel_n;
        sv <= sv_n; ov <= ov_n; rv <= rv_n; neg <= neg_n; amb <= amb_n;
        valid_o    <= 1'b1;
        accepted_o <= 1'b1;
        wlen <= 8'd0;
        wbuf <= 96'd0;
      end
    end
  end
endmodule
