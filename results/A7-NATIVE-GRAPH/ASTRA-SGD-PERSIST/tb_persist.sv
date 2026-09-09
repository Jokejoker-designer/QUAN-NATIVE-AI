`timescale 1ns / 1ps
module tb_persist;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic go_s, go_u, ready, done, load_v;
  logic signed [2:0] rew;
  logic [4:0] lidx;
  logic signed [15:0] lw, v;
  logic signed [7:0] x [0:31];
  logic signed [15:0] wo [0:31];
  logic signed [15:0] snap [0:31];
  integer i, fail;

  a7ng_shared_rank_sgd_q8_v1 u (
    .clk(clk), .rst_n(rst_n), .freeze_i(1'b0),
    .go_score_i(go_s), .go_upd_i(go_u), .x_i(x), .reward_i(rew),
    .load_v_i(load_v), .load_idx_i(lidx), .load_w_i(lw),
    .w_o(wo), .ready_o(ready), .done_o(done), .v_q8_o(v)
  );

  task wait_done; begin wait(done); @(posedge clk); end endtask

  initial begin
    fail=0; rst_n=0; go_s=0; go_u=0; load_v=0; rew=0; lidx=0; lw=0;
    for(i=0;i<32;i=i+1) x[i]=0;
    x[0]=8'sd64;
    repeat(4) @(posedge clk); rst_n=1; @(posedge clk); wait(ready);
    go_u=1; rew=3'sd3; @(posedge clk); go_u=0; wait_done();
    $display("AFTER_UPD v=%0d w0=%0d", v, wo[0]);
    if (wo[0]==0) begin $display("FAIL no weight change"); fail=fail+1; end
    for(i=0;i<32;i=i+1) snap[i]=wo[i];
    rst_n=0; repeat(4) @(posedge clk); rst_n=1; @(posedge clk); wait(ready);
    go_s=1; @(posedge clk); go_s=0; wait_done();
    $display("AFTER_RST_SCORE v=%0d (expect ~0)", v);
    if (v != 0) begin $display("FAIL rst did not clear"); fail=fail+1; end
    for(i=0;i<32;i=i+1) begin
      @(posedge clk); lidx=i[4:0]; lw=snap[i]; load_v=1; @(posedge clk); load_v=0;
    end
    @(posedge clk); wait(ready);
    go_s=1; @(posedge clk); go_s=0; wait_done();
    $display("AFTER_RELOAD v=%0d w0=%0d", v, wo[0]);
    if (wo[0]!==snap[0] || v==0) begin $display("FAIL persist"); fail=fail+1; end
    else $display("PASS PERSIST");
    if (fail==0) $display("ASTRA_SGD_PERSIST_XSIM_PASS");
    else $display("ASTRA_SGD_PERSIST_XSIM_FAIL n=%0d", fail);
    $finish;
  end
endmodule
