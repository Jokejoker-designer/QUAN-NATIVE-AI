`ifndef A7NG_C4_MAT_GOLDEN_SVH
`define A7NG_C4_MAT_GOLDEN_SVH
localparam int A7NG_C4_MAT_N = 6;
localparam logic A7NG_C4_MAT_R [0:A7NG_C4_MAT_N-1] = '{0, 1, 0, 0, 0, 1};
localparam logic A7NG_C4_MAT_SO [0:A7NG_C4_MAT_N-1] = '{0, 0, 0, 0, 1, 0};
localparam logic A7NG_C4_MAT_DO [0:A7NG_C4_MAT_N-1] = '{0, 0, 0, 0, 0, 0};
localparam logic [31:0] A7NG_C4_MAT_SRC [0:A7NG_C4_MAT_N-1] = '{32'h65736f68, 32'h65736f68, 32'h746e6576, 32'h65736f68, 32'h65736f68, 32'h746c6f62};
localparam logic [31:0] A7NG_C4_MAT_DST [0:A7NG_C4_MAT_N-1] = '{32'h6d757264, 32'h6d757264, 32'h6d757264, 32'h746e6576, 32'h6d757264, 32'h6b6e6174};
localparam logic [7:0] A7NG_C4_MAT_CTX [0:A7NG_C4_MAT_N-1][0:15] = '{
  '{8'd70, 8'd32, 8'd100, 8'd114, 8'd117, 8'd109, 8'd32, 8'd104, 8'd111, 8'd115, 8'd101, 8'd62, 8'd100, 8'd114, 8'd117, 8'd109},  // F drum hose>drum
  '{8'd82, 8'd32, 8'd104, 8'd111, 8'd115, 8'd101, 8'd32, 8'd104, 8'd111, 8'd115, 8'd101, 8'd62, 8'd100, 8'd114, 8'd117, 8'd109},  // R hose hose>drum
  '{8'd70, 8'd32, 8'd100, 8'd114, 8'd117, 8'd109, 8'd32, 8'd118, 8'd101, 8'd110, 8'd116, 8'd62, 8'd100, 8'd114, 8'd117, 8'd109},  // F drum vent>drum
  '{8'd70, 8'd32, 8'd118, 8'd101, 8'd110, 8'd116, 8'd32, 8'd104, 8'd111, 8'd115, 8'd101, 8'd62, 8'd118, 8'd101, 8'd110, 8'd116},  // F vent hose>vent
  '{8'd70, 8'd32, 8'd100, 8'd114, 8'd117, 8'd109, 8'd32, 8'd63, 8'd63, 8'd63, 8'd63, 8'd62, 8'd100, 8'd114, 8'd117, 8'd109},  // F drum ????>drum
  '{8'd82, 8'd32, 8'd98, 8'd111, 8'd108, 8'd116, 8'd32, 8'd98, 8'd111, 8'd108, 8'd116, 8'd62, 8'd116, 8'd97, 8'd110, 8'd107}  // R bolt bolt>tank
};
`endif
