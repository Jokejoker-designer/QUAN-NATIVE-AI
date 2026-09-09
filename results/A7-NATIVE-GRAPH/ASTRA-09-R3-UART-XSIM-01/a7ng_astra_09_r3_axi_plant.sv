// a7ng_astra_09_r3_axi_plant.sv — ASTRA-09-R3-UART-XSIM-01. PROGRAM=NO.
// Bag-local behavioral AXI plant. Not silicon BRAM. Not a7ng_axi_bram128 edit.
`timescale 1ns / 1ps

module a7ng_astra_09_r3_axi_plant (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [1:0]  plant_sel,
  input  logic [3:0]  s_axi_arid,
  input  logic [27:0] s_axi_araddr,
  input  logic [7:0]  s_axi_arlen,
  input  logic [2:0]  s_axi_arsize,
  input  logic [1:0]  s_axi_arburst,
  input  logic        s_axi_arvalid,
  output logic        s_axi_arready,
  output logic [3:0]  s_axi_rid,
  output logic [127:0] s_axi_rdata,
  output logic [1:0]  s_axi_rresp,
  output logic        s_axi_rlast,
  output logic        s_axi_rvalid,
  input  logic        s_axi_rready
);
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000;
  localparam logic [27:0] POST_HEAP  = 28'h0504_0000;
  localparam logic [27:0] FACT_BASE  = 28'h0580_0000;
  localparam logic [1:0]  PLANT_SMOKE = 2'd1;
  localparam logic [1:0]  PLANT_OVF   = 2'd2;

  typedef enum logic [1:0] { M_IDLE, M_BEAT } mst_t;
  mst_t mst;
  logic [7:0]  rem;
  logic [27:0] ra;

  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl * 65536 + (key & 12'hFFF) * 16;
  endfunction
  function automatic logic [127:0] dir_pack(input int count);
    dir_pack = {48'd0, 16'd7, 16'd0, count[15:0], 4'd0, POST_HEAP};
  endfunction
  function automatic logic [127:0] fact_pack(
      input int s, o, r, e, conf, trans, pol, fctx);
    fact_pack = {28'd0, conf[7:0], fctx[7:0], 4'd1, 1'b0, 1'b1, pol[0], trans[0],
                 e[19:0], r[7:0], o[19:0], s[19:0]};
  endfunction
  function automatic logic [127:0] post_beat(
      input int a, input int b, input int c, input int d);
    post_beat = {d[31:0], c[31:0], b[31:0], a[31:0]};
  endfunction
  function automatic logic [27:0] fact_addr(input int id);
    fact_addr = FACT_BASE + (id << 4);
  endfunction

  function automatic logic [127:0] mem_rd(input logic [27:0] a);
    logic [127:0] d;
    int id;
    begin
      d = 128'd0;
      if ((plant_sel == PLANT_SMOKE) || (plant_sel == PLANT_OVF)) begin
        if ((a == dir_addr(0, 2562)) || (a == dir_addr(2, 766)))
          d = dir_pack((plant_sel == PLANT_OVF) ? 20 : 4);
        else if (a == POST_HEAP)
          d = post_beat(17, 34, 18, 35);
        else if (a == fact_addr(17))
          d = fact_pack(10, 1, 2, 17, 200, 1, 1, 0);
        else if (a == fact_addr(34))
          d = fact_pack(1, 4, 2, 34, 200, 1, 1, 0);
        else if (a == fact_addr(18))
          d = fact_pack(10, 8, 2, 18, 8, 1, 1, 0);
        else if (a == fact_addr(35))
          d = fact_pack(8, 4, 2, 35, 8, 1, 1, 0);
        if (plant_sel == PLANT_OVF) begin
          if (a == (POST_HEAP + 28'd16))
            d = post_beat(100, 101, 102, 103);
          else if (a == (POST_HEAP + 28'd32))
            d = post_beat(104, 105, 106, 107);
          else if (a == (POST_HEAP + 28'd48))
            d = post_beat(108, 109, 110, 111);
          else if (a == (POST_HEAP + 28'd64))
            d = post_beat(112, 113, 114, 115);
          for (id = 100; id <= 115; id = id + 1)
            if (a == fact_addr(id))
              d = fact_pack(99, 98, 2, id, 8, 1, 1, 0);
        end
      end
      mem_rd = d;
    end
  endfunction

  assign s_axi_arready = (mst == M_IDLE);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mst <= M_IDLE;
      s_axi_rvalid <= 1'b0;
      s_axi_rlast <= 1'b0;
      s_axi_rdata <= 128'd0;
      s_axi_rid <= 4'd0;
      s_axi_rresp <= 2'b00;
      rem <= 8'd0;
      ra <= 28'd0;
    end else unique case (mst)
      M_IDLE: if (s_axi_arvalid && s_axi_arready) begin
        ra <= s_axi_araddr;
        rem <= s_axi_arlen;
        s_axi_rid <= s_axi_arid;
        s_axi_rresp <= 2'b00;
        s_axi_rlast <= (s_axi_arlen == 8'd0);
        s_axi_rvalid <= 1'b1;
        s_axi_rdata <= mem_rd(s_axi_araddr);
        mst <= M_BEAT;
      end
      M_BEAT: if (s_axi_rvalid && s_axi_rready) begin
        if (s_axi_rlast) begin
          s_axi_rvalid <= 1'b0;
          mst <= M_IDLE;
        end else begin
          s_axi_rdata <= mem_rd(ra + 28'd16);
          ra <= ra + 28'd16;
          s_axi_rlast <= (rem == 8'd1);
          rem <= rem - 8'd1;
        end
      end
    endcase
  end
endmodule
