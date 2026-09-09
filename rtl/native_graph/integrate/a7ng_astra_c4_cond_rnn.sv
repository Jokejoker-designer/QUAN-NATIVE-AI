// a7ng_astra_c4_cond_rnn.sv — ASTRA-C4-COND-RNN-BYTE256-01. PROGRAM=NO.
// Named compact integer Elman decoder. Context bytes and prefix token both
// enter the recurrent state consumed by every BYTE256 score.
// Does not edit grounded_gen KEEP / TinyGPT / live prod_top.
// Not C4_MASTER. !evid_has safety gate is outside learned scores.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_cond_rnn.svh"

module a7ng_astra_c4_cond_rnn (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        go_i,
  input  logic        retire_i,
  input  logic        evid_has_i,
  input  logic        zero_w_i,
  input  logic [7:0]  seed_tok_i,
  input  logic [4:0]  ctx_n_i,
  input  logic [7:0]  ctx_i [0:15],
  output logic        busy_o,
  output logic        done_o,
  output logic        tok_valid_o,
  output logic [7:0]  tok_o,
  output logic        eos_o,
  output logic [7:0]  n_out_o,
  output logic [15:0] n_mac_o,
  output logic [15:0] n_host_tok_o,
  output logic [3:0]  vocab_ver_o
);
  typedef enum logic [4:0] {
    S_IDLE, S_ENC_LD, S_ENC_BIAS, S_ENC_E, S_ENC_HH, S_ENC_SAT, S_ENC_SWAP,
    S_DEC_LD, S_DEC_BIAS, S_DEC_E, S_DEC_HH, S_DEC_SAT, S_DEC_SWAP,
    S_SCAN_BY, S_SCAN_E, S_EMIT, S_SAFE, S_DONE
  } st_t;
  st_t st;

  logic signed [7:0] wmem [0:A7NG_C4R_N_W-1];
  logic signed [7:0] h [0:A7NG_C4R_H-1];
  logic signed [7:0] hnext [0:A7NG_C4R_H-1];
  logic signed [7:0] evec [0:A7NG_C4R_E-1];
  logic [7:0] ctxb [0:15];
  logic [4:0] ctxn, ci;
  logic [3:0] ei, hi, hh;
  logic [8:0] vi;
  logic [7:0] last_tok, n_out, safe_i;
  logic evid_has, zw, have_best;
  logic signed [31:0] acc, tmp;
  logic signed [31:0] best_sc;
  logic [7:0] best_v;
  logic [15:0] n_mac;
  integer k;

  initial $readmemh("a7ng_astra_c4_cond_rnn.hex", wmem);

  function automatic logic signed [7:0] rd(input int unsigned idx);
    begin
      rd = zw ? 8'sd0 : wmem[idx];
    end
  endfunction
  function automatic logic signed [7:0] sat8(input logic signed [31:0] x);
    begin
      if (x > 32'sd127) sat8 = 8'sd127;
      else if (x < -32'sd127) sat8 = -8'sd127;
      else sat8 = x[7:0];
    end
  endfunction

  assign busy_o = (st != S_IDLE) && (st != S_DONE);
  assign done_o = (st == S_DONE);
  assign n_out_o = n_out;
  assign n_mac_o = n_mac;
  assign n_host_tok_o = 16'd0;
  assign vocab_ver_o = A7NG_C4R_VOCAB_VER;

  always_comb begin
    tmp = acc + $signed(rd(A7NG_C4R_OFF_WE + (vi * A7NG_C4R_E) + ei))
              * $signed(h[ei[2:0]]);
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      evid_has <= 1'b0;
      zw <= 1'b0;
      ctxn <= 5'd0;
      ci <= 5'd0;
      ei <= 4'd0;
      hi <= 4'd0;
      hh <= 4'd0;
      vi <= 9'd0;
      last_tok <= 8'd0;
      n_out <= 8'd0;
      safe_i <= 8'd0;
      acc <= 32'sd0;
      best_sc <= 32'sd0;
      best_v <= 8'd0;
      have_best <= 1'b0;
      n_mac <= 16'd0;
      tok_valid_o <= 1'b0;
      tok_o <= 8'd0;
      eos_o <= 1'b0;
      for (k = 0; k < A7NG_C4R_H; k = k + 1) begin
        h[k] <= 8'sd0;
        hnext[k] <= 8'sd0;
      end
      for (k = 0; k < A7NG_C4R_E; k = k + 1) evec[k] <= 8'sd0;
      for (k = 0; k < 16; k = k + 1) ctxb[k] <= 8'd0;
    end else begin
      tok_valid_o <= 1'b0;
      unique case (st)
        S_IDLE: begin
          eos_o <= 1'b0;
          if (go_i) begin
            evid_has <= evid_has_i;
            zw <= zero_w_i;
            last_tok <= seed_tok_i;
            ctxn <= (ctx_n_i > 5'd16) ? 5'd16 : ctx_n_i;
            for (k = 0; k < 16; k = k + 1) ctxb[k] <= ctx_i[k];
            n_out <= 8'd0;
            n_mac <= 16'd0;
            ci <= 5'd0;
            ei <= 4'd0;
            for (k = 0; k < A7NG_C4R_H; k = k + 1) h[k] <= 8'sd0;
            if (!evid_has_i) begin
              safe_i <= 8'd0;
              st <= S_SAFE;
            end else if (ctx_n_i == 5'd0) st <= S_DEC_LD;
            else st <= S_ENC_LD;
          end
        end
        S_ENC_LD: begin
          evec[ei[1:0]] <= rd(A7NG_C4R_OFF_WE
              + (32'(ctxb[ci]) * A7NG_C4R_E) + 32'(ei));
          if (ei == 4'(A7NG_C4R_E - 1)) begin
            ei <= 4'd0;
            hi <= 4'd0;
            st <= S_ENC_BIAS;
          end else ei <= ei + 4'd1;
        end
        S_ENC_BIAS: begin
          acc <= {{24{rd(A7NG_C4R_OFF_BH + 32'(hi))[7]}},
                  rd(A7NG_C4R_OFF_BH + 32'(hi))};
          ei <= 4'd0;
          st <= S_ENC_E;
        end
        S_ENC_E: begin
          acc <= acc + $signed(rd(A7NG_C4R_OFF_WXH
                      + (32'(hi) * A7NG_C4R_E) + 32'(ei)))
                     * $signed(evec[ei[1:0]]);
          n_mac <= n_mac + 16'd1;
          if (ei == 4'(A7NG_C4R_E - 1)) begin
            hh <= 4'd0;
            st <= S_ENC_HH;
          end else ei <= ei + 4'd1;
        end
        S_ENC_HH: begin
          acc <= acc + $signed(rd(A7NG_C4R_OFF_WHH
                      + (32'(hi) * A7NG_C4R_H) + 32'(hh)))
                     * $signed(h[hh[2:0]]);
          n_mac <= n_mac + 16'd1;
          if (hh == 4'(A7NG_C4R_H - 1)) st <= S_ENC_SAT;
          else hh <= hh + 4'd1;
        end
        S_ENC_SAT: begin
          hnext[hi[2:0]] <= sat8(acc >>> A7NG_C4R_SHR);
          if (hi == 4'(A7NG_C4R_H - 1)) st <= S_ENC_SWAP;
          else begin
            hi <= hi + 4'd1;
            st <= S_ENC_BIAS;
          end
        end
        S_ENC_SWAP: begin
          for (k = 0; k < A7NG_C4R_H; k = k + 1) h[k] <= hnext[k];
          if (ci + 5'd1 >= ctxn) begin
            ei <= 4'd0;
            st <= S_DEC_LD;
          end else begin
            ci <= ci + 5'd1;
            ei <= 4'd0;
            st <= S_ENC_LD;
          end
        end
        S_DEC_LD: begin
          evec[ei[1:0]] <= rd(A7NG_C4R_OFF_WE
              + (32'(last_tok) * A7NG_C4R_E) + 32'(ei));
          if (ei == 4'(A7NG_C4R_E - 1)) begin
            ei <= 4'd0;
            hi <= 4'd0;
            st <= S_DEC_BIAS;
          end else ei <= ei + 4'd1;
        end
        S_DEC_BIAS: begin
          acc <= {{24{rd(A7NG_C4R_OFF_BH + 32'(hi))[7]}},
                  rd(A7NG_C4R_OFF_BH + 32'(hi))};
          ei <= 4'd0;
          st <= S_DEC_E;
        end
        S_DEC_E: begin
          acc <= acc + $signed(rd(A7NG_C4R_OFF_WXH
                      + (32'(hi) * A7NG_C4R_E) + 32'(ei)))
                     * $signed(evec[ei[1:0]]);
          n_mac <= n_mac + 16'd1;
          if (ei == 4'(A7NG_C4R_E - 1)) begin
            hh <= 4'd0;
            st <= S_DEC_HH;
          end else ei <= ei + 4'd1;
        end
        S_DEC_HH: begin
          acc <= acc + $signed(rd(A7NG_C4R_OFF_WHH
                      + (32'(hi) * A7NG_C4R_H) + 32'(hh)))
                     * $signed(h[hh[2:0]]);
          n_mac <= n_mac + 16'd1;
          if (hh == 4'(A7NG_C4R_H - 1)) st <= S_DEC_SAT;
          else hh <= hh + 4'd1;
        end
        S_DEC_SAT: begin
          hnext[hi[2:0]] <= sat8(acc >>> A7NG_C4R_SHR);
          if (hi == 4'(A7NG_C4R_H - 1)) st <= S_DEC_SWAP;
          else begin
            hi <= hi + 4'd1;
            st <= S_DEC_BIAS;
          end
        end
        S_DEC_SWAP: begin
          for (k = 0; k < A7NG_C4R_H; k = k + 1) h[k] <= hnext[k];
          vi <= 9'd0;
          have_best <= 1'b0;
          best_v <= 8'd0;
          ei <= 4'd0;
          st <= S_SCAN_BY;
        end
        S_SCAN_BY: begin
          acc <= {{24{rd(A7NG_C4R_OFF_BY + 32'(vi))[7]}},
                  rd(A7NG_C4R_OFF_BY + 32'(vi))};
          ei <= 4'd0;
          st <= S_SCAN_E;
        end
        S_SCAN_E: begin
          n_mac <= n_mac + 16'd1;
          if (ei != 4'(A7NG_C4R_E - 1)) begin
            acc <= tmp;
            ei <= ei + 4'd1;
          end else begin
            if (!have_best || (tmp > best_sc)) begin
              have_best <= 1'b1;
              best_sc <= tmp;
              best_v <= vi[7:0];
            end
            if (vi == 9'(A7NG_C4R_V - 1)) st <= S_EMIT;
            else begin
              vi <= vi + 9'd1;
              st <= S_SCAN_BY;
            end
          end
        end
        S_EMIT: begin
          tok_valid_o <= 1'b1;
          tok_o <= best_v;
          eos_o <= (best_v == A7NG_C4R_EOS)
                || (n_out + 8'd1 >= A7NG_C4R_MAX_TOKENS[7:0]);
          last_tok <= best_v;
          n_out <= n_out + 8'd1;
          if ((best_v == A7NG_C4R_EOS)
              || (n_out + 8'd1 >= A7NG_C4R_MAX_TOKENS[7:0]))
            st <= S_DONE;
          else begin
            ei <= 4'd0;
            st <= S_DEC_LD;
          end
        end
        S_SAFE: begin
          tok_valid_o <= 1'b1;
          unique case (safe_i)
            8'd0: begin tok_o <= A7NG_C4R_CH_N; eos_o <= 1'b0; end
            8'd1: begin tok_o <= A7NG_C4R_CH_O; eos_o <= 1'b0; end
            default: begin tok_o <= A7NG_C4R_EOS; eos_o <= 1'b1; end
          endcase
          n_out <= n_out + 8'd1;
          if (safe_i >= 8'd2) st <= S_DONE;
          else safe_i <= safe_i + 8'd1;
        end
        S_DONE: begin
          if (retire_i) st <= S_IDLE;
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
