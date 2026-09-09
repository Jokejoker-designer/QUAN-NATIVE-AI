`ifndef A7NG_ASTRA_C5_SGD32_CKPT_PEND_SVH
`define A7NG_ASTRA_C5_SGD32_CKPT_PEND_SVH
// ASTRA-C5-PEND-PROOF-PHI-01. PROGRAM=NO.
// Named pending+weight snapshot. Does not edit C2 KEEP or sgd32_ckpt.
// PERSIST_SCHEMA_VERSION stays NOT_FROZEN.
localparam logic [15:0] A7NG_C5P_MAGIC      = 16'hC5B1;
localparam logic [7:0]  A7NG_C5P_VER        = 8'd1;
localparam logic [7:0]  A7NG_C5P_SCHEMA     = 8'd2;
localparam logic [7:0]  A7NG_C5P_NW         = 8'd32;
localparam logic [27:0] A7NG_C5P_BASE       = 28'h0600_0000;
localparam int unsigned A7NG_C5P_NBEAT      = 9;
localparam int unsigned A7NG_C5P_TO         = 256;
localparam logic [3:0]  A7NG_C5P_PH_IDLE       = 4'd0;
localparam logic [3:0]  A7NG_C5P_PH_CAPTURE    = 4'd1;
localparam logic [3:0]  A7NG_C5P_PH_WRITE      = 4'd2;
localparam logic [3:0]  A7NG_C5P_PH_WAITB      = 4'd3;
localparam logic [3:0]  A7NG_C5P_PH_PERSISTED  = 4'd4;
localparam logic [3:0]  A7NG_C5P_PH_READ       = 4'd5;
localparam logic [3:0]  A7NG_C5P_PH_LOAD       = 4'd6;
localparam logic [3:0]  A7NG_C5P_PH_READY      = 4'd7;
localparam logic [3:0]  A7NG_C5P_PH_FAILED     = 4'd8;
localparam logic [3:0]  A7NG_C5P_F_NONE     = 4'd0;
localparam logic [3:0]  A7NG_C5P_F_MAGIC    = 4'd1;
localparam logic [3:0]  A7NG_C5P_F_SCHEMA   = 4'd2;
localparam logic [3:0]  A7NG_C5P_F_CRC      = 4'd3;
localparam logic [3:0]  A7NG_C5P_F_COMMIT   = 4'd4;
localparam logic [3:0]  A7NG_C5P_F_BRESP    = 4'd5;
localparam logic [3:0]  A7NG_C5P_F_RRESP    = 4'd6;
localparam logic [3:0]  A7NG_C5P_F_TO       = 4'd7;
`endif
