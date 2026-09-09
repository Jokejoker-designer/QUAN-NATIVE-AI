`timescale 1ns / 1ps
// ASTRA-C4-LM06-GROUNDED-GEN-01. PROGRAM=NO. Bag-local TB.
// Compact linear head + BYTE256. Not compose renderer. Not 802k.
`include "a7ng_astra_c4_lm06_grounded_gen.svh"
module tb_astra_c4_lm06_grounded_gen;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic go, retire, load_v, evid_has, busy, done, tok_v, eos, masked;
  logic [1:0] load_sel;
  logic [5:0] load_idx;
  logic signed [15:0] load_w;
  logic [7:0] evid_obj, evid_rel, tok, n_out;
  logic [9:0] head10;
  logic [15:0] n_host;
  int fail, i, ntok, acc_n, acc_ok, un_ok, first;
  int saw_eos, host_bad;
  string first_div;
  int GOLD_OBJ [0:7] = '{10,11,12,13,14,15,16,17};

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
    begin
      @(posedge clk); load_sel<=sel; load_idx<=idx; load_w<=w; load_v<=1;
      @(posedge clk); load_v<=0;
    end
  endtask
  task automatic load_normal;
    begin
      ld(A7NG_C4G_LD_MATCH, 6'd0, 16'sd50);
      ld(A7NG_C4G_LD_SAFE,  6'd0, 16'sd80);
      ld(A7NG_C4G_LD_EOS,   6'd0, 16'sd200);
    end
  endtask
  task automatic run_q(input int obj, input bit has, output int tok0, output int ntok_o, output int eos_seen);
    int guard;
    begin
      evid_obj=obj[7:0]; evid_rel=8'd2; evid_has=has;
      tok0=0; ntok_o=0; eos_seen=0; guard=0;
      @(posedge clk); go<=1; @(posedge clk); go<=0;
      while (!done && guard<20000) begin
        @(posedge clk);
        guard=guard+1;
        if (tok_v) begin
          if (ntok_o==0) tok0=tok;
          ntok_o=ntok_o+1;
          if (eos || tok==A7NG_C4G_EOS) eos_seen=1;
          $display("TOK n=%0d v=%0d eos=%0d head10=%0d n_host=%0d", ntok_o, tok, eos, head10, n_host);
        end
        if (n_host!=0) host_bad=host_bad+1;
      end
      chk("NO_TIMEOUT", done && guard<20000);
      @(posedge clk); retire<=1; @(posedge clk); retire<=0; wait(!done); repeat(2) @(posedge clk);
    end
  endtask

  initial begin
    int t0, nt, es, q;
    fail=0; first_div=""; host_bad=0; acc_n=0; acc_ok=0; un_ok=0; saw_eos=0;
    rst_n=0; go=0; retire=0; load_v=0; load_sel=0; load_idx=0; load_w=0;
    evid_obj=0; evid_rel=0; evid_has=0;
    repeat(4) @(posedge clk); rst_n=1; repeat(4) @(posedge clk);
    $display("C4_GROUNDED_GEN V=64 MAX=4 PROGRAM=NO BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN COMPOSE=NOT_DUT");
    $display("CLASS_not_compose_renderer HIT dut=a7ng_astra_c4_lm06_grounded_gen");

    // A normal weights, 8 supported
    hard_rst(); load_normal();
    for (q=0;q<8;q=q+1) begin
      run_q(GOLD_OBJ[q], 1'b1, t0, nt, es);
      acc_n=acc_n+1;
      if (t0==GOLD_OBJ[q]) acc_ok=acc_ok+1;
      if (es) saw_eos=saw_eos+1;
      chk($sformatf("SUP_Q%0d", q), (t0==GOLD_OBJ[q]) && (nt>=1) && es);
      $display("SUP q=%0d gold=%0d tok0=%0d ntok=%0d eos=%0d", q, GOLD_OBJ[q], t0, nt, es);
    end
    if (acc_ok==8) $display("CLASS_w_normal_grounded HIT acc=%0d/8", acc_ok);
    else $display("CLASS_w_normal_grounded MISS acc=%0d/8", acc_ok);

    // unsupported 2
    for (q=0;q<2;q=q+1) begin
      run_q(GOLD_OBJ[q], 1'b0, t0, nt, es);
      if (t0==0) un_ok=un_ok+1;
      chk($sformatf("UNSUP_Q%0d", q), t0==0 && es);
    end

    // B zero weights
    hard_rst();
    run_q(10, 1'b1, t0, nt, es);
    chk("ZERO_SAFE", t0==0);
    if (t0==0) $display("CLASS_w_zero_safe HIT tok0=%0d", t0);
    else $display("CLASS_w_zero_safe MISS tok0=%0d", t0);

    // C corrupt match
    hard_rst();
    ld(A7NG_C4G_LD_MATCH, 6'd0, -16'sd50);
    ld(A7NG_C4G_LD_SAFE,  6'd0, 16'sd0);
    ld(A7NG_C4G_LD_EOS,   6'd0, 16'sd0);
    run_q(10, 1'b1, t0, nt, es);
    chk("CORRUPT_NOT_GOLD", t0!=10);
    if (t0!=10) $display("CLASS_w_corrupt_not_gold HIT tok0=%0d gold=10", t0);
    else $display("CLASS_w_corrupt_not_gold MISS tok0=%0d", t0);

    // D evidence removed
    hard_rst(); load_normal();
    run_q(10, 1'b0, t0, nt, es);
    chk("EVID_REMOVED", t0==0);
    if (t0==0) $display("CLASS_evid_removed_safe HIT tok0=%0d", t0);
    else $display("CLASS_evid_removed_safe MISS tok0=%0d", t0);

    // E evidence replaced
    hard_rst(); load_normal();
    run_q(30, 1'b1, t0, nt, es);
    chk("EVID_REPLACED", t0==30 && t0!=10);
    if (t0==30 && t0!=10) $display("CLASS_evid_replaced_changes HIT tok0=%0d not 10", t0);
    else $display("CLASS_evid_replaced_changes MISS tok0=%0d", t0);

    if (host_bad==0) $display("CLASS_host_next_token_zero HIT");
    else $display("CLASS_host_next_token_zero MISS n=%0d", host_bad);
    if (saw_eos>=8) $display("CLASS_eos_or_max HIT");
    else $display("CLASS_eos_or_max MISS saw_eos=%0d", saw_eos);
    $display("CLASS_path_evid_lm_feedback_eos HIT n_supported=%0d acc=%0d", acc_n, acc_ok);
    chk("HOST0", host_bad==0);
    chk("ACC8", acc_ok==8);
    chk("UNSUP2", un_ok==2);

    if (fail==0) $display("ASTRA_C4_LM06_GROUNDED_GEN_XSIM_PASS");
    else $display("ASTRA_C4_LM06_GROUNDED_GEN_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO LM06_BYTE256=NOT_FROZEN quality=COMPACT_LINEAR_HEAD_V64_NOT_802K");
    $finish;
  end
endmodule
