// tb_astra_c3_pend_phi_pipe.sv — integer GOLDEN for c3_pend_phi. PROGRAM=NO.
`timescale 1ns / 1ps
`include "a7ng_astra_c3_held_out.svh"
`include "expected.svh"

module tb_astra_c3_pend_phi_pipe;
  logic clk, rst_n, tok_r, busy, resv, acc, cmt, pok, lftb, rr;
  logic [7:0] txn, gen, obj, ctx, subj;
  logic [3:0] st, arid, rid;
  logic [1:0] sel, dir, arb;
  logic [19:0] ans, p0, p1, src, dst;
  logic [4:0] npath;
  logic [2:0] arsz;
  logic [15:0] nhw, nha, nupd, ndup, nbad;
  logic signed [15:0] vb, vs;
  logic signed [7:0] phi0;
  logic signed [7:0] phi_o [0:31];
  logic signed [15:0] ww [0:31];
  logic [27:0] ara;
  logic [7:0] arlen;
  logic arv;
  integer k, v, tmo, fail, i;

  a7ng_astra_c3_held_out_pendld u_c3 (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7), .ctrl_i(2'd0),
    .tok_valid_i(1'b0), .tok_ready_o(tok_r), .tok_i(8'd0),
    .fire_i(1'b0), .retire_i(1'b0),
    .rew_v_i(1'b0), .rew_i(4'sd0), .rew_txn_i(8'd0), .rew_gen_i(8'd0),
    .load_v_i(1'b0), .load_idx_i(5'd0), .load_w_i(16'sd0),
    .phi_load_v_i(1'b0), .phi_idx_i(5'd0), .phi_w_i(8'sd0),
    .pend_load_v_i(1'b0),
    .pend_p0_i(20'd0), .pend_p1_i(20'd0), .pend_ans_i(20'd0),
    .pend_sel_i(2'd0), .pend_st_i(4'd0), .pend_txn_i(8'd0), .pend_gen_i(8'd0),
    .pend_acc_i(1'b0), .pend_cmt_i(1'b0), .clr_pend_i(1'b0),
    .busy_o(busy), .result_v_o(resv),
    .pend_acc_o(acc), .pend_cmt_o(cmt),
    .txn_id_o(txn), .gen_o(gen), .sel_idx_o(sel),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1),
    .src_ent_o(src), .dst_ent_o(dst),
    .n_path_o(npath), .status_o(st), .proof_ok_o(pok), .direction_o(dir),
    .obj_o(obj), .ctx_o(ctx), .subj_o(subj),
    .n_host_winner_o(nhw), .n_host_addr_o(nha),
    .v_best_o(vb), .v_second_o(vs), .phi0_o(phi0),
    .pend_phi_o(phi_o), .w_o(ww),
    .n_upd_o(nupd), .n_dup_o(ndup), .n_bad_o(nbad), .load_from_tb_o(lftb),
    .m_axi_arid(arid), .m_axi_araddr(ara), .m_axi_arlen(arlen),
    .m_axi_arsize(arsz), .m_axi_arburst(arb),
    .m_axi_arvalid(arv), .m_axi_arready(1'b1),
    .m_axi_rid(4'd0), .m_axi_rdata(128'd0), .m_axi_rresp(2'b00),
    .m_axi_rlast(1'b0), .m_axi_rvalid(1'b0), .m_axi_rready(rr)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  task automatic diverge(input string c, input string d);
    begin
      $display("FIRST_DIVERGENCE %s %s", c, d);
      fail = fail + 1;
      #20 $finish;
    end
  endtask

  task automatic load_vec(input int vi);
    begin
      u_c3.np = EXP_NP[vi];
      for (k = 0; k < 4; k = k + 1) begin
        u_c3.pv[k] = EXP_PV[vi][k];
        u_c3.pp0[k] = EXP_PP0[vi][k];
        u_c3.pp1[k] = EXP_PP1[vi][k];
        u_c3.pans[k] = EXP_PANS[vi][k];
        u_c3.psrc[k] = EXP_SRC[vi][k];
        u_c3.pdst[k] = EXP_DST[vi][k];
        for (i = 0; i < 32; i = i + 1) u_c3.phis[k][i] = EXP_PHIS[vi][k][i];
      end
    end
  endtask

  // Deposit, not force: force holds st and drops the NBA to S_COMMIT/S_HOLD.
  task automatic kick_pick(input int vi);
    begin
      @(negedge clk);
      load_vec(vi);
      #1;
      begin : poke_pick
        logic [3:0] poke;
        poke = ST_PICK[3:0];
        if (!$cast(u_c3.st, poke))
          diverge("CAST_ST", $sformatf("%0d", poke));
      end
      @(posedge clk);
      tmo = 0;
      while (!resv) begin
        @(posedge clk);
        tmo = tmo + 1;
        if (tmo > 32)
          diverge("TIMEOUT", $sformatf("st=%0d resv=%0d", u_c3.st, resv));
      end
    end
  endtask

  initial begin
    fail = 0;
    rst_n = 0;
    repeat (4) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);

    for (v = 0; v < N_VEC; v = v + 1) begin
      kick_pick(v);
      if (sel !== EXP_IDX[v]) diverge("SEL", $sformatf("v=%0d got=%0d exp=%0d", v, sel, EXP_IDX[v]));
      if (ans !== EXP_A[v]) diverge("ANS", $sformatf("v=%0d", v));
      if (p0 !== EXP_P0[v]) diverge("P0", $sformatf("v=%0d", v));
      if (p1 !== EXP_P1[v]) diverge("P1", $sformatf("v=%0d", v));
      if (src !== EXP_SRC_W[v]) diverge("SRC", $sformatf("v=%0d", v));
      if (dst !== EXP_DST_W[v]) diverge("DST", $sformatf("v=%0d", v));
      if (vb !== EXP_VB[v]) diverge("VB", $sformatf("v=%0d got=%0d exp=%0d", v, vb, EXP_VB[v]));
      if (vs !== EXP_V2[v]) diverge("V2", $sformatf("v=%0d", v));
      if (st !== A7NG_C3_ST_ANSWER) diverge("STATUS", $sformatf("v=%0d", v));
      if (!pok) diverge("PROOF", $sformatf("v=%0d", v));
      for (i = 0; i < 32; i = i + 1) begin
        if (phi_o[i] !== EXP_PHI_WIN[v][i])
          diverge("PHI", $sformatf("v=%0d i=%0d got=%0d exp=%0d", v, i, phi_o[i], EXP_PHI_WIN[v][i]));
      end
      $display("T_VEC %0d idx=%0d ans=%0d", v, sel, ans);
      @(posedge clk);
      rst_n = 0;
      repeat (2) @(posedge clk);
      rst_n = 1;
      repeat (2) @(posedge clk);
    end

    if (fail != 0) diverge("FAILN", $sformatf("%0d", fail));
    $display("ASTRA_C3_PEND_PHI_PIPE_XSIM_PASS");
    $display("C4_MASTER=OPEN C5_MASTER=OPEN C6_MASTER=OPEN PROGRAM=NO E3AB=DO_NOT_START");
    $finish;
  end
endmodule
