// a7ng_astra_c4_materializer_v2.sv
// C4_CONTEXT_CONTRACT_V2. proof_src_id + proof_dst_id + dictionary.
// No answer_id / target_slot / selected_answer. PROGRAM=NO.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_context_v2.svh"

module a7ng_astra_c4_materializer_v2 #(
  parameter int unsigned ID_W   = 8,
  parameter int unsigned DICT_N = 16
) (
  input  logic              bank_r_i,
  input  logic [ID_W-1:0]   proof_src_id_i,
  input  logic [ID_W-1:0]   proof_dst_id_i,
  input  logic [31:0]       dict_sym_i [0:DICT_N-1],
  input  logic              dict_hit_i [0:DICT_N-1],
  input  logic              dict_ovf_i [0:DICT_N-1],
  output logic [7:0]        ctx_o [0:15],
  output logic              ovf_o,
  output logic              valid_o
);
  integer k;
  logic [ID_W-1:0] src_ix, dst_ix;
  logic src_bad, dst_bad;
  logic [31:0] src_u, dest_u;

  always_comb begin
    src_ix = (proof_src_id_i >= ID_W'(DICT_N)) ? ID_W'(0) : proof_src_id_i;
    dst_ix = (proof_dst_id_i >= ID_W'(DICT_N)) ? ID_W'(0) : proof_dst_id_i;
    src_bad = (proof_src_id_i >= ID_W'(DICT_N)) || !dict_hit_i[src_ix] || dict_ovf_i[src_ix];
    dst_bad = (proof_dst_id_i >= ID_W'(DICT_N)) || !dict_hit_i[dst_ix] || dict_ovf_i[dst_ix];
    ovf_o = src_bad | dst_bad;
    valid_o = !ovf_o;
    src_u  = src_bad  ? {4{A7NG_C4V2_QMARK}} : dict_sym_i[src_ix];
    dest_u = dst_bad  ? {4{A7NG_C4V2_QMARK}} : dict_sym_i[dst_ix];
    ctx_o[0] = bank_r_i ? A7NG_C4V2_OP_R : A7NG_C4V2_OP_F;
    ctx_o[1] = A7NG_C4V2_SP;
    for (k = 0; k < 4; k = k + 1) ctx_o[2 + k] = src_u[8*k +: 8];
    ctx_o[6] = A7NG_C4V2_SP;
    for (k = 0; k < 4; k = k + 1) ctx_o[7 + k] = dest_u[8*k +: 8];
    ctx_o[11] = A7NG_C4V2_GT;
    for (k = 0; k < 4; k = k + 1) ctx_o[12 + k] = A7NG_C4V2_PAD;
  end
endmodule
