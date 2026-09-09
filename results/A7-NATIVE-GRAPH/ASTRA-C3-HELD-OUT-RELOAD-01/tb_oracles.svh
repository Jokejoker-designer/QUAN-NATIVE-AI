`ifndef ASTRA_C3_RELOAD_TB_ORACLES_SVH
`define ASTRA_C3_RELOAD_TB_ORACLES_SVH
// Frozen identities copied from ASTRA-C3-HELD-OUT-01. Do not edit after XSim.
// Train subjects {10,11,1} disjoint from hold subjects {6,9}.
// PROGRAM=NO. Does not freeze Master C3.

localparam int C3_N_WORLD = 5;
localparam int C3_N_Q     = 8;
localparam int C3_N_SEED  = 5;
localparam logic [31:0] C3_GEN_SEED = 32'hC3000001;

localparam int C3_TR_W [0:7] = '{0,1,2,0,1,2,0,1};
localparam int C3_HO_W [0:7] = '{3,4,3,4,3,4,3,4};

localparam int C3_W_SUBJ [0:4] = '{10,11,1,6,9};
localparam int C3_W_REL  [0:4] = '{2,2,2,3,2};
localparam int C3_W_K0   [0:4] = '{16'h0A22,16'h0B22,16'h0122,16'h0623,16'h0922};
localparam int C3_W_K1   [0:4] = '{16'h0022,16'h0022,16'h0022,16'h0023,16'h0022};
localparam int C3_W_K2   [0:4] = '{766,1361,4408,289,1372};

localparam int C3_SHARED_DST    = 64;
localparam int C3_SHARED_BG_DST = 96;
localparam int C3_SHARED_MID    = 80;

localparam int C3_TR_G0 [0:7] = '{16,20,24,28,32,36,40,44};
localparam int C3_HO_D0 [0:7] = '{256,260,264,268,272,276,280,284};
localparam int C3_HO_G0 [0:7] = '{258,262,266,270,274,278,282,286};

localparam int C3_HO_GDST [0:7] = '{112,113,114,115,116,117,118,119};
localparam int C3_HO_DDST [0:7] = '{144,145,146,147,148,149,150,151};

localparam int C3_TR_CONF_W [0:4] = '{200,204,208,212,216};
localparam int C3_HO_CONF_Q [0:7] = '{220,224,228,232,236,240,244,248};
localparam int C3_HO_CX1 [0:7] = '{3,3,4,4,5,3,4,5};
localparam int C3_HO_CX2 [0:7] = '{1,2,1,2,1,0,0,2};
localparam int C3_TR_CX1 = 1;
localparam int C3_TR_CX2 = 0;
localparam int C3_EXTRA_CONF = 160;
`endif
