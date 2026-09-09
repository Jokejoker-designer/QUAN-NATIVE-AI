`ifndef A7NG_ASTRA_C4_COND_RNN_SVH
`define A7NG_ASTRA_C4_COND_RNN_SVH
// ASTRA-C4-COND-RNN-BYTE256-01. PROGRAM=NO.
// Compact integer Elman, BYTE256 tokens. Rival-1 feasibility candidate.
// Does not edit grounded_gen KEEP / TinyGPT / a7lm06_wmem.hex.
// Does not freeze LM06_BYTE256. Does not stamp C4_MASTER.
localparam int unsigned A7NG_C4R_V          = 256;
localparam int unsigned A7NG_C4R_E          = 4;
localparam int unsigned A7NG_C4R_H          = 8;
localparam int unsigned A7NG_C4R_SHR        = 4;
localparam int unsigned A7NG_C4R_MAX_TOKENS = 6;
localparam int unsigned A7NG_C4R_CTX        = 16;
localparam int unsigned A7NG_C4R_OFF_WE     = 0;
localparam int unsigned A7NG_C4R_OFF_WXH    = 1024;
localparam int unsigned A7NG_C4R_OFF_WHH    = 1056;
localparam int unsigned A7NG_C4R_OFF_BH     = 1120;
localparam int unsigned A7NG_C4R_OFF_BY     = 1128;
localparam int unsigned A7NG_C4R_N_W        = 1384;
localparam logic [7:0]  A7NG_C4R_EOS        = 8'd0;
localparam logic [7:0]  A7NG_C4R_CH_N       = 8'h6E;
localparam logic [7:0]  A7NG_C4R_CH_O       = 8'h6F;
localparam logic [3:0]  A7NG_C4R_VOCAB_VER  = 4'd1;
`endif
