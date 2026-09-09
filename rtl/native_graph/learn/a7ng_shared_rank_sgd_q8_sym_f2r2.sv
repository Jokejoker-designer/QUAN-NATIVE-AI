// a7ng_shared_rank_sgd_q8_sym_f2r2.sv — ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW
// Sequential MAC, Master native-rank-sgd-q8-v1 symmetric RSH. PROGRAM=NO.
// Does not patch a7ng_shared_rank_sgd_q8.sv / _v1 / _v1_f2r / dsp_tfix.
`timescale 1ns / 1ps

module a7ng_shared_rank_sgd_q8_sym_f2r2 #(
  parameter int unsigned N     = 32,
  parameter int unsigned SHIFT = 6
) (
  input  logic               clk,
  input  logic               rst_n,
  input  logic               freeze_i,
  input  logic               go_score_i,
  input  logic               go_upd_i,
  input  logic signed [7:0]  x_i [0:N-1],
  input  logic signed [3:0]  reward_i,
  input  logic               load_v_i,
  input  logic [4:0]         load_idx_i,
  input  logic signed [15:0] load_w_i,
  output logic signed [15:0] w_o [0:N-1],
  output logic               ready_o,
  output logic               done_o,
  output logic signed [15:0] v_q8_o
);
  typedef enum logic [2:0] { IDLE, SCORE, LATCH, UPD, DONE } st_t;
  st_t st;
  localparam int IW = $clog2(N);
  logic [IW:0] i;
  logic signed [15:0] w [0:N-1];
  logic signed [39:0] acc;
  logic signed [15:0] v_sat, err;
  logic signed [3:0]  rew;
  logic               do_upd;
  logic [IW-1:0]      ji;
  logic signed [23:0] prod_sc, prod_ud;
  logic signed [39:0] acc_add, dw40;
  logic signed [31:0] rew_se, v_se, w_se, dw_se;
  logic signed [15:0] v_comb;
  integer             k;

  function automatic logic signed [39:0] rsh40(input logic signed [39:0] v, input int unsigned s);
    logic signed [39:0] a, addend;
    begin
      a = (v < 0) ? -v : v;
      addend = 40'sd1 <<< (s - 1);
      a = (a + addend) >>> s;
      rsh40 = (v < 0) ? -a : a;
    end
  endfunction

  function automatic logic signed [15:0] sat16(input logic signed [31:0] v);
    if (v > 32'sd32767) return 16'sd32767;
    if (v < -32'sd32768) return -16'sd32768;
    return v[15:0];
  endfunction

  function automatic logic signed [15:0] clamp768(input logic signed [39:0] r);
    if (r > 40'sd768) return 16'sd768;
    if (r < -40'sd768) return -16'sd768;
    return r[15:0];
  endfunction

  function automatic logic signed [15:0] clamp_err(input logic signed [31:0] e);
    if (e > 32'sd1536) return 16'sd1536;
    if (e < -32'sd1536) return -16'sd1536;
    return e[15:0];
  endfunction

  assign ready_o = (st == IDLE);
  assign ji = i[IW-1:0];
  assign prod_sc = w[ji] * x_i[ji];
  assign prod_ud = err * x_i[ji];
  assign acc_add = {{16{prod_sc[23]}}, prod_sc};
  assign dw40 = rsh40({{16{prod_ud[23]}}, prod_ud}, 7 + SHIFT);
  assign v_comb = clamp768(rsh40(acc, 7));
  assign rew_se = {{28{rew[3]}}, rew};
  assign v_se   = {{16{v_comb[15]}}, v_comb};
  assign w_se   = {{16{w[ji][15]}}, w[ji]};
  assign dw_se  = {{16{dw40[15]}}, dw40[15:0]};
  genvar gi;
  generate for (gi = 0; gi < N; gi = gi + 1) begin : g_w
    assign w_o[gi] = w[gi];
  end endgenerate

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= IDLE; i <= '0; done_o <= 1'b0; v_q8_o <= '0;
      acc <= '0; err <= '0; v_sat <= '0; do_upd <= 1'b0; rew <= '0;
      for (k = 0; k < N; k = k + 1) w[k] <= '0;
    end else begin
      done_o <= 1'b0;
      unique case (st)
        IDLE: begin
          if (load_v_i && (32'(load_idx_i) < N))
            w[load_idx_i] <= load_w_i;
          else if (go_score_i || go_upd_i) begin
            i <= '0; acc <= '0;
            do_upd <= go_upd_i && !freeze_i;
            rew <= reward_i;
            st <= SCORE;
          end
        end
        SCORE: begin
          acc <= acc + acc_add;
          if (32'(i) == N - 1) st <= LATCH;
          else i <= i + 1'b1;
        end
        LATCH: begin
          v_sat <= v_comb;
          err <= clamp_err(rew_se * 32'sd256 - v_se);
          i <= '0;
          st <= do_upd ? UPD : DONE;
        end
        UPD: begin
          w[ji] <= sat16(w_se + dw_se);
          if (32'(i) == N - 1) st <= DONE;
          else i <= i + 1'b1;
        end
        DONE: begin
          v_q8_o <= v_sat;
          done_o <= 1'b1;
          st <= IDLE;
        end
        default: st <= IDLE;
      endcase
    end
  end
endmodule
