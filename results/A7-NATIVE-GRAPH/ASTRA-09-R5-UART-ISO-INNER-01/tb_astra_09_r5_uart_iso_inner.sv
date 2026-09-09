// ASTRA-09-R5-UART-ISO-INNER-01. PROGRAM=NO. Bag-local TB.
// Instantiates a7ng_astra_09_r5_uart_iso_inner_wrap (UART ISO into frozen
// A09-R2 inner u_sgd). No second SGD instance. Not BOARD_PASS.
`timescale 1ns / 1ps

module tb_astra_09_r5_uart_iso_inner;
  localparam int CLK_PIN_NS = 10;
  localparam int BAUD       = 115200;
  localparam int CLK_PIN_HZ = 100_000_000;
  localparam int CPB        = (CLK_PIN_HZ + BAUD/2) / BAUD;
  localparam logic [7:0] MAGIC   = 8'hA2;
  localparam logic [7:0] CMD_ISO = 8'hA5;
  localparam logic [7:0] EOL     = 8'h0A;
  localparam int TX_N = 16;

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

  a7ng_astra_09_r5_uart_iso_inner_wrap dut (
    .CLK100MHZ(CLK100MHZ),
    .sw(sw),
    .btn(btn),
    .led(led),
    .uart_txd_in(uart_txd_in),
    .uart_rxd_out(uart_rxd_out)
  );

  always @(posedge dut.clk) begin
    if (dut.pulse_go)
      $display("INNER_GO x0=%0d rew=%0d t=%0t", $signed(dut.x0_lat),
        $signed(dut.iso_rew), $time);
    if (dut.inner_dn)
      $display("INNER_DONE w0=%0d v=%0d w1=%0d tbl=%0d a09_w0=%0d t=%0t",
        dut.inner_w0, dut.inner_v, dut.inner_w1, dut.tbl, dut.w_a09[0], $time);
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

  task automatic uart_send_iso(input logic signed [7:0] x0,
                               input logic signed [7:0] rew8);
    begin
      uart_send_byte(CMD_ISO);
      uart_send_byte(x0);
      uart_send_byte(rew8);
      uart_send_byte(EOL);
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

  task automatic decode_iso(
      input string tag,
      input logic signed [15:0] exp_w0,
      input logic signed [7:0]  exp_x0,
      input logic signed [7:0]  exp_rew
  );
    logic [7:0] fr [0:TX_N-1];
    logic signed [15:0] w0_u, v_u, w1_u;
    logic signed [7:0] x0_u, rew_u;
    logic tbl_u, iso_u;
    begin
      uart_get_frame(fr);
      $display("FRAME %s %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h",
        tag, fr[0], fr[1], fr[2], fr[3], fr[4], fr[5], fr[6], fr[7],
        fr[8], fr[9], fr[10], fr[11], fr[12], fr[13], fr[14], fr[15]);
      w0_u  = $signed({fr[3], fr[2]});
      v_u   = $signed({fr[5], fr[4]});
      w1_u  = $signed({fr[9], fr[8]});
      x0_u  = $signed(fr[6]);
      rew_u = $signed(fr[7]);
      tbl_u = fr[1][7];
      iso_u = fr[1][6];
      $display("%s w0=%0d v=%0d w1=%0d x0=%0d rew=%0d tbl=%0d iso=%0d inner_w0=%0d hier_sgd_w0=%0d a09_w0=%0d hier_tbl=%0d",
        tag, w0_u, v_u, w1_u, x0_u, rew_u, tbl_u, iso_u,
        dut.inner_w0, dut.u_a09r2.u_sgd.w_o[0], dut.w_a09[0], dut.tbl);
      chk({tag, "_MAGIC"}, fr[0] === MAGIC);
      chk({tag, "_EOL"}, fr[15] === EOL);
      chk({tag, "_TBL0"}, (tbl_u === 1'b0) && (fr[14][0] === 1'b0)
          && (dut.tbl === 1'b0));
      chk({tag, "_ISOFLG"}, iso_u === 1'b1);
      chk({tag, "_X0"}, x0_u === exp_x0);
      chk({tag, "_REW"}, rew_u === exp_rew);
      chk({tag, "_W0"}, w0_u === exp_w0);
      chk({tag, "_V0"}, v_u === 16'sd0);
      chk({tag, "_W1_0"}, w1_u === 16'sd0);
      chk({tag, "_INNER_W0"}, dut.inner_w0 === exp_w0);
      chk({tag, "_HIER_SGD_W0"}, dut.u_a09r2.u_sgd.w_o[0] === exp_w0);
      chk({tag, "_A09_W0_IS_INNER"}, dut.w_a09[0] === exp_w0);
      chk({tag, "_INNER_W1"}, dut.inner_w1 === 16'sd0);
    end
  endtask

  task automatic wrap_rst;
    integer g;
    begin
      rx_arm = 1'b0;
      rxq.delete();
      btn[0] = 1'b1;
      repeat (64) @(posedge CLK100MHZ);
      btn[0] = 1'b0;
      g = 0;
      while (dut.rst_n !== 1'b1) begin
        @(posedge CLK100MHZ);
        g = g + 1;
        if (g > 2_000_000) begin
          $display("FAIL RST_AFTER_BTN locked=%0b rst_n=%0b t=%0t",
            dut.locked, dut.rst_n, $time);
          fail = fail + 1;
          if (first_div == "") first_div = "RST_AFTER_BTN";
          return;
        end
      end
      repeat (64) @(posedge CLK100MHZ);
      rx_arm = 1'b1;
    end
  endtask

  initial begin
    fail = 0;
    first_div = "";
    n_tx_bytes = 0;
    rx_busy = 1'b0;
    rx_arm = 1'b0;
    sw = 4'd0;
    btn = 4'd0;
    uart_txd_in = 1'b1;
    $display("TB ASTRA-09-R5-UART-ISO-INNER DUT=a7ng_astra_09_r5_uart_iso_inner_wrap INNER=a7ng_astra_09_r2_cand_ovf.u_sgd NO_SIBLING_SGD=1 PROGRAM=NO");
    $display("UART 115200 8N1 CPB_PIN100=%0d BIT_NS=%0d PRODUCTION_TOP=UNKNOWN",
      CPB, CPB * CLK_PIN_NS);

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
      $display("ASTRA_09_R5_UART_ISO_INNER_FAIL n=%0d first=%s", fail, first_div);
      $finish;
    end

    repeat (64) @(posedge CLK100MHZ);
    rx_arm = 1'b1;

    $display("ISO_P3_CMD_SENT x0=50 rew=+3 t=%0t", $time);
    uart_send_iso(8'sd50, 8'sd3);
    decode_iso("ISO_P3", 16'sd5, 8'sd50, 8'sd3);
    chk("ISO_P3_X50_DW5", (dut.inner_w0 === 16'sd5) && (dut.inner_w1 === 16'sd0)
        && (dut.inner_v === 16'sd0) && (dut.tbl === 1'b0)
        && (dut.u_a09r2.u_sgd.w_o[0] === 16'sd5)
        && (dut.w_a09[0] === 16'sd5));

    wrap_rst();
    chk("ISO_M3_PRE_W0", (dut.inner_w0 === 16'sd0)
        && (dut.u_a09r2.u_sgd.w_o[0] === 16'sd0));

    $display("ISO_M3_CMD_SENT x0=64 rew=-3 t=%0t", $time);
    uart_send_iso(8'sd64, -8'sd3);
    decode_iso("ISO_M3", -16'sd6, 8'sd64, -8'sd3);
    chk("ISO_M3_X64_DW6", (dut.inner_w0 === -16'sd6) && (dut.inner_w1 === 16'sd0)
        && (dut.inner_v === 16'sd0) && (dut.tbl === 1'b0)
        && (dut.u_a09r2.u_sgd.w_o[0] === -16'sd6)
        && (dut.w_a09[0] === -16'sd6));

    if (fail == 0)
      $display("ASTRA_09_R5_UART_ISO_INNER_PASS");
    else
      $display("ASTRA_09_R5_UART_ISO_INNER_FAIL n=%0d first=%s", fail, first_div);
    $finish;
  end
endmodule
