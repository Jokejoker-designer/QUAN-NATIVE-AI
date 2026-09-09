// a7ng_query_axi_rbeat_probe.sv — ASTRA-C1-AXI-BEAT-ACCOUNTING-01
// RTL-visible AXI beat counters. Does not modify DUT / C0 / intersect.
// DIR_R_BEATS / POST_R_BEATS increment on rvalid && rready.
// Class from latched AR address: dir [INDEX_BASE, POST_HEAP), post >= POST_HEAP.
// TOTAL_AXI_BYTES = 16 * (DIR_R_BEATS + POST_R_BEATS). PROGRAM=NO.
`timescale 1ns / 1ps

module a7ng_query_axi_rbeat_probe #(
  parameter logic [27:0] INDEX_BASE  = 28'h0500_0000,
  parameter int unsigned N_TABLES    = 4,
  parameter int unsigned N_BUCKETS   = 4096,
  parameter int unsigned ENTRY_BYTES = 16
) (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        clr_i,
  input  logic [27:0] araddr,
  input  logic        arvalid,
  input  logic        arready,
  input  logic        rvalid,
  input  logic        rready,
  input  logic        rlast,
  output logic [31:0] dir_r_beats_o,
  output logic [31:0] post_r_beats_o,
  output logic [31:0] dir_ar_beats_o,
  output logic [31:0] post_ar_beats_o,
  output logic [31:0] unk_ar_o,
  output logic [31:0] unk_r_o,
  output logic [31:0] total_axi_bytes_o
);
  localparam logic [27:0] POST_HEAP =
      INDEX_BASE + 28'(N_TABLES * N_BUCKETS * ENTRY_BYTES);
  localparam logic [27:0] DIR_LO = INDEX_BASE;
  localparam logic [27:0] DIR_HI = POST_HEAP - 28'(ENTRY_BYTES);

  logic pending_dir, pending_post;

  assign total_axi_bytes_o = (dir_r_beats_o + post_r_beats_o) * 32'd16;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dir_r_beats_o  <= 32'd0;
      post_r_beats_o <= 32'd0;
      dir_ar_beats_o <= 32'd0;
      post_ar_beats_o<= 32'd0;
      unk_ar_o       <= 32'd0;
      unk_r_o        <= 32'd0;
      pending_dir    <= 1'b0;
      pending_post   <= 1'b0;
    end else if (clr_i) begin
      dir_r_beats_o  <= 32'd0;
      post_r_beats_o <= 32'd0;
      dir_ar_beats_o <= 32'd0;
      post_ar_beats_o<= 32'd0;
      unk_ar_o       <= 32'd0;
      unk_r_o        <= 32'd0;
      pending_dir    <= 1'b0;
      pending_post   <= 1'b0;
    end else begin
      if (rvalid && rready) begin
        if (pending_dir)
          dir_r_beats_o <= dir_r_beats_o + 32'd1;
        else if (pending_post)
          post_r_beats_o <= post_r_beats_o + 32'd1;
        else
          unk_r_o <= unk_r_o + 32'd1;
        if (rlast) begin
          pending_dir <= 1'b0;
          pending_post<= 1'b0;
        end
      end
      if (arvalid && arready) begin
        if ((araddr >= DIR_LO) && (araddr <= DIR_HI)) begin
          dir_ar_beats_o <= dir_ar_beats_o + 32'd1;
          pending_dir    <= 1'b1;
          pending_post   <= 1'b0;
        end else if (araddr >= POST_HEAP) begin
          post_ar_beats_o <= post_ar_beats_o + 32'd1;
          pending_dir     <= 1'b0;
          pending_post    <= 1'b1;
        end else begin
          unk_ar_o     <= unk_ar_o + 32'd1;
          pending_dir  <= 1'b0;
          pending_post <= 1'b0;
        end
      end
    end
  end
endmodule
