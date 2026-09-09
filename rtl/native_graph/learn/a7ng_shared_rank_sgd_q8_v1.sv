// a7ng_shared_rank_sgd_q8_v1.sv — sequential MAC, no DSP pipeline. PROGRAM=NO.
// F2-T learner. Timing-fix DSP SGD is not used here.
`timescale 1ns / 1ps

module a7ng_shared_rank_sgd_q8_v1 #(
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
  input  logic               load_v_i = 1'b0,
  input  logic [4:0]         load_idx_i = 5'd0,
  input  logic signed [15:0] load_w_i = 16'sd0,
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
  logic signed [31:0] acc;
  logic signed [15:0] v_sat, err;
  logic do_upd;
  logic signed [2:0] rew;
  integer k;

  function automatic logic signed [15:0] sat16(input logic signed [31:0] v);
    if (v > 32'sd32767) return 16'sd32767;
    if (v < -32'sd32768) return -16'sd32768;
    return v[15:0];
  endfunction

  assign ready_o = (st == IDLE);
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
          acc <= acc + 32'(w[i[IW-1:0]]) * 32'(x_i[i[IW-1:0]]);
          if (32'(i) == N - 1) st <= LATCH;
          else i <= i + 1'b1;
        end
        LATCH: begin
          v_sat <= sat16(acc >>> 7);
          err <= sat16(32'(rew) * 32'sd256 - 32'(sat16(acc >>> 7)));
          i <= '0;
          st <= do_upd ? UPD : DONE;
        end
        UPD: begin
          w[i[IW-1:0]] <= sat16(32'(w[i[IW-1:0]]) +
            ((32'(err) * 32'(x_i[i[IW-1:0]])) >>> (7 + SHIFT)));
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
