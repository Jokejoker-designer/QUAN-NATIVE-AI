// arty_a7_astra_rtp_soc_top.sv — ASTRA-11 RTP SOC (auditor fix #7). PROGRAM=NO.
// UART bytes → a7ng_astra_rtp_pipe_r2 → compact proof/status TX.
// On-chip AXI BRAM with RTP-R2 BASE 17/34 plant. No MIG. freeze unused (no SGD).
// Pins from constraints/arty_a7_100.xdc only. Do not overwrite frozen SoC tops.
`timescale 1ns / 1ps

module arty_a7_astra_rtp_soc_top (
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
  localparam int unsigned TX_N   = 16;
  localparam logic [7:0]  MAGIC  = 8'hA2;
  localparam logic [7:0]  EOL    = 8'h0A;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000;
  localparam logic [27:0] FACT_BASE  = 28'h0580_0000;

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
  logic        ovf, neg, amb;
  logic [7:0]  tok_b, subj, obj, rel, ctx, ncand, nload;
  logic [19:0] ans, p0, p1;
  logic [3:0]  status;
  logic [15:0] nfar, nfok, nferr, nfto, narto, ndir, nhost;
  logic [3:0]  arid;
  logic [27:0] araddr;
  logic [7:0]  arlen;
  logic [2:0]  arsize;
  logic [1:0]  arburst;
  logic        arvalid, arready, rvalid, rready, rlast;
  logic [3:0]  rid;
  logic [127:0] rdata;
  logic [1:0]  rresp;

  logic [7:0] fifo [0:FIFO_N-1];
  logic [FIFO_W-1:0] wr_ptr, rd_ptr;
  logic [FIFO_W:0]   count;
  logic              fire_pend, sent;
  logic              fifo_full, fifo_empty;

  assign fifo_full  = (count == FIFO_N[FIFO_W:0]);
  assign fifo_empty = (count == '0);

  logic [7:0]  tx_bytes [0:TX_N-1];
  logic [3:0]  tx_idx;
  logic        tx_active, do_retire;
  logic [24:0] hb;
  logic        push, pop;
  logic        is_eol;

  a7ng_astra_rtp_pipe_r2 #(
    .N_EDGES(16), .ID_W(20), .WALK_ID_W(20), .CAND_CAP(16),
    .INDEX_BASE(INDEX_BASE), .FACT_BASE(FACT_BASE)
  ) u_pipe (
    .clk(clk), .rst_n(rst_n),
    .live_epoch_i(16'd7),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok_b),
    .fire_i(fire), .retire_i(retire),
    .busy_o(busy), .result_v_o(result_v),
    .subj_id_o(subj), .obj_id_o(obj), .rel_id_o(rel), .ctx_id_o(ctx),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1), .status_o(status),
    .n_cand_o(ncand), .n_load_o(nload),
    .n_fact_ar_o(nfar), .n_fact_ok_o(nfok), .n_fact_err_o(nferr),
    .n_fact_to_o(nfto), .n_ar_to_o(narto),
    .n_dir_ar_o(ndir), .n_host_any_o(nhost),
    .ovf_o(ovf), .neg_o(neg), .amb_o(amb), .load_from_tb_o(tbl),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  (* keep_hierarchy = "yes" *)
  a7ng_axi_bram128 #(
    .DEPTH_WORDS(256), .INDEX_BASE(INDEX_BASE), .PLANT_R2_BASE(1'b1)
  ) u_sram (
    .clk(clk), .rst_n(rst_n),
    .s_axi_awid(4'd0), .s_axi_awaddr(28'd0), .s_axi_awlen(8'd0),
    .s_axi_awsize(3'd4), .s_axi_awburst(2'b01),
    .s_axi_awvalid(1'b0), .s_axi_awready(),
    .s_axi_wdata(128'd0), .s_axi_wstrb(16'd0), .s_axi_wlast(1'b0),
    .s_axi_wvalid(1'b0), .s_axi_wready(),
    .s_axi_bid(), .s_axi_bresp(), .s_axi_bvalid(), .s_axi_bready(1'b1),
    .s_axi_arid(arid), .s_axi_araddr(araddr), .s_axi_arlen(arlen),
    .s_axi_arsize(arsize), .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid), .s_axi_arready(arready),
    .s_axi_rid(rid), .s_axi_rdata(rdata), .s_axi_rresp(rresp),
    .s_axi_rlast(rlast), .s_axi_rvalid(rvalid), .s_axi_rready(rready)
  );

  assign is_eol = (rx_data == EOL) || (rx_data == 8'h00);
  assign push   = rx_valid && !is_eol && !fifo_full;
  assign pop    = !fifo_empty && tok_r && !tx_active && !do_retire;

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
      tx_start <= 1'b0;
      tx_data  <= 8'd0;
      tx_idx   <= 4'd0;
      tx_active <= 1'b0;
      do_retire <= 1'b0;
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
      tx_start <= 1'b0;
      hb <= hb + 25'd1;

      if (rx_valid && is_eol)
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

      if (fire_pend && (count == '0) && !push && tok_r && !busy && !tx_active && !do_retire && !pop) begin
        fire <= 1'b1;
        fire_pend <= 1'b0;
      end

      if (!result_v)
        sent <= 1'b0;

      if (result_v && !sent && !tx_active && !do_retire) begin
        tx_bytes[0]  <= MAGIC;
        tx_bytes[1]  <= {tbl, ovf, neg, amb, status};
        tx_bytes[2]  <= ans[7:0];
        tx_bytes[3]  <= ans[15:8];
        tx_bytes[4]  <= {4'd0, ans[19:16]};
        tx_bytes[5]  <= p0[7:0];
        tx_bytes[6]  <= p0[15:8];
        tx_bytes[7]  <= {4'd0, p0[19:16]};
        tx_bytes[8]  <= p1[7:0];
        tx_bytes[9]  <= p1[15:8];
        tx_bytes[10] <= {4'd0, p1[19:16]};
        tx_bytes[11] <= nload;
        tx_bytes[12] <= nfok[7:0];
        tx_bytes[13] <= ndir[7:0];
        tx_bytes[14] <= ncand;
        tx_bytes[15] <= EOL;
        tx_idx    <= 4'd0;
        tx_active <= 1'b1;
        sent      <= 1'b1;
      end

      if (tx_active && !tx_busy && !tx_start) begin
        tx_data  <= tx_bytes[tx_idx];
        tx_start <= 1'b1;
        if (tx_idx == 4'(TX_N-1)) begin
          tx_active <= 1'b0;
          do_retire <= 1'b1;
        end else
          tx_idx <= tx_idx + 4'd1;
      end

      if (do_retire && !tx_busy && !tx_start && !tx_active) begin
        retire    <= 1'b1;
        do_retire <= 1'b0;
      end
    end
  end

  assign led[0] = rst_n & hb[24];
  assign led[1] = busy;
  assign led[2] = result_v | (|nfar) | (|nfok) | (|ndir);
  assign led[3] = sw[0] | (|sw[3:1]) | btn[1] | (|btn[3:2]) | (|subj) | (|obj)
                | (|rel) | (|ctx) | (|nferr) | (|nfto) | (|narto) | (|nhost);
endmodule
