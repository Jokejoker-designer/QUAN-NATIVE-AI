`ifndef A7NG_ASTRA_F2R5_TXN_WRAP_SVH
`define A7NG_ASTRA_F2R5_TXN_WRAP_SVH
// ASTRA-F2R-R5-TXN-WRAP-RESET-01 identity lifetime. PROGRAM=NO.
// Pending key is {epoch[15:0], gen[7:0], txn[7:0]}. Epoch 0 is invalid.
// epoch is sess_id_i (host session nonce / transport), NOT live_epoch_i
// (sparse-walker generation / semantic cue). Do not mix the two.
// 8-bit txn/gen do not wrap in-session: PICK at TXN_MAX refuses a new pending.
// rst_n clears pending/weights/counters; host must supply a fresh sess_id_i.
// DUT does not journal across power-loss. sess_id_i uniqueness is host protocol.
localparam int unsigned A7NG_F2R5_TO_CYC     = 64;
localparam int unsigned A7NG_F2R5_DRAIN_TO   = 64;
localparam logic [3:0]  A7NG_F2R5_SPARSE_RID = 4'd1;
localparam logic [3:0]  A7NG_F2R5_FACT_RID0  = 4'd2;
localparam logic [1:0]  A7NG_F2R5_RRESP_OK   = 2'b00;
localparam logic [7:0]  A7NG_F2R5_TXN_MAX    = 8'd255;
localparam logic [15:0] A7NG_F2R5_EPOCH_INV  = 16'd0;
`endif
