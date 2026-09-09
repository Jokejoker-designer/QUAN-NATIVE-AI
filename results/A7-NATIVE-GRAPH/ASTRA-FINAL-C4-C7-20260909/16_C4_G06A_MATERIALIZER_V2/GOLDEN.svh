`ifndef A7NG_C4_MAT2_GOLDEN_SVH
`define A7NG_C4_MAT2_GOLDEN_SVH
localparam int A7NG_C4_MAT2_N = 6;
localparam logic A7NG_C4_MAT2_R [0:A7NG_C4_MAT2_N-1] = '{0, 1, 1, 1, 0, 0};
localparam logic [7:0] A7NG_C4_MAT2_SID [0:A7NG_C4_MAT2_N-1] = '{8'd1, 8'd1, 8'd3, 8'd4, 8'd1, 8'd9};
localparam logic [7:0] A7NG_C4_MAT2_DID [0:A7NG_C4_MAT2_N-1] = '{8'd2, 8'd2, 8'd2, 8'd2, 8'd2, 8'd2};
localparam logic [7:0] A7NG_C4_MAT2_CTX [0:A7NG_C4_MAT2_N-1][0:15] = '{
  '{8'd70, 8'd32, 8'd100, 8'd114, 8'd117, 8'd109, 8'd32, 8'd104, 8'd111, 8'd115, 8'd101, 8'd62, 8'd45, 8'd45, 8'd45, 8'd45},  // F drum hose>----
  '{8'd82, 8'd32, 8'd100, 8'd114, 8'd117, 8'd109, 8'd32, 8'd104, 8'd111, 8'd115, 8'd101, 8'd62, 8'd45, 8'd45, 8'd45, 8'd45},  // R drum hose>----
  '{8'd82, 8'd32, 8'd98, 8'd111, 8'd108, 8'd116, 8'd32, 8'd104, 8'd111, 8'd115, 8'd101, 8'd62, 8'd45, 8'd45, 8'd45, 8'd45},  // R bolt hose>----
  '{8'd82, 8'd32, 8'd118, 8'd101, 8'd110, 8'd116, 8'd32, 8'd104, 8'd111, 8'd115, 8'd101, 8'd62, 8'd45, 8'd45, 8'd45, 8'd45},  // R vent hose>----
  '{8'd70, 8'd32, 8'd100, 8'd114, 8'd117, 8'd109, 8'd32, 8'd104, 8'd111, 8'd115, 8'd101, 8'd62, 8'd45, 8'd45, 8'd45, 8'd45},  // F drum hose>----
  '{8'd70, 8'd32, 8'd63, 8'd63, 8'd63, 8'd63, 8'd32, 8'd104, 8'd111, 8'd115, 8'd101, 8'd62, 8'd45, 8'd45, 8'd45, 8'd45}  // F ???? hose>----
};
`endif
