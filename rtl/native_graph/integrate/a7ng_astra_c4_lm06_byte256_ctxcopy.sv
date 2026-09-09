// a7ng_astra_c4_lm06_byte256_ctxcopy.sv — ASTRA-C4-LM06-BYTE256-CTXCOPY-01.
// PROGRAM=NO. Copies next token from FPGA-visible PROOF bytes already in context.
// No object-indexed name LUT. Proof-byte ports only. Instantiates BYTE256 only.
// Does not edit KEEP / TinyGPT / compose / dict DUT. Host next-token = 0.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_lm06_byte256.svh"
`include "a7ng_astra_c4_lm06_byte256_ctxcopy.svh"

module a7ng_astra_c4_lm06_byte256_ctxcopy (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        go_i,
  input  logic        retire_i,
  input  logic        load_v_i,
  input  logic [1:0]  load_sel_i,
  input  logic signed [15:0] load_w_i,
  input  logic [7:0]  proof0_i,
  input  logic [7:0]  proof1_i,
  input  logic [7:0]  proof2_i,
  input  logic        evid_has_i,
  output logic        busy_o,
  output logic        done_o,
  output logic        tok_valid_o,
  output logic [7:0]  tok_o,
  output logic        eos_o,
  output logic [9:0]  head10_o,
  output logic        masked_hi_o,
  output logic [15:0] n_host_tok_o,
  output logic [7:0]  n_out_o,
  output logic [7:0]  mat_q0_o,
  output logic [7:0]  mat_p0_o,
  output logic [3:0]  vocab_ver_o
);
  typedef enum logic [2:0] { S_IDLE, S_MAT, S_CAND, S_GO256, S_WAIT256, S_EMIT, S_DONE } st_t;
  st_t st;

  logic signed [15:0] g_copy, g_safe, g_eos;
  logic [7:0] proof [0:2];
  logic [7:0] step, n_out, last_tok, q0, p0;
  logic       evid_has;
  integer k;

  logic b_go, b_ret, b_busy, b_done, b_valid, b_mask, b_eos, b_phys;
  logic [7:0] b_in, b_out, b_feed;
  logic [9:0] b_head;
  logic [15:0] b_nhost;
  logic [4:0] b_iw, b_ow, b_hw;
  logic [9:0] cid [0:3];
  logic signed [15:0] csc [0:3];

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
  assign mat_q0_o = q0;
  assign mat_p0_o = p0;
  assign vocab_ver_o = A7NG_C4X_VOCAB_VER;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      g_copy <= 16'sd0; g_safe <= 16'sd0; g_eos <= 16'sd0;
      proof[0] <= 8'd0; proof[1] <= 8'd0; proof[2] <= 8'd0;
      evid_has <= 1'b0;
      step <= 8'd0; n_out <= 8'd0; last_tok <= 8'd0;
      q0 <= 8'd0; p0 <= 8'd0;
      tok_valid_o <= 1'b0; tok_o <= 8'd0; eos_o <= 1'b0;
      b_go <= 1'b0; b_ret <= 1'b0; b_in <= 8'd0;
      for (k = 0; k < 4; k = k + 1) begin cid[k] <= 10'd0; csc[k] <= 16'sd0; end
    end else begin
      tok_valid_o <= 1'b0;
      b_go <= 1'b0;
      b_ret <= 1'b0;
      if (load_v_i && (st == S_IDLE)) begin
        unique case (load_sel_i)
          2'd0: ;
          A7NG_C4X_LD_COPY: g_copy <= load_w_i;
          A7NG_C4X_LD_SAFE: g_safe <= load_w_i;
          A7NG_C4X_LD_EOS:  g_eos  <= load_w_i;
          default: ;
        endcase
      end
      unique case (st)
        S_IDLE: begin
          eos_o <= 1'b0;
          if (go_i) begin
            proof[0] <= proof0_i;
            proof[1] <= proof1_i;
            proof[2] <= proof2_i;
            evid_has <= evid_has_i;
            step <= 8'd0;
            n_out <= 8'd0;
            last_tok <= 8'd0;
            st <= S_MAT;
          end
        end
        S_MAT: begin
          q0 <= A7NG_C4X_MARK_Q;
          p0 <= evid_has ? proof[0] : A7NG_C4X_EOS;
          st <= S_CAND;
        end
        S_CAND: begin
          if (!evid_has || (g_copy <= 16'sd0) || (step >= A7NG_C4X_NAME_N[7:0])) begin
            cid[0] <= {2'd0, A7NG_C4X_EOS};
            csc[0] <= (g_safe > 16'sd0) ? g_safe : ((g_eos > 16'sd0) ? g_eos : 16'sd1);
            cid[1] <= {2'd0, proof[0]}; csc[1] <= 16'sd0;
            cid[2] <= 10'd88; csc[2] <= 16'sd0;
            cid[3] <= 10'd32; csc[3] <= 16'sd0;
          end else begin
            cid[0] <= {2'd0, proof[step]}; csc[0] <= g_copy;
            cid[1] <= {2'd0, A7NG_C4X_EOS}; csc[1] <= 16'sd0;
            cid[2] <= 10'd88; csc[2] <= 16'sd0;
            cid[3] <= 10'd32; csc[3] <= 16'sd0;
          end
          b_in <= (step == 8'd0) ? A7NG_C4X_MARK_P : last_tok;
          st <= S_GO256;
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
          tok_o <= b_valid ? b_out : A7NG_C4X_EOS;
          eos_o <= (!b_valid) || b_eos || (b_out == A7NG_C4X_EOS);
          last_tok <= b_valid ? b_out : A7NG_C4X_EOS;
          n_out <= n_out + 8'd1;
          b_ret <= 1'b1;
          if ((!b_valid) || b_eos || (b_out == A7NG_C4X_EOS)
              || (n_out + 8'd1 >= A7NG_C4X_MAX_TOKENS[7:0]))
            st <= S_DONE;
          else begin
            step <= step + 8'd1;
            st <= S_CAND;
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
