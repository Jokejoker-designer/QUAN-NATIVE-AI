`ifndef A7NG_ASTRA_C4_LM06_BYTE256_ARLANG_SVH
`define A7NG_ASTRA_C4_LM06_BYTE256_ARLANG_SVH
// ASTRA-C4-LM06-BYTE256-ARLANG-01. PROGRAM=NO.
// Compact BYTE256 autoreg head. New bag-local checkpoint. Not TinyGPT.
// Does not freeze LM06_BYTE256. Does not overwrite a7lm06_wmem.hex.
localparam int unsigned A7NG_C4L_D          = 32;
localparam int unsigned A7NG_C4L_CTX        = 7;
localparam int unsigned A7NG_C4L_MAX_TOKENS = 8;
localparam int unsigned A7NG_C4L_W_E        = 8192;
localparam int unsigned A7NG_C4L_W_B        = 256;
localparam int unsigned A7NG_C4L_W_N        = 8472;
localparam logic [7:0]  A7NG_C4L_EOS        = 8'd0;
localparam logic [7:0]  A7NG_C4L_Y          = 8'd121;
localparam logic [7:0]  A7NG_C4L_E          = 8'd101;
localparam logic [7:0]  A7NG_C4L_S          = 8'd115;
localparam logic [3:0]  A7NG_C4L_VOCAB_VER  = 4'd5;
localparam logic [1:0]  A7NG_C4L_LD_SCALE   = 2'd0;
localparam logic [1:0]  A7NG_C4L_LD_ZERO    = 2'd1;
localparam int unsigned A7NG_C4L_SHIFT      = 8;

function automatic logic [7:0] a7ng_c4l_ch(input logic [7:0] id, input int unsigned pos);
  begin
    unique case (pos)
      0: a7ng_c4l_ch = 8'h41 + (id % 8'd26);
      1: a7ng_c4l_ch = 8'h61 + 8'((32'(id) * 32'd5) % 32'd26);
      2: a7ng_c4l_ch = 8'h30 + (id % 8'd10);
      default: a7ng_c4l_ch = A7NG_C4L_EOS;
    endcase
  end
endfunction
`endif
