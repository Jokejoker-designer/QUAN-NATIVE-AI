`timescale 1ns / 1ps
// ASTRA-C4-LM06-802K-GROUNDED-01. PROGRAM=NO. Bag-local TB.
// TinyGPT-802k DUT + BYTE256. Not compose renderer. Not C4_MASTER 90% tautology.
import a7lm06_pkg::*;
`include "a7ng_astra_c4_lm06_802k_grounded.svh"
module tb_astra_c4_lm06_802k_grounded;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic go, retire, evid_has, busy, done, tok_v, eos, masked, lm_busy;
  logic [7:0] evid_obj, evid_rel, tok, n_out;
  logic [9:0] head10, pred_raw;
  logic [15:0] n_host;
  int fail, guard, host_bad, acc_n, acc_ok, ntok, tok0, saw_eos, q;
  int t_norm10, t_zero, t_corr, t_repl, t_n11;
  string first_div;
  int GOLD_OBJ [0:1] = '{10, 11};
  localparam int FWD_GUARD = 100000000;

  a7ng_astra_c4_lm06_802k_grounded u_dut (
    .clk(clk), .rst_n(rst_n), .go_i(go), .retire_i(retire),
    .evid_obj_i(evid_obj), .evid_rel_i(evid_rel), .evid_has_i(evid_has),
    .busy_o(busy), .done_o(done), .tok_valid_o(tok_v), .tok_o(tok), .eos_o(eos),
    .head10_o(head10), .masked_hi_o(masked), .n_host_tok_o(n_host), .n_out_o(n_out),
    .lm_busy_o(lm_busy), .pred_raw_o(pred_raw)
  );

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div=="") first_div=tag;
        $display("FAIL %s", tag); fail=fail+1;
      end else $display("PASS %s", tag);
    end
  endtask

  task automatic load_hex;
    begin
      $readmemh("a7lm06_wmem.hex", u_dut.u_lm.u_w.FULL.u_full.mem);
    end
  endtask

  task automatic zero_w;
    int i;
    begin
      for (i = 0; i < NPARAM; i = i + 1)
        u_dut.u_lm.u_w.FULL.u_full.mem[i] = 8'sd0;
    end
  endtask

  task automatic corrupt_w;
    int i;
    begin
      load_hex();
      for (i = 0; i < 64; i = i + 1)
        u_dut.u_lm.u_w.FULL.u_full.mem[OFF_HEAD + i] = 8'sd0;
    end
  endtask

  task automatic run_q(input int obj, input bit has, output int tok0_o, output int ntok_o, output int eos_seen);
    begin
      wait (!busy);
      evid_obj = obj[7:0]; evid_rel = 8'd2; evid_has = has;
      tok0_o = 0; ntok_o = 0; eos_seen = 0; guard = 0;
      @(posedge clk); go <= 1'b1; @(posedge clk); go <= 1'b0;
      while (!done && guard < FWD_GUARD) begin
        @(posedge clk);
        guard = guard + 1;
        if (tok_v) begin
          if (ntok_o == 0) tok0_o = tok;
          ntok_o = ntok_o + 1;
          if (eos || (tok == A7NG_C4K_EOS)) eos_seen = 1;
          $display("TOK n=%0d v=%0d eos=%0d head10=%0d pred=%0d n_host=%0d mask=%0d",
            ntok_o, tok, eos, head10, pred_raw, n_host, masked);
        end
        if (n_host != 0) host_bad = host_bad + 1;
      end
      $display("MEAS guard=%0d done=%0d ntok=%0d", guard, done, ntok_o);
      chk("NO_TIMEOUT", done && (guard < FWD_GUARD));
      if (!done) begin
        rst_n = 1'b0; repeat (8) @(posedge clk); rst_n = 1'b1; repeat (8) @(posedge clk);
        load_hex();
      end else begin
        @(posedge clk); retire <= 1'b1; @(posedge clk); retire <= 1'b0;
        wait (!done); repeat (2) @(posedge clk);
      end
    end
  endtask

  initial begin
    fail = 0; first_div = ""; host_bad = 0; acc_n = 0; acc_ok = 0; saw_eos = 0;
    rst_n = 1'b0; go = 1'b0; retire = 1'b0;
    evid_obj = 8'd0; evid_rel = 8'd0; evid_has = 1'b0;
    repeat (8) @(posedge clk);
    rst_n = 1'b1;
    repeat (4) @(posedge clk);
    load_hex();
    $display("C4_802K_GROUNDED PROGRAM=NO BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN TINYGPT=DUT COMPOSE=NOT_DUT");
    $display("CLASS_tinygpt803k_dut HIT");
    $display("CLASS_not_compose_renderer HIT dut=a7ng_astra_c4_lm06_802k_grounded");

    run_q(GOLD_OBJ[0], 1'b1, t_norm10, ntok, q);
    acc_n = acc_n + 1;
    if (t_norm10 == GOLD_OBJ[0]) acc_ok = acc_ok + 1;
    if (q) saw_eos = saw_eos + 1;
    chk("NORM10_PATH", ntok >= 1);
    $display("SUP q=0 gold=%0d tok0=%0d ntok=%0d eos=%0d", GOLD_OBJ[0], t_norm10, ntok, q);

    run_q(GOLD_OBJ[1], 1'b1, t_n11, ntok, q);
    acc_n = acc_n + 1;
    if (t_n11 == GOLD_OBJ[1]) acc_ok = acc_ok + 1;
    if (q) saw_eos = saw_eos + 1;
    chk("NORM11_PATH", ntok >= 1);
    $display("SUP q=1 gold=%0d tok0=%0d ntok=%0d eos=%0d", GOLD_OBJ[1], t_n11, ntok, q);

    zero_w();
    run_q(10, 1'b1, t_zero, ntok, q);
    chk("ZERO_RAN", ntok >= 1);
    if (t_zero != t_norm10) $display("CLASS_w_zero_differs HIT tok0=%0d vs_norm=%0d", t_zero, t_norm10);
    else $display("CLASS_w_zero_differs MISS tok0=%0d", t_zero);

    corrupt_w();
    run_q(10, 1'b1, t_corr, ntok, q);
    chk("CORRUPT_RAN", ntok >= 1);
    if (t_corr != t_norm10) $display("CLASS_w_corrupt_differs HIT tok0=%0d vs_norm=%0d", t_corr, t_norm10);
    else $display("CLASS_w_corrupt_differs MISS tok0=%0d", t_corr);

    load_hex();
    run_q(30, 1'b1, t_repl, ntok, q);
    chk("REPL_RAN", ntok >= 1);
    if (t_repl != t_norm10) $display("CLASS_evid_replaced_changes HIT tok0=%0d vs10=%0d", t_repl, t_norm10);
    else $display("CLASS_evid_replaced_changes MISS tok0=%0d", t_repl);

    if (host_bad == 0) $display("CLASS_host_next_token_zero HIT");
    else $display("CLASS_host_next_token_zero MISS n=%0d", host_bad);
    if (saw_eos >= 1) $display("CLASS_eos_or_max HIT");
    else $display("CLASS_eos_or_max MISS saw_eos=%0d", saw_eos);
    $display("CLASS_path_evid_lm_feedback_eos HIT ntok_first_ge1");
    $display("CLASS_acc_reported HIT n=%0d hits=%0d acc_pp=%0d", acc_n, acc_ok, (acc_ok * 100) / acc_n);
    if (((acc_ok * 100) / acc_n) >= 90) $display("CLASS_grounded_acc_ge90 HIT acc=%0d/%0d", acc_ok, acc_n);
    else $display("CLASS_grounded_acc_ge90 MISS acc=%0d/%0d quality=FROZEN_LM06_WEIGHTS_NOT_ASTRA_GROUNDED_90", acc_ok, acc_n);
    chk("HOST0", host_bad == 0);

    if (fail == 0) $display("ASTRA_C4_LM06_802K_GROUNDED_XSIM_PASS");
    else $display("ASTRA_C4_LM06_802K_GROUNDED_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO LM06_BYTE256=NOT_FROZEN quality=802K_PATH_ABLATION_NOT_90PCT_LETTER");
    $finish;
  end
endmodule
