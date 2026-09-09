`ifndef A7NG_ASTRA_C2_PERSIST_MIG_SVH
`define A7NG_ASTRA_C2_PERSIST_MIG_SVH
// ASTRA-C2-PERSIST-MIG-01. PROGRAM=NO. Named MIG persist law.
// Instantiates persist-commit KEEP. Does not edit KEEP persist, mig.prj, or ddr3_model.
// AXI master talks to official Digilent AXI MIG (mig_native_wrap + mig_sim).
// PERSIST_BASE=0x06000000, never subj[15:0]. Not BOARD. Not Master C2 close.
// PERSIST_SCHEMA_VERSION and DDR_QUERY_BOUND_FINAL stay NOT_FROZEN.
`include "a7ng_astra_c2_persist_commit.svh"
localparam logic A7NG_C2MIG_REQUIRE_CALIB = 1'b1;
`endif
