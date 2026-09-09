`ifndef A7NG_ASTRA_11_A09R8_UART_FREEZE_SVH
`define A7NG_ASTRA_11_A09R8_UART_FREEZE_SVH
// ASTRA-11-A09R8-UART-FREEZE-BIT-01 protocol (same bytes as R7 / A09R7 wrap).
// PROGRAM=NO. Not an edit of ASTRA-09-R7 or A09R7 svh.
localparam logic [7:0] A7NG_A09R8_MAGIC   = 8'hA2;
localparam logic [7:0] A7NG_A09R8_EOL     = 8'h0A;
localparam logic [7:0] A7NG_A09R8_CMD_REW = 8'hA6;
localparam logic [7:0] A7NG_A09R8_CMD_RET = 8'hA7;
localparam logic [7:0] A7NG_A09R8_OBS_TAG = 8'h57;
localparam int unsigned A7NG_A09R8_TX_N   = 16;
`endif
