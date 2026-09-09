`timescale 1ns / 1ps
// ASTRA-C4-LM06-BYTE256-CONTRACT-01. PROGRAM=NO. Bag-local TB.
// Contract/mask only. Not grounded-gen 90%. Not historical 653/689/237/60 gold.
`include "a7ng_astra_c4_lm06_byte256.svh"
module tb_astra_c4_lm06_byte256;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic go, retire, busy, done, out_v, masked, eos, phys;
  logic [7:0] in_tok, out_tok, feed;
  logic [9:0] head10;
  logic [15:0] n_host;
  logic [4:0] in_w, out_w, head_w;
  logic [9:0] cid [0:3];
  logic signed [15:0] csc [0:3];
  int fail, i;
  string first_div;
  int n_valid_hi, n_host_seen;

  a7ng_astra_c4_lm06_byte256 u_dut (
    .clk(clk), .rst_n(rst_n), .go_i(go), .retire_i(retire),
    .in_tok_i(in_tok), .cand_id_i(cid), .cand_sc_i(csc),
    .busy_o(busy), .done_o(done),
    .head10_o(head10), .out_tok_o(out_tok), .out_valid_o(out_v),
    .masked_hi_o(masked), .eos_o(eos), .feed_tok_o(feed),
    .n_host_tok_o(n_host), .in_w_o(in_w), .out_w_o(out_w), .head_w_o(head_w),
    .phys_head_present_o(phys)
  );

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div=="") first_div=tag;
        $display("FAIL %s", tag); fail=fail+1;
      end else $display("PASS %s", tag);
    end
  endtask
  task automatic set4(
      input logic [9:0] a, input logic signed [15:0] sa,
      input logic [9:0] b, input logic signed [15:0] sb,
      input logic [9:0] c, input logic signed [15:0] scv,
      input logic [9:0] d, input logic signed [15:0] sd);
    begin
      cid[0]=a; csc[0]=sa; cid[1]=b; csc[1]=sb;
      cid[2]=c; csc[2]=scv; cid[3]=d; csc[3]=sd;
    end
  endtask
  task automatic fire;
    begin
      @(posedge clk); go<=1; @(posedge clk); go<=0;
      wait(done); @(posedge clk);
    end
  endtask
  task automatic ret;
    begin @(posedge clk); retire<=1; @(posedge clk); retire<=0; wait(!done); repeat(2) @(posedge clk); end
  endtask

  initial begin
    fail=0; first_div=""; n_valid_hi=0; n_host_seen=0;
    rst_n=0; go=0; retire=0; in_tok=0;
    for(i=0;i<4;i=i+1) begin cid[i]=0; csc[i]=0; end
    repeat(4) @(posedge clk); rst_n=1; repeat(4) @(posedge clk);

    $display("C4_BYTE256 LAW=lm06-byte256-contract-01 PROGRAM=NO BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN");
    $display("HIST_ORACLE_653_689_237_60 not this gold");

    chk("IN_W8", in_w==5'd8);
    chk("OUT_W8", out_w==5'd8);
    chk("HEAD_W10", head_w==5'd10);
    chk("PHYS_HEAD", phys==1'b1);
    if (in_w==5'd8) $display("CLASS_in_tok_width_8 HIT in_w=%0d", in_w);
    else $display("CLASS_in_tok_width_8 MISS in_w=%0d", in_w);
    if (phys && head_w==5'd10) $display("CLASS_phys_head10_present HIT head_w=%0d", head_w);
    else $display("CLASS_phys_head10_present MISS");
    $display("CLASS_hist_oracle_not_this_gold HIT ids=653,689,237,60 unused_as_gold");

    in_tok=8'h41;
    set4(10'd65, 16'sd10, 10'd1, 16'sd1, 10'd2, 16'sd1, 10'd3, 16'sd1);
    fire();
    $display("BYTE_OK head10=%0d out=%0d valid=%0d masked=%0d", head10, out_tok, out_v, masked);
    chk("BYTE_OK", out_v && !masked && (head10==10'd65) && (out_tok==8'h41));
    if (out_v && (out_tok <= 8'hFF) && (head10 <= A7NG_C4_BYTE_MAX))
      $display("CLASS_out_domain_0_255 HIT tok=%0d", out_tok);
    else $display("CLASS_out_domain_0_255 MISS");
    ret();

    in_tok=8'h4A;
    set4(10'd74, 16'sd20, 10'd10, 16'sd5, 10'd11, 16'sd4, 10'd12, 16'sd3);
    fire();
    chk("SHARED", out_v && (in_tok==out_tok) && (out_tok==8'h4A) && (head10==10'd74));
    if (out_v && (in_tok==out_tok)) $display("CLASS_shared_byte_vocab HIT tok=%0d", out_tok);
    else $display("CLASS_shared_byte_vocab MISS");
    chk("FEED_EQ_OUT", feed==out_tok);
    ret();

    set4(10'd256, 16'sd99, 10'd1, 16'sd1, 10'd2, 16'sd1, 10'd3, 16'sd1);
    fire();
    $display("MASK256 head10=%0d valid=%0d masked=%0d out=%0d", head10, out_v, masked, out_tok);
    chk("MASK256", masked && !out_v && (head10==10'd256) && (out_tok==8'd0));
    if (masked && !out_v && (head10>=10'd256)) $display("CLASS_mask_ge256 HIT head10=%0d", head10);
    else $display("CLASS_mask_ge256 MISS");
    if (out_v && (head10>A7NG_C4_BYTE_MAX)) n_valid_hi = n_valid_hi + 1;
    ret();

    set4(A7NG_C4_HIST_653, 16'sd50, 10'd4, 16'sd2, 10'd5, 16'sd1, 10'd6, 16'sd0);
    fire();
    chk("MASK653", masked && !out_v && (head10==A7NG_C4_HIST_653));
    if (masked && !out_v && (head10==A7NG_C4_HIST_653))
      $display("CLASS_hist_653_masked HIT head10=%0d", head10);
    else $display("CLASS_hist_653_masked MISS");
    if (out_v && (head10>A7NG_C4_BYTE_MAX)) n_valid_hi = n_valid_hi + 1;
    ret();

    set4(A7NG_C4_HIST_689, 16'sd50, 10'd7, 16'sd2, 10'd8, 16'sd1, 10'd9, 16'sd0);
    fire();
    chk("MASK689", masked && !out_v && (head10==A7NG_C4_HIST_689));
    if (masked && !out_v && (head10==A7NG_C4_HIST_689))
      $display("CLASS_hist_689_masked HIT head10=%0d", head10);
    else $display("CLASS_hist_689_masked MISS");
    if (out_v && (head10>A7NG_C4_BYTE_MAX)) n_valid_hi = n_valid_hi + 1;
    ret();

    set4(10'd1023, 16'sd80, 10'd20, 16'sd1, 10'd21, 16'sd1, 10'd22, 16'sd1);
    fire();
    chk("MASK1023", masked && !out_v && (head10==10'd1023) && phys);
    if (out_v && (head10>A7NG_C4_BYTE_MAX)) n_valid_hi = n_valid_hi + 1;
    ret();

    in_tok=8'h21;
    set4(10'd33, 16'sd9, 10'd0, 16'sd0, 10'd1, 16'sd0, 10'd2, 16'sd0);
    fire();
    chk("STEP0", out_v && (out_tok==8'h21) && (n_host==16'd0));
    in_tok = feed;
    ret();
    set4(10'd34, 16'sd9, 10'd0, 16'sd0, 10'd1, 16'sd0, 10'd2, 16'sd0);
    fire();
    chk("STEP1_FEED", out_v && (in_tok==8'h21) && (out_tok==8'h22) && (n_host==16'd0));
    if (n_host!=0) n_host_seen = n_host_seen + 1;
    ret();

    set4(10'd0, 16'sd5, 10'd40, 16'sd1, 10'd41, 16'sd1, 10'd42, 16'sd1);
    fire();
    chk("EOS", out_v && eos && (out_tok==A7NG_C4_EOS_BYTE));
    ret();

    if (n_host==16'd0 && n_host_seen==0) $display("CLASS_host_next_token_zero HIT");
    else $display("CLASS_host_next_token_zero MISS n_host=%0d extra=%0d", n_host, n_host_seen);
    chk("NO_VALID_HI10", n_valid_hi==0);
    chk("HOST0", n_host==16'd0);

    if (fail==0) $display("ASTRA_C4_LM06_BYTE256_CONTRACT_XSIM_PASS");
    else $display("ASTRA_C4_LM06_BYTE256_CONTRACT_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO LM06_BYTE256=NOT_FROZEN quality=CONTRACT_MASK_4CAND_NOT_802K");
    $finish;
  end
endmodule
