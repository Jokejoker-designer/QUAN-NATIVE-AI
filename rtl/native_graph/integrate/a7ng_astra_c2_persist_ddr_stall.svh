`ifndef A7NG_ASTRA_C2_PERSIST_DDR_STALL_SVH
`define A7NG_ASTRA_C2_PERSIST_DDR_STALL_SVH
// ASTRA-C2-PERSIST-DDR-STALL-01. PROGRAM=NO. Named AXI-stall persist law.
// Does not edit persist-commit KEEP or persist-multi-slot KEEP.
// Canonical tuple is 20-bit {subject, relation, object, context} + generation.
// On-chip N=1. AXI backing N_AXI=2 at PERSIST_BASE + axi_idx*16.
// Journal/cache updates only on AXI B OKAY (not on COMMITTED).
// Address is never subj[15:0]. Not MIG. Not BOARD.
// PERSIST_SCHEMA_VERSION stays NOT_FROZEN.
localparam int unsigned A7NG_C2ST_ID_W         = 20;
localparam int unsigned A7NG_C2ST_AXI_N        = 2;
localparam logic [7:0]  A7NG_C2ST_SCHEMA_VER   = 8'd1;
localparam logic [27:0] A7NG_C2ST_PERSIST_BASE = 28'h0600_0000;
localparam logic [3:0]  A7NG_C2ST_PH_IDLE      = 4'd0;
localparam logic [3:0]  A7NG_C2ST_PH_RECEIVED  = 4'd1;
localparam logic [3:0]  A7NG_C2ST_PH_ACCEPTED  = 4'd2;
localparam logic [3:0]  A7NG_C2ST_PH_COMMITTED = 4'd3;
localparam logic [3:0]  A7NG_C2ST_PH_PERSISTED = 4'd4;
localparam logic [3:0]  A7NG_C2ST_PH_FAILED    = 4'd5;
localparam logic [3:0]  A7NG_C2ST_F_NONE       = 4'd0;
localparam logic [3:0]  A7NG_C2ST_F_SCHEMA     = 4'd1;
localparam logic [3:0]  A7NG_C2ST_F_STALE_GEN  = 4'd2;
localparam logic [3:0]  A7NG_C2ST_F_NO_PEND    = 4'd4;
localparam int unsigned A7NG_C2ST_STALL_AW     = 8;
localparam int unsigned A7NG_C2ST_STALL_W      = 5;
localparam int unsigned A7NG_C2ST_STALL_B      = 6;
localparam int unsigned A7NG_C2ST_STALL_AR     = 4;
localparam int unsigned A7NG_C2ST_STALL_R      = 3;
`endif
