// a7ng_astra_c2_persist_multi_slot.sv — ASTRA-C2-PERSIST-MULTI-SLOT-01. PROGRAM=NO.
// New named DUT. Does not edit persist-commit KEEP, ASTRA-06, prior_store, C0, C1 KEEP.
// ONE UNKNOWN: CAP_N=2 miss-allocate / cache-hit / full / dirty eviction + AXI
// write-back of a committed victim. Journal addr = PERSIST_BASE+axi_idx*16, not low16.
`timescale 1ns / 1ps
`include "a7ng_astra_c2_persist_multi_slot.svh"

module a7ng_astra_c2_persist_multi_slot (
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
  output logic [7:0]  occ_o,
  output logic        cap_full_o,
  output logic        s0_valid_o,
  output logic        s0_dirty_o,
  output logic [19:0] s0_subj_o,
  output logic [19:0] s0_obj_o,
  output logic [19:0] s0_ctx_o,
  output logic signed [15:0] s0_w0_o,
  output logic [1:0]  s0_axi_o,
  output logic        s1_valid_o,
  output logic        s1_dirty_o,
  output logic [19:0] s1_subj_o,
  output logic [19:0] s1_obj_o,
  output logic [19:0] s1_ctx_o,
  output logic signed [15:0] s1_w0_o,
  output logic [1:0]  s1_axi_o,
  output logic [15:0] n_upd_o,
  output logic [15:0] n_hit_o,
  output logic [15:0] n_miss_o,
  output logic [15:0] n_evict_o,
  output logic [15:0] n_wb_o,
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

  typedef struct packed {
    logic        valid;
    logic        dirty;
    logic        cmt;
    logic [19:0] subj, rel, obj, ctx;
    logic [7:0]  gen, txn, schema;
    logic signed [15:0] w0;
    logic [1:0]  axi;
    logic [15:0] seq;
  } slot_t;

  slot_t sl [0:1];
  logic [19:0] u_subj, u_rel, u_obj, u_ctx;
  logic [7:0]  u_gen, u_txn, u_schema;
  logic signed [3:0] u_rew;
  logic signed [15:0] live_w0;
  logic [3:0]  phase, fail_code;
  logic [15:0] n_upd = 16'd0, n_hit = 16'd0, n_miss = 16'd0;
  logic [15:0] n_evict = 16'd0, n_wb = 16'd0, n_stale = 16'd0;
  logic [15:0] n_schema = 16'd0, n_false = 16'd0;
  logic [127:0] wbeat;
  logic        awv, wv, arv;
  logic        is_hit, wr_wb;
  logic [1:0]  tgt, axi_sel, ridx;
  logic [1:0]  next_axi = 2'd0;
  logic [15:0] seq_ctr = 16'd1;
  logic        found_full, found_key, found_free, found_vic;
  logic [1:0]  hit_full_i, hit_key_i, free_i, vic_i;
  logic [7:0]  occ_c, n_cmt_c;
  logic [15:0] best_seq_c;

  function automatic logic [127:0] pack_rec(
      input logic [19:0] s, r, o, c,
      input logic [7:0] g, t, sch,
      input logic signed [15:0] w);
    begin
      pack_rec = {7'd0, 1'b1, w, sch, t, g, c, r, o, s};
    end
  endfunction

  function automatic logic signed [15:0] sext_rew(input logic signed [3:0] rew);
    begin
      sext_rew = {{12{rew[3]}}, rew};
    end
  endfunction

  integer di;
  always_comb begin
    found_full = 1'b0; found_key = 1'b0; found_free = 1'b0; found_vic = 1'b0;
    hit_full_i = 2'd0; hit_key_i = 2'd0; free_i = 2'd0; vic_i = 2'd0;
    occ_c = 8'd0; n_cmt_c = 8'd0;
    for (di = 0; di < 2; di = di + 1) begin
      if (sl[di].valid) occ_c = occ_c + 8'd1;
      if (sl[di].valid && sl[di].cmt) n_cmt_c = n_cmt_c + 8'd1;
      if (sl[di].valid && (sl[di].subj == u_subj) && (sl[di].rel == u_rel)
          && (sl[di].obj == u_obj) && (sl[di].ctx == u_ctx)) begin
        found_key = 1'b1;
        hit_key_i = di[1:0];
        if (sl[di].gen == u_gen) begin
          found_full = 1'b1;
          hit_full_i = di[1:0];
        end
      end
      if (!sl[di].valid && !found_free) begin
        found_free = 1'b1;
        free_i = di[1:0];
      end
    end
    best_seq_c = 16'hFFFF;
    for (di = 0; di < 2; di = di + 1) begin
      if (sl[di].valid && sl[di].cmt
          && (!found_vic || (sl[di].seq < best_seq_c)
              || ((sl[di].seq == best_seq_c) && (di[1:0] < vic_i)))) begin
        found_vic = 1'b1;
        best_seq_c = sl[di].seq;
        vic_i = di[1:0];
      end
    end
  end

  assign upd_ready_o = (st == S_IDLE);
  assign busy_o = (st != S_IDLE) && (st != S_HOLD) && (st != S_FAIL);
  assign phase_o = phase;
  assign fail_code_o = fail_code;
  assign live_w0_o = live_w0;
  assign occ_o = occ_c;
  assign cap_full_o = (occ_c == 8'd2);
  assign lk_hit_o = (sl[0].valid && (lk_subj_i == sl[0].subj) && (lk_rel_i == sl[0].rel)
                     && (lk_obj_i == sl[0].obj) && (lk_ctx_i == sl[0].ctx))
                 || (sl[1].valid && (lk_subj_i == sl[1].subj) && (lk_rel_i == sl[1].rel)
                     && (lk_obj_i == sl[1].obj) && (lk_ctx_i == sl[1].ctx));
  assign s0_valid_o = sl[0].valid;
  assign s0_dirty_o = sl[0].dirty;
  assign s0_subj_o  = sl[0].subj;
  assign s0_obj_o   = sl[0].obj;
  assign s0_ctx_o   = sl[0].ctx;
  assign s0_w0_o    = sl[0].w0;
  assign s0_axi_o   = sl[0].axi;
  assign s1_valid_o = sl[1].valid;
  assign s1_dirty_o = sl[1].dirty;
  assign s1_subj_o  = sl[1].subj;
  assign s1_obj_o   = sl[1].obj;
  assign s1_ctx_o   = sl[1].ctx;
  assign s1_w0_o    = sl[1].w0;
  assign s1_axi_o   = sl[1].axi;
  assign n_upd_o = n_upd;
  assign n_hit_o = n_hit;
  assign n_miss_o = n_miss;
  assign n_evict_o = n_evict;
  assign n_wb_o = n_wb;
  assign n_stale_o = n_stale;
  assign n_schema_o = n_schema;
  assign n_false_o = n_false;
  assign m_axi_awid = 4'd1;
  assign m_axi_awaddr = A7NG_C2MS_PERSIST_BASE + {22'd0, axi_sel, 4'd0};
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
  assign m_axi_araddr = A7NG_C2MS_PERSIST_BASE + {22'd0, ridx, 4'd0};
  assign m_axi_arlen = 8'd0;
  assign m_axi_arsize = 3'd4;
  assign m_axi_arburst = 2'b01;
  assign m_axi_arvalid = arv;
  assign m_axi_rready = (st == S_R);

  integer ci;
  always_ff @(posedge clk) begin
    if (persist_clr_i) begin
      for (ci = 0; ci < 2; ci = ci + 1) sl[ci] <= '0;
      next_axi <= 2'd0;
      seq_ctr <= 16'd1;
    end else if (st == S_CMT) begin
      if (is_hit) begin
        sl[tgt].w0    <= sl[tgt].w0 + sext_rew(u_rew);
        sl[tgt].dirty <= 1'b1;
        sl[tgt].txn   <= u_txn;
        sl[tgt].cmt   <= 1'b1;
      end else begin
        sl[tgt].valid  <= 1'b1;
        sl[tgt].dirty  <= 1'b1;
        sl[tgt].cmt    <= 1'b1;
        sl[tgt].subj   <= u_subj;
        sl[tgt].rel    <= u_rel;
        sl[tgt].obj    <= u_obj;
        sl[tgt].ctx    <= u_ctx;
        sl[tgt].gen    <= u_gen;
        sl[tgt].txn    <= u_txn;
        sl[tgt].schema <= u_schema;
        sl[tgt].w0     <= sext_rew(u_rew);
        sl[tgt].axi    <= next_axi;
        sl[tgt].seq    <= seq_ctr;
        next_axi       <= next_axi + 2'd1;
        seq_ctr        <= seq_ctr + 16'd1;
      end
      if (sl[0].valid && sl[1].valid
          && (sl[0].subj == sl[1].subj) && (sl[0].rel == sl[1].rel)
          && (sl[0].obj == sl[1].obj) && (sl[0].ctx == sl[1].ctx))
        n_false <= n_false + 16'd1;
      n_upd <= n_upd + 16'd1;
      if (is_hit) n_hit <= n_hit + 16'd1;
      else n_miss <= n_miss + 16'd1;
    end else if ((st == S_B) && m_axi_bvalid && m_axi_bready && (m_axi_bresp == 2'b00)) begin
      if (wr_wb) n_wb <= n_wb + 16'd1;
      else sl[tgt].dirty <= 1'b0;
    end else if ((st == S_R) && m_axi_rvalid && m_axi_rready && m_axi_rlast
                 && (m_axi_rresp == 2'b00)) begin
      sl[ridx].valid  <= m_axi_rdata[120];
      sl[ridx].dirty  <= 1'b0;
      sl[ridx].cmt    <= m_axi_rdata[120];
      sl[ridx].subj   <= m_axi_rdata[19:0];
      sl[ridx].obj    <= m_axi_rdata[39:20];
      sl[ridx].rel    <= m_axi_rdata[59:40];
      sl[ridx].ctx    <= m_axi_rdata[79:60];
      sl[ridx].gen    <= m_axi_rdata[87:80];
      sl[ridx].txn    <= m_axi_rdata[95:88];
      sl[ridx].schema <= m_axi_rdata[103:96];
      sl[ridx].w0     <= m_axi_rdata[119:104];
      sl[ridx].axi    <= ridx;
      sl[ridx].seq    <= {14'd0, ridx} + 16'd1;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      phase <= A7NG_C2MS_PH_IDLE;
      fail_code <= A7NG_C2MS_F_NONE;
      live_w0 <= 16'sd0;
      u_subj <= '0; u_rel <= '0; u_obj <= '0; u_ctx <= '0;
      u_gen <= '0; u_txn <= '0; u_schema <= '0; u_rew <= '0;
      awv <= 1'b0; wv <= 1'b0; arv <= 1'b0; wbeat <= '0;
      is_hit <= 1'b0; wr_wb <= 1'b0;
      tgt <= 2'd0; axi_sel <= 2'd0; ridx <= 2'd0;
    end else begin
      unique case (st)
        S_IDLE: begin
          phase <= A7NG_C2MS_PH_IDLE;
          fail_code <= A7NG_C2MS_F_NONE;
          awv <= 1'b0; wv <= 1'b0; arv <= 1'b0;
          wr_wb <= 1'b0; is_hit <= 1'b0;
          if (reload_i) begin
            ridx <= 2'd0;
            arv <= 1'b1;
            st <= S_AR;
          end else if (upd_valid_i) begin
            u_subj <= upd_subj_i; u_rel <= upd_rel_i; u_obj <= upd_obj_i;
            u_ctx <= upd_ctx_i; u_gen <= upd_gen_i; u_txn <= upd_txn_i;
            u_schema <= upd_schema_i; u_rew <= upd_rew_i;
            phase <= A7NG_C2MS_PH_RECEIVED;
            st <= S_RECV;
          end
        end
        S_RECV: st <= S_DECIDE;
        S_DECIDE: begin
          if (u_schema != A7NG_C2MS_SCHEMA_VER) begin
            fail_code <= A7NG_C2MS_F_SCHEMA;
            n_schema <= n_schema + 16'd1;
            phase <= A7NG_C2MS_PH_FAILED;
            st <= S_FAIL;
          end else if (found_full) begin
            is_hit <= 1'b1;
            tgt <= hit_full_i;
            phase <= A7NG_C2MS_PH_ACCEPTED;
            st <= S_ACC;
          end else if (found_key) begin
            fail_code <= A7NG_C2MS_F_STALE_GEN;
            n_stale <= n_stale + 16'd1;
            phase <= A7NG_C2MS_PH_FAILED;
            st <= S_FAIL;
          end else if (found_free) begin
            is_hit <= 1'b0;
            tgt <= free_i;
            phase <= A7NG_C2MS_PH_ACCEPTED;
            st <= S_ACC;
          end else if (!found_vic) begin
            fail_code <= A7NG_C2MS_F_CAP;
            phase <= A7NG_C2MS_PH_FAILED;
            st <= S_FAIL;
          end else if (sl[vic_i].dirty) begin
            is_hit <= 1'b0;
            wr_wb <= 1'b1;
            tgt <= vic_i;
            axi_sel <= sl[vic_i].axi;
            wbeat <= pack_rec(sl[vic_i].subj, sl[vic_i].rel, sl[vic_i].obj,
                              sl[vic_i].ctx, sl[vic_i].gen, sl[vic_i].txn,
                              sl[vic_i].schema, sl[vic_i].w0);
            n_evict <= n_evict + 16'd1;
            phase <= A7NG_C2MS_PH_ACCEPTED;
            awv <= 1'b1;
            st <= S_AW;
          end else begin
            is_hit <= 1'b0;
            tgt <= vic_i;
            n_evict <= n_evict + 16'd1;
            phase <= A7NG_C2MS_PH_ACCEPTED;
            st <= S_ACC;
          end
        end
        S_ACC: begin
          phase <= A7NG_C2MS_PH_ACCEPTED;
          st <= S_CMT;
        end
        S_CMT: begin
          if (is_hit)
            live_w0 <= sl[tgt].w0 + sext_rew(u_rew);
          else
            live_w0 <= sext_rew(u_rew);
          phase <= A7NG_C2MS_PH_COMMITTED;
          if (is_hit) st <= S_HOLD;
          else begin
            axi_sel <= next_axi;
            wbeat <= pack_rec(u_subj, u_rel, u_obj, u_ctx, u_gen, u_txn,
                              u_schema, sext_rew(u_rew));
            awv <= 1'b1;
            wr_wb <= 1'b0;
            st <= S_AW;
          end
        end
        S_AW: begin
          if (wr_wb) phase <= A7NG_C2MS_PH_ACCEPTED;
          else phase <= A7NG_C2MS_PH_COMMITTED;
          if (awv && m_axi_awready) begin
            awv <= 1'b0;
            wv <= 1'b1;
            st <= S_W;
          end
        end
        S_W: begin
          if (wr_wb) phase <= A7NG_C2MS_PH_ACCEPTED;
          else phase <= A7NG_C2MS_PH_COMMITTED;
          if (wv && m_axi_wready) begin
            wv <= 1'b0;
            st <= S_B;
          end
        end
        S_B: begin
          if (wr_wb) phase <= A7NG_C2MS_PH_ACCEPTED;
          else phase <= A7NG_C2MS_PH_COMMITTED;
          if (m_axi_bvalid && m_axi_bready) begin
            if (m_axi_bresp != 2'b00) begin
              fail_code <= A7NG_C2MS_F_NO_PEND;
              phase <= A7NG_C2MS_PH_FAILED;
              st <= S_FAIL;
            end else if (wr_wb) begin
              wr_wb <= 1'b0;
              is_hit <= 1'b0;
              st <= S_CMT;
            end else begin
              phase <= A7NG_C2MS_PH_PERSISTED;
              st <= S_HOLD;
            end
          end
        end
        S_HOLD: begin
          if (is_hit) phase <= A7NG_C2MS_PH_COMMITTED;
          else phase <= A7NG_C2MS_PH_PERSISTED;
          if (retire_i) st <= S_IDLE;
        end
        S_FAIL: begin
          phase <= A7NG_C2MS_PH_FAILED;
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
            if (m_axi_rresp == 2'b00 && m_axi_rdata[120])
              live_w0 <= m_axi_rdata[119:104];
            if (ridx == 2'd1) begin
              phase <= A7NG_C2MS_PH_PERSISTED;
              st <= S_HOLD;
            end else begin
              ridx <= ridx + 2'd1;
              arv <= 1'b1;
              st <= S_AR;
            end
          end
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
