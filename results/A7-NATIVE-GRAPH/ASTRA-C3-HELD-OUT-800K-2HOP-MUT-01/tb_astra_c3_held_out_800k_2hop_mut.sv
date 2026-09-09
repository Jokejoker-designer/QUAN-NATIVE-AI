`timescale 1ns / 1ps
// ASTRA-C3-HELD-OUT-800K-2HOP-MUT-01. PROGRAM=NO.
// After +rew train, mutate ctx overlay: delete hop2 / replace dest / reverse query.
`include "a7ng_astra_c3_held_out.svh"
module tb_astra_c3_held_out_800k_2hop_mut;
  `include "query_gold.svh"
  `include "gen_800k.svh"
  `include "c3_800k_facts.svh"
  `include "c3_800k_2hop.svh"
  localparam logic [27:0] FACT_BASE_800K = 28'h0E00_0000;
  localparam logic [3:0] ST_ANSWER=4'd0;
  localparam logic [3:0] ST_UNKNOWN=4'd1;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  int fail; string first_div;
  logic tok_v, tok_r, fire, retire, rew_v, busy, result_v, tbl;
  logic pend_acc, pend_cmt, load_v;
  logic [1:0] ctrl, mut;
  logic [3:0] sel;
  logic [7:0] tok, txn, gen, rew_txn, rew_gen, phi0, qobj, qctx, qsubj;
  logic [15:0] nhwin, nhaddr, live_ep, nupd, ndup, nbad;
  logic [4:0] load_idx, npath;
  logic signed [15:0] load_w, wdut [0:31];
  logic signed [3:0] rew;
  logic [19:0] ans, p0, p1;
  logic [3:0] st;
  logic signed [15:0] vbest, vsec;
  logic signed [7:0] pphi [0:31];
  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst;
  logic arvalid, arready, rready, rlast, rvalid;
  logic [3:0] rid; logic [127:0] rdata; logic [1:0] rresp;
  int TR_S [0:7] = '{13,15,16,13,15,16,13,15};
  int host_bad, q;

  a7ng_astra_c3_held_out_nb64k #(.TO_CYC(65535), .FACT_BASE(FACT_BASE_800K)) u_dut (
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

  a7ng_axi_mem_c3_800k_2hop_mut u_mem (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_ep), .mut_i(mut),
    .s_axi_arid(arid), .s_axi_araddr(araddr), .s_axi_arlen(arlen),
    .s_axi_arsize(arsize), .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid), .s_axi_arready(arready),
    .s_axi_rid(rid), .s_axi_rdata(rdata), .s_axi_rresp(rresp),
    .s_axi_rlast(rlast), .s_axi_rvalid(rvalid), .s_axi_rready(rready)
  );

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div=="") first_div=tag;
        $display("FAIL %s", tag); fail=fail+1;
      end else $display("PASS %s", tag);
    end
  endtask
  function automatic string qstr(input int subj);
    begin
      unique case (subj)
        13: qstr = "boiler feeds indirect";
        14: qstr = "header feeds indirect";
        15: qstr = "coil feeds indirect";
        16: qstr = "filter feeds indirect";
        19: qstr = "plenum feeds indirect";
        20: qstr = "riser feeds indirect";
        default: qstr = "boiler feeds indirect";
      endcase
    end
  endfunction
  task send_text(input string s);
    integer n,k; begin n=s.len();
      for(k=0;k<n;k=k+1) begin @(posedge clk); while(!tok_r) @(posedge clk);
        tok_v<=1; tok<=s[k]; @(posedge clk); tok_v<=0; end
      @(posedge clk); fire<=1; @(posedge clk); fire<=0;
    end
  endtask
  task wait_done;
    begin fork wait(result_v); begin repeat(200000) @(posedge clk); $display("TIMEOUT"); fail=fail+1; $finish; end join_any disable fork; end
  endtask
  task retire_q; begin @(posedge clk); retire<=1; @(posedge clk); retire<=0; wait(!result_v); repeat(4) @(posedge clk); end endtask
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
  task automatic q_run(input int subj);
    begin
      send_text(qstr(subj));
      wait_done();
    end
  endtask

  initial begin
    fail=0; first_div=""; ctrl=0; tok_v=0; fire=0; retire=0;
    rew_v=0; rew=0; rew_txn=0; rew_gen=0; live_ep=16'd7; mut=2'd0;
    load_v=0; load_idx=0; load_w=0; host_bad=0; rst_n=0;
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    $display("C3_800K_2HOP_MUT FACT_BASE=0E000000 PROGRAM=NO BOARD_PASS=REJECT");
    $display("CLASS_entities_disjoint HIT train={13,15,16} hold={19} reverse_subj=14");

    ctrl=2'd0;
    for (q=0;q<8;q=q+1) begin
      q_run(TR_S[q]);
      pulse_rew(3); wait_upd(q+1); retire_q();
    end

    mut=2'd0;
    q_run(19);
    $display("BASE st=%0d npath=%0d ans=%0d p0=%0d p1=%0d ctx=%0d", st, npath, ans, p0, p1, qctx);
    if ((st===ST_ANSWER) && (ans===20'd28) && (p1===20'd64617) && (qctx===A7NG_C3_CTX_INDIRECT))
      $display("CLASS_base_two_hop HIT ans=28 p1=64617");
    else $display("CLASS_base_two_hop MISS");
    chk("BASE_TWO_HOP", (st===ST_ANSWER) && (ans===20'd28) && (p1===20'd64617));
    if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
    retire_q();

    mut=2'd1;
    q_run(19);
    $display("DEL st=%0d npath=%0d ans=%0d p0=%0d p1=%0d", st, npath, ans, p0, p1);
    if ((st===ST_UNKNOWN) && (ans!==20'd28))
      $display("CLASS_edge_delete HIT");
    else $display("CLASS_edge_delete MISS");
    chk("EDGE_DELETE_UNKNOWN", (st===ST_UNKNOWN) && (ans!==20'd28));
    if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
    retire_q();

    mut=2'd2;
    q_run(19);
    $display("REP st=%0d npath=%0d ans=%0d p0=%0d p1=%0d", st, npath, ans, p0, p1);
    if ((st===ST_ANSWER) && (ans===20'd45) && (p1===20'd64633))
      $display("CLASS_edge_replace HIT ans=45 p1=64633");
    else $display("CLASS_edge_replace MISS");
    chk("EDGE_REPLACE_DEST45", (st===ST_ANSWER) && (ans===20'd45) && (p1===20'd64633));
    if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
    retire_q();

    mut=2'd0;
    q_run(14);
    $display("REV st=%0d npath=%0d ans=%0d subj=%0d ctx=%0d", st, npath, ans, qsubj, qctx);
    if ((st===ST_UNKNOWN) && (ans!==20'd28) && (ans!==20'd45) && (qsubj===8'd14))
      $display("CLASS_edge_reverse HIT");
    else $display("CLASS_edge_reverse MISS");
    chk("EDGE_REVERSE_UNKNOWN", (st===ST_UNKNOWN) && (qsubj===8'd14));
    if (nhwin!==16'd0 || nhaddr!==16'd0 || tbl) host_bad = host_bad + 1;
    retire_q();

    if (host_bad==0) $display("CLASS_host_winner_zero HIT");
    else $display("CLASS_host_winner_zero MISS n=%0d", host_bad);
    chk("HOST_WINNER_ADDR_WEIGHT_ZERO", host_bad==0);

    if (fail==0) $display("ASTRA_C3_HELD_OUT_800K_2HOP_MUT_XSIM_PASS");
    else $display("ASTRA_C3_HELD_OUT_800K_2HOP_MUT_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C3_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO quality=800K_CTX_OVERLAY_MUT_NOT_MIG");
    $finish;
  end
endmodule
