`timescale 1ns / 1ps
// ASTRA-06-R2-EVICT-HIGHID-01. PROGRAM=NO. Bag-local TB.
// High-bit 20-bit eids, explicit reload_i, persist capacity N=1.
module tb_astra_06_r2_evict_highid;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS=80;
  localparam logic [3:0] ST_ANSWER=4'd0, ST_UNKNOWN=4'd1;
  localparam logic [19:0] HID_P0  = 20'hA0011;
  localparam logic [19:0] HID_P1  = 20'hA0022;
  localparam logic [19:0] HID_P0B = 20'hA0033;
  localparam logic [19:0] HID_P1B = 20'hA0044;
  localparam logic [19:0] HID_MID = 20'hA0100;
  localparam logic [19:0] HID_MIDB= 20'hA0200;
  localparam logic [19:0] HID_ANS = 20'hA00B4;
  localparam logic [7:0]  SCH_OK  = 8'h01;
  localparam logic [7:0]  SCH_BAD = 8'hA5;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  int fail, i, nslot;
  string first_div;
  logic tok_v, tok_r, fire, retire, rew_v, busy, result_v, tbl;
  logic pend_acc, pend_cmt, load_v, axi_ost, axi_abort, txn_exh;
  logic persist_en, restore_en, persist_clr, reload_req, schema_poke, cap_full;
  logic p_valid, p_acc, p_cmt, rl_busy;
  logic [1:0] ctrl, sel;
  logic [7:0] tok, txn, gen, rew_txn, rew_gen, phi0, qobj, qctx, schema;
  logic [7:0] p_gen, p_txn, p_phi0, p_ver;
  logic [15:0] live_ep, sess_id, rew_epoch, epoch, nexh, p_epoch;
  logic [15:0] nref, nevict, nsch, nrlauto, nrlcmd;
  logic [4:0] load_idx, npath;
  logic signed [15:0] load_w, p_w0, p_vpred;
  logic signed [3:0] rew;
  logic [19:0] ans, p0, p1, p_ans, p_p0, p_p1;
  logic [3:0] st, ost_rid;
  logic signed [15:0] vbest, vsec, vpred, wdut [0:31];
  logic signed [7:0] pphi [0:31];
  logic [15:0] nupd, ndup, nbad, nstale, noor;
  logic [15:0] narto, nrto, nerr, ndrain, naban, dead_mask;
  logic signed [7:0] xiso [0:31];
  logic go_s, go_u, rdy, dn, iso_load;
  logic signed [15:0] viso, wiso [0:31];
  logic signed [3:0] iso_rew;
  logic [15:0] sav_ep;
  logic [7:0] sav_txn, sav_gen;
  logic [15:0] nupd0, nstale0, nref0, nevict0, nrlauto0, nrlcmd0, nsch0;

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

  a7ng_astra_06_r2_evict_highid u_dut (
    .clk(clk), .rst_n(rst_n),
    .persist_en_i(persist_en), .restore_en_i(restore_en),
    .persist_clr_i(persist_clr), .reload_i(reload_req),
    .schema_i(schema), .schema_poke_i(schema_poke),
    .live_epoch_i(live_ep), .sess_id_i(sess_id), .ctrl_i(ctrl),
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
    .ost_rid_o(ost_rid), .dead_mask_o(dead_mask),
    .persist_valid_o(p_valid), .persist_acc_o(p_acc), .persist_cmt_o(p_cmt),
    .reload_busy_o(rl_busy),
    .persist_epoch_o(p_epoch), .persist_gen_o(p_gen), .persist_txn_o(p_txn),
    .persist_w0_o(p_w0), .persist_vpred_o(p_vpred), .persist_phi0_o(p_phi0),
    .persist_ans_o(p_ans), .persist_p0_o(p_p0), .persist_p1_o(p_p1),
    .persist_ver_o(p_ver), .cap_full_o(cap_full),
    .n_cap_ref_o(nref), .n_cap_evict_o(nevict),
    .n_schema_rej_o(nsch), .n_rl_auto_o(nrlauto), .n_rl_cmd_o(nrlcmd)
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
  task automatic wait_reload;
    begin
      fork
        begin wait(!rl_busy); end
        begin repeat(400) @(posedge clk); $display("RELOAD_TIMEOUT"); fail=fail+1; $finish; end
      join_any disable fork;
      repeat(4) @(posedge clk);
    end
  endtask
  task automatic wipe_rst;
    begin
      persist_clr=1; rst_n=0; load_v=0; rew_v=0; fire=0; retire=0; tok_v=0; reload_req=0; schema_poke=0;
      repeat(4) @(posedge clk); persist_clr=0; rst_n=1; repeat(8) @(posedge clk);
    end
  endtask
  task automatic power_loss;
    begin
      rst_n=0; load_v=0; rew_v=0; fire=0; retire=0; tok_v=0; reload_req=0; schema_poke=0;
      repeat(4) @(posedge clk); rst_n=1; repeat(2) @(posedge clk);
      if (restore_en) wait_reload();
      else repeat(8) @(posedge clk);
    end
  endtask
  task automatic plant_high;
    logic [127:0] beat;
    begin
      reset_mem();
      beat = 32'(HID_P1B); beat=(beat<<32)|32'(HID_P0B); beat=(beat<<32)|32'(HID_P1); beat=(beat<<32)|32'(HID_P0);
      mem_wr(POST_HEAP, beat);
      mem_wr(dir_addr(0,2562), dir_pack(4));
      mem_wr(dir_addr(2,766), dir_pack(4));
      mem_wr(FACT_BASE+{HID_P0,4'b0},  fact_pack(10, HID_MID,  2, HID_P0,  200,1,1,0));
      mem_wr(FACT_BASE+{HID_P1,4'b0},  fact_pack(HID_MID, HID_ANS, 2, HID_P1,  200,1,1,0));
      mem_wr(FACT_BASE+{HID_P0B,4'b0}, fact_pack(10, HID_MIDB, 2, HID_P0B, 8,1,1,0));
      mem_wr(FACT_BASE+{HID_P1B,4'b0}, fact_pack(HID_MIDB,HID_ANS, 2, HID_P1B, 8,1,1,0));
    end
  endtask
  task automatic dump(input string tag);
    $display("%s st=%0d npath=%0d ans=0x%05h p0=0x%05h acc=%0d cmt=%0d txn=%0d gen=%0d ep=%0d nupd=%0d nstale=%0d nbad=%0d w0=%0d phi0=%0d vpred=%0d ost=%0d tbl=%0d pval=%0d pacc=%0d pcmt=%0d pep=%0d ptxn=%0d pgen=%0d pw0=%0d pans=0x%05h pp0=0x%05h pphi0=%0d pver=%0d capf=%0d nref=%0d nevict=%0d nrlauto=%0d nrlcmd=%0d nsch=%0d",
      tag, st, npath, ans, p0, pend_acc, pend_cmt, txn, gen, epoch, nupd, nstale, nbad, wdut[0], phi0, vpred, axi_ost, tbl,
      p_valid, p_acc, p_cmt, p_epoch, p_txn, p_gen, p_w0, p_ans, p_p0, p_phi0, p_ver, cap_full, nref, nevict, nrlauto, nrlcmd, nsch);
  endtask
  task automatic pulse_rew(input int rv);
    begin
      @(posedge clk);
      rew<=rv[3:0]; rew_txn<=txn; rew_gen<=gen; rew_epoch<=epoch; rew_v<=1;
      @(posedge clk);
      rew_v<=0; rew<=~rew; rew_txn<=8'hFF; rew_gen<=8'hFF; rew_epoch<=16'hFFFF;
    end
  endtask
  task automatic pulse_rew_id(input int rv, input logic [15:0] ep, input logic [7:0] t, input logic [7:0] g);
    begin
      @(posedge clk);
      rew<=rv[3:0]; rew_txn<=t; rew_gen<=g; rew_epoch<=ep; rew_v<=1;
      @(posedge clk);
      rew_v<=0; rew<=~rew; rew_txn<=8'hFF; rew_gen<=8'hFF; rew_epoch<=16'hFFFF;
    end
  endtask
  task automatic pulse_reload;
    begin
      @(posedge clk); reload_req<=1;
      @(posedge clk); reload_req<=0;
      fork
        begin
          if (!rl_busy) wait(rl_busy);
          wait(!rl_busy);
        end
        begin repeat(400) @(posedge clk); $display("RELOAD_I_TIMEOUT"); fail=fail+1; $finish; end
      join_any disable fork;
      repeat(4) @(posedge clk);
    end
  endtask
  task automatic pulse_schema(input logic [7:0] v);
    begin
      @(posedge clk); schema<=v; schema_poke<=1;
      @(posedge clk); schema_poke<=0;
      repeat(2) @(posedge clk);
    end
  endtask
  task automatic q_high;
    begin plant_high(); send_text("pump requires indirect"); wait_done(); end
  endtask
  function automatic bit highid_ok;
    highid_ok = (p_ans===HID_ANS) && (p_p0===HID_P0) && (ans===HID_ANS) && (p0===HID_P0)
             && (p_p0[19:8]!==12'd0) && (p0[19:8]!==12'd0)
             && (p_ans[19:8]!==12'd0) && (ans[19:8]!==12'd0);
  endfunction

  initial begin
    fail=0; first_div=""; nslot=0; ctrl=0; tok_v=0; fire=0; retire=0;
    rew_v=0; rew=0; rew_txn=0; rew_gen=0; rew_epoch=0; live_ep=16'd7; sess_id=16'd7;
    load_v=0; load_idx=0; load_w=0;
    persist_en=0; restore_en=0; persist_clr=1; reload_req=0; schema_poke=0; schema=SCH_OK;
    go_s=0; go_u=0; iso_load=0; iso_rew=0; rst_n=0;
    for(i=0;i<32;i=i+1) xiso[i]=0;
    for(i=0;i<SLOTS;i=i+1) mvld[i]=0;
    repeat(8) @(posedge clk); persist_clr=0; rst_n=1; repeat(8) @(posedge clk);

    xiso[0]=8'sd50; iso_rew=4'sd3;
    wait(rdy); @(posedge clk); go_u=1; @(posedge clk); go_u=0; wait(dn); @(posedge clk);
    $display("ISO_P3 w0=%0d viso=%0d", wiso[0], viso);
    chk("ISO_P3_X50_DW5", wiso[0]===16'sd5 && wiso[1]===0);

    persist_en=1; restore_en=1; schema=SCH_OK; live_ep=16'd7; sess_id=16'd7; wipe_rst(); q_high();
    dump("SMOKE_HIGHID");
    chk("SMOKE_HIGHID", (st===ST_ANSWER) && !tbl && (npath>=5'd2) && highid_ok()
        && pend_acc && (txn===8'd1) && (gen===8'd1) && (epoch===16'd7)
        && (phi0===8'sd50));
    chk("HIGHID_EID20", highid_ok() && (p_p1===HID_P1) && (p1===HID_P1));
    $display("HIGHID_OBS pans=0x%05h pp0=0x%05h pp1=0x%05h ans=0x%05h p0=0x%05h p1=0x%05h bits19_8_p0=%0h",
      p_ans, p_p0, p_p1, ans, p0, p1, p0[19:8]);
    chk("PERSIST_SNAP", p_valid && p_acc && !p_cmt && (p_w0===16'sd0) && (p_epoch===16'd7)
        && (p_txn===8'd1) && (p_gen===8'd1) && (p_phi0===8'sd50) && (p_ver===SCH_OK) && cap_full);
    sav_ep=epoch; sav_txn=txn; sav_gen=gen;

    power_loss();
    dump("EN_RST_LIVE");
    chk("EN_RST_LIVE_CLEAR", (wdut[0]===16'sd0) && !axi_ost && (nupd===16'd0));
    chk("AXI_OST_CLEARED", !axi_ost);
    dump("EN_RELOAD_AUTO");
    chk("EN_RELOAD_AUTO", pend_acc && !pend_cmt && (txn===8'd1) && (gen===8'd1)
        && (epoch===16'd7) && (phi0===8'sd50) && p_valid && (p_w0===16'sd0)
        && (nrlauto===16'd1) && (nrlcmd===16'd0) && highid_ok());
    pulse_rew_id(-3, sav_ep, sav_txn, sav_gen);
    repeat(250) @(posedge clk);
    dump("EN_DELAYED_UPD");
    chk("EN_DELAYED_UPD", nupd===16'd1 && pend_cmt && (wdut[0]===-16'sd5));
    retire_q();

    persist_en=1; restore_en=0; schema=SCH_OK; live_ep=16'd7; sess_id=16'd7; wipe_rst(); q_high();
    sav_ep=epoch; sav_txn=txn; sav_gen=gen;
    nrlauto0=nrlauto; nrlcmd0=nrlcmd;
    dump("RELOAD_I_PRE");
    chk("RELOAD_I_PRE_HIGHID", highid_ok() && p_valid && pend_acc && !pend_cmt);
    power_loss();
    dump("RELOAD_I_AFTER_RST");
    chk("RELOAD_I_NO_AUTO", (nrlauto===nrlauto0) && (nrlcmd===nrlcmd0) && p_valid
        && !pend_acc && (p_ans===HID_ANS) && (p_p0===HID_P0) && (p_p0[19:8]!==12'd0));
    pulse_reload();
    dump("RELOAD_I_PATH");
    chk("RELOAD_I_PATH", (nrlcmd===nrlcmd0+16'd1) && (nrlauto===nrlauto0)
        && pend_acc && !pend_cmt && (txn===sav_txn) && (gen===sav_gen)
        && (epoch===sav_ep) && highid_ok());
    pulse_rew_id(-3, sav_ep, sav_txn, sav_gen);
    repeat(250) @(posedge clk);
    dump("RELOAD_I_DELAYED_UPD");
    chk("RELOAD_I_DELAYED_UPD", nupd===16'd1 && pend_cmt && (wdut[0]===-16'sd5));
    retire_q();

    persist_en=1; restore_en=1; schema=SCH_OK; live_ep=16'd7; sess_id=16'd7; wipe_rst(); q_high();
    dump("CAP_OCCUPIED");
    chk("CAP_OCCUPIED", cap_full && p_valid && (p_txn===8'd1) && !p_cmt && pend_acc && highid_ok());
    retire_q();
    nref0=nref;
    q_high();
    dump("CAP_REFUSE_SECOND");
    chk("CAP_REFUSE_SECOND", (nref===nref0+16'd1) && !pend_acc && p_valid && !p_cmt
        && (p_txn===8'd1) && (p_ans===HID_ANS) && (p_p0===HID_P0) && cap_full);
    retire_q();

    persist_en=1; restore_en=1; schema=SCH_OK; live_ep=16'd7; sess_id=16'd7; wipe_rst(); q_high();
    pulse_rew(-3);
    repeat(250) @(posedge clk);
    dump("CAP_COMMITTED");
    chk("CAP_COMMITTED", p_cmt && p_valid && (p_txn===8'd1) && !cap_full && (wdut[0]===-16'sd5));
    retire_q();
    nevict0=nevict;
    q_high();
    dump("CAP_EVICT_COMMITTED");
    chk("CAP_EVICT_COMMITTED", (nevict===nevict0+16'd1) && pend_acc && !pend_cmt
        && p_valid && !p_cmt && (p_txn===8'd2) && (p_ans===HID_ANS) && cap_full);
    retire_q();

    persist_en=1; restore_en=1; schema=SCH_OK; live_ep=16'd7; sess_id=16'd7; wipe_rst(); q_high();
    pulse_rew(-3);
    repeat(250) @(posedge clk);
    dump("SCHEMA_NATIVE_CMT");
    chk("SCHEMA_NATIVE_CMT", (wdut[0]===-16'sd5) && (p_w0===-16'sd5) && (p_ver===SCH_OK) && p_cmt);
    nsch0=nsch;
    pulse_schema(SCH_BAD);
    dump("SCHEMA_POKE");
    chk("SCHEMA_POKE", (p_ver===SCH_BAD) && (p_w0===-16'sd5) && p_valid);
    power_loss();
    dump("SCHEMA_FOREIGN_NO_RESTORE");
    chk("SCHEMA_FOREIGN_NO_RESTORE", (nsch>nsch0) && (wdut[0]===16'sd0) && !pend_acc
        && p_valid && (p_w0===-16'sd5) && (p_ver===SCH_BAD) && (p_ans===HID_ANS));
    retire_q();

    persist_en=0; restore_en=1; schema=SCH_OK; live_ep=16'd7; sess_id=16'd7; wipe_rst(); q_high();
    sav_ep=epoch; sav_txn=txn; sav_gen=gen;
    dump("DIS_PRE");
    chk("DIS_NO_SNAP", !p_valid);
    power_loss();
    dump("DIS_RST");
    nupd0=nupd; nstale0=nstale;
    pulse_rew_id(-3, sav_ep, sav_txn, sav_gen);
    repeat(40) @(posedge clk);
    dump("DIS_STALE");
    chk("DIS_RST_STALE", nupd===nupd0 && nstale>nstale0 && (wdut[0]===16'sd0) && !pend_cmt);

    persist_en=1; restore_en=1; schema=SCH_OK; live_ep=16'd7; sess_id=16'd7; wipe_rst(); q_high();
    power_loss();
    dump("UNREL_PRE");
    send_text("payroll tax form"); wait_done();
    dump("UNREL");
    chk("UNREL_NO_STALE", st===ST_UNKNOWN && npath===5'd0 && ans===20'd0 && p0===20'd0 && !tbl);

    if (fail==0) $display("ASTRA_06_R2_EVICT_HIGHID_XSIM_PASS");
    else $display("ASTRA_06_R2_EVICT_HIGHID_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $finish;
  end
endmodule
