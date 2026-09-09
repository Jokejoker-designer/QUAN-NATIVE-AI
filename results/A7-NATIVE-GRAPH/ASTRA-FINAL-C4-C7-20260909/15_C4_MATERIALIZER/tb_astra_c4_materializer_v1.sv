`timescale 1ns / 1ps
// G06 materializer vs Python C4_CONTEXT_CONTRACT_V1. PROGRAM=NO.
`include "GOLDEN.svh"

module tb_astra_c4_materializer_v1;
  logic bank_r, src_ovf, dest_ovf, ovf, valid;
  logic [31:0] src_sym, dest_sym;
  logic [7:0] ctx [0:15];
  int fail, i, c, t;

  a7ng_astra_c4_materializer_v1 u_dut (
    .bank_r_i(bank_r),
    .src_sym_i(src_sym),
    .dest_sym_i(dest_sym),
    .src_ovf_i(src_ovf),
    .dest_ovf_i(dest_ovf),
    .ctx_o(ctx),
    .ovf_o(ovf),
    .valid_o(valid)
  );

  initial begin
    fail = 0;
    $display("G06_MATERIALIZER PROGRAM=NO C4_MASTER=OPEN BOARD_PASS=OPEN");
    for (c = 0; c < A7NG_C4_MAT_N; c = c + 1) begin
      bank_r = A7NG_C4_MAT_R[c];
      src_ovf = A7NG_C4_MAT_SO[c];
      dest_ovf = A7NG_C4_MAT_DO[c];
      src_sym = A7NG_C4_MAT_SRC[c];
      dest_sym = A7NG_C4_MAT_DST[c];
      #1;
      for (t = 0; t < 16; t = t + 1) begin
        if (ctx[t] !== A7NG_C4_MAT_CTX[c][t]) begin
          $display("FAIL CTX_%0d_%0d exp=%0d got=%0d", c, t, A7NG_C4_MAT_CTX[c][t], ctx[t]);
          fail = fail + 1;
        end
      end
      if (ovf !== (src_ovf || dest_ovf)) begin
        $display("FAIL OVF_%0d", c);
        fail = fail + 1;
      end
      if (valid !== !(src_ovf || dest_ovf)) begin
        $display("FAIL VALID_%0d", c);
        fail = fail + 1;
      end
      $display("CASE %0d ctx0=%0d ovf=%0d valid=%0d", c, ctx[0], ovf, valid);
    end
    // Replaced-src (case 0 vs 2) must differ in slot B.
    bank_r = A7NG_C4_MAT_R[0]; src_ovf = 1'b0; dest_ovf = 1'b0;
    src_sym = A7NG_C4_MAT_SRC[0]; dest_sym = A7NG_C4_MAT_DST[0];
    #1;
    begin : rep
      logic [7:0] b0 [0:15];
      for (i = 0; i < 16; i = i + 1) b0[i] = ctx[i];
      src_sym = A7NG_C4_MAT_SRC[2];
      dest_sym = A7NG_C4_MAT_DST[2];
      #1;
      if (ctx[7] === b0[7] && ctx[8] === b0[8] && ctx[9] === b0[9] && ctx[10] === b0[10]) begin
        $display("FAIL REPLACE_SRC_SLOT_B_UNCHANGED");
        fail = fail + 1;
      end else $display("PASS REPLACE_SRC_SLOT_B");
      if (ctx[2] !== b0[2]) begin
        $display("FAIL REPLACE_SRC_CHANGED_DEST_SLOT");
        fail = fail + 1;
      end else $display("PASS REPLACE_SRC_KEEPS_DEST");
    end
    if (fail == 0) begin
      $display("CLASS_ref_match HIT");
      $display("ASTRA_C4_MATERIALIZER_V1_XSIM_PASS n=%0d", A7NG_C4_MAT_N);
    end else begin
      $display("CLASS_ref_match MISS");
      $display("ASTRA_C4_MATERIALIZER_V1_XSIM_FAIL n=%0d", fail);
    end
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=OPEN PROGRAM=NO");
    $finish;
  end
endmodule
