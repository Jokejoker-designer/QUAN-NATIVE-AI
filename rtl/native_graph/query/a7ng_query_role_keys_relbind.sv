// a7ng_query_role_keys_relbind.sv — ASTRA-C1-KEY-RELBIND-01
// Law: qse-v2-relbind-01
// Combinational rebind of frozen qse-v2-role-00 keys. Does not patch extract.
// k0,k1 pass through {subj,rel}/{obj,rel}.
// k2 = {rel_id, subj_cue[7:0]}  k3 = {rel_id, obj_cue[7:0]}
// Valids pass through frozen bind-state (not key!=0, not nid-derived).
// PROGRAM=NO.
`timescale 1ns / 1ps

module a7ng_query_role_keys_relbind (
  input  logic [7:0]  rel_id_i,
  input  logic [63:0] subj_cue_i,
  input  logic [63:0] obj_cue_i,
  input  logic [15:0] k0_i,
  input  logic [15:0] k1_i,
  input  logic        k0_valid_i,
  input  logic        k1_valid_i,
  input  logic        k2_valid_i,
  input  logic        k3_valid_i,
  output logic [15:0] k0_o,
  output logic [15:0] k1_o,
  output logic [15:0] k2_o,
  output logic [15:0] k3_o,
  output logic        k0_valid_o,
  output logic        k1_valid_o,
  output logic        k2_valid_o,
  output logic        k3_valid_o
);
  assign k0_o       = k0_i;
  assign k1_o       = k1_i;
  assign k2_o       = {rel_id_i, subj_cue_i[7:0]};
  assign k3_o       = {rel_id_i, obj_cue_i[7:0]};
  assign k0_valid_o = k0_valid_i;
  assign k1_valid_o = k1_valid_i;
  assign k2_valid_o = k2_valid_i;
  assign k3_valid_o = k3_valid_i;
endmodule
