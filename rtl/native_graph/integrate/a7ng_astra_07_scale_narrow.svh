`ifndef A7NG_ASTRA_07_SCALE_NARROW_SVH
`define A7NG_ASTRA_07_SCALE_NARROW_SVH
// ASTRA-07-SCALE-NARROW-01 contract. PROGRAM=NO.
// Named wrap around frozen a7ng_astra_09_integ_path. Does not patch A09.
// Overflow identity: directory post_count > CAND_CAP or dir[48] ovf-ent
// fail-closes ST_INCOMP with ans/p0 cleared (no stale ANSWER from truncated leftover).
// MAX_PATH INCOMP remains A09 S_GUARD (n_legal > MAX_PATH).
// Not 65536. Not 800k. Not BOARD.
localparam int unsigned A7NG_A07_CAND_CAP   = 16;
localparam int unsigned A7NG_A07_MAX_PATH   = 4;
localparam int unsigned A7NG_A07_OVF_PLANT  = 20;
localparam logic [3:0]  A7NG_A07_ST_INCOMP  = 4'd6;
localparam logic [3:0]  A7NG_A07_ST_ANSWER  = 4'd0;
localparam logic [3:0]  A7NG_A07_ST_UNKNOWN = 4'd1;
localparam logic [27:0] A7NG_A07_DIR_SPAN   = 28'h0004_0000;
`endif
