`ifndef A7NG_ASTRA_11_A09R7_SW_IO_SVH
`define A7NG_ASTRA_11_A09R7_SW_IO_SVH
// ASTRA-11-A09R7-SW-IO-01 protocol (same bytes as R7 XSim wrap).
// PROGRAM=NO. Not PRODUCTION_TOP. Not an edit of ASTRA-09-R7, BTN-IO, BTN-IDELAY, or LED-IO svh.
localparam logic [7:0] A7NG_A09R7_MAGIC   = 8'hA2;
localparam logic [7:0] A7NG_A09R7_EOL     = 8'h0A;
localparam logic [7:0] A7NG_A09R7_CMD_REW = 8'hA6;
localparam logic [7:0] A7NG_A09R7_CMD_RET = 8'hA7;
localparam logic [7:0] A7NG_A09R7_OBS_TAG = 8'h57;
localparam int unsigned A7NG_A09R7_TX_N   = 16;
`endif
