// a7ng_astra_c4_rq_mcycle.sv
// Multicycle c4_rq only. PROGRAM=NO. E3e: S_V consumer; no c4_sat here.
// PRODUCT WIDTH LAW: prod is logic signed [63:0] and is assigned
//   prod = val * $signed(64'(mul));
// at the same semantic point as a7ng_astra_c4_lm06_d32_fr_v2.c4_rq.
// Do not round/shift a wider product.
`timescale 1ns / 1ps

module a7ng_astra_c4_rq_mcycle (
  input  logic               clk,
  input  logic               rst_n,
  input  logic               start_i,
  input  logic signed [63:0] val_i,
  input  logic        [31:0] mul_i,
  input  logic         [5:0] shr_i,
  output logic               busy_o,
  output logic               done_o,
  output logic signed [63:0] q_o
);
  typedef enum logic [1:0] { ST_IDLE, ST_MUL, ST_RND, ST_DONE } st_t;
  st_t st;

  logic signed [63:0] val_r, prod_r, q_r;
  logic        [31:0] mul_r;
  logic         [5:0] shr_r;

  assign busy_o = (st != ST_IDLE);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= ST_IDLE;
      done_o <= 1'b0;
      q_o <= 64'sd0;
      val_r <= 64'sd0;
      mul_r <= 32'd0;
      shr_r <= 6'd0;
      prod_r <= 64'sd0;
      q_r <= 64'sd0;
    end else begin
      done_o <= 1'b0;
      unique case (st)
        ST_IDLE: begin
          if (start_i) begin
            val_r <= val_i;
            mul_r <= mul_i;
            shr_r <= shr_i;
            st <= ST_MUL;
          end
        end
        ST_MUL: begin
          prod_r <= val_r * $signed(64'(mul_r));
          st <= ST_RND;
        end
        ST_RND: begin
          begin : rnd
            logic [63:0] mag, qmag, half, mask;
            if (shr_r == 6'd0) q_r <= prod_r;
            else begin
              mag  = prod_r[63] ? (~prod_r + 64'd1) : prod_r;
              half = 64'd1 << (shr_r - 6'd1);
              mask = (64'd1 << shr_r) - 64'd1;
              qmag = (mag >> shr_r) + (((mag & mask) >= half) ? 64'd1 : 64'd0);
              q_r <= prod_r[63] ? -$signed(qmag) : $signed(qmag);
            end
          end
          st <= ST_DONE;
        end
        ST_DONE: begin
          q_o <= q_r;
          done_o <= 1'b1;
          st <= ST_IDLE;
        end
        default: st <= ST_IDLE;
      endcase
    end
  end
endmodule
