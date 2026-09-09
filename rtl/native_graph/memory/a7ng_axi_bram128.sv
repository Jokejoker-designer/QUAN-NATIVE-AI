// a7ng_axi_bram128.sv — small synth AXI4 128-bit SRAM. PROGRAM=NO.
// Maps INDEX_BASE (0x05000000) into on-chip BRAM. Empty init is valid (default).
// PLANT_R2_BASE=1: compact map of RTP-R2 BASE 17/34 dir+post+facts (not full 4x4096).
// Do not use a7ng_axi_mem_model (behavioral, huge DEPTH). No MIG.
`timescale 1ns / 1ps

module a7ng_axi_bram128 #(
  parameter int unsigned DEPTH_WORDS   = 256,
  parameter logic [27:0] INDEX_BASE    = 28'h0500_0000,
  parameter bit          PLANT_R2_BASE = 1'b0
) (
  input  logic         clk,
  input  logic         rst_n,
  input  logic [3:0]   s_axi_awid,
  input  logic [27:0]  s_axi_awaddr,
  input  logic [7:0]   s_axi_awlen,
  input  logic [2:0]   s_axi_awsize,
  input  logic [1:0]   s_axi_awburst,
  input  logic         s_axi_awvalid,
  output logic         s_axi_awready,
  input  logic [127:0] s_axi_wdata,
  input  logic [15:0]  s_axi_wstrb,
  input  logic         s_axi_wlast,
  input  logic         s_axi_wvalid,
  output logic         s_axi_wready,
  output logic [3:0]   s_axi_bid,
  output logic [1:0]   s_axi_bresp,
  output logic         s_axi_bvalid,
  input  logic         s_axi_bready,
  input  logic [3:0]   s_axi_arid,
  input  logic [27:0]  s_axi_araddr,
  input  logic [7:0]   s_axi_arlen,
  input  logic [2:0]   s_axi_arsize,
  input  logic [1:0]   s_axi_arburst,
  input  logic         s_axi_arvalid,
  output logic         s_axi_arready,
  output logic [3:0]   s_axi_rid,
  output logic [127:0] s_axi_rdata,
  output logic [1:0]   s_axi_rresp,
  output logic         s_axi_rlast,
  output logic         s_axi_rvalid,
  input  logic         s_axi_rready
);
  localparam int unsigned AW = (DEPTH_WORDS <= 1) ? 1 : $clog2(DEPTH_WORDS);
  // RTP-R2 BASE 17/34 (tb_astra_rtp_r2 plant_ids + FACT_BASE+(id<<4)).
  // Extra dir(1,2)/dir(3,0) match R1 klist; same POST_HEAP (no new facts).
  localparam logic [27:0] P_DIR0 = 28'h0500A020; // dir_addr(0,2562)
  localparam logic [27:0] P_DIR1 = 28'h05010020; // dir_addr(1,2)
  localparam logic [27:0] P_DIR2 = 28'h05022FE0; // dir_addr(2,766)
  localparam logic [27:0] P_DIR3 = 28'h05030000; // dir_addr(3,0)
  localparam logic [27:0] P_POST = 28'h05040000; // POST_HEAP
  localparam logic [27:0] P_F17  = 28'h05800110; // FACT_BASE+(17<<4)
  localparam logic [27:0] P_F34  = 28'h05800220; // FACT_BASE+(34<<4)

  (* ram_style = "block" *) (* ram_extract = "yes" *) logic [127:0] mem [0:DEPTH_WORDS-1];

  typedef enum logic [1:0] { R_IDLE, R_ISSUE, R_BEAT } rst_t;
  typedef enum logic [1:0] { W_IDLE, W_DATA, W_RESP } wst_t;
  rst_t r_st;
  wst_t w_st;

  logic [27:0] r_addr, w_addr;
  logic [7:0]  r_left, w_left;
  logic [3:0]  r_id, w_id;
  logic [1:0]  r_burst, w_burst;
  logic [AW-1:0] r_word, w_word;
  logic [127:0]  r_q;
  logic          we;

  integer ii;

  function automatic logic [127:0] r2_dir_pack(
      input logic [27:0] base, input logic [15:0] count);
    return {48'd0, 16'd7, 16'd0, count, 4'd0, base};
  endfunction

  function automatic logic [127:0] r2_fact_pack(
      input logic [19:0] s,
      input logic [19:0] o,
      input logic [7:0]  r,
      input logic [19:0] e);
    return {52'd0, 4'd1, 1'b0, 1'b1, 1'b1, 1'b1, e, r, o, s};
  endfunction

  initial begin
    for (ii = 0; ii < DEPTH_WORDS; ii = ii + 1)
      mem[ii] = 128'd0;
    if (PLANT_R2_BASE) begin
      mem[0] = r2_dir_pack(P_POST, 16'd2);
      mem[1] = r2_dir_pack(P_POST, 16'd2);
      mem[2] = {96'd0, 32'd34, 32'd17};
      mem[3] = r2_fact_pack(20'd10, 20'd1, 8'd2, 20'd17);
      mem[4] = r2_fact_pack(20'd1, 20'd4, 8'd2, 20'd34);
      mem[5] = r2_dir_pack(P_POST, 16'd2);
      mem[6] = r2_dir_pack(P_POST, 16'd2);
    end
  end

  function automatic logic [AW-1:0] word_of(input logic [27:0] a);
    logic [27:0] rel;
    if (PLANT_R2_BASE) begin
      unique case (a)
        P_DIR0: return AW'(0);
        P_DIR2: return AW'(1);
        P_POST: return AW'(2);
        P_F17:  return AW'(3);
        P_F34:  return AW'(4);
        P_DIR1: return AW'(5);
        P_DIR3: return AW'(6);
        default: return AW'({1'b1, a[10:4]});
      endcase
    end
    rel = (a >= INDEX_BASE) ? (a - INDEX_BASE) : a;
    return rel[AW+3:4];
  endfunction

  function automatic logic [27:0] next_addr(
      input logic [27:0] a, input logic [1:0] burst);
    if (burst == 2'b01)
      return a + 28'd16;
    return a;
  endfunction

  assign s_axi_rresp = 2'b00;
  assign s_axi_bresp = 2'b00;
  assign r_word = word_of(r_addr);
  assign w_word = word_of(w_addr);

  always_ff @(posedge clk) begin
    if (we)
      mem[w_word] <= s_axi_wdata;
    r_q <= mem[r_word];
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      r_st <= R_IDLE;
      s_axi_arready <= 1'b1;
      s_axi_rvalid  <= 1'b0;
      s_axi_rlast   <= 1'b0;
      s_axi_rdata   <= '0;
      s_axi_rid     <= '0;
      r_addr <= '0;
      r_left <= '0;
      r_id <= '0;
      r_burst <= 2'b01;
    end else begin
      unique case (r_st)
        R_IDLE: begin
          s_axi_arready <= 1'b1;
          s_axi_rvalid  <= 1'b0;
          s_axi_rlast   <= 1'b0;
          if (s_axi_arvalid && s_axi_arready) begin
            r_addr  <= s_axi_araddr;
            r_left  <= s_axi_arlen;
            r_id    <= s_axi_arid;
            r_burst <= s_axi_arburst;
            s_axi_arready <= 1'b0;
            r_st <= R_ISSUE;
          end
        end
        R_ISSUE: begin
          s_axi_arready <= 1'b0;
          s_axi_rvalid  <= 1'b0;
          r_st <= R_BEAT;
        end
        R_BEAT: begin
          s_axi_rvalid <= 1'b1;
          s_axi_rdata  <= r_q;
          s_axi_rid    <= r_id;
          s_axi_rlast  <= (r_left == 8'd0);
          if (s_axi_rvalid && s_axi_rready) begin
            s_axi_rvalid <= 1'b0;
            if (r_left == 8'd0) begin
              s_axi_rlast   <= 1'b0;
              s_axi_arready <= 1'b1;
              r_st <= R_IDLE;
            end else begin
              r_left <= r_left - 8'd1;
              r_addr <= next_addr(r_addr, r_burst);
              r_st <= R_ISSUE;
            end
          end
        end
        default: r_st <= R_IDLE;
      endcase
    end
  end

  assign we = (w_st == W_DATA) && s_axi_wvalid && s_axi_wready;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      w_st <= W_IDLE;
      s_axi_awready <= 1'b1;
      s_axi_wready  <= 1'b0;
      s_axi_bvalid  <= 1'b0;
      s_axi_bid     <= '0;
      w_addr <= '0;
      w_left <= '0;
      w_id <= '0;
      w_burst <= 2'b01;
    end else begin
      unique case (w_st)
        W_IDLE: begin
          s_axi_awready <= 1'b1;
          s_axi_wready  <= 1'b0;
          s_axi_bvalid  <= 1'b0;
          if (s_axi_awvalid && s_axi_awready) begin
            w_addr  <= s_axi_awaddr;
            w_left  <= s_axi_awlen;
            w_id    <= s_axi_awid;
            w_burst <= s_axi_awburst;
            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b1;
            w_st <= W_DATA;
          end
        end
        W_DATA: begin
          if (s_axi_wvalid && s_axi_wready) begin
            if (s_axi_wlast || (w_left == 8'd0)) begin
              s_axi_wready <= 1'b0;
              s_axi_bid    <= w_id;
              s_axi_bvalid <= 1'b1;
              w_st <= W_RESP;
            end else begin
              w_left <= w_left - 8'd1;
              w_addr <= next_addr(w_addr, w_burst);
            end
          end
        end
        W_RESP: begin
          if (s_axi_bvalid && s_axi_bready) begin
            s_axi_bvalid  <= 1'b0;
            s_axi_awready <= 1'b1;
            w_st <= W_IDLE;
          end
        end
        default: w_st <= W_IDLE;
      endcase
    end
  end
endmodule
