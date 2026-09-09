`ifndef A7NG_ASTRA_C2_PERSIST_COMMIT_SVH
`define A7NG_ASTRA_C2_PERSIST_COMMIT_SVH
// ASTRA-C2-PERSIST-COMMIT-01. PROGRAM=NO. Named persist-identity law.
// Canonical tuple is 20-bit {subject, relation, object, context} + generation.
// Journal AXI address is PERSIST_BASE, never subj[15:0] / obj[7:0].
// Persist store is not cleared by rst_n. Live FSM / live w0 are.
// Not MIG. Not BOARD. PERSIST_SCHEMA_VERSION stays NOT_FROZEN in FINAL_CONTRACT.
localparam int unsigned A7NG_C2_ID_W         = 20;
localparam logic [7:0]  A7NG_C2_SCHEMA_VER   = 8'd1;
localparam logic [27:0] A7NG_C2_PERSIST_BASE = 28'h0600_0000;
localparam logic [3:0]  A7NG_C2_PH_IDLE      = 4'd0;
localparam logic [3:0]  A7NG_C2_PH_RECEIVED  = 4'd1;
localparam logic [3:0]  A7NG_C2_PH_ACCEPTED  = 4'd2;
localparam logic [3:0]  A7NG_C2_PH_COMMITTED = 4'd3;
localparam logic [3:0]  A7NG_C2_PH_PERSISTED = 4'd4;
localparam logic [3:0]  A7NG_C2_PH_FAILED    = 4'd5;
localparam logic [3:0]  A7NG_C2_F_NONE       = 4'd0;
localparam logic [3:0]  A7NG_C2_F_SCHEMA     = 4'd1;
localparam logic [3:0]  A7NG_C2_F_STALE_GEN  = 4'd2;
localparam logic [3:0]  A7NG_C2_F_DUP        = 4'd3;
localparam logic [3:0]  A7NG_C2_F_NO_PEND    = 4'd4;
localparam logic [3:0]  A7NG_C2_F_BAD_TXN    = 4'd5;
`endif
