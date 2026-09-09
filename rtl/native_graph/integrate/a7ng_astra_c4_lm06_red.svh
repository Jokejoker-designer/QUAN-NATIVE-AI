`ifndef A7NG_ASTRA_C4_LM06_RED_SVH
`define A7NG_ASTRA_C4_LM06_RED_SVH
// ASTRA-C4-LM06-RED-BYTE256-01. PROGRAM=NO.
// Reduced decoder-only BYTE256 block (tied embed + 1 attn + FFN).
// LM06-compatible token law. Not TinyGPT-802k. Not grounded_gen KEEP.
// Does not freeze LM06_BYTE256. Does not stamp C4_MASTER.
localparam int unsigned A7NG_C4L_V          = 256;
localparam int unsigned A7NG_C4L_D          = 4;
localparam int unsigned A7NG_C4L_F          = 8;
localparam int unsigned A7NG_C4L_SHR        = 4;
localparam int unsigned A7NG_C4L_MAX_TOKENS = 6;
localparam int unsigned A7NG_C4L_CTX        = 16;
localparam int unsigned A7NG_C4L_TMAX       = 24;
localparam int unsigned A7NG_C4L_OFF_WE     = 0;
localparam int unsigned A7NG_C4L_OFF_WQ     = 1024;
localparam int unsigned A7NG_C4L_OFF_WK     = 1040;
localparam int unsigned A7NG_C4L_OFF_WV     = 1056;
localparam int unsigned A7NG_C4L_OFF_W1     = 1072;
localparam int unsigned A7NG_C4L_OFF_W2     = 1104;
localparam int unsigned A7NG_C4L_OFF_BY     = 1136;
localparam int unsigned A7NG_C4L_N_W        = 1392;
localparam logic [7:0]  A7NG_C4L_EOS        = 8'd0;
localparam logic [7:0]  A7NG_C4L_CH_N       = 8'h6E;
localparam logic [7:0]  A7NG_C4L_CH_O       = 8'h6F;
localparam logic [3:0]  A7NG_C4L_VOCAB_VER  = 4'd2;
localparam logic [9:0]  A7NG_C4L_HEAD10_PAD = 10'd0;
`endif
