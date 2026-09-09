`timescale 1ns / 1ps
// ASTRA-F3-R2-INDEPENDENT-WORLDS-01. PROGRAM=NO. Bag-local TB.
// Five independent world/role/relation/support draws. Hold phi != train phi.
`include "tb_oracles.svh"
module tb_astra_f3r2_ind_worlds;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS=96;
  localparam logic [3:0] ST_ANSWER=4'd0, ST_UNKNOWN=4'd1;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  int fail, i, nslot;
  string first_div;
  int en_e1, en_e2, en_rl, fr_c, sh_c, pid_c, phi_neq_c, n_rank, n_ans;
  int pidmap [0:255];
  logic tok_v, tok_r, fire, retire, rew_v, busy, result_v, tbl;
  logic pend_acc, pend_cmt, load_v;
  logic [1:0] ctrl, sel;
  logic [7:0] tok, txn, gen, rew_txn, rew_gen, phi0, qobj, qctx;
  logic [15:0] live_ep;
  logic [4:0] load_idx, npath;
  logic signed [15:0] load_w, wsnap [0:31];
  logic signed [3:0] rew;
  logic [19:0] ans, p0, p1;
  logic [3:0] st;
  logic signed [15:0] vbest, vsec, wdut [0:31];
  logic signed [7:0] pphi [0:31];
  logic signed [7:0] trphi [0:31], hophi [0:31];
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

  a7ng_astra_f3r2_ind_worlds u_dut (
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
  task automatic plant_index(input int nfact, input int k0, input int k2,
                             input int k1, input int k3, input bit objb);
    begin
      mem_wr(dir_addr(0,k0), dir_pack(nfact));
      mem_wr(dir_addr(2,k2), dir_pack(nfact));
      if (objb) begin
        mem_wr(dir_addr(1,k1), dir_pack(nfact));
        mem_wr(dir_addr(3,k3), dir_pack(nfact));
      end
    end
  endtask
  task automatic plant_post(input int n, input int e0, input int e1, input int e2,
                            input int e3, input int e4, input int e5);
    logic [127:0] b0, b1;
    begin
      b0 = e3; b0=(b0<<32)|e2; b0=(b0<<32)|e1; b0=(b0<<32)|e0;
      mem_wr(POST_HEAP, b0);
      if (n > 4) begin
        b1 = 32'd0; b1=(b1<<32)|32'd0; b1=(b1<<32)|e5; b1=(b1<<32)|e4;
        mem_wr(POST_HEAP+28'd16, b1);
      end
    end
  endtask
  task automatic wr_f(input int e, s, o, r, conf, trans, pol, fctx);
    mem_wr(FACT_BASE+(e<<4), fact_pack(s,o,r,e,conf,trans,pol,fctx));
  endtask

  // kind: 0 train enabled, 1 hold, 2 shuffle train
  task automatic plant_world(input int seed, input int kind);
    begin
      reset_mem();
      unique case (seed)
        0: begin
          if (kind==1) begin
            plant_post(2, 32'h111, 32'h211, 0, 0, 0, 0);
            plant_index(2, F3R2_K0_PUMP_REQ, F3R2_K2_PUMP, 0, 0, 1'b0);
            wr_f(32'h111, 10, 32'h81, 2, 8, 0, 1, 1);
            wr_f(32'h211, 10, 32'h80, 2, 200, 0, 1, 1);
          end else if (kind==2) begin
            plant_post(4, 16, 33, 19, 36, 0, 0);
            plant_index(4, F3R2_K0_PUMP_REQ, F3R2_K2_PUMP, 0, 0, 1'b0);
            wr_f(16, 10, 8, 2, 8, 1, 1, 2);
            wr_f(33, 8, 21, 2, 8, 1, 1, 2);
            wr_f(19, 10, 1, 2, 200, 1, 1, 2);
            wr_f(36, 1, 20, 2, 200, 1, 1, 2);
          end else begin
            plant_post(4, 17, 34, 18, 35, 0, 0);
            plant_index(4, F3R2_K0_PUMP_REQ, F3R2_K2_PUMP, 0, 0, 1'b0);
            wr_f(17, 10, 1, 2, 200, 1, 1, 2);
            wr_f(34, 1, 20, 2, 200, 1, 1, 2);
            wr_f(18, 10, 8, 2, 8, 1, 1, 2);
            wr_f(35, 8, 21, 2, 8, 1, 1, 2);
          end
        end
        1: begin
          if (kind==1) begin
            plant_post(4, 32'h311, 32'h322, 32'h411, 32'h422, 0, 0);
            plant_index(4, F3R2_K0_CHILL_REQ, F3R2_K2_CHILLER, 0, 0, 1'b0);
            wr_f(32'h311, 1, 32'h39, 2, 200, 1, 1, 1);
            wr_f(32'h322, 32'h39, 32'h83, 2, 200, 1, 1, 1);
            wr_f(32'h411, 1, 32'h30, 2, 200, 1, 1, 2);
            wr_f(32'h422, 32'h30, 32'h82, 2, 200, 1, 1, 2);
          end else if (kind==2) begin
            plant_post(2, 39, 43, 0, 0, 0, 0);
            plant_index(2, F3R2_K0_VALVE_SUP, F3R2_K2_VALVE, 0, 0, 1'b0);
            wr_f(39, 11, 32'h23, 1, 200, 0, 1, 0);
            wr_f(43, 11, 32'h22, 1, 200, 0, 1, 1);
          end else begin
            plant_post(2, 40, 42, 0, 0, 0, 0);
            plant_index(2, F3R2_K0_VALVE_SUP, F3R2_K2_VALVE, 0, 0, 1'b0);
            wr_f(40, 11, 32'h22, 1, 200, 0, 1, 1);
            wr_f(42, 11, 32'h23, 1, 200, 0, 1, 0);
          end
        end
        2: begin
          if (kind==1) begin
            plant_post(4, 32'h511, 32'h522, 32'h611, 32'h622, 0, 0);
            plant_index(4, F3R2_K0_VALVE_REQ, F3R2_K2_VALVE, F3R2_K1_EVAP_REQ, F3R2_K3_EVAP, 1'b1);
            wr_f(32'h511, 11, 32'h53, 2, 200, 1, 1, 1);
            wr_f(32'h522, 32'h53, 3, 2, 200, 1, 1, 0);
            wr_f(32'h611, 11, 32'h50, 2, 200, 1, 1, 1);
            wr_f(32'h622, 32'h50, 3, 2, 200, 1, 1, 5);
          end else if (kind==2) begin
            plant_post(4, 48, 49, 54, 55, 0, 0);
            plant_index(4, F3R2_K0_PUMP_REQ, F3R2_K2_PUMP, F3R2_K1_COMP_REQ, F3R2_K3_COMP, 1'b1);
            wr_f(48, 10, 13, 2, 200, 1, 1, 0);
            wr_f(49, 13, 4, 2, 200, 1, 1, 0);
            wr_f(54, 10, 12, 2, 200, 1, 1, 0);
            wr_f(55, 12, 4, 2, 200, 1, 1, 3);
          end else begin
            plant_post(4, 50, 51, 52, 53, 0, 0);
            plant_index(4, F3R2_K0_PUMP_REQ, F3R2_K2_PUMP, F3R2_K1_COMP_REQ, F3R2_K3_COMP, 1'b1);
            wr_f(50, 10, 12, 2, 200, 1, 1, 0);
            wr_f(51, 12, 4, 2, 200, 1, 1, 3);
            wr_f(52, 10, 13, 2, 200, 1, 1, 0);
            wr_f(53, 13, 4, 2, 200, 1, 1, 0);
          end
        end
        3: begin
          if (kind==1) begin
            plant_post(6, 32'h711, 32'h722, 32'h811, 32'h822, 32'h833, 32'h834);
            plant_index(6, F3R2_K0_TOWER_REQ, F3R2_K2_TOWER, 0, 0, 1'b0);
            wr_f(32'h711, 9, 32'h16, 2, 200, 1, 1, 2);
            wr_f(32'h722, 32'h16, 32'h85, 2, 200, 1, 1, 2);
            wr_f(32'h811, 9, 32'h12, 2, 200, 1, 1, 3);
            wr_f(32'h822, 32'h12, 32'h84, 2, 200, 1, 1, 1);
            wr_f(32'h833, 9, 32'h15, 2, 200, 1, 1, 0);
            wr_f(32'h834, 9, 32'h18, 2, 200, 1, 1, 0);
          end else if (kind==2) begin
            plant_post(5, 58, 59, 65, 66, 67, 0);
            plant_index(5, F3R2_K0_AHU_CONN, F3R2_K2_AHU, 0, 0, 1'b0);
            wr_f(58, 6, 14, 3, 200, 1, 1, 0);
            wr_f(59, 14, 32'h25, 3, 200, 1, 1, 0);
            wr_f(65, 6, 2, 3, 200, 1, 1, 1);
            wr_f(66, 2, 32'h24, 3, 200, 1, 1, 0);
            wr_f(67, 6, 5, 3, 200, 1, 1, 0);
          end else begin
            plant_post(5, 60, 61, 62, 63, 64, 0);
            plant_index(5, F3R2_K0_AHU_CONN, F3R2_K2_AHU, 0, 0, 1'b0);
            wr_f(60, 6, 2, 3, 200, 1, 1, 1);
            wr_f(61, 2, 32'h24, 3, 200, 1, 1, 0);
            wr_f(62, 6, 14, 3, 200, 1, 1, 0);
            wr_f(63, 14, 32'h25, 3, 200, 1, 1, 0);
            wr_f(64, 6, 5, 3, 200, 1, 1, 0);
          end
        end
        4: begin
          if (kind==1) begin
            plant_post(4, 32'hC00, 32'hC01, 32'hC10, 32'hC11, 0, 0);
            plant_index(4, F3R2_K0_SENS_REQ, F3R2_K2_SENSOR, 0, 0, 1'b0);
            wr_f(32'hC00, 12, 32'h71, 2, 200, 1, 1, 0);
            wr_f(32'hC01, 32'h71, 32'h87, 2, 200, 1, 1, 0);
            wr_f(32'hC10, 12, 32'h70, 2, 200, 1, 1, 1);
            wr_f(32'hC11, 32'h70, 32'h86, 2, 200, 1, 1, 1);
          end else if (kind==2) begin
            plant_post(2, 68, 72, 0, 0, 0, 0);
            plant_index(2, F3R2_K0_COMP_SUP, F3R2_K2_COMP, 0, 0, 1'b0);
            wr_f(68, 4, 32'h27, 1, 200, 0, 1, 0);
            wr_f(72, 4, 32'h26, 1, 200, 0, 1, 3);
          end else begin
            plant_post(2, 70, 71, 0, 0, 0, 0);
            plant_index(2, F3R2_K0_COMP_SUP, F3R2_K2_COMP, 0, 0, 1'b0);
            wr_f(70, 4, 32'h26, 1, 200, 0, 1, 3);
            wr_f(71, 4, 32'h27, 1, 200, 0, 1, 0);
          end
        end
        default: ;
      endcase
    end
  endtask

  task automatic send_q(input int seed, input bit hold);
    begin
      if (hold) begin
        unique case (seed)
          0: send_text("pump requires water");
          1: send_text("chiller requires indirect");
          2: send_text("valve requires indirect evaporator");
          3: send_text("tower requires indirect");
          4: send_text("sensor requires indirect");
          default: send_text("pump requires water");
        endcase
      end else begin
        unique case (seed)
          0: send_text("pump requires indirect");
          1: send_text("valve supplies water");
          2: send_text("pump requires indirect compressor");
          3: send_text("ahu connects indirect");
          4: send_text("compressor supplies air");
          default: send_text("pump requires indirect");
        endcase
      end
    end
  endtask

  task automatic q_s(input int seed, input int kind);
    begin
      plant_world(seed, kind);
      send_q(seed, kind==1);
      wait_done();
      n_rank = n_rank + 1;
      if (st==ST_ANSWER) n_ans = n_ans + 1;
    end
  endtask

  function automatic logic [19:0] gold_p0(input int seed, input int kind);
    begin
      unique case (seed)
        0: gold_p0 = (kind==1) ? F3R2_S0_HO_G : ((kind==2) ? F3R2_S0_SH_G : F3R2_S0_TR_G);
        1: gold_p0 = (kind==1) ? F3R2_S1_HO_G : ((kind==2) ? F3R2_S1_SH_G : F3R2_S1_TR_G);
        2: gold_p0 = (kind==1) ? F3R2_S2_HO_G : ((kind==2) ? F3R2_S2_SH_G : F3R2_S2_TR_G);
        3: gold_p0 = (kind==1) ? F3R2_S3_HO_G : ((kind==2) ? F3R2_S3_SH_G : F3R2_S3_TR_G);
        4: gold_p0 = (kind==1) ? F3R2_S4_HO_G : ((kind==2) ? F3R2_S4_SH_G : F3R2_S4_TR_G);
        default: gold_p0 = 20'd0;
      endcase
    end
  endfunction
  function automatic logic [19:0] dist_p0(input int seed, input int kind);
    begin
      unique case (seed)
        0: dist_p0 = (kind==1) ? F3R2_S0_HO_D : ((kind==2) ? F3R2_S0_SH_D : F3R2_S0_TR_D);
        1: dist_p0 = (kind==1) ? F3R2_S1_HO_D : ((kind==2) ? F3R2_S1_SH_D : F3R2_S1_TR_D);
        2: dist_p0 = (kind==1) ? F3R2_S2_HO_D : ((kind==2) ? F3R2_S2_SH_D : F3R2_S2_TR_D);
        3: dist_p0 = (kind==1) ? F3R2_S3_HO_D : ((kind==2) ? F3R2_S3_SH_D : F3R2_S3_TR_D);
        4: dist_p0 = (kind==1) ? F3R2_S4_HO_D : ((kind==2) ? F3R2_S4_SH_D : F3R2_S4_TR_D);
        default: dist_p0 = 20'd0;
      endcase
    end
  endfunction
  function automatic logic [19:0] gold_ans_h(input int seed);
    begin
      unique case (seed)
        0: gold_ans_h = F3R2_S0_HO_ANS;
        1: gold_ans_h = F3R2_S1_HO_ANS;
        2: gold_ans_h = F3R2_S2_HO_ANS;
        3: gold_ans_h = F3R2_S3_HO_ANS;
        4: gold_ans_h = F3R2_S4_HO_ANS;
        default: gold_ans_h = 20'd0;
      endcase
    end
  endfunction
  function automatic logic [19:0] dist_ans_h(input int seed);
    begin
      unique case (seed)
        0: dist_ans_h = F3R2_S0_HO_DANS;
        1: dist_ans_h = F3R2_S1_HO_DANS;
        2: dist_ans_h = F3R2_S2_HO_DANS;
        3: dist_ans_h = F3R2_S3_HO_DANS;
        4: dist_ans_h = F3R2_S4_HO_DANS;
        default: dist_ans_h = 20'd0;
      endcase
    end
  endfunction
  function automatic bit phi_same();
    integer k; begin
      phi_same = 1'b1;
      for (k=0;k<32;k=k+1) if (trphi[k] !== hophi[k]) phi_same = 1'b0;
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
  function automatic bit pid_picks_hold_gold(input int seed);
    int pg, pd; begin
      pg = pidmap[gold_ans_h(seed)[7:0]];
      pd = pidmap[dist_ans_h(seed)[7:0]];
      pid_picks_hold_gold = (pg > pd) || ((pg==pd) && (gold_p0(seed,1) < dist_p0(seed,1)));
    end
  endfunction

  task automatic run_seed(input int seed);
    string qs;
    integer k;
    begin
      qs = $sformatf("S%0d", seed);
      for (k=0;k<256;k=k+1) pidmap[k]=0;

      hard_rst();
      q_s(seed, 1);
      dump({qs, "_FR_HOLD"});
      chk({qs, "_FR_ANSWER"}, (st===ST_ANSWER) && !tbl && (npath>=5'd1));
      chk({qs, "_FR_DIST"}, p0===dist_p0(seed,1));
      if (p0===gold_p0(seed,1)) fr_c = fr_c + 1;
      retire_q();

      hard_rst();
      q_s(seed, 0);
      dump({qs, "_EN_TRAIN"});
      chk({qs, "_EN_TRAIN_GOLD"}, (st===ST_ANSWER) && !tbl && (p0===gold_p0(seed,0)));
      for (k=0;k<32;k=k+1) trphi[k]=pphi[k];
      if (ans[19:8]==12'd0) pidmap[ans[7:0]] = pidmap[ans[7:0]] + 3;
      pulse_rew(3); wait_upd(1); retire_q();
      q_s(seed, 1);
      dump({qs, "_EN_HOLD_E1"});
      chk({qs, "_EN_HOLD_GOLD"}, (st===ST_ANSWER) && !tbl && (p0===gold_p0(seed,1)));
      for (k=0;k<32;k=k+1) hophi[k]=pphi[k];
      chk({qs, "_PHI_NEQ"}, !phi_same());
      if (!phi_same()) phi_neq_c = phi_neq_c + 1;
      if (p0===gold_p0(seed,1)) en_e1 = en_e1 + 1;
      if (pid_picks_hold_gold(seed)) pid_c = pid_c + 1;
      $display("%s_PID pg=%0d pd=%0d pick_gold=%0d", qs, pidmap[gold_ans_h(seed)[7:0]],
        pidmap[dist_ans_h(seed)[7:0]], pid_picks_hold_gold(seed));
      retire_q();

      q_s(seed, 0);
      dump({qs, "_EN_TRAIN_E2"});
      chk({qs, "_EN_TRAIN_E2_GOLD"}, p0===gold_p0(seed,0));
      pulse_rew(3); wait_upd(2); retire_q();
      q_s(seed, 1);
      dump({qs, "_EN_HOLD_E2"});
      chk({qs, "_EN_HOLD_E2_GOLD"}, (st===ST_ANSWER) && (p0===gold_p0(seed,1)));
      if (p0===gold_p0(seed,1)) en_e2 = en_e2 + 1;
      snap_w();
      retire_q();

      hard_rst();
      load_w_snap();
      q_s(seed, 1);
      dump({qs, "_EN_HOLD_RL"});
      chk({qs, "_EN_HOLD_RL_GOLD"}, (st===ST_ANSWER) && !tbl && (p0===gold_p0(seed,1)));
      if (p0===gold_p0(seed,1)) en_rl = en_rl + 1;
      retire_q();

      hard_rst();
      q_s(seed, 2);
      dump({qs, "_SH_TRAIN"});
      chk({qs, "_SH_TRAIN_DIST"}, (st===ST_ANSWER) && (p0===dist_p0(seed,2)));
      pulse_rew(3); wait_upd(1); retire_q();
      q_s(seed, 1);
      dump({qs, "_SH_HOLD"});
      chk({qs, "_SH_HOLD_NOT_GOLD"}, (st===ST_ANSWER) && (p0!==gold_p0(seed,1)));
      if (p0===gold_p0(seed,1)) sh_c = sh_c + 1;
      retire_q();
    end
  endtask

  initial begin
    fail=0; first_div=""; nslot=0; ctrl=0; tok_v=0; fire=0; retire=0;
    rew_v=0; rew=0; rew_txn=0; rew_gen=0; live_ep=16'd7;
    load_v=0; load_idx=0; load_w=0;
    go_s=0; go_u=0; iso_load=0; iso_rew=0; rst_n=0;
    en_e1=0; en_e2=0; en_rl=0; fr_c=0; sh_c=0; pid_c=0; phi_neq_c=0; n_rank=0; n_ans=0;
    for(i=0;i<32;i=i+1) begin xiso[i]=0; wsnap[i]=0; trphi[i]=0; hophi[i]=0; end
    for(i=0;i<256;i=i+1) pidmap[i]=0;
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
    plant_world(0, 0);
    send_text("payroll tax form"); wait_done();
    dump("UNREL");
    chk("UNREL_UNKNOWN", (st===ST_UNKNOWN) && (npath==5'd0) && (ans===20'd0) && (p0===20'd0) && !tbl);
    chk("ISO_DUT_W0_CLEARED_LAST", wdut[0]===16'sd0);

    $display("METRICS en_e1=%0d/5 en_e2=%0d/5 en_rl=%0d/5 fr=%0d/5 sh=%0d/5 pid=%0d/5 phi_neq=%0d/5 n_rank=%0d n_ans=%0d",
      en_e1, en_e2, en_rl, fr_c, sh_c, pid_c, phi_neq_c, n_rank, n_ans);
    chk("EN_E1_5", en_e1==5);
    chk("FR_HOLD_0", fr_c==0);
    chk("SH_HOLD_0", sh_c==0);
    chk("PID_HOLD_0", pid_c==0);
    chk("PHI_NEQ_5", phi_neq_c==5);
    chk("EN_E2_5", en_e2==5);
    chk("EN_RL_5", en_rl==5);

    if (fail==0) $display("ASTRA_F3R2_INDEPENDENT_WORLDS_XSIM_PASS");
    else $display("ASTRA_F3R2_INDEPENDENT_WORLDS_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $finish;
  end
endmodule
