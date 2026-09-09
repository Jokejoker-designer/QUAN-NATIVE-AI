// a7ng_astra_c4_lm06_byte256_arlang.sv — ASTRA-C4-LM06-BYTE256-ARLANG-01.
// PROGRAM=NO. Live C3 wrap QUERY/PROOF FPGA text -> compact tied-embed AR BYTE256.
// Prefix language "yes" from checkpoint, then proof dest-name via E[v]·h. Not qptext_gen.
// Does not edit KEEP / C3 wrap / TinyGPT / a7lm06_wmem.hex / qptext / c4q.
`timescale 1ns / 1ps
`include "a7ng_astra_c3_held_out.svh"
`include "a7ng_astra_c4_lm06_byte256.svh"
`include "a7ng_astra_c4_lm06_byte256_arlang.svh"

module a7ng_astra_c4_lm06_byte256_arlang (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [15:0] live_epoch_i,
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
  input  logic        c3_load_v_i,
  input  logic [4:0]  c3_load_idx_i,
  input  logic signed [15:0] c3_load_w_i,
  input  logic        g_load_v_i,
  input  logic [1:0]  g_load_sel_i,
  input  logic signed [15:0] g_load_w_i,
  output logic        busy_o,
  output logic        done_o,
  output logic        tok_valid_o,
  output logic [7:0]  tok_o,
  output logic        eos_o,
  output logic [9:0]  head10_o,
  output logic        masked_hi_o,
  output logic [15:0] n_host_tok_o,
  output logic [7:0]  n_out_o,
  output logic [7:0]  mat_q0_o,
  output logic [7:0]  mat_p0_o,
  output logic [3:0]  vocab_ver_o,
  output logic [3:0]  c3_status_o,
  output logic [19:0] c3_ans_o,
  output logic [19:0] c3_p0_o,
  output logic [19:0] c3_p1_o,
  output logic [7:0]  c3_subj_o,
  output logic        c3_result_v_o,
  output logic [15:0] n_host_winner_o,
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
  output logic        m_axi_rready
);
  typedef enum logic [2:0] { S_IDLE, S_C3, S_MAT, S_GOGEN, S_GEN, S_DONE } st_t;
  st_t st;

  logic c3_busy, c3_res, c3_pacc, c3_pcmt, c3_tbl;
  logic [7:0] c3_txn, c3_gen, c3_obj, c3_ctx, c3_subj;
  logic [1:0] c3_sel;
  logic [19:0] c3_ans, c3_p0, c3_p1;
  logic [4:0] c3_npath;
  logic [3:0] c3_st;
  logic [15:0] c3_nhw, c3_nha, c3_nupd, c3_ndup, c3_nbad;
  logic signed [15:0] c3_vb, c3_vs;
  logic signed [7:0] c3_phi0;
  logic signed [7:0] c3_pphi [0:31];
  logic signed [15:0] c3_w [0:31];
  logic c3_ret;

  logic g_go, g_ret, g_busy, g_done, g_tv, g_eos, g_mask;
  logic [7:0] g_tok, g_nout, g_q0, g_p0, g_qi0, g_ei0, g_o0, g_o1, g_o2;
  logic [9:0] g_head;
  logic [15:0] g_nhost;
  logic [3:0] g_vver;
  logic g_has;
  logic [19:0] lat_ans, lat_p0, lat_p1;
  logic [7:0] lat_subj;
  logic [3:0] lat_st;

  a7ng_astra_c3_held_out u_c3 (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_epoch_i), .ctrl_i(ctrl_i),
    .tok_valid_i(tok_valid_i), .tok_ready_o(tok_ready_o), .tok_i(tok_i),
    .fire_i(fire_i), .retire_i(c3_ret),
    .rew_v_i(rew_v_i), .rew_i(rew_i), .rew_txn_i(rew_txn_i), .rew_gen_i(rew_gen_i),
    .load_v_i(c3_load_v_i), .load_idx_i(c3_load_idx_i), .load_w_i(c3_load_w_i),
    .busy_o(c3_busy), .result_v_o(c3_res),
    .pend_acc_o(c3_pacc), .pend_cmt_o(c3_pcmt),
    .txn_id_o(c3_txn), .gen_o(c3_gen), .sel_idx_o(c3_sel),
    .ans_o(c3_ans), .proof0_o(c3_p0), .proof1_o(c3_p1),
    .n_path_o(c3_npath), .status_o(c3_st), .obj_o(c3_obj), .ctx_o(c3_ctx),
    .subj_o(c3_subj), .n_host_winner_o(c3_nhw), .n_host_addr_o(c3_nha),
    .v_best_o(c3_vb), .v_second_o(c3_vs), .phi0_o(c3_phi0),
    .pend_phi_o(c3_pphi), .w_o(c3_w),
    .n_upd_o(c3_nupd), .n_dup_o(c3_ndup), .n_bad_o(c3_nbad),
    .load_from_tb_o(c3_tbl),
    .m_axi_arid(m_axi_arid), .m_axi_araddr(m_axi_araddr), .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize), .m_axi_arburst(m_axi_arburst),
    .m_axi_arvalid(m_axi_arvalid), .m_axi_arready(m_axi_arready),
    .m_axi_rid(m_axi_rid), .m_axi_rdata(m_axi_rdata), .m_axi_rresp(m_axi_rresp),
    .m_axi_rlast(m_axi_rlast), .m_axi_rvalid(m_axi_rvalid), .m_axi_rready(m_axi_rready)
  );

  a7ng_astra_c4_lm06_byte256_arlang_gen u_gen (
    .clk(clk), .rst_n(rst_n), .go_i(g_go), .retire_i(g_ret),
    .load_v_i(g_load_v_i), .load_sel_i(g_load_sel_i), .load_w_i(g_load_w_i),
    .q0_i(g_qi0), .e0_i(g_ei0),
    .obj0_i(g_o0), .obj1_i(g_o1), .obj2_i(g_o2),
    .evid_has_i(g_has),
    .busy_o(g_busy), .done_o(g_done), .tok_valid_o(g_tv), .tok_o(g_tok), .eos_o(g_eos),
    .head10_o(g_head), .masked_hi_o(g_mask), .n_host_tok_o(g_nhost), .n_out_o(g_nout),
    .mat_q0_o(g_q0), .mat_p0_o(g_p0), .vocab_ver_o(g_vver)
  );

  assign busy_o = (st != S_IDLE) && (st != S_DONE);
  assign done_o = (st == S_DONE);
  assign tok_valid_o = g_tv;
  assign tok_o = g_tok;
  assign eos_o = g_eos;
  assign head10_o = g_head;
  assign masked_hi_o = g_mask;
  assign n_host_tok_o = 16'd0;
  assign n_out_o = g_nout;
  assign mat_q0_o = g_q0;
  assign mat_p0_o = g_p0;
  assign vocab_ver_o = A7NG_C4L_VOCAB_VER;
  assign c3_status_o = c3_st;
  assign c3_ans_o = (st == S_IDLE) ? c3_ans : lat_ans;
  assign c3_p0_o = (st == S_IDLE) ? c3_p0 : lat_p0;
  assign c3_p1_o = (st == S_IDLE) ? c3_p1 : lat_p1;
  assign c3_subj_o = (st == S_IDLE) ? c3_subj : lat_subj;
  assign c3_result_v_o = c3_res;
  assign n_host_winner_o = c3_nhw;
  assign load_from_tb_o = c3_tbl;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      g_go <= 1'b0;
      g_ret <= 1'b0;
      c3_ret <= 1'b0;
      g_qi0 <= 8'd0;
      g_ei0 <= 8'd0;
      g_o0 <= 8'd0;
      g_o1 <= 8'd0;
      g_o2 <= 8'd0;
      g_has <= 1'b0;
      lat_ans <= 20'd0;
      lat_p0 <= 20'd0;
      lat_p1 <= 20'd0;
      lat_subj <= 8'd0;
      lat_st <= 4'd0;
    end else begin
      g_go <= 1'b0;
      g_ret <= 1'b0;
      c3_ret <= retire_i;
      unique case (st)
        S_IDLE: begin
          if (fire_i) st <= S_C3;
        end
        S_C3: begin
          if (c3_res) begin
            lat_ans <= c3_ans;
            lat_p0 <= c3_p0;
            lat_p1 <= c3_p1;
            lat_subj <= c3_subj;
            lat_st <= c3_st;
            st <= S_MAT;
          end
        end
        S_MAT: begin
          g_qi0 <= a7ng_c4l_ch(lat_subj, 0);
          g_ei0 <= a7ng_c4l_ch(lat_p0[7:0], 0);
          if (lat_st == A7NG_C3_ST_ANSWER) begin
            g_has <= 1'b1;
            g_o0 <= a7ng_c4l_ch(lat_ans[7:0], 0);
            g_o1 <= a7ng_c4l_ch(lat_ans[7:0], 1);
            g_o2 <= a7ng_c4l_ch(lat_ans[7:0], 2);
          end else begin
            g_has <= 1'b0;
            g_o0 <= A7NG_C4L_EOS;
            g_o1 <= A7NG_C4L_EOS;
            g_o2 <= A7NG_C4L_EOS;
          end
          st <= S_GOGEN;
        end
        S_GOGEN: begin
          g_go <= 1'b1;
          st <= S_GEN;
        end
        S_GEN: begin
          if (g_done) st <= S_DONE;
        end
        S_DONE: begin
          if (retire_i) begin
            g_ret <= 1'b1;
            st <= S_IDLE;
          end
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
