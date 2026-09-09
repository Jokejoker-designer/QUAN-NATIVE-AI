// a7ng_astra_09_r6_uart_iso_public_wrap.sv — ASTRA-09-R6-UART-ISO-PUBLIC-01.
// PROGRAM=NO. Bag-local UART ISO glue. Instantiates named DUT
// a7ng_astra_09_r6_iso_pub. Pass numbers from inner u_sgd via public
// iso_req/iso_x0/iso_rew. Frozen A09-R2 unused. Not PRODUCTION_TOP.
`timescale 1ns / 1ps
`include "a7ng_astra_09_r6_iso_pub.svh"

module a7ng_astra_09_r6_uart_iso_public_wrap (
  input  logic       CLK100MHZ,
  input  logic [3:0] sw,
  input  logic [3:0] btn,
  output logic [3:0] led,
  input  logic       uart_txd_in,
  output logic       uart_rxd_out
);
  localparam int unsigned CLK_HZ = 50_000_000;
  localparam int unsigned BAUD   = 115200;
  localparam int unsigned TX_N   = 16;
  localparam logic [7:0]  MAGIC   = A7NG_A09R6_MAGIC;
  localparam logic [7:0]  CMD_ISO = A7NG_A09R6_CMD_ISO;
  localparam logic [7:0]  EOL     = A7NG_A09R6_EOL;

  logic clk, clkfb, clk50u, locked;
  MMCME2_BASE #(
    .CLKIN1_PERIOD(10.0),
    .CLKFBOUT_MULT_F(10.0),
    .CLKOUT0_DIVIDE_F(20.0),
    .DIVCLK_DIVIDE(1),
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT0_PHASE(0.0)
  ) u_mmcm (
    .CLKIN1(CLK100MHZ),
    .CLKFBIN(clkfb),
    .CLKFBOUT(clkfb),
    .CLKOUT0(clk50u),
    .LOCKED(locked),
    .PWRDWN(1'b0),
    .RST(1'b0)
  );
  BUFG u_bufg50 (.I(clk50u), .O(clk));

  (* ASYNC_REG = "TRUE" *) logic [1:0] btn0_q;
  logic [7:0] por_cnt;
  logic       rst_n;
  always_ff @(posedge clk) begin
    btn0_q <= {btn0_q[0], btn[0]};
    if (!locked || btn0_q[1])
      por_cnt <= 8'd0;
    else if (por_cnt != 8'hFF)
      por_cnt <= por_cnt + 8'd1;
  end
  assign rst_n = locked && (por_cnt == 8'hFF);

  logic [7:0] rx_data;
  logic       rx_valid;
  logic       tx_start, tx_busy;
  logic [7:0] tx_data;

  uart_rx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) u_rx (
    .clk(clk), .rst_n(rst_n), .rx(uart_txd_in), .data(rx_data), .valid(rx_valid)
  );
  uart_tx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) u_tx (
    .clk(clk), .rst_n(rst_n), .start(tx_start), .data(tx_data),
    .tx(uart_rxd_out), .busy(tx_busy)
  );

  logic               iso_req, iso_rdy, iso_dn, iso_busy, tbl;
  logic signed [7:0]  x0_lat, rew8_lat;
  logic signed [3:0]  iso_rew;
  logic signed [15:0] w_pub [0:31];
  logic signed [15:0] v_pub;

  (* keep_hierarchy = "yes" *)
  a7ng_astra_09_r6_iso_pub u_r6 (
    .clk(clk),
    .rst_n(rst_n),
    .iso_req_i(iso_req),
    .iso_x0_i(x0_lat),
    .iso_rew_i(iso_rew),
    .iso_ready_o(iso_rdy),
    .iso_done_o(iso_dn),
    .iso_busy_o(iso_busy),
    .w_o(w_pub),
    .v_q8_o(v_pub),
    .load_from_tb_o(tbl)
  );

  logic signed [15:0] inner_w0, inner_w1, inner_v;
  logic               inner_rdy, inner_dn;
  assign inner_w0  = w_pub[0];
  assign inner_w1  = w_pub[1];
  assign inner_v   = v_pub;
  assign inner_rdy = iso_rdy;
  assign inner_dn  = iso_dn;

  typedef enum logic [2:0] {
    C_IDLE, C_X, C_REW, C_EOL, C_HOLDX, C_GO, C_WAIT, C_TX
  } cmd_t;
  cmd_t cst;

  logic [7:0]  tx_bytes [0:TX_N-1];
  logic [3:0]  tx_idx;
  logic        tx_active;
  logic [24:0] hb;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cst       <= C_IDLE;
      iso_req   <= 1'b0;
      iso_rew   <= 4'sd0;
      x0_lat    <= 8'sd0;
      rew8_lat  <= 8'sd0;
      tx_start  <= 1'b0;
      tx_data   <= 8'd0;
      tx_idx    <= 4'd0;
      tx_active <= 1'b0;
      hb        <= '0;
      tx_bytes[0]  <= MAGIC;
      tx_bytes[1]  <= 8'd0;
      tx_bytes[2]  <= 8'd0;
      tx_bytes[3]  <= 8'd0;
      tx_bytes[4]  <= 8'd0;
      tx_bytes[5]  <= 8'd0;
      tx_bytes[6]  <= 8'd0;
      tx_bytes[7]  <= 8'd0;
      tx_bytes[8]  <= 8'd0;
      tx_bytes[9]  <= 8'd0;
      tx_bytes[10] <= 8'd0;
      tx_bytes[11] <= 8'd0;
      tx_bytes[12] <= 8'd0;
      tx_bytes[13] <= 8'd0;
      tx_bytes[14] <= 8'd0;
      tx_bytes[15] <= EOL;
    end else begin
      iso_req  <= 1'b0;
      tx_start <= 1'b0;
      hb       <= hb + 25'd1;

      unique case (cst)
        C_IDLE: begin
          if (rx_valid && (rx_data == CMD_ISO) && !tx_active)
            cst <= C_X;
        end
        C_X: begin
          if (rx_valid) begin
            x0_lat <= rx_data;
            cst    <= C_REW;
          end
        end
        C_REW: begin
          if (rx_valid) begin
            rew8_lat <= rx_data;
            iso_rew  <= rx_data[3:0];
            cst      <= C_EOL;
          end
        end
        C_EOL: begin
          if (rx_valid) begin
            if (rx_data == EOL)
              cst <= C_HOLDX;
            else
              cst <= C_IDLE;
          end
        end
        C_HOLDX: begin
          if (iso_rdy)
            cst <= C_GO;
        end
        C_GO: begin
          if (iso_rdy)
            iso_req <= 1'b1;
          cst <= C_WAIT;
        end
        C_WAIT: begin
          if (iso_dn) begin
            tx_bytes[0]  <= MAGIC;
            tx_bytes[1]  <= {tbl, 1'b1, 6'd0};
            tx_bytes[2]  <= inner_w0[7:0];
            tx_bytes[3]  <= inner_w0[15:8];
            tx_bytes[4]  <= inner_v[7:0];
            tx_bytes[5]  <= inner_v[15:8];
            tx_bytes[6]  <= x0_lat;
            tx_bytes[7]  <= rew8_lat;
            tx_bytes[8]  <= inner_w1[7:0];
            tx_bytes[9]  <= inner_w1[15:8];
            tx_bytes[10] <= 8'd0;
            tx_bytes[11] <= 8'd0;
            tx_bytes[12] <= 8'd0;
            tx_bytes[13] <= 8'd0;
            tx_bytes[14] <= {7'd0, tbl};
            tx_bytes[15] <= EOL;
            tx_idx    <= 4'd0;
            tx_active <= 1'b1;
            cst       <= C_TX;
          end
        end
        C_TX: begin
          if (tx_active && !tx_busy && !tx_start) begin
            tx_data  <= tx_bytes[tx_idx];
            tx_start <= 1'b1;
            if (tx_idx == 4'(TX_N-1)) begin
              tx_active <= 1'b0;
              cst       <= C_IDLE;
            end else
              tx_idx <= tx_idx + 4'd1;
          end
        end
        default: cst <= C_IDLE;
      endcase
    end
  end

  assign led[0] = rst_n & hb[24];
  assign led[1] = iso_rdy;
  assign led[2] = (cst != C_IDLE) | iso_busy;
  assign led[3] = sw[0] | (|sw[3:1]) | btn[1] | (|btn[3:2]) | tbl;
endmodule
