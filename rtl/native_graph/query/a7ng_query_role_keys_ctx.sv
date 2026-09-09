// a7ng_query_role_keys_ctx.sv — ASTRA-C1-CONTEXT-02
// Law: qse-v2-intersect-context-02
// Combinational rebind of frozen qse-v2-role-00 keys. Does not patch extract.
// Does not invent nid-derived keys. Does not set relevant=router_union.
//
// ctx_valid is the bind flag, independent of a zero ctx_id *inside the packer*.
// Frozen extract does not export xh. C0 lexicon CLS_CTX ids are {1,2} never 0,
// so ctx_valid := (ctx_id_i != 0) ≡ xh on this freeze. If a later named extract
// exports xh, wire that here; do not silent-patch C0.
//
// if ctx_valid:
//   k0 = {subj[7:0], ctx[3:0], rel[3:0]}   packed {subj,rel,ctx} into 16b
//   k1 = {obj[7:0],  ctx[3:0], rel[3:0]}
// else:
//   k0, k1 pass through frozen {subj,rel}/{obj,rel}
// k2 = {rel[7:0], ctx[7:0]}   extra k_ctx fragment; indexed, not probed
// k3 = {subj[7:0], ctx[7:0]}  extra fragment; indexed, not probed
// Valids pass through frozen bind-state (not key!=0).
// PROGRAM=NO.
`timescale 1ns / 1ps

module a7ng_query_role_keys_ctx (
  input  logic [7:0]  subj_id_i,
  input  logic [7:0]  obj_id_i,
  input  logic [7:0]  rel_id_i,
  input  logic [7:0]  ctx_id_i,
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
  output logic        k3_valid_o,
  output logic        ctx_valid_o
);
  // Bind flag is not "skip fold because id==0" inside the packer.
  assign ctx_valid_o = (ctx_id_i != 8'd0);

  wire [15:0] k0_ctx = {subj_id_i, ctx_id_i[3:0], rel_id_i[3:0]};
  wire [15:0] k1_ctx = {obj_id_i,  ctx_id_i[3:0], rel_id_i[3:0]};

  assign k0_o       = ctx_valid_o ? k0_ctx : k0_i;
  assign k1_o       = ctx_valid_o ? k1_ctx : k1_i;
  assign k2_o       = {rel_id_i, ctx_id_i};
  assign k3_o       = {subj_id_i, ctx_id_i};
  assign k0_valid_o = k0_valid_i;
  assign k1_valid_o = k1_valid_i;
  assign k2_valid_o = k2_valid_i;
  assign k3_valid_o = k3_valid_i;
endmodule
