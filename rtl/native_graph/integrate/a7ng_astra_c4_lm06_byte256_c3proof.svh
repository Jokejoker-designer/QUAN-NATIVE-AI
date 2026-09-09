`ifndef A7NG_ASTRA_C4_LM06_BYTE256_C3PROOF_SVH
`define A7NG_ASTRA_C4_LM06_BYTE256_C3PROOF_SVH
// ASTRA-C4-LM06-BYTE256-C3PROOF-01. PROGRAM=NO.
// FPGA-visible dest-name image for C3 ANSWER IDs. Not TinyGPT. Not compose.
localparam int unsigned A7NG_C4P_NAME_N     = 3;
localparam logic [7:0]  A7NG_C4P_EOS        = 8'd0;
localparam logic [3:0]  A7NG_C4P_VOCAB_VER  = 4'd3;

function automatic logic [7:0] a7ng_c4p_ch(input logic [7:0] id, input int unsigned pos);
  begin
    unique case (pos)
      0: a7ng_c4p_ch = 8'h41 + (id % 8'd26);
      1: a7ng_c4p_ch = 8'h61 + 8'((32'(id) * 32'd5) % 32'd26);
      2: a7ng_c4p_ch = 8'h30 + (id % 8'd10);
      default: a7ng_c4p_ch = A7NG_C4P_EOS;
    endcase
  end
endfunction
`endif
