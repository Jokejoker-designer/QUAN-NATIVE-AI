`ifndef A7NG_ASTRA_C5_PROD_TOP_CKPT_SVH
`define A7NG_ASTRA_C5_PROD_TOP_CKPT_SVH
// ASTRA-C5-EXPLICIT-REWARD-AND-FULLSTATE-01B. PROGRAM=NO.
// Named C5 top. Does not edit live a7ng_astra_c5_prod_top.svh (8000/800 stay).
// Does not freeze DDR_QUERY_BOUND_FINAL / PERSIST_SCHEMA_VERSION.
// Does not instantiate C2 on 0x06000000. C5_MASTER stays OPEN.
localparam int unsigned A7NG_C5P_CLK_HZ     = 8000;
localparam int unsigned A7NG_C5P_BAUD       = 800;
localparam logic [27:0] A7NG_C5P_FACT_BASE  = 28'h0580_0000;
localparam logic [7:0]  A7NG_C5P_EOL        = 8'h0A;
localparam logic [7:0]  A7NG_C5P_CMD_FLUSH  = 8'h0C;
localparam logic [7:0]  A7NG_C5P_CMD_RELOAD = 8'h12;
localparam logic [7:0]  A7NG_C5P_CMD_FREEZE = 8'h14;
localparam logic [7:0]  A7NG_C5P_CMD_LEARN  = 8'h15;
localparam logic [7:0]  A7NG_C5P_CMD_REWARD = 8'h16;
localparam logic [7:0]  A7NG_C5P_REW_VER    = 8'd1;
localparam logic [7:0]  A7NG_C5P_REW_PLEN   = 8'd6;
localparam logic [15:0] A7NG_C5P_INST_MASK  = 16'h0FFF;
localparam logic [3:0]  A7NG_C5P_ST_ANSWER   = 4'd0;
localparam logic [3:0]  A7NG_C5P_ST_UNKNOWN  = 4'd1;
localparam logic [3:0]  A7NG_C5P_ST_CONFLICT = 4'd5;
localparam logic [3:0]  A7NG_C5P_ST_INCOMP   = 4'd6;
localparam logic [3:0]  A7NG_C5P_ST_AMB      = 4'd7;
`endif
