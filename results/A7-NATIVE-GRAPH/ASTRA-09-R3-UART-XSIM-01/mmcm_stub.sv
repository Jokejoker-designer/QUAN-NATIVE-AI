// Behavioral MMCME2_BASE + BUFG for XSim when unisim is not bound.
// NOT silicon MMCM. RESULTS must say MMCM_STUB.
`timescale 1ns / 1ps

module MMCME2_BASE #(
  parameter BANDWIDTH = "OPTIMIZED",
  parameter real CLKFBOUT_MULT_F = 5.000,
  parameter real CLKFBOUT_PHASE = 0.000,
  parameter real CLKIN1_PERIOD = 0.000,
  parameter real CLKOUT0_DIVIDE_F = 1.000,
  parameter real CLKOUT0_DUTY_CYCLE = 0.500,
  parameter real CLKOUT0_PHASE = 0.000,
  parameter integer CLKOUT1_DIVIDE = 1,
  parameter real CLKOUT1_DUTY_CYCLE = 0.500,
  parameter real CLKOUT1_PHASE = 0.000,
  parameter integer CLKOUT2_DIVIDE = 1,
  parameter real CLKOUT2_DUTY_CYCLE = 0.500,
  parameter real CLKOUT2_PHASE = 0.000,
  parameter integer CLKOUT3_DIVIDE = 1,
  parameter real CLKOUT3_DUTY_CYCLE = 0.500,
  parameter real CLKOUT3_PHASE = 0.000,
  parameter CLKOUT4_CASCADE = "FALSE",
  parameter integer CLKOUT4_DIVIDE = 1,
  parameter real CLKOUT4_DUTY_CYCLE = 0.500,
  parameter real CLKOUT4_PHASE = 0.000,
  parameter integer CLKOUT5_DIVIDE = 1,
  parameter real CLKOUT5_DUTY_CYCLE = 0.500,
  parameter real CLKOUT5_PHASE = 0.000,
  parameter integer CLKOUT6_DIVIDE = 1,
  parameter real CLKOUT6_DUTY_CYCLE = 0.500,
  parameter real CLKOUT6_PHASE = 0.000,
  parameter integer DIVCLK_DIVIDE = 1,
  parameter real REF_JITTER1 = 0.010,
  parameter STARTUP_WAIT = "FALSE"
) (
  output CLKFBOUT,
  output CLKFBOUTB,
  output CLKOUT0,
  output CLKOUT0B,
  output CLKOUT1,
  output CLKOUT1B,
  output CLKOUT2,
  output CLKOUT2B,
  output CLKOUT3,
  output CLKOUT3B,
  output CLKOUT4,
  output CLKOUT5,
  output CLKOUT6,
  output LOCKED,
  input  CLKFBIN,
  input  CLKIN1,
  input  PWRDWN,
  input  RST
);
  logic div2;
  always_ff @(posedge CLKIN1) begin
    if (RST || PWRDWN)
      div2 <= 1'b0;
    else
      div2 <= ~div2;
  end
  assign CLKOUT0   = div2;
  assign CLKFBOUT  = CLKIN1;
  assign LOCKED    = ~(RST | PWRDWN);
  assign CLKFBOUTB = ~CLKFBOUT;
  assign CLKOUT0B  = ~CLKOUT0;
  assign CLKOUT1   = 1'b0;
  assign CLKOUT1B  = 1'b1;
  assign CLKOUT2   = 1'b0;
  assign CLKOUT2B  = 1'b1;
  assign CLKOUT3   = 1'b0;
  assign CLKOUT3B  = 1'b1;
  assign CLKOUT4   = 1'b0;
  assign CLKOUT5   = 1'b0;
  assign CLKOUT6   = 1'b0;
endmodule

module BUFG (
  input  I,
  output O
);
  assign O = I;
endmodule
