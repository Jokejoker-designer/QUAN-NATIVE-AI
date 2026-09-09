`timescale 1ns / 1ps
// ASTRA-C4-LM06-GROUNDED-GEN-HELDOUT-20-01. PROGRAM=NO. Bag-local TB.
// 20 held-out object IDs on compact grounded_gen. Not compose. Not 802k.
// Does not edit GROUNDED-GEN-01 GOLDEN. Does not stamp C4_MASTER.
`include "a7ng_astra_c4_lm06_grounded_gen.svh"
module tb_astra_c4_lm06_grounded_gen_heldout20;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic go, retire, load_v, evid_has, busy, done, tok_v, eos, masked;
  logic [1:0] load_sel;
  logic [5:0] load_idx;
  logic signed [15:0] load_w;
  logic [7:0] evid_obj, evid_rel, tok, n_out;
  logic [9:0] head10;
  logic [15:0] n_host;
  int fail, ntok, acc_n, acc_ok, zero_ok, corr_ok, rem_ok, rem_hall, first;
  int saw_eos, host_bad, q, t0, nt, es;
  string first_div;
  int HOLD_OBJ [0:19] = '{20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39};

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
          $display("TOK n=%0d v=%0d eos=%0d head10=%0d n_host=%0d obj=%0d has=%0d", ntok_o, tok, eos, head10, n_host, obj, has);
        end
        if (n_host!=0) host_bad=host_bad+1;
      end
      chk("NO_TIMEOUT", done && guard<20000);
      @(posedge clk); retire<=1; @(posedge clk); retire<=0; wait(!done); repeat(2) @(posedge clk);
    end
  endtask

  initial begin
    fail=0; first_div=""; host_bad=0; acc_n=0; acc_ok=0; zero_ok=0; corr_ok=0;
    rem_ok=0; rem_hall=0; saw_eos=0;
    rst_n=0; go=0; retire=0; load_v=0; load_sel=0; load_idx=0; load_w=0;
    evid_obj=0; evid_rel=0; evid_has=0;
    repeat(4) @(posedge clk); rst_n=1; repeat(4) @(posedge clk);
    $display("C4_GROUNDED_GEN_HELDOUT20 V=64 N=20 PROGRAM=NO BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN C4_MASTER=OPEN");
    $display("CLASS_not_compose_renderer HIT dut=a7ng_astra_c4_lm06_grounded_gen");
    $display("CLASS_not_tinygpt_802k HIT tinygpt=RETIRED_PER_GROK_550");

    // A normal weights + evidence, 20 held-out
    hard_rst(); load_normal();
    for (q=0;q<20;q=q+1) begin
      run_q(HOLD_OBJ[q], 1'b1, t0, nt, es);
      acc_n=acc_n+1;
      if (t0==HOLD_OBJ[q]) acc_ok=acc_ok+1;
      if (es) saw_eos=saw_eos+1;
      chk($sformatf("HOLD_Q%0d", q), (t0==HOLD_OBJ[q]) && (nt>=1) && es);
      $display("HOLD q=%0d gold=%0d tok0=%0d ntok=%0d eos=%0d", q, HOLD_OBJ[q], t0, nt, es);
    end
    if (acc_ok==20) $display("CLASS_w_normal_grounded HIT acc=%0d/20", acc_ok);
    else $display("CLASS_w_normal_grounded MISS acc=%0d/20", acc_ok);
    if (acc_ok>=18) $display("CLASS_grounded_acc_ge90 HIT acc=%0d/20", acc_ok);
    else $display("CLASS_grounded_acc_ge90 MISS acc=%0d/20", acc_ok);
    chk("ACC_GE90", acc_ok>=18);

    // B zero weights: 20 held-out must be safe/EOS
    hard_rst();
    for (q=0;q<20;q=q+1) begin
      run_q(HOLD_OBJ[q], 1'b1, t0, nt, es);
      if (t0==0 && es) zero_ok=zero_ok+1;
      chk($sformatf("ZERO_Q%0d", q), t0==0 && es);
    end
    if (zero_ok==20) $display("CLASS_w_zero_safe HIT n=%0d/20", zero_ok);
    else $display("CLASS_w_zero_safe MISS n=%0d/20", zero_ok);
    chk("ZERO20", zero_ok==20);

    // C corrupt match: output must not copy gold object
    hard_rst();
    ld(A7NG_C4G_LD_MATCH, 6'd0, -16'sd50);
    ld(A7NG_C4G_LD_SAFE,  6'd0, 16'sd0);
    ld(A7NG_C4G_LD_EOS,   6'd0, 16'sd0);
    for (q=0;q<20;q=q+1) begin
      run_q(HOLD_OBJ[q], 1'b1, t0, nt, es);
      if (t0!=HOLD_OBJ[q]) corr_ok=corr_ok+1;
      chk($sformatf("CORRUPT_Q%0d", q), t0!=HOLD_OBJ[q]);
    end
    if (corr_ok==20) $display("CLASS_w_corrupt_not_gold HIT n=%0d/20", corr_ok);
    else $display("CLASS_w_corrupt_not_gold MISS n=%0d/20", corr_ok);
    chk("CORRUPT20", corr_ok==20);

    // D evidence removed: safe EOS, halluc <= 5% (at most 1/20 non-EOS)
    hard_rst(); load_normal();
    for (q=0;q<20;q=q+1) begin
      run_q(HOLD_OBJ[q], 1'b0, t0, nt, es);
      if (t0==0 && es) rem_ok=rem_ok+1;
      if (t0!=0) rem_hall=rem_hall+1;
      chk($sformatf("REMOVED_Q%0d", q), t0==0 && es);
    end
    if (rem_ok==20) $display("CLASS_evid_removed_safe HIT n=%0d/20", rem_ok);
    else $display("CLASS_evid_removed_safe MISS n=%0d/20", rem_ok);
    if (rem_hall<=1) $display("CLASS_evid_removed_halluc_le5 HIT hall=%0d/20", rem_hall);
    else $display("CLASS_evid_removed_halluc_le5 MISS hall=%0d/20", rem_hall);
    chk("HALL_LE5", rem_hall<=1);
    chk("REMOVED20", rem_ok==20);

    if (host_bad==0) $display("CLASS_host_next_token_zero HIT");
    else $display("CLASS_host_next_token_zero MISS n=%0d", host_bad);
    if (saw_eos>=20) $display("CLASS_eos_or_max HIT saw_eos=%0d", saw_eos);
    else $display("CLASS_eos_or_max MISS saw_eos=%0d", saw_eos);
    chk("HOST0", host_bad==0);
    chk("EOS20", saw_eos>=20);

    if (fail==0) $display("ASTRA_C4_LM06_GROUNDED_GEN_HELDOUT20_XSIM_PASS");
    else $display("ASTRA_C4_LM06_GROUNDED_GEN_HELDOUT20_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO LM06_BYTE256=NOT_FROZEN TINYGPT_802K=RETIRED_PER_GROK_550 quality=COMPACT_V64_CLASS_ID_NOT_LETTER_LANGUAGE");
    $finish;
  end
endmodule
