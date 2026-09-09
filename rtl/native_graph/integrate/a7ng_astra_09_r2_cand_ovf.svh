`ifndef A7NG_ASTRA_09_R2_CAND_OVF_SVH
`define A7NG_ASTRA_09_R2_CAND_OVF_SVH
// ASTRA-09-R2-CAND-OVF-01 contract. PROGRAM=NO.
// New named A09 revision. Does not patch frozen a7ng_astra_09_integ_path.
// Identity: walker n_trunc_o!=0 (or q_overflow_o) → ST_INCOMP, ans/p0=0, pend_acc=0.
// Not a wrap around frozen A09 leftover ANSWER 4. Not 65536. Not 800k. Not BOARD.
localparam int unsigned A7NG_A09R2_CAND_CAP  = 16;
localparam int unsigned A7NG_A09R2_MAX_PATH  = 4;
localparam int unsigned A7NG_A09R2_OVF_PLANT = 20;
localparam logic [3:0]  A7NG_A09R2_ST_INCOMP = 4'd6;
localparam logic [3:0]  A7NG_A09R2_ST_ANSWER = 4'd0;
localparam logic [3:0]  A7NG_A09R2_ST_UNKNOWN= 4'd1;
`endif
