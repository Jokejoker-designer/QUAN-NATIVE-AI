// Opaque entity/edge IDs for ASTRA-05 TB. Not an answer ROM.
// Generated/owned by host_astra05.py. Engine RTL must not contain these constants.
`ifndef ASTRA05_IDS_SVH
`define ASTRA05_IDS_SVH
localparam logic [7:0] A5_READ_A  = 8'hA1;
localparam logic [7:0] A5_READY_B = 8'hB2;
localparam logic [7:0] A5_CALIB_C = 8'hC3;
localparam logic [7:0] A5_CALIB_D = 8'hD4;
localparam logic [7:0] A5_REL_REQ = 8'h21;
localparam logic [7:0] A5_EID_AB  = 8'h11;
localparam logic [7:0] A5_EID_BC  = 8'h22;
localparam logic [7:0] A5_EID_BD  = 8'h33;
localparam logic [7:0] A5_EID_NEG = 8'h44;
localparam logic [7:0] A5_RND_X   = 8'h3E;
localparam logic [7:0] A5_RND_Y   = 8'h91;
localparam logic [7:0] A5_RND_Z   = 8'h07;
localparam logic [7:0] A5_RND_E0  = 8'h54;
localparam logic [7:0] A5_RND_E1  = 8'hA8;
`endif
