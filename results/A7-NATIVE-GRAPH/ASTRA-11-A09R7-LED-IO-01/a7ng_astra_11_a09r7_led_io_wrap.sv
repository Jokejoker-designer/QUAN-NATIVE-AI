// a7ng_astra_11_a09r7_led_io_wrap.sv — ASTRA-11-A09R7-LED-IO-01.
// PROGRAM=NO. BIT=NO. Named LED-IO wrap: R7 query-rew FSM + UART IOB FFs + LED IOB FFs.
// Instantiates frozen a7ng_astra_09_r2_cand_ovf (no copy-paste graph).
// Prior a7ng_astra_11_a09r7_uart_impl_wrap KEEP, not this top. Not PRODUCTION_TOP.
// Frozen a7ng_astra_09_integ_path is not instantiated. MMCM 100→50 + BUFG.
// UART pins uart_rxd_out=D10 uart_txd_in=A9. LEDs LD4-LD7 H5/J5/T9/T10.
`timescale 1ns / 1ps
`include "a7ng_astra_11_a09r7_led_io.svh"

module a7ng_astra_11_a09r7_led_io_wrap (
  input  logic       CLK100MHZ,
  input  logic [3:0] sw,
  input  logic [3:0] btn,
  output logic [3:0] led,
  input  logic       uart_txd_in,
  output logic       uart_rxd_out
);
  localparam int unsigned CLK_HZ = 50_000_000;
  localparam int unsigned BAUD   = 115200;
  localparam int unsigned FIFO_N = 64;
  localparam int unsigned FIFO_W = 6;
  localparam int unsigned TX_N   = A7NG_A09R7_TX_N;
  localparam logic [7:0]  MAGIC  = A7NG_A09R7_MAGIC;
  localparam logic [7:0]  EOL    = A7NG_A09R7_EOL;
  localparam logic [7:0]  CMD_REW = A7NG_A09R7_CMD_REW;
  localparam logic [7:0]  CMD_RET = A7NG_A09R7_CMD_RET;
  localparam logic [7:0]  OBS_TAG = A7NG_A09R7_OBS_TAG;

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
  logic       tx_int;

  // IOB pad FFs (PREREG). Do not patch frozen uart_rx / uart_tx.
  // INIT idle-high. No SR on these FFs so Vivado can pack into IOB.
  (* IOB = "TRUE" *) logic uart_rx_iob = 1'b1;
  (* IOB = "TRUE" *) logic uart_tx_iob = 1'b1;
  always_ff @(posedge clk) begin
    uart_rx_iob <= uart_txd_in;
    uart_tx_iob <= tx_int;
  end
  assign uart_rxd_out = uart_tx_iob;

  (* keep_hierarchy = "yes" *)
  uart_rx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) u_rx (
    .clk(clk), .rst_n(rst_n), .rx(uart_rx_iob), .data(rx_data), .valid(rx_valid)
  );
  (* keep_hierarchy = "yes" *)
  uart_tx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) u_tx (
    .clk(clk), .rst_n(rst_n), .start(tx_start), .data(tx_data),
    .tx(tx_int), .busy(tx_busy)
  );

  logic        tok_v, tok_r, fire, retire, busy, result_v, tbl;
  logic        pend_acc, pend_cmt, txn_exh, r_ovf, w_ovf;
  logic        rew_v;
  logic signed [3:0] rew_i;
  logic [7:0]  rew_txn, rew_gen, tok_b, txn_id, gen, obj, ctx;
  logic [15:0] rew_epoch, epoch, n_upd, n_dup, n_bad, n_stale, n_oor, n_exh, ntrunc;
  logic [1:0]  sel_idx;
  logic [19:0] ans, p0, p1;
  logic [4:0]  npath;
  logic [3:0]  status;
  logic signed [15:0] v_best, v_second, v_pred;
  logic signed [7:0]  phi0;
  logic signed [7:0]  pend_phi [0:31];
  logic signed [15:0] w [0:31];
  logic signed [15:0] inner_w0;
  logic [3:0]  arid, ost_rid;
  logic [27:0] araddr;
  logic [7:0]  arlen;
  logic [2:0]  arsize;
  logic [1:0]  arburst;
  logic        arvalid, arready, rvalid, rready, rlast, axi_ost, axi_abort;
  logic [3:0]  rid;
  logic [127:0] rdata;
  logic [1:0]  rresp;
  logic [15:0] narto, nrto, nerr, ndrain, naban, dead_mask;

  logic [7:0] fifo [0:FIFO_N-1];
  logic [FIFO_W-1:0] wr_ptr, rd_ptr;
  logic [FIFO_W:0]   count;
  logic              fire_pend, sent;
  logic              fifo_full, fifo_empty;
  logic [7:0]  tx_bytes [0:TX_N-1];
  logic [3:0]  tx_idx;
  logic        tx_active;
  logic [24:0] hb;
  logic        push, pop, is_eol;

  typedef enum logic [3:0] {
    C_QRUN, C_TX, C_HOLD,
    C_R_REW, C_R_TXN, C_R_GEN, C_R_E0, C_R_E1, C_R_EOL, C_R_PULSE, C_R_WAIT,
    C_OBS_TX, C_RET_EOL, C_RET_PULSE
  } cst_t;
  cst_t cst;
  logic [7:0]  rew8_lat, e0_lat;
  logic [9:0]  wait_cnt;

  assign fifo_full  = (count == FIFO_N[FIFO_W:0]);
  assign fifo_empty = (count == '0);
  assign is_eol = (rx_data == EOL) || (rx_data == 8'h00);
  assign push   = rx_valid && !is_eol && !fifo_full && (cst == C_QRUN);
  assign pop    = !fifo_empty && tok_r && (cst == C_QRUN) && !tx_active;
  assign inner_w0 = w[0];

  (* keep_hierarchy = "yes" *)
  a7ng_astra_09_r2_cand_ovf u_a09r2 (
    .clk(clk), .rst_n(rst_n),
    .live_epoch_i(16'd7), .sess_id_i(16'd7), .ctrl_i(2'd0),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok_b),
    .fire_i(fire), .retire_i(retire),
    .rew_v_i(rew_v), .rew_i(rew_i), .rew_txn_i(rew_txn), .rew_gen_i(rew_gen),
    .rew_epoch_i(rew_epoch),
    .load_v_i(1'b0), .load_idx_i(5'd0), .load_w_i(16'sd0),
    .busy_o(busy), .result_v_o(result_v),
    .pend_acc_o(pend_acc), .pend_cmt_o(pend_cmt),
    .txn_id_o(txn_id), .gen_o(gen), .epoch_o(epoch), .sel_idx_o(sel_idx),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1),
    .n_path_o(npath), .status_o(status), .obj_o(obj), .ctx_o(ctx),
    .v_best_o(v_best), .v_second_o(v_second), .v_pred_o(v_pred), .phi0_o(phi0),
    .pend_phi_o(pend_phi), .w_o(w),
    .n_upd_o(n_upd), .n_dup_o(n_dup), .n_bad_o(n_bad), .n_stale_o(n_stale),
    .n_oor_o(n_oor), .n_exh_o(n_exh), .txn_exh_o(txn_exh),
    .load_from_tb_o(tbl),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready),
    .n_ar_to_o(narto), .n_r_to_o(nrto), .n_axi_err_o(nerr),
    .n_drain_o(ndrain), .n_abandon_o(naban),
    .axi_ost_o(axi_ost), .axi_abort_o(axi_abort),
    .ost_rid_o(ost_rid), .dead_mask_o(dead_mask),
    .n_trunc_o(ntrunc), .r_ovf_o(r_ovf), .w_ovf_o(w_ovf)
  );

  (* keep_hierarchy = "yes" *)
  a7ng_astra_11_a09r7_led_io_plant u_plant (
    .clk(clk), .rst_n(rst_n), .plant_sel(sw[1:0]),
    .s_axi_arid(arid), .s_axi_araddr(araddr), .s_axi_arlen(arlen),
    .s_axi_arsize(arsize), .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid), .s_axi_arready(arready),
    .s_axi_rid(rid), .s_axi_rdata(rdata), .s_axi_rresp(rresp),
    .s_axi_rlast(rlast), .s_axi_rvalid(rvalid), .s_axi_rready(rready)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr <= '0;
      rd_ptr <= '0;
      count  <= '0;
      fire_pend <= 1'b0;
      sent <= 1'b0;
      tok_v <= 1'b0;
      tok_b <= 8'd0;
      fire  <= 1'b0;
      retire <= 1'b0;
      rew_v <= 1'b0;
      rew_i <= 4'sd0;
      rew_txn <= 8'd0;
      rew_gen <= 8'd0;
      rew_epoch <= 16'd0;
      rew8_lat <= 8'd0;
      e0_lat <= 8'd0;
      wait_cnt <= 10'd0;
      cst <= C_QRUN;
      tx_start <= 1'b0;
      tx_data  <= 8'd0;
      tx_idx   <= 4'd0;
      tx_active <= 1'b0;
      hb <= '0;
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
      tok_v    <= 1'b0;
      fire     <= 1'b0;
      retire   <= 1'b0;
      rew_v    <= 1'b0;
      tx_start <= 1'b0;
      hb <= hb + 25'd1;

      if (rx_valid && is_eol && (cst == C_QRUN))
        fire_pend <= 1'b1;

      if (push) begin
        fifo[wr_ptr] <= rx_data;
        wr_ptr <= wr_ptr + FIFO_W'(1);
      end
      if (pop) begin
        tok_b  <= fifo[rd_ptr];
        tok_v  <= 1'b1;
        rd_ptr <= rd_ptr + FIFO_W'(1);
      end
      unique case ({push, pop})
        2'b10: count <= count + (FIFO_W+1)'(1);
        2'b01: count <= count - (FIFO_W+1)'(1);
        default: ;
      endcase

      if ((cst == C_QRUN) && fire_pend && (count == '0) && !push && tok_r
          && !busy && !tx_active && !pop) begin
        fire <= 1'b1;
        fire_pend <= 1'b0;
      end

      unique case (cst)
        C_QRUN: begin
          if (!result_v)
            sent <= 1'b0;
          if (result_v && !sent && !tx_active) begin
            tx_bytes[0]  <= MAGIC;
            tx_bytes[1]  <= {tbl, r_ovf, w_ovf, pend_acc, status};
            tx_bytes[2]  <= ans[7:0];
            tx_bytes[3]  <= ans[15:8];
            tx_bytes[4]  <= {4'd0, ans[19:16]};
            tx_bytes[5]  <= p0[7:0];
            tx_bytes[6]  <= p0[15:8];
            tx_bytes[7]  <= {4'd0, p0[19:16]};
            tx_bytes[8]  <= p1[7:0];
            tx_bytes[9]  <= p1[15:8];
            tx_bytes[10] <= {4'd0, p1[19:16]};
            tx_bytes[11] <= {3'd0, npath};
            tx_bytes[12] <= ntrunc[7:0];
            tx_bytes[13] <= ntrunc[15:8];
            tx_bytes[14] <= {7'd0, tbl};
            tx_bytes[15] <= EOL;
            tx_idx    <= 4'd0;
            tx_active <= 1'b1;
            sent      <= 1'b1;
            cst       <= C_TX;
          end
        end
        C_TX: begin
          if (tx_active && !tx_busy && !tx_start) begin
            tx_data  <= tx_bytes[tx_idx];
            tx_start <= 1'b1;
            if (tx_idx == 4'(TX_N-1)) begin
              tx_active <= 1'b0;
              cst <= C_HOLD;
            end else
              tx_idx <= tx_idx + 4'd1;
          end
        end
        C_HOLD: begin
          if (rx_valid && !tx_busy && !tx_active) begin
            if (rx_data == CMD_REW)
              cst <= C_R_REW;
            else if (rx_data == CMD_RET)
              cst <= C_RET_EOL;
          end
        end
        C_R_REW: if (rx_valid) begin
          rew8_lat <= rx_data;
          rew_i <= rx_data[3:0];
          cst <= C_R_TXN;
        end
        C_R_TXN: if (rx_valid) begin
          rew_txn <= rx_data;
          cst <= C_R_GEN;
        end
        C_R_GEN: if (rx_valid) begin
          rew_gen <= rx_data;
          cst <= C_R_E0;
        end
        C_R_E0: if (rx_valid) begin
          e0_lat <= rx_data;
          cst <= C_R_E1;
        end
        C_R_E1: if (rx_valid) begin
          rew_epoch <= {rx_data, e0_lat};
          cst <= C_R_EOL;
        end
        C_R_EOL: if (rx_valid)
          cst <= (rx_data == EOL) ? C_R_PULSE : C_HOLD;
        C_R_PULSE: begin
          rew_v <= 1'b1;
          wait_cnt <= 10'd0;
          cst <= C_R_WAIT;
        end
        C_R_WAIT: begin
          wait_cnt <= wait_cnt + 10'd1;
          if (pend_cmt || (wait_cnt == 10'd1023)) begin
            tx_bytes[0]  <= MAGIC;
            tx_bytes[1]  <= {tbl, pend_cmt, pend_acc, 1'b0, status};
            tx_bytes[2]  <= w[0][7:0];
            tx_bytes[3]  <= w[0][15:8];
            tx_bytes[4]  <= phi0;
            tx_bytes[5]  <= n_upd[7:0];
            tx_bytes[6]  <= n_bad[7:0];
            tx_bytes[7]  <= n_stale[7:0];
            tx_bytes[8]  <= txn_id;
            tx_bytes[9]  <= gen;
            tx_bytes[10] <= epoch[7:0];
            tx_bytes[11] <= epoch[15:8];
            tx_bytes[12] <= ntrunc[7:0];
            tx_bytes[13] <= n_dup[7:0];
            tx_bytes[14] <= OBS_TAG;
            tx_bytes[15] <= EOL;
            tx_idx    <= 4'd0;
            tx_active <= 1'b1;
            cst       <= C_OBS_TX;
          end
        end
        C_OBS_TX: begin
          if (tx_active && !tx_busy && !tx_start) begin
            tx_data  <= tx_bytes[tx_idx];
            tx_start <= 1'b1;
            if (tx_idx == 4'(TX_N-1)) begin
              tx_active <= 1'b0;
              cst <= C_HOLD;
            end else
              tx_idx <= tx_idx + 4'd1;
          end
        end
        C_RET_EOL: if (rx_valid)
          cst <= (rx_data == EOL) ? C_RET_PULSE : C_HOLD;
        C_RET_PULSE: begin
          retire    <= 1'b1;
          fire_pend <= 1'b0;
          cst       <= C_QRUN;
        end
        default: cst <= C_QRUN;
      endcase
    end
  end

  // LED IOB pad FFs (PREREG). INIT 0. No SR so Vivado can pack into IOB.
  // Pins LD4-LD7 = H5/J5/T9/T10 (cited constraints/arty_a7_100.xdc).
  (* IOB = "TRUE" *) logic [3:0] led_q = 4'b0000;
  always_ff @(posedge clk) begin
    led_q[0] <= rst_n & hb[24];
    led_q[1] <= busy;
    led_q[2] <= result_v | r_ovf | pend_cmt | (|ntrunc);
    led_q[3] <= sw[0] | (|sw[3:1]) | btn[1] | (|btn[3:2]) | tbl | w_ovf;
  end
  assign led = led_q;
endmodule
