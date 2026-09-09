// ASTRA-09-R3-UART-XSIM-01. PROGRAM=NO. Bag-local TB.
// Instantiates a7ng_astra_09_r3_uart_wrap (UART glue around frozen A09-R2).
// Does not claim ASTRA-SOC-RTP-WRAP-UART-XSIM results. Not BOARD_PASS.
`timescale 1ns / 1ps

module tb_astra_09_r3_uart_xsim;
  localparam int CLK_PIN_NS = 10;
  localparam int BAUD       = 115200;
  localparam int CLK_PIN_HZ = 100_000_000;
  localparam int CPB        = (CLK_PIN_HZ + BAUD/2) / BAUD;
  localparam logic [7:0] MAGIC = 8'hA2;
  localparam logic [7:0] EOL   = 8'h0A;
  localparam int TX_N = 16;
  localparam logic [1:0] PLANT_SMOKE = 2'd1;
  localparam logic [1:0] PLANT_OVF   = 2'd2;
  localparam logic [3:0] ST_ANSWER = 4'd0, ST_UNKNOWN = 4'd1, ST_INCOMP = 4'd6;

  logic        CLK100MHZ;
  logic        uart_txd_in;
  logic        uart_rxd_out;
  logic [3:0]  sw, btn, led;
  logic        rx_arm, rx_busy;
  integer      fail, n_tx_bytes;
  string       first_div;
  logic [7:0]  rxq [$];

  initial CLK100MHZ = 1'b0;
  always #(CLK_PIN_NS/2) CLK100MHZ = ~CLK100MHZ;

  a7ng_astra_09_r3_uart_wrap dut (
    .CLK100MHZ(CLK100MHZ),
    .sw(sw),
    .btn(btn),
    .led(led),
    .uart_txd_in(uart_txd_in),
    .uart_rxd_out(uart_rxd_out)
  );

  always @(posedge dut.clk) begin
    if (dut.fire)
      $display("FIRE t=%0t plant=%0d", $time, sw[1:0]);
    if (dut.result_v && !dut.sent)
      $display("HIER result_v ans=%0d p0=%0d p1=%0d st=%0d tbl=%0d npath=%0d ntrunc=%0d rov=%0d wov=%0d acc=%0d t=%0t",
        dut.ans, dut.p0, dut.p1, dut.status, dut.tbl, dut.npath, dut.ntrunc,
        dut.r_ovf, dut.w_ovf, dut.pend_acc, $time);
  end

  always @(negedge uart_rxd_out) begin
    logic [7:0] b;
    int i;
    if (rx_arm && dut.rst_n && !rx_busy) begin
      rx_busy = 1'b1;
      repeat (CPB / 2) @(posedge CLK100MHZ);
      b = 8'd0;
      for (i = 0; i < 8; i = i + 1) begin
        repeat (CPB) @(posedge CLK100MHZ);
        b[i] = uart_rxd_out;
      end
      repeat (CPB) @(posedge CLK100MHZ);
      rxq.push_back(b);
      n_tx_bytes = n_tx_bytes + 1;
      $display("UART_RX n=%0d byte=%02h t=%0t", n_tx_bytes, b, $time);
      rx_busy = 1'b0;
    end
  end

  task automatic uart_send_byte(input logic [7:0] b);
    integer i;
    begin
      uart_txd_in = 1'b0;
      repeat (CPB) @(posedge CLK100MHZ);
      for (i = 0; i < 8; i = i + 1) begin
        uart_txd_in = b[i];
        repeat (CPB) @(posedge CLK100MHZ);
      end
      uart_txd_in = 1'b1;
      repeat (CPB) @(posedge CLK100MHZ);
    end
  endtask

  task automatic uart_send_str(input string s);
    integer k;
    begin
      for (k = 0; k < s.len(); k = k + 1)
        uart_send_byte(s[k]);
    end
  endtask

  task automatic uart_get_byte(output logic [7:0] b);
    integer guard;
    begin
      guard = 0;
      while (rxq.size() == 0) begin
        @(posedge CLK100MHZ);
        guard = guard + 1;
        if (guard > 8_000_000) begin
          $display("FAIL UART_RX_TIMEOUT t=%0t", $time);
          fail = fail + 1;
          if (first_div == "") first_div = "UART_RX_TIMEOUT";
          b = 8'h00;
          return;
        end
      end
      b = rxq.pop_front();
    end
  endtask

  task automatic uart_get_frame(output logic [7:0] fr [0:TX_N-1]);
    integer i;
    begin
      for (i = 0; i < TX_N; i = i + 1)
        uart_get_byte(fr[i]);
    end
  endtask

  task automatic wait_idle;
    integer g;
    begin
      g = 0;
      while (dut.busy || dut.tx_active || dut.do_retire || dut.result_v) begin
        @(posedge CLK100MHZ);
        g = g + 1;
        if (g > 2_000_000) begin
          $display("FAIL IDLE_TIMEOUT busy=%0b tx=%0b ret=%0b rv=%0b t=%0t",
            dut.busy, dut.tx_active, dut.do_retire, dut.result_v, $time);
          fail = fail + 1;
          if (first_div == "") first_div = "IDLE_TIMEOUT";
          return;
        end
      end
      repeat (64) @(posedge CLK100MHZ);
    end
  endtask

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div == "") first_div = tag;
        $display("FAIL %s", tag);
        fail = fail + 1;
      end else
        $display("PASS %s", tag);
    end
  endtask

  task automatic decode_and_check(
      input string tag,
      input logic [3:0] exp_st,
      input logic [19:0] exp_ans,
      input logic [19:0] exp_p0,
      input bit check_p1,
      input logic [19:0] exp_p1,
      input bit expect_ntrunc
  );
    logic [7:0] fr [0:TX_N-1];
    logic [19:0] ans_u, p0_u, p1_u;
    logic tbl_u, rov_u, wov_u, acc_u;
    logic [3:0] st_u;
    logic [4:0] npath_u;
    logic [15:0] ntrunc_u;
    begin
      uart_get_frame(fr);
      $display("FRAME %s %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h",
        tag, fr[0], fr[1], fr[2], fr[3], fr[4], fr[5], fr[6], fr[7],
        fr[8], fr[9], fr[10], fr[11], fr[12], fr[13], fr[14], fr[15]);
      ans_u    = {fr[4][3:0], fr[3], fr[2]};
      p0_u     = {fr[7][3:0], fr[6], fr[5]};
      p1_u     = {fr[10][3:0], fr[9], fr[8]};
      tbl_u    = fr[1][7];
      rov_u    = fr[1][6];
      wov_u    = fr[1][5];
      acc_u    = fr[1][4];
      st_u     = fr[1][3:0];
      npath_u  = fr[11][4:0];
      ntrunc_u = {fr[13], fr[12]};
      $display("DECODE %s magic=%02h tbl=%0d st=%0d ans=%0d p0=%0d p1=%0d npath=%0d ntrunc=%0d rov=%0d wov=%0d acc=%0d eol=%02h hier_tbl=%0d",
        tag, fr[0], tbl_u, st_u, ans_u, p0_u, p1_u, npath_u, ntrunc_u,
        rov_u, wov_u, acc_u, fr[15], dut.tbl);
      chk({tag, "_MAGIC"}, fr[0] === MAGIC);
      chk({tag, "_EOL"}, fr[15] === EOL);
      chk({tag, "_TBL0"}, (tbl_u === 1'b0) && (fr[14][0] === 1'b0) && (dut.tbl === 1'b0));
      chk({tag, "_ST"}, st_u === exp_st);
      chk({tag, "_ANS"}, ans_u === exp_ans);
      chk({tag, "_P0"}, p0_u === exp_p0);
      if (check_p1)
        chk({tag, "_P1"}, p1_u === exp_p1);
      if (expect_ntrunc)
        chk({tag, "_NTRUNC"}, (ntrunc_u != 16'd0) && rov_u);
      else
        chk({tag, "_NO_TRUNC"}, ntrunc_u == 16'd0);
    end
  endtask

  initial begin
    fail = 0;
    first_div = "";
    n_tx_bytes = 0;
    rx_busy = 1'b0;
    rx_arm = 1'b0;
    sw = {2'b00, PLANT_OVF};
    btn = 4'd0;
    uart_txd_in = 1'b1;
    $display("TB ASTRA-09-R3-UART-XSIM DUT=a7ng_astra_09_r3_uart_wrap INNER=a7ng_astra_09_r2_cand_ovf PROGRAM=NO");
    $display("UART 115200 8N1 CPB_PIN100=%0d BIT_NS=%0d PRODUCTION_TOP=UNKNOWN", CPB, CPB * CLK_PIN_NS);

    fork
      begin
        wait (dut.rst_n === 1'b1);
        $display("RST_N=1 locked=%0b t=%0t", dut.locked, $time);
      end
      begin
        repeat (2_000_000) @(posedge CLK100MHZ);
        if (dut.rst_n !== 1'b1) begin
          $display("FAIL MMCM_POR_TIMEOUT locked=%0b rst_n=%0b t=%0t",
            dut.locked, dut.rst_n, $time);
          fail = fail + 1;
          if (first_div == "") first_div = "MMCM_POR_TIMEOUT";
        end
      end
    join_any
    disable fork;

    if (dut.rst_n !== 1'b1) begin
      $display("ASTRA_09_R3_UART_XSIM_FAIL n=%0d first=%s", fail, first_div);
      $finish;
    end

    repeat (64) @(posedge CLK100MHZ);
    rx_arm = 1'b1;

    $display("QUERY_OVF_SENT t=%0t", $time);
    uart_send_str("pump requires indirect\n");
    decode_and_check("OVF_UART", ST_INCOMP, 20'd0, 20'd0, 1'b1, 20'd0, 1'b1);
    chk("OVF_UART_NO_STALE_ANS4", (dut.ans !== 20'd4) && (dut.status !== ST_ANSWER));
    chk("OVF_UART_HIER_INCOMP", (dut.status === ST_INCOMP) && (dut.ans === 20'd0)
        && (dut.p0 === 20'd0) && dut.r_ovf && !dut.w_ovf);
    wait_idle();

    sw = {2'b00, PLANT_SMOKE};
    repeat (32) @(posedge CLK100MHZ);
    $display("QUERY_SMOKE_SENT t=%0t", $time);
    uart_send_str("pump requires indirect\n");
    decode_and_check("SMOKE_UART", ST_ANSWER, 20'd4, 20'd17, 1'b1, 20'd34, 1'b0);
    chk("SMOKE_UART_NPATH", dut.npath >= 5'd2);
    wait_idle();

    $display("QUERY_UNREL_SENT t=%0t", $time);
    uart_send_str("payroll tax form\n");
    decode_and_check("UNREL_UART", ST_UNKNOWN, 20'd0, 20'd0, 1'b0, 20'd0, 1'b0);
    chk("UNREL_UART_NO_STALE", (dut.ans === 20'd0) && (dut.npath === 5'd0)
        && (dut.status === ST_UNKNOWN) && !dut.tbl);

    if (fail == 0)
      $display("ASTRA_09_R3_UART_XSIM_PASS");
    else
      $display("ASTRA_09_R3_UART_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $finish;
  end
endmodule
