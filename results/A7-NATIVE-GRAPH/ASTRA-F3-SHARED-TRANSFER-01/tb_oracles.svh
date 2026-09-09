`ifndef ASTRA_F3_TB_ORACLES_SVH
`define ASTRA_F3_TB_ORACLES_SVH
// Frozen identities (not scores). Do not edit after XSim to manufacture PASS.
localparam logic [19:0] F3_S0_TR_G = 20'd17,  F3_S0_TR_D = 20'd18;
localparam logic [19:0] F3_S0_HO_G = 20'h211, F3_S0_HO_D = 20'h111;
localparam logic [19:0] F3_S1_TR_G = 20'd40,  F3_S1_TR_D = 20'd42;
localparam logic [19:0] F3_S1_HO_G = 20'h411, F3_S1_HO_D = 20'h311;
localparam logic [19:0] F3_S2_TR_G = 20'd50,  F3_S2_TR_D = 20'd52;
localparam logic [19:0] F3_S2_HO_G = 20'h611, F3_S2_HO_D = 20'h511;
localparam logic [19:0] F3_S3_TR_G = 20'd60,  F3_S3_TR_D = 20'd62;
localparam logic [19:0] F3_S3_HO_G = 20'h811, F3_S3_HO_D = 20'h711;
localparam logic [19:0] F3_S4_TR_G = 20'd70,  F3_S4_TR_D = 20'd71;
localparam logic [19:0] F3_S4_HO_G = 20'hC10, F3_S4_HO_D = 20'hC00;
localparam logic [19:0] F3_S0_TR_ANS = 20'd4,    F3_S0_HO_ANS = 20'h40;
localparam logic [19:0] F3_S1_TR_ANS = 20'd4,    F3_S1_HO_ANS = 20'h40;
localparam logic [19:0] F3_S2_TR_ANS = 20'd4,    F3_S2_HO_ANS = 20'd4;
localparam logic [19:0] F3_S3_TR_ANS = 20'd11,   F3_S3_HO_ANS = 20'hB0;
localparam logic [19:0] F3_S4_TR_ANS = 20'd11,   F3_S4_HO_ANS = 20'hC1;
`endif
