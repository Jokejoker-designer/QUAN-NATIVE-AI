`ifndef A7NG_ASTRA_C4_LM06_BYTE256_DICT_SVH
`define A7NG_ASTRA_C4_LM06_BYTE256_DICT_SVH
// ASTRA-C4-LM06-BYTE256-DICT-HELDOUT-01. PROGRAM=NO.
// FPGA-visible BYTE256 dictionary + QUERY/PROOF materializer + compact copy head.
// Does not freeze LM06_BYTE256. Not TinyGPT-802k. Not compose renderer.
localparam int unsigned A7NG_C4D_NAME_N     = 3;
localparam int unsigned A7NG_C4D_MAX_TOKENS = 8;
localparam logic [7:0]  A7NG_C4D_EOS        = 8'd0;
localparam logic [7:0]  A7NG_C4D_MARK_Q     = 8'h51;
localparam logic [7:0]  A7NG_C4D_MARK_R     = 8'h52;
localparam logic [7:0]  A7NG_C4D_MARK_P     = 8'h50;
localparam logic [3:0]  A7NG_C4D_VOCAB_VER  = 4'd1;
localparam logic [1:0]  A7NG_C4D_LD_COPY    = 2'd1;
localparam logic [1:0]  A7NG_C4D_LD_SAFE    = 2'd2;
localparam logic [1:0]  A7NG_C4D_LD_EOS     = 2'd3;

function automatic logic [7:0] a7ng_c4d_ch(input logic [7:0] id, input int unsigned pos);
  begin
    unique case (pos)
      0: a7ng_c4d_ch = 8'h41 + (id % 8'd26);
      1: a7ng_c4d_ch = 8'h61 + 8'((32'(id) * 32'd5) % 32'd26);
      2: a7ng_c4d_ch = 8'h30 + (id % 8'd10);
      default: a7ng_c4d_ch = A7NG_C4D_EOS;
    endcase
  end
endfunction
`endif
