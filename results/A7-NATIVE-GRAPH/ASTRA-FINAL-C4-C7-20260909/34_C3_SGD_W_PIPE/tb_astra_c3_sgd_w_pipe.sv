// tb_astra_c3_sgd_w_pipe.sv — integer GOLDEN for c3_sgd_w pipe. PROGRAM=NO.
`timescale 1ns / 1ps
`include "expected.svh"

module tb_astra_c3_sgd_w_pipe;
  logic clk, rst_n, freeze, go_s, go_u, load_v, ready, done;
  logic signed [7:0] x [0:31];
  logic signed [3:0] rew;
  logic [4:0] load_idx;
  logic signed [15:0] load_w;
  logic signed [15:0] w_o [0:31];
  logic signed [15:0] v;
  integer k, t, fail, tmo;

  a7ng_shared_rank_sgd_q8_sym_f2r2 dut (
    .clk(clk), .rst_n(rst_n), .freeze_i(freeze),
    .go_score_i(go_s), .go_upd_i(go_u), .x_i(x), .reward_i(rew),
    .load_v_i(load_v), .load_idx_i(load_idx), .load_w_i(load_w),
    .w_o(w_o), .ready_o(ready), .done_o(done), .v_q8_o(v)
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

  task automatic kick(input int upd);
    begin
      while (!ready) @(posedge clk);
      @(posedge clk);
      go_s <= (upd == 0);
      go_u <= (upd != 0);
      @(posedge clk);
      go_s <= 1'b0;
      go_u <= 1'b0;
      tmo = 0;
      while (!done) begin
        @(posedge clk);
        tmo = tmo + 1;
        if (tmo > 4000) diverge("TIMEOUT", "");
      end
      @(posedge clk);
    end
  endtask

  task automatic load_one(input [4:0] idx, input signed [15:0] val);
    begin
      while (!ready) @(posedge clk);
      @(posedge clk);
      load_v <= 1'b1; load_idx <= idx; load_w <= val;
      @(posedge clk);
      load_v <= 1'b0;
    end
  endtask

  initial begin
    fail = 0;
    rst_n = 0; freeze = 0; go_s = 0; go_u = 0; rew = 0;
    load_v = 0; load_idx = 0; load_w = 0;
    for (k = 0; k < 32; k = k + 1) x[k] = 8'sd64;
    repeat (4) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);

    freeze = 1;
    kick(0);
    if (v !== EXP_V_FR)
      diverge("ZERO_WEIGHT", $sformatf("v=%0d exp=%0d", v, EXP_V_FR));
    $display("T_FROZEN_ZERO v=%0d", v);

    freeze = 0;
    rew = 4'sd3;
    for (t = 0; t < 16; t = t + 1) kick(1);
    kick(0);
    if (v !== EXP_V_EN)
      diverge("ENABLED", $sformatf("v=%0d exp=%0d", v, EXP_V_EN));
    $display("T_ENABLED v=%0d", v);

    rst_n = 0;
    repeat (4) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);
    rew = 4'sd3;
    for (t = 0; t < 16; t = t + 1) begin
      rew = ((t & 1) != 0) ? 4'sd3 : -4'sd3;
      kick(1);
    end
    kick(0);
    if (v !== EXP_V_SH)
      diverge("SHUFFLE", $sformatf("v=%0d exp=%0d", v, EXP_V_SH));
    $display("T_SHUFFLE v=%0d", v);

    rst_n = 0;
    repeat (4) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);
    for (k = 0; k < 32; k = k + 1) begin
      load_one(k[4:0], 16'(k * 17) - 16'sd80);
      x[k] = 8'(((k * 13) % 127) - 64);
    end
    rew = 4'sd2;
    kick(1);
    if (v !== EXP_V_MX)
      diverge("MIXED_V", $sformatf("v=%0d exp=%0d", v, EXP_V_MX));
    for (k = 0; k < 32; k = k + 1)
      if (w_o[k] !== EXP_W_MX[k])
        diverge("MIXED_W", $sformatf("k=%0d w=%0d exp=%0d", k, w_o[k], EXP_W_MX[k]));
    $display("T_MIXED v=%0d", v);

    freeze = 1;
    kick(1);
    for (k = 0; k < 32; k = k + 1)
      if (w_o[k] !== EXP_W_MX[k])
        diverge("FREEZE_W", $sformatf("k=%0d w=%0d", k, w_o[k]));
    $display("T_FREEZE_KEEP");

    if (fail != 0) diverge("FAIL_COUNT", $sformatf("%0d", fail));
    $display("ASTRA_C3_SGD_W_PIPE_XSIM_PASS");
    $display("C4_MASTER=OPEN C5_MASTER=OPEN C6_MASTER=OPEN PROGRAM=NO");
    $finish;
  end
endmodule
