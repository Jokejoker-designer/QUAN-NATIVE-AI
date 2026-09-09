// a7ng_astra_c4_materializer_v1.sv
// C4_CONTEXT_CONTRACT_V1. FPGA-owned src/dest symbols + F/R role.
// No host answer / next-token / qid port. PROGRAM=NO.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_lm06_d32_fr_v1.svh"

module a7ng_astra_c4_materializer_v1 (
  input  logic        bank_r_i,
  input  logic [31:0] src_sym_i,
  input  logic [31:0] dest_sym_i,
  input  logic        src_ovf_i,
  input  logic        dest_ovf_i,
  output logic [7:0]  ctx_o [0:15],
  output logic        ovf_o,
  output logic        valid_o
);
  logic [31:0] src_u, dest_u;
  logic [7:0] op, sa [0:3], sb [0:3], sc [0:3];
  integer k;

  always_comb begin
    ovf_o = src_ovf_i | dest_ovf_i;
    valid_o = !ovf_o;
    src_u  = src_ovf_i  ? 32'h3F3F3F3F : src_sym_i;
    dest_u = dest_ovf_i ? 32'h3F3F3F3F : dest_sym_i;
    op = bank_r_i ? A7NG_C4D32_OP_R : 8'd70;
    if (bank_r_i) begin
      for (k = 0; k < 4; k = k + 1) begin
        sa[k] = src_u[8*k +: 8];
        sb[k] = src_u[8*k +: 8];
        sc[k] = dest_u[8*k +: 8];
      end
    end else begin
      for (k = 0; k < 4; k = k + 1) begin
        sa[k] = dest_u[8*k +: 8];
        sb[k] = src_u[8*k +: 8];
        sc[k] = dest_u[8*k +: 8];
      end
    end
    ctx_o[0]  = op;
    ctx_o[1]  = 8'h20;
    ctx_o[2]  = sa[0]; ctx_o[3] = sa[1]; ctx_o[4] = sa[2]; ctx_o[5] = sa[3];
    ctx_o[6]  = 8'h20;
    ctx_o[7]  = sb[0]; ctx_o[8] = sb[1]; ctx_o[9] = sb[2]; ctx_o[10] = sb[3];
    ctx_o[11] = 8'h3E;
    ctx_o[12] = sc[0]; ctx_o[13] = sc[1]; ctx_o[14] = sc[2]; ctx_o[15] = sc[3];
  end
endmodule
