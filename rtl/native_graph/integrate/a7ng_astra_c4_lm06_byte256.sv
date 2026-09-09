// a7ng_astra_c4_lm06_byte256.sv — ASTRA-C4-LM06-BYTE256-CONTRACT-01. PROGRAM=NO.
// New named BYTE256 adapter. Does not edit frozen LM-06 tiny_gpt803k_core / a7lm06_pkg.
// Physical 10-bit head remains visible. Semantic tokens are 8-bit 0..255.
// IDs 256..1023 are masked. Does not freeze LM06_BYTE256. Not grounded generation.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_lm06_byte256.svh"

module a7ng_astra_c4_lm06_byte256 (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        go_i,
  input  logic        retire_i,
  input  logic [A7NG_C4_IN_W-1:0] in_tok_i,
  input  logic [A7NG_C4_HEAD10_W-1:0] cand_id_i [0:A7NG_C4_NCAND-1],
  input  logic signed [15:0]          cand_sc_i [0:A7NG_C4_NCAND-1],
  output logic        busy_o,
  output logic        done_o,
  output logic [A7NG_C4_HEAD10_W-1:0] head10_o,
  output logic [A7NG_C4_OUT_W-1:0]    out_tok_o,
  output logic        out_valid_o,
  output logic        masked_hi_o,
  output logic        eos_o,
  output logic [A7NG_C4_OUT_W-1:0]    feed_tok_o,
  output logic [15:0] n_host_tok_o,
  output logic [4:0]  in_w_o,
  output logic [4:0]  out_w_o,
  output logic [4:0]  head_w_o,
  output logic        phys_head_present_o
);
  typedef enum logic [1:0] { S_IDLE, S_PICK, S_HOLD } st_t;
  st_t st;

  logic [A7NG_C4_HEAD10_W-1:0] win_id, head_q;
  logic signed [15:0] win_sc;
  logic [A7NG_C4_IN_W-1:0] in_q;
  logic mask_q, valid_q, eos_q;
  logic [A7NG_C4_OUT_W-1:0] out_q;
  integer k;

  always_comb begin
    win_id = cand_id_i[0];
    win_sc = cand_sc_i[0];
    for (k = 1; k < A7NG_C4_NCAND; k = k + 1) begin
      if (cand_sc_i[k] > win_sc) begin
        win_sc = cand_sc_i[k];
        win_id = cand_id_i[k];
      end
    end
  end

  assign busy_o = (st != S_IDLE) && (st != S_HOLD);
  assign done_o = (st == S_HOLD);
  assign head10_o = head_q;
  assign out_tok_o = out_q;
  assign out_valid_o = valid_q;
  assign masked_hi_o = mask_q;
  assign eos_o = eos_q;
  assign feed_tok_o = valid_q ? out_q : in_q;
  assign n_host_tok_o = 16'd0;
  assign in_w_o = 5'(A7NG_C4_IN_W);
  assign out_w_o = 5'(A7NG_C4_OUT_W);
  assign head_w_o = 5'(A7NG_C4_HEAD10_W);
  assign phys_head_present_o = 1'b1;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      head_q <= '0;
      in_q <= '0;
      out_q <= '0;
      mask_q <= 1'b0;
      valid_q <= 1'b0;
      eos_q <= 1'b0;
    end else begin
      unique case (st)
        S_IDLE: begin
          valid_q <= 1'b0;
          mask_q <= 1'b0;
          eos_q <= 1'b0;
          if (go_i) begin
            in_q <= in_tok_i;
            st <= S_PICK;
          end
        end
        S_PICK: begin
          head_q <= win_id;
          mask_q <= (win_id > A7NG_C4_BYTE_MAX);
          if (win_id > A7NG_C4_BYTE_MAX) begin
            out_q <= 8'd0;
            valid_q <= 1'b0;
            eos_q <= 1'b0;
          end else begin
            out_q <= win_id[A7NG_C4_OUT_W-1:0];
            valid_q <= 1'b1;
            eos_q <= (win_id[A7NG_C4_OUT_W-1:0] == A7NG_C4_EOS_BYTE);
          end
          st <= S_HOLD;
        end
        S_HOLD: begin
          if (retire_i) st <= S_IDLE;
        end
        default: begin
          st <= S_IDLE;
        end
      endcase
    end
  end
endmodule
