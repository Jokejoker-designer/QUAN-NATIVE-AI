// a7ng_astra_11_a09r2_impl_wrap.sv — ASTRA-11-A09R2-IMPL-ROUTE-01. PROGRAM=NO. BIT=NO.
// Named impl/route wrapper. Instantiates a7ng_astra_09_r2_cand_ovf (no copy-paste graph).
// Frozen a7ng_astra_09_integ_path is not instantiated. MMCM 100→50 + BUFG.
// Routed WNS includes clock-network delay. No UART. No BRAM plant.
`timescale 1ns / 1ps

module a7ng_astra_11_a09r2_impl_wrap (
  input  logic       CLK100MHZ,
  input  logic [3:0] sw,
  input  logic [3:0] btn,
  output logic [3:0] led
);
  logic clkfb, clk50u, clk, locked;
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

  logic        tok_ready, busy, result_v, pend_acc, pend_cmt, txn_exh, load_from_tb;
  logic [7:0]  txn_id, gen, obj, ctx;
  logic [15:0] epoch, n_upd, n_dup, n_bad, n_stale, n_oor, n_exh, n_trunc;
  logic [1:0]  sel_idx;
  logic [19:0] ans, proof0, proof1;
  logic [4:0]  n_path;
  logic [3:0]  status;
  logic signed [15:0] v_best, v_second, v_pred, w0;
  logic signed [7:0]  phi0;
  logic signed [7:0]  pend_phi [0:31];
  logic signed [15:0] w [0:31];
  logic [3:0]  m_axi_arid, ost_rid;
  logic [27:0] m_axi_araddr;
  logic [7:0]  m_axi_arlen;
  logic [2:0]  m_axi_arsize;
  logic [1:0]  m_axi_arburst;
  logic        m_axi_arvalid, m_axi_rready, axi_ost, axi_abort, r_ovf, w_ovf;
  logic [15:0] n_ar_to, n_r_to, n_axi_err, n_drain, n_abandon, dead_mask;

  (* keep_hierarchy = "yes" *)
  a7ng_astra_09_r2_cand_ovf u_a09r2 (
    .clk(clk),
    .rst_n(rst_n),
    .live_epoch_i({12'h0, sw}),
    .sess_id_i({12'h0, sw}),
    .ctrl_i(sw[1:0]),
    .tok_valid_i(sw[0]),
    .tok_ready_o(tok_ready),
    .tok_i({4'h0, sw}),
    .fire_i(btn[1]),
    .retire_i(btn[2]),
    .rew_v_i(btn[3]),
    .rew_i($signed(sw)),
    .rew_txn_i({4'h0, sw}),
    .rew_gen_i({4'h0, sw}),
    .rew_epoch_i({12'h0, sw}),
    .load_v_i(1'b0),
    .load_idx_i(5'd0),
    .load_w_i(16'sd0),
    .busy_o(busy),
    .result_v_o(result_v),
    .pend_acc_o(pend_acc),
    .pend_cmt_o(pend_cmt),
    .txn_id_o(txn_id),
    .gen_o(gen),
    .epoch_o(epoch),
    .sel_idx_o(sel_idx),
    .ans_o(ans),
    .proof0_o(proof0),
    .proof1_o(proof1),
    .n_path_o(n_path),
    .status_o(status),
    .obj_o(obj),
    .ctx_o(ctx),
    .v_best_o(v_best),
    .v_second_o(v_second),
    .v_pred_o(v_pred),
    .phi0_o(phi0),
    .pend_phi_o(pend_phi),
    .w_o(w),
    .n_upd_o(n_upd),
    .n_dup_o(n_dup),
    .n_bad_o(n_bad),
    .n_stale_o(n_stale),
    .n_oor_o(n_oor),
    .n_exh_o(n_exh),
    .txn_exh_o(txn_exh),
    .load_from_tb_o(load_from_tb),
    .m_axi_arid(m_axi_arid),
    .m_axi_araddr(m_axi_araddr),
    .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize),
    .m_axi_arburst(m_axi_arburst),
    .m_axi_arvalid(m_axi_arvalid),
    .m_axi_arready(1'b1),
    .m_axi_rid(4'd0),
    .m_axi_rdata(128'd0),
    .m_axi_rresp(2'b00),
    .m_axi_rlast(1'b0),
    .m_axi_rvalid(1'b0),
    .m_axi_rready(m_axi_rready),
    .n_ar_to_o(n_ar_to),
    .n_r_to_o(n_r_to),
    .n_axi_err_o(n_axi_err),
    .n_drain_o(n_drain),
    .n_abandon_o(n_abandon),
    .axi_ost_o(axi_ost),
    .axi_abort_o(axi_abort),
    .ost_rid_o(ost_rid),
    .dead_mask_o(dead_mask),
    .n_trunc_o(n_trunc),
    .r_ovf_o(r_ovf),
    .w_ovf_o(w_ovf)
  );

  assign w0 = w[0];

  logic [7:0] probe;
  assign probe = {4'b0, busy, result_v, pend_acc, pend_cmt}
               ^ txn_id ^ gen ^ epoch[7:0] ^ epoch[15:8]
               ^ {6'b0, sel_idx} ^ ans[7:0] ^ ans[15:8] ^ {4'b0, ans[19:16]}
               ^ proof0[7:0] ^ proof1[7:0] ^ {3'b0, n_path} ^ {4'b0, status}
               ^ obj ^ ctx ^ v_best[7:0] ^ v_second[7:0] ^ v_pred[7:0]
               ^ phi0 ^ w0[7:0] ^ n_upd[7:0] ^ n_dup[7:0] ^ n_bad[7:0]
               ^ n_stale[7:0] ^ n_oor[7:0] ^ n_exh[7:0]
               ^ {7'b0, txn_exh} ^ {7'b0, load_from_tb} ^ {7'b0, tok_ready}
               ^ {4'b0, m_axi_arid} ^ m_axi_araddr[7:0] ^ m_axi_arlen
               ^ {5'b0, m_axi_arsize} ^ {6'b0, m_axi_arburst}
               ^ {7'b0, m_axi_arvalid} ^ {7'b0, m_axi_rready}
               ^ n_ar_to[7:0] ^ n_r_to[7:0] ^ n_axi_err[7:0]
               ^ n_drain[7:0] ^ n_abandon[7:0] ^ {7'b0, axi_ost}
               ^ {7'b0, axi_abort} ^ {4'b0, ost_rid} ^ dead_mask[7:0]
               ^ n_trunc[7:0] ^ n_trunc[15:8] ^ {7'b0, r_ovf} ^ {7'b0, w_ovf};

  (* keep = "true" *) logic [3:0] led_q;
  always_ff @(posedge clk) begin
    if (!rst_n)
      led_q <= 4'd0;
    else
      led_q <= probe[3:0] ^ sw;
  end
  assign led = led_q;
endmodule
