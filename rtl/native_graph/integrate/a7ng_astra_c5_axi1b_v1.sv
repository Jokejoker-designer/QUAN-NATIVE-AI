// a7ng_astra_c5_axi1b_v1.sv — AXI RRESP/RID/RLAST adapter. PROGRAM=NO.
// Standalone extract of the resp-lane 1-beat adapter. Does not fabricate OKAY.
`timescale 1ns / 1ps
`include "a7ng_astra_c5_ddr_arb.svh"
`include "a7ng_astra_c5_prod_top_final_v1.svh"

module a7ng_astra_c5_axi1b_v1 (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [3:0]  s_arid,
  input  logic [27:0] s_araddr,
  input  logic [7:0]  s_arlen,
  input  logic        s_arvalid,
  output logic        s_arready,
  output logic [3:0]  s_rid,
  output logic [127:0] s_rdata,
  output logic [1:0]  s_rresp,
  output logic        s_rlast,
  output logic        s_rvalid,
  input  logic        s_rready,
  output logic        req_o,
  output logic        arvalid_o,
  output logic [27:0] araddr_o,
  input  logic        arready_i,
  input  logic        rvalid_i,
  input  logic [127:0] rdata_i,
  input  logic [1:0]  rresp_i,
  input  logic        rlast_i,
  input  logic [3:0]  rid_i,
  output logic        rready_o,
  output logic [2:0]  cli_o
);
  typedef enum logic [1:0] { S_IDLE, S_AR, S_R, S_HOLD } st_t;
  st_t st;
  logic [27:0] addr;
  logic [7:0]  rem;
  logic [3:0]  id;
  logic [2:0]  cli;
  logic [127:0] bufd;
  logic [1:0]  bufr;
  logic [3:0]  bufrid;
  logic last_q;
  logic mig_got;

  assign cli_o = cli;
  assign req_o = (st != S_IDLE);
  assign arvalid_o = (st == S_AR) && !mig_got;
  assign araddr_o = addr;
  assign s_arready = (st == S_AR) && mig_got;
  assign rready_o = (st == S_R) || ((st == S_AR) && !mig_got && rvalid_i);
  assign s_rid = bufrid;
  assign s_rdata = bufd;
  assign s_rresp = bufr;
  assign s_rlast = last_q;
  assign s_rvalid = (st == S_HOLD);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      addr <= 28'd0;
      rem <= 8'd0;
      id <= 4'd0;
      cli <= A7NG_C5_QDIR;
      bufd <= 128'd0;
      bufr <= 2'b00;
      bufrid <= 4'd0;
      last_q <= 1'b0;
      mig_got <= 1'b0;
    end else unique case (st)
      S_IDLE: begin
        mig_got <= 1'b0;
        if (s_arvalid) begin
          addr <= s_araddr;
          rem <= s_arlen;
          id <= s_arid;
          cli <= (s_araddr >= A7NG_C5P_FACT_BASE) ? A7NG_C5_DESC : A7NG_C5_QDIR;
          st <= S_AR;
        end
      end
      S_AR: begin
        if (!mig_got) begin
          if (arready_i) mig_got <= 1'b1;
        end else if (!s_arvalid) begin
          st <= S_R;
        end
      end
      S_R: begin
        if (rvalid_i) begin
          bufd <= rdata_i;
          bufr <= rresp_i;
          last_q <= rlast_i;
          bufrid <= rid_i;
          st <= S_HOLD;
        end
      end
      S_HOLD: begin
        if (s_rready) begin
          if (rem == 8'd0) st <= S_IDLE;
          else begin
            rem <= rem - 8'd1;
            addr <= addr + 28'd16;
            mig_got <= 1'b0;
            st <= S_AR;
          end
        end
      end
      default: st <= S_IDLE;
    endcase
  end
endmodule
