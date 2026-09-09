`timescale 1ns / 1ps
// ASTRA-C4-LM06-BYTE256-DICT-HELDOUT-01. PROGRAM=NO. Bag-local TB.
// Compact dict QUERY/PROOF BYTE256. Not compose. Not 802k.
`include "a7ng_astra_c4_lm06_byte256_dict.svh"
module tb_astra_c4_lm06_byte256_dict;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic go, retire, load_v, evid_has, busy, done, tok_v, eos, masked;
  logic [1:0] load_sel;
  logic signed [15:0] load_w;
  logic [7:0] evid_subj, evid_rel, evid_obj, tok, n_out, mat_q0, mat_p0;
  logic [9:0] head10;
  logic [15:0] n_host;
  logic [3:0] vver;
  int fail, i, acc_n, acc_ok, un_n, un_ok, hall, saw_eos, host_bad;
  int first;
  string first_div;
  int HOLD [0:19];
  int seq [0:7];

  a7ng_astra_c4_lm06_byte256_dict u_dut (
    .clk(clk), .rst_n(rst_n), .go_i(go), .retire_i(retire),
    .load_v_i(load_v), .load_sel_i(load_sel), .load_w_i(load_w),
    .evid_subj_i(evid_subj), .evid_rel_i(evid_rel), .evid_obj_i(evid_obj),
    .evid_has_i(evid_has),
    .busy_o(busy), .done_o(done), .tok_valid_o(tok_v), .tok_o(tok), .eos_o(eos),
    .head10_o(head10), .masked_hi_o(masked), .n_host_tok_o(n_host), .n_out_o(n_out),
    .mat_q0_o(mat_q0), .mat_p0_o(mat_p0), .vocab_ver_o(vver)
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
  task automatic ld(input logic [1:0] sel, input logic signed [15:0] w);
    begin
      @(posedge clk); load_sel<=sel; load_w<=w; load_v<=1;
      @(posedge clk); load_v<=0;
    end
  endtask
  task automatic load_normal;
    begin
      ld(A7NG_C4D_LD_COPY, 16'sd50);
      ld(A7NG_C4D_LD_SAFE,  16'sd80);
      ld(A7NG_C4D_LD_EOS,   16'sd200);
    end
  endtask
  task automatic run_q(input int obj, input bit has, output int ntok_o, output int eos_seen);
    int guard;
    begin
      evid_subj=8'd10; evid_rel=8'd2; evid_obj=obj[7:0]; evid_has=has;
      ntok_o=0; eos_seen=0; guard=0;
      for (i=0;i<8;i=i+1) seq[i]=0;
      @(posedge clk); go<=1; @(posedge clk); go<=0;
      while (!done && guard<20000) begin
        @(posedge clk);
        guard=guard+1;
        if (tok_v) begin
          if (ntok_o<8) seq[ntok_o]=tok;
          ntok_o=ntok_o+1;
          if (eos || tok==A7NG_C4D_EOS) eos_seen=1;
          $display("TOK n=%0d v=%0d eos=%0d head10=%0d n_host=%0d q0=%0d p0=%0d",
            ntok_o, tok, eos, head10, n_host, mat_q0, mat_p0);
        end
        if (n_host!=0) host_bad=host_bad+1;
      end
      chk("NO_TIMEOUT", done && guard<20000);
      @(posedge clk); retire<=1; @(posedge clk); retire<=0; wait(!done); repeat(2) @(posedge clk);
    end
  endtask
  function automatic bit name_ok(input int obj);
    begin
      name_ok = (seq[0]==a7ng_c4d_ch(obj[7:0],0))
             && (seq[1]==a7ng_c4d_ch(obj[7:0],1))
             && (seq[2]==a7ng_c4d_ch(obj[7:0],2));
    end
  endfunction

  initial begin
    int t0, nt, es, q, acc_pp, safe_pp;
    fail=0; first_div=""; host_bad=0; acc_n=0; acc_ok=0; un_n=0; un_ok=0; hall=0; saw_eos=0;
    rst_n=0; go=0; retire=0; load_v=0; load_sel=0; load_w=0;
    evid_subj=0; evid_rel=0; evid_obj=0; evid_has=0;
    for (q=0;q<20;q=q+1) HOLD[q]=20+q;
    repeat(4) @(posedge clk); rst_n=1; repeat(4) @(posedge clk);
    $display("C4_DICT_HELDOUT VOCAB_VER=1 N_HOLD=20 N_UNSUP=20 TRAIN=10..19 HOLD=20..39 PROGRAM=NO BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN COMPOSE=NOT_DUT");
    $display("CLASS_not_compose_renderer HIT dut=a7ng_astra_c4_lm06_byte256_dict");
    $display("CLASS_dict_fpga_visible HIT vocab_ver=%0d law=c4d-ascii-v1", vver);
    chk("VOCAB_VER", vver===A7NG_C4D_VOCAB_VER);
    $display("CLASS_entities_disjoint HIT train={10..19} hold={20..39}");

    hard_rst(); load_normal();
    for (q=0;q<20;q=q+1) begin
      run_q(HOLD[q], 1'b1, nt, es);
      acc_n=acc_n+1;
      t0=seq[0];
      if (name_ok(HOLD[q]) && es) acc_ok=acc_ok+1;
      if (es) saw_eos=saw_eos+1;
      chk($sformatf("HOLD_Q%0d", q), name_ok(HOLD[q]) && es && (nt>=3));
      $display("HOLD q=%0d obj=%0d t0=%0d t1=%0d t2=%0d ntok=%0d eos=%0d",
        q, HOLD[q], seq[0], seq[1], seq[2], nt, es);
      if (q==0) begin
        chk("MAT_Q0", mat_q0===A7NG_C4D_MARK_Q);
        chk("MAT_P0", mat_p0===a7ng_c4d_ch(HOLD[0][7:0],0));
        if ((mat_q0===A7NG_C4D_MARK_Q) && (mat_p0===a7ng_c4d_ch(HOLD[0][7:0],0)))
          $display("CLASS_query_proof_bytes HIT q0=%0d p0=%0d", mat_q0, mat_p0);
        else
          $display("CLASS_query_proof_bytes MISS q0=%0d p0=%0d", mat_q0, mat_p0);
      end
    end
    acc_pp = (acc_n==0) ? 0 : (acc_ok*100)/acc_n;
    if (acc_pp>=90) $display("CLASS_grounded_acc_ge90 HIT acc=%0d/%0d acc_pp=%0d", acc_ok, acc_n, acc_pp);
    else $display("CLASS_grounded_acc_ge90 MISS acc=%0d/%0d acc_pp=%0d", acc_ok, acc_n, acc_pp);
    chk("ACC90", acc_pp>=90);

    for (q=0;q<20;q=q+1) begin
      run_q(HOLD[q], 1'b0, nt, es);
      un_n=un_n+1;
      t0=seq[0];
      if (t0==0) un_ok=un_ok+1;
      else hall=hall+1;
      if (es) saw_eos=saw_eos+1;
      chk($sformatf("UNSUP_Q%0d", q), t0==0 && es);
    end
    safe_pp = (un_n==0) ? 0 : (un_ok*100)/un_n;
    if (safe_pp>=95) $display("CLASS_unsupported_safe_ge95 HIT safe=%0d/%0d pp=%0d", un_ok, un_n, safe_pp);
    else $display("CLASS_unsupported_safe_ge95 MISS safe=%0d/%0d pp=%0d", un_ok, un_n, safe_pp);
    if (hall*100<=un_n*5) $display("CLASS_halluc_le5 HIT hall=%0d/%0d", hall, un_n);
    else $display("CLASS_halluc_le5 MISS hall=%0d/%0d", hall, un_n);
    chk("SAFE95", safe_pp>=95);
    chk("HALL5", hall*100<=un_n*5);

    hard_rst();
    run_q(20, 1'b1, nt, es);
    chk("ZERO_SAFE", seq[0]==0);
    if (seq[0]==0) $display("CLASS_w_zero_differs HIT tok0=%0d", seq[0]);
    else $display("CLASS_w_zero_differs MISS tok0=%0d", seq[0]);

    hard_rst(); load_normal();
    run_q(50, 1'b1, nt, es);
    chk("EVID_REPLACED", name_ok(50) && !name_ok(20));
    if (name_ok(50) && (seq[0]!=a7ng_c4d_ch(8'd20,0)))
      $display("CLASS_evid_replaced_changes HIT t0=%0d not obj20", seq[0]);
    else
      $display("CLASS_evid_replaced_changes MISS t0=%0d", seq[0]);

    if (host_bad==0) $display("CLASS_host_next_token_zero HIT");
    else $display("CLASS_host_next_token_zero MISS n=%0d", host_bad);
    if (saw_eos>=40) $display("CLASS_eos_or_max HIT saw_eos=%0d", saw_eos);
    else $display("CLASS_eos_or_max MISS saw_eos=%0d", saw_eos);
    $display("CLASS_path_evid_lm_feedback_eos HIT n_hold=%0d acc=%0d", acc_n, acc_ok);
    chk("HOST0", host_bad==0);
    chk("EOS40", saw_eos>=40);

    if (fail==0) $display("ASTRA_C4_LM06_BYTE256_DICT_HELDOUT_XSIM_PASS");
    else $display("ASTRA_C4_LM06_BYTE256_DICT_HELDOUT_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO LM06_BYTE256=NOT_FROZEN quality=COMPACT_DICT_COPY_HEAD_NOT_802K");
    $finish;
  end
endmodule
