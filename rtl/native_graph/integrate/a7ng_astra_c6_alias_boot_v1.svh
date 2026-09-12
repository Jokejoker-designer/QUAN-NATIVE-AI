`ifndef A7NG_ASTRA_C6_ALIAS_BOOT_V1_SVH
`define A7NG_ASTRA_C6_ALIAS_BOOT_V1_SVH
// Generated. PROGRAM=NO. Do not hand-edit; run gen_alias_boot_svh.py.
localparam int unsigned A7NG_C6_ALIAS_N = 8;
localparam logic [31:0] A7NG_C6_ALIAS_CRC32 = 32'h32cb9f27;
localparam logic [19:0] A7NG_C6_ALIAS_KEY [0:A7NG_C6_ALIAS_N-1] = '{
20'h0000a, 20'h0000b, 20'h00000, 20'h00000, 20'h00000, 20'h00000, 20'h00000, 20'h00000};
localparam logic [31:0] A7NG_C6_ALIAS_SYM [0:A7NG_C6_ALIAS_N-1] = '{
32'h68676d76, 32'h68666974, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000};
localparam logic A7NG_C6_ALIAS_VALID [0:A7NG_C6_ALIAS_N-1] = '{
1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
localparam logic A7NG_C6_ALIAS_OVF [0:A7NG_C6_ALIAS_N-1] = '{
1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
// image_sha256 4b4516d81722dd6e99f36a07367de151fdd04d4ce84e137b558a80b5d7323e9e
`endif
