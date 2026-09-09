// a7ng_astra_07_scale_narrow.sv — ASTRA-07-SCALE-NARROW-01. PROGRAM=NO.
// Named wrap. Instantiates frozen a7ng_astra_09_integ_path (SGD inside; not patched).
// Fail-closed: dir post_count > CAND_CAP or ovf-ent → ST_INCOMP, ans/p0/p1=0, pend_acc=0.
// Truncated leftover must not publish ANSWER 4. Not 65536/800k. Not BOARD.
`timescale 1ns / 1ps
`include "a7ng_astra_07_scale_narrow.svh"
`include "a7ng_astra_09_integ_path.svh"

module a7ng_astra_07_scale_narrow #(
  parameter int unsigned ID_W       = 20,
  parameter int unsigned CAND_CAP   = A7NG_A07_CAND_CAP,
  parameter int unsigned MAX_PATH   = A7NG_A07_MAX_PATH,
  parameter logic [27:0] INDEX_BASE = 28'h0500_0000,
  parameter logic [27:0] FACT_BASE  = 28'h0580_0000
) (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [15:0] live_epoch_i,
  input  logic [15:0] sess_id_i,
  input  logic [1:0]  ctrl_i,
  input  logic        tok_valid_i,
  output logic        tok_ready_o,
  input  logic [7:0]  tok_i,
  input  logic        fire_i,
  input  logic        retire_i,
  input  logic        rew_v_i,
  input  logic signed [3:0] rew_i,
  input  logic [7:0]  rew_txn_i,
  input  logic [7:0]  rew_gen_i,
  input  logic [15:0] rew_epoch_i,
  input  logic        load_v_i,
  input  logic [4:0]  load_idx_i,
  input  logic signed [15:0] load_w_i,
  output logic        busy_o,
  output logic        result_v_o,
  output logic        pend_acc_o,
  output logic        pend_cmt_o,
  output logic [7:0]  txn_id_o,
  output logic [7:0]  gen_o,
  output logic [15:0] epoch_o,
  output logic [1:0]  sel_idx_o,
  output logic [ID_W-1:0] ans_o,
  output logic [ID_W-1:0] proof0_o,
  output logic [ID_W-1:0] proof1_o,
  output logic [4:0]  n_path_o,
  output logic [3:0]  status_o,
  output logic [7:0]  obj_o,
  output logic [7:0]  ctx_o,
  output logic signed [15:0] v_best_o,
  output logic signed [15:0] v_second_o,
  output logic signed [15:0] v_pred_o,
  output logic signed [7:0]  phi0_o,
  output logic signed [7:0]  pend_phi_o [0:31],
  output logic signed [15:0] w_o [0:31],
  output logic [15:0] n_upd_o,
  output logic [15:0] n_dup_o,
  output logic [15:0] n_bad_o,
  output logic [15:0] n_stale_o,
  output logic [15:0] n_oor_o,
  output logic [15:0] n_exh_o,
  output logic        txn_exh_o,
  output logic        load_from_tb_o,
  output logic [3:0]  m_axi_arid,
  output logic [27:0] m_axi_araddr,
  output logic [7:0]  m_axi_arlen,
  output logic [2:0]  m_axi_arsize,
  output logic [1:0]  m_axi_arburst,
  output logic        m_axi_arvalid,
  input  logic        m_axi_arready,
  input  logic [3:0]  m_axi_rid,
  input  logic [127:0] m_axi_rdata,
  input  logic [1:0]  m_axi_rresp,
  input  logic        m_axi_rlast,
  input  logic        m_axi_rvalid,
  output logic        m_axi_rready,
  output logic [15:0] n_ar_to_o,
  output logic [15:0] n_r_to_o,
  output logic [15:0] n_axi_err_o,
  output logic [15:0] n_drain_o,
  output logic [15:0] n_abandon_o,
  output logic        axi_ost_o,
  output logic        axi_abort_o,
  output logic [3:0]  ost_rid_o,
  output logic [15:0] dead_mask_o,
  output logic        cap_ovf_o,
  output logic [3:0]  a09_status_o,
  output logic [ID_W-1:0] a09_ans_o,
  output logic [ID_W-1:0] a09_proof0_o,
  output logic [4:0]  a09_npath_o
);
  logic        busy_a, res_a, acc_a, cmt_a;
  logic [3:0]  st_a;
  logic [ID_W-1:0] ans_a, p0_a, p1_a;
  logic [4:0]  np_a;
  logic [1:0]  sel_a;
  logic        busy_d, cap_ovf, pend_dir, force_incomp;
  logic [3:0]  pend_rid;

  a7ng_astra_09_integ_path #(
    .ID_W(ID_W), .CAND_CAP(CAND_CAP), .MAX_PATH(MAX_PATH),
    .INDEX_BASE(INDEX_BASE), .FACT_BASE(FACT_BASE)
  ) u_a09 (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_epoch_i), .sess_id_i(sess_id_i), .ctrl_i(ctrl_i),
    .tok_valid_i(tok_valid_i), .tok_ready_o(tok_ready_o), .tok_i(tok_i),
    .fire_i(fire_i), .retire_i(retire_i),
    .rew_v_i(rew_v_i), .rew_i(rew_i), .rew_txn_i(rew_txn_i), .rew_gen_i(rew_gen_i),
    .rew_epoch_i(rew_epoch_i),
    .load_v_i(load_v_i), .load_idx_i(load_idx_i), .load_w_i(load_w_i),
    .busy_o(busy_a), .result_v_o(res_a),
    .pend_acc_o(acc_a), .pend_cmt_o(cmt_a),
    .txn_id_o(txn_id_o), .gen_o(gen_o), .epoch_o(epoch_o), .sel_idx_o(sel_a),
    .ans_o(ans_a), .proof0_o(p0_a), .proof1_o(p1_a),
    .n_path_o(np_a), .status_o(st_a), .obj_o(obj_o), .ctx_o(ctx_o),
    .v_best_o(v_best_o), .v_second_o(v_second_o), .v_pred_o(v_pred_o), .phi0_o(phi0_o),
    .pend_phi_o(pend_phi_o), .w_o(w_o),
    .n_upd_o(n_upd_o), .n_dup_o(n_dup_o), .n_bad_o(n_bad_o), .n_stale_o(n_stale_o), .n_oor_o(n_oor_o),
    .n_exh_o(n_exh_o), .txn_exh_o(txn_exh_o),
    .load_from_tb_o(load_from_tb_o),
    .m_axi_arid(m_axi_arid), .m_axi_araddr(m_axi_araddr), .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize), .m_axi_arburst(m_axi_arburst),
    .m_axi_arvalid(m_axi_arvalid), .m_axi_arready(m_axi_arready),
    .m_axi_rid(m_axi_rid), .m_axi_rdata(m_axi_rdata), .m_axi_rresp(m_axi_rresp),
    .m_axi_rlast(m_axi_rlast), .m_axi_rvalid(m_axi_rvalid), .m_axi_rready(m_axi_rready),
    .n_ar_to_o(n_ar_to_o), .n_r_to_o(n_r_to_o), .n_axi_err_o(n_axi_err_o),
    .n_drain_o(n_drain_o), .n_abandon_o(n_abandon_o),
    .axi_ost_o(axi_ost_o), .axi_abort_o(axi_abort_o),
    .ost_rid_o(ost_rid_o), .dead_mask_o(dead_mask_o)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      busy_d <= 1'b0; cap_ovf <= 1'b0; pend_dir <= 1'b0; pend_rid <= 4'd0;
    end else begin
      busy_d <= busy_a;
      if (busy_a && !busy_d) cap_ovf <= 1'b0;
      if (m_axi_arvalid && m_axi_arready) begin
        pend_dir <= (m_axi_araddr >= INDEX_BASE) &&
                    (m_axi_araddr < (INDEX_BASE + A7NG_A07_DIR_SPAN));
        pend_rid <= m_axi_arid;
      end
      if (m_axi_rvalid && m_axi_rready && pend_dir && (m_axi_rid == pend_rid)) begin
        if (m_axi_rdata[47:32] > CAND_CAP[15:0]) cap_ovf <= 1'b1;
        if (m_axi_rdata[48]) cap_ovf <= 1'b1;
      end
    end
  end

  assign force_incomp = res_a && cap_ovf;
  assign busy_o       = busy_a;
  assign result_v_o   = res_a;
  assign pend_cmt_o   = cmt_a;
  assign cap_ovf_o    = cap_ovf;
  assign a09_status_o = st_a;
  assign a09_ans_o    = ans_a;
  assign a09_proof0_o = p0_a;
  assign a09_npath_o  = np_a;
  assign status_o     = force_incomp ? A7NG_A07_ST_INCOMP : st_a;
  assign ans_o        = force_incomp ? '0 : ans_a;
  assign proof0_o     = force_incomp ? '0 : p0_a;
  assign proof1_o     = force_incomp ? '0 : p1_a;
  assign n_path_o     = force_incomp ? 5'd0 : np_a;
  assign pend_acc_o   = force_incomp ? 1'b0 : acc_a;
  assign sel_idx_o    = force_incomp ? 2'd0 : sel_a;
endmodule
