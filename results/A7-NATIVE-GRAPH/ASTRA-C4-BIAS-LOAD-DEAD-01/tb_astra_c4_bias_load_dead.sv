`timescale 1ns / 1ps
// ASTRA-C4-BIAS-LOAD-DEAD-01. PROGRAM=NO. Falsifier on unedited grounded_gen.
`include "a7ng_astra_c4_lm06_grounded_gen.svh"
module tb_astra_c4_bias_load_dead;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic go, retire, load_v, evid_has, busy, done, tok_v, eos, masked;
  logic [1:0] load_sel;
  logic [5:0] load_idx;
  logic signed [15:0] load_w;
  logic [7:0] evid_obj, evid_rel, tok, n_out;
  logic [9:0] head10;
  logic [15:0] n_host;
  int fail, t0, nt, es, guard;
  string first_div;

  a7ng_astra_c4_lm06_grounded_gen u_dut (
    .clk(clk), .rst_n(rst_n), .go_i(go), .retire_i(retire),
    .load_v_i(load_v), .load_sel_i(load_sel), .load_idx_i(load_idx), .load_w_i(load_w),
    .evid_obj_i(evid_obj), .evid_rel_i(evid_rel), .evid_has_i(evid_has),
    .busy_o(busy), .done_o(done), .tok_valid_o(tok_v), .tok_o(tok), .eos_o(eos),
    .head10_o(head10), .masked_hi_o(masked), .n_host_tok_o(n_host), .n_out_o(n_out)
  );

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div=="") first_div=tag;
        $display("FAIL %s", tag); fail=fail+1;
      end else $display("PASS %s", tag);
    end
  endtask
  task automatic hard_rst;
    begin rst_n=0; go=0; retire=0; load_v=0; repeat(4) @(posedge clk); rst_n=1; repeat(4) @(posedge clk); end
  endtask
  task automatic ld(input logic [1:0] sel, input logic [5:0] idx, input logic signed [15:0] w);
    begin @(posedge clk); load_sel<=sel; load_idx<=idx; load_w<=w; load_v<=1; @(posedge clk); load_v<=0; end
  endtask
  task automatic run_q(input int obj, input bit has, output int tok0);
    begin
      evid_obj=obj[7:0]; evid_rel=8'd2; evid_has=has;
      tok0=0; nt=0; es=0; guard=0;
      @(posedge clk); go<=1; @(posedge clk); go<=0;
      while (!done && guard<20000) begin
        @(posedge clk); guard=guard+1;
        if (tok_v) begin
          if (nt==0) tok0=tok;
          nt=nt+1;
          if (eos || tok==A7NG_C4G_EOS) es=1;
        end
      end
      chk("NO_TIMEOUT", done && guard<20000);
      @(posedge clk); retire<=1; @(posedge clk); retire<=0; wait(!done); repeat(2) @(posedge clk);
    end
  endtask

  initial begin
    fail=0; first_div=""; rst_n=0; go=0; retire=0; load_v=0;
    load_sel=0; load_idx=0; load_w=0; evid_obj=0; evid_rel=0; evid_has=0;
    repeat(4) @(posedge clk); rst_n=1; repeat(4) @(posedge clk);
    $display("C4_BIAS_LOAD_DEAD PROGRAM=NO DUT=unedited_grounded_gen V=%0d V5_0=%0d",
      A7NG_C4G_V, A7NG_C4G_V[5:0]);
    if (A7NG_C4G_V[5:0]==6'd0) $display("CLASS_v_slice_is_zero HIT V5_0=0");
    else $display("CLASS_v_slice_is_zero MISS V5_0=%0d", A7NG_C4G_V[5:0]);
    chk("V_SLICE0", A7NG_C4G_V[5:0]==6'd0);

    hard_rst();
    ld(A7NG_C4G_LD_BIAS, 6'd1, 16'sd200);
    run_q(10, 1'b1, t0);
    $display("AFTER_BIAS1 tok0=%0d (if load worked expect 1)", t0);
    if (t0!=1) $display("CLASS_bias_idx1_rejected HIT tok0=%0d", t0);
    else $display("CLASS_bias_idx1_rejected MISS tok0=%0d", t0);
    chk("BIAS1_DEAD", t0!=1);

    hard_rst();
    ld(A7NG_C4G_LD_BIAS, 6'd63, 16'sd200);
    run_q(10, 1'b1, t0);
    $display("AFTER_BIAS63 tok0=%0d (if load worked expect 63)", t0);
    if (t0!=63) $display("CLASS_bias_idx63_rejected HIT tok0=%0d", t0);
    else $display("CLASS_bias_idx63_rejected MISS tok0=%0d", t0);
    chk("BIAS63_DEAD", t0!=63);

    if (fail==0) $display("ASTRA_C4_BIAS_LOAD_DEAD_XSIM_PASS");
    else $display("ASTRA_C4_BIAS_LOAD_DEAD_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO quality=FALSIFIER_NOT_A_FIX");
    $finish;
  end
endmodule
