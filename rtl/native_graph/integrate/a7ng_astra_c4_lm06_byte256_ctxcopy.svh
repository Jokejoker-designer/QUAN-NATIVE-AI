`ifndef A7NG_ASTRA_C4_LM06_BYTE256_CTXCOPY_SVH
`define A7NG_ASTRA_C4_LM06_BYTE256_CTXCOPY_SVH
// ASTRA-C4-LM06-BYTE256-CTXCOPY-01. PROGRAM=NO.
// QUERY/PROOF context-copy BYTE256. No object-indexed name LUT in this header.
// Does not freeze LM06_BYTE256. Not TinyGPT-802k. Not compose renderer.
localparam int unsigned A7NG_C4X_NAME_N     = 3;
localparam int unsigned A7NG_C4X_MAX_TOKENS = 8;
localparam logic [7:0]  A7NG_C4X_EOS        = 8'd0;
localparam logic [7:0]  A7NG_C4X_MARK_Q     = 8'h51;
localparam logic [7:0]  A7NG_C4X_MARK_P     = 8'h50;
localparam logic [3:0]  A7NG_C4X_VOCAB_VER  = 4'd2;
localparam logic [1:0]  A7NG_C4X_LD_COPY    = 2'd1;
localparam logic [1:0]  A7NG_C4X_LD_SAFE    = 2'd2;
localparam logic [1:0]  A7NG_C4X_LD_EOS     = 2'd3;
`endif
