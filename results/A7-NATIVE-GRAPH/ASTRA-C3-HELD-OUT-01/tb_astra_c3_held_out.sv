`timescale 1ns / 1ps
// ASTRA-C3-HELD-OUT-01. PROGRAM=NO. Bag-local TB.
// 5 seeds, 4 arms, train subjects disjoint from hold. Compact TB-AXI.
// Does not self-stamp Master C3 or BOARD_PASS.
`include "tb_oracles.svh"
module tb_astra_c3_held_out;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS=96;
  localparam logic [3:0] ST_ANSWER=4'd0, ST_UNKNOWN=4'd1, ST_INCOMP=4'd6;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  int fail, i, j, nslot, q;
  string first_div;
  int en_e1, en_e2, en_rl, fr_c, sh_c, pid_ov, pid_dj, phi_neq_c, n_rank, n_ans;
  int npath4_c, uniq_ho, uniq_trw, incomp_ok;
  int pidmap [0:255];
  logic tok_v, tok_r, fire, retire, rew_v, busy, result_v, tbl;
  logic pend_acc, pend_cmt, load_v;
  logic [1:0] ctrl, sel;
  logic [7:0] tok, txn, gen, rew_txn, rew_gen, phi0, qobj, qctx, qsubj;
  logic [15:0] nhwin, nhaddr;
  logic [15:0] live_ep;
  logic [4:0] load_idx, npath;
  logic signed [15:0] load_w, wsnap [0:31];
  logic signed [3:0] rew;
  logic [19:0] ans, p0, p1;
  logic [3:0] st;
  logic signed [15:0] vbest, vsec, wdut [0:31];
  logic signed [7:0] pphi [0:31];
  logic signed [7:0] trphi [0:7][0:31];
  logic signed [7:0] hophi [0:7][0:31];
  logic [31:0] trh [0:7], hoh [0:7], w_hash [0:4];
  bit w_got [0:4];
  logic [15:0] nupd, ndup, nbad;
  logic signed [7:0] xiso [0:31];
  logic go_s, go_u, rdy, dn, iso_load;
  logic signed [15:0] viso, wiso [0:31];
  logic signed [3:0] iso_rew;

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
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl*65536 + (key & 12'hFFF)*16;
  endfunction
  function automatic logic [31:0] hash32(input logic signed [7:0] x [0:31]);
    integer k; logic [31:0] h;
    begin
      h = C3_GEN_SEED;
      for (k=0;k<32;k=k+1) h = {h[30:0], h[31]} ^ {24'd0, x[k][7:0]};
      hash32 = h;
    end
  endfunction
  function automatic string qstr(input int w);
    begin
      unique case (w)
        0: qstr = "pump requires indirect";
        1: qstr = "valve requires indirect";
        2: qstr = "chiller requires indirect";
        3: qstr = "ahu connects indirect";
        4: qstr = "tower requires indirect";
        default: qstr = "pump requires indirect";
      endcase
    end
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

  a7ng_astra_c3_held_out u_dut (
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
    .subj_o(qsubj), .n_host_winner_o(nhwin), .n_host_addr_o(nhaddr),
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
  task automatic reset_mem; begin for(i=0;i<SLOTS;i=i+1) mvld[i]=0; nslot=0; end endtask
  task automatic hard_rst;
    begin rst_n=0; load_v=0; rew_v=0; fire=0; retire=0; tok_v=0; ctrl=0;
      repeat(4) @(posedge clk); rst_n=1; repeat(8) @(posedge clk); end
  endtask
  task automatic dump(input string tag);
    $display("%s st=%0d npath=%0d ans=%0d p0=%0d p1=%0d acc=%0d cmt=%0d txn=%0d gen=%0d nupd=%0d phi0=%0d vbest=%0d w0=%0d tbl=%0d obj=%0d ctx=%0d",
      tag, st, npath, ans, p0, p1, pend_acc, pend_cmt, txn, gen, nupd, phi0, vbest, wdut[0], tbl, qobj, qctx);
  endtask
  task automatic dump_phi(input string tag);
    integer k; logic [31:0] h;
    begin
      h = hash32(pphi);
      $write("%s_PHI32", tag);
      for (k=0;k<32;k=k+1) $write(" %0d", pphi[k]);
      $display(" HASH=%08h", h);
    end
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
  task automatic plant_index(input int nfact, input int k0, input int k1, input int k2);
    begin
      mem_wr(dir_addr(0,k0), dir_pack(nfact));
      mem_wr(dir_addr(1,k1), dir_pack(nfact));
      mem_wr(dir_addr(2,k2), dir_pack(nfact));
    end
  endtask
  task automatic plant_post8(
      input int e0, input int e1, input int e2, input int e3,
      input int e4, input int e5, input int e6, input int e7);
    logic [127:0] b0, b1;
    begin
      b0 = e3; b0=(b0<<32)|e2; b0=(b0<<32)|e1; b0=(b0<<32)|e0;
      b1 = e7; b1=(b1<<32)|e6; b1=(b1<<32)|e5; b1=(b1<<32)|e4;
      mem_wr(POST_HEAP, b0);
      mem_wr(POST_HEAP+28'd16, b1);
    end
  endtask
  task automatic plant_post10(
      input int e0, input int e1, input int e2, input int e3,
      input int e4, input int e5, input int e6, input int e7,
      input int e8, input int e9);
    logic [127:0] b0, b1, b2;
    begin
      b0 = e3; b0=(b0<<32)|e2; b0=(b0<<32)|e1; b0=(b0<<32)|e0;
      b1 = e7; b1=(b1<<32)|e6; b1=(b1<<32)|e5; b1=(b1<<32)|e4;
      b2 = 0; b2=(b2<<32)|0; b2=(b2<<32)|e9; b2=(b2<<32)|e8;
      mem_wr(POST_HEAP, b0);
      mem_wr(POST_HEAP+28'd16, b1);
      mem_wr(POST_HEAP+28'd32, b2);
    end
  endtask
  task automatic wr_f(input int e, s, o, r, conf, trans, pol, fctx);
    mem_wr(FACT_BASE+(e<<4), fact_pack(s,o,r,e,conf,trans,pol,fctx));
  endtask

  // kind: 0 train enabled, 1 hold enabled/frozen, 2 shuffle train, 3 shuffle hold
  task automatic plant_q(input int qi, input int kind);
    int w, subj, rel, k0, k1, k2;
    int g0, g1, d0, d1, s0, s1, pf0, pf1;
    int gmid, dmid, gdst, ddst, pmid, pdst;
    int cx1g, cx2g, cx1d, cx2d, cfg, cfd;
    bit hold, shuf, gold_has_f, dist_has_f;
    begin
      hold = (kind==1) || (kind==3);
      shuf = (kind==2) || (kind==3);
      w = hold ? C3_HO_W[qi] : C3_TR_W[qi];
      subj = C3_W_SUBJ[w]; rel = C3_W_REL[w];
      k0 = C3_W_K0[w]; k1 = C3_W_K1[w]; k2 = C3_W_K2[w];
      gold_has_f = !shuf;
      dist_has_f = shuf;
      if (kind==0) begin
        g0=C3_TR_G0[qi]; g1=g0+1; d0=g0+2; d1=g0+3;
      end else if (kind==1) begin
        d0=C3_HO_D0[qi]; d1=d0+1; g0=C3_HO_G0[qi]; g1=g0+1;
      end else if (kind==2) begin
        d0=C3_SH_D0[qi]; d1=d0+1; g0=d0+2; g1=d0+3;
      end else begin
        g0=C3_SHH_G0[qi]; g1=g0+1; d0=C3_SHH_D0[qi]; d1=d0+1;
      end
      gmid=32'h30; dmid=32'h38+qi;
      if (kind==1) gdst = C3_HO_GDST[qi];
      else gdst = C3_SHARED_DST;
      ddst = 32'h90+qi;
      if (hold) begin cfg=C3_HO_CONF_Q[qi]; cfd=cfg; end
      else begin cfg=C3_TR_CONF_W[w]; cfd=cfg; end
      if (gold_has_f) begin
        if (hold) begin cx1g=C3_HO_CX1[qi]; cx2g=C3_HO_CX2[qi]; end
        else begin cx1g=C3_TR_CX1; cx2g=C3_TR_CX2; end
      end else begin cx1g=0; cx2g=0; end
      if (dist_has_f) begin
        if (hold) begin cx1d=C3_HO_CX1[qi]; cx2d=C3_HO_CX2[qi]; end
        else begin cx1d=C3_TR_CX1; cx2d=C3_TR_CX2; end
      end else begin cx1d=0; cx2d=0; end
      s0=32'h200+w*2; s1=32'h201+w*2;
      pf0=32'h300+w*2; pf1=32'h301+w*2;
      pmid=32'hA0+w*2; pdst=32'hB0+w*2;
      reset_mem();
      plant_post8(g0,g1,d0,d1,s0,s1,pf0,pf1);
      plant_index(8, k0, k1, k2);
      wr_f(g0, subj, gmid, rel, cfg, 1, 1, cx1g);
      wr_f(g1, gmid, gdst, rel, cfg, 1, 1, cx2g);
      wr_f(d0, subj, dmid, rel, cfd, 1, 1, cx1d);
      wr_f(d1, dmid, ddst, rel, cfd, 1, 1, cx2d);
      wr_f(s0, subj, C3_SHARED_MID, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(s1, C3_SHARED_MID, C3_SHARED_BG_DST, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf0, subj, pmid, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf1, pmid, pdst, rel, C3_EXTRA_CONF, 1, 1, 0);
    end
  endtask

  task automatic plant_incomp5;
    int w, subj, rel, k0, k1, k2;
    int g0,g1,d0,d1,s0,s1,pf0,pf1,x0,x1;
    begin
      w=0; subj=C3_W_SUBJ[0]; rel=C3_W_REL[0];
      k0=C3_W_K0[0]; k1=C3_W_K1[0]; k2=C3_W_K2[0];
      g0=16; g1=17; d0=18; d1=19;
      s0=32'h200; s1=32'h201; pf0=32'h300; pf1=32'h301;
      x0=32'h400; x1=32'h401;
      reset_mem();
      plant_post10(g0,g1,d0,d1,s0,s1,pf0,pf1,x0,x1);
      plant_index(10, k0, k1, k2);
      wr_f(g0, subj, 32'h30, rel, 200, 1, 1, 1);
      wr_f(g1, 32'h30, C3_SHARED_DST, rel, 200, 1, 1, 0);
      wr_f(d0, subj, 32'h38, rel, 200, 1, 1, 0);
      wr_f(d1, 32'h38, 32'h90, rel, 200, 1, 1, 0);
      wr_f(s0, subj, C3_SHARED_MID, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(s1, C3_SHARED_MID, C3_SHARED_BG_DST, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf0, subj, 32'hA0, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf1, 32'hA0, 32'hB0, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(x0, subj, 32'h58, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(x1, 32'h58, 32'h68, rel, C3_EXTRA_CONF, 1, 1, 0);
    end
  endtask

  task automatic q_s(input int qi, input int kind);
    int w; bit hold;
    begin
      hold = (kind==1) || (kind==3);
      w = hold ? C3_HO_W[qi] : C3_TR_W[qi];
      plant_q(qi, kind);
      send_text(qstr(w));
      wait_done();
      n_rank = n_rank + 1;
      if (st==ST_ANSWER) n_ans = n_ans + 1;
      if (npath==5'd4) npath4_c = npath4_c + 1;
      else chk($sformatf("NPATH4_K%0d_Q%0d", kind, qi), 1'b0);
    end
  endtask

  function automatic bit phi_same_q(input int qi);
    integer k; begin
      phi_same_q = 1'b1;
      for (k=0;k<32;k=k+1) if (trphi[qi][k] !== hophi[qi][k]) phi_same_q = 1'b0;
    end
  endfunction
  task automatic snap_w;
    integer k; begin for (k=0;k<32;k=k+1) wsnap[k]=wdut[k]; end
  endtask
  task automatic load_w_snap;
    integer k; begin
      for (k=0;k<32;k=k+1) begin
        @(posedge clk);
        load_idx <= k[4:0]; load_w <= wsnap[k]; load_v <= 1'b1;
      end
      @(posedge clk); load_v <= 1'b0; load_idx <= 5'd0; load_w <= 16'sd0;
      repeat(4) @(posedge clk);
    end
  endtask
  function automatic bit pid_picks_hold(input int qi);
    int pg, pd; begin
      pg = pidmap[C3_HO_GDST[qi][7:0]];
      pd = pidmap[C3_HO_DDST[qi][7:0]];
      pid_picks_hold = (pg > pd) || ((pg==pd) && (C3_HO_G0[qi] < C3_HO_D0[qi]));
    end
  endfunction

  initial begin
    int seed, qa, qb, qc, qd, acc_a, acc_b, acc_c, acc_d, pid_hit;
    int sum_a, sum_b, sum_c, sum_d, gain_pp, pair_pos, host_bad, dj_fail;
    int tr_seen [0:255];
    int ho_seen [0:255];
    fail=0; first_div=""; nslot=0; ctrl=0; tok_v=0; fire=0; retire=0;
    rew_v=0; rew=0; rew_txn=0; rew_gen=0; live_ep=16'd7;
    load_v=0; load_idx=0; load_w=0;
    go_s=0; go_u=0; iso_load=0; iso_rew=0; rst_n=0;
    n_rank=0; n_ans=0; npath4_c=0;
    sum_a=0; sum_b=0; sum_c=0; sum_d=0; pair_pos=0; host_bad=0; dj_fail=0;
    for(i=0;i<32;i=i+1) begin xiso[i]=0; wsnap[i]=0; end
    for(i=0;i<256;i=i+1) begin pidmap[i]=0; tr_seen[i]=0; ho_seen[i]=0; end
    for(i=0;i<SLOTS;i=i+1) mvld[i]=0;
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    $display("C3_GEN seed=%08h N_SEED=%0d N_TRAIN=%0d N_HOLD=%0d TR_W=0,1,2 HO_W=3,4 DISJOINT=1 PROGRAM=NO",
      C3_GEN_SEED, C3_N_SEED, C3_N_Q, C3_N_Q);

    for (i=0;i<8;i=i+1) tr_seen[C3_W_SUBJ[C3_TR_W[i]]] = 1;
    for (i=0;i<8;i=i+1) ho_seen[C3_W_SUBJ[C3_HO_W[i]]] = 1;
    for (i=0;i<256;i=i+1) if (tr_seen[i] && ho_seen[i]) dj_fail = dj_fail + 1;
    if (dj_fail==0) $display("CLASS_entities_disjoint HIT train={10,11,1} hold={6,9}");
    else $display("CLASS_entities_disjoint MISS overlap=%0d", dj_fail);
    chk("ENTITIES_DISJOINT_ORACLE", dj_fail==0);

    xiso[0]=8'sd50; iso_rew=4'sd3;
    wait(rdy); @(posedge clk); go_u=1; @(posedge clk); go_u=0; wait(dn); @(posedge clk);
    $display("ISO_P3 w0=%0d viso=%0d", wiso[0], viso);
    chk("ISO_P3_X50_DW5", wiso[0]===16'sd5 && wiso[1]===0);

    for (seed=0; seed<C3_N_SEED; seed=seed+1) begin
      live_ep = 16'd7 + seed[15:0];
      $display("C3_SEED_BEGIN s=%0d live_ep=%0d", seed, live_ep);

      // Arm B frozen / no-update
      hard_rst(); ctrl=2'd1;
      acc_b=0;
      for (q=0;q<8;q=q+1) begin
        q_s(q, 1);
        dump($sformatf("B_S%0d_Q%0d", seed, q));
        chk($sformatf("B_S%0d_Q%0d_ANSWER", seed, q), (st===ST_ANSWER) && !tbl);
        if (p0===C3_HO_G0[q][19:0]) acc_b = acc_b + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      $display("CLASS_arm_B_frozen HIT seed=%0d acc=%0d/8 ctrl=1 freeze_i=1", seed, acc_b);
      sum_b = sum_b + acc_b;

      // Arm A learner
      hard_rst(); ctrl=2'd0;
      acc_a=0;
      for (q=0;q<8;q=q+1) begin
        q_s(q, 0);
        dump($sformatf("A_TR_S%0d_Q%0d", seed, q));
        pulse_rew(3); wait_upd(q+1); retire_q();
      end
      for (q=0;q<8;q=q+1) begin
        q_s(q, 1);
        dump($sformatf("A_HO_S%0d_Q%0d", seed, q));
        chk($sformatf("A_S%0d_Q%0d_ANSWER", seed, q), (st===ST_ANSWER) && !tbl);
        if (p0===C3_HO_G0[q][19:0]) acc_a = acc_a + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        if (q==7) snap_w();
        retire_q();
      end
      $display("CLASS_arm_A_learner HIT seed=%0d acc=%0d/8 nupd=%0d", seed, acc_a, nupd);
      sum_a = sum_a + acc_a;
      if (acc_a > acc_b) pair_pos = pair_pos + 1;

      // Arm C shuffled reward
      hard_rst(); ctrl=2'd0;
      acc_c=0;
      for (q=0;q<8;q=q+1) begin
        q_s(q, 2);
        pulse_rew(3); wait_upd(q+1); retire_q();
      end
      for (q=0;q<8;q=q+1) begin
        q_s(q, 3);
        dump($sformatf("C_HO_S%0d_Q%0d", seed, q));
        if (p0===C3_SHH_G0[q][19:0]) acc_c = acc_c + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      $display("CLASS_arm_C_shuffled HIT seed=%0d acc=%0d/8", seed, acc_c);
      sum_c = sum_c + acc_c;

      // Arm D per-ID prior from DUT answers on train
      hard_rst(); ctrl=2'd0;
      for(i=0;i<256;i=i+1) pidmap[i]=0;
      acc_d=0; pid_hit=0;
      for (q=0;q<8;q=q+1) begin
        q_s(q, 0);
        if (ans[19:8]==12'd0) pidmap[ans[7:0]] = pidmap[ans[7:0]] + 3;
        pulse_rew(3); wait_upd(q+1); retire_q();
      end
      for (q=0;q<8;q=q+1) begin
        q_s(q, 1);
        dump($sformatf("D_HO_S%0d_Q%0d", seed, q));
        if (pid_picks_hold(q)) pid_hit = pid_hit + 1;
        if (p0===C3_HO_G0[q][19:0]) acc_d = acc_d + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      $display("CLASS_arm_D_perid HIT seed=%0d dut_gold=%0d/8 pid_pick_gold=%0d/8", seed, acc_d, pid_hit);
      sum_d = sum_d + pid_hit;

      qa = acc_a; qb = acc_b; qc = acc_c; qd = pid_hit;
      gain_pp = (qa - qb) * 100 / 8;
      $display("C3_SEED_GAIN s=%0d A=%0d B=%0d C=%0d Dpid=%0d gain_pp=%0d", seed, qa, qb, qc, qd, gain_pp);
    end

    gain_pp = (sum_a - sum_b) * 100 / (8*C3_N_SEED);
    $display("C3_SUM A=%0d/%0d B=%0d C=%0d Dpid=%0d gain_pp=%0d pair_pos=%0d/%0d host_bad=%0d",
      sum_a, 8*C3_N_SEED, sum_b, sum_c, sum_d, gain_pp, pair_pos, C3_N_SEED, host_bad);
    if (gain_pp >= 10) $display("CLASS_gain_A_over_B HIT gain_pp=%0d", gain_pp);
    else $display("CLASS_gain_A_over_B MISS gain_pp=%0d", gain_pp);
    if (host_bad==0) $display("CLASS_host_winner_zero HIT");
    else $display("CLASS_host_winner_zero MISS n=%0d", host_bad);
    chk("HOST_WINNER_ADDR_WEIGHT_ZERO", host_bad==0);
    chk("PAIR_A_GT_B_SEEDS", pair_pos==C3_N_SEED);
    chk("A_GT_SHUFFLE", sum_a > sum_c);

    if (fail==0) $display("ASTRA_C3_HELD_OUT_XSIM_PASS");
    else $display("ASTRA_C3_HELD_OUT_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C3_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO quality=TB_AXI_COMPACT_5SEED");
    $finish;
  end
endmodule
