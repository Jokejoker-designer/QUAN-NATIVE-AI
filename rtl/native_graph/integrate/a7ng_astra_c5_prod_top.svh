`ifndef A7NG_ASTRA_C5_PROD_TOP_SVH
`define A7NG_ASTRA_C5_PROD_TOP_SVH
// ASTRA-C5-PROD-TOP-01. PROGRAM=NO.
// One production hierarchy. Simulation fixtures stay in the TB.
// Does not freeze DDR_QUERY_BOUND_FINAL. A09R8 is not this top.
// Not MIG PHY. Not BOARD. C5_MASTER stays OPEN from this bag alone.
localparam int unsigned A7NG_C5P_CLK_HZ     = 8000;
localparam int unsigned A7NG_C5P_BAUD       = 800;
localparam logic [27:0] A7NG_C5P_FACT_BASE  = 28'h0580_0000;
localparam logic [7:0]  A7NG_C5P_EOL        = 8'h0A;
localparam logic [7:0]  A7NG_C5P_CMD_FLUSH  = 8'h0C;
localparam logic [7:0]  A7NG_C5P_CMD_RELOAD = 8'h12;
localparam logic [7:0]  A7NG_C5P_CMD_FREEZE = 8'h14;
localparam logic [7:0]  A7NG_C5P_CMD_LEARN  = 8'h15;
localparam logic [15:0] A7NG_C5P_INST_MASK  = 16'h0FFF;
localparam logic [3:0]  A7NG_C5P_ST_ANSWER   = 4'd0;
localparam logic [3:0]  A7NG_C5P_ST_UNKNOWN  = 4'd1;
localparam logic [3:0]  A7NG_C5P_ST_CONFLICT = 4'd5;
localparam logic [3:0]  A7NG_C5P_ST_INCOMP   = 4'd6;
localparam logic [3:0]  A7NG_C5P_ST_AMB      = 4'd7;
`endif
