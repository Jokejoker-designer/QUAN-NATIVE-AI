`ifndef A7NG_ASTRA_C3_HELD_OUT_SVH
`define A7NG_ASTRA_C3_HELD_OUT_SVH
// ASTRA-C3-HELD-OUT-01. PROGRAM=NO.
// Compact TB-AXI wrap around C1 synonym KEEP + SGD KEEP.
// Master 10pp/CI/silicon not self-stamped from this file.
localparam int unsigned A7NG_C3_TO_CYC      = 64;
localparam int unsigned A7NG_C3_MAX_PATH    = 4;
localparam logic [3:0]  A7NG_C3_VER         = 4'd1;
localparam logic [3:0]  A7NG_C3_ST_ANSWER   = 4'd0;
localparam logic [3:0]  A7NG_C3_ST_UNKNOWN  = 4'd1;
localparam logic [3:0]  A7NG_C3_ST_CONFLICT = 4'd5;
localparam logic [3:0]  A7NG_C3_ST_INCOMP   = 4'd6;
localparam logic [3:0]  A7NG_C3_ST_AMB      = 4'd7;
localparam logic [3:0]  A7NG_C3_ST_NEG      = 4'd8;
localparam logic [7:0]  A7NG_C3_CTX_INDIRECT = 8'd2;
localparam logic [3:0]  A7NG_C3_FACT_RID    = 4'd2;
localparam logic [1:0]  A7NG_C3_RRESP_OK    = 2'b00;
`endif
