// a7ng_astra_c4_entity_alias_v1.sv
// Exact 20-bit entity-id CAM. TB dictionary may be synthetic.
// Production dictionary remains OPEN until a verified id→4-char map exists.
// FORBIDDEN: id[7:0] slice, 256-entry ROM indexed by truncated proof/fact IDs.
// PROGRAM=NO. Not C4_MASTER. Not BOARD_PASS.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_entity_alias_v1.svh"
`include "a7ng_astra_c4_context_v2.svh"

module a7ng_astra_c4_entity_alias_v1 #(
  parameter int unsigned ENT_W = A7NG_C4_ALIAS_ENT_W,
  parameter int unsigned N     = A7NG_C4_ALIAS_N_TB
) (
  input  logic [ENT_W-1:0] id_i,
  input  logic [ENT_W-1:0] key_i [0:N-1],
  input  logic [31:0]      sym_i [0:N-1],
  input  logic             valid_i [0:N-1],
  input  logic             ovf_i [0:N-1],
  output logic [31:0]      sym_o,
  output logic             hit_o,
  output logic             ovf_o,
  output logic             miss_o
);
  integer k;
  integer n_hit;
  logic [31:0] acc_sym;
  logic acc_ovf;

  always_comb begin
    n_hit = 0;
    acc_sym = {4{A7NG_C4V2_QMARK}};
    acc_ovf = 1'b0;
    for (k = 0; k < N; k = k + 1) begin
      if (valid_i[k] && (key_i[k] == id_i)) begin
        n_hit = n_hit + 1;
        acc_sym = sym_i[k];
        acc_ovf = ovf_i[k];
      end
    end
    if (n_hit == 0) begin
      hit_o  = 1'b0;
      miss_o = 1'b1;
      ovf_o  = 1'b0;
      sym_o  = {4{A7NG_C4V2_QMARK}};
    end else if (n_hit == 1) begin
      hit_o  = 1'b1;
      miss_o = 1'b0;
      ovf_o  = acc_ovf;
      sym_o  = acc_sym;
    end else begin
      hit_o  = 1'b0;
      miss_o = 1'b0;
      ovf_o  = 1'b1;
      sym_o  = {4{A7NG_C4V2_QMARK}};
    end
  end
endmodule
