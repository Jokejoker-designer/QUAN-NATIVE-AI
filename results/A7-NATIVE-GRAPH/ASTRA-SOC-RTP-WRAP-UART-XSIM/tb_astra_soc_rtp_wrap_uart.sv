// WRAP-UART-XSIM TB. PROGRAM=NO. Instantiates arty_a7_astra_rtp_soc_top.
// UART 115200 8N1 on pin CLK100MHZ (10 ns). EMPTY not in this TB.
`timescale 1ns / 1ps

module tb_astra_soc_rtp_wrap_uart;
  localparam int CLK_PIN_NS = 10;
  localparam int BAUD       = 115200;
  localparam int CLK_PIN_HZ = 100_000_000;
  localparam int CPB        = (CLK_PIN_HZ + BAUD/2) / BAUD;
  localparam logic [7:0] MAGIC = 8'hA2;
  localparam logic [7:0] EOL   = 8'h0A;
  localparam int TX_N = 16;

  logic        CLK100MHZ;
  logic        uart_txd_in;
  logic        uart_rxd_out;
  logic [3:0]  sw, btn, led;
  logic        rx_arm, rx_busy;
  integer      fail, n_tx_bytes;
  logic [7:0]  rxq [$];

  initial CLK100MHZ = 1'b0;
  always #(CLK_PIN_NS/2) CLK100MHZ = ~CLK100MHZ;

  arty_a7_astra_rtp_soc_top dut (
    .CLK100MHZ(CLK100MHZ),
    .sw(sw),
    .btn(btn),
    .led(led),
    .uart_txd_in(uart_txd_in),
    .uart_rxd_out(uart_rxd_out)
  );

  always @(posedge dut.clk) begin
    if (dut.fire)
      $display("FIRE t=%0t", $time);
    if (dut.result_v && !dut.sent)
      $display("HIER result_v ans=%0d p0=%0d p1=%0d st=%0d tbl=%0d nload=%0d ncand=%0d nfok=%0d ndir=%0d nfar=%0d ovf=%0d neg=%0d amb=%0d t=%0t",
        dut.ans, dut.p0, dut.p1, dut.status, dut.tbl, dut.nload, dut.ncand,
        dut.nfok, dut.ndir, dut.nfar, dut.ovf, dut.neg, dut.amb, $time);
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
        if (guard > 5_000_000) begin
          $display("FAIL UART_RX_TIMEOUT t=%0t", $time);
          fail = fail + 1;
          b = 8'h00;
          return;
        end
      end
      b = rxq.pop_front();
    end
  endtask

  initial begin
    fail = 0;
    n_tx_bytes = 0;
    rx_busy = 1'b0;
    rx_arm = 1'b0;
    sw = 4'd0;
    btn = 4'd0;
    uart_txd_in = 1'b1;
    $display("TB WRAP-UART-XSIM DUT=arty_a7_astra_rtp_soc_top PROGRAM=NO");
    $display("UART 115200 8N1 CPB_PIN100=%0d BIT_NS=%0d", CPB, CPB * CLK_PIN_NS);

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
        end
      end
    join_any
    disable fork;

    if (dut.rst_n !== 1'b1) begin
      $display("ASTRA_SOC_RTP_WRAP_UART_XSIM_FAIL n=%0d", fail);
      $finish;
    end

    repeat (64) @(posedge CLK100MHZ);
    rx_arm = 1'b1;

    uart_send_str("pump requires indirect\n");
    $display("QUERY_SENT t=%0t", $time);

    begin
      logic [7:0] fr [0:TX_N-1];
      integer i;
      logic [19:0] ans_u, p0_u, p1_u;
      logic tbl_u;
      logic [3:0] st_u;
      for (i = 0; i < TX_N; i = i + 1)
        uart_get_byte(fr[i]);
      $display("FRAME %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h",
        fr[0], fr[1], fr[2], fr[3], fr[4], fr[5], fr[6], fr[7],
        fr[8], fr[9], fr[10], fr[11], fr[12], fr[13], fr[14], fr[15]);
      ans_u = {fr[4][3:0], fr[3], fr[2]};
      p0_u  = {fr[7][3:0], fr[6], fr[5]};
      p1_u  = {fr[10][3:0], fr[9], fr[8]};
      tbl_u = fr[1][7];
      st_u  = fr[1][3:0];
      $display("DECODE magic=%02h tbl=%0d st=%0d ans=%0d p0=%0d p1=%0d nload=%0d nfok=%0d ndir=%0d ncand=%0d eol=%02h",
        fr[0], tbl_u, st_u, ans_u, p0_u, p1_u, fr[11], fr[12], fr[13], fr[14], fr[15]);
      if (fr[0] !== MAGIC) begin
        $display("FAIL MAGIC got=%02h", fr[0]);
        fail = fail + 1;
      end
      if (tbl_u !== 1'b0) begin
        $display("FAIL TBL");
        fail = fail + 1;
      end
      if (dut.tbl !== 1'b0) begin
        $display("FAIL HIER_TBL");
        fail = fail + 1;
      end
      if (ans_u !== 20'd4 || p0_u !== 20'd17 || p1_u !== 20'd34) begin
        $display("FAIL ANS/PROOF got ans=%0d p0=%0d p1=%0d", ans_u, p0_u, p1_u);
        fail = fail + 1;
      end else
        $display("PASS BASE UART ans=4 p0=17 p1=34 tbl=0");
      if (fr[15] !== EOL) begin
        $display("FAIL EOL got=%02h", fr[15]);
        fail = fail + 1;
      end
    end

    if (fail == 0)
      $display("ASTRA_SOC_RTP_WRAP_UART_XSIM_PASS");
    else
      $display("ASTRA_SOC_RTP_WRAP_UART_XSIM_FAIL n=%0d", fail);
    $finish;
  end
endmodule
