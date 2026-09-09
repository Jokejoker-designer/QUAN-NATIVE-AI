// a7ng_astra_c2_persist_commit.sv — ASTRA-C2-PERSIST-COMMIT-01. PROGRAM=NO.
// New named DUT. Does not edit ASTRA-06, prior_store, C0, or C1 KEEP RTL.
// ONE UNKNOWN: 20-bit persist identity + five transaction phases + false success=0
// through a modeled AXI journal (not MIG).
`timescale 1ns / 1ps
`include "a7ng_astra_c2_persist_commit.svh"

module a7ng_astra_c2_persist_commit (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        persist_clr_i,
  input  logic        reload_i,
  input  logic        retire_i,
  input  logic        upd_valid_i,
  output logic        upd_ready_o,
  input  logic [19:0] upd_subj_i,
  input  logic [19:0] upd_rel_i,
  input  logic [19:0] upd_obj_i,
  input  logic [19:0] upd_ctx_i,
  input  logic [7:0]  upd_gen_i,
  input  logic [7:0]  upd_txn_i,
  input  logic [7:0]  upd_schema_i,
  input  logic signed [3:0] upd_rew_i,
  input  logic        lk_go_i,
  input  logic [19:0] lk_subj_i,
  input  logic [19:0] lk_rel_i,
  input  logic [19:0] lk_obj_i,
  input  logic [19:0] lk_ctx_i,
  output logic        lk_hit_o,
  output logic        busy_o,
  output logic [3:0]  phase_o,
  output logic [3:0]  fail_code_o,
  output logic signed [15:0] live_w0_o,
  output logic        persist_valid_o,
  output logic [19:0] persist_subj_o,
  output logic [19:0] persist_rel_o,
  output logic [19:0] persist_obj_o,
  output logic [19:0] persist_ctx_o,
  output logic [7:0]  persist_gen_o,
  output logic [7:0]  persist_txn_o,
  output logic [7:0]  persist_schema_o,
  output logic signed [15:0] persist_w0_o,
  output logic [15:0] n_upd_o,
  output logic [15:0] n_dup_o,
  output logic [15:0] n_stale_o,
  output logic [15:0] n_schema_o,
  output logic [15:0] n_false_o,
  output logic [3:0]  m_axi_awid,
  output logic [27:0] m_axi_awaddr,
  output logic [7:0]  m_axi_awlen,
  output logic [2:0]  m_axi_awsize,
  output logic [1:0]  m_axi_awburst,
  output logic        m_axi_awvalid,
  input  logic        m_axi_awready,
  output logic [127:0] m_axi_wdata,
  output logic [15:0] m_axi_wstrb,
  output logic        m_axi_wlast,
  output logic        m_axi_wvalid,
  input  logic        m_axi_wready,
  input  logic [3:0]  m_axi_bid,
  input  logic [1:0]  m_axi_bresp,
  input  logic        m_axi_bvalid,
  output logic        m_axi_bready,
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
  typedef enum logic [3:0] {
    S_IDLE, S_RECV, S_DECIDE, S_ACC, S_CMT, S_AW, S_W, S_B, S_HOLD, S_FAIL,
    S_AR, S_R
  } st_t;
  st_t st;

  logic        p_valid;
  logic [19:0] p_subj, p_rel, p_obj, p_ctx;
  logic [7:0]  p_gen, p_txn, p_schema;
  logic signed [15:0] p_w0;
  logic [19:0] u_subj, u_rel, u_obj, u_ctx;
  logic [7:0]  u_gen, u_txn, u_schema;
  logic signed [3:0] u_rew;
  logic signed [15:0] live_w0;
  logic [3:0]  phase, fail_code;
  logic [15:0] n_upd = 16'd0, n_dup = 16'd0, n_stale = 16'd0, n_schema = 16'd0, n_false = 16'd0;
  logic [127:0] wbeat, rbeat;
  logic        awv, wv, arv;

  function automatic logic [127:0] pack_rec(
      input logic [19:0] s, r, o, c,
      input logic [7:0] g, t, sch,
      input logic signed [15:0] w);
    begin
      pack_rec = {7'd0, 1'b1, w, sch, t, g, c, r, o, s};
    end
  endfunction

  assign upd_ready_o = (st == S_IDLE);
  assign busy_o = (st != S_IDLE) && (st != S_HOLD) && (st != S_FAIL);
  assign phase_o = phase;
  assign fail_code_o = fail_code;
  assign live_w0_o = live_w0;
  assign persist_valid_o = p_valid;
  assign persist_subj_o = p_subj;
  assign persist_rel_o = p_rel;
  assign persist_obj_o = p_obj;
  assign persist_ctx_o = p_ctx;
  assign persist_gen_o = p_gen;
  assign persist_txn_o = p_txn;
  assign persist_schema_o = p_schema;
  assign persist_w0_o = p_w0;
  assign n_upd_o = n_upd;
  assign n_dup_o = n_dup;
  assign n_stale_o = n_stale;
  assign n_schema_o = n_schema;
  assign n_false_o = n_false;
  assign lk_hit_o = p_valid && (lk_subj_i == p_subj) && (lk_rel_i == p_rel)
                    && (lk_obj_i == p_obj) && (lk_ctx_i == p_ctx);
  assign m_axi_awid = 4'd1;
  assign m_axi_awaddr = A7NG_C2_PERSIST_BASE;
  assign m_axi_awlen = 8'd0;
  assign m_axi_awsize = 3'd4;
  assign m_axi_awburst = 2'b01;
  assign m_axi_awvalid = awv;
  assign m_axi_wdata = wbeat;
  assign m_axi_wstrb = 16'hFFFF;
  assign m_axi_wlast = 1'b1;
  assign m_axi_wvalid = wv;
  assign m_axi_bready = (st == S_B);
  assign m_axi_arid = 4'd2;
  assign m_axi_araddr = A7NG_C2_PERSIST_BASE;
  assign m_axi_arlen = 8'd0;
  assign m_axi_arsize = 3'd4;
  assign m_axi_arburst = 2'b01;
  assign m_axi_arvalid = arv;
  assign m_axi_rready = (st == S_R);

  always_ff @(posedge clk) begin
    if (persist_clr_i) begin
      p_valid <= 1'b0;
      p_subj <= '0; p_rel <= '0; p_obj <= '0; p_ctx <= '0;
      p_gen <= '0; p_txn <= '0; p_schema <= '0;
      p_w0 <= 16'sd0;
    end else if ((st == S_B) && m_axi_bvalid && m_axi_bready && (m_axi_bresp == 2'b00)) begin
      p_valid <= 1'b1;
      p_subj <= u_subj; p_rel <= u_rel; p_obj <= u_obj; p_ctx <= u_ctx;
      p_gen <= u_gen; p_txn <= u_txn; p_schema <= u_schema;
      p_w0 <= live_w0;
    end else if ((st == S_R) && m_axi_rvalid && m_axi_rready && m_axi_rlast
                 && (m_axi_rresp == 2'b00) && m_axi_rdata[120]) begin
      p_valid <= 1'b1;
      p_subj <= m_axi_rdata[19:0];
      p_obj  <= m_axi_rdata[39:20];
      p_rel  <= m_axi_rdata[59:40];
      p_ctx  <= m_axi_rdata[79:60];
      p_gen  <= m_axi_rdata[87:80];
      p_txn  <= m_axi_rdata[95:88];
      p_schema <= m_axi_rdata[103:96];
      p_w0   <= m_axi_rdata[119:104];
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      phase <= A7NG_C2_PH_IDLE;
      fail_code <= A7NG_C2_F_NONE;
      live_w0 <= 16'sd0;
      u_subj <= '0; u_rel <= '0; u_obj <= '0; u_ctx <= '0;
      u_gen <= '0; u_txn <= '0; u_schema <= '0; u_rew <= '0;
      awv <= 1'b0; wv <= 1'b0; arv <= 1'b0; wbeat <= '0; rbeat <= '0;
    end else begin
      unique case (st)
        S_IDLE: begin
          phase <= A7NG_C2_PH_IDLE;
          fail_code <= A7NG_C2_F_NONE;
          awv <= 1'b0; wv <= 1'b0; arv <= 1'b0;
          if (reload_i) begin
            arv <= 1'b1;
            st <= S_AR;
          end else if (upd_valid_i) begin
            u_subj <= upd_subj_i; u_rel <= upd_rel_i; u_obj <= upd_obj_i;
            u_ctx <= upd_ctx_i; u_gen <= upd_gen_i; u_txn <= upd_txn_i;
            u_schema <= upd_schema_i; u_rew <= upd_rew_i;
            phase <= A7NG_C2_PH_RECEIVED;
            st <= S_RECV;
          end
        end
        S_RECV: st <= S_DECIDE;
        S_DECIDE: begin
          if (u_schema != A7NG_C2_SCHEMA_VER) begin
            fail_code <= A7NG_C2_F_SCHEMA;
            n_schema <= n_schema + 16'd1;
            phase <= A7NG_C2_PH_FAILED;
            st <= S_FAIL;
          end else if (p_valid && (u_subj == p_subj) && (u_rel == p_rel)
                       && (u_obj == p_obj) && (u_ctx == p_ctx)
                       && (u_gen == p_gen)) begin
            fail_code <= A7NG_C2_F_DUP;
            n_dup <= n_dup + 16'd1;
            phase <= A7NG_C2_PH_FAILED;
            st <= S_FAIL;
          end else if (p_valid && (u_subj == p_subj) && (u_rel == p_rel)
                       && (u_obj == p_obj) && (u_ctx == p_ctx)
                       && (u_gen != p_gen)) begin
            fail_code <= A7NG_C2_F_STALE_GEN;
            n_stale <= n_stale + 16'd1;
            phase <= A7NG_C2_PH_FAILED;
            st <= S_FAIL;
          end else if (p_valid && (u_txn != p_txn) && (u_subj == p_subj)
                       && (u_rel == p_rel) && (u_obj == p_obj)
                       && (u_ctx == p_ctx) && (u_gen == p_gen)) begin
            fail_code <= A7NG_C2_F_BAD_TXN;
            st <= S_FAIL;
            phase <= A7NG_C2_PH_FAILED;
          end else begin
            phase <= A7NG_C2_PH_ACCEPTED;
            st <= S_ACC;
          end
        end
        S_ACC: begin
          phase <= A7NG_C2_PH_ACCEPTED;
          st <= S_CMT;
        end
        S_CMT: begin
          live_w0 <= live_w0 + {{12{u_rew[3]}}, u_rew};
          n_upd <= n_upd + 16'd1;
          phase <= A7NG_C2_PH_COMMITTED;
          wbeat <= pack_rec(u_subj, u_rel, u_obj, u_ctx, u_gen, u_txn, u_schema,
                            live_w0 + {{12{u_rew[3]}}, u_rew});
          awv <= 1'b1;
          st <= S_AW;
        end
        S_AW: begin
          phase <= A7NG_C2_PH_COMMITTED;
          if (awv && m_axi_awready) begin
            awv <= 1'b0;
            wv <= 1'b1;
            st <= S_W;
          end
        end
        S_W: begin
          phase <= A7NG_C2_PH_COMMITTED;
          if (wv && m_axi_wready) begin
            wv <= 1'b0;
            st <= S_B;
          end
        end
        S_B: begin
          phase <= A7NG_C2_PH_COMMITTED;
          if (m_axi_bvalid && m_axi_bready) begin
            if (m_axi_bresp != 2'b00) begin
              fail_code <= A7NG_C2_F_NO_PEND;
              phase <= A7NG_C2_PH_FAILED;
              st <= S_FAIL;
            end else begin
              phase <= A7NG_C2_PH_PERSISTED;
              st <= S_HOLD;
            end
          end
        end
        S_HOLD: begin
          phase <= A7NG_C2_PH_PERSISTED;
          if (p_valid && ((p_subj != u_subj) || (p_obj != u_obj)
              || (p_rel != u_rel) || (p_ctx != u_ctx) || (p_w0 != live_w0)))
            n_false <= n_false + 16'd1;
          if (retire_i) st <= S_IDLE;
        end
        S_FAIL: begin
          phase <= A7NG_C2_PH_FAILED;
          if (retire_i) st <= S_IDLE;
        end
        S_AR: begin
          if (arv && m_axi_arready) begin
            arv <= 1'b0;
            st <= S_R;
          end
        end
        S_R: begin
          if (m_axi_rvalid && m_axi_rready && m_axi_rlast) begin
            rbeat <= m_axi_rdata;
            if (m_axi_rresp == 2'b00 && m_axi_rdata[120]) begin
              live_w0 <= m_axi_rdata[119:104];
              u_subj <= m_axi_rdata[19:0];
              u_obj  <= m_axi_rdata[39:20];
              u_rel  <= m_axi_rdata[59:40];
              u_ctx  <= m_axi_rdata[79:60];
              u_gen  <= m_axi_rdata[87:80];
              u_txn  <= m_axi_rdata[95:88];
              u_schema <= m_axi_rdata[103:96];
              phase <= A7NG_C2_PH_PERSISTED;
              st <= S_HOLD;
            end else begin
              fail_code <= A7NG_C2_F_NO_PEND;
              phase <= A7NG_C2_PH_FAILED;
              st <= S_FAIL;
            end
          end
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
