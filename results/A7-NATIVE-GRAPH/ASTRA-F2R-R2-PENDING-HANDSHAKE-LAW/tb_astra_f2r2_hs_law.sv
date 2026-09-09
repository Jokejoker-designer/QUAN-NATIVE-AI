`timescale 1ns / 1ps
module tb_astra_f2r2_hs_law;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS=96, EPOCH=7, N=32, SHIFT=6;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  int fail, i, nslot, hi;
  string first_div;
  logic tok_v, tok_r, fire, retire, rew_v, busy, result_v, tbl;
  logic pend_acc, pend_cmt, load_v;
  logic [1:0] ctrl, sel;
  logic [7:0] tok, txn, gen, rew_txn, rew_gen, phi0;
  logic [4:0] load_idx;
  logic signed [15:0] load_w;
  logic signed [3:0] rew;
  logic [19:0] ans, p0, p1;
  logic [3:0] npath, st;
  logic signed [15:0] vbest, vsec, vpred;
  logic [15:0] nupd, ndup, nbad, nstale, noor;
  logic signed [7:0] pphi [0:31];
  logic signed [15:0] wdut [0:31], wsnap [0:31], wexp [0:31];
  logic signed [7:0] xiso [0:31], xexp [0:31];
  logic go_s, go_u, rdy, dn, iso_load;
  logic signed [15:0] viso, wiso [0:31];
  logic signed [3:0] iso_rew;

  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst;
  logic arvalid, arready, rready, rlast, rvalid;
  logic [3:0] rid; logic [127:0] rdata; logic [1:0] rresp;
  logic [27:0] mk[0:SLOTS-1]; logic [127:0] mv[0:SLOTS-1]; logic mvld[0:SLOTS-1];
  typedef enum logic { M_IDLE, M_BEAT } mst_t;
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
  function automatic logic [127:0] fact_pack(input int s,o,r,e,conf);
    fact_pack = {28'd0,conf[7:0],8'd0,4'd1,1'b0,1'b1,1'b1,1'b1,e[19:0],r[7:0],o[19:0],s[19:0]};
  endfunction
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl*65536 + (key & 12'hFFF)*16;
  endfunction
  function automatic longint rsh64(input longint v, input int s);
    longint a; begin
      a = (v<0) ? -v : v;
      a = (a + (64'sd1 <<< (s-1))) >>> s;
      rsh64 = (v<0) ? -a : a;
    end
  endfunction
  function automatic shortint sat16(input longint v);
    if (v > 32767) return 16'sd32767;
    if (v < -32768) return -16'sd32768;
    return v[15:0];
  endfunction
  function automatic shortint clamp768(input longint r);
    if (r > 768) return 16'sd768;
    if (r < -768) return -16'sd768;
    return r[15:0];
  endfunction
  function automatic shortint clamp_err(input longint e);
    if (e > 1536) return 16'sd1536;
    if (e < -1536) return -16'sd1536;
    return e[15:0];
  endfunction
  function automatic shortint score_vec;
    longint acc; integer t; begin
      acc=0; for(t=0;t<N;t=t+1) acc=acc+longint'(wsnap[t])*longint'(xexp[t]);
      score_vec = clamp768(rsh64(acc,7));
    end
  endfunction
  task automatic oracle_upd(input int rewv);
    integer t; shortint v, err; longint dw;
    begin
      v = score_vec();
      err = clamp_err(longint'(rewv)*256 - longint'(v));
      for (t=0;t<N;t=t+1) begin
        dw = rsh64(longint'(err)*longint'(xexp[t]), 7+SHIFT);
        wexp[t] = sat16(longint'(wsnap[t]) + dw);
      end
    end
  endtask

  assign arready = (mst==M_IDLE);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mst<=M_IDLE; rvalid<=0; rlast<=0; rdata<=0; rid<=0; rresp<=0; rem<=0; ra<=0;
    end else unique case (mst)
      M_IDLE: if (arvalid && arready) begin
        ra<=araddr; rem<=arlen; rid<=arid; rresp<=2'b00;
        rdata<=mem_rd(araddr); rlast<=(arlen==8'd0); rvalid<=1'b1; mst<=M_BEAT;
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

  a7ng_astra_f2r2_hs_law u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7), .ctrl_i(ctrl),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .rew_v_i(rew_v), .rew_i(rew), .rew_txn_i(rew_txn), .rew_gen_i(rew_gen),
    .load_v_i(load_v), .load_idx_i(load_idx), .load_w_i(load_w),
    .busy_o(busy), .result_v_o(result_v),
    .pend_acc_o(pend_acc), .pend_cmt_o(pend_cmt),
    .txn_id_o(txn), .gen_o(gen), .sel_idx_o(sel),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1),
    .n_path_o(npath), .status_o(st),
    .v_best_o(vbest), .v_second_o(vsec), .v_pred_o(vpred), .phi0_o(phi0),
    .pend_phi_o(pphi), .w_o(wdut),
    .n_upd_o(nupd), .n_dup_o(ndup), .n_bad_o(nbad), .n_stale_o(nstale), .n_oor_o(noor),
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
  task automatic chk_w(input string tag);
    integer t; bit ok; begin
      ok=1;
      for (t=0;t<N;t=t+1) if (wdut[t]!==wexp[t]) begin
        if (ok) $display("DIVERGE %s i=%0d got=%0d exp=%0d", tag, t, wdut[t], wexp[t]);
        ok=0;
      end
      chk(tag, ok);
    end
  endtask
  task automatic snap();
    integer t; begin
      for(t=0;t<N;t=t+1) begin wsnap[t]=wdut[t]; xexp[t]=pphi[t]; end
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
  task automatic load_w0(input shortint val);
    begin wait(!busy); @(posedge clk); load_idx<=5'd0; load_w<=val; load_v<=1;
      @(posedge clk); load_v<=0; repeat(2) @(posedge clk); end
  endtask
  task automatic pulse_rew(input int rv);
    begin
      @(posedge clk);
      rew<=rv[3:0]; rew_txn<=txn; rew_gen<=gen; rew_v<=1;
      @(posedge clk);
      rew_v<=0; rew<=~rew; rew_txn<=8'hFF; rew_gen<=8'hFF;
    end
  endtask
  task automatic plant2;
    logic [127:0] beat;
    begin
      reset_mem();
      beat = 32'd35; beat=(beat<<32)|32'd18; beat=(beat<<32)|32'd34; beat=(beat<<32)|32'd17;
      mem_wr(POST_HEAP, beat);
      mem_wr(dir_addr(0,2562), dir_pack(4));
      mem_wr(dir_addr(2,766), dir_pack(4));
      mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17,200));
      mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34,200));
      mem_wr(FACT_BASE+(18<<4), fact_pack(10,8,2,18,8));
      mem_wr(FACT_BASE+(35<<4), fact_pack(8,4,2,35,8));
    end
  endtask
  task automatic plant_shared;
    logic [127:0] beat;
    begin
      reset_mem();
      beat = 32'd0; beat=(beat<<32)|32'd36; beat=(beat<<32)|32'd34; beat=(beat<<32)|32'd17;
      mem_wr(POST_HEAP, beat);
      mem_wr(dir_addr(0,2562), dir_pack(3));
      mem_wr(dir_addr(2,766), dir_pack(3));
      mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17,200));
      mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34,200));
      mem_wr(FACT_BASE+(36<<4), fact_pack(1,7,2,36,8));
    end
  endtask
  task automatic plant4(input int hi_slot);
    logic [127:0] b0,b1; int s, mid, e0, e1, c; int mids [0:3];
    begin
      mids[0]=1; mids[1]=2; mids[2]=3; mids[3]=8;
      reset_mem();
      b0 = 32'd23; b0=(b0<<32)|32'd22; b0=(b0<<32)|32'd21; b0=(b0<<32)|32'd20;
      b1 = 32'd27; b1=(b1<<32)|32'd26; b1=(b1<<32)|32'd25; b1=(b1<<32)|32'd24;
      mem_wr(POST_HEAP, b0);
      mem_wr(POST_HEAP+28'd16, b1);
      mem_wr(dir_addr(0,2562), dir_pack(8));
      mem_wr(dir_addr(2,766), dir_pack(8));
      for (s=0;s<4;s=s+1) begin
        mid=mids[s]; e0=20+2*s; e1=21+2*s; c=(s==hi_slot)?200:8;
        mem_wr(FACT_BASE+(e0<<4), fact_pack(10,mid,2,e0,c));
        mem_wr(FACT_BASE+(e1<<4), fact_pack(mid,4,2,e1,c));
      end
    end
  endtask

  initial begin
    fail=0; first_div=""; nslot=0; ctrl=0; tok_v=0; fire=0; retire=0;
    rew_v=0; rew=0; rew_txn=0; rew_gen=0; load_v=0; load_idx=0; load_w=0;
    go_s=0; go_u=0; iso_load=0; iso_rew=0; rst_n=0;
    for(i=0;i<32;i=i+1) xiso[i]=0;
    for(i=0;i<SLOTS;i=i+1) mvld[i]=0;
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    // 1. Isolated symmetric law
    xiso[0]=8'sd50; iso_rew=4'sd3;
    wait(rdy); @(posedge clk); go_u=1; @(posedge clk); go_u=0; wait(dn); @(posedge clk);
    $display("ISO_P3 w0=%0d viso=%0d", wiso[0], viso);
    chk("ISO_P3_X50_DW5", wiso[0]===16'sd5 && wiso[1]===0);

    hard_rst();
    for(i=0;i<32;i=i+1) xiso[i]=0;
    xiso[0]=8'sd64; iso_rew=-4'sd3;
    wait(rdy); @(posedge clk); go_u=1; @(posedge clk); go_u=0; wait(dn); @(posedge clk);
    chk("ISO_M3_X64_DW6", wiso[0]===-16'sd6 && wiso[1]===0);

    // 2. Smoke two proofs, slot0, handshake one-cycle then bus invert
    hard_rst(); ctrl=0; plant2();
    send_text("pump requires indirect"); wait_done();
    $display("SMOKE npath=%0d p0=%0d p1=%0d ans=%0d sel=%0d phi0=%0d txn=%0d gen=%0d tbl=%0d",
      npath,p0,p1,ans,sel,phi0,txn,gen,tbl);
    chk("SMOKE_TWO_PROOFS", !tbl && npath>=2 && p0===20'd17 && ans===20'd4 && sel===2'd0 && phi0===8'sd50);
    snap(); oracle_upd(-3);
    pulse_rew(-3);
    repeat(250) @(posedge clk);
    $display("HS nupd=%0d cmt=%0d w0=%0d w1=%0d", nupd, pend_cmt, wdut[0], wdut[1]);
    chk("HS_LATCH_NUPD", nupd===16'd1 && pend_cmt===1'b1);
    chk_w("HS_ALL32_M3_P50");

    // 3. Descriptor mutation after decision, before commit
    hard_rst(); plant2();
    send_text("pump requires indirect"); wait_done();
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17,8));
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34,8));
    chk("MUT_PHI_FROZEN", phi0===8'sd50);
    snap(); oracle_upd(-3);
    pulse_rew(-3);
    repeat(250) @(posedge clk);
    chk_w("MUT_PRECOMMIT_USES_SNAPSHOT");
    retire_q();

    // 4. Shared proof0, different hop2/phi; low-conf wins with w0=-16
    hard_rst(); plant_shared(); load_w0(-16'sd16);
    send_text("pump requires indirect"); wait_done();
    $display("SHARE npath=%0d p0=%0d p1=%0d ans=%0d sel=%0d phi0=%0d", npath,p0,p1,ans,sel,phi0);
    chk("SHARE_P0", npath>=2 && p0===20'd17 && p1===20'd36 && ans===20'd7 && sel===2'd1 && phi0===8'sd2);
    snap(); oracle_upd(-3);
    pulse_rew(-3);
    repeat(250) @(posedge clk);
    chk_w("SHARE_REWARD_SLOT1_PHI");
    retire_q();

    // 5. Slot 2 and 3 winners
    for (hi=0; hi<4; hi=hi+1) begin
      hard_rst(); plant4(hi); load_w0(16'sd16);
      send_text("pump requires indirect"); wait_done();
      $display("SLOT%0d npath=%0d sel=%0d p0=%0d phi0=%0d ans=%0d", hi, npath, sel, p0, phi0, ans);
      chk($sformatf("SLOT%0d_WIN", hi), npath===4 && sel===hi[1:0] && phi0===8'sd50 && ans===20'd4);
      snap(); oracle_upd(-3);
      pulse_rew(-3);
      repeat(250) @(posedge clk);
      chk_w($sformatf("SLOT%0d_DW32", hi));
      retire_q();
    end

    // 6. Zero, freeze, positive
    hard_rst(); plant2();
    send_text("pump requires indirect"); wait_done();
    snap(); oracle_upd(0);
    pulse_rew(0);
    repeat(250) @(posedge clk);
    chk("ZERO_COMMIT", nupd===16'd1 && pend_cmt===1'b1);
    chk_w("ZERO_DW0");
    retire_q();

    hard_rst(); ctrl=1; plant2();
    send_text("pump requires indirect"); wait_done();
    pulse_rew(-3);
    repeat(250) @(posedge clk);
    chk("FREEZE_NO_UPD", nupd===16'd0 && pend_cmt===1'b0 && wdut[0]===0);
    retire_q();

    hard_rst(); ctrl=0; plant2();
    send_text("pump requires indirect"); wait_done();
    snap(); oracle_upd(3);
    pulse_rew(3);
    repeat(250) @(posedge clk);
    chk_w("POS_ALL32_P50");
    retire_q();

    // 7. dup / wrong / stale / oor
    hard_rst(); plant2();
    send_text("pump requires indirect"); wait_done();
    snap(); oracle_upd(-3);
    pulse_rew(-3);
    repeat(250) @(posedge clk);
    pulse_rew(-3);
    repeat(40) @(posedge clk);
    chk("DUP", nupd===16'd1 && ndup>=1);
    chk_w("DUP_NO_SECOND_DW");
    @(posedge clk); rew<=-4'sd3; rew_txn<=txn+8'd1; rew_gen<=gen; rew_v<=1;
    @(posedge clk); rew_v<=0; repeat(20) @(posedge clk);
    chk("WRONG_TXN", nbad>=1);
    @(posedge clk); rew<=-4'sd3; rew_txn<=txn; rew_gen<=gen-8'd1; rew_v<=1;
    @(posedge clk); rew_v<=0; repeat(20) @(posedge clk);
    chk("STALE_GEN", nstale>=1);
    @(posedge clk); rew<=-4'sd4; rew_txn<=txn; rew_gen<=gen; rew_v<=1;
    @(posedge clk); rew_v<=0; repeat(20) @(posedge clk);
    chk("OOR_M4", noor>=1);
    chk_w("GUARDS_NO_EXTRA_DW");
    retire_q();

    // 8. retire pending; retire during update drain
    hard_rst(); plant2();
    send_text("pump requires indirect"); wait_done();
    retire_q();
    @(posedge clk); rew<=-4'sd3; rew_txn<=8'd1; rew_gen<=8'd1; rew_v<=1;
    @(posedge clk); rew_v<=0; repeat(40) @(posedge clk);
    chk("RETIRE_PENDING_NO_UPD", nupd===16'd0 && wdut[0]===0);

    hard_rst(); plant2();
    send_text("pump requires indirect"); wait_done();
    snap(); oracle_upd(-3);
    pulse_rew(-3);
    repeat(8) @(posedge clk);
    @(posedge clk); retire<=1; @(posedge clk); retire<=0;
    wait(!busy); repeat(8) @(posedge clk);
    chk("RETIRE_DRAIN_COMMIT", nupd===16'd1);
    chk_w("RETIRE_DRAIN_FULL_W");

    // 9. ANSWER then UNREL no stale
    hard_rst(); plant2();
    send_text("pump requires indirect"); wait_done();
    chk("PRE_UNREL", st===4'd0 && npath>=2);
    retire_q();
    send_text("payroll tax form"); wait_done();
    $display("UNREL st=%0d npath=%0d ans=%0d p0=%0d", st,npath,ans,p0);
    chk("UNREL_NO_STALE", st===4'd1 && npath===0 && ans===20'd0 && p0===20'd0);

    if (fail==0) $display("ASTRA_F2R2_HS_LAW_XSIM_PASS");
    else $display("ASTRA_F2R2_HS_LAW_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $finish;
  end
endmodule
