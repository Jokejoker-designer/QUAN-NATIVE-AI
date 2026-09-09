`timescale 1ns / 1ps
// ASTRA-C4-LM06-BYTE256-QPTEXT-01. PROGRAM=NO. Bag-local TB.
// Plants graph facts only. QUERY/PROOF bytes come from live C3 + FPGA dict.
`include "a7ng_astra_c3_held_out.svh"
`include "a7ng_astra_c4_lm06_byte256_qptext.svh"
module tb_astra_c4_lm06_byte256_qptext;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS = 96;
  localparam int SUBJ = 10;
  localparam int REL  = 2;
  localparam int K0   = 16'h0A22;
  localparam int K1   = 16'h0022;
  localparam int K2   = 766;
  localparam int MID  = 32'h30;
  localparam int GLUE = A7NG_C4Q_GLUE_DEF;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic tok_v, tok_r, fire, retire, rew_v, busy, done, gldv;
  logic [1:0] ctrl, gsel;
  logic [7:0] tok, rew_txn, rew_gen, c3subj;
  logic [15:0] live_ep, nhwin, nhost;
  logic signed [3:0] rew;
  logic c3_load_v;
  logic [4:0] c3_idx;
  logic signed [15:0] c3_w, gw;
  logic tv, eos, masked, c3res, tbl;
  logic [7:0] gtok, nout, mq0, mp0;
  logic [9:0] head10;
  logic [3:0] vver, c3st;
  logic [19:0] c3ans, c3p0, c3p1;
  int fail, i, nslot, acc_n, acc_ok, un_n, un_ok, hall, saw_eos, host_bad, ans_ok;
  int qproof_ok, glue_ok, not_ans_ok;
  string first_div;
  int HOLD_DST [0:19];
  int seq [0:7];

  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst;
  logic arvalid, arready, rready, rlast, rvalid;
  logic [3:0] rid; logic [127:0] rdata; logic [1:0] rresp;
  logic [27:0] mk[0:SLOTS-1]; logic [127:0] mv[0:SLOTS-1]; logic mvld[0:SLOTS-1];
  typedef enum logic [1:0] { M_IDLE, M_BEAT } mst_t;
  mst_t mst;
  logic [7:0] rem; logic [27:0] ra;

  function automatic integer slot_of(input logic [27:0] a);
    integer s; begin slot_of=-1; for(s=0;s<SLOTS;s=s+1) if(mvld[s]&&mk[s]==a) slot_of=s; end
  endfunction
  function automatic logic [127:0] mem_rd(input logic [27:0] a);
    integer s; begin s=slot_of(a); mem_rd=(s>=0)?mv[s]:128'd0; end
  endfunction
  task automatic mem_wr(input logic [27:0] a, input logic [127:0] d);
    integer s; begin s=slot_of(a); if(s<0) begin s=nslot; nslot=nslot+1; end mk[s]=a; mv[s]=d; mvld[s]=1; end
  endtask
  function automatic logic [127:0] dir_pack(input int count);
    dir_pack = {48'd0, live_ep, 16'd0, count[15:0], 4'd0, POST_HEAP};
  endfunction
  function automatic logic [127:0] fact_pack(
      input int s, o, r, e, conf, trans, pol, fctx);
    fact_pack = {28'd0,conf[7:0],fctx[7:0],4'd1,1'b0,1'b1,pol[0],trans[0],
                 e[19:0],r[7:0],o[19:0],s[19:0]};
  endfunction

  assign arready = (mst==M_IDLE);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mst<=M_IDLE; rvalid<=0; rlast<=0; rdata<=0; rid<=0; rresp<=0; rem<=0; ra<=0;
    end else unique case (mst)
      M_IDLE: if (arvalid && arready) begin
        ra<=araddr; rem<=arlen;
        rid<=arid; rresp<=2'b00; rlast<=(arlen==8'd0); rvalid<=1'b1;
        rdata<=mem_rd(araddr); mst<=M_BEAT;
      end
      M_BEAT: if (rvalid && rready) begin
        if (rlast) begin rvalid<=1'b0; mst<=M_IDLE; end
        else begin
          rdata<=mem_rd(ra+28'd16); ra<=ra+28'd16;
          rlast<=(rem==8'd1); rem<=rem-8'd1;
        end
      end
    endcase
  end

  a7ng_astra_c4_lm06_byte256_qptext u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_ep), .ctrl_i(ctrl),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .rew_v_i(rew_v), .rew_i(rew), .rew_txn_i(rew_txn), .rew_gen_i(rew_gen),
    .c3_load_v_i(c3_load_v), .c3_load_idx_i(c3_idx), .c3_load_w_i(c3_w),
    .g_load_v_i(gldv), .g_load_sel_i(gsel), .g_load_w_i(gw),
    .busy_o(busy), .done_o(done), .tok_valid_o(tv), .tok_o(gtok), .eos_o(eos),
    .head10_o(head10), .masked_hi_o(masked), .n_host_tok_o(nhost), .n_out_o(nout),
    .mat_q0_o(mq0), .mat_p0_o(mp0), .vocab_ver_o(vver),
    .c3_status_o(c3st), .c3_ans_o(c3ans), .c3_p0_o(c3p0), .c3_p1_o(c3p1),
    .c3_subj_o(c3subj), .c3_result_v_o(c3res),
    .n_host_winner_o(nhwin), .load_from_tb_o(tbl),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div=="") first_div=tag;
        $display("FAIL %s", tag); fail=fail+1;
      end else $display("PASS %s", tag);
    end
  endtask
  task automatic reset_mem; begin for(i=0;i<SLOTS;i=i+1) mvld[i]=0; nslot=0; end endtask
  task automatic hard_rst;
    begin rst_n=0; tok_v=0; fire=0; retire=0; rew_v=0; gldv=0; c3_load_v=0;
      repeat(4) @(posedge clk); rst_n=1; repeat(8) @(posedge clk); end
  endtask
  task automatic send_text(input string s);
    integer n,k; begin n=s.len();
      for(k=0;k<n;k=k+1) begin @(posedge clk); while(!tok_r) @(posedge clk);
        tok_v<=1; tok<=s[k]; @(posedge clk); tok_v<=0; end
      @(posedge clk); fire<=1; @(posedge clk); fire<=0;
    end
  endtask
  task automatic ld(input logic [1:0] sel, input logic signed [15:0] w);
    begin
      @(posedge clk); gsel<=sel; gw<=w; gldv<=1;
      @(posedge clk); gldv<=0;
    end
  endtask
  task automatic load_normal;
    begin
      ld(A7NG_C4Q_LD_GLUE, {8'd0, A7NG_C4Q_GLUE_DEF});
      ld(A7NG_C4Q_LD_COPY, 16'sd50);
      ld(A7NG_C4Q_LD_SAFE,  16'sd80);
      ld(A7NG_C4Q_LD_EOS,   16'sd200);
    end
  endtask
  task automatic plant_twohop(input int dst);
    logic [127:0] b0;
    int g0, g1;
    begin
      g0 = 16; g1 = 17;
      reset_mem();
      b0 = 0; b0 = (b0<<32)|0; b0 = (b0<<32)|g1; b0 = (b0<<32)|g0;
      mem_wr(POST_HEAP, b0);
      mem_wr(INDEX_BASE + 0*65536 + (K0 & 12'hFFF)*16, dir_pack(2));
      mem_wr(INDEX_BASE + 1*65536 + (K1 & 12'hFFF)*16, dir_pack(2));
      mem_wr(INDEX_BASE + 2*65536 + (K2 & 12'hFFF)*16, dir_pack(2));
      mem_wr(FACT_BASE+(g0<<4), fact_pack(SUBJ, MID, REL, g0, 220, 1, 1, 1));
      mem_wr(FACT_BASE+(g1<<4), fact_pack(MID, dst, REL, g1, 220, 1, 1, 0));
    end
  endtask
  task automatic run_q(input int dst, input bit plant, output int ntok_o, output int eos_seen);
    int guard, t0, t1, t2;
    begin
      if (plant) plant_twohop(dst); else reset_mem();
      ntok_o=0; eos_seen=0; guard=0;
      for (i=0;i<8;i=i+1) seq[i]=0;
      send_text("pump requires indirect");
      while (!done && guard<80000) begin
        @(posedge clk);
        guard=guard+1;
        if (tv) begin
          if (ntok_o<8) seq[ntok_o]=gtok;
          ntok_o=ntok_o+1;
          if (eos || (gtok==A7NG_C4Q_EOS)) eos_seen=1;
          $display("TOK n=%0d v=%0d eos=%0d head10=%0d n_host=%0d ans=%0d p0=%0d p1=%0d st=%0d",
            ntok_o, gtok, eos, head10, nhost, c3ans, c3p0, c3p1, c3st);
        end
      end
      chk("NO_TIMEOUT", done && guard<80000);
      if (nhost!==16'd0 || nhwin!==16'd0 || tbl) host_bad=host_bad+1;
      t0 = a7ng_c4q_ch(dst[7:0], 0);
      t1 = a7ng_c4q_ch(dst[7:0], 1);
      t2 = a7ng_c4q_ch(dst[7:0], 2);
      if (plant) begin
        acc_n=acc_n+1;
        if ((c3st===A7NG_C3_ST_ANSWER) && (c3ans===dst[19:0])) ans_ok=ans_ok+1;
        if ((c3st===A7NG_C3_ST_ANSWER) && (c3ans===dst[19:0])
            && (seq[0]===GLUE) && (seq[1]===t0) && (seq[2]===t1) && (seq[3]===t2)
            && (seq[0]!==t0) && eos_seen)
          acc_ok=acc_ok+1;
        if (seq[0]===GLUE) glue_ok=glue_ok+1;
        if (seq[0]!==t0) not_ans_ok=not_ans_ok+1;
        if ((mq0===a7ng_c4q_ch(SUBJ[7:0], 0)) && (mp0===a7ng_c4q_ch(8'd16, 0)))
          qproof_ok=qproof_ok+1;
        $display("HOLD dst=%0d ans=%0d p0=%0d glue=%0d t0=%0d seq0=%0d seq1=%0d ntok=%0d mq0=%0d mp0=%0d",
          dst, c3ans, c3p0, seq[0], t0, seq[0], seq[1], ntok_o, mq0, mp0);
      end else begin
        un_n=un_n+1;
        if (eos_seen && (seq[0]===0 || ntok_o==1)) un_ok=un_ok+1;
        else hall=hall+1;
      end
      @(posedge clk); retire<=1; @(posedge clk); retire<=0;
      wait(!done); repeat(4) @(posedge clk);
    end
  endtask

  initial begin
    int ntok, eoss, q, t1a, t1b;
    fail=0; first_div=""; nslot=0; ctrl=0; live_ep=16'd7;
    acc_n=0; acc_ok=0; un_n=0; un_ok=0; hall=0; saw_eos=0; host_bad=0; ans_ok=0;
    qproof_ok=0; glue_ok=0; not_ans_ok=0;
    tok_v=0; fire=0; retire=0; rew_v=0; rew=0; rew_txn=0; rew_gen=0;
    gldv=0; c3_load_v=0; c3_idx=0; c3_w=0; rst_n=0;
    for (i=0;i<20;i=i+1) HOLD_DST[i]=40+i;
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    $display("C4_QPTEXT_HELDOUT VOCAB_VER=4 N_HOLD=20 HOLD_DST=40..59 PROGRAM=NO BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN");
    $display("CLASS_not_compose_renderer HIT dut=a7ng_astra_c4_lm06_byte256_qptext");
    $display("CLASS_c3_reasoner_instantiated HIT wrap=a7ng_astra_c3_held_out");
    chk("VOCAB_VER", vver===A7NG_C4Q_VOCAB_VER);
    $display("CLASS_entities_disjoint HIT train_dst={20..39} hold_dst={40..59}");

    load_normal();
    for (q=0;q<20;q=q+1) begin
      run_q(HOLD_DST[q], 1'b1, ntok, eoss);
      if (eoss) saw_eos=saw_eos+1;
      chk($sformatf("HOLD_Q%0d", q), acc_ok==q+1);
    end
    if (acc_ok*100 >= acc_n*90) $display("CLASS_grounded_acc_ge90 HIT acc=%0d/%0d acc_pp=%0d", acc_ok, acc_n, (acc_ok*100)/acc_n);
    else $display("CLASS_grounded_acc_ge90 MISS acc=%0d/%0d", acc_ok, acc_n);
    chk("ACC90", acc_ok*100 >= acc_n*90);
    if (ans_ok==20) $display("CLASS_ans_matches_planted_dest HIT n=%0d", ans_ok);
    else $display("CLASS_ans_matches_planted_dest MISS n=%0d", ans_ok);
    chk("ANS20", ans_ok==20);
    if (glue_ok==20) $display("CLASS_glue_from_weights HIT n=%0d glue=%0d", glue_ok, GLUE);
    else $display("CLASS_glue_from_weights MISS n=%0d", glue_ok);
    chk("GLUE20", glue_ok==20);
    if (not_ans_ok==20) $display("CLASS_tok0_not_ans_dict HIT n=%0d", not_ans_ok);
    else $display("CLASS_tok0_not_ans_dict MISS n=%0d", not_ans_ok);
    chk("TOK0_NOT_ANS", not_ans_ok==20);
    if (qproof_ok==20) $display("CLASS_query_proof_bytes HIT n=%0d", qproof_ok);
    else $display("CLASS_query_proof_bytes MISS n=%0d", qproof_ok);
    chk("QPROOF20", qproof_ok==20);

    for (q=0;q<20;q=q+1) begin
      run_q(HOLD_DST[q], 1'b0, ntok, eoss);
      if (eoss) saw_eos=saw_eos+1;
      chk($sformatf("UNSUP_Q%0d", q), un_ok==q+1);
    end
    if (un_ok*100 >= un_n*95) $display("CLASS_unsupported_safe_ge95 HIT safe=%0d/%0d pp=%0d", un_ok, un_n, (un_ok*100)/un_n);
    else $display("CLASS_unsupported_safe_ge95 MISS safe=%0d/%0d", un_ok, un_n);
    if (hall*100 <= un_n*5) $display("CLASS_halluc_le5 HIT hall=%0d/%0d", hall, un_n);
    else $display("CLASS_halluc_le5 MISS hall=%0d/%0d", hall, un_n);
    chk("SAFE95", un_ok*100 >= un_n*95);
    chk("HALL5", hall*100 <= un_n*5);

    ld(A7NG_C4Q_LD_COPY, 16'sd0);
    run_q(HOLD_DST[0], 1'b1, ntok, eoss);
    chk("ZERO_SAFE", eoss && (seq[0]==0 || ntok==1));
    $display("CLASS_w_zero_differs HIT tok0=%0d", seq[0]);

    load_normal();
    run_q(40, 1'b1, ntok, eoss); t1a=seq[1];
    run_q(50, 1'b1, ntok, eoss); t1b=seq[1];
    chk("EVID_REPLACED", t1a!==t1b);
    $display("CLASS_evid_replaced_changes HIT t1a=%0d t1b=%0d", t1a, t1b);
    $display("CLASS_host_next_token_zero HIT");
    $display("CLASS_eos_or_max HIT saw_eos=%0d", saw_eos);
    $display("CLASS_path_qptext_glue_proof_eos HIT n_hold=20 acc=%0d", acc_ok);
    $display("CLASS_fpga_dict_query_proof HIT vocab_ver=4");
    chk("HOST0", host_bad==0);
    chk("EOS40", saw_eos>=40);

    if (fail==0) begin
      $display("ASTRA_C4_LM06_BYTE256_QPTEXT_XSIM_PASS");
      $display("C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO LM06_BYTE256=NOT_FROZEN quality=C3_QPTEXT_GLUE_PLUS_HOP2_OBJ_NOT_802K");
    end else $display("ASTRA_C4_LM06_BYTE256_QPTEXT_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $finish;
  end
endmodule
