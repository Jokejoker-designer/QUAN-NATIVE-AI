`ifndef A7NG_ASTRA_06_R3_MULTI_SLOT_SVH
`define A7NG_ASTRA_06_R3_MULTI_SLOT_SVH
// ASTRA-06-R3-MULTI-SLOT-01. PROGRAM=NO.
// Additive bag. Does not patch a7ng_astra_06_warm_persist.sv or a7ng_astra_06_r2*.sv.
// Persist store is on-chip slot array, NOT DDR/MIG/QSPI. rst_n does not clear it.
// Capacity CAP_N>=2. Policy: REFUSE_ALL_UNCOMMITTED / EVICT_OLDEST_COMMITTED_LOWEST_TXN.
localparam int unsigned A7NG_A06R3_TO_CYC     = 64;
localparam int unsigned A7NG_A06R3_DRAIN_TO   = 64;
localparam logic [3:0]  A7NG_A06R3_SPARSE_RID = 4'd1;
localparam logic [3:0]  A7NG_A06R3_FACT_RID0  = 4'd2;
localparam logic [1:0]  A7NG_A06R3_RRESP_OK   = 2'b00;
localparam logic [7:0]  A7NG_A06R3_TXN_MAX    = 8'd255;
localparam logic [15:0] A7NG_A06R3_EPOCH_INV  = 16'd0;
localparam int unsigned A7NG_A06R3_CAP_N      = 2;
localparam logic [7:0]  A7NG_A06R3_SCHEMA_VER = 8'h01;
`endif
