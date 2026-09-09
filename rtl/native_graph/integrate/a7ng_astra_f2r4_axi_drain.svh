`ifndef A7NG_ASTRA_F2R4_AXI_DRAIN_SVH
`define A7NG_ASTRA_F2R4_AXI_DRAIN_SVH
// ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01 contract constants. PROGRAM=NO.
// AXI4 has no AR cancel. After AR handshake the slave owes R..RLAST.
localparam int unsigned A7NG_F2R4_TO_CYC     = 64;
localparam int unsigned A7NG_F2R4_DRAIN_TO   = 64;
localparam logic [3:0]  A7NG_F2R4_SPARSE_RID = 4'd1;
localparam logic [3:0]  A7NG_F2R4_FACT_RID0  = 4'd2;
localparam logic [1:0]  A7NG_F2R4_RRESP_OK   = 2'b00;
`endif
