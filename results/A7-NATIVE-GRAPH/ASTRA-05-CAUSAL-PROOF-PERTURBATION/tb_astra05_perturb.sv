// tb_astra05_perturb.sv — corpus mutation must change the derived answer. PROGRAM=NO.
`timescale 1ns / 1ps

module tb_astra05_perturb;
  `include "ids.svh"
  localparam int unsigned ID_W = 8;
  localparam logic [2:0] ST_ANSWER     = 3'd0;
  localparam logic [2:0] ST_UNKNOWN    = 3'd1;
  localparam logic [2:0] ST_CONFLICT   = 3'd5;
  localparam logic [2:0] ST_INCOMPLETE = 3'd6;

  logic clk, rst_n, load_v, clr_v, q_v, q_ready, ans_v, q_obj_v, q_two, load_pol, load_trans;
  logic [3:0] lidx, cidx, q_max_hop;
  logic [7:0] ls, lr, lo, leid, qs, qr, qo, ans, p0, p1, q_budget, scan_used;
  logic [2:0] st;
  integer fail;

  a7ng_rel_engine_2hop #(.N_EDGES(16), .ID_W(ID_W)) dut (
    .clk(clk), .rst_n(rst_n),
    .load_v(load_v), .load_idx(lidx),
    .load_s(ls), .load_r(lr), .load_o(lo), .load_eid(leid),
    .load_trans(load_trans), .load_pol(load_pol),
    .clr_v(clr_v), .clr_idx(cidx),
    .q_v(q_v), .q_s(qs), .q_r(qr), .q_o(qo),
    .q_obj_valid(q_obj_v), .q_two_hop(q_two),
    .q_budget(q_budget), .q_max_hop(q_max_hop),
    .q_ready(q_ready), .ans_v(ans_v), .ans_o(ans), .proof0(p0), .proof1(p1),
    .status_o(st), .scan_used_o(scan_used)
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

  task automatic load_e(
    input int idx, input int s, input int r, input int o, input int e,
    input int tr, input int pol
  );
    begin
      while (!q_ready) @(posedge clk);
      @(posedge clk);
      lidx <= idx[3:0];
      ls <= s[7:0]; lr <= r[7:0]; lo <= o[7:0]; leid <= e[7:0];
      load_trans <= tr[0]; load_pol <= pol[0];
      load_v <= 1'b1;
      @(posedge clk);
      load_v <= 1'b0;
    end
  endtask

  task automatic clr_e(input int idx);
    begin
      while (!q_ready) @(posedge clk);
      @(posedge clk);
      cidx <= idx[3:0];
      clr_v <= 1'b1;
      @(posedge clk);
      clr_v <= 1'b0;
    end
  endtask

  task automatic ask(
    input int s, input int r, input int o, input int ov, input int two,
    input int budg, input int hop
  );
    begin
      while (!q_ready) @(posedge clk);
      @(posedge clk);
      qs <= s[7:0]; qr <= r[7:0]; qo <= o[7:0];
      q_obj_v <= ov[0]; q_two <= two[0];
      q_budget <= budg[7:0]; q_max_hop <= hop[3:0];
      q_v <= 1'b1;
      @(posedge clk);
      q_v <= 1'b0;
      begin : wans
        integer tmo;
        tmo = 0;
        while (!ans_v) begin
          @(posedge clk);
          tmo = tmo + 1;
          if (tmo > 4000) diverge("NO_ANS", "timeout");
        end
      end
    end
  endtask

  task automatic dump_case(input string cname);
    $display("ASTRA05_CASE %s st=%0d ans=%0d p0=%0d p1=%0d scan=%0d",
             cname, st, ans, p0, p1, scan_used);
  endtask

  initial begin
    fail = 0;
    rst_n = 0; load_v = 0; clr_v = 0; q_v = 0; q_obj_v = 0; q_two = 0;
    load_trans = 1; load_pol = 1;
    lidx = 0; cidx = 0; ls = 0; lr = 0; lo = 0; leid = 0;
    qs = 0; qr = 0; qo = 0; q_budget = 0; q_max_hop = 0;
    repeat (4) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);

    load_e(0, A5_READ_A, A5_REL_REQ, A5_READY_B, A5_EID_AB, 1, 1);
    load_e(1, A5_READY_B, A5_REL_REQ, A5_CALIB_C, A5_EID_BC, 1, 1);

    ask(A5_READ_A, A5_REL_REQ, 0, 0, 1, 0, 0);
    dump_case("BASE");
    if (st !== ST_ANSWER || ans !== A5_CALIB_C || p0 !== A5_EID_AB || p1 !== A5_EID_BC)
      diverge("BASE", $sformatf("st=%0d ans=%0d p0=%0d p1=%0d", st, ans, p0, p1));
    $display("T_BASE PASS");

    ask(A5_READ_A, A5_REL_REQ, A5_CALIB_C, 1, 0, 0, 0);
    dump_case("BASE_NOT_STORED");
    if (st !== ST_UNKNOWN || ans === A5_CALIB_C)
      diverge("BASE_NOT_STORED", $sformatf("st=%0d ans=%0d", st, ans));
    $display("T_BASE_NOT_STORED PASS");

    clr_e(1);
    ask(A5_READ_A, A5_REL_REQ, 0, 0, 1, 0, 0);
    dump_case("DEL");
    if (st !== ST_UNKNOWN)
      diverge("DEL", $sformatf("st=%0d", st));
    if (ans === A5_CALIB_C || st === ST_ANSWER)
      diverge("DEL_KEPT_C", $sformatf("st=%0d ans=%0d", st, ans));
    $display("T_DEL PASS");

    load_e(1, A5_READY_B, A5_REL_REQ, A5_CALIB_D, A5_EID_BD, 1, 1);
    ask(A5_READ_A, A5_REL_REQ, 0, 0, 1, 0, 0);
    dump_case("REP");
    if (st !== ST_ANSWER || ans !== A5_CALIB_D)
      diverge("REP", $sformatf("st=%0d ans=%0d", st, ans));
    if (p1 === A5_EID_BC || p1 !== A5_EID_BD || p0 !== A5_EID_AB)
      diverge("REP_PROOF", $sformatf("p0=%0d p1=%0d", p0, p1));
    if (ans === A5_CALIB_C)
      diverge("REP_STILL_C", "");
    $display("T_REP PASS");

    load_e(1, A5_READY_B, A5_REL_REQ, A5_CALIB_C, A5_EID_BC, 1, 1);
    load_e(2, A5_READY_B, A5_REL_REQ, A5_CALIB_C, A5_EID_NEG, 0, 0);
    ask(A5_READ_A, A5_REL_REQ, 0, 0, 1, 0, 0);
    dump_case("CONF_NEG");
    if (st !== ST_CONFLICT)
      diverge("CONF_NEG", $sformatf("st=%0d", st));
    if (st === ST_ANSWER || ans === A5_CALIB_C)
      diverge("CONF_NEG_ANSWER", $sformatf("st=%0d ans=%0d", st, ans));
    $display("T_CONF_NEG PASS");

    load_e(2, A5_READY_B, A5_REL_REQ, A5_CALIB_D, A5_EID_BD, 1, 1);
    ask(A5_READ_A, A5_REL_REQ, 0, 0, 1, 0, 0);
    dump_case("CONF_TWO");
    if (st !== ST_CONFLICT)
      diverge("CONF_TWO", $sformatf("st=%0d", st));
    $display("T_CONF_TWO PASS");

    clr_e(2);
    load_e(1, A5_READY_B, A5_REL_REQ, A5_CALIB_C, A5_EID_BC, 1, 1);
    ask(A5_READ_A, A5_REL_REQ, 0, 0, 1, 1, 0);
    dump_case("CAP");
    if (st !== ST_INCOMPLETE)
      diverge("CAP", $sformatf("st=%0d", st));
    if (st === ST_UNKNOWN || st === ST_ANSWER || ans === A5_CALIB_C)
      diverge("CAP_FALSE", $sformatf("st=%0d ans=%0d", st, ans));
    $display("T_CAP PASS");

    ask(A5_READ_A, A5_REL_REQ, 0, 0, 1, 0, 1);
    dump_case("CAP_HOP");
    if (st !== ST_INCOMPLETE || ans === A5_CALIB_C)
      diverge("CAP_HOP", $sformatf("st=%0d ans=%0d", st, ans));
    $display("T_CAP_HOP PASS");

    ask(A5_READ_A, A5_REL_REQ, 0, 0, 1, 0, 0);
    dump_case("CAP_RESTORE");
    if (st !== ST_ANSWER || ans !== A5_CALIB_C)
      diverge("CAP_RESTORE", $sformatf("st=%0d ans=%0d", st, ans));
    $display("T_CAP_RESTORE PASS");

    load_e(1, A5_CALIB_C, A5_REL_REQ, A5_READY_B, A5_EID_BC, 1, 1);
    ask(A5_READ_A, A5_REL_REQ, 0, 0, 1, 0, 0);
    dump_case("INV");
    if (st === ST_ANSWER || ans === A5_CALIB_C)
      diverge("INV_KEPT_C", $sformatf("st=%0d ans=%0d", st, ans));
    if (st !== ST_UNKNOWN)
      diverge("INV", $sformatf("st=%0d", st));
    $display("T_INV PASS");

    clr_e(0);
    clr_e(1);
    load_e(0, A5_RND_X, A5_REL_REQ, A5_RND_Y, A5_RND_E0, 1, 1);
    load_e(1, A5_RND_Y, A5_REL_REQ, A5_RND_Z, A5_RND_E1, 1, 1);
    ask(A5_RND_X, A5_REL_REQ, 0, 0, 1, 0, 0);
    dump_case("RND");
    if (st !== ST_ANSWER || ans !== A5_RND_Z || p0 !== A5_RND_E0 || p1 !== A5_RND_E1)
      diverge("RND", $sformatf("st=%0d ans=%0d p0=%0d p1=%0d", st, ans, p0, p1));
    $display("T_RND PASS");

    $display("ASTRA05_CAUSAL_XSIM_PASS");
    $display("NOT_CLAIMED=open_world_causality,ddr_graph,lm,gate14,board");
    #20 $finish;
  end
endmodule
