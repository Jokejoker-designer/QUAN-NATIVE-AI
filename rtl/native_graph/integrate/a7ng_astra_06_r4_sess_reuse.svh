`ifndef A7NG_ASTRA_06_R4_SESS_REUSE_SVH
`define A7NG_ASTRA_06_R4_SESS_REUSE_SVH
// ASTRA-06-R4-SESS-REUSE-01. PROGRAM=NO.
// Additive bag. Does not patch a7ng_astra_06_warm_persist.sv, a7ng_astra_06_r2*.sv,
// or a7ng_astra_06_r3_multi_slot.sv.
// Persist store is on-chip slot array, NOT DDR/MIG/QSPI. rst_n does not clear it.
// Sess lifetime: sess_id is part of pending/persist key {sess,gen,txn}.
// rst without restore must not mint a new live pending that replays pre-rst {sess,txn}.
// Restore with matching sess_id rebinds live pending to the snapshot.
localparam int unsigned A7NG_A06R4_TO_CYC     = 64;
localparam int unsigned A7NG_A06R4_DRAIN_TO   = 64;
localparam logic [3:0]  A7NG_A06R4_SPARSE_RID = 4'd1;
localparam logic [3:0]  A7NG_A06R4_FACT_RID0  = 4'd2;
localparam logic [1:0]  A7NG_A06R4_RRESP_OK   = 2'b00;
localparam logic [7:0]  A7NG_A06R4_TXN_MAX    = 8'd255;
localparam logic [15:0] A7NG_A06R4_EPOCH_INV  = 16'd0;
localparam int unsigned A7NG_A06R4_CAP_N      = 2;
localparam logic [7:0]  A7NG_A06R4_SCHEMA_VER = 8'h01;
`endif
