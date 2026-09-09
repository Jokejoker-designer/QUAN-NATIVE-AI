`ifndef A7NG_ASTRA_06_R2_EVICT_HIGHID_SVH
`define A7NG_ASTRA_06_R2_EVICT_HIGHID_SVH
// ASTRA-06-R2-EVICT-HIGHID-01. PROGRAM=NO.
// Additive bag. Does not patch a7ng_astra_06_warm_persist.sv.
// Persist store is on-chip regs, NOT DDR/MIG/QSPI. rst_n does not clear it.
// Capacity N=1. Policy: REFUSE_UNCOMMITTED_EVICT_COMMITTED.
// Schema byte: native VER restores; foreign VER does not restore live weights.
localparam int unsigned A7NG_A06R2_TO_CYC     = 64;
localparam int unsigned A7NG_A06R2_DRAIN_TO   = 64;
localparam logic [3:0]  A7NG_A06R2_SPARSE_RID = 4'd1;
localparam logic [3:0]  A7NG_A06R2_FACT_RID0  = 4'd2;
localparam logic [1:0]  A7NG_A06R2_RRESP_OK   = 2'b00;
localparam logic [7:0]  A7NG_A06R2_TXN_MAX    = 8'd255;
localparam logic [15:0] A7NG_A06R2_EPOCH_INV  = 16'd0;
localparam int unsigned A7NG_A06R2_CAP_N      = 1;
localparam logic [7:0]  A7NG_A06R2_SCHEMA_VER = 8'h01;
localparam logic [7:0]  A7NG_A06R2_SCHEMA_BAD = 8'hA5;
`endif
