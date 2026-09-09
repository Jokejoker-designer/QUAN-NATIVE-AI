// a7ng_axi_mem_c3_800k.sv — bag-local. PROGRAM=NO.
// Directory/postings = gen_800k cartesian. Facts = C3 fact_pack at 0x0E000000.
// live_epoch patched into dir words. Not MIG. Not KEEP.
`timescale 1ns / 1ps

module a7ng_axi_mem_c3_800k (
  input  logic         clk,
  input  logic         rst_n,
  input  logic [15:0]  live_epoch_i,
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
  // In-module includes (C1 pattern). File-scope include puts G_* in $unit and
  // collides when xvlog shares $unit across mem + TB.
  `include "query_gold.svh"
  `include "gen_800k.svh"
  `include "c3_800k_facts.svh"

  typedef enum logic [1:0] {RIDLE, RDATA} rst_t;
  rst_t rst;
  logic [27:0] ar_a;
  logic [3:0]  ar_id;
  logic [7:0]  ar_left;

  function automatic logic [127:0] rd_of(input logic [27:0] addr);
    int nid;
    logic [127:0] d;
    begin
      if ((addr >= C3K_FACT_BASE) && (addr < (C3K_FACT_BASE + (C3K_NID_MAX << 4)))) begin
        nid = (addr - C3K_FACT_BASE) >> 4;
        rd_of = c3k_fact_pack(nid);
      end else begin
        d = g_rdata_of(addr);
        if ((addr >= G_DIR_LO) && (addr <= G_DIR_HI))
          d[79:64] = live_epoch_i;
        rd_of = d;
      end
    end
  endfunction

  assign s_axi_rresp = 2'b00;

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
          s_axi_rdata  <= rd_of(ar_a);
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
