`ifndef A7NG_ASTRA_09_R7_UART_QUERY_REW_SVH
`define A7NG_ASTRA_09_R7_UART_QUERY_REW_SVH
// ASTRA-09-R7-UART-QUERY-REW-01 protocol. PROGRAM=NO.
// UART 8N1 around instantiated frozen A09-R2. Not PRODUCTION_TOP.
localparam logic [7:0] A7NG_A09R7_MAGIC   = 8'hA2;
localparam logic [7:0] A7NG_A09R7_EOL     = 8'h0A;
localparam logic [7:0] A7NG_A09R7_CMD_REW = 8'hA6;
localparam logic [7:0] A7NG_A09R7_CMD_RET = 8'hA7;
localparam logic [7:0] A7NG_A09R7_OBS_TAG = 8'h57;
localparam int unsigned A7NG_A09R7_TX_N   = 16;
`endif
