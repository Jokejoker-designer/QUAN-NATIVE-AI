`timescale 1ns / 1ps
// ASTRA-C3-HELD-OUT-RELOAD-01. PROGRAM=NO. Bag-local TB.
// One unknown: retention after C2 persist_clr + reload. Does not edit KEEP.
// C2 journals w0 only; w[1:31] TB-restored (quality bound in PREREG).
`include "tb_oracles.svh"
`include "a7ng_astra_c2_persist_commit.svh"
module tb_astra_c3_held_out_reload;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam logic [3:0] ST_ANSWER=4'd0;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  int fail, i, nslot, q;
  string first_div;
  int n_rank, n_ans, npath4_c, host_bad, dj_fail;
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
  logic [15:0] nupd, ndup, nbad;
  logic signed [7:0] xiso [0:31];
  logic go_s, go_u, rdy, dn, iso_load;
  logic signed [15:0] viso, wiso [0:31];
  logic signed [3:0] iso_rew;

  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst;
  logic arvalid, arready, rready, rlast, rvalid;
  logic [3:0] rid; logic [127:0] rdata; logic [1:0] rresp;
  logic [27:0] mk[0:95]; logic [127:0] mv[0:95]; logic mvld[0:95];
  typedef enum logic [1:0] { M_IDLE, M_BEAT } mst_t;
  mst_t mst;
  logic [7:0] rem; logic [27:0] ra;

  logic persist_clr, c2_reload, c2_retire, upd_v, upd_r, lk_go, lk_hit, c2_busy;
  logic [3:0] c2_phase, c2_fail;
  logic [19:0] us, ur, uo, uc;
  logic [7:0] ug, ut, usch;
  logic signed [3:0] urew;
  logic signed [15:0] live_w0, p_w0;
  logic p_valid;
  logic [19:0] ps, pr, po, pc;
  logic [7:0] pg, pt, psch;
  logic [15:0] c2_nupd, c2_ndup, c2_nstale, c2_nsch, c2_nfalse;
  logic [3:0] c2_awid, c2_arid, c2_bid, c2_rid;
  logic [27:0] c2_awaddr, c2_araddr, last_aw;
  logic [7:0] c2_awlen, c2_arlen;
  logic [2:0] c2_awsize, c2_arsize;
  logic [1:0] c2_awburst, c2_arburst, c2_bresp, c2_rresp;
  logic c2_awvalid, c2_awready, c2_wvalid, c2_wready, c2_wlast, c2_bvalid, c2_bready;
  logic c2_arvalid, c2_arready, c2_rvalid, c2_rready, c2_rlast;
  logic [127:0] c2_wdata, c2_rdata;
  logic [15:0] c2_wstrb;
  logic [127:0] jmem;
  logic jvalid, saw_base;
  typedef enum logic [2:0] { MX_IDLE, MX_W, MX_B, MX_AR, MX_R } mx_t;
  mx_t mx;
  int c2g, step, drop_pp, max_drop, sum_pre, sum_post, acc_pre, acc_post;
  logic signed [15:0] remain, delta;

  function automatic integer slot_of(input logic [27:0] a);
    integer s; begin slot_of=-1; for(s=0;s<96;s=s+1) if(mvld[s]&&mk[s]==a) slot_of=s; end
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

  assign c2_awready = (mx == MX_IDLE);
  assign c2_wready  = (mx == MX_W);
  assign c2_arready = (mx == MX_IDLE);
  assign c2_bid = 4'd1;
  assign c2_rid = 4'd2;
  assign c2_bresp = 2'b00;
  assign c2_rresp = 2'b00;
  assign c2_rlast = 1'b1;
  assign c2_rdata = jmem;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mx <= MX_IDLE;
      c2_bvalid <= 1'b0;
      c2_rvalid <= 1'b0;
    end else unique case (mx)
      MX_IDLE: begin
        c2_bvalid <= 1'b0;
        c2_rvalid <= 1'b0;
        if (c2_awvalid && c2_awready) mx <= MX_W;
        else if (c2_arvalid && c2_arready) begin
          c2_rvalid <= 1'b1;
          mx <= MX_R;
        end
      end
      MX_W: if (c2_wvalid && c2_wready) begin
        c2_bvalid <= 1'b1;
        mx <= MX_B;
      end
      MX_B: if (c2_bvalid && c2_bready) begin
        c2_bvalid <= 1'b0;
        mx <= MX_IDLE;
      end
      MX_R: if (c2_rvalid && c2_rready) begin
        c2_rvalid <= 1'b0;
        mx <= MX_IDLE;
      end
      default: mx <= MX_IDLE;
    endcase
  end

  always_ff @(posedge clk) begin
    if (mx == MX_W && c2_wvalid && c2_wready) begin
      jmem <= c2_wdata;
      jvalid <= 1'b1;
    end
    if (c2_awvalid && c2_awready) begin
      last_aw <= c2_awaddr;
      if (c2_awaddr == A7NG_C2_PERSIST_BASE) saw_base <= 1'b1;
    end
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

  a7ng_astra_c2_persist_commit u_c2 (
    .clk(clk), .rst_n(rst_n),
    .persist_clr_i(persist_clr), .reload_i(c2_reload), .retire_i(c2_retire),
    .upd_valid_i(upd_v), .upd_ready_o(upd_r),
    .upd_subj_i(us), .upd_rel_i(ur), .upd_obj_i(uo), .upd_ctx_i(uc),
    .upd_gen_i(ug), .upd_txn_i(ut), .upd_schema_i(usch), .upd_rew_i(urew),
    .lk_go_i(lk_go), .lk_subj_i(20'd0), .lk_rel_i(20'd0), .lk_obj_i(20'd0), .lk_ctx_i(20'd0),
    .lk_hit_o(lk_hit),
    .busy_o(c2_busy), .phase_o(c2_phase), .fail_code_o(c2_fail),
    .live_w0_o(live_w0),
    .persist_valid_o(p_valid),
    .persist_subj_o(ps), .persist_rel_o(pr), .persist_obj_o(po), .persist_ctx_o(pc),
    .persist_gen_o(pg), .persist_txn_o(pt), .persist_schema_o(psch),
    .persist_w0_o(p_w0),
    .n_upd_o(c2_nupd), .n_dup_o(c2_ndup), .n_stale_o(c2_nstale), .n_schema_o(c2_nsch),
    .n_false_o(c2_nfalse),
    .m_axi_awid(c2_awid), .m_axi_awaddr(c2_awaddr), .m_axi_awlen(c2_awlen),
    .m_axi_awsize(c2_awsize), .m_axi_awburst(c2_awburst),
    .m_axi_awvalid(c2_awvalid), .m_axi_awready(c2_awready),
    .m_axi_wdata(c2_wdata), .m_axi_wstrb(c2_wstrb), .m_axi_wlast(c2_wlast),
    .m_axi_wvalid(c2_wvalid), .m_axi_wready(c2_wready),
    .m_axi_bid(c2_bid), .m_axi_bresp(c2_bresp), .m_axi_bvalid(c2_bvalid),
    .m_axi_bready(c2_bready),
    .m_axi_arid(c2_arid), .m_axi_araddr(c2_araddr), .m_axi_arlen(c2_arlen),
    .m_axi_arsize(c2_arsize), .m_axi_arburst(c2_arburst),
    .m_axi_arvalid(c2_arvalid), .m_axi_arready(c2_arready),
    .m_axi_rid(c2_rid), .m_axi_rdata(c2_rdata), .m_axi_rresp(c2_rresp),
    .m_axi_rlast(c2_rlast), .m_axi_rvalid(c2_rvalid), .m_axi_rready(c2_rready)
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
  task automatic reset_mem; begin for(i=0;i<96;i=i+1) mvld[i]=0; nslot=0; end endtask
  task automatic hard_rst;
    begin rst_n=0; load_v=0; rew_v=0; fire=0; retire=0; tok_v=0; ctrl=0;
      persist_clr=0; c2_reload=0; c2_retire=0; upd_v=0;
      repeat(4) @(posedge clk); rst_n=1; repeat(8) @(posedge clk); end
  endtask
  task automatic dump(input string tag);
    $display("%s st=%0d npath=%0d ans=%0d p0=%0d acc=%0d cmt=%0d nupd=%0d vbest=%0d w0=%0d tbl=%0d",
      tag, st, npath, ans, p0, pend_acc, pend_cmt, nupd, vbest, wdut[0], tbl);
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
  task automatic wr_f(input int e, s, o, r, conf, trans, pol, fctx);
    mem_wr(FACT_BASE+(e<<4), fact_pack(s,o,r,e,conf,trans,pol,fctx));
  endtask

  task automatic plant_q(input int qi, input int kind);
    int w, subj, rel, k0, k1, k2;
    int g0, g1, d0, d1, s0, s1, pf0, pf1;
    int gmid, dmid, gdst, ddst;
    int cx1g, cx2g, cfg, cfd;
    bit hold;
    begin
      hold = (kind==1);
      w = hold ? C3_HO_W[qi] : C3_TR_W[qi];
      subj = C3_W_SUBJ[w]; rel = C3_W_REL[w];
      k0 = C3_W_K0[w]; k1 = C3_W_K1[w]; k2 = C3_W_K2[w];
      if (kind==0) begin
        g0=C3_TR_G0[qi]; g1=g0+1; d0=g0+2; d1=g0+3;
      end else begin
        d0=C3_HO_D0[qi]; d1=d0+1; g0=C3_HO_G0[qi]; g1=g0+1;
      end
      gmid=32'h30; dmid=32'h38+qi;
      if (kind==1) gdst = C3_HO_GDST[qi];
      else gdst = C3_SHARED_DST;
      ddst = 32'h90+qi;
      if (hold) begin cfg=C3_HO_CONF_Q[qi]; cfd=cfg; cx1g=C3_HO_CX1[qi]; cx2g=C3_HO_CX2[qi]; end
      else begin cfg=C3_TR_CONF_W[w]; cfd=cfg; cx1g=C3_TR_CX1; cx2g=C3_TR_CX2; end
      s0=32'h200+w*2; s1=32'h201+w*2;
      pf0=32'h300+w*2; pf1=32'h301+w*2;
      reset_mem();
      plant_post8(g0,g1,d0,d1,s0,s1,pf0,pf1);
      plant_index(8, k0, k1, k2);
      wr_f(g0, subj, gmid, rel, cfg, 1, 1, cx1g);
      wr_f(g1, gmid, gdst, rel, cfg, 1, 1, cx2g);
      wr_f(d0, subj, dmid, rel, cfd, 1, 1, 0);
      wr_f(d1, dmid, ddst, rel, cfd, 1, 1, 0);
      wr_f(s0, subj, C3_SHARED_MID, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(s1, C3_SHARED_MID, C3_SHARED_BG_DST, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf0, subj, 32'hA0+w*2, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf1, 32'hA0+w*2, 32'hB0+w*2, rel, C3_EXTRA_CONF, 1, 1, 0);
    end
  endtask

  task automatic q_s(input int qi, input int kind);
    int w; bit hold;
    begin
      hold = (kind==1);
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

  task automatic snap_w;
    integer k; begin for (k=0;k<32;k=k+1) wsnap[k]=wdut[k]; end
  endtask
  task automatic load_w_from_c2;
    integer k; begin
      for (k=0;k<32;k=k+1) begin
        @(posedge clk);
        load_idx <= k[4:0];
        load_w <= (k==0) ? p_w0 : wsnap[k];
        load_v <= 1'b1;
      end
      @(posedge clk); load_v <= 1'b0; load_idx <= 5'd0; load_w <= 16'sd0;
      repeat(4) @(posedge clk);
    end
  endtask

  task automatic wait_c2_phase(input logic [3:0] want, input int lim);
    begin
      c2g = 0;
      if (c2_phase != want) begin
        while ((c2_phase != want) && (c2g < lim)) begin
          @(posedge clk);
          c2g = c2g + 1;
        end
      end
      if (c2_phase != want)
        chk($sformatf("TO_PHASE_%0d", want), 1'b0);
    end
  endtask
  task automatic pulse_upd;
    begin
      c2g = 0;
      while (!upd_r && c2g < 4000) begin @(posedge clk); c2g = c2g + 1; end
      if (!upd_r) chk("NO_UPD_READY", 1'b0);
      @(negedge clk);
      upd_v = 1'b1;
      @(posedge clk);
      @(negedge clk);
      upd_v = 1'b0;
    end
  endtask
  task automatic pulse_c2_retire;
    begin
      @(negedge clk); c2_retire = 1'b1;
      @(posedge clk);
      @(negedge clk); c2_retire = 1'b0;
      repeat(2) @(posedge clk);
    end
  endtask
  task automatic pulse_clr;
    begin
      @(posedge clk); persist_clr = 1'b1;
      @(posedge clk); persist_clr = 1'b0;
      repeat(2) @(posedge clk);
    end
  endtask
  task automatic c2_commit_one(input int seed_i, input int step_i, input logic signed [3:0] dw);
    begin
      us = 20'd1000 + seed_i[19:0]*20'd64 + step_i[19:0];
      ur = 20'd7;
      uo = 20'd2000 + seed_i[19:0]*20'd64 + step_i[19:0];
      uc = 20'd0;
      ug = 8'd1;
      ut = 8'd1 + step_i[7:0];
      usch = A7NG_C2_SCHEMA_VER;
      urew = dw;
      pulse_upd;
      wait_c2_phase(A7NG_C2_PH_PERSISTED, 400);
      chk($sformatf("C2_AW_%0d_%0d", seed_i, step_i), last_aw == A7NG_C2_PERSIST_BASE);
      pulse_c2_retire;
    end
  endtask
  task automatic c2_drive_to(input int seed_i, input logic signed [15:0] target);
    begin
      step = 0;
      remain = target - live_w0;
      if (remain == 16'sd0) begin
        c2_commit_one(seed_i, step, 4'sd0);
      end else begin
        while ((remain != 16'sd0) && (step < 48)) begin
          if (remain > 16'sd3) delta = 16'sd3;
          else if (remain < -16'sd3) delta = -16'sd3;
          else delta = remain;
          c2_commit_one(seed_i, step, delta[3:0]);
          remain = target - live_w0;
          step = step + 1;
        end
      end
      chk($sformatf("C2_LIVE_EQ_TARGET_S%0d", seed_i), live_w0 === target && p_w0 === target && jvalid);
      $display("C2_DRIVE s=%0d target=%0d live=%0d p_w0=%0d steps=%0d aw=%h",
        seed_i, target, live_w0, p_w0, step, last_aw);
    end
  endtask

  initial begin
    int seed;
    int tr_seen [0:255];
    int ho_seen [0:255];
    fail=0; first_div=""; nslot=0; ctrl=0; tok_v=0; fire=0; retire=0;
    rew_v=0; rew=0; rew_txn=0; rew_gen=0; live_ep=16'd7;
    load_v=0; load_idx=0; load_w=0;
    go_s=0; go_u=0; iso_load=0; iso_rew=0; rst_n=0;
    persist_clr=0; c2_reload=0; c2_retire=0; upd_v=0; lk_go=0;
    us=0; ur=0; uo=0; uc=0; ug=0; ut=0; usch=0; urew=0;
    n_rank=0; n_ans=0; npath4_c=0; host_bad=0; dj_fail=0;
    sum_pre=0; sum_post=0; max_drop=0;
    for(i=0;i<32;i=i+1) begin xiso[i]=0; wsnap[i]=0; end
    for(i=0;i<256;i=i+1) begin tr_seen[i]=0; ho_seen[i]=0; end
    for(i=0;i<96;i=i+1) mvld[i]=0;
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    $display("C3_RELOAD seed=%08h N_SEED=%0d N_HOLD=%0d TR_W=0,1,2 HO_W=3,4 DISJOINT=1 PROGRAM=NO",
      C3_GEN_SEED, C3_N_SEED, C3_N_Q);

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
      $display("C3_RELOAD_SEED_BEGIN s=%0d live_ep=%0d", seed, live_ep);

      hard_rst(); ctrl=2'd0;
      for (q=0;q<8;q=q+1) begin
        q_s(q, 0);
        dump($sformatf("TR_S%0d_Q%0d", seed, q));
        pulse_rew(3); wait_upd(q+1); retire_q();
      end
      acc_pre=0;
      for (q=0;q<8;q=q+1) begin
        q_s(q, 1);
        dump($sformatf("PRE_S%0d_Q%0d", seed, q));
        chk($sformatf("PRE_S%0d_Q%0d_ANSWER", seed, q), (st===ST_ANSWER) && !tbl);
        if (p0===C3_HO_G0[q][19:0]) acc_pre = acc_pre + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        if (q==7) snap_w();
        retire_q();
      end
      $display("ACC_PRE s=%0d acc=%0d/8 w0=%0d", seed, acc_pre, wsnap[0]);

      pulse_clr();
      c2_drive_to(seed, wsnap[0]);
      pulse_clr();
      chk($sformatf("CLR_PVALID_S%0d", seed), p_valid==1'b0);
      hard_rst();
      chk($sformatf("FLUSH_W0_S%0d", seed), wdut[0]===16'sd0);
      if (wdut[0]===16'sd0) $display("CLASS_flush_w0_zero HIT seed=%0d", seed);
      else $display("CLASS_flush_w0_zero MISS seed=%0d w0=%0d", seed, wdut[0]);

      @(posedge clk); c2_reload=1'b1;
      @(posedge clk); c2_reload=1'b0;
      wait_c2_phase(A7NG_C2_PH_PERSISTED, 400);
      chk($sformatf("RELOAD_MATCH_S%0d", seed), p_valid && (p_w0===wsnap[0]) && (live_w0===wsnap[0]));
      if (p_valid && (p_w0===wsnap[0]) && (live_w0===wsnap[0]))
        $display("CLASS_c2_persist_reload HIT seed=%0d w0=%0d", seed, p_w0);
      else
        $display("CLASS_c2_persist_reload MISS seed=%0d p_w0=%0d live=%0d snap=%0d pvalid=%0d",
          seed, p_w0, live_w0, wsnap[0], p_valid);
      if (p_w0===wsnap[0]) $display("CLASS_c2_w0_match HIT seed=%0d w0=%0d", seed, p_w0);
      else $display("CLASS_c2_w0_match MISS seed=%0d p_w0=%0d snap=%0d", seed, p_w0, wsnap[0]);
      pulse_c2_retire;

      load_w_from_c2();
      acc_post=0;
      for (q=0;q<8;q=q+1) begin
        q_s(q, 1);
        dump($sformatf("POST_S%0d_Q%0d", seed, q));
        chk($sformatf("POST_S%0d_Q%0d_ANSWER", seed, q), (st===ST_ANSWER) && !tbl);
        if (p0===C3_HO_G0[q][19:0]) acc_post = acc_post + 1;
        if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
        retire_q();
      end
      drop_pp = (acc_pre - acc_post) * 100 / 8;
      if (drop_pp > max_drop) max_drop = drop_pp;
      sum_pre = sum_pre + acc_pre;
      sum_post = sum_post + acc_post;
      $display("RETENTION s=%0d pre=%0d post=%0d drop_pp=%0d", seed, acc_pre, acc_post, drop_pp);
      chk($sformatf("DROP_LE5_S%0d", seed), drop_pp <= 5);
    end

    drop_pp = (sum_pre - sum_post) * 100 / (8*C3_N_SEED);
    $display("C3_RELOAD_SUM pre=%0d/%0d post=%0d drop_pp=%0d max_seed_drop=%0d host_bad=%0d saw_base=%0d n_false=%0d",
      sum_pre, 8*C3_N_SEED, sum_post, drop_pp, max_drop, host_bad, saw_base, c2_nfalse);
    if (saw_base && last_aw==A7NG_C2_PERSIST_BASE)
      $display("CLASS_awaddr_06000000 HIT awaddr=%h", last_aw);
    else $display("CLASS_awaddr_06000000 MISS aw=%h saw=%0d", last_aw, saw_base);
    if (host_bad==0) $display("CLASS_host_winner_zero HIT");
    else $display("CLASS_host_winner_zero MISS n=%0d", host_bad);
    if ((drop_pp <= 5) && (max_drop <= 5))
      $display("CLASS_retention_le5pp HIT drop_pp=%0d max_seed_drop=%0d", drop_pp, max_drop);
    else
      $display("CLASS_retention_le5pp MISS drop_pp=%0d max_seed_drop=%0d", drop_pp, max_drop);
    chk("HOST_WINNER_ADDR_WEIGHT_ZERO", host_bad==0);
    chk("RETENTION_LE5", (drop_pp <= 5) && (max_drop <= 5));
    chk("C2_FALSE_ZERO", c2_nfalse==16'd0);
    chk("SAW_PERSIST_BASE", saw_base==1'b1);

    if (fail==0) $display("ASTRA_C3_HELD_OUT_RELOAD_XSIM_PASS");
    else $display("ASTRA_C3_HELD_OUT_RELOAD_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C3_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO quality=TB_AXI_COMPACT_C2_W0_PLUS_SNAP_W1_31");
    $finish;
  end
endmodule
