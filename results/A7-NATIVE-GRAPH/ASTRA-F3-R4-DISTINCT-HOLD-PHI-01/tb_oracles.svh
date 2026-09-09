`ifndef ASTRA_F3R4_TB_ORACLES_SVH
`define ASTRA_F3R4_TB_ORACLES_SVH
// Frozen identities and directory keys (not scores). Do not edit after XSim.
// Distinct hold 32-phi HASH per query. Unique train HASH per world.
// Shared+private complete 2-hops enter npath. Fifth hop INCOMP at cap=4.

localparam int F3R4_N_WORLD = 5;
localparam int F3R4_N_Q     = 8;
localparam int F3R4_N_EPOCH = 2;
localparam logic [31:0] F3R4_GEN_SEED = 32'hA5F34001;

localparam int F3R4_TR_W [0:7] = '{0,1,2,3,4,0,1,2};
localparam int F3R4_HO_W [0:7] = '{4,3,0,1,2,4,3,1};
localparam bit F3R4_HO_OV [0:7] = '{0,0,0,0,0,0,1,1};

localparam int F3R4_W_SUBJ [0:4] = '{10,11,1,6,9};
localparam int F3R4_W_REL  [0:4] = '{2,2,2,3,2};
localparam int F3R4_W_K0   [0:4] = '{2562,2818,258,1539,2306};
localparam int F3R4_W_K2   [0:4] = '{766,1361,4408,289,1372};

localparam int F3R4_SHARED_DST    = 64;
localparam int F3R4_SHARED_BG_DST = 96;
localparam int F3R4_SHARED_MID    = 80;

localparam int F3R4_TR_G0 [0:7] = '{16,20,24,28,32,36,40,44};
localparam int F3R4_HO_D0 [0:7] = '{256,260,264,268,272,276,280,284};
localparam int F3R4_HO_G0 [0:7] = '{258,262,266,270,274,278,282,286};
localparam int F3R4_SH_D0 [0:7] = '{128,132,136,140,144,148,152,156};
localparam int F3R4_SHH_G0 [0:7] = '{384,388,392,396,400,404,408,412};
localparam int F3R4_SHH_D0 [0:7] = '{386,390,394,398,402,406,410,414};

localparam int F3R4_HO_GDST [0:7] = '{112,113,114,115,116,117,64,64};
localparam int F3R4_HO_DDST [0:7] = '{144,145,146,147,148,149,150,151};

// Train gold conf per world (unique train HASH). Hold gold conf per query
// (unique hold HASH even when HO_W repeats). Dist conf matches gold of that query.
localparam int F3R4_TR_CONF_W [0:4] = '{200,204,208,212,216};
localparam int F3R4_HO_CONF_Q [0:7] = '{220,224,228,232,236,240,244,248};
localparam int F3R4_HO_CX1 [0:7] = '{3,3,4,4,5,3,4,5};
localparam int F3R4_HO_CX2 [0:7] = '{1,2,1,2,1,0,0,2};
localparam int F3R4_TR_CX1 = 1;
localparam int F3R4_TR_CX2 = 0;
localparam int F3R4_EXTRA_CONF = 160;
`endif
