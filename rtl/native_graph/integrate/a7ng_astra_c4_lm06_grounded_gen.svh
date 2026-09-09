`ifndef A7NG_ASTRA_C4_LM06_GROUNDED_GEN_SVH
`define A7NG_ASTRA_C4_LM06_GROUNDED_GEN_SVH
// ASTRA-C4-LM06-GROUNDED-GEN-01. PROGRAM=NO.
// Compact linear head over materialized evidence features + loadable weights.
// Not 802k LM06. Does not freeze LM06_BYTE256. Not compose renderer.
localparam int unsigned A7NG_C4G_V          = 64;
localparam int unsigned A7NG_C4G_MAX_TOKENS = 4;
localparam logic [7:0]  A7NG_C4G_EOS        = 8'd0;
localparam logic [1:0]  A7NG_C4G_LD_BIAS    = 2'd0;
localparam logic [1:0]  A7NG_C4G_LD_MATCH   = 2'd1;
localparam logic [1:0]  A7NG_C4G_LD_SAFE    = 2'd2;
localparam logic [1:0]  A7NG_C4G_LD_EOS     = 2'd3;
`endif
