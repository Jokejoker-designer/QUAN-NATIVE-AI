// a7ng_shared_rank_sgd_q8.sv — ASTRA-06 native-rank-sgd-q8-v1
// 32 shared signed weights, sequential MAC. DSP AREG/MREG/PREG. PROGRAM=NO.
`timescale 1ns / 1ps

module a7ng_shared_rank_sgd_q8 #(
  parameter int unsigned N     = 32,
  parameter int unsigned SHIFT = 6
) (
  input  logic               clk,
  input  logic               rst_n,
  input  logic               freeze_i,
  input  logic               go_score_i,
  input  logic               go_upd_i,
  input  logic signed [7:0]  x_i [0:N-1],
  input  logic signed [2:0]  reward_i,
  output logic               ready_o,
  output logic               done_o,
  output logic signed [15:0] v_q8_o
);
  typedef enum logic [2:0] {
    IDLE, SCORE, FLUSH, LATCH, UPD, UFLUSH, DONE
  } st_t;
  st_t st;

  localparam int IW = $clog2(N);
  localparam int unsigned ACC_FLUSH_N = 2;
  localparam int unsigned UPD_FLUSH_N = 3;

  logic [IW:0] i;
  logic signed [15:0] w [0:N-1];
  logic signed [15:0] v_sat, err;
  logic               do_upd;
  logic signed [2:0]  rew;
  logic [1:0]         fcnt;
  integer             k;

  logic signed [15:0] w_sel;
  logic signed [7:0]  x_sel;

  logic signed [29:0] acc_a_in, acc_a;
  logic signed [17:0] acc_b_in, acc_b;
  (* use_dsp = "yes" *) logic signed [47:0] acc_m;
  (* use_dsp = "yes" *) logic signed [47:0] acc_p;
  logic               acc_av, acc_mv, acc_start;

  logic signed [29:0] upd_a_in, upd_a;
  logic signed [17:0] upd_b_in, upd_b;
  (* use_dsp = "yes" *) logic signed [47:0] upd_m;
  (* use_dsp = "yes" *) logic signed [47:0] upd_p;
  logic               upd_av, upd_mv, upd_start;

  logic signed [39:0] acc;
  logic signed [39:0] sh_r;
  logic [IW-1:0]      ui0, ui1, ui2, ui3;
  logic               uv0, uv1, uv2, uv3;

  function automatic logic signed [39:0] rsh40(input logic signed [39:0] v, input int s);
    logic signed [39:0] a, addend;
    a = (v < 0) ? -v : v;
    addend = 40'sd1 <<< (s - 1);
    a = (a + addend) >>> s;
    return (v < 0) ? -a : a;
  endfunction

  function automatic logic signed [15:0] sat16(input logic signed [31:0] v);
    if (v > 32'sd32767) return 16'sd32767;
    if (v < -32'sd32768) return -16'sd32768;
    return v[15:0];
  endfunction

  assign ready_o = (st == IDLE);
  assign acc     = acc_p[39:0];
  assign acc_start = (st == IDLE) && (go_score_i || go_upd_i);
  assign upd_start = (st == LATCH) && do_upd;

  always_comb begin
    w_sel    = w[i[IW-1:0]];
    x_sel    = x_i[i[IW-1:0]];
    acc_a_in = {{14{w_sel[15]}}, w_sel};
    acc_b_in = {{10{x_sel[7]}}, x_sel};
    upd_a_in = {{14{err[15]}}, err};
    upd_b_in = {{10{x_sel[7]}}, x_sel};
    if (acc > (40'sd768 <<< 7))
      v_sat = 16'sd768;
    else if (acc < (-40'sd768 <<< 7))
      v_sat = -16'sd768;
    else
      v_sat = rsh40(acc, 7);
  end

  // SCORE MAC: AREG + MREG + PREG (UG901 3-stage DSP MAC)
  always_ff @(posedge clk) begin
    acc_a <= acc_a_in;
    acc_b <= acc_b_in;
    acc_m <= acc_a * acc_b;
    if (!rst_n || acc_start) begin
      acc_p  <= 48'sd0;
      acc_av <= 1'b0;
      acc_mv <= 1'b0;
    end else begin
      acc_av <= (st == SCORE);
      acc_mv <= acc_av;
      if (acc_mv)
        acc_p <= acc_p + acc_m;
    end
  end

  // UPD mul: AREG + MREG (product), PREG unused for add (fabric rsh/sat)
  always_ff @(posedge clk) begin
    upd_a <= upd_a_in;
    upd_b <= upd_b_in;
    upd_m <= upd_a * upd_b;
    if (!rst_n || upd_start) begin
      upd_p  <= 48'sd0;
      upd_av <= 1'b0;
      upd_mv <= 1'b0;
    end else begin
      upd_av <= (st == UPD);
      upd_mv <= upd_av;
      if (upd_mv)
        upd_p <= upd_m;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= IDLE;
      i <= '0;
      done_o <= 1'b0;
      v_q8_o <= '0;
      err <= '0;
      do_upd <= 1'b0;
      rew <= '0;
      fcnt <= '0;
      sh_r <= '0;
      ui0 <= '0; ui1 <= '0; ui2 <= '0; ui3 <= '0;
      uv0 <= 1'b0; uv1 <= 1'b0; uv2 <= 1'b0; uv3 <= 1'b0;
      for (k = 0; k < N; k = k + 1)
        w[k] <= '0;
    end else begin
      done_o <= 1'b0;
      uv0 <= (st == UPD);
      ui0 <= i[IW-1:0];
      uv1 <= uv0;
      ui1 <= ui0;
      uv2 <= uv1;
      ui2 <= ui1;
      uv3 <= uv2;
      ui3 <= ui2;
      if (uv2)
        sh_r <= rsh40(upd_m[39:0], 7 + SHIFT);
      if (uv3)
        w[ui3] <= sat16(32'(w[ui3]) + 32'(sh_r));

      unique case (st)
        IDLE: begin
          if (go_score_i || go_upd_i) begin
            i <= '0;
            do_upd <= go_upd_i && !freeze_i;
            rew <= reward_i;
            st <= SCORE;
          end
        end
        SCORE: begin
          if (32'(i) == N - 1) begin
            i <= '0;
            fcnt <= ACC_FLUSH_N[1:0];
            st <= FLUSH;
          end else
            i <= i + 1'b1;
        end
        FLUSH: begin
          if (fcnt == 2'd0)
            st <= LATCH;
          else
            fcnt <= fcnt - 2'd1;
        end
        LATCH: begin
          v_q8_o <= v_sat;
          err <= sat16(32'(rew) * 32'sd256 - 32'(v_sat));
          i <= '0;
          if (do_upd) begin
            fcnt <= UPD_FLUSH_N[1:0];
            st <= UPD;
          end else
            st <= DONE;
        end
        UPD: begin
          if (32'(i) == N - 1) begin
            i <= '0;
            fcnt <= UPD_FLUSH_N[1:0];
            st <= UFLUSH;
          end else
            i <= i + 1'b1;
        end
        UFLUSH: begin
          if (fcnt == 2'd0)
            st <= DONE;
          else
            fcnt <= fcnt - 2'd1;
        end
        DONE: begin
          done_o <= 1'b1;
          st <= IDLE;
        end
        default: st <= IDLE;
      endcase
    end
  end
endmodule
