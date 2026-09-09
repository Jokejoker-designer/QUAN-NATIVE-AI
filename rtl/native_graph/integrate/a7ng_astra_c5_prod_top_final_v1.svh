`ifndef A7NG_ASTRA_C5_PROD_TOP_FINAL_V1_SVH
`define A7NG_ASTRA_C5_PROD_TOP_FINAL_V1_SVH
// ASTRA-C5-FINAL-V1. PROGRAM=NO. C5_MASTER=OPEN.
// Hand-built hierarchy. Production ENTITY_ALIAS dictionary OPEN.
// Defaults 83.333MHz / 115200. TB may override CLK_HZ/BAUD.
localparam int unsigned A7NG_C5P_CLK_HZ     = 83333333;
localparam int unsigned A7NG_C5P_BAUD       = 115200;
localparam int unsigned A7NG_C5P_TFIFO      = 8;
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
localparam logic [1:0]  A7NG_C5P_OKAY        = 2'b00;
`endif
