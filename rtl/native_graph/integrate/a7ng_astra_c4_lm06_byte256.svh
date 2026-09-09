`ifndef A7NG_ASTRA_C4_LM06_BYTE256_SVH
`define A7NG_ASTRA_C4_LM06_BYTE256_SVH
// ASTRA-C4-LM06-BYTE256-CONTRACT-01. PROGRAM=NO.
// New versioned compatibility law. Does not overwrite historical 653/689/237/60.
// Does not freeze LM06_BYTE256 in FINAL_CONTRACT. Not grounded-gen 90%.
localparam int unsigned A7NG_C4_IN_W        = 8;
localparam int unsigned A7NG_C4_OUT_W       = 8;
localparam int unsigned A7NG_C4_HEAD10_W    = 10;
localparam int unsigned A7NG_C4_NCAND       = 4;
localparam logic [9:0]  A7NG_C4_BYTE_MAX    = 10'd255;
localparam logic [9:0]  A7NG_C4_HIST_653    = 10'd653;
localparam logic [9:0]  A7NG_C4_HIST_689    = 10'd689;
localparam logic [9:0]  A7NG_C4_HIST_237    = 10'd237;
localparam logic [9:0]  A7NG_C4_HIST_60     = 10'd60;
localparam logic [7:0]  A7NG_C4_EOS_BYTE    = 8'd0;
localparam int unsigned A7NG_C4_MAX_TOKENS  = 8;
localparam logic [3:0]  A7NG_C4_LAW_VER     = 4'd1;
`endif
