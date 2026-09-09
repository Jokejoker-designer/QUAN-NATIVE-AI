// tb_astra06_sgd.sv — shared 32-feature SGD vs freeze/shuffle. PROGRAM=NO.
`timescale 1ns / 1ps

module tb_astra06_sgd;
  logic clk, rst_n, freeze, go_s, go_u, ready, done;
  logic signed [7:0] x [0:31];
  logic signed [2:0] rew;
  logic signed [15:0] v;
  integer k, t, fail;
  logic signed [15:0] v_en, v_fr, v_sh;

  a7ng_shared_rank_sgd_q8 dut (
    .clk(clk), .rst_n(rst_n), .freeze_i(freeze),
    .go_score_i(go_s), .go_upd_i(go_u), .x_i(x), .reward_i(rew),
    .ready_o(ready), .done_o(done), .v_q8_o(v)
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
      begin : w
        integer tmo;
        tmo = 0;
        while (!done) begin
          @(posedge clk);
          tmo = tmo + 1;
          if (tmo > 4000) diverge("TIMEOUT", "");
        end
      end
      @(posedge clk);
    end
  endtask

  initial begin
    fail = 0;
    rst_n = 0; freeze = 0; go_s = 0; go_u = 0; rew = 0;
    for (k = 0; k < 32; k = k + 1)
      x[k] = 8'sd64;
    repeat (4) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);

    freeze = 1;
    kick(0);
    v_fr = v;
    if (v_fr !== 16'sd0)
      diverge("ZERO_WEIGHT", $sformatf("v=%0d", v_fr));
    $display("T_FROZEN_ZERO v=%0d", v_fr);

    freeze = 0;
    rew = 3'sd3;
    for (t = 0; t < 16; t = t + 1)
      kick(1);
    kick(0);
    v_en = v;
    if (v_en <= 16'sd0)
      diverge("ENABLED", $sformatf("v=%0d", v_en));
    $display("T_ENABLED v=%0d", v_en);

    rst_n = 0;
    repeat (4) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);
    freeze = 0;
    for (t = 0; t < 16; t = t + 1) begin
      rew = (t[0]) ? 3'sd3 : -3'sd3;
      kick(1);
    end
    kick(0);
    v_sh = v;
    if (v_en <= v_sh)
      diverge("SHUFFLE", $sformatf("enabled=%0d shuffle=%0d", v_en, v_sh));
    $display("T_SHUFFLE enabled=%0d shuffle=%0d", v_en, v_sh);

    $display("ASTRA06_SGD_XSIM_PASS");
    $display("NOT_CLAIMED=held_out,board,hides_retrieval");
    #20 $finish;
  end
endmodule
