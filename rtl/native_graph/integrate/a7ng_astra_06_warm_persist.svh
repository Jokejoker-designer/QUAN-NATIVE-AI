`ifndef A7NG_ASTRA_06_WARM_PERSIST_SVH
`define A7NG_ASTRA_06_WARM_PERSIST_SVH
// ASTRA-06-WARM-PERSIST-01 modeled power-loss journal. PROGRAM=NO.
// Persist store is on-chip regs, NOT DDR/MIG/QSPI. rst_n does not clear it.
// Survives rst_n: committed weights, pending {sess,gen,txn,phi,v_pred},
// 20-bit {ans,p0,p1}, epoch. Does not survive: AXI ost, in-flight SGD.
// Epoch 0 invalid. sess_id_i is host session nonce, not live_epoch_i.
localparam int unsigned A7NG_A06_TO_CYC     = 64;
localparam int unsigned A7NG_A06_DRAIN_TO   = 64;
localparam logic [3:0]  A7NG_A06_SPARSE_RID = 4'd1;
localparam logic [3:0]  A7NG_A06_FACT_RID0  = 4'd2;
localparam logic [1:0]  A7NG_A06_RRESP_OK   = 2'b00;
localparam logic [7:0]  A7NG_A06_TXN_MAX    = 8'd255;
localparam logic [15:0] A7NG_A06_EPOCH_INV  = 16'd0;
`endif
