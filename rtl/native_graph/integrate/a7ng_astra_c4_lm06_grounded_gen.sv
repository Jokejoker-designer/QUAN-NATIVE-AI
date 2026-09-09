// a7ng_astra_c4_lm06_grounded_gen.sv — ASTRA-C4-LM06-GROUNDED-GEN-01. PROGRAM=NO.
// New named compact LM head. Instantiates BYTE256 adapter. Does not edit frozen
// tiny_gpt803k_core / a7lm06_pkg / a7ng_evidence_compose.
// Output depends on loadable weights AND evidence. Host next-token = 0.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_lm06_byte256.svh"
`include "a7ng_astra_c4_lm06_grounded_gen.svh"

module a7ng_astra_c4_lm06_grounded_gen (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        go_i,
  input  logic        retire_i,
  input  logic        load_v_i,
  input  logic [1:0]  load_sel_i,
  input  logic [5:0]  load_idx_i,
  input  logic signed [15:0] load_w_i,
  input  logic [7:0]  evid_obj_i,
  input  logic [7:0]  evid_rel_i,
  input  logic        evid_has_i,
  output logic        busy_o,
  output logic        done_o,
  output logic        tok_valid_o,
  output logic [7:0]  tok_o,
  output logic        eos_o,
  output logic [9:0]  head10_o,
  output logic        masked_hi_o,
  output logic [15:0] n_host_tok_o,
  output logic [7:0]  n_out_o
);
  typedef enum logic [2:0] { S_IDLE, S_SEED, S_SCAN, S_GO256, S_WAIT256, S_EMIT, S_DONE } st_t;
  st_t st;

  logic signed [15:0] bias [0:A7NG_C4G_V-1];
  logic signed [15:0] g_match, g_safe, g_eos;
  logic [7:0] x_obj, x_rel, step, n_out;
  logic evid_has;
  logic [5:0] t;
  logic [9:0] best_id;
  logic signed [15:0] best_sc;
  logic [7:0] last_tok;
  integer k;

  logic b_go, b_ret, b_busy, b_done, b_valid, b_mask, b_eos, b_phys;
  logic [7:0] b_in, b_out, b_feed;
  logic [9:0] b_head;
  logic [15:0] b_nhost;
  logic [4:0] b_iw, b_ow, b_hw;
  logic [9:0] cid [0:3];
  logic signed [15:0] csc [0:3];

  function automatic logic signed [15:0] score_at(input logic [5:0] ti);
    logic signed [15:0] s;
    begin
      s = bias[ti];
      if (ti == x_obj[5:0] && (x_obj < A7NG_C4G_V[7:0]))
        s = s + g_match;
      if (!evid_has && (ti == 6'd0))
        s = s + g_safe;
      if ((step != 8'd0) && (ti == 6'd0))
        s = s + g_eos;
      score_at = s;
    end
  endfunction

  a7ng_astra_c4_lm06_byte256 u_b256 (
    .clk(clk), .rst_n(rst_n), .go_i(b_go), .retire_i(b_ret),
    .in_tok_i(b_in), .cand_id_i(cid), .cand_sc_i(csc),
    .busy_o(b_busy), .done_o(b_done),
    .head10_o(b_head), .out_tok_o(b_out), .out_valid_o(b_valid),
    .masked_hi_o(b_mask), .eos_o(b_eos), .feed_tok_o(b_feed),
    .n_host_tok_o(b_nhost), .in_w_o(b_iw), .out_w_o(b_ow), .head_w_o(b_hw),
    .phys_head_present_o(b_phys)
  );

  assign busy_o = (st != S_IDLE) && (st != S_DONE);
  assign done_o = (st == S_DONE);
  assign n_host_tok_o = 16'd0;
  assign n_out_o = n_out;
  assign head10_o = b_head;
  assign masked_hi_o = b_mask;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      g_match <= 16'sd0; g_safe <= 16'sd0; g_eos <= 16'sd0;
      x_obj <= 8'd0; x_rel <= 8'd0; evid_has <= 1'b0; step <= 8'd0;
      t <= 6'd0; best_id <= 10'd0; best_sc <= 16'sd0;
      last_tok <= 8'd0; n_out <= 8'd0;
      tok_valid_o <= 1'b0; tok_o <= 8'd0; eos_o <= 1'b0;
      b_go <= 1'b0; b_ret <= 1'b0; b_in <= 8'd0;
      for (k = 0; k < A7NG_C4G_V; k = k + 1) bias[k] <= 16'sd0;
      for (k = 0; k < 4; k = k + 1) begin cid[k] <= 10'd0; csc[k] <= 16'sd0; end
    end else begin
      tok_valid_o <= 1'b0;
      b_go <= 1'b0;
      b_ret <= 1'b0;
      if (load_v_i && (st == S_IDLE)) begin
        unique case (load_sel_i)
          A7NG_C4G_LD_BIAS: if (load_idx_i < A7NG_C4G_V[5:0]) bias[load_idx_i] <= load_w_i;
          A7NG_C4G_LD_MATCH: g_match <= load_w_i;
          A7NG_C4G_LD_SAFE:  g_safe  <= load_w_i;
          A7NG_C4G_LD_EOS:   g_eos   <= load_w_i;
          default: ;
        endcase
      end
      unique case (st)
        S_IDLE: begin
          eos_o <= 1'b0;
          if (go_i) begin
            x_obj <= evid_obj_i;
            x_rel <= evid_rel_i;
            evid_has <= evid_has_i;
            step <= 8'd0;
            n_out <= 8'd0;
            last_tok <= 8'd0;
            t <= 6'd0;
            st <= S_SEED;
          end
        end
        S_SEED: begin
          best_id <= 10'd0;
          best_sc <= score_at(6'd0);
          t <= 6'd0;
          st <= S_SCAN;
        end
        S_SCAN: begin
          if (t == A7NG_C4G_V[5:0] - 6'd1) begin
            cid[0] <= best_id; csc[0] <= 16'sd100;
            cid[1] <= 10'd0;   csc[1] <= 16'sd0;
            cid[2] <= 10'd0;   csc[2] <= 16'sd0;
            cid[3] <= 10'd0;   csc[3] <= 16'sd0;
            b_in <= last_tok;
            st <= S_GO256;
          end else begin
            t <= t + 6'd1;
            if (score_at(t + 6'd1) > best_sc) begin
              best_sc <= score_at(t + 6'd1);
              best_id <= {4'd0, t + 6'd1};
            end
          end
        end
        S_GO256: begin
          b_go <= 1'b1;
          st <= S_WAIT256;
        end
        S_WAIT256: begin
          if (b_done) st <= S_EMIT;
        end
        S_EMIT: begin
          tok_valid_o <= b_valid;
          tok_o <= b_valid ? b_out : A7NG_C4G_EOS;
          eos_o <= (!b_valid) || b_eos || (b_out == A7NG_C4G_EOS);
          last_tok <= b_valid ? b_out : A7NG_C4G_EOS;
          n_out <= n_out + 8'd1;
          b_ret <= 1'b1;
          if ((!b_valid) || b_eos || (b_out == A7NG_C4G_EOS) || (n_out + 8'd1 >= A7NG_C4G_MAX_TOKENS[7:0]))
            st <= S_DONE;
          else begin
            step <= step + 8'd1;
            st <= S_SEED;
          end
        end
        S_DONE: begin
          if (retire_i) st <= S_IDLE;
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
