`ifndef A7NG_ASTRA_C5_DDR_ARB_SVH
`define A7NG_ASTRA_C5_DDR_ARB_SVH
// ASTRA-C5-DDR-ARB-01. PROGRAM=NO.
// Six DDR client classes, one owner. No mid-flight owner change.
// Does not freeze DDR_QUERY_BOUND_FINAL. Not production top. Not MIG PHY.
localparam int unsigned A7NG_C5_NCLI        = 6;
localparam logic [2:0]  A7NG_C5_NONE        = 3'd7;
localparam logic [2:0]  A7NG_C5_IDX         = 3'd0;
localparam logic [2:0]  A7NG_C5_QDIR        = 3'd1;
localparam logic [2:0]  A7NG_C5_DESC        = 3'd2;
localparam logic [2:0]  A7NG_C5_LRN         = 3'd3;
localparam logic [2:0]  A7NG_C5_LMD         = 3'd4;
localparam logic [2:0]  A7NG_C5_CKPT        = 3'd5;
localparam logic [27:0] A7NG_C5_CKPT_BASE   = 28'h0600_0000;
localparam logic [27:0] A7NG_C5_IDX_BASE    = 28'h0500_0000;
`endif
