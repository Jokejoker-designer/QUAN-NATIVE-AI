`timescale 1ns / 1ps
// Unit TB: a7ng_astra_c4_rq_mcycle == D32 c4_rq. No c4_sat. PROGRAM=NO.
module tb_c4_rq_mcycle;
  logic clk, rst_n, start, busy, done;
  logic signed [63:0] val, q, gold;
  logic [31:0] mul;
  logic [5:0] shr;
  integer i, fail, guard;
  logic signed [63:0] VAL [0:8];
  logic [31:0] MUL [0:8];
  logic [5:0] SHR [0:8];

  a7ng_astra_c4_rq_mcycle u_dut (
    .clk(clk), .rst_n(rst_n), .start_i(start),
    .val_i(val), .mul_i(mul), .shr_i(shr),
    .busy_o(busy), .done_o(done), .q_o(q)
  );

  // Same prod assignment as D32 c4_rq. 64-bit truncate at this point.
  function automatic signed [63:0] gold_rq(
      input signed [63:0] v,
      input [31:0] m,
      input [5:0] s
  );
    logic signed [63:0] prod;
    logic [63:0] mag, qq, half, mask;
    begin
      prod = v * $signed(64'(m));
      if (s == 6'd0) gold_rq = prod;
      else begin
        mag = prod[63] ? (~prod + 64'd1) : prod;
        half = 64'd1 << (s - 6'd1);
        mask = (64'd1 << s) - 64'd1;
        qq = (mag >> s) + (((mag & mask) >= half) ? 64'd1 : 64'd0);
        gold_rq = prod[63] ? -$signed(qq) : $signed(qq);
      end
    end
  endfunction

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    fail = 0;
    rst_n = 1'b0;
    start = 1'b0;
    val = 0; mul = 0; shr = 0;
    // V_MUL=549309118 V_SHR=36
    VAL[0] = 64'sd0;        MUL[0] = 32'd549309118; SHR[0] = 6'd36;
    VAL[1] = 64'sd1;        MUL[1] = 32'd1;         SHR[1] = 6'd0;
    VAL[2] = -64'sd1;       MUL[2] = 32'd1;         SHR[2] = 6'd0;
    VAL[3] = 64'sd100;      MUL[3] = 32'd549309118; SHR[3] = 6'd36;
    VAL[4] = -64'sd100;     MUL[4] = 32'd549309118; SHR[4] = 6'd36;
    VAL[5] = 64'sd4096;     MUL[5] = 32'd549309118; SHR[5] = 6'd36;
    VAL[6] = -64'sd4096;    MUL[6] = 32'd549309118; SHR[6] = 6'd36;
    VAL[7] = 64'sd1048576;  MUL[7] = 32'd549309118; SHR[7] = 6'd36;
    // Corner: |val|*mul > 2^63-1 so 64-bit prod != 128-bit math then truncate-after-round.
    VAL[8] = 64'sd1 <<< 40; MUL[8] = 32'd549309118; SHR[8] = 6'd36;
    repeat (4) @(posedge clk);
    rst_n = 1'b1;
    @(posedge clk);
    for (i = 0; i < 9; i = i + 1) begin
      val = VAL[i];
      mul = MUL[i];
      shr = SHR[i];
      gold = gold_rq(val, mul, shr);
      start = 1'b1;
      @(posedge clk);
      start = 1'b0;
      guard = 0;
      while (!done && guard < 16) begin
        @(posedge clk);
        guard = guard + 1;
      end
      if (!done) begin
        $display("FAIL timeout i=%0d", i);
        fail = fail + 1;
      end else if (q !== gold) begin
        $display("FAIL i=%0d val=%0d mul=%0d shr=%0d got=%0d gold=%0d",
                 i, VAL[i], MUL[i], SHR[i], q, gold);
        fail = fail + 1;
      end else $display("PASS i=%0d q=%0d cycles=%0d", i, q, guard);
      @(posedge clk);
    end
    if (fail == 0) $display("ASTRA_C4_RQ_MCYCLE_IVERILOG_PASS n=9 PROGRAM=NO E3E_SV_ONLY");
    else $display("ASTRA_C4_RQ_MCYCLE_IVERILOG_FAIL nfail=%0d PROGRAM=NO", fail);
    $finish;
  end
endmodule
