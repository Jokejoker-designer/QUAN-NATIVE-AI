`ifndef A7NG_ASTRA_C4_LM06_802K_GROUNDED_SVH
`define A7NG_ASTRA_C4_LM06_802K_GROUNDED_SVH
// ASTRA-C4-LM06-802K-GROUNDED-01. PROGRAM=NO.
// TinyGPT-802k + BYTE256 mask. Does not edit frozen tiny_gpt803k_core / a7lm06_pkg.
// Does not freeze LM06_BYTE256. Not compose renderer. Not C4_MASTER.
localparam int unsigned A7NG_C4K_MAX_TOKENS = 2;
localparam logic [7:0]  A7NG_C4K_EOS        = 8'd0;
localparam logic [7:0]  A7NG_C4K_QMARK      = 8'h51;
localparam logic [7:0]  A7NG_C4K_PMARK      = 8'h50;
`endif
