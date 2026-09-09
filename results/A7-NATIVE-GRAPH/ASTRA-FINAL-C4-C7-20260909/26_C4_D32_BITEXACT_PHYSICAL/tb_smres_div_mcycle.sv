`timescale 1ns / 1ps
// Unit TB for a7ng_astra_c4_smres_div_mcycle. PROGRAM=NO.
// iverilog-safe. Do not run xvlog/xsim while bag 26 OOC holds BASIC license.
module tb_smres_div_mcycle;
  logic clk, rst_n, start, busy, done;
  logic signed [31:0] elut, eden, q;
  logic [5:0] idx_i, idx_o;
  integer i, fail, guard, got, exp;
  integer ELUT [0:12];
  integer EDEN [0:12];
  integer GOLD [0:12];

  a7ng_astra_c4_smres_div_mcycle u_dut (
    .clk(clk), .rst_n(rst_n), .start_i(start),
    .elut_i(elut), .eden_i(eden), .idx_i(idx_i),
    .busy_o(busy), .done_o(done), .q_o(q), .idx_o(idx_o)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    fail = 0;
    rst_n = 1'b0;
    start = 1'b0;
    elut = 0; eden = 0; idx_i = 0;
    ELUT[0] = 0;      EDEN[0] = 0;         GOLD[0] = 0;
    ELUT[1] = 1;      EDEN[1] = 0;         GOLD[1] = 0;
    ELUT[2] = 32767;  EDEN[2] = 0;         GOLD[2] = 0;
    ELUT[3] = 0;      EDEN[3] = 1;         GOLD[3] = 0;
    ELUT[4] = 1;      EDEN[4] = 1;         GOLD[4] = 32767;
    ELUT[5] = 32767;  EDEN[5] = 1;         GOLD[5] = 1073676289;
    ELUT[6] = 32767;  EDEN[6] = 32767;     GOLD[6] = 32767;
    ELUT[7] = 100;    EDEN[7] = 3;         GOLD[7] = 1092233;
    ELUT[8] = 7;      EDEN[8] = 2;         GOLD[8] = 114685;
    ELUT[9] = 1;      EDEN[9] = 2;         GOLD[9] = 16384;
    ELUT[10] = 32767; EDEN[10] = 786408;   GOLD[10] = 1365;
    ELUT[11] = -100;  EDEN[11] = 3;        GOLD[11] = -1092233;
    ELUT[12] = 100;   EDEN[12] = -3;       GOLD[12] = -1092233;
    repeat (4) @(posedge clk);
    rst_n = 1'b1;
    @(posedge clk);
    for (i = 0; i < 13; i = i + 1) begin
      elut = ELUT[i];
      eden = EDEN[i];
      idx_i = i[5:0];
      start = 1'b1;
      @(posedge clk);
      start = 1'b0;
      guard = 0;
      while (!done && guard < 64) begin
        @(posedge clk);
        guard = guard + 1;
      end
      got = q;
      exp = GOLD[i];
      if (!done) begin
        $display("FAIL timeout i=%0d", i);
        fail = fail + 1;
      end else if ((got !== exp) || (idx_o !== i[5:0])) begin
        $display("FAIL i=%0d elut=%0d eden=%0d got=%0d gold=%0d idx=%0d", i, ELUT[i], EDEN[i], got, exp, idx_o);
        fail = fail + 1;
      end else $display("PASS i=%0d q=%0d cycles=%0d", i, got, guard);
      @(posedge clk);
    end
    if (fail == 0) $display("ASTRA_SMRES_DIV_MCYCLE_IVERILOG_PASS n=13 PROGRAM=NO NOT_INSTANTIATED");
    else $display("ASTRA_SMRES_DIV_MCYCLE_IVERILOG_FAIL nfail=%0d PROGRAM=NO", fail);
    $finish;
  end
endmodule
