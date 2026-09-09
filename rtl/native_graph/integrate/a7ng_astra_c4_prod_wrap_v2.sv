// a7ng_astra_c4_prod_wrap_v2.sv
// C4 surface: status / proof_ok / direction → ENTITY_ALIAS_V1 → mat V2
// → answer_allowed → D32 FR V2 or S_SAFE.
// Alias keys are 20-bit. Materializer IDs are local slots 0/1, not C3 IDs.
// Do not wire C3 proof0_o/proof1_o (fact record IDs) into this alias.
// bank_r_i is explicit. qse_dir encoding besides 2'd0 is OPEN.
// PROGRAM=NO. Not C4_MASTER. Not BOARD_PASS.
`timescale 1ns / 1ps
`include "a7ng_astra_c3_held_out.svh"
`include "a7ng_astra_c4_context_v2.svh"
`include "a7ng_astra_c4_entity_alias_v1.svh"

module a7ng_astra_c4_prod_wrap_v2 #(
  parameter int unsigned ENT_W   = A7NG_C4_ALIAS_ENT_W,
  parameter int unsigned ALIAS_N = A7NG_C4_ALIAS_N_TB
) (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        go_i,
  input  logic        retire_i,
  input  logic        zero_w_i,
  input  logic [3:0]  c3_status_i,
  input  logic [4:0]  c3_npath_i,
  input  logic        c3_proof_ok_i,
  input  logic [1:0]  direction_i,
  input  logic        bank_r_i,
  input  logic [ENT_W-1:0] entity_src_i,
  input  logic [ENT_W-1:0] entity_dst_i,
  input  logic [ENT_W-1:0] alias_key_i [0:ALIAS_N-1],
  input  logic [31:0]      alias_sym_i [0:ALIAS_N-1],
  input  logic             alias_valid_i [0:ALIAS_N-1],
  input  logic             alias_ovf_i [0:ALIAS_N-1],
  output logic        busy_o,
  output logic        done_o,
  output logic        tok_valid_o,
  output logic [7:0]  tok_o,
  output logic        eos_o,
  output logic [7:0]  n_out_o,
  output logic [15:0] n_host_tok_o,
  output logic        bank_r_o,
  output logic [3:0]  vocab_ver_o,
  output logic        answer_allowed_o,
  output logic        mat_valid_o,
  output logic        mat_ovf_o,
  output logic        alias_ok_o,
  output logic        dir_known_o,
  output logic [7:0]  ctx_o [0:15]
);
  logic gate_ok;
  logic [7:0] ctx_w [0:15];
  logic [31:0] src_sym, dst_sym;
  logic src_hit, dst_hit, src_ovf, dst_ovf, src_miss, dst_miss;
  logic [31:0] dict_sym [0:1];
  logic dict_hit [0:1];
  logic dict_ovf [0:1];
  integer ci;

  assign dir_known_o = (direction_i == A7NG_C4_DIR_SVO_AS_WRITTEN);
  assign alias_ok_o  = src_hit && dst_hit && !src_ovf && !dst_ovf;

  a7ng_astra_c4_answer_gate_v1 u_gate (
    .c3_status_i(c3_status_i),
    .c3_npath_i(c3_npath_i),
    .c3_proof_ok_i(c3_proof_ok_i),
    .answer_allowed_o(gate_ok)
  );

  a7ng_astra_c4_entity_alias_v1 #(
    .ENT_W(ENT_W),
    .N(ALIAS_N)
  ) u_alias_src (
    .id_i(entity_src_i),
    .key_i(alias_key_i),
    .sym_i(alias_sym_i),
    .valid_i(alias_valid_i),
    .ovf_i(alias_ovf_i),
    .sym_o(src_sym),
    .hit_o(src_hit),
    .ovf_o(src_ovf),
    .miss_o(src_miss)
  );

  a7ng_astra_c4_entity_alias_v1 #(
    .ENT_W(ENT_W),
    .N(ALIAS_N)
  ) u_alias_dst (
    .id_i(entity_dst_i),
    .key_i(alias_key_i),
    .sym_i(alias_sym_i),
    .valid_i(alias_valid_i),
    .ovf_i(alias_ovf_i),
    .sym_o(dst_sym),
    .hit_o(dst_hit),
    .ovf_o(dst_ovf),
    .miss_o(dst_miss)
  );

  always_comb begin
    dict_sym[0] = src_sym;
    dict_sym[1] = dst_sym;
    dict_hit[0] = src_hit && !src_ovf;
    dict_hit[1] = dst_hit && !dst_ovf;
    dict_ovf[0] = src_ovf || src_miss;
    dict_ovf[1] = dst_ovf || dst_miss;
  end

  a7ng_astra_c4_materializer_v2 #(
    .ID_W(8),
    .DICT_N(2)
  ) u_mat (
    .bank_r_i(bank_r_i),
    .proof_src_id_i(8'd0),
    .proof_dst_id_i(8'd1),
    .dict_sym_i(dict_sym),
    .dict_hit_i(dict_hit),
    .dict_ovf_i(dict_ovf),
    .ctx_o(ctx_w),
    .ovf_o(mat_ovf_o),
    .valid_o(mat_valid_o)
  );

  assign answer_allowed_o = gate_ok && alias_ok_o && mat_valid_o;
  always_comb begin
    for (ci = 0; ci < 16; ci = ci + 1) ctx_o[ci] = ctx_w[ci];
  end

  a7ng_astra_c4_lm06_d32_fr_v2 u_dec (
    .clk(clk),
    .rst_n(rst_n),
    .go_i(go_i),
    .retire_i(retire_i),
    .answer_allowed_i(answer_allowed_o),
    .zero_w_i(zero_w_i),
    .ctx_i(ctx_w),
    .busy_o(busy_o),
    .done_o(done_o),
    .tok_valid_o(tok_valid_o),
    .tok_o(tok_o),
    .eos_o(eos_o),
    .n_out_o(n_out_o),
    .n_host_tok_o(n_host_tok_o),
    .bank_r_o(bank_r_o),
    .vocab_ver_o(vocab_ver_o)
  );
endmodule
