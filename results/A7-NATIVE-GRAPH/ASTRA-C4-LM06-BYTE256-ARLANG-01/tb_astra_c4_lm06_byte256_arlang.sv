`timescale 1ns / 1ps
// ASTRA-C4-LM06-BYTE256-ARLANG-01. PROGRAM=NO. Bag-local TB.
// Compact AR BYTE256. Not TinyGPT. Not compose. Not C4_MASTER.
`include "a7ng_astra_c4_lm06_byte256_arlang.svh"
module tb_astra_c4_lm06_byte256_arlang;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic go, retire, load_v, evid_has, busy, done, tok_v, eos, masked;
  logic [1:0] load_sel;
  logic signed [15:0] load_w;
  logic [7:0] q0, e0, o0, o1, o2, tok, n_out, mq0, mp0;
  logic [9:0] head10;
  logic [15:0] n_host;
  logic [3:0] vver;
  int fail, q, t0, nt, es, acc_ok, zero_ok, corr_ok, rem_ok, rem_hall, saw_eos, host_bad, yes_ok;
  int seq [0:7];
  string first_div;
  int HOLD [0:19] = '{40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59};

  a7ng_astra_c4_lm06_byte256_arlang_gen u_dut (
    .clk(clk), .rst_n(rst_n), .go_i(go), .retire_i(retire),
    .load_v_i(load_v), .load_sel_i(load_sel), .load_w_i(load_w),
    .q0_i(q0), .e0_i(e0), .obj0_i(o0), .obj1_i(o1), .obj2_i(o2), .evid_has_i(evid_has),
    .busy_o(busy), .done_o(done), .tok_valid_o(tok_v), .tok_o(tok), .eos_o(eos),
    .head10_o(head10), .masked_hi_o(masked), .n_host_tok_o(n_host), .n_out_o(n_out),
    .mat_q0_o(mq0), .mat_p0_o(mp0), .vocab_ver_o(vver)
  );

  function automatic int ch(input int id, input int pos);
    begin
      if (pos==0) ch = 8'h41 + (id % 26);
      else if (pos==1) ch = 8'h61 + ((id * 5) % 26);
      else ch = 8'h30 + (id % 10);
    end
  endfunction
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
  task automatic ld(input logic [1:0] sel, input logic signed [15:0] w);
    begin @(posedge clk); load_sel<=sel; load_w<=w; load_v<=1; @(posedge clk); load_v<=0; end
  endtask
  task automatic run_q(input int dst, input bit has, output int tok0, output int ntok_o, output int eos_seen);
    int guard, i;
    begin
      q0=8'd81; e0=8'd80;
      o0=ch(dst,0); o1=ch(dst,1); o2=ch(dst,2);
      evid_has=has;
      tok0=0; ntok_o=0; eos_seen=0; guard=0;
      for (i=0;i<8;i=i+1) seq[i]=0;
      @(posedge clk); go<=1; @(posedge clk); go<=0;
      while (!done && guard<300000) begin
        @(posedge clk);
        guard=guard+1;
        if (tok_v) begin
          if (ntok_o==0) tok0=tok;
          if (ntok_o<8) seq[ntok_o]=tok;
          ntok_o=ntok_o+1;
          if (eos || tok==A7NG_C4L_EOS) eos_seen=1;
          $display("TOK n=%0d v=%0d eos=%0d dst=%0d has=%0d n_host=%0d", ntok_o, tok, eos, dst, has, n_host);
        end
        if (n_host!=0) host_bad=host_bad+1;
      end
      chk("NO_TIMEOUT", done && guard<300000);
      @(posedge clk); retire<=1; @(posedge clk); retire<=0; wait(!done); repeat(2) @(posedge clk);
    end
  endtask
  function automatic bit gold_ok(input int dst);
    begin
      gold_ok = (seq[0]==121) && (seq[1]==101) && (seq[2]==115)
             && (seq[3]==ch(dst,0)) && (seq[4]==ch(dst,1)) && (seq[5]==ch(dst,2))
             && (seq[6]==0);
    end
  endfunction

  initial begin
    fail=0; first_div=""; host_bad=0; acc_ok=0; zero_ok=0; corr_ok=0;
    rem_ok=0; rem_hall=0; saw_eos=0; yes_ok=0;
    rst_n=0; go=0; retire=0; load_v=0; load_sel=0; load_w=0;
    q0=0; e0=0; o0=0; o1=0; o2=0; evid_has=0;
    repeat(4) @(posedge clk); rst_n=1; repeat(4) @(posedge clk);
    $display("C4_ARLANG V=256 D=32 N=20 PROGRAM=NO BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN C4_MASTER=OPEN");
    $display("CLASS_not_compose_renderer HIT dut=a7ng_astra_c4_lm06_byte256_arlang_gen");
    $display("CLASS_not_tinygpt_802k HIT tinygpt=RETIRED_PER_GROK_550");

    hard_rst();
    for (q=0;q<20;q=q+1) begin
      run_q(HOLD[q], 1'b1, t0, nt, es);
      if (gold_ok(HOLD[q])) acc_ok=acc_ok+1;
      if ((seq[0]==121)&&(seq[1]==101)&&(seq[2]==115)) yes_ok=yes_ok+1;
      if (es) saw_eos=saw_eos+1;
      chk($sformatf("HOLD_Q%0d", q), gold_ok(HOLD[q]) && es);
      $display("HOLD q=%0d dst=%0d tok0=%0d ntok=%0d seq=%0d,%0d,%0d,%0d,%0d,%0d,%0d",
        q, HOLD[q], t0, nt, seq[0], seq[1], seq[2], seq[3], seq[4], seq[5], seq[6]);
    end
    if (acc_ok>=18) $display("CLASS_grounded_acc_ge90 HIT acc=%0d/20", acc_ok);
    else $display("CLASS_grounded_acc_ge90 MISS acc=%0d/20", acc_ok);
    if (yes_ok==20) $display("CLASS_ar_yes_prefix HIT n=%0d/20", yes_ok);
    else $display("CLASS_ar_yes_prefix MISS n=%0d/20", yes_ok);
    chk("ACC_GE90", acc_ok>=18);

    hard_rst(); ld(A7NG_C4L_LD_ZERO, 16'sd1);
    for (q=0;q<20;q=q+1) begin
      run_q(HOLD[q], 1'b1, t0, nt, es);
      if (t0==0 && es) zero_ok=zero_ok+1;
      chk($sformatf("ZERO_Q%0d", q), t0==0 && es);
    end
    if (zero_ok==20) $display("CLASS_w_zero_safe HIT n=%0d/20", zero_ok);
    else $display("CLASS_w_zero_safe MISS n=%0d/20", zero_ok);
    chk("ZERO20", zero_ok==20);

    hard_rst(); ld(A7NG_C4L_LD_SCALE, 16'sd1);
    for (q=0;q<20;q=q+1) begin
      run_q(HOLD[q], 1'b1, t0, nt, es);
      if (!gold_ok(HOLD[q])) corr_ok=corr_ok+1;
      chk($sformatf("CORRUPT_Q%0d", q), !gold_ok(HOLD[q]));
    end
    if (corr_ok==20) $display("CLASS_w_corrupt_not_gold HIT n=%0d/20", corr_ok);
    else $display("CLASS_w_corrupt_not_gold MISS n=%0d/20", corr_ok);
    chk("CORRUPT20", corr_ok==20);

    hard_rst();
    for (q=0;q<20;q=q+1) begin
      run_q(HOLD[q], 1'b0, t0, nt, es);
      if (t0==0 && es) rem_ok=rem_ok+1;
      if (t0!=0) rem_hall=rem_hall+1;
      chk($sformatf("REMOVED_Q%0d", q), t0==0 && es);
    end
    if (rem_ok==20) $display("CLASS_evid_removed_safe HIT n=%0d/20", rem_ok);
    else $display("CLASS_evid_removed_safe MISS n=%0d/20", rem_ok);
    if (rem_hall<=1) $display("CLASS_evid_removed_halluc_le5 HIT hall=%0d/20", rem_hall);
    else $display("CLASS_evid_removed_halluc_le5 MISS hall=%0d/20", rem_hall);
    chk("HALL_LE5", rem_hall<=1);

    if (host_bad==0) $display("CLASS_host_next_token_zero HIT");
    else $display("CLASS_host_next_token_zero MISS n=%0d", host_bad);
    if (saw_eos>=20) $display("CLASS_eos_or_max HIT saw_eos=%0d", saw_eos);
    else $display("CLASS_eos_or_max MISS saw_eos=%0d", saw_eos);
    chk("HOST0", host_bad==0);

    if (fail==0) $display("ASTRA_C4_LM06_BYTE256_ARLANG_XSIM_PASS");
    else $display("ASTRA_C4_LM06_BYTE256_ARLANG_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO LM06_BYTE256=NOT_FROZEN TINYGPT_802K=RETIRED_PER_GROK_550");
    $finish;
  end
endmodule
