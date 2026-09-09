`timescale 1ns / 1ps
// G04 D32 FR V2 differential vs TRAINONLY IntegerModel / Confirm V3.
// PROGRAM=NO. Not C4_MASTER. Not ASTRA_NATIVE_AI_BOARD_PASS.
`include "a7ng_astra_c4_lm06_d32_fr_v2.svh"
`include "GOLDEN.svh"

module tb_astra_c4_lm06_d32_fr_v2;
  logic clk, rst_n, go, retire, allowed, zero_w, busy, done, tok_v, eos, bank_r;
  logic [7:0] tok, n_out;
  logic [7:0] ctx [0:15];
  logic [15:0] n_host;
  logic [3:0] vver;
  int fail, guard, nt, i, c, t, nrun;
  int got [0:7];
  string first_div;

  a7ng_astra_c4_lm06_d32_fr_v2 u_dut (
    .clk(clk),
    .rst_n(rst_n),
    .go_i(go),
    .retire_i(retire),
    .answer_allowed_i(allowed),
    .zero_w_i(zero_w),
    .ctx_i(ctx),
    .busy_o(busy),
    .done_o(done),
    .tok_valid_o(tok_v),
    .tok_o(tok),
    .eos_o(eos),
    .n_out_o(n_out),
    .n_host_tok_o(n_host),
    .bank_r_o(bank_r),
    .vocab_ver_o(vver)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div == "") first_div = tag;
        $display("FAIL %s", tag);
        fail = fail + 1;
      end else $display("PASS %s", tag);
    end
  endtask

  task automatic run_one(input int idx);
    begin
      for (i = 0; i < 16; i = i + 1) ctx[i] = A7NG_C4D32_GCTX[idx][i];
      allowed = A7NG_C4D32_GALLOW[idx];
      zero_w = A7NG_C4D32_GZERO[idx];
      nt = 0;
      for (t = 0; t < 8; t = t + 1) got[t] = 0;
      @(posedge clk);
      go <= 1'b1;
      @(posedge clk);
      go <= 1'b0;
      guard = 0;
      while (!done && guard < 2000000) begin
        @(posedge clk);
        guard = guard + 1;
        if (tok_v && nt < 8) begin
          if (idx == 0 && nt == 0) begin
            $display("PROBE_tlen=%0d use_r=%0d toks0=%0d toks7=%0d toks16=%0d",
                     u_dut.tlen, u_dut.use_r, u_dut.toks[0], u_dut.toks[7], u_dut.toks[16]);
            $display("PROBE_We0=%0d WeF0=%0d Weh0=%0d",
                     u_dut.We[0], u_dut.We[70*32], u_dut.We[104*32]);
            $display("PROBE_x0=%0d %0d %0d %0d x7=%0d %0d %0d %0d x16=%0d %0d %0d %0d",
                     u_dut.x[0][0], u_dut.x[0][1], u_dut.x[0][2], u_dut.x[0][3],
                     u_dut.x[7][0], u_dut.x[7][1], u_dut.x[7][2], u_dut.x[7][3],
                     u_dut.x[16][0], u_dut.x[16][1], u_dut.x[16][2], u_dut.x[16][3]);
            $display("PROBE_q=%0d %0d %0d %0d", u_dut.qv[0], u_dut.qv[1], u_dut.qv[2], u_dut.qv[3]);
            $display("PROBE_dots0_7_16=%0d %0d %0d attn7=%0d",
                     u_dut.dots[0], u_dut.dots[7], u_dut.dots[16], u_dut.attn[7]);
            $display("PROBE_logits_g_h_o=%0d %0d %0d best=%0d best_logit=%0d",
                     u_dut.logits[103], u_dut.logits[104], u_dut.logits[111],
                     u_dut.best_tok, u_dut.best_logit);
          end
          got[nt] = tok;
          nt = nt + 1;
        end
      end
      chk($sformatf("NO_TIMEOUT_%0d", idx), done && (guard < 2000000));
      chk($sformatf("N_%0d", idx), nt == A7NG_C4D32_GN[idx]);
      for (t = 0; t < A7NG_C4D32_GN[idx]; t = t + 1) begin
        if (got[t] !== A7NG_C4D32_GTOK[idx][t]) begin
          chk($sformatf("TOK_%0d_%0d exp=%0d got=%0d", idx, t, A7NG_C4D32_GTOK[idx][t], got[t]), 1'b0);
        end
      end
      $display("CASE %0d n=%0d t0=%0d t1=%0d t2=%0d t3=%0d t4=%0d guard=%0d",
               idx, nt, got[0], got[1], got[2], got[3], got[4], guard);
      @(posedge clk);
      retire <= 1'b1;
      @(posedge clk);
      retire <= 1'b0;
      guard = 0;
      while (done && guard < 40) begin
        @(posedge clk);
        guard = guard + 1;
      end
    end
  endtask

  initial begin
    fail = 0;
    first_div = "";
    rst_n = 1'b0;
    go = 1'b0;
    retire = 1'b0;
    allowed = 1'b1;
    zero_w = 1'b0;
    for (i = 0; i < 16; i = i + 1) ctx[i] = 8'd0;
    repeat (8) @(posedge clk);
    rst_n = 1'b1;
    repeat (4) @(posedge clk);
    $display("C4_D32_FR_V2 PROGRAM=NO BOARD_PASS=OPEN C4_MASTER=OPEN");
    chk("HOST0", n_host == 16'd0);
    if (n_host == 16'd0) $display("CLASS_host_tok0 HIT");
`ifdef C4D32_SMOKE
    nrun = 4;
    run_one(0);
    run_one(1);
    run_one(A7NG_C4D32_NCASE - 2);
    run_one(A7NG_C4D32_NCASE - 1);
`else
    nrun = A7NG_C4D32_NCASE;
    for (c = 0; c < A7NG_C4D32_NCASE; c = c + 1) run_one(c);
`endif
    if (fail == 0) begin
      $display("CLASS_ref_match HIT");
`ifdef C4D32_SMOKE
      $display("ASTRA_C4_D32_FR_V2_XSIM_SMOKE_PASS n=%0d", nrun);
`else
      $display("ASTRA_C4_D32_FR_V2_XSIM_PASS n=%0d", nrun);
`endif
    end else begin
      $display("CLASS_ref_match MISS");
`ifdef C4D32_SMOKE
      $display("ASTRA_C4_D32_FR_V2_XSIM_SMOKE_FAIL n=%0d first=%s", fail, first_div);
`else
      $display("ASTRA_C4_D32_FR_V2_XSIM_FAIL n=%0d first=%s", fail, first_div);
`endif
      $display("FIRST_DIVERGENCE %s", first_div);
    end
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=OPEN PROGRAM=NO");
    $finish;
  end
endmodule
