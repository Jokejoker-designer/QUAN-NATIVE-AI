// a7ng_query_role_relctx_synonym.sv — ASTRA-C1-SYNONYM-LAW-01
// Law: qse-v2-relctx-synonym-01
// Combinational overlay after frozen qse-v2-role-00 extract.
// Does not patch a7ng_query_role_extract.sv (cd7baf49).
// Does not patch C0 qse_role_lexicon.svh (38189974).
// Does not rewrite named 187-word lexicon (df0e8833).
// Rebuilds pack_plain keys {subj,rel_syn}/{obj,rel_syn}.
// PROGRAM=NO.
`timescale 1ns / 1ps
`include "qse_relctx_synonym_01.svh"

module a7ng_query_role_relctx_synonym (
  input  logic [7:0]  subj_id_i,
  input  logic [7:0]  obj_id_i,
  input  logic [7:0]  rel_id_i,
  input  logic [7:0]  ctx_id_i,
  input  logic [15:0] k0_i,
  input  logic [15:0] k1_i,
  input  logic        k0_valid_i,
  input  logic        k1_valid_i,
  output logic [7:0]  rel_id_o,
  output logic [15:0] k0_o,
  output logic [15:0] k1_o,
  output logic        syn_hit_o
);
  integer i;
  logic [7:0] rid;
  logic       hit;

  always_comb begin
    rid = rel_id_i;
    hit = 1'b0;
    for (i = 0; i < QSE_SYN_N; i = i + 1) begin
      if (rel_id_i == QSE_SYN_FROM[i]) begin
        rid = QSE_SYN_TO[i];
        hit = 1'b1;
      end
    end
    rel_id_o  = rid;
    syn_hit_o = hit;
    k0_o      = {subj_id_i, rid};
    k1_o      = {obj_id_i,  rid};
  end
endmodule
