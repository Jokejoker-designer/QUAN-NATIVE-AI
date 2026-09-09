// Wrapper tops so CAND_CAP_SWEEP is bound at elab without -generic_top.
// Vivado xelab.bat splits CAND_CAP_SWEEP=16 on '='.
`timescale 1ns / 1ps
module tb_sweep_16;
  tb_astra_c1_cand_cap_sweep #(.CAND_CAP_SWEEP(16)) u();
endmodule
module tb_sweep_64;
  tb_astra_c1_cand_cap_sweep #(.CAND_CAP_SWEEP(64)) u();
endmodule
module tb_sweep_128;
  tb_astra_c1_cand_cap_sweep #(.CAND_CAP_SWEEP(128)) u();
endmodule
module tb_sweep_256;
  tb_astra_c1_cand_cap_sweep #(.CAND_CAP_SWEEP(256)) u();
endmodule
