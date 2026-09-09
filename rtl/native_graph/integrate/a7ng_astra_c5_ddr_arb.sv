// a7ng_astra_c5_ddr_arb.sv — ASTRA-C5-DDR-ARB-01. PROGRAM=NO.
// New named 6-client exclusive DDR owner. Does not edit a7ng_lm_graph_arb,
// C0/C1/C2 KEEP, official mig.prj, or leftover A09.
// Modeled AXI AR mux. Not MIG PHY. DDR_QUERY_BOUND_FINAL stays NOT_FROZEN.
// Hold S_OWN while a read is in flight (pend) or AR is waiting on ready.
`timescale 1ns / 1ps
`include "a7ng_astra_c5_ddr_arb.svh"

module a7ng_astra_c5_ddr_arb (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [5:0]  req_i,
  output logic [5:0]  gnt_o,
  output logic [2:0]  owner_o,
  output logic        dual_err_o,
  output logic [15:0] n_switch_o,
  output logic [15:0] n_block_o,
  input  logic [5:0]  s_arvalid_i,
  input  logic [27:0] s_araddr_i [0:5],
  output logic [5:0]  s_arready_o,
  output logic        m_arvalid_o,
  output logic [27:0] m_araddr_o,
  input  logic        m_arready_i,
  input  logic        m_rvalid_i,
  input  logic [127:0] m_rdata_i,
  output logic        m_rready_o,
  output logic [5:0]  s_rvalid_o,
  output logic [127:0] s_rdata_o
);
  typedef enum logic [1:0] { S_IDLE, S_OWN } st_t;
  st_t st;
  logic [2:0] own, pick;
  logic [15:0] n_sw, n_blk;
  logic [3:0] pend;
  integer ip, io;
  logic [2:0] ones;

  always_comb begin
    pick = A7NG_C5_NONE;
    for (ip = 0; ip < A7NG_C5_NCLI; ip = ip + 1)
      if (req_i[ip] && (pick == A7NG_C5_NONE))
        pick = ip[2:0];
  end

  always_comb begin
    ones = 3'd0;
    for (io = 0; io < A7NG_C5_NCLI; io = io + 1)
      if (gnt_o[io]) ones = ones + 3'd1;
  end

  assign owner_o = (st == S_OWN) ? own : A7NG_C5_NONE;
  assign gnt_o = (st == S_OWN) ? (6'd1 << own) : 6'd0;
  assign dual_err_o = (ones > 3'd1);
  assign n_switch_o = n_sw;
  assign n_block_o = n_blk;

  assign m_arvalid_o = (st == S_OWN) && s_arvalid_i[own];
  assign m_araddr_o  = (st == S_OWN) ? s_araddr_i[own] : 28'd0;
  assign m_rready_o  = (st == S_OWN);

  always_comb begin
    s_arready_o = 6'd0;
    s_rvalid_o  = 6'd0;
    s_rdata_o   = m_rdata_i;
    if (st == S_OWN) begin
      s_arready_o[own] = m_arready_i;
      s_rvalid_o[own]  = m_rvalid_i;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      own <= A7NG_C5_NONE;
      n_sw <= 16'd0;
      n_blk <= 16'd0;
      pend <= 4'd0;
    end else begin
      if (m_arvalid_o && m_arready_i && !(m_rvalid_i && m_rready_o))
        pend <= pend + 4'd1;
      else if (!(m_arvalid_o && m_arready_i) && m_rvalid_i && m_rready_o
               && (pend > 4'd0))
        pend <= pend - 4'd1;
      unique case (st)
        S_IDLE: begin
          if (pick != A7NG_C5_NONE) begin
            own <= pick;
            n_sw <= n_sw + 16'd1;
            st <= S_OWN;
          end
        end
        S_OWN: begin
          if ((req_i & ~(6'd1 << own)) != 6'd0)
            n_blk <= n_blk + 16'd1;
          if (!req_i[own] && (pend == 4'd0)
              && !(s_arvalid_i[own] && !m_arready_i)) begin
            own <= A7NG_C5_NONE;
            st <= S_IDLE;
          end
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
