// a7ng_astra_c4_lm06_d32_fr_v2.sv  V2 TRAINONLY sidecar; V1 file untouched.
// Frozen D32/F64 F+R integer decoder. PROGRAM=NO.
// Bit-exact intent: Python IntegerModel in quantize_c4_parity.py.
// Do not load these weights into a7ng_astra_c4_lm06_red (D4/F8).
// Not C4_MASTER. Not ASTRA_NATIVE_AI_BOARD_PASS.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_lm06_d32_fr_v2.svh"

module a7ng_astra_c4_lm06_d32_fr_v2 (
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
    S_IDLE, S_SAFE, S_EMB, S_EMB_RQ1, S_EMB_CAP, S_EMB_RQ2, S_EMB_FIN, S_Q, S_Q_RQ, S_Q_FIN, S_K, S_K_RQ, S_K_FIN, S_V, S_V_RQ, S_V_FIN, S_DOT, S_DOT_RQ, S_DOT_FIN, S_SMMAX, S_SMLUT,
    S_SMDIV, S_SMRES, S_SMFIX, S_H, S_H_SNAP, S_H_RQ, S_H_FIN, S_Y, S_Y_RQ1, S_Y_CAP, S_Y_RQ2, S_Y_FIN, S_F1, S_F1_RQ, S_F1_FIN,
    S_F2, S_F2_RQ1, S_F2_CAP, S_F2_RQ2, S_F2_FIN, S_LOG, S_LOG_RQ1, S_LOG_CAP,
    S_LOG_RQ2, S_LOG_FIN, S_ARG, S_EMIT, S_DONE
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
  (* keep = "true" *) logic signed [63:0] acc;
  (* keep = "true" *) logic signed [63:0] hacc;
  integer ti, di, dj, fi, vi, posi;
  logic signed [31:0] dmax;
  logic [5:0] amax_i;
  logic signed [31:0] elut [0:TMAX-1];
  logic signed [31:0] eden, psum;
  logic               smres_div_go, smres_div_hold, smres_div_busy, smres_div_done;
  logic signed [31:0] smres_div_q;
  logic [5:0]         smres_div_idx;
  logic               rq_go, rq_hold, rq_busy, rq_done;
  logic signed [63:0] rq_val_r, rq_q, rq_q_saved;
  logic        [31:0] rq_mul_r;
  logic         [5:0] rq_shr_r;
  logic               x_we, qv_we, kv_we, vv_we, zv_we, logits_we;
  logic signed [15:0] x_wdata, qv_wdata, kv_wdata, vv_wdata, zv_wdata;
  logic signed [31:0] logits_wdata;
  logic [5:0]         x_a0, x_a1, kv_a0, kv_a1, vv_a0, vv_a1, qv_a, zv_a;
  logic [7:0]         logits_a;
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

  a7ng_astra_c4_smres_div_mcycle u_smres_div (
    .clk(clk),
    .rst_n(rst_n),
    .start_i(smres_div_go),
    .elut_i(elut[ti]),
    .eden_i(eden),
    .idx_i(ti[5:0]),
    .busy_o(smres_div_busy),
    .done_o(smres_div_done),
    .q_o(smres_div_q),
    .idx_o(smres_div_idx)
  );

  a7ng_astra_c4_rq_mcycle u_rq (
    .clk(clk),
    .rst_n(rst_n),
    .start_i(rq_go),
    .val_i(rq_val_r),
    .mul_i(rq_mul_r),
    .shr_i(rq_shr_r),
    .busy_o(rq_busy),
    .done_o(rq_done),
    .q_o(rq_q)
  );

  // E3c: arrays off the async-reset FSM so BRAM/DRAM inference is legal.
  always_ff @(posedge clk) begin
    if (x_we)      x[x_a0][x_a1] <= x_wdata;
    if (qv_we)     qv[qv_a] <= qv_wdata;
    if (kv_we)     kv[kv_a0][kv_a1] <= kv_wdata;
    if (vv_we)     vv[vv_a0][vv_a1] <= vv_wdata;
    if (zv_we)     zv[zv_a] <= zv_wdata;
    if (logits_we) logits[logits_a] <= logits_wdata;
  end

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
      hacc <= 64'sd0;
      ti <= 0; di <= 0; dj <= 0; fi <= 0; vi <= 0; posi <= 0;
      smres_div_go <= 1'b0;
      smres_div_hold <= 1'b0;
      rq_go <= 1'b0;
      rq_hold <= 1'b0;
      rq_val_r <= 64'sd0;
      rq_mul_r <= 32'd0;
      rq_shr_r <= 6'd0;
      rq_q_saved <= 64'sd0;
      x_we <= 1'b0; qv_we <= 1'b0; kv_we <= 1'b0;
      vv_we <= 1'b0; zv_we <= 1'b0; logits_we <= 1'b0;
    end else begin
      tok_valid_o <= 1'b0;
      eos_o <= 1'b0;
      x_we <= 1'b0; qv_we <= 1'b0; kv_we <= 1'b0;
      vv_we <= 1'b0; zv_we <= 1'b0; logits_we <= 1'b0;
      rq_go <= 1'b0;
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
          rq_val_r <= {{56{wgt8(We[toks[ti]*D + di])[7]}}, wgt8(We[toks[ti]*D + di])};
          rq_mul_r <= A7NG_C4D32_RQ_EMB_WE_MUL[31:0];
          rq_shr_r <= A7NG_C4D32_RQ_EMB_WE_SHR[5:0];
          rq_hold <= 1'b0;
          st <= S_EMB_RQ1;
        end
        S_EMB_RQ1: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_EMB_CAP;
          end
        end
        S_EMB_CAP: begin
          rq_q_saved <= rq_q;
          rq_val_r <= {{56{wgt8(Pe[posi*D + di])[7]}}, wgt8(Pe[posi*D + di])};
          rq_mul_r <= A7NG_C4D32_RQ_EMB_PE_MUL[31:0];
          rq_shr_r <= A7NG_C4D32_RQ_EMB_PE_SHR[5:0];
          rq_hold <= 1'b0;
          st <= S_EMB_RQ2;
        end
        S_EMB_RQ2: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_EMB_FIN;
          end
        end
        S_EMB_FIN: begin
          x_we <= 1'b1;
          x_a0 <= ti[5:0];
          x_a1 <= di[5:0];
          x_wdata <= c4_sat(rq_q_saved + rq_q)[15:0];
          rq_hold <= 1'b0;
          if (di == D - 1) begin
            di <= 0;
            if (ti == tlen - 1) begin
              ti <= 0; dj <= 0; acc <= 64'sd0; st <= S_Q;
            end else begin
              ti <= ti + 1;
              st <= S_EMB;
            end
          end else begin
            di <= di + 1;
            st <= S_EMB;
          end
        end
        S_Q: begin
          w8 = use_r ? wgt8(WqR[dj*D + di]) : wgt8(Wq[dj*D + di]);
          acc <= (di == 0) ? (w8 * x[tlen-1][di]) : (acc + w8 * x[tlen-1][di]);
          if (di == D - 1) begin
            rq_val_r <= acc + w8 * x[tlen-1][di];
            rq_mul_r <= use_r ? A7NG_C4D32_RQ_QR_MUL[31:0] : A7NG_C4D32_RQ_Q_MUL[31:0];
            rq_shr_r <= use_r ? A7NG_C4D32_RQ_QR_SHR[5:0] : A7NG_C4D32_RQ_Q_SHR[5:0];
            rq_hold <= 1'b0;
            st <= S_Q_RQ;
          end else di <= di + 1;
        end
        S_Q_RQ: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_Q_FIN;
          end
        end
        S_Q_FIN: begin
          qv_we <= 1'b1;
          qv_a <= dj[5:0];
          qv_wdata <= c4_sat(rq_q)[15:0];
          di <= 0; acc <= 64'sd0;
          rq_hold <= 1'b0;
          if (dj == D - 1) begin
            dj <= 0; ti <= 0; st <= S_K;
          end else begin
            dj <= dj + 1;
            st <= S_Q;
          end
        end
        S_K: begin
          w8 = use_r ? wgt8(WkR[dj*D + di]) : wgt8(Wk[dj*D + di]);
          acc <= (di == 0) ? (w8 * x[ti][di]) : (acc + w8 * x[ti][di]);
          if (di == D - 1) begin
            rq_val_r <= acc + w8 * x[ti][di];
            rq_mul_r <= use_r ? A7NG_C4D32_RQ_KR_MUL[31:0] : A7NG_C4D32_RQ_K_MUL[31:0];
            rq_shr_r <= use_r ? A7NG_C4D32_RQ_KR_SHR[5:0] : A7NG_C4D32_RQ_K_SHR[5:0];
            rq_hold <= 1'b0;
            st <= S_K_RQ;
          end else di <= di + 1;
        end
        S_K_RQ: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_K_FIN;
          end
        end
        S_K_FIN: begin
          kv_we <= 1'b1;
          kv_a0 <= ti[5:0];
          kv_a1 <= dj[5:0];
          kv_wdata <= c4_sat(rq_q)[15:0];
          di <= 0; acc <= 64'sd0;
          rq_hold <= 1'b0;
          if (dj == D - 1) begin
            dj <= 0;
            if (ti == tlen - 1) begin ti <= 0; st <= S_V; end
            else begin ti <= ti + 1; st <= S_K; end
          end else begin
            dj <= dj + 1;
            st <= S_K;
          end
        end
        S_V: begin
          w8 = use_r ? wgt8(WvR[dj*D + di]) : wgt8(Wv[dj*D + di]);
          acc <= (di == 0) ? (w8 * x[ti][di]) : (acc + w8 * x[ti][di]);
          if (di == D - 1) begin
            rq_val_r <= acc + w8 * x[ti][di];
            rq_mul_r <= use_r ? A7NG_C4D32_RQ_VR_MUL[31:0] : A7NG_C4D32_RQ_V_MUL[31:0];
            rq_shr_r <= use_r ? A7NG_C4D32_RQ_VR_SHR[5:0] : A7NG_C4D32_RQ_V_SHR[5:0];
            rq_hold <= 1'b0;
            st <= S_V_RQ;
          end else di <= di + 1;
        end
        S_V_RQ: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_V_FIN;
          end
        end
        S_V_FIN: begin
          vv_we <= 1'b1;
          vv_a0 <= ti[5:0];
          vv_a1 <= dj[5:0];
          vv_wdata <= c4_sat(rq_q)[15:0];
          di <= 0; acc <= 64'sd0;
          rq_hold <= 1'b0;
          if (dj == D - 1) begin
            dj <= 0;
            if (ti == tlen - 1) begin ti <= 0; st <= S_DOT; end
            else begin ti <= ti + 1; st <= S_V; end
          end else begin
            dj <= dj + 1;
            st <= S_V;
          end
        end
        S_DOT: begin
          acc <= (di == 0) ? (kv[ti][di] * qv[di]) : (acc + kv[ti][di] * qv[di]);
          if (di == D - 1) begin
            rq_val_r <= acc + kv[ti][di] * qv[di];
            rq_mul_r <= A7NG_C4D32_RQ_DOTS_MUL[31:0];
            rq_shr_r <= A7NG_C4D32_RQ_DOTS_SHR[5:0];
            rq_hold <= 1'b0;
            st <= S_DOT_RQ;
          end else di <= di + 1;
        end
        S_DOT_RQ: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_DOT_FIN;
          end
        end
        S_DOT_FIN: begin
          dots[ti] <= rq_q[31:0];
          di <= 0; acc <= 64'sd0;
          rq_hold <= 1'b0;
          if (ti == tlen - 1) begin
            ti <= 0; dmax <= -32'sh7fffffff; amax_i <= 6'd0; st <= S_SMMAX;
          end else begin
            ti <= ti + 1;
            st <= S_DOT;
          end
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
          // Shared multicycle divider: one q for attn and psum. No combo /.
          if (!smres_div_hold) begin
            smres_div_go <= 1'b1;
            smres_div_hold <= 1'b1;
          end else begin
            smres_div_go <= 1'b0;
            if (smres_div_done) begin
              attn[ti] <= smres_div_q;
              psum <= (ti == 0 ? 32'sd0 : psum) + smres_div_q;
              smres_div_hold <= 1'b0;
              if (ti == tlen - 1) st <= S_SMFIX;
              else ti <= ti + 1;
            end
          end
        end
        S_SMFIX: begin
          attn[amax_i] <= attn[amax_i] + (32'sd32767 - psum);
          ti <= 0; dj <= 0; acc <= 64'sd0; hacc <= 64'sd0; st <= S_H;
        end
        S_H: begin
          hacc <= (ti == 0) ? (attn[0] * vv[0][dj]) : (hacc + attn[ti] * vv[ti][dj]);
          if (ti == tlen - 1) st <= S_H_SNAP;
          else ti <= ti + 1;
        end
        S_H_SNAP: begin
          rq_val_r <= hacc;
          rq_mul_r <= A7NG_C4D32_RQ_H_MUL[31:0];
          rq_shr_r <= A7NG_C4D32_RQ_H_SHR[5:0];
          rq_hold <= 1'b0;
          st <= S_H_RQ;
        end
        S_H_RQ: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_H_FIN;
          end
        end
        S_H_FIN: begin
          hv[dj] <= c4_sat(rq_q)[15:0];
          ti <= 0; acc <= 64'sd0; hacc <= 64'sd0;
          rq_hold <= 1'b0;
          if (dj == D - 1) begin
            dj <= 0; di <= 0; st <= S_Y;
          end else begin
            dj <= dj + 1;
            st <= S_H;
          end
        end
        S_Y: begin
          rq_val_r <= {{48{x[tlen-1][di][15]}}, x[tlen-1][di]};
          rq_mul_r <= A7NG_C4D32_RQ_YX_MUL[31:0];
          rq_shr_r <= A7NG_C4D32_RQ_YX_SHR[5:0];
          rq_hold <= 1'b0;
          st <= S_Y_RQ1;
        end
        S_Y_RQ1: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_Y_CAP;
          end
        end
        S_Y_CAP: begin
          rq_q_saved <= rq_q;
          rq_val_r <= {{48{hv[di][15]}}, hv[di]};
          rq_mul_r <= A7NG_C4D32_RQ_YH_MUL[31:0];
          rq_shr_r <= A7NG_C4D32_RQ_YH_SHR[5:0];
          rq_hold <= 1'b0;
          st <= S_Y_RQ2;
        end
        S_Y_RQ2: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_Y_FIN;
          end
        end
        S_Y_FIN: begin
          yv[di] <= c4_sat(rq_q_saved + rq_q)[15:0];
          rq_hold <= 1'b0;
          if (di == D - 1) begin
            di <= 0; fi <= 0; acc <= 64'sd0; st <= S_F1;
          end else begin
            di <= di + 1;
            st <= S_Y;
          end
        end
        S_F1: begin
          w8 = wgt8(W1[fi*D + di]);
          acc <= (di == 0) ? (w8 * yv[di]) : (acc + w8 * yv[di]);
          if (di == D - 1) begin
            rq_val_r <= acc + w8 * yv[di];
            rq_mul_r <= A7NG_C4D32_RQ_T_MUL[31:0];
            rq_shr_r <= A7NG_C4D32_RQ_T_SHR[5:0];
            rq_hold <= 1'b0;
            st <= S_F1_RQ;
          end else di <= di + 1;
        end
        S_F1_RQ: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_F1_FIN;
          end
        end
        S_F1_FIN: begin
          begin : relu
            logic signed [31:0] trq;
            trq = c4_sat(rq_q);
            tv[fi] <= (trq < 0) ? 16'sd0 : trq[15:0];
          end
          di <= 0; acc <= 64'sd0;
          rq_hold <= 1'b0;
          if (fi == Ff - 1) begin
            fi <= 0; dj <= 0; st <= S_F2;
          end else begin
            fi <= fi + 1;
            st <= S_F1;
          end
        end
        S_F2: begin
          acc <= (fi == 0) ? (wgt8(W2[dj*Ff + fi]) * tv[fi]) : (acc + wgt8(W2[dj*Ff + fi]) * tv[fi]);
          if (fi == Ff - 1) begin
            // Snapshot ZT on this cycle: acc is still the pre-NBA value.
            rq_val_r <= acc + wgt8(W2[dj*Ff + fi]) * tv[fi];
            rq_mul_r <= A7NG_C4D32_RQ_ZT_MUL[31:0];
            rq_shr_r <= A7NG_C4D32_RQ_ZT_SHR[5:0];
            rq_hold <= 1'b0;
            st <= S_F2_RQ1;
          end else fi <= fi + 1;
        end
        S_F2_RQ1: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_F2_CAP;
          end
        end
        S_F2_CAP: begin
          rq_q_saved <= rq_q;
          rq_val_r <= {{48{yv[dj][15]}}, yv[dj]};
          rq_mul_r <= A7NG_C4D32_RQ_ZY_MUL[31:0];
          rq_shr_r <= A7NG_C4D32_RQ_ZY_SHR[5:0];
          rq_hold <= 1'b0;
          st <= S_F2_RQ2;
        end
        S_F2_RQ2: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_F2_FIN;
          end
        end
        S_F2_FIN: begin
          zv_we <= 1'b1;
          zv_a <= dj[5:0];
          zv_wdata <= c4_sat(rq_q_saved + rq_q)[15:0];
          fi <= 0; acc <= 64'sd0;
          rq_hold <= 1'b0;
          if (dj == D - 1) begin
            dj <= 0; vi <= 0; st <= S_LOG;
          end else begin
            dj <= dj + 1;
            st <= S_F2;
          end
        end
        S_LOG: begin
          w8 = wgt8(We[vi*D + di]);
          acc <= (di == 0) ? (w8 * zv[di]) : (acc + w8 * zv[di]);
          if (di == D - 1) begin
            rq_val_r <= acc + w8 * zv[di];
            rq_mul_r <= A7NG_C4D32_RQ_LOGITS_MUL[31:0];
            rq_shr_r <= A7NG_C4D32_RQ_LOGITS_SHR[5:0];
            rq_hold <= 1'b0;
            st <= S_LOG_RQ1;
          end else di <= di + 1;
        end
        S_LOG_RQ1: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_LOG_CAP;
          end
        end
        S_LOG_CAP: begin
          rq_q_saved <= rq_q;
          rq_val_r <= {{32{wgt32(By[vi])[31]}}, wgt32(By[vi])};
          rq_mul_r <= A7NG_C4D32_RQ_BIAS_MUL[31:0];
          rq_shr_r <= A7NG_C4D32_RQ_BIAS_SHR[5:0];
          rq_hold <= 1'b0;
          st <= S_LOG_RQ2;
        end
        S_LOG_RQ2: begin
          if (!rq_hold) begin
            rq_go <= 1'b1;
            rq_hold <= 1'b1;
          end else if (rq_done) begin
            st <= S_LOG_FIN;
          end
        end
        S_LOG_FIN: begin
          logits_we <= 1'b1;
          logits_a <= vi[7:0];
          logits_wdata <= c4_sat(rq_q_saved + rq_q);
          di <= 0; acc <= 64'sd0;
          rq_hold <= 1'b0;
          if (vi == 255) begin
            vi <= 0;
            best_logit <= -32'sh7fffffff;
            best_tok <= 8'd0;
            st <= S_ARG;
          end else begin
            vi <= vi + 1;
            st <= S_LOG;
          end
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
