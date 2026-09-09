`ifndef A7NG_ASTRA_C2_PERSIST_MULTI_SLOT_SVH
`define A7NG_ASTRA_C2_PERSIST_MULTI_SLOT_SVH
// ASTRA-C2-PERSIST-MULTI-SLOT-01. PROGRAM=NO. Named multi-slot persist law.
// Does not edit a7ng_astra_c2_persist_commit.sv (identity KEEP).
// Canonical tuple is 20-bit {subject, relation, object, context} + generation.
// On-chip CAP_N=2. AXI backing N_AXI=4 at PERSIST_BASE + axi_idx*16.
// Address is never subj[15:0] / obj[7:0]. Not MIG. Not BOARD.
// PERSIST_SCHEMA_VERSION stays NOT_FROZEN in FINAL_CONTRACT.
// Victim = oldest committed (lowest seq, tie lowest index). Uncommitted
// rows are never victims. occ==N and no committed row → refuse.
// Same full tuple after a committed slot is a cache-hit in-place dirty
// w0 delta (not DUP). DUP remains identity-bag KEEP law.
localparam int unsigned A7NG_C2MS_ID_W         = 20;
localparam int unsigned A7NG_C2MS_CAP_N        = 2;
localparam int unsigned A7NG_C2MS_AXI_N        = 4;
localparam logic [7:0]  A7NG_C2MS_SCHEMA_VER   = 8'd1;
localparam logic [27:0] A7NG_C2MS_PERSIST_BASE = 28'h0600_0000;
localparam logic [3:0]  A7NG_C2MS_PH_IDLE      = 4'd0;
localparam logic [3:0]  A7NG_C2MS_PH_RECEIVED  = 4'd1;
localparam logic [3:0]  A7NG_C2MS_PH_ACCEPTED  = 4'd2;
localparam logic [3:0]  A7NG_C2MS_PH_COMMITTED = 4'd3;
localparam logic [3:0]  A7NG_C2MS_PH_PERSISTED = 4'd4;
localparam logic [3:0]  A7NG_C2MS_PH_FAILED    = 4'd5;
localparam logic [3:0]  A7NG_C2MS_F_NONE       = 4'd0;
localparam logic [3:0]  A7NG_C2MS_F_SCHEMA     = 4'd1;
localparam logic [3:0]  A7NG_C2MS_F_STALE_GEN  = 4'd2;
localparam logic [3:0]  A7NG_C2MS_F_DUP        = 4'd3;
localparam logic [3:0]  A7NG_C2MS_F_NO_PEND    = 4'd4;
localparam logic [3:0]  A7NG_C2MS_F_BAD_TXN    = 4'd5;
localparam logic [3:0]  A7NG_C2MS_F_CAP        = 4'd6;
`endif
