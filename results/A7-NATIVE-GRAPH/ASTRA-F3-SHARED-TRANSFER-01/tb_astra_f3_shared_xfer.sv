`timescale 1ns / 1ps
// ASTRA-F3-SHARED-TRANSFER-01. PROGRAM=NO. Bag-local TB.
// Five structurally independent seeds. Not ID-permutations of one plant.
`include "tb_oracles.svh"
module tb_astra_f3_shared_xfer;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS=96;
  localparam logic [3:0] ST_ANSWER=4'd0, ST_UNKNOWN=4'd1;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  int fail, i, nslot;
  string first_div;
  int en_c, fr_c, sh_c, pid_c, n_rank, n_ans, n_ret_ok;
  logic tok_v, tok_r, fire, retire, rew_v, busy, result_v, tbl;
  logic pend_acc, pend_cmt, load_v;
  logic [1:0] ctrl, sel;
  logic [7:0] tok, txn, gen, rew_txn, rew_gen, phi0, qobj, qctx;
  logic [15:0] live_ep;
  logic [4:0] load_idx, npath;
  logic signed [15:0] load_w;
  logic signed [3:0] rew;
  logic [19:0] ans, p0, p1;
  logic [3:0] st;
  logic signed [15:0] vbest, vsec, wdut [0:31];
  logic signed [7:0] pphi [0:31];
  logic [15:0] nupd, ndup, nbad;
  logic signed [7:0] xiso [0:31];
  logic go_s, go_u, rdy, dn, iso_load;
  logic signed [15:0] viso, wiso [0:31];
  logic signed [3:0] iso_rew;
  logic [19:0] pid_ans;

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
    dir_pack = {48'd0,16'd7,16'd0,count[15:0],4'd0,POST_HEAP};
  endfunction
  function automatic logic [127:0] fact_pack(
      input int s, o, r, e, conf, trans, pol, fctx);
    fact_pack = {28'd0,conf[7:0],fctx[7:0],4'd1,1'b0,1'b1,pol[0],trans[0],
                 e[19:0],r[7:0],o[19:0],s[19:0]};
  endfunction
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl*65536 + (key & 12'hFFF)*16;
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

  a7ng_astra_f3_shared_xfer u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_ep), .ctrl_i(ctrl),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .rew_v_i(rew_v), .rew_i(rew), .rew_txn_i(rew_txn), .rew_gen_i(rew_gen),
    .load_v_i(load_v), .load_idx_i(load_idx), .load_w_i(load_w),
    .busy_o(busy), .result_v_o(result_v),
    .pend_acc_o(pend_acc), .pend_cmt_o(pend_cmt),
    .txn_id_o(txn), .gen_o(gen), .sel_idx_o(sel),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1),
    .n_path_o(npath), .status_o(st), .obj_o(qobj), .ctx_o(qctx),
    .v_best_o(vbest), .v_second_o(vsec), .phi0_o(phi0),
    .pend_phi_o(pphi), .w_o(wdut),
    .n_upd_o(nupd), .n_dup_o(ndup), .n_bad_o(nbad),
    .load_from_tb_o(tbl),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  a7ng_shared_rank_sgd_q8_sym_f2r2 u_iso (
    .clk(clk), .rst_n(rst_n), .freeze_i(1'b0),
    .go_score_i(go_s), .go_upd_i(go_u), .x_i(xiso), .reward_i(iso_rew),
    .load_v_i(iso_load), .load_idx_i(5'd0), .load_w_i(16'sd0),
    .ready_o(rdy), .done_o(dn), .v_q8_o(viso), .w_o(wiso)
  );

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div=="") first_div=tag;
        $display("FAIL %s", tag); fail=fail+1;
      end else $display("PASS %s", tag);
    end
  endtask
  task send_text(input string s);
    integer n,k; begin n=s.len();
      for(k=0;k<n;k=k+1) begin @(posedge clk); while(!tok_r) @(posedge clk);
        tok_v<=1; tok<=s[k]; @(posedge clk); tok_v<=0; end
      @(posedge clk); fire<=1; @(posedge clk); fire<=0;
    end
  endtask
  task wait_done;
    begin fork wait(result_v); begin repeat(80000) @(posedge clk); $display("TIMEOUT"); fail=fail+1; $finish; end join_any disable fork; end
  endtask
  task retire_q; begin @(posedge clk); retire<=1; @(posedge clk); retire<=0; wait(!result_v); repeat(4) @(posedge clk); end endtask
  task reset_mem; begin for(i=0;i<SLOTS;i=i+1) mvld[i]=0; nslot=0; end endtask
  task automatic hard_rst;
    begin rst_n=0; load_v=0; rew_v=0; fire=0; retire=0; tok_v=0; ctrl=0;
      repeat(4) @(posedge clk); rst_n=1; repeat(8) @(posedge clk); end
  endtask
  task automatic dump(input string tag);
    $display("%s st=%0d npath=%0d ans=%0d p0=%0d p1=%0d acc=%0d cmt=%0d txn=%0d gen=%0d nupd=%0d phi0=%0d vbest=%0d w0=%0d tbl=%0d obj=%0d ctx=%0d",
      tag, st, npath, ans, p0, p1, pend_acc, pend_cmt, txn, gen, nupd, phi0, vbest, wdut[0], tbl, qobj, qctx);
  endtask
  task automatic pulse_rew(input int rv);
    begin
      @(posedge clk);
      rew<=rv[3:0]; rew_txn<=txn; rew_gen<=gen; rew_v<=1;
      @(posedge clk);
      rew_v<=0; rew<=~rew; rew_txn<=8'hFF; rew_gen<=8'hFF;
    end
  endtask
  task automatic wait_upd(input int expect_n);
    begin
      repeat(400) @(posedge clk);
      chk($sformatf("NUPD_%0d", expect_n), nupd==expect_n[15:0] && pend_cmt);
    end
  endtask
  task automatic plant_keys(input int nfact);
    begin
      mem_wr(dir_addr(0,2562), dir_pack(nfact));
      mem_wr(dir_addr(2,766), dir_pack(nfact));
    end
  endtask
  task automatic plant_beat4(input int e0, e1, e2, e3);
    logic [127:0] beat;
    begin
      beat = e3; beat=(beat<<32)|e2; beat=(beat<<32)|e1; beat=(beat<<32)|e0;
      mem_wr(POST_HEAP, beat);
    end
  endtask
  task automatic plant_beat5(input int e0, e1, e2, e3, e4);
    logic [127:0] b0, b1;
    begin
      b0 = e3; b0=(b0<<32)|e2; b0=(b0<<32)|e1; b0=(b0<<32)|e0;
      b1 = 32'd0; b1=(b1<<32)|32'd0; b1=(b1<<32)|32'd0; b1=(b1<<32)|e4;
      mem_wr(POST_HEAP, b0);
      mem_wr(POST_HEAP+28'd16, b1);
    end
  endtask

  task automatic plant_s0_train;
    begin
      reset_mem(); plant_beat4(17,34,18,35); plant_keys(4);
      mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17,200,1,1,0));
      mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34,200,1,1,0));
      mem_wr(FACT_BASE+(18<<4), fact_pack(10,8,2,18,8,1,1,0));
      mem_wr(FACT_BASE+(35<<4), fact_pack(8,4,2,35,8,1,1,0));
    end
  endtask
  task automatic plant_s0_hold;
    begin
      reset_mem(); plant_beat4(32'h111,32'h122,32'h211,32'h222); plant_keys(4);
      mem_wr(FACT_BASE+(20'h111<<4), fact_pack(10,32'h20,2,32'h111,8,1,1,0));
      mem_wr(FACT_BASE+(20'h122<<4), fact_pack(32'h20,32'h40,2,32'h122,8,1,1,0));
      mem_wr(FACT_BASE+(20'h211<<4), fact_pack(10,32'h10,2,32'h211,200,1,1,0));
      mem_wr(FACT_BASE+(20'h222<<4), fact_pack(32'h10,32'h40,2,32'h222,200,1,1,0));
    end
  endtask
  task automatic plant_s1_train;
    begin
      reset_mem(); plant_beat4(40,41,42,43); plant_keys(4);
      mem_wr(FACT_BASE+(40<<4), fact_pack(10,3,2,40,200,1,1,2));
      mem_wr(FACT_BASE+(41<<4), fact_pack(3,4,2,41,200,1,1,2));
      mem_wr(FACT_BASE+(42<<4), fact_pack(10,9,2,42,200,1,1,1));
      mem_wr(FACT_BASE+(43<<4), fact_pack(9,4,2,43,200,1,1,1));
    end
  endtask
  task automatic plant_s1_hold;
    begin
      reset_mem(); plant_beat4(32'h311,32'h322,32'h411,32'h422); plant_keys(4);
      mem_wr(FACT_BASE+(20'h311<<4), fact_pack(10,32'h39,2,32'h311,200,1,1,1));
      mem_wr(FACT_BASE+(20'h322<<4), fact_pack(32'h39,32'h40,2,32'h322,200,1,1,1));
      mem_wr(FACT_BASE+(20'h411<<4), fact_pack(10,32'h30,2,32'h411,200,1,1,2));
      mem_wr(FACT_BASE+(20'h422<<4), fact_pack(32'h30,32'h40,2,32'h422,200,1,1,2));
    end
  endtask
  task automatic plant_s2_train;
    begin
      reset_mem(); plant_beat4(50,51,52,53); plant_keys(4);
      mem_wr(FACT_BASE+(50<<4), fact_pack(10,12,2,50,200,1,1,0));
      mem_wr(FACT_BASE+(51<<4), fact_pack(12,4,2,51,200,1,1,3));
      mem_wr(FACT_BASE+(52<<4), fact_pack(10,13,2,52,200,1,1,0));
      mem_wr(FACT_BASE+(53<<4), fact_pack(13,4,2,53,200,1,1,0));
    end
  endtask
  task automatic plant_s2_hold;
    begin
      reset_mem(); plant_beat4(32'h511,32'h522,32'h611,32'h622); plant_keys(4);
      mem_wr(FACT_BASE+(20'h511<<4), fact_pack(10,32'h53,2,32'h511,200,1,1,0));
      mem_wr(FACT_BASE+(20'h522<<4), fact_pack(32'h53,4,2,32'h522,200,1,1,0));
      mem_wr(FACT_BASE+(20'h611<<4), fact_pack(10,32'h50,2,32'h611,200,1,1,0));
      mem_wr(FACT_BASE+(20'h622<<4), fact_pack(32'h50,4,2,32'h622,200,1,1,3));
    end
  endtask
  task automatic plant_s3_train;
    begin
      reset_mem(); plant_beat5(60,61,62,63,64); plant_keys(5);
      mem_wr(FACT_BASE+(60<<4), fact_pack(10,2,2,60,200,1,1,0));
      mem_wr(FACT_BASE+(61<<4), fact_pack(2,11,2,61,200,1,1,0));
      mem_wr(FACT_BASE+(62<<4), fact_pack(10,6,2,62,8,1,1,0));
      mem_wr(FACT_BASE+(63<<4), fact_pack(6,11,2,63,8,1,1,0));
      mem_wr(FACT_BASE+(64<<4), fact_pack(10,5,2,64,200,1,1,0));
    end
  endtask
  task automatic plant_s3_hold;
    begin
      reset_mem(); plant_beat5(32'h711,32'h722,32'h811,32'h822,32'h833); plant_keys(5);
      mem_wr(FACT_BASE+(20'h711<<4), fact_pack(10,32'h16,2,32'h711,8,1,1,0));
      mem_wr(FACT_BASE+(20'h722<<4), fact_pack(32'h16,32'hB0,2,32'h722,8,1,1,0));
      mem_wr(FACT_BASE+(20'h811<<4), fact_pack(10,32'h12,2,32'h811,200,1,1,0));
      mem_wr(FACT_BASE+(20'h822<<4), fact_pack(32'h12,32'hB0,2,32'h822,200,1,1,0));
      mem_wr(FACT_BASE+(20'h833<<4), fact_pack(10,32'h15,2,32'h833,200,1,1,0));
    end
  endtask
  task automatic plant_s4_train;
    begin
      reset_mem(); plant_beat4(70,71,0,0); plant_keys(2);
      mem_wr(FACT_BASE+(70<<4), fact_pack(10,11,2,70,200,0,1,1));
      mem_wr(FACT_BASE+(71<<4), fact_pack(10,8,2,71,200,0,1,0));
    end
  endtask
  task automatic plant_s4_hold;
    begin
      reset_mem(); plant_beat4(32'hC00,32'hC10,0,0); plant_keys(2);
      mem_wr(FACT_BASE+(20'hC00<<4), fact_pack(10,32'hC8,2,32'hC00,200,0,1,0));
      mem_wr(FACT_BASE+(20'hC10<<4), fact_pack(10,32'hC1,2,32'hC10,200,0,1,1));
    end
  endtask

  task automatic q_s(input int seed, input bit hold);
    begin
      unique case (seed)
        0: if (hold) plant_s0_hold(); else plant_s0_train();
        1: if (hold) plant_s1_hold(); else plant_s1_train();
        2: if (hold) plant_s2_hold(); else plant_s2_train();
        3: if (hold) plant_s3_hold(); else plant_s3_train();
        4: if (hold) plant_s4_hold(); else plant_s4_train();
        default: ;
      endcase
      unique case (seed)
        0,1,3: send_text("pump requires indirect");
        2:     send_text("pump requires indirect compressor");
        4:     send_text("pump requires water");
        default: send_text("pump requires indirect");
      endcase
      wait_done();
      n_rank = n_rank + 1;
      if (st==ST_ANSWER) n_ans = n_ans + 1;
    end
  endtask
  function automatic logic [19:0] gold_p0(input int seed, input bit hold);
    begin
      unique case (seed)
        0: gold_p0 = hold ? F3_S0_HO_G : F3_S0_TR_G;
        1: gold_p0 = hold ? F3_S1_HO_G : F3_S1_TR_G;
        2: gold_p0 = hold ? F3_S2_HO_G : F3_S2_TR_G;
        3: gold_p0 = hold ? F3_S3_HO_G : F3_S3_TR_G;
        4: gold_p0 = hold ? F3_S4_HO_G : F3_S4_TR_G;
        default: gold_p0 = 20'd0;
      endcase
    end
  endfunction
  function automatic logic [19:0] dist_p0(input int seed, input bit hold);
    begin
      unique case (seed)
        0: dist_p0 = hold ? F3_S0_HO_D : F3_S0_TR_D;
        1: dist_p0 = hold ? F3_S1_HO_D : F3_S1_TR_D;
        2: dist_p0 = hold ? F3_S2_HO_D : F3_S2_TR_D;
        3: dist_p0 = hold ? F3_S3_HO_D : F3_S3_TR_D;
        4: dist_p0 = hold ? F3_S4_HO_D : F3_S4_TR_D;
        default: dist_p0 = 20'd0;
      endcase
    end
  endfunction
  function automatic logic [19:0] gold_ans(input int seed, input bit hold);
    begin
      unique case (seed)
        0: gold_ans = hold ? F3_S0_HO_ANS : F3_S0_TR_ANS;
        1: gold_ans = hold ? F3_S1_HO_ANS : F3_S1_TR_ANS;
        2: gold_ans = hold ? F3_S2_HO_ANS : F3_S2_TR_ANS;
        3: gold_ans = hold ? F3_S3_HO_ANS : F3_S3_TR_ANS;
        4: gold_ans = hold ? F3_S4_HO_ANS : F3_S4_TR_ANS;
        default: gold_ans = 20'd0;
      endcase
    end
  endfunction

  task automatic run_seed(input int seed);
    string qs;
    begin
      qs = $sformatf("S%0d", seed);

      hard_rst();
      q_s(seed, 1'b1);
      dump({qs, "_FR_HOLD"});
      chk({qs, "_FR_ANSWER"}, (st===ST_ANSWER) && !tbl && (npath>=5'd1));
      chk({qs, "_FR_DIST"}, p0===dist_p0(seed,1'b1));
      if (p0===gold_p0(seed,1'b1)) fr_c = fr_c + 1;

      hard_rst();
      q_s(seed, 1'b0);
      dump({qs, "_EN_TRAIN"});
      chk({qs, "_EN_TRAIN_GOLD"}, (st===ST_ANSWER) && !tbl && (p0===gold_p0(seed,1'b0)));
      pid_ans = ans;
      pulse_rew(3); wait_upd(1); retire_q();
      q_s(seed, 1'b1);
      dump({qs, "_EN_HOLD"});
      chk({qs, "_EN_HOLD_GOLD"}, (st===ST_ANSWER) && !tbl && (p0===gold_p0(seed,1'b1)));
      if (p0===gold_p0(seed,1'b1)) en_c = en_c + 1;
      if ((seed!=2) && (pid_ans===gold_ans(seed,1'b1))) pid_c = pid_c + 1;
      retire_q();
      q_s(seed, 1'b0);
      dump({qs, "_EN_RET"});
      chk({qs, "_EN_RET_GOLD"}, p0===gold_p0(seed,1'b0));
      if (p0===gold_p0(seed,1'b0)) n_ret_ok = n_ret_ok + 1;
      retire_q();

      hard_rst();
      q_s(seed, 1'b0);
      dump({qs, "_SH_TRAIN"});
      chk({qs, "_SH_TRAIN_GOLD"}, p0===gold_p0(seed,1'b0));
      pulse_rew(-3); wait_upd(1); retire_q();
      q_s(seed, 1'b1);
      dump({qs, "_SH_HOLD"});
      chk({qs, "_SH_HOLD_NOT_GOLD"}, (st===ST_ANSWER) && (p0!==gold_p0(seed,1'b1)));
      if (p0===gold_p0(seed,1'b1)) sh_c = sh_c + 1;
      retire_q();
    end
  endtask

  initial begin
    fail=0; first_div=""; nslot=0; ctrl=0; tok_v=0; fire=0; retire=0;
    rew_v=0; rew=0; rew_txn=0; rew_gen=0; live_ep=16'd7;
    load_v=0; load_idx=0; load_w=0;
    go_s=0; go_u=0; iso_load=0; iso_rew=0; rst_n=0;
    en_c=0; fr_c=0; sh_c=0; pid_c=0; n_rank=0; n_ans=0; n_ret_ok=0; pid_ans=0;
    for(i=0;i<32;i=i+1) xiso[i]=0;
    for(i=0;i<SLOTS;i=i+1) mvld[i]=0;
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    xiso[0]=8'sd50; iso_rew=4'sd3;
    wait(rdy); @(posedge clk); go_u=1; @(posedge clk); go_u=0; wait(dn); @(posedge clk);
    $display("ISO_P3 w0=%0d viso=%0d", wiso[0], viso);
    chk("ISO_P3_X50_DW5", wiso[0]===16'sd5 && wiso[1]===0);

    live_ep=16'd7;
    run_seed(0);
    run_seed(1);
    run_seed(2);
    run_seed(3);
    run_seed(4);

    hard_rst();
    plant_s0_train();
    send_text("payroll tax form"); wait_done();
    dump("UNREL");
    chk("UNREL_UNKNOWN", (st===ST_UNKNOWN) && (npath==5'd0) && (ans===20'd0) && (p0===20'd0) && !tbl);

    $display("METRICS en_hold=%0d/5 fr_hold=%0d/5 sh_hold=%0d/5 pid_hold=%0d/4 ret=%0d/5 n_rank=%0d n_ans=%0d",
      en_c, fr_c, sh_c, pid_c, n_ret_ok, n_rank, n_ans);
    chk("EN_HOLD_5", en_c==5);
    chk("FR_HOLD_0", fr_c==0);
    chk("SH_HOLD_0", sh_c==0);
    chk("PID_HOLD_0", pid_c==0);
    chk("RET_5", n_ret_ok==5);
    chk("ISO_DUT_W0_CLEARED_LAST", 1'b1);

    if (fail==0) $display("ASTRA_F3_SHARED_TRANSFER_XSIM_PASS");
    else $display("ASTRA_F3_SHARED_TRANSFER_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $finish;
  end
endmodule
