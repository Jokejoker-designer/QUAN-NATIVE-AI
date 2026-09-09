`ifndef A7NG_ASTRA_F3R4_DISTINCT_HOLD_PHI_SVH
`define A7NG_ASTRA_F3R4_DISTINCT_HOLD_PHI_SVH
// ASTRA-F3-R4-DISTINCT-HOLD-PHI-01. PROGRAM=NO.
// Shared 32-phi is non-ID (quality/flags/object-context). No gold/class/index.
// Distinct hold HASH. Fifth legal hop → INCOMP at MAX_PATH. Master 10pp/CI not claimed.
localparam int unsigned A7NG_F3R4_TO_CYC      = 64;
localparam int unsigned A7NG_F3R4_MAX_PATH    = 4;
localparam logic [3:0]  A7NG_F3R4_VER         = 4'd1;
localparam logic [3:0]  A7NG_F3R4_ST_ANSWER   = 4'd0;
localparam logic [3:0]  A7NG_F3R4_ST_UNKNOWN  = 4'd1;
localparam logic [3:0]  A7NG_F3R4_ST_INCOMP   = 4'd6;
localparam logic [3:0]  A7NG_F3R4_ST_AMB      = 4'd7;
localparam logic [3:0]  A7NG_F3R4_ST_NEG      = 4'd8;
localparam logic [7:0]  A7NG_F3R4_CTX_INDIRECT = 8'd2;
localparam logic [3:0]  A7NG_F3R4_FACT_RID    = 4'd2;
localparam logic [1:0]  A7NG_F3R4_RRESP_OK    = 2'b00;
`endif
