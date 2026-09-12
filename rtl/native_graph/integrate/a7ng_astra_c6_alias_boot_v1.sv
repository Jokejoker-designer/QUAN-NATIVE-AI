// a7ng_astra_c6_alias_boot_v1.sv — FPGA-owned CAM fill after C5 reset.
// PROGRAM=NO. Not D32. Not E3ab. Not BOARD_PASS.
`timescale 1ns / 1ps
`include "a7ng_astra_c6_alias_boot_v1.svh"

module a7ng_astra_c6_alias_boot_v1 (
  input  logic        clk,
  input  logic        rst_n,
  output logic        wr_v_o,
  output logic [2:0]  wr_idx_o,
  output logic [19:0] wr_key_o,
  output logic [31:0] wr_sym_o,
  output logic        wr_ovf_o,
  output logic        dict_lock_o
);
  typedef enum logic [1:0] { ST_FILL, ST_LOCK } st_t;
  st_t st;
  logic [2:0] idx;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= ST_FILL;
      idx <= 3'd0;
      wr_v_o <= 1'b0;
      wr_idx_o <= 3'd0;
      wr_key_o <= 20'd0;
      wr_sym_o <= 32'd0;
      wr_ovf_o <= 1'b0;
      dict_lock_o <= 1'b0;
    end else begin
      wr_v_o <= 1'b0;
      unique case (st)
        ST_FILL: begin
          wr_v_o <= A7NG_C6_ALIAS_VALID[idx];
          wr_idx_o <= idx;
          wr_key_o <= A7NG_C6_ALIAS_KEY[idx];
          wr_sym_o <= A7NG_C6_ALIAS_SYM[idx];
          wr_ovf_o <= A7NG_C6_ALIAS_OVF[idx];
          if (idx == 3'(A7NG_C6_ALIAS_N - 1))
            st <= ST_LOCK;
          else
            idx <= idx + 3'd1;
        end
        ST_LOCK: begin
          dict_lock_o <= 1'b1;
          wr_v_o <= 1'b0;
        end
        default: begin
          dict_lock_o <= 1'b1;
          wr_v_o <= 1'b0;
        end
      endcase
    end
  end
endmodule
