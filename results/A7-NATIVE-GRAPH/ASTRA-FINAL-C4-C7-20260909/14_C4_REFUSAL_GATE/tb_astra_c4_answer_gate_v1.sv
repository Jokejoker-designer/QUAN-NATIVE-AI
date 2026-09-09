`timescale 1ns / 1ps
// G05 answer gate + D32 S_SAFE. PROGRAM=NO. Never proof_ok=1'b1 as a production tie.
`include "a7ng_astra_c3_held_out.svh"

module tb_astra_c4_answer_gate_v1;
  logic [3:0] st;
  logic [4:0] np;
  logic pok, allow;
  logic clk, rst_n, go, retire, zero_w, busy, done, tok_v, eos, bank_r;
  logic [7:0] tok, n_out, ctx [0:15];
  logic [15:0] n_host;
  logic [3:0] vver;
  int fail, guard, nt, i;
  int got [0:7];

  a7ng_astra_c4_answer_gate_v1 u_gate (
    .c3_status_i(st),
    .c3_npath_i(np),
    .c3_proof_ok_i(pok),
    .answer_allowed_o(allow)
  );

  a7ng_astra_c4_lm06_d32_fr_v1 u_dut (
    .clk(clk),
    .rst_n(rst_n),
    .go_i(go),
    .retire_i(retire),
    .answer_allowed_i(allow),
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

  task automatic expect_allow(input string tag, input bit exp);
    begin
      if (allow !== exp) begin
        $display("FAIL %s allow=%0d exp=%0d", tag, allow, exp);
        fail = fail + 1;
      end else $display("PASS %s", tag);
    end
  endtask

  task automatic run_safe;
    begin
      nt = 0;
      for (i = 0; i < 8; i = i + 1) got[i] = 0;
      @(posedge clk);
      go <= 1'b1;
      @(posedge clk);
      go <= 1'b0;
      guard = 0;
      while (!done && guard < 100) begin
        @(posedge clk);
        guard = guard + 1;
        if (tok_v && nt < 8) begin
          got[nt] = tok;
          nt = nt + 1;
        end
      end
      if (!(done && nt == 3 && got[0] == 8'h6E && got[1] == 8'h6F && got[2] == 8'd0)) begin
        $display("FAIL SAFE n=%0d t0=%0d t1=%0d t2=%0d", nt, got[0], got[1], got[2]);
        fail = fail + 1;
      end else $display("PASS SAFE_NO");
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
    rst_n = 1'b0;
    go = 1'b0;
    retire = 1'b0;
    zero_w = 1'b0;
    st = A7NG_C3_ST_UNKNOWN;
    np = 5'd0;
    pok = 1'b0;
    for (i = 0; i < 16; i = i + 1) ctx[i] = 8'd0;
    ctx[0] = 8'd70;
    repeat (4) @(posedge clk);
    rst_n = 1'b1;
    repeat (2) @(posedge clk);
    $display("G05_GATE PROGRAM=NO C4_MASTER=OPEN BOARD_PASS=OPEN");

    st = A7NG_C3_ST_ANSWER; np = 5'd1; pok = 1'b1;
    #1 expect_allow("ANS_NP_POK", 1'b1);
    pok = 1'b0;
    #1 expect_allow("ANS_NP_NOPROOF", 1'b0);
    pok = 1'b1; np = 5'd0;
    #1 expect_allow("ANS_NP0", 1'b0);
    np = 5'd1; st = A7NG_C3_ST_UNKNOWN;
    #1 expect_allow("UNK", 1'b0);
    st = A7NG_C3_ST_CONFLICT;
    #1 expect_allow("CONF", 1'b0);
    st = A7NG_C3_ST_INCOMP;
    #1 expect_allow("INCOMP", 1'b0);
    st = A7NG_C3_ST_AMB;
    #1 expect_allow("AMB", 1'b0);
    st = A7NG_C3_ST_NEG;
    #1 expect_allow("NEG", 1'b0);
    if (A7NG_C3_ST_ANSWER === 4'd1) begin
      $display("FAIL ANSWER_NOT_4D0");
      fail = fail + 1;
    end else $display("PASS ANSWER_IS_4D0");

    st = A7NG_C3_ST_UNKNOWN; np = 5'd1; pok = 1'b1;
    run_safe;
    st = A7NG_C3_ST_CONFLICT; pok = 1'b0; np = 5'd2;
    run_safe;

    if (fail == 0) $display("ASTRA_C4_G05_GATE_XSIM_PASS");
    else $display("ASTRA_C4_G05_GATE_XSIM_FAIL n=%0d", fail);
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=OPEN PROGRAM=NO");
    $finish;
  end
endmodule
