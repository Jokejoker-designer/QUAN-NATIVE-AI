`ifndef ASTRA_C3_TB_ORACLES_SVH
`define ASTRA_C3_TB_ORACLES_SVH
// Test-only plant identities. Not a production map. PROGRAM=NO.
localparam int C3_W_SUBJ [0:4] = '{10,11,1,6,9};
localparam int C3_W_REL  [0:4] = '{2,2,2,3,2};
localparam int C3_W_K0   [0:4] = '{16'h0A22,16'h0B22,16'h0122,16'h0623,16'h0922};
localparam int C3_W_K1   [0:4] = '{16'h0022,16'h0022,16'h0022,16'h0023,16'h0022};
localparam int C3_W_K2   [0:4] = '{766,1361,4408,289,1372};
localparam int C3_TR_CONF_W [0:4] = '{200,204,208,212,216};
localparam int C3_TR_CX1 = 1;
localparam int C3_TR_CX2 = 0;
`endif
