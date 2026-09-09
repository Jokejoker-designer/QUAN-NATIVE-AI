`timescale 1ns / 1ps
// ASTRA-09-INTEGRATED-PATH-01. PROGRAM=NO. Bag-local TB.
// One path: retrieve→2-hop→rank→pending→reward + CONFLICT/wrong-object + SLVERR drain.
module tb_astra_09_integ_path;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS=80;
  localparam logic [3:0] ST_ANSWER=4'd0, ST_UNKNOWN=4'd1, ST_CONFLICT=4'd5, ST_INCOMP=4'd6;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  int fail, i, nslot, inj;
  string first_div;
  logic tok_v, tok_r, fire, retire, rew_v, busy, result_v, tbl;
  logic pend_acc, pend_cmt, load_v, axi_ost, axi_abort, txn_exh;
  logic [1:0] ctrl, sel;
  logic [7:0] tok, txn, gen, rew_txn, rew_gen, phi0, qobj, qctx;
  logic [15:0] live_ep, sess_id, rew_epoch, epoch, nexh;
  logic [4:0] load_idx, npath;
  logic signed [15:0] load_w;
  logic signed [3:0] rew;
  logic [19:0] ans, p0, p1;
  logic [3:0] st, ost_rid;
  logic signed [15:0] vbest, vsec, vpred, wdut [0:31];
  logic signed [7:0] pphi [0:31];
  logic [15:0] nupd, ndup, nbad, nstale, noor;
  logic [15:0] narto, nrto, nerr, ndrain, naban, dead_mask;
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
        rid<=arid;
        if ((araddr>=FACT_BASE) && (inj==1)) begin
          rresp<=2'b10; rlast<=1'b1; rvalid<=1'b1; rdata<=mem_rd(araddr); mst<=M_BEAT;
        end else begin
          rresp<=2'b00; rlast<=(arlen==8'd0); rvalid<=1'b1; rdata<=mem_rd(araddr); mst<=M_BEAT;
        end
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

  a7ng_astra_09_integ_path u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_ep), .sess_id_i(sess_id), .ctrl_i(ctrl),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .rew_v_i(rew_v), .rew_i(rew), .rew_txn_i(rew_txn), .rew_gen_i(rew_gen),
    .rew_epoch_i(rew_epoch),
    .load_v_i(load_v), .load_idx_i(load_idx), .load_w_i(load_w),
    .busy_o(busy), .result_v_o(result_v),
    .pend_acc_o(pend_acc), .pend_cmt_o(pend_cmt),
    .txn_id_o(txn), .gen_o(gen), .epoch_o(epoch), .sel_idx_o(sel),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1),
    .n_path_o(npath), .status_o(st), .obj_o(qobj), .ctx_o(qctx),
    .v_best_o(vbest), .v_second_o(vsec), .v_pred_o(vpred), .phi0_o(phi0),
    .pend_phi_o(pphi), .w_o(wdut),
    .n_upd_o(nupd), .n_dup_o(ndup), .n_bad_o(nbad), .n_stale_o(nstale), .n_oor_o(noor),
    .n_exh_o(nexh), .txn_exh_o(txn_exh),
    .load_from_tb_o(tbl),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready),
    .n_ar_to_o(narto), .n_r_to_o(nrto), .n_axi_err_o(nerr),
    .n_drain_o(ndrain), .n_abandon_o(naban),
    .axi_ost_o(axi_ost), .axi_abort_o(axi_abort),
    .ost_rid_o(ost_rid), .dead_mask_o(dead_mask)
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
    begin rst_n=0; load_v=0; rew_v=0; fire=0; retire=0; tok_v=0; ctrl=0; inj=0;
      repeat(4) @(posedge clk); rst_n=1; repeat(8) @(posedge clk); end
  endtask
  task automatic load_w0(input shortint val);
    begin wait(!busy); @(posedge clk); load_idx<=5'd0; load_w<=val; load_v<=1;
      @(posedge clk); load_v<=0; repeat(2) @(posedge clk); end
  endtask
  task automatic plant_keys(input int nfact);
    begin
      mem_wr(dir_addr(0,2562), dir_pack(nfact));
      mem_wr(dir_addr(2,766), dir_pack(nfact));
    end
  endtask
  task automatic plant2;
    logic [127:0] beat;
    begin
      reset_mem();
      beat = 32'd35; beat=(beat<<32)|32'd18; beat=(beat<<32)|32'd34; beat=(beat<<32)|32'd17;
      mem_wr(POST_HEAP, beat);
      plant_keys(4);
      mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17,200,1,1,0));
      mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34,200,1,1,0));
      mem_wr(FACT_BASE+(18<<4), fact_pack(10,8,2,18,8,1,1,0));
      mem_wr(FACT_BASE+(35<<4), fact_pack(8,4,2,35,8,1,1,0));
    end
  endtask
  task automatic plant_shared;
    logic [127:0] beat;
    begin
      reset_mem();
      beat = 32'd0; beat=(beat<<32)|32'd36; beat=(beat<<32)|32'd34; beat=(beat<<32)|32'd17;
      mem_wr(POST_HEAP, beat);
      plant_keys(3);
      mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17,200,1,1,0));
      mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34,200,1,1,0));
      mem_wr(FACT_BASE+(36<<4), fact_pack(1,7,2,36,8,1,1,0));
    end
  endtask
  task automatic dump(input string tag);
    $display("%s st=%0d npath=%0d ans=%0d p0=%0d acc=%0d cmt=%0d txn=%0d gen=%0d ep=%0d nupd=%0d nerr=%0d ndrain=%0d abort=%0d ost=%0d arvalid=%0d w0=%0d phi0=%0d obj=%0d ctx=%0d tbl=%0d",
      tag, st, npath, ans, p0, pend_acc, pend_cmt, txn, gen, epoch, nupd, nerr, ndrain, axi_abort, axi_ost, arvalid, wdut[0], phi0, qobj, qctx, tbl);
  endtask
  task automatic pulse_rew(input int rv);
    begin
      @(posedge clk);
      rew<=rv[3:0]; rew_txn<=txn; rew_gen<=gen; rew_epoch<=epoch; rew_v<=1;
      @(posedge clk);
      rew_v<=0; rew<=~rew; rew_txn<=8'hFF; rew_gen<=8'hFF; rew_epoch<=16'hFFFF;
    end
  endtask

  initial begin
    fail=0; first_div=""; nslot=0; inj=0; ctrl=0; tok_v=0; fire=0; retire=0;
    rew_v=0; rew=0; rew_txn=0; rew_gen=0; rew_epoch=0; live_ep=16'd7; sess_id=16'd7;
    load_v=0; load_idx=0; load_w=0;
    go_s=0; go_u=0; iso_load=0; iso_rew=0; rst_n=0;
    for(i=0;i<32;i=i+1) xiso[i]=0;
    for(i=0;i<SLOTS;i=i+1) mvld[i]=0;
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    xiso[0]=8'sd50; iso_rew=4'sd3;
    wait(rdy); @(posedge clk); go_u=1; @(posedge clk); go_u=0; wait(dn); @(posedge clk);
    $display("ISO_P3 w0=%0d viso=%0d", wiso[0], viso);
    chk("ISO_P3_X50_DW5", wiso[0]===16'sd5 && wiso[1]===0);

    live_ep=16'd7; sess_id=16'd7; hard_rst(); inj=0; plant2();
    send_text("pump requires indirect"); wait_done();
    dump("SMOKE_TWO_PROOFS");
    chk("SMOKE_TWO_PROOFS", (st===ST_ANSWER) && !tbl && (npath>=5'd2) && (p0===20'd17)
        && (ans===20'd4) && pend_acc && (txn===8'd1) && (gen===8'd1) && (epoch===16'd7)
        && (phi0===8'sd50));

    pulse_rew(-3);
    repeat(250) @(posedge clk);
    dump("HS_UPD");
    chk("HS_LATCH_NUPD", nupd===16'd1 && pend_cmt===1'b1 && wdut[0]===-16'sd5);
    retire_q();

    hard_rst(); inj=0; plant_shared(); load_w0(-16'sd16);
    send_text("pump requires indirect"); wait_done();
    dump("CONFLICT_DEST");
    chk("CONFLICT_DEST", (st===ST_CONFLICT) && (ans===20'd0) && (p0===20'd0)
        && !pend_acc && (npath>=5'd2) && !tbl);
    pulse_rew(-3);
    repeat(80) @(posedge clk);
    dump("CONFLICT_NO_UPD");
    chk("CONFLICT_NO_UPD", nupd===16'd0 && wdut[0]===-16'sd16);
    retire_q();

    hard_rst(); inj=0; plant2();
    send_text("pump requires indirect valve"); wait_done();
    dump("WRONG_OBJ");
    chk("WRONG_OBJ", (st===ST_UNKNOWN) && (ans===20'd0) && (p0===20'd0)
        && (npath===5'd0) && (qobj===8'd11) && (qctx===8'd2) && !pend_acc && !tbl);
    retire_q();

    hard_rst(); inj=1; plant2();
    send_text("pump requires indirect"); wait_done();
    dump("SLVERR");
    chk("SLVERR", (st===ST_INCOMP) && (ans===20'd0) && (p0===20'd0) && !pend_acc
        && !arvalid && !axi_ost && !tbl && axi_abort);
    chk("SLVERR_NERR", nerr>=16'd1);
    chk("SLVERR_NO_STALE", (ans===20'd0) && (p0===20'd0));
    retire_q(); inj=0;

    hard_rst(); inj=0; plant2();
    send_text("pump requires indirect"); wait_done();
    dump("SMOKE_AFTER");
    chk("SMOKE_AFTER", (st===ST_ANSWER) && !tbl && (npath>=5'd2)
        && (p0===20'd17) && (ans===20'd4));
    retire_q();
    send_text("payroll tax form"); wait_done();
    dump("UNREL");
    chk("UNREL_NO_STALE", (st===ST_UNKNOWN) && (npath===5'd0)
        && (ans===20'd0) && (p0===20'd0) && !tbl);

    if (fail==0) $display("ASTRA_09_INTEGRATED_PATH_XSIM_PASS");
    else $display("ASTRA_09_INTEGRATED_PATH_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $finish;
  end
endmodule
