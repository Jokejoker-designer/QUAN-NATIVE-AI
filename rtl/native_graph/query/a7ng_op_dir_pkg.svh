`ifndef A7NG_OP_DIR_PKG_SVH
`define A7NG_OP_DIR_PKG_SVH
// E1a NEW GATE encoding. PROGRAM=NO.
// 2'd0 remains KEEP F SVO-as-written. Reverse is 2'd1, not a bit0 of 2'd0.
localparam logic [1:0] A7NG_OP_F_SVO_AS_WRITTEN = 2'd0;
localparam logic [1:0] A7NG_OP_R_INVERSE        = 2'd1;
localparam logic [1:0] A7NG_OP_INVALID         = 2'd2;
localparam logic [1:0] A7NG_OP_RESERVED        = 2'd3;
`endif
