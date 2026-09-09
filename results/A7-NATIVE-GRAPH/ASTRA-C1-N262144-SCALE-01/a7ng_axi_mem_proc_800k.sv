// a7ng_axi_mem_proc_800k.sv — bag-local procedural AXI slave for N=800000.
// NOT an edit of C0 a7ng_axi_mem_model.sv. 800k facts are addressable by
// closed-form generator (gen_800k.svh). Dense 800k array is forbidden.
// PROGRAM=NO. Index is AXI behavioral, not MIG.
`timescale 1ns / 1ps

module a7ng_axi_mem_proc_800k (
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
  `include "query_gold.svh"
  `include "gen_800k.svh"

  typedef enum logic [1:0] {RIDLE, RDATA} rst_t;
  rst_t rst;
  logic [27:0] ar_a;
  logic [3:0]  ar_id;
  logic [7:0]  ar_left;

  assign s_axi_bresp   = 2'b00;
  assign s_axi_rresp   = 2'b00;
  assign s_axi_awready = 1'b0;
  assign s_axi_wready  = 1'b0;
  assign s_axi_bvalid  = 1'b0;
  assign s_axi_bid     = 4'd0;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rst <= RIDLE;
      s_axi_arready <= 1'b1;
      s_axi_rvalid  <= 1'b0;
      s_axi_rlast   <= 1'b0;
      s_axi_rdata   <= '0;
      s_axi_rid     <= '0;
      ar_left <= '0;
      ar_a <= '0;
      ar_id <= '0;
    end else begin
      unique case (rst)
        RIDLE: begin
          s_axi_arready <= 1'b1;
          s_axi_rvalid  <= 1'b0;
          s_axi_rlast   <= 1'b0;
          if (s_axi_arvalid && s_axi_arready) begin
            ar_a    <= s_axi_araddr;
            ar_id   <= s_axi_arid;
            ar_left <= s_axi_arlen;
            s_axi_arready <= 1'b0;
            rst <= RDATA;
          end
        end
        RDATA: begin
          s_axi_rvalid <= 1'b1;
          s_axi_rid    <= ar_id;
          s_axi_rdata  <= g_rdata_of(ar_a);
          s_axi_rlast  <= (ar_left == 8'd0);
          if (s_axi_rvalid && s_axi_rready) begin
            if (ar_left == 8'd0) begin
              s_axi_rvalid <= 1'b0;
              s_axi_rlast  <= 1'b0;
              rst <= RIDLE;
            end else begin
              ar_left <= ar_left - 8'd1;
              ar_a    <= ar_a + 28'd16;
            end
          end
        end
        default: rst <= RIDLE;
      endcase
    end
  end
endmodule
