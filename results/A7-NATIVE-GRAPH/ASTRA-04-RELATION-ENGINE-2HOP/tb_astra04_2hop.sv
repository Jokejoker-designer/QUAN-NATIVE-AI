// tb_astra04_2hop.sv — bounded requires-compose. PROGRAM=NO.
`timescale 1ns / 1ps

module tb_astra04_2hop;
  localparam int unsigned ID_W = 8;
  logic clk, rst_n, load_v, q_v, q_ready, ans_v, q_obj_v, q_two, clr_v;
  logic [3:0] lidx;
  logic [7:0] ls, lr, lo, leid, qs, qr, qo, ans, p0, p1;
  logic ltr;
  logic [2:0] st;
  integer fail;

  a7ng_rel_engine_2hop #(.N_EDGES(16), .ID_W(ID_W)) dut (
    .clk(clk), .rst_n(rst_n),
    .load_v(load_v), .load_idx(lidx),
    .load_s(ls), .load_r(lr), .load_o(lo), .load_eid(leid), .load_trans(ltr),
    .load_pol(1'b1),
    .clr_v(clr_v), .clr_idx(4'd0),
    .q_v(q_v), .q_s(qs), .q_r(qr), .q_o(qo), .q_obj_valid(q_obj_v), .q_two_hop(q_two),
    .q_budget(8'd0), .q_max_hop(4'd0),
    .q_ready(q_ready), .ans_v(ans_v), .ans_o(ans), .proof0(p0), .proof1(p1), .status_o(st),
    .scan_used_o()
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

  task automatic load_e(input int idx, input int s, input int r, input int o, input int e, input int tr);
    begin
      @(posedge clk);
      lidx <= idx[3:0]; ls <= s[7:0]; lr <= r[7:0]; lo <= o[7:0]; leid <= e[7:0]; ltr <= tr[0];
      load_v <= 1'b1;
      @(posedge clk);
      load_v <= 1'b0;
    end
  endtask

  task automatic ask(input int s, input int r, input int o, input int ov, input int two);
    begin
      while (!q_ready) @(posedge clk);
      @(posedge clk);
      qs <= s[7:0]; qr <= r[7:0]; qo <= o[7:0]; q_obj_v <= ov[0]; q_two <= two[0];
      q_v <= 1'b1;
      @(posedge clk);
      q_v <= 1'b0;
      begin : wans
        integer tmo;
        tmo = 0;
        while (!ans_v) begin
          @(posedge clk);
          tmo = tmo + 1;
          if (tmo > 2000) diverge("NO_ANS", "timeout");
        end
      end
    end
  endtask

  initial begin
    fail = 0;
    rst_n = 0; load_v = 0; q_v = 0; q_obj_v = 0; q_two = 0; clr_v = 0;
    lidx = 0; ls = 0; lr = 0; lo = 0; leid = 0; ltr = 0;
    qs = 0; qr = 0; qo = 0;
    repeat (4) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);

    // pump=10 requires chiller=1 ; chiller requires condenser=2
    load_e(0, 10, 2, 1, 1, 1);
    load_e(1, 1, 2, 2, 2, 1);
    load_e(2, 10, 1, 1, 3, 0); // supplies, non-transitive
    load_e(3, 10, 2, 1, 4, 1); // duplicate requires pump→chiller

    ask(10, 2, 1, 1, 0);
    if (st !== 3'd0 || ans !== 8'd1 || (p0 !== 8'd1 && p0 !== 8'd4))
      diverge("STORED_FACT", $sformatf("st=%0d ans=%0d p0=%0d", st, ans, p0));
    $display("T_STORED_FACT PASS");

    ask(10, 2, 0, 0, 0);
    if (st !== 3'd0 || ans !== 8'd1)
      diverge("1HOP", $sformatf("st=%0d ans=%0d", st, ans));
    $display("T_1HOP PASS");

    ask(10, 2, 2, 1, 1);
    if (st !== 3'd0 || ans !== 8'd2 || p1 !== 8'd2 || (p0 !== 8'd1 && p0 !== 8'd4))
      diverge("2HOP", $sformatf("st=%0d ans=%0d p0=%0d p1=%0d", st, ans, p0, p1));
    $display("T_2HOP PASS proof %0d %0d", p0, p1);

    ask(11, 2, 0, 0, 1);
    if (st !== 3'd1)
      diverge("MISSING", $sformatf("st=%0d", st));
    $display("T_MISSING PASS");

    ask(1, 2, 10, 1, 0);
    if (st !== 3'd2)
      diverge("WRONG_DIR", $sformatf("st=%0d", st));
    $display("T_WRONG_DIR PASS");

    ask(10, 1, 0, 0, 1);
    if (st !== 3'd3)
      diverge("NONTRANS", $sformatf("st=%0d", st));
    $display("T_NONTRANS PASS");

    load_e(4, 1, 2, 10, 5, 1);
    ask(10, 2, 10, 1, 1);
    if (st !== 3'd4)
      diverge("CYCLE", $sformatf("st=%0d", st));
    $display("T_CYCLE PASS");

    $display("ASTRA04_2HOP_XSIM_PASS");
    $display("NOT_CLAIMED=board,lm,open_nlu");
    #20 $finish;
  end
endmodule
