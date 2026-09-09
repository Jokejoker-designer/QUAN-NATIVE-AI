// a7ng_astra_09_r5_uart_iso_inner_wrap.sv — ASTRA-09-R5-UART-ISO-INNER-01.
// PROGRAM=NO. Bag-local UART ISO glue. Instantiates frozen
// a7ng_astra_09_r2_cand_ovf only. Pass numbers from inner u_sgd, not a
// second SGD instance. Frozen A09-R2 does not export go_upd/x/rew; UART
// FSM forces those inner ports. Not PRODUCTION_TOP. Not a bit.
`timescale 1ns / 1ps

module a7ng_astra_09_r5_uart_iso_inner_wrap (
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
  localparam logic [7:0]  MAGIC  = 8'hA2;
  localparam logic [7:0]  CMD_ISO = 8'hA5;
  localparam logic [7:0]  EOL    = 8'h0A;

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

  logic        tok_v, tok_r, fire, retire, busy, result_v, tbl;
  logic        pend_acc, pend_cmt, txn_exh, r_ovf, w_ovf;
  logic [7:0]  tok_b, txn_id, gen, obj, ctx;
  logic [15:0] epoch, n_upd, n_dup, n_bad, n_stale, n_oor, n_exh, ntrunc;
  logic [1:0]  sel_idx;
  logic [19:0] ans, p0, p1;
  logic [4:0]  npath;
  logic [3:0]  status;
  logic signed [15:0] v_best, v_second, v_pred;
  logic signed [7:0]  phi0;
  logic signed [7:0]  pend_phi [0:31];
  logic signed [15:0] w_a09 [0:31];
  logic [3:0]  arid, ost_rid, rid;
  logic [27:0] araddr;
  logic [7:0]  arlen;
  logic [2:0]  arsize;
  logic [1:0]  arburst, rresp;
  logic        arvalid, arready, rvalid, rready, rlast, axi_ost, axi_abort;
  logic [127:0] rdata;
  logic [15:0] narto, nrto, nerr, ndrain, naban, dead_mask;

  assign tok_v  = 1'b0;
  assign tok_b  = 8'd0;
  assign fire   = 1'b0;
  assign retire = 1'b0;
  assign arready = 1'b1;
  assign rid     = 4'd0;
  assign rdata   = 128'd0;
  assign rresp   = 2'b00;
  assign rlast   = 1'b1;
  assign rvalid  = 1'b0;

  (* keep_hierarchy = "yes" *)
  a7ng_astra_09_r2_cand_ovf u_a09r2 (
    .clk(clk), .rst_n(rst_n),
    .live_epoch_i(16'd7), .sess_id_i(16'd7), .ctrl_i(2'd0),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok_b),
    .fire_i(fire), .retire_i(retire),
    .rew_v_i(1'b0), .rew_i(4'sd0), .rew_txn_i(8'd0), .rew_gen_i(8'd0),
    .rew_epoch_i(16'd0),
    .load_v_i(1'b0), .load_idx_i(5'd0), .load_w_i(16'sd0),
    .busy_o(busy), .result_v_o(result_v),
    .pend_acc_o(pend_acc), .pend_cmt_o(pend_cmt),
    .txn_id_o(txn_id), .gen_o(gen), .epoch_o(epoch), .sel_idx_o(sel_idx),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1),
    .n_path_o(npath), .status_o(status), .obj_o(obj), .ctx_o(ctx),
    .v_best_o(v_best), .v_second_o(v_second), .v_pred_o(v_pred), .phi0_o(phi0),
    .pend_phi_o(pend_phi), .w_o(w_a09),
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

  logic inner_rdy, inner_dn;
  logic signed [15:0] inner_w0, inner_w1, inner_v;
  assign inner_rdy = u_a09r2.u_sgd.ready_o;
  assign inner_dn  = u_a09r2.u_sgd.done_o;
  assign inner_w0  = u_a09r2.u_sgd.w_o[0];
  assign inner_w1  = u_a09r2.u_sgd.w_o[1];
  assign inner_v   = u_a09r2.u_sgd.v_q8_o;

  logic signed [7:0]  xiso [0:31];
  logic signed [7:0]  x0_lat;
  logic signed [3:0]  iso_rew;
  logic signed [7:0]  rew8_lat;
  logic               hold_x, pulse_go;
  integer ki;

  always_comb begin
    for (ki = 0; ki < 32; ki = ki + 1)
      xiso[ki] = 8'sd0;
    xiso[0] = x0_lat;
  end

  // Frozen A09-R2 ties inner go_upd/x/rew to query/pending phi. Isolated
  // UART ISO injects the law vector into the same u_sgd without a second
  // SGD instance. TB does not poke these nets.
  always @(*) begin
    if (!rst_n) begin
      release u_a09r2.u_sgd.x_i;
      release u_a09r2.u_sgd.reward_i;
      release u_a09r2.u_sgd.go_upd_i;
    end else begin
      if (hold_x) begin
        force u_a09r2.u_sgd.x_i = xiso;
        force u_a09r2.u_sgd.reward_i = iso_rew;
      end else begin
        release u_a09r2.u_sgd.x_i;
        release u_a09r2.u_sgd.reward_i;
      end
      if (pulse_go)
        force u_a09r2.u_sgd.go_upd_i = 1'b1;
      else
        release u_a09r2.u_sgd.go_upd_i;
    end
  end

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
      cst      <= C_IDLE;
      hold_x   <= 1'b0;
      pulse_go <= 1'b0;
      iso_rew  <= 4'sd0;
      x0_lat   <= 8'sd0;
      rew8_lat <= 8'sd0;
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
      pulse_go <= 1'b0;
      tx_start <= 1'b0;
      hb <= hb + 25'd1;

      unique case (cst)
        C_IDLE: begin
          hold_x <= 1'b0;
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
          hold_x <= 1'b1;
          if (inner_rdy)
            cst <= C_GO;
        end
        C_GO: begin
          hold_x <= 1'b1;
          if (inner_rdy)
            pulse_go <= 1'b1;
          else
            cst <= C_WAIT;
        end
        C_WAIT: begin
          hold_x <= 1'b1;
          if (inner_dn) begin
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
            hold_x    <= 1'b0;
            cst       <= C_TX;
          end
        end
        C_TX: begin
          hold_x <= 1'b0;
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
  assign led[1] = inner_rdy;
  assign led[2] = (cst != C_IDLE);
  assign led[3] = sw[0] | (|sw[3:1]) | btn[1] | (|btn[3:2]) | tbl | w_ovf;
endmodule
