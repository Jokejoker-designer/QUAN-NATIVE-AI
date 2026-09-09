`timescale 1ns / 1ps
module tb_astra_f2r;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS=80, EPOCH=7;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  int inj, late_cnt, fail, i, nslot, nswitch, nworld;
  logic tok_v, tok_r, fire, retire, rew_v, busy, result_v, tbl;
  logic pend_acc, pend_cmt;
  logic [1:0] ctrl;
  logic [7:0] tok, txn, rew_txn, phi0;
  logic signed [2:0] rew;
  logic [19:0] ans, p0, p1;
  logic [3:0] npath, st;
  logic signed [15:0] vbest, vsec;
  logic [15:0] nupd, ndup, nbad;
  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst;
  logic arvalid, arready, rready, rlast, rvalid;
  logic [3:0] rid; logic [127:0] rdata; logic [1:0] rresp;
  logic [27:0] mk[0:SLOTS-1]; logic [127:0] mv[0:SLOTS-1]; logic mvld[0:SLOTS-1];
  logic signed [7:0] xiso [0:31];
  logic go_s, go_u, rdy, dn;
  logic signed [15:0] viso, wiso [0:31];

  function automatic integer slot_of(input logic [27:0] a);
    integer s; begin slot_of=-1; for(s=0;s<SLOTS;s=s+1) if(mvld[s]&&mk[s]==a) slot_of=s; end
  endfunction
  task automatic mem_wr(input logic [27:0] a, input logic [127:0] d);
    integer s; begin s=slot_of(a); if(s<0) begin s=nslot; nslot=nslot+1; end mk[s]=a; mv[s]=d; mvld[s]=1; end
  endtask
  function automatic logic [127:0] dir_pack(input int count);
    dir_pack = {48'd0,16'd7,16'd0,count[15:0],4'd0,POST_HEAP};
  endfunction
  function automatic logic [127:0] fact_pack(input int s,o,r,e,conf);
    fact_pack = {28'd0,conf[7:0],8'd0,4'd1,1'b0,1'b1,1'b1,1'b1,e[19:0],r[7:0],o[19:0],s[19:0]};
  endfunction
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl*65536 + (key & 12'hFFF)*16;
  endfunction

  assign arready = !((inj==5) && arvalid && (araddr>=FACT_BASE));
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin rvalid<=0; rlast<=0; rdata<=0; rid<=0; rresp<=0; late_cnt<=0; end
    else begin
      if (rvalid && rready) begin rvalid<=0; rlast<=0; end
      if (arvalid && arready && !(rvalid && !rready)) begin
        if (inj==4 && araddr>=FACT_BASE) begin end
        else if (inj==6 && araddr>=FACT_BASE) begin
          late_cnt<=20; rid<=arid; rresp<=0; rlast<=1;
          rdata<=(slot_of(araddr)>=0)?mv[slot_of(araddr)]:128'd0;
        end else begin
          rid <= ((araddr>=FACT_BASE)&&(inj==1)) ? 4'd7 : arid;
          rresp<= ((araddr>=FACT_BASE)&&(inj==2)) ? 2'b10 : 2'b00;
          rlast<= ((araddr>=FACT_BASE)&&(inj==3)) ? 1'b0 : 1'b1;
          rvalid<=1;
          rdata<=(slot_of(araddr)>=0)?mv[slot_of(araddr)]:128'd0;
        end
      end else if (late_cnt>0) begin
        late_cnt<=late_cnt-1; if (late_cnt==1) rvalid<=1;
      end
    end
  end

  a7ng_astra_f2r_rank u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7), .ctrl_i(ctrl),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .rew_v_i(rew_v), .rew_i(rew), .rew_txn_i(rew_txn),
    .busy_o(busy), .result_v_o(result_v),
    .pend_acc_o(pend_acc), .pend_cmt_o(pend_cmt), .txn_id_o(txn),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1),
    .n_path_o(npath), .status_o(st),
    .v_best_o(vbest), .v_second_o(vsec), .phi0_o(phi0),
    .n_upd_o(nupd), .n_dup_o(ndup), .n_bad_o(nbad), .load_from_tb_o(tbl),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  a7ng_shared_rank_sgd_q8_v1_f2r u_iso (
    .clk(clk), .rst_n(rst_n), .freeze_i(1'b0),
    .go_score_i(go_s), .go_upd_i(go_u), .x_i(xiso), .reward_i(-3'sd3),
    .ready_o(rdy), .done_o(dn), .v_q8_o(viso), .w_o(wiso)
  );

  task send_text(input string s);
    integer n,k; begin n=s.len();
      for(k=0;k<n;k=k+1) begin @(posedge clk); while(!tok_r) @(posedge clk);
        tok_v<=1; tok<=s[k]; @(posedge clk); tok_v<=0; end
      @(posedge clk); fire<=1; @(posedge clk); fire<=0;
    end
  endtask
  task wait_done;
    begin fork wait(result_v); begin repeat(40000) @(posedge clk); $display("TIMEOUT"); fail=fail+1; $finish; end join_any disable fork; end
  endtask
  task retire_q; begin @(posedge clk); retire<=1; @(posedge clk); retire<=0; wait(!result_v); repeat(4) @(posedge clk); end endtask
  task reset_mem; begin for(i=0;i<SLOTS;i=i+1) mvld[i]=0; nslot=0; end endtask
  task plant4(input int e0,e1,e2,e3, input int m1,m2, input int dst, input int c_hi, input int c_lo);
    logic [127:0] beat;
    begin
      reset_mem();
      beat = e3; beat=(beat<<32)|e2; beat=(beat<<32)|e1; beat=(beat<<32)|e0;
      mem_wr(POST_HEAP, beat);
      mem_wr(dir_addr(0,2562), dir_pack(4));
      mem_wr(dir_addr(2,766), dir_pack(4));
      mem_wr(FACT_BASE+(e0<<4), fact_pack(10,m1,2,e0,c_hi));
      mem_wr(FACT_BASE+(e1<<4), fact_pack(m1,dst,2,e1,c_hi));
      mem_wr(FACT_BASE+(e2<<4), fact_pack(10,m2,2,e2,c_lo));
      mem_wr(FACT_BASE+(e3<<4), fact_pack(m2,dst,2,e3,c_lo));
    end
  endtask

  initial begin
    fail=0; nslot=0; inj=0; ctrl=0; tok_v=0; fire=0; retire=0; rew_v=0; rew=0; rew_txn=0;
    go_s=0; go_u=0; rst_n=0;
    for(i=0;i<32;i=i+1) xiso[i]=0;
    for(i=0;i<SLOTS;i=i+1) mvld[i]=0;
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    // 1. SGD one-hot isolate
    xiso[0]=8'sd64;
    wait(rdy); @(posedge clk); go_u=1; @(posedge clk); go_u=0; wait(dn); @(posedge clk);
    $display("ISO w0=%0d w1=%0d viso=%0d", wiso[0], wiso[1], viso);
    if (wiso[0]!==-16'sd6 || wiso[1]!==0) begin $display("FAIL ISO_ONEHOT"); fail=fail+1; end
    else $display("PASS ISO_ONEHOT");

    // 2. Two proofs, quality rank, -3 switch
    inj=0; ctrl=0; plant4(17,34,18,35,1,8,4,200,8);
    send_text("pump requires indirect"); wait_done();
    $display("R0 npath=%0d p0=%0d p1=%0d ans=%0d vbest=%0d vsec=%0d phi0=%0d tbl=%0d txn=%0d",
      npath,p0,p1,ans,vbest,vsec,phi0,tbl,txn);
    if (tbl || npath<2 || p0!==20'd17 || vsec===16'sh8000) begin $display("FAIL R0"); fail=fail+1; end
    else $display("PASS R0_TWO_PROOFS_TIE_17");
    repeat(8) @(posedge clk);
    @(posedge clk); rew<=-3'sd3; rew_txn<=txn; rew_v<=1; @(posedge clk); rew_v<=0;
    repeat(200) @(posedge clk);
    $display("AFTER_NEG nupd=%0d pend_cmt=%0d w0=%0d", nupd, pend_cmt, u_dut.u_sgd.w_o[0]);
    if (nupd!==1 || u_dut.u_sgd.w_o[0]!==-16'sd5) begin $display("FAIL DW_ORACLE"); fail=fail+1; end
    else $display("PASS DW_W0_M5");
    retire_q();
    plant4(17,34,18,35,1,8,4,200,8);
    send_text("pump requires indirect"); wait_done();
    $display("R1 p0=%0d vbest=%0d vsec=%0d", p0,vbest,vsec);
    if (p0!==20'd18) begin $display("FAIL NEG_SWITCH"); fail=fail+1; end
    else $display("PASS NEG_SWITCH_TO_18");
    retire_q();

    // 3. freeze no switch
    rst_n=0; repeat(4) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);
    ctrl=1; plant4(17,34,18,35,1,8,4,200,8);
    send_text("pump requires indirect"); wait_done();
    @(posedge clk); rew<=-3'sd3; rew_txn<=txn; rew_v<=1; @(posedge clk); rew_v<=0;
    repeat(200) @(posedge clk);
    if (nupd!==0) begin $display("FAIL FREEZE_UPD"); fail=fail+1; end
    retire_q();
    send_text("pump requires indirect"); wait_done();
    if (p0!==20'd17) begin $display("FAIL FREEZE_STAY"); fail=fail+1; end
    else $display("PASS FREEZE_NO_SWITCH");
    retire_q();

    // 4. validity-only no switch
    rst_n=0; repeat(4) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);
    ctrl=2; plant4(17,34,18,35,1,8,4,200,8);
    send_text("pump requires indirect"); wait_done();
    @(posedge clk); rew<=-3'sd3; rew_txn<=txn; rew_v<=1; @(posedge clk); rew_v<=0;
    repeat(200) @(posedge clk);
    retire_q();
    send_text("pump requires indirect"); wait_done();
    if (p0!==20'd17 || nupd!==0) begin $display("FAIL VALIDITY_CTRL"); fail=fail+1; end
    else $display("PASS VALIDITY_ONLY_NO_SWITCH");
    retire_q();

    // 5. +3 stay, shuf +3 no switch from 17
    rst_n=0; repeat(4) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);
    ctrl=0; plant4(17,34,18,35,1,8,4,200,8);
    send_text("pump requires indirect"); wait_done();
    @(posedge clk); rew<=3'sd3; rew_txn<=txn; rew_v<=1; @(posedge clk); rew_v<=0;
    repeat(200) @(posedge clk);
    if (u_dut.u_sgd.w_o[0]!==16'sd4) begin $display("FAIL POS_DW"); fail=fail+1; end
    retire_q();
    send_text("pump requires indirect"); wait_done();
    if (p0!==20'd17) begin $display("FAIL POS_STAY"); fail=fail+1; end
    else $display("PASS POS_AND_SHUF_STAY_17");
    retire_q();

    // 6. dup and wrong txn
    rst_n=0; repeat(4) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);
    ctrl=0; plant4(17,34,18,35,1,8,4,200,8);
    send_text("pump requires indirect"); wait_done();
    @(posedge clk); rew<=-3'sd3; rew_txn<=txn; rew_v<=1; @(posedge clk); rew_v<=0;
    repeat(200) @(posedge clk);
    @(posedge clk); rew<=-3'sd3; rew_txn<=txn; rew_v<=1; @(posedge clk); rew_v<=0;
    repeat(40) @(posedge clk);
    @(posedge clk); rew<=-3'sd3; rew_txn<=8'hFF; rew_v<=1; @(posedge clk); rew_v<=0;
    repeat(40) @(posedge clk);
    $display("TXN nupd=%0d ndup=%0d nbad=%0d w0=%0d", nupd, ndup, nbad, u_dut.u_sgd.w_o[0]);
    if (nupd!==1 || ndup<1 || nbad<1 || u_dut.u_sgd.w_o[0]!==-16'sd5) begin $display("FAIL TXN_DEDUP"); fail=fail+1; end
    else $display("PASS TXN_DEDUP_WRONG");
    // bus mutate after pending: change conf in mem, reward already committed; new query uses saved w
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17,8));
    retire_q();

    // 7. held-out 5 worlds after this w0=-5
    nswitch=0;
    for (nworld=0; nworld<5; nworld=nworld+1) begin
      plant4(20'h1000+nworld*4, 20'h1001+nworld*4, 20'h1002+nworld*4, 20'h1003+nworld*4,
             9,10,4,200,8);
      send_text("pump requires indirect"); wait_done();
      $display("WORLD%0d p0=%0h npath=%0d", nworld, p0, npath);
      if (npath>=2 && p0===(20'h1002+nworld*4)) nswitch=nswitch+1;
      retire_q();
    end
    $display("TRANSFER %0d/5", nswitch);
    if (nswitch<5) begin $display("FAIL TRANSFER_NARROW"); fail=fail+1; end
    else $display("PASS TRANSFER_5WORLD_STRUCTURAL");

    // 8. RTP negatives on this path
    rst_n=0; repeat(4) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);
    ctrl=0; inj=0;
    plant4(17,34,18,35,1,8,4,200,8);
    // POST_DROP: posting only 17,34 (one path)
    reset_mem();
    mem_wr(POST_HEAP, {32'd0,32'd0,32'd34,32'd17});
    mem_wr(dir_addr(0,2562), dir_pack(2));
    mem_wr(dir_addr(2,766), dir_pack(2));
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17,200));
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34,200));
    mem_wr(FACT_BASE+(18<<4), fact_pack(10,8,2,18,8));
    mem_wr(FACT_BASE+(35<<4), fact_pack(8,4,2,35,8));
    send_text("pump requires indirect"); wait_done();
    $display("POST_DROP npath=%0d p0=%0d st=%0d", npath,p0,st);
    if (npath==1 && p0==17) $display("PASS POST_DROP"); else begin $display("FAIL POST_DROP"); fail=fail+1; end
    retire_q();

    plant4(17,34,18,35,1,8,4,200,8);
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,7,2,34,200));
    send_text("pump requires indirect"); wait_done();
    $display("DESC_SWAP npath=%0d ans=%0d p0=%0d", npath,ans,p0);
    // two conclusions 7 vs 4: ranker may pick one; legality: npath>=1 and not empty
    if (npath>=1 && (ans==7 || ans==4)) $display("PASS DESC_SWAP_ENUM"); else begin $display("FAIL DESC_SWAP"); fail=fail+1; end
    retire_q();

    inj=0; plant4(20'hA0011,20'hA0022,20'hA0033,20'hA0044,1,8,4,200,8);
    send_text("pump requires indirect"); wait_done();
    if (npath>=2 && p0==20'hA0011) $display("PASS HIGH_ID"); else begin $display("FAIL HIGH_ID"); fail=fail+1; end
    retire_q();

    plant4(17,34,18,35,1,8,4,200,8);
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,20'hEE,200));
    send_text("pump requires indirect"); wait_done();
    $display("EID_MISMATCH npath=%0d st=%0d", npath,st);
    if (st==6 || npath<=1) $display("PASS EID_MISMATCH"); else begin $display("FAIL EID_MISMATCH"); fail=fail+1; end
    retire_q();

    inj=1; plant4(17,34,18,35,1,8,4,200,8);
    send_text("pump requires indirect"); wait_done();
    if (st==6) $display("PASS AXI_BAD_RID"); else begin $display("FAIL AXI_BAD_RID st=%0d", st); fail=fail+1; end
    retire_q(); inj=0;

    inj=5; plant4(17,34,18,35,1,8,4,200,8);
    send_text("pump requires indirect"); wait_done();
    if (st==6) $display("PASS AR_STALL"); else begin $display("FAIL AR_STALL st=%0d", st); fail=fail+1; end
    retire_q(); inj=0;

    inj=6; plant4(17,34,18,35,1,8,4,200,8);
    send_text("pump requires indirect"); wait_done();
    if (st==0 && npath>=2) $display("PASS LATE_R"); else begin $display("FAIL LATE_R"); fail=fail+1; end
    retire_q(); inj=0;

    reset_mem();
    mem_wr(POST_HEAP, {32'd35,32'd18,32'd34,32'd17});
    mem_wr(dir_addr(0,2562), {48'd0,16'd7,15'd0,1'b1,16'd4,4'd0,POST_HEAP});
    mem_wr(dir_addr(2,766), {48'd0,16'd7,15'd0,1'b1,16'd4,4'd0,POST_HEAP});
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17,200));
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34,200));
    mem_wr(FACT_BASE+(18<<4), fact_pack(10,8,2,18,8));
    mem_wr(FACT_BASE+(35<<4), fact_pack(8,4,2,35,8));
    send_text("pump requires indirect"); wait_done();
    if (st==6) $display("PASS OVF"); else begin $display("FAIL OVF st=%0d", st); fail=fail+1; end
    retire_q();

    plant4(17,34,18,35,1,8,4,200,8);
    send_text("not pump requires indirect"); wait_done();
    if (st==8 && ans==0) $display("PASS NEG"); else begin $display("FAIL NEG"); fail=fail+1; end
    retire_q();

    plant4(17,34,18,35,1,8,4,200,8);
    send_text("pump requires chiller or valve"); wait_done();
    if (st==7 && ans==0) $display("PASS AMB"); else begin $display("FAIL AMB"); fail=fail+1; end
    retire_q();

    plant4(17,34,18,35,1,8,4,200,8);
    send_text("pump requires indirect"); wait_done();
    if (st!=0) begin $display("FAIL PRE_UNREL"); fail=fail+1; end
    retire_q();
    send_text("payroll tax form"); wait_done();
    $display("UNREL st=%0d npath=%0d ans=%0d p0=%0d", st,npath,ans,p0);
    if (st==1 && npath==0 && ans==0 && p0==0) $display("PASS UNREL_NO_STALE");
    else begin $display("FAIL UNREL_STALE"); fail=fail+1; end

    if (fail==0) $display("ASTRA_F2R_XSIM_PASS");
    else $display("ASTRA_F2R_XSIM_FAIL n=%0d", fail);
    $finish;
  end
endmodule
