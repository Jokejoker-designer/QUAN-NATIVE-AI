`timescale 1ns / 1ps
// Canonical C3 ANSWER gate. PROGRAM=NO.
// proof_ok_i must be the real C3 pick/proof-valid pulse/level, never tied to 1'b1.
`include "a7ng_astra_c3_held_out.svh"

module a7ng_astra_c4_answer_gate_v1 (
  input  logic [3:0] c3_status_i,
  input  logic [4:0] c3_npath_i,
  input  logic       c3_proof_ok_i,
  output logic       answer_allowed_o
);
  assign answer_allowed_o =
      (c3_status_i == A7NG_C3_ST_ANSWER)
      && (c3_npath_i != 5'd0)
      && c3_proof_ok_i;
endmodule
