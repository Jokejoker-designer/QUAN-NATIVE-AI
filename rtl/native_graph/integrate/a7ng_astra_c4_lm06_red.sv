// a7ng_astra_c4_lm06_red.sv — ASTRA-C4-LM06-RED-BYTE256-01. PROGRAM=NO.
// Reduced decoder-only BYTE256 (tied embed, 1 causal attn, FFN).
// LM06-compatible token law. Does not instantiate TinyGPT-802k or grounded_gen KEEP.
// Safety gate is outside learned scores. Not C4_MASTER.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_lm06_red.svh"

module a7ng_astra_c4_lm06_red (
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
  output logic [9:0]  head10_o,
  output logic [7:0]  n_out_o,
  output logic [15:0] n_mac_o,
  output logic [15:0] n_host_tok_o,
  output logic [3:0]  vocab_ver_o
);
  typedef enum logic [4:0] {
    S_IDLE, S_CTX, S_SEED, S_QC, S_QSAT,
    S_KC, S_KSAT, S_DOT, S_DOTSAT, S_VC, S_VSAT, S_ADD,
    S_NORM, S_F1, S_F1SAT, S_F2, S_F2SAT, S_SCAN, S_SCANSAT, S_EMIT, S_GEN, S_SAFE, S_DONE
  } st_t;
  st_t st;

  logic signed [7:0] wmem [0:A7NG_C4L_N_W-1];
  logic signed [7:0] xs [0:A7NG_C4L_TMAX-1][0:A7NG_C4L_D-1];
  logic signed [7:0] qv [0:A7NG_C4L_D-1];
  logic signed [7:0] kv [0:A7NG_C4L_D-1];
  logic signed [7:0] vv [0:A7NG_C4L_D-1];
  logic signed [7:0] yv [0:A7NG_C4L_D-1];
  logic signed [7:0] zv [0:A7NG_C4L_D-1];
  logic signed [7:0] tv [0:A7NG_C4L_F-1];
  logic signed [31:0] accv [0:A7NG_C4L_D-1];
  logic [7:0] ctxb [0:15];
  logic [4:0] ctxn, ci, pos, last, jj;
  logic [2:0] dd, ee, ff, rr;
  logic [8:0] vi;
  logic [7:0] seed, n_out, safe_i, best_v;
  logic evid_has, zw, have_best;
  logic signed [31:0] acc, best_sc, wsum, den;
  logic signed [7:0] ss;
  logic [15:0] n_mac;
  integer k, kd;

  initial $readmemh("a7ng_astra_c4_lm06_red.hex", wmem);

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
  function automatic logic signed [7:0] relu8(input logic signed [7:0] x);
    begin
      relu8 = (x[7]) ? 8'sd0 : x;
    end
  endfunction

  assign busy_o = (st != S_IDLE) && (st != S_DONE);
  assign done_o = (st == S_DONE);
  assign n_out_o = n_out;
  assign n_mac_o = n_mac;
  assign n_host_tok_o = 16'd0;
  assign vocab_ver_o = A7NG_C4L_VOCAB_VER;
  assign head10_o = {2'b00, tok_o};

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      evid_has <= 1'b0;
      zw <= 1'b0;
      ctxn <= 5'd0;
      ci <= 5'd0;
      pos <= 5'd0;
      last <= 5'd0;
      jj <= 5'd0;
      dd <= 3'd0;
      ee <= 3'd0;
      ff <= 3'd0;
      rr <= 3'd0;
      vi <= 9'd0;
      seed <= 8'd0;
      n_out <= 8'd0;
      safe_i <= 8'd0;
      best_v <= 8'd0;
      have_best <= 1'b0;
      acc <= 32'sd0;
      best_sc <= 32'sd0;
      wsum <= 32'sd0;
      den <= 32'sd1;
      ss <= 8'sd0;
      n_mac <= 16'd0;
      tok_valid_o <= 1'b0;
      tok_o <= 8'd0;
      eos_o <= 1'b0;
      for (k = 0; k < A7NG_C4L_TMAX; k = k + 1)
        for (kd = 0; kd < A7NG_C4L_D; kd = kd + 1) xs[k][kd] <= 8'sd0;
      for (kd = 0; kd < A7NG_C4L_D; kd = kd + 1) begin
        qv[kd] <= 8'sd0; kv[kd] <= 8'sd0; vv[kd] <= 8'sd0;
        yv[kd] <= 8'sd0; zv[kd] <= 8'sd0; accv[kd] <= 32'sd0;
      end
      for (k = 0; k < A7NG_C4L_F; k = k + 1) tv[k] <= 8'sd0;
      for (k = 0; k < 16; k = k + 1) ctxb[k] <= 8'd0;
    end else begin
      tok_valid_o <= 1'b0;
      unique case (st)
        S_IDLE: begin
          eos_o <= 1'b0;
          if (go_i) begin
            evid_has <= evid_has_i;
            zw <= zero_w_i;
            seed <= seed_tok_i;
            ctxn <= (ctx_n_i > 5'd16) ? 5'd16 : ctx_n_i;
            for (k = 0; k < 16; k = k + 1) ctxb[k] <= ctx_i[k];
            n_out <= 8'd0;
            n_mac <= 16'd0;
            ci <= 5'd0;
            pos <= 5'd0;
            dd <= 3'd0;
            if (!evid_has_i) begin
              safe_i <= 8'd0;
              st <= S_SAFE;
            end else if (ctx_n_i == 5'd0) st <= S_SEED;
            else st <= S_CTX;
          end
        end
        S_CTX: begin
          xs[pos][dd[1:0]] <= rd(A7NG_C4L_OFF_WE
              + (32'(ctxb[ci]) * A7NG_C4L_D) + 32'(dd));
          if (dd == 3'(A7NG_C4L_D - 1)) begin
            dd <= 3'd0;
            pos <= pos + 5'd1;
            if (ci + 5'd1 >= ctxn) st <= S_SEED;
            else ci <= ci + 5'd1;
          end else dd <= dd + 3'd1;
        end
        S_SEED: begin
          xs[pos][dd[1:0]] <= rd(A7NG_C4L_OFF_WE
              + (32'(seed) * A7NG_C4L_D) + 32'(dd));
          if (dd == 3'(A7NG_C4L_D - 1)) begin
            last <= pos;
            pos <= pos + 5'd1;
            dd <= 3'd0;
            rr <= 3'd0;
            acc <= 32'sd0;
            ee <= 3'd0;
            st <= S_QC;
          end else dd <= dd + 3'd1;
        end
        S_QC: begin
          acc <= acc + $signed(rd(A7NG_C4L_OFF_WQ
                      + (32'(rr) * A7NG_C4L_D) + 32'(ee)))
                     * $signed(xs[last][ee[1:0]]);
          n_mac <= n_mac + 16'd1;
          if (ee == 3'(A7NG_C4L_D - 1)) st <= S_QSAT;
          else ee <= ee + 3'd1;
        end
        S_QSAT: begin
          qv[rr[1:0]] <= sat8(acc >>> A7NG_C4L_SHR);
          if (rr == 3'(A7NG_C4L_D - 1)) begin
            jj <= 5'd0;
            wsum <= 32'sd0;
            for (kd = 0; kd < A7NG_C4L_D; kd = kd + 1) accv[kd] <= 32'sd0;
            rr <= 3'd0;
            ee <= 3'd0;
            acc <= 32'sd0;
            st <= S_KC;
          end else begin
            rr <= rr + 3'd1;
            ee <= 3'd0;
            acc <= 32'sd0;
            st <= S_QC;
          end
        end
        S_KC: begin
          acc <= acc + $signed(rd(A7NG_C4L_OFF_WK
                      + (32'(rr) * A7NG_C4L_D) + 32'(ee)))
                     * $signed(xs[jj][ee[1:0]]);
          n_mac <= n_mac + 16'd1;
          if (ee == 3'(A7NG_C4L_D - 1)) st <= S_KSAT;
          else ee <= ee + 3'd1;
        end
        S_KSAT: begin
          kv[rr[1:0]] <= sat8(acc >>> A7NG_C4L_SHR);
          if (rr == 3'(A7NG_C4L_D - 1)) begin
            acc <= 32'sd0;
            ee <= 3'd0;
            st <= S_DOT;
          end else begin
            rr <= rr + 3'd1;
            ee <= 3'd0;
            acc <= 32'sd0;
            st <= S_KC;
          end
        end
        S_DOT: begin
          acc <= acc + $signed(qv[ee[1:0]]) * $signed(kv[ee[1:0]]);
          n_mac <= n_mac + 16'd1;
          if (ee == 3'(A7NG_C4L_D - 1)) st <= S_DOTSAT;
          else ee <= ee + 3'd1;
        end
        S_DOTSAT: begin
          ss <= relu8(sat8(acc >>> A7NG_C4L_SHR));
          rr <= 3'd0;
          ee <= 3'd0;
          acc <= 32'sd0;
          st <= S_VC;
        end
        S_VC: begin
          acc <= acc + $signed(rd(A7NG_C4L_OFF_WV
                      + (32'(rr) * A7NG_C4L_D) + 32'(ee)))
                     * $signed(xs[jj][ee[1:0]]);
          n_mac <= n_mac + 16'd1;
          if (ee == 3'(A7NG_C4L_D - 1)) st <= S_VSAT;
          else ee <= ee + 3'd1;
        end
        S_VSAT: begin
          vv[rr[1:0]] <= sat8(acc >>> A7NG_C4L_SHR);
          if (rr == 3'(A7NG_C4L_D - 1)) st <= S_ADD;
          else begin
            rr <= rr + 3'd1;
            ee <= 3'd0;
            acc <= 32'sd0;
            st <= S_VC;
          end
        end
        S_ADD: begin
          for (kd = 0; kd < A7NG_C4L_D; kd = kd + 1)
            accv[kd] <= accv[kd] + $signed(ss) * $signed(vv[kd]);
          wsum <= wsum + {{24{1'b0}}, ss};
          if (jj == last) st <= S_NORM;
          else begin
            jj <= jj + 5'd1;
            rr <= 3'd0;
            ee <= 3'd0;
            acc <= 32'sd0;
            st <= S_KC;
          end
        end
        S_NORM: begin
          den <= (wsum == 32'sd0) ? 32'sd1 : wsum;
          for (kd = 0; kd < A7NG_C4L_D; kd = kd + 1) begin
            yv[kd] <= sat8($signed(xs[last][kd])
                + sat8(accv[kd] / ((wsum == 32'sd0) ? 32'sd1 : wsum)));
          end
          ff <= 3'd0;
          ee <= 3'd0;
          acc <= 32'sd0;
          st <= S_F1;
        end
        S_F1: begin
          acc <= acc + $signed(rd(A7NG_C4L_OFF_W1
                      + (32'(ff) * A7NG_C4L_D) + 32'(ee)))
                     * $signed(yv[ee[1:0]]);
          n_mac <= n_mac + 16'd1;
          if (ee == 3'(A7NG_C4L_D - 1)) st <= S_F1SAT;
          else ee <= ee + 3'd1;
        end
        S_F1SAT: begin
          tv[ff] <= relu8(sat8(acc >>> A7NG_C4L_SHR));
          if (ff == 3'(A7NG_C4L_F - 1)) begin
            rr <= 3'd0;
            ee <= 3'd0;
            acc <= 32'sd0;
            st <= S_F2;
          end else begin
            ff <= ff + 3'd1;
            ee <= 3'd0;
            acc <= 32'sd0;
            st <= S_F1;
          end
        end
        S_F2: begin
          acc <= acc + $signed(rd(A7NG_C4L_OFF_W2
                      + (32'(rr) * A7NG_C4L_F) + 32'(ee)))
                     * $signed(tv[ee]);
          n_mac <= n_mac + 16'd1;
          if (ee == 3'(A7NG_C4L_F - 1)) st <= S_F2SAT;
          else ee <= ee + 3'd1;
        end
        S_F2SAT: begin
          zv[rr[1:0]] <= sat8($signed(yv[rr[1:0]]) + sat8(acc >>> A7NG_C4L_SHR));
          if (rr == 3'(A7NG_C4L_D - 1)) begin
            vi <= 9'd0;
            have_best <= 1'b0;
            ee <= 3'd0;
            acc <= {{24{rd(A7NG_C4L_OFF_BY)[7]}}, rd(A7NG_C4L_OFF_BY)};
            st <= S_SCAN;
          end else begin
            rr <= rr + 3'd1;
            ee <= 3'd0;
            acc <= 32'sd0;
            st <= S_F2;
          end
        end
        S_SCAN: begin
          n_mac <= n_mac + 16'd1;
          acc <= acc + $signed(rd(A7NG_C4L_OFF_WE
                      + (32'(vi) * A7NG_C4L_D) + 32'(ee)))
                     * $signed(zv[ee[1:0]]);
          if (ee == 3'(A7NG_C4L_D - 1)) st <= S_SCANSAT;
          else ee <= ee + 3'd1;
        end
        S_SCANSAT: begin
          if (!have_best || (acc > best_sc)) begin
            have_best <= 1'b1;
            best_sc <= acc;
            best_v <= vi[7:0];
          end
          if (vi == 9'(A7NG_C4L_V - 1)) st <= S_EMIT;
          else begin
            vi <= vi + 9'd1;
            ee <= 3'd0;
            acc <= {{24{rd(A7NG_C4L_OFF_BY + 32'(vi) + 32'd1)[7]}},
                    rd(A7NG_C4L_OFF_BY + 32'(vi) + 32'd1)};
            st <= S_SCAN;
          end
        end
        S_EMIT: begin
          tok_valid_o <= 1'b1;
          tok_o <= best_v;
          eos_o <= (best_v == A7NG_C4L_EOS)
                || (n_out + 8'd1 >= A7NG_C4L_MAX_TOKENS[7:0]);
          n_out <= n_out + 8'd1;
          if ((best_v == A7NG_C4L_EOS)
              || (n_out + 8'd1 >= A7NG_C4L_MAX_TOKENS[7:0])
              || (pos >= 5'(A7NG_C4L_TMAX - 1)))
            st <= S_DONE;
          else begin
            dd <= 3'd0;
            st <= S_GEN;
          end
        end
        S_GEN: begin
          xs[pos][dd[1:0]] <= rd(A7NG_C4L_OFF_WE
              + (32'(best_v) * A7NG_C4L_D) + 32'(dd));
          if (dd == 3'(A7NG_C4L_D - 1)) begin
            last <= pos;
            pos <= pos + 5'd1;
            rr <= 3'd0;
            ee <= 3'd0;
            acc <= 32'sd0;
            st <= S_QC;
          end else dd <= dd + 3'd1;
        end
        S_SAFE: begin
          tok_valid_o <= 1'b1;
          unique case (safe_i)
            8'd0: begin tok_o <= A7NG_C4L_CH_N; eos_o <= 1'b0; end
            8'd1: begin tok_o <= A7NG_C4L_CH_O; eos_o <= 1'b0; end
            default: begin tok_o <= A7NG_C4L_EOS; eos_o <= 1'b1; end
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
