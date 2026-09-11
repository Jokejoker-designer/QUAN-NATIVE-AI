// a7ng_astra_c4_rq_mcycle.sv
// Multicycle c4_rq only. PROGRAM=NO. E3e: S_V consumer; no c4_sat here.
// PRODUCT WIDTH LAW: prod is logic signed [63:0] and is assigned
//   prod = val * $signed(64'(mul));
// at the same semantic point as a7ng_astra_c4_lm06_d32_fr_v2.c4_rq.
// Do not round/shift a wider product.
// E3v: ST_RND variable >>shr flattened into q_r (33 CARRY4). Serial
// logical shift, one bit per cycle; rounding is mag[shr-1] as before.
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
  typedef enum logic [2:0] { ST_IDLE, ST_MUL, ST_RND, ST_SHF, ST_ADD, ST_DONE } st_t;
  st_t st;

  logic signed [63:0] val_r, prod_r, q_r;
  logic        [31:0] mul_r;
  logic         [5:0] shr_r, n_r;
  logic        [63:0] mag_r;
  logic               neg_r, round_r;

  assign busy_o = (st != ST_IDLE);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= ST_IDLE;
      done_o <= 1'b0;
      q_o <= 64'sd0;
      val_r <= 64'sd0;
      mul_r <= 32'd0;
      shr_r <= 6'd0;
      n_r <= 6'd0;
      mag_r <= 64'd0;
      neg_r <= 1'b0;
      round_r <= 1'b0;
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
          if (shr_r == 6'd0) begin
            q_r <= prod_r;
            st <= ST_DONE;
          end else begin
            mag_r <= prod_r[63] ? (~prod_r + 64'd1) : prod_r;
            neg_r <= prod_r[63];
            n_r <= shr_r;
            st <= ST_SHF;
          end
        end
        ST_SHF: begin
          round_r <= mag_r[0];
          mag_r <= {1'b0, mag_r[63:1]};
          if (n_r == 6'd1) st <= ST_ADD;
          else n_r <= n_r - 6'd1;
        end
        ST_ADD: begin
          begin : add_round
            logic [63:0] qmag;
            qmag = mag_r + {63'd0, round_r};
            q_r <= neg_r ? -$signed(qmag) : $signed(qmag);
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
