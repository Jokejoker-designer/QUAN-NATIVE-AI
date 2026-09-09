// a7ng_astra_c4_smres_div_mcycle.sv
// Shared multicycle divider for S_SMRES candidate. PROGRAM=NO.
// NOT instantiated in a7ng_astra_c4_lm06_d32_fr_v2 (wait E3a timing_n20).
// Law: eden==0 → 0; else 32-bit SV trunc-toward-zero
//   (elut*32767 + eden/2) / eden   — same expression as D32 S_SMRES.
// Width FACT: Lut[0..4096] in [0,32767], TMAX=24, |num|<=1074069493 < 2^31.
// Ignore start while busy. One quotient per start. No stale q reuse after done.
`timescale 1ns / 1ps

module a7ng_astra_c4_smres_div_mcycle (
  input  logic               clk,
  input  logic               rst_n,
  input  logic               start_i,
  input  logic signed [31:0] elut_i,
  input  logic signed [31:0] eden_i,
  input  logic [5:0]         idx_i,
  output logic               busy_o,
  output logic               done_o,
  output logic signed [31:0] q_o,
  output logic [5:0]         idx_o
);
  typedef enum logic [1:0] { ST_IDLE, ST_DIV, ST_DONE } st_t;
  st_t st;

  logic signed [31:0] num32, den32;
  logic [31:0]        un, ud, uq;
  logic [32:0]        rem;
  logic [32:0]        shifted;
  logic [5:0]         left;
  logic               neg;
  logic [5:0]         idx_r;

  assign busy_o = (st != ST_IDLE);
  assign num32 = elut_i * 32'sd32767 + (eden_i / 32'sd2);
  assign den32 = eden_i;
  assign shifted = {rem[31:0], un[31]};

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= ST_IDLE;
      done_o <= 1'b0;
      q_o <= 32'sd0;
      idx_o <= 6'd0;
      un <= 32'd0;
      ud <= 32'd0;
      uq <= 32'd0;
      rem <= 33'd0;
      left <= 6'd0;
      neg <= 1'b0;
      idx_r <= 6'd0;
    end else begin
      done_o <= 1'b0;
      unique case (st)
        ST_IDLE: begin
          if (start_i) begin
            idx_r <= idx_i;
            idx_o <= idx_i;
            if (eden_i == 32'sd0) begin
              q_o <= 32'sd0;
              done_o <= 1'b1;
            end else begin
              neg <= (num32[31] != den32[31]);
              un <= num32[31] ? (32'd0 - num32[31:0]) : num32[31:0];
              ud <= den32[31] ? (32'd0 - den32[31:0]) : den32[31:0];
              rem <= 33'd0;
              uq <= 32'd0;
              left <= 6'd32;
              st <= ST_DIV;
            end
          end
        end
        ST_DIV: begin
          if (shifted >= {1'b0, ud}) begin
            rem <= shifted - {1'b0, ud};
            uq  <= {uq[30:0], 1'b1};
          end else begin
            rem <= shifted;
            uq  <= {uq[30:0], 1'b0};
          end
          un   <= {un[30:0], 1'b0};
          left <= left - 6'd1;
          if (left == 6'd1) st <= ST_DONE;
        end
        ST_DONE: begin
          q_o <= neg ? -$signed(uq) : $signed(uq);
          idx_o <= idx_r;
          done_o <= 1'b1;
          st <= ST_IDLE;
        end
        default: st <= ST_IDLE;
      endcase
    end
  end
endmodule
