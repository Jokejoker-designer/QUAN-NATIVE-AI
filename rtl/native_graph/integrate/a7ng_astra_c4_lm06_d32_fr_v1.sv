// a7ng_astra_c4_lm06_d32_fr_v1.sv
// Frozen D32/F64 F+R integer decoder. PROGRAM=NO.
// Bit-exact intent: Python IntegerModel in quantize_c4_parity.py.
// Do not load these weights into a7ng_astra_c4_lm06_red (D4/F8).
// Not C4_MASTER. Not ASTRA_NATIVE_AI_BOARD_PASS.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_lm06_d32_fr_v1.svh"

module a7ng_astra_c4_lm06_d32_fr_v1 (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        go_i,
  input  logic        retire_i,
  input  logic        answer_allowed_i,
  input  logic        zero_w_i,
  input  logic [7:0]  ctx_i [0:15],
  output logic        busy_o,
  output logic        done_o,
  output logic        tok_valid_o,
  output logic [7:0]  tok_o,
  output logic        eos_o,
  output logic [7:0]  n_out_o,
  output logic [15:0] n_host_tok_o,
  output logic        bank_r_o,
  output logic [3:0]  vocab_ver_o
);
  typedef enum logic [5:0] {
    S_IDLE, S_SAFE, S_EMB, S_Q, S_K, S_V, S_DOT, S_SMMAX, S_SMLUT,
    S_SMDIV, S_SMRES, S_SMFIX, S_H, S_Y, S_F1, S_F2, S_LOG, S_ARG, S_EMIT, S_DONE
  } st_t;
  st_t st;

  localparam int unsigned D = A7NG_C4D32_D;
  localparam int unsigned Ff = A7NG_C4D32_F;
  localparam int unsigned TMAX = A7NG_C4D32_TMAX;
  localparam signed [31:0] ALIM = $signed(A7NG_C4D32_ALIM);

  logic signed [7:0]  We [0:256*D-1];
  logic signed [7:0]  Pe [0:TMAX*D-1];
  logic signed [7:0]  Wq [0:D*D-1];
  logic signed [7:0]  Wk [0:D*D-1];
  logic signed [7:0]  Wv [0:D*D-1];
  logic signed [7:0]  WqR [0:D*D-1];
  logic signed [7:0]  WkR [0:D*D-1];
  logic signed [7:0]  WvR [0:D*D-1];
  logic signed [7:0]  W1 [0:Ff*D-1];
  logic signed [7:0]  W2 [0:D*Ff-1];
  logic signed [31:0] By [0:255];
  logic signed [15:0] Lut [0:A7NG_C4D32_LUT_N-1];

  initial begin
    $readmemh("We.hex", We);
    $readmemh("Pe.hex", Pe);
    $readmemh("Wq.hex", Wq);
    $readmemh("Wk.hex", Wk);
    $readmemh("Wv.hex", Wv);
    $readmemh("WqR.hex", WqR);
    $readmemh("WkR.hex", WkR);
    $readmemh("WvR.hex", WvR);
    $readmemh("W1.hex", W1);
    $readmemh("W2.hex", W2);
    $readmemh("by.hex", By);
    $readmemh("softmax_exp_q15.hex", Lut);
  end

  logic signed [15:0] x [0:TMAX-1][0:D-1];
  logic signed [15:0] qv [0:D-1];
  logic signed [15:0] kv [0:TMAX-1][0:D-1];
  logic signed [15:0] vv [0:TMAX-1][0:D-1];
  logic signed [31:0] dots [0:TMAX-1];
  logic signed [31:0] attn [0:TMAX-1];
  logic signed [15:0] hv [0:D-1];
  logic signed [15:0] yv [0:D-1];
  logic signed [15:0] tv [0:Ff-1];
  logic signed [15:0] zv [0:D-1];
  logic signed [31:0] logits [0:255];
  logic [7:0] toks [0:TMAX-1];
  logic [5:0] tlen;
  logic [7:0] n_out;
  logic [2:0] n_gen;
  logic [7:0] safe_i;
  logic use_r;
  logic signed [63:0] acc;
  integer ti, di, dj, fi, vi, posi;
  logic signed [31:0] dmax;
  logic [5:0] amax_i;
  logic signed [31:0] elut [0:TMAX-1];
  logic signed [31:0] eden, psum;
  logic signed [31:0] best_logit;
  logic [7:0] best_tok;
  logic signed [7:0] w8;
  logic signed [31:0] w32;

  function automatic signed [7:0] wgt8(input signed [7:0] a);
    wgt8 = zero_w_i ? 8'sd0 : a;
  endfunction

  function automatic signed [31:0] wgt32(input signed [31:0] a);
    wgt32 = zero_w_i ? 32'sd0 : a;
  endfunction

  function automatic signed [63:0] c4_rq(input signed [63:0] val, input int unsigned mul, input int unsigned shr);
    logic signed [63:0] prod;
    logic [63:0] mag, half, q;
    begin
      prod = val * $signed(64'(mul));
      if (shr == 0) c4_rq = prod;
      else begin
        mag = prod[63] ? (~prod + 64'd1) : prod;
        half = 64'd1 << (shr - 1);
        q = (mag >> shr) + (((mag & ((64'd1 << shr) - 64'd1)) >= half) ? 64'd1 : 64'd0);
        c4_rq = prod[63] ? -$signed(q) : $signed(q);
      end
    end
  endfunction

  function automatic signed [31:0] c4_sat(input signed [63:0] val);
    if (val > ALIM) c4_sat = ALIM;
    else if (val < -ALIM) c4_sat = -ALIM;
    else c4_sat = val[31:0];
  endfunction

  assign busy_o = (st != S_IDLE) && (st != S_DONE);
  assign n_out_o = n_out;
  assign n_host_tok_o = 16'd0;
  assign bank_r_o = use_r;
  assign vocab_ver_o = A7NG_C4D32_VOCAB_VER;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      done_o <= 1'b0;
      tok_valid_o <= 1'b0;
      tok_o <= 8'd0;
      eos_o <= 1'b0;
      n_out <= 8'd0;
      n_gen <= 3'd0;
      tlen <= 6'd0;
      safe_i <= 8'd0;
      use_r <= 1'b0;
      acc <= 64'sd0;
      ti <= 0; di <= 0; dj <= 0; fi <= 0; vi <= 0; posi <= 0;
    end else begin
      tok_valid_o <= 1'b0;
      eos_o <= 1'b0;
      unique case (st)
        S_IDLE: begin
          done_o <= 1'b0;
          if (go_i) begin
            n_out <= 8'd0;
            n_gen <= 3'd0;
            use_r <= (ctx_i[0] == A7NG_C4D32_OP_R);
            for (ti = 0; ti < 16; ti = ti + 1) toks[ti] <= ctx_i[ti];
            toks[16] <= A7NG_C4D32_EOS;
            tlen <= 6'd17;
            safe_i <= 8'd0;
            if (!answer_allowed_i) st <= S_SAFE;
            else begin
              ti <= 0; di <= 0; acc <= 64'sd0; st <= S_EMB;
            end
          end
        end
        S_SAFE: begin
          tok_valid_o <= 1'b1;
          unique case (safe_i)
            8'd0: begin tok_o <= A7NG_C4D32_CH_N; eos_o <= 1'b0; end
            8'd1: begin tok_o <= A7NG_C4D32_CH_O; eos_o <= 1'b0; end
            default: begin tok_o <= A7NG_C4D32_EOS; eos_o <= 1'b1; end
          endcase
          n_out <= n_out + 8'd1;
          if (safe_i >= 8'd2) st <= S_DONE;
          else safe_i <= safe_i + 8'd1;
        end
        S_EMB: begin
          // Concatenation is unsigned. 56-bit {48{s},i8} zero-extends into
          // signed [63:0] and turns negative weights into ~2^56. Use 64 bits.
          posi = (ti > 23) ? 23 : ti;
          acc = c4_rq({{56{wgt8(We[toks[ti]*D + di])[7]}}, wgt8(We[toks[ti]*D + di])}, A7NG_C4D32_RQ_EMB_WE_MUL, A7NG_C4D32_RQ_EMB_WE_SHR)
              + c4_rq({{56{wgt8(Pe[posi*D + di])[7]}}, wgt8(Pe[posi*D + di])}, A7NG_C4D32_RQ_EMB_PE_MUL, A7NG_C4D32_RQ_EMB_PE_SHR);
          x[ti][di] <= c4_sat(acc)[15:0];
          if (di == D - 1) begin
            di <= 0;
            if (ti == tlen - 1) begin
              ti <= 0; dj <= 0; acc <= 64'sd0; st <= S_Q;
            end else ti <= ti + 1;
          end else di <= di + 1;
        end
        S_Q: begin
          w8 = use_r ? wgt8(WqR[dj*D + di]) : wgt8(Wq[dj*D + di]);
          acc <= (di == 0) ? (w8 * x[tlen-1][di]) : (acc + w8 * x[tlen-1][di]);
          if (di == D - 1) begin
            qv[dj] <= c4_sat(use_r
              ? c4_rq(acc + w8 * x[tlen-1][di], A7NG_C4D32_RQ_QR_MUL, A7NG_C4D32_RQ_QR_SHR)
              : c4_rq(acc + w8 * x[tlen-1][di], A7NG_C4D32_RQ_Q_MUL, A7NG_C4D32_RQ_Q_SHR))[15:0];
            di <= 0;
            acc <= 64'sd0;
            if (dj == D - 1) begin dj <= 0; ti <= 0; st <= S_K; end
            else dj <= dj + 1;
          end else di <= di + 1;
        end
        S_K: begin
          w8 = use_r ? wgt8(WkR[dj*D + di]) : wgt8(Wk[dj*D + di]);
          acc <= (di == 0) ? (w8 * x[ti][di]) : (acc + w8 * x[ti][di]);
          if (di == D - 1) begin
            kv[ti][dj] <= c4_sat(use_r
              ? c4_rq(acc + w8 * x[ti][di], A7NG_C4D32_RQ_KR_MUL, A7NG_C4D32_RQ_KR_SHR)
              : c4_rq(acc + w8 * x[ti][di], A7NG_C4D32_RQ_K_MUL, A7NG_C4D32_RQ_K_SHR))[15:0];
            di <= 0; acc <= 64'sd0;
            if (dj == D - 1) begin
              dj <= 0;
              if (ti == tlen - 1) begin ti <= 0; st <= S_V; end
              else ti <= ti + 1;
            end else dj <= dj + 1;
          end else di <= di + 1;
        end
        S_V: begin
          w8 = use_r ? wgt8(WvR[dj*D + di]) : wgt8(Wv[dj*D + di]);
          acc <= (di == 0) ? (w8 * x[ti][di]) : (acc + w8 * x[ti][di]);
          if (di == D - 1) begin
            vv[ti][dj] <= c4_sat(use_r
              ? c4_rq(acc + w8 * x[ti][di], A7NG_C4D32_RQ_VR_MUL, A7NG_C4D32_RQ_VR_SHR)
              : c4_rq(acc + w8 * x[ti][di], A7NG_C4D32_RQ_V_MUL, A7NG_C4D32_RQ_V_SHR))[15:0];
            di <= 0; acc <= 64'sd0;
            if (dj == D - 1) begin
              dj <= 0;
              if (ti == tlen - 1) begin ti <= 0; st <= S_DOT; end
              else ti <= ti + 1;
            end else dj <= dj + 1;
          end else di <= di + 1;
        end
        S_DOT: begin
          acc <= (di == 0) ? (kv[ti][di] * qv[di]) : (acc + kv[ti][di] * qv[di]);
          if (di == D - 1) begin
            dots[ti] <= c4_rq(acc + kv[ti][di] * qv[di], A7NG_C4D32_RQ_DOTS_MUL, A7NG_C4D32_RQ_DOTS_SHR)[31:0];
            di <= 0; acc <= 64'sd0;
            if (ti == tlen - 1) begin ti <= 0; dmax <= -32'sh7fffffff; amax_i <= 6'd0; st <= S_SMMAX; end
            else ti <= ti + 1;
          end else di <= di + 1;
        end
        S_SMMAX: begin
          if ((ti == 0) || (dots[ti] > dmax) || ((dots[ti] == dmax) && (ti < amax_i))) begin
            dmax <= dots[ti];
            amax_i <= ti[5:0];
          end
          if (ti == tlen - 1) begin ti <= 0; st <= S_SMLUT; end
          else ti <= ti + 1;
        end
        S_SMLUT: begin
          begin : smlut
            logic signed [31:0] delta;
            delta = dots[ti] - dmax;
            if (delta < -32'sd4096) elut[ti] <= 32'sd0;
            else if ((-delta) > 32'sd4096) elut[ti] <= 32'sd0;
            else elut[ti] <= Lut[(-delta) > 0 ? (-delta) : 0];
          end
          if (ti == tlen - 1) begin ti <= 0; eden <= 32'sd0; st <= S_SMDIV; end
          else ti <= ti + 1;
        end
        S_SMDIV: begin
          if (ti == 0) eden <= elut[0];
          else eden <= eden + elut[ti];
          if (ti == tlen - 1) begin ti <= 0; psum <= 32'sd0; st <= S_SMRES; end
          else ti <= ti + 1;
        end
        S_SMRES: begin
          if (eden == 32'sd0) attn[ti] <= 32'sd0;
          else attn[ti] <= (elut[ti] * 32'sd32767 + (eden / 32'sd2)) / eden;
          psum <= (ti == 0 ? 32'sd0 : psum) + ((eden == 32'sd0) ? 32'sd0 : ((elut[ti] * 32'sd32767 + (eden / 32'sd2)) / eden));
          if (ti == tlen - 1) st <= S_SMFIX;
          else ti <= ti + 1;
        end
        S_SMFIX: begin
          attn[amax_i] <= attn[amax_i] + (32'sd32767 - psum);
          ti <= 0; dj <= 0; acc <= 64'sd0; st <= S_H;
        end
        S_H: begin
          acc <= (ti == 0) ? (attn[0] * vv[0][dj]) : (acc + attn[ti] * vv[ti][dj]);
          if (ti == tlen - 1) begin
            hv[dj] <= c4_sat(c4_rq(acc + attn[ti] * vv[ti][dj], A7NG_C4D32_RQ_H_MUL, A7NG_C4D32_RQ_H_SHR))[15:0];
            ti <= 0; acc <= 64'sd0;
            if (dj == D - 1) begin dj <= 0; di <= 0; st <= S_Y; end
            else dj <= dj + 1;
          end else ti <= ti + 1;
        end
        S_Y: begin
          yv[di] <= c4_sat(
            c4_rq({{48{x[tlen-1][di][15]}}, x[tlen-1][di]}, A7NG_C4D32_RQ_YX_MUL, A7NG_C4D32_RQ_YX_SHR)
          + c4_rq({{48{hv[di][15]}}, hv[di]}, A7NG_C4D32_RQ_YH_MUL, A7NG_C4D32_RQ_YH_SHR)
          )[15:0];
          if (di == D - 1) begin di <= 0; fi <= 0; acc <= 64'sd0; st <= S_F1; end
          else di <= di + 1;
        end
        S_F1: begin
          acc <= (di == 0) ? (wgt8(W1[fi*D + di]) * yv[di]) : (acc + wgt8(W1[fi*D + di]) * yv[di]);
          if (di == D - 1) begin
            begin : relu
              logic signed [31:0] trq;
              trq = c4_sat(c4_rq(acc + wgt8(W1[fi*D + di]) * yv[di], A7NG_C4D32_RQ_T_MUL, A7NG_C4D32_RQ_T_SHR));
              tv[fi] <= (trq < 0) ? 16'sd0 : trq[15:0];
            end
            di <= 0; acc <= 64'sd0;
            if (fi == Ff - 1) begin fi <= 0; dj <= 0; st <= S_F2; end
            else fi <= fi + 1;
          end else di <= di + 1;
        end
        S_F2: begin
          acc <= (fi == 0) ? (wgt8(W2[dj*Ff + fi]) * tv[fi]) : (acc + wgt8(W2[dj*Ff + fi]) * tv[fi]);
          if (fi == Ff - 1) begin
            zv[dj] <= c4_sat(
              c4_rq({{48{yv[dj][15]}}, yv[dj]}, A7NG_C4D32_RQ_ZY_MUL, A7NG_C4D32_RQ_ZY_SHR)
            + c4_rq(acc + wgt8(W2[dj*Ff + fi]) * tv[fi], A7NG_C4D32_RQ_ZT_MUL, A7NG_C4D32_RQ_ZT_SHR)
            )[15:0];
            fi <= 0; acc <= 64'sd0;
            if (dj == D - 1) begin dj <= 0; vi <= 0; st <= S_LOG; end
            else dj <= dj + 1;
          end else fi <= fi + 1;
        end
        S_LOG: begin
          acc <= (di == 0) ? (wgt8(We[vi*D + di]) * zv[di]) : (acc + wgt8(We[vi*D + di]) * zv[di]);
          if (di == D - 1) begin
            logits[vi] <= c4_sat(
              c4_rq(acc + wgt8(We[vi*D + di]) * zv[di], A7NG_C4D32_RQ_LOGITS_MUL, A7NG_C4D32_RQ_LOGITS_SHR)
            + c4_rq({{32{wgt32(By[vi])[31]}}, wgt32(By[vi])}, A7NG_C4D32_RQ_BIAS_MUL, A7NG_C4D32_RQ_BIAS_SHR)
            );
            di <= 0; acc <= 64'sd0;
            if (vi == 255) begin vi <= 0; best_logit <= -32'sh7fffffff; best_tok <= 8'd0; st <= S_ARG; end
            else vi <= vi + 1;
          end else di <= di + 1;
        end
        S_ARG: begin
          if ((vi == 0) || (logits[vi] > best_logit)) begin
            best_logit <= logits[vi];
            best_tok <= vi[7:0];
          end
          if (vi == 255) st <= S_EMIT;
          else vi <= vi + 1;
        end
        S_EMIT: begin
          tok_valid_o <= 1'b1;
          tok_o <= best_tok;
          eos_o <= (best_tok == A7NG_C4D32_EOS);
          n_out <= n_out + 8'd1;
          if ((best_tok == A7NG_C4D32_EOS) || (n_gen == A7NG_C4D32_MAX_TOK - 1)) st <= S_DONE;
          else begin
            toks[tlen] <= best_tok;
            tlen <= tlen + 6'd1;
            n_gen <= n_gen + 3'd1;
            ti <= 0; di <= 0; acc <= 64'sd0; st <= S_EMB;
          end
        end
        S_DONE: begin
          done_o <= 1'b1;
          if (retire_i) st <= S_IDLE;
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
