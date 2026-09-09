`ifndef A7NG_ASTRA_C5_SGD32_CKPT_SVH
`define A7NG_ASTRA_C5_SGD32_CKPT_SVH
// ASTRA-C5-SGD32-CKPT-01 / WO-01B. PROGRAM=NO.
// Named serialization backend. Does not edit C2 KEEP.
// Bag-local schema. PERSIST_SCHEMA_VERSION stays NOT_FROZEN.
localparam logic [15:0] A7NG_C5K_MAGIC      = 16'hC5B1;
localparam logic [7:0]  A7NG_C5K_VER        = 8'd1;
localparam logic [7:0]  A7NG_C5K_SCHEMA     = 8'd1;
localparam logic [7:0]  A7NG_C5K_NW         = 8'd32;
localparam logic [27:0] A7NG_C5K_BASE       = 28'h0600_0000;
localparam int unsigned A7NG_C5K_NBEAT      = 6;
localparam int unsigned A7NG_C5K_TO         = 256;
localparam logic [3:0]  A7NG_C5K_PH_IDLE       = 4'd0;
localparam logic [3:0]  A7NG_C5K_PH_CAPTURE    = 4'd1;
localparam logic [3:0]  A7NG_C5K_PH_WRITE      = 4'd2;
localparam logic [3:0]  A7NG_C5K_PH_WAITB      = 4'd3;
localparam logic [3:0]  A7NG_C5K_PH_PERSISTED  = 4'd4;
localparam logic [3:0]  A7NG_C5K_PH_READ       = 4'd5;
localparam logic [3:0]  A7NG_C5K_PH_LOAD       = 4'd6;
localparam logic [3:0]  A7NG_C5K_PH_READY      = 4'd7;
localparam logic [3:0]  A7NG_C5K_PH_FAILED     = 4'd8;
localparam logic [3:0]  A7NG_C5K_F_NONE     = 4'd0;
localparam logic [3:0]  A7NG_C5K_F_MAGIC    = 4'd1;
localparam logic [3:0]  A7NG_C5K_F_SCHEMA   = 4'd2;
localparam logic [3:0]  A7NG_C5K_F_CRC      = 4'd3;
localparam logic [3:0]  A7NG_C5K_F_COMMIT   = 4'd4;
localparam logic [3:0]  A7NG_C5K_F_BRESP    = 4'd5;
localparam logic [3:0]  A7NG_C5K_F_RRESP    = 4'd6;
localparam logic [3:0]  A7NG_C5K_F_TO       = 4'd7;
localparam logic [3:0]  A7NG_C5K_F_HALF     = 4'd8;
`endif
