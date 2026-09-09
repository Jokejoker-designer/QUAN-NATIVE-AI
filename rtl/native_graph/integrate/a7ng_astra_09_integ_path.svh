`ifndef A7NG_ASTRA_09_INTEG_PATH_SVH
`define A7NG_ASTRA_09_INTEG_PATH_SVH
// ASTRA-09-INTEGRATED-PATH-01 contract. PROGRAM=NO.
// One named path: retrieve→2-hop→rank→pending→reward. load_from_tb=0.
// Pending key is {epoch[15:0]=sess_id_i, gen[7:0], txn[7:0]}. Epoch 0 invalid.
// CONFLICT/wrong-object must not rank away contradiction.
// AXI4 has no AR cancel. After AR handshake the slave owes R..RLAST.
// SLVERR / R timeout / NOLAST enter S_DRAIN then S_ABORT (ans/proof/pending cleared).
localparam int unsigned A7NG_A09_TO_CYC     = 64;
localparam int unsigned A7NG_A09_DRAIN_TO   = 64;
localparam logic [3:0]  A7NG_A09_SPARSE_RID = 4'd1;
localparam logic [3:0]  A7NG_A09_FACT_RID0  = 4'd2;
localparam logic [1:0]  A7NG_A09_RRESP_OK   = 2'b00;
localparam logic [7:0]  A7NG_A09_TXN_MAX    = 8'd255;
localparam logic [15:0] A7NG_A09_EPOCH_INV  = 16'd0;
`endif
