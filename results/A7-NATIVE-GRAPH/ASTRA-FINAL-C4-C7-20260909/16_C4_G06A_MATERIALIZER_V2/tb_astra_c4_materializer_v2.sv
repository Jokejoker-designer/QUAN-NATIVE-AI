`timescale 1ns / 1ps
// G06-A: proof+dict → V2 context. No C4. PROGRAM=NO.
`include "a7ng_astra_c4_context_v2.svh"
`include "GOLDEN.svh"

module tb_astra_c4_materializer_v2;
  logic bank_r, ovf, valid;
  logic [7:0] sid, did;
  logic [31:0] dict_sym [0:15];
  logic dict_hit [0:15];
  logic dict_ovf [0:15];
  logic [7:0] ctx [0:15];
  logic [7:0] ctx_f [0:15];
  logic [7:0] ctx_r [0:15];
  int fail, i, c, t, once_s, once_d;

  a7ng_astra_c4_materializer_v2 u_dut (
    .bank_r_i(bank_r),
    .proof_src_id_i(sid),
    .proof_dst_id_i(did),
    .dict_sym_i(dict_sym),
    .dict_hit_i(dict_hit),
    .dict_ovf_i(dict_ovf),
    .ctx_o(ctx),
    .ovf_o(ovf),
    .valid_o(valid)
  );

  initial begin
    fail = 0;
    for (i = 0; i < 16; i = i + 1) begin
      dict_sym[i] = 32'd0;
      dict_hit[i] = 1'b0;
      dict_ovf[i] = 1'b0;
    end
    dict_hit[1] = 1'b1; dict_sym[1] = 32'h6D757264; // drum
    dict_hit[2] = 1'b1; dict_sym[2] = 32'h65736F68; // hose
    dict_hit[3] = 1'b1; dict_sym[3] = 32'h746C6F62; // bolt
    dict_hit[4] = 1'b1; dict_sym[4] = 32'h746E6576; // vent
    $display("G06A_MATERIALIZER_V2 PROGRAM=NO C4_MASTER=OPEN BOARD_PASS=OPEN");
    for (c = 0; c < A7NG_C4_MAT2_N; c = c + 1) begin
      bank_r = A7NG_C4_MAT2_R[c];
      sid = A7NG_C4_MAT2_SID[c];
      did = A7NG_C4_MAT2_DID[c];
      #1;
      for (t = 0; t < 16; t = t + 1) begin
        if (ctx[t] !== A7NG_C4_MAT2_CTX[c][t]) begin
          $display("FAIL CTX_%0d_%0d exp=%0d got=%0d", c, t, A7NG_C4_MAT2_CTX[c][t], ctx[t]);
          fail = fail + 1;
        end
      end
      $display("CASE %0d op=%0d src=%0d dst=%0d ovf=%0d valid=%0d", c, ctx[0], sid, did, ovf, valid);
    end
    // Falsifier: same ids, only opcode may differ.
    bank_r = 1'b0; sid = 8'd1; did = 8'd2; #1;
    for (i = 0; i < 16; i = i + 1) ctx_f[i] = ctx[i];
    bank_r = 1'b1; #1;
    for (i = 0; i < 16; i = i + 1) ctx_r[i] = ctx[i];
    if (ctx_f[0] !== A7NG_C4V2_OP_F || ctx_r[0] !== A7NG_C4V2_OP_R) begin
      $display("FAIL OPCODE_BYTES"); fail = fail + 1;
    end else $display("PASS OPCODE_BYTES");
    for (i = 1; i < 16; i = i + 1) begin
      if (ctx_f[i] !== ctx_r[i]) begin
        $display("FAIL INVARIANT_BYTE_%0d f=%0d r=%0d", i, ctx_f[i], ctx_r[i]);
        fail = fail + 1;
      end
    end
    if (fail == 0) $display("PASS ENTITY_INVARIANT_EXCEPT_OPCODE");
    // Each endpoint once: SRC only at 2..5, DST only at 7..10, PAD at 12..15.
    once_s = 0; once_d = 0;
    for (i = 0; i < 13; i = i + 1) begin
      if (ctx_f[i]==ctx_f[2] && ctx_f[i+1]==ctx_f[3] && ctx_f[i+2]==ctx_f[4] && ctx_f[i+3]==ctx_f[5])
        once_s = once_s + 1;
      if (ctx_f[i]==ctx_f[7] && ctx_f[i+1]==ctx_f[8] && ctx_f[i+2]==ctx_f[9] && ctx_f[i+3]==ctx_f[10])
        once_d = once_d + 1;
    end
    if (once_s !== 1 || once_d !== 1) begin
      $display("FAIL ENDPOINT_ONCE s=%0d d=%0d", once_s, once_d); fail = fail + 1;
    end else $display("PASS ENDPOINT_ONCE");
    if (ctx_f[12]!==A7NG_C4V2_PAD || ctx_f[13]!==A7NG_C4V2_PAD || ctx_f[14]!==A7NG_C4V2_PAD || ctx_f[15]!==A7NG_C4V2_PAD) begin
      $display("FAIL PAD"); fail = fail + 1;
    end else $display("PASS PAD");
    // Overflow: missing src id.
    bank_r = 1'b0; sid = 8'd9; did = 8'd2; #1;
    if (!ovf || valid || ctx[2]!==A7NG_C4V2_QMARK) begin
      $display("FAIL OVERFLOW"); fail = fail + 1;
    end else $display("PASS OVERFLOW");
    if (fail == 0) begin
      $display("CLASS_ref_match HIT");
      $display("ASTRA_C4_G06A_MATERIALIZER_V2_XSIM_PASS");
    end else begin
      $display("CLASS_ref_match MISS");
      $display("ASTRA_C4_G06A_MATERIALIZER_V2_XSIM_FAIL n=%0d", fail);
    end
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=OPEN PROGRAM=NO");
    $finish;
  end
endmodule
