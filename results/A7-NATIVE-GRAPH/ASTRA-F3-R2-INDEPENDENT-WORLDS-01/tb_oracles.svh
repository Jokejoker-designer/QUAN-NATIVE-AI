`ifndef ASTRA_F3R2_TB_ORACLES_SVH
`define ASTRA_F3R2_TB_ORACLES_SVH
// Frozen identities and directory keys (not scores). Do not edit after XSim.
// Hold proof0 / dest are not train-phi ID remaps.

// S0: quality across hop 2→1. train "pump requires indirect"; hold "pump requires water"
localparam logic [19:0] F3R2_S0_TR_G = 20'd17,  F3R2_S0_TR_D = 20'd18;
localparam logic [19:0] F3R2_S0_SH_G = 20'd19,  F3R2_S0_SH_D = 20'd16;
localparam logic [19:0] F3R2_S0_HO_G = 20'h211, F3R2_S0_HO_D = 20'h111;
localparam logic [19:0] F3R2_S0_TR_ANS = 20'd20, F3R2_S0_TR_DANS = 20'd21;
localparam logic [19:0] F3R2_S0_HO_ANS = 20'h80, F3R2_S0_HO_DANS = 20'h81;

// S1: ctx_match across rel/role/hop. train "valve supplies water"; hold "chiller requires indirect"
localparam logic [19:0] F3R2_S1_TR_G = 20'd40,  F3R2_S1_TR_D = 20'd42;
localparam logic [19:0] F3R2_S1_SH_G = 20'd43,  F3R2_S1_SH_D = 20'd39;
localparam logic [19:0] F3R2_S1_HO_G = 20'h411, F3R2_S1_HO_D = 20'h311;
localparam logic [19:0] F3R2_S1_TR_ANS = 20'h22, F3R2_S1_TR_DANS = 20'h23;
localparam logic [19:0] F3R2_S1_HO_ANS = 20'h82, F3R2_S1_HO_DANS = 20'h83;

// S2: hop2 obj-ctx, object-bound, mixed on hold. train compressor; hold evaporator
localparam logic [19:0] F3R2_S2_TR_G = 20'd50,  F3R2_S2_TR_D = 20'd52;
localparam logic [19:0] F3R2_S2_SH_G = 20'd54,  F3R2_S2_SH_D = 20'd48;
localparam logic [19:0] F3R2_S2_HO_G = 20'h611, F3R2_S2_HO_D = 20'h511;
localparam logic [19:0] F3R2_S2_TR_ANS = 20'd4,  F3R2_S2_TR_DANS = 20'd4;
localparam logic [19:0] F3R2_S2_HO_ANS = 20'd3,  F3R2_S2_HO_DANS = 20'd3;

// S3: mixed_ctx + dead-end support. train "ahu connects indirect"; hold "tower requires indirect"
localparam logic [19:0] F3R2_S3_TR_G = 20'd60,  F3R2_S3_TR_D = 20'd62;
localparam logic [19:0] F3R2_S3_SH_G = 20'd65,  F3R2_S3_SH_D = 20'd58;
localparam logic [19:0] F3R2_S3_HO_G = 20'h811, F3R2_S3_HO_D = 20'h711;
localparam logic [19:0] F3R2_S3_TR_ANS = 20'h24, F3R2_S3_TR_DANS = 20'h25;
localparam logic [19:0] F3R2_S3_HO_ANS = 20'h84, F3R2_S3_HO_DANS = 20'h85;

// S4: ctx_nz not ctx_match. train "compressor supplies air"; hold "sensor requires indirect"
localparam logic [19:0] F3R2_S4_TR_G = 20'd70,  F3R2_S4_TR_D = 20'd71;
localparam logic [19:0] F3R2_S4_SH_G = 20'd72,  F3R2_S4_SH_D = 20'd68;
localparam logic [19:0] F3R2_S4_HO_G = 20'hC10, F3R2_S4_HO_D = 20'hC00;
localparam logic [19:0] F3R2_S4_TR_ANS = 20'h26, F3R2_S4_TR_DANS = 20'h27;
localparam logic [19:0] F3R2_S4_HO_ANS = 20'h86, F3R2_S4_HO_DANS = 20'h87;

// LAW_SEL=1 directory keys (k0={subj,rel}, k2=subj_cue[15:0])
localparam int F3R2_K0_PUMP_REQ   = 2562;
localparam int F3R2_K2_PUMP       = 766;
localparam int F3R2_K0_VALVE_SUP  = 2817;
localparam int F3R2_K2_VALVE      = 1361;
localparam int F3R2_K0_CHILL_REQ  = 258;
localparam int F3R2_K2_CHILLER    = 4408;
localparam int F3R2_K0_VALVE_REQ  = 2818;
localparam int F3R2_K0_AHU_CONN   = 1539;
localparam int F3R2_K2_AHU        = 289;
localparam int F3R2_K0_TOWER_REQ  = 2306;
localparam int F3R2_K2_TOWER      = 1372;
localparam int F3R2_K0_COMP_SUP   = 1025;
localparam int F3R2_K2_COMP       = 35176;
localparam int F3R2_K0_SENS_REQ   = 3074;
localparam int F3R2_K2_SENSOR     = 2592;
localparam int F3R2_K1_COMP_REQ   = 1026;
localparam int F3R2_K3_COMP       = 35176;
localparam int F3R2_K1_EVAP_REQ   = 770;
localparam int F3R2_K3_EVAP       = 38964;
`endif
