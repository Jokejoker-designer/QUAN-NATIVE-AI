// a7ng_axi_rtp_plant128.sv — SOC_RTP_GLUE planted index+desc. PROGRAM=NO.
// Read-only AXI4 128-bit slave. INIT holds R1 BASE dir/post/facts (rtp-desc-v1).
// fill_i=0 returns zeros (empty-index control). Not load_v. No MIG.
`timescale 1ns / 1ps

module a7ng_axi_rtp_plant128 #(
  parameter int unsigned CAM_N = 16
) (
  input  logic         clk,
  input  logic         rst_n,
  input  logic         fill_i,
  input  logic [3:0]   s_axi_awid,
  input  logic [27:0]  s_axi_awaddr,
  input  logic [7:0]   s_axi_awlen,
  input  logic [2:0]   s_axi_awsize,
  input  logic [1:0]   s_axi_awburst,
  input  logic         s_axi_awvalid,
  output logic         s_axi_awready,
  input  logic [127:0] s_axi_wdata,
  input  logic [15:0]  s_axi_wstrb,
  input  logic         s_axi_wlast,
  input  logic         s_axi_wvalid,
  output logic         s_axi_wready,
  output logic [3:0]   s_axi_bid,
  output logic [1:0]   s_axi_bresp,
  output logic         s_axi_bvalid,
  input  logic         s_axi_bready,
  input  logic [3:0]   s_axi_arid,
  input  logic [27:0]  s_axi_araddr,
  input  logic [7:0]   s_axi_arlen,
  input  logic [2:0]   s_axi_arsize,
  input  logic [1:0]   s_axi_arburst,
  input  logic         s_axi_arvalid,
  output logic         s_axi_arready,
  output logic [3:0]   s_axi_rid,
  output logic [127:0] s_axi_rdata,
  output logic [1:0]   s_axi_rresp,
  output logic         s_axi_rlast,
  output logic         s_axi_rvalid,
  input  logic         s_axi_rready
);
  localparam logic [127:0] DIR_BEAT =
      128'h0000_0000_0000_0007_0000_0002_0504_0000;
  localparam logic [127:0] POST_BEAT =
      128'h0000_0000_0000_0000_0000_0022_0000_0011;
  localparam logic [127:0] FACT17 =
      128'h0000_0000_0000_0170_0011_0200_0010_000A;
  localparam logic [127:0] FACT34 =
      128'h0000_0000_0000_0170_0022_0200_0040_0001;

  typedef enum logic [1:0] { R_IDLE, R_ISSUE, R_BEAT } rst_t;
  typedef enum logic [1:0] { W_IDLE, W_DATA, W_RESP } wst_t;
  rst_t r_st;
  wst_t w_st;

  logic [27:0] r_addr, w_addr;
  logic [7:0]  r_left, w_left;
  logic [3:0]  r_id, w_id;
  logic [1:0]  r_burst, w_burst;
  logic [127:0] r_q;
  logic         we;

  logic [27:0]  cam_a [0:CAM_N-1];
  logic [127:0] cam_d [0:CAM_N-1];
  logic         cam_v [0:CAM_N-1];
  integer       ci;

  function automatic logic [27:0] align16(input logic [27:0] a);
    return {a[27:4], 4'd0};
  endfunction

  function automatic logic [27:0] next_addr(
      input logic [27:0] a, input logic [1:0] burst);
    if (burst == 2'b01)
      return a + 28'd16;
    return a;
  endfunction

  function automatic logic [127:0] rom_of(input logic [27:0] a);
    logic [27:0] w;
    w = align16(a);
    unique case (w)
      28'h0500A020: return DIR_BEAT;
      28'h05010020: return DIR_BEAT;
      28'h05022FE0: return DIR_BEAT;
      28'h05030000: return DIR_BEAT;
      28'h05040000: return POST_BEAT;
      28'h05800110: return FACT17;
      28'h05800220: return FACT34;
      default:      return 128'd0;
    endcase
  endfunction

  logic [127:0] r_lookup;
  integer       rk;

  always_comb begin
    r_lookup = fill_i ? rom_of(r_addr) : 128'd0;
    for (rk = 0; rk < CAM_N; rk = rk + 1)
      if (cam_v[rk] && (cam_a[rk] == align16(r_addr)))
        r_lookup = cam_d[rk];
  end

  assign s_axi_rresp = 2'b00;
  assign s_axi_bresp = 2'b00;
  assign we = (w_st == W_DATA) && s_axi_wvalid && s_axi_wready;

  always_ff @(posedge clk) begin
    r_q <= r_lookup;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (ci = 0; ci < CAM_N; ci = ci + 1) begin
        cam_v[ci] <= 1'b0;
        cam_a[ci] <= '0;
        cam_d[ci] <= '0;
      end
    end else if (we) begin
      cam_v[0] <= 1'b1;
      cam_a[0] <= align16(w_addr);
      cam_d[0] <= s_axi_wdata;
      for (ci = 1; ci < CAM_N; ci = ci + 1) begin
        cam_v[ci] <= cam_v[ci-1];
        cam_a[ci] <= cam_a[ci-1];
        cam_d[ci] <= cam_d[ci-1];
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      r_st <= R_IDLE;
      s_axi_arready <= 1'b1;
      s_axi_rvalid  <= 1'b0;
      s_axi_rlast   <= 1'b0;
      s_axi_rdata   <= '0;
      s_axi_rid     <= '0;
      r_addr <= '0;
      r_left <= '0;
      r_id <= '0;
      r_burst <= 2'b01;
    end else begin
      unique case (r_st)
        R_IDLE: begin
          s_axi_arready <= 1'b1;
          s_axi_rvalid  <= 1'b0;
          s_axi_rlast   <= 1'b0;
          if (s_axi_arvalid && s_axi_arready) begin
            r_addr  <= s_axi_araddr;
            r_left  <= s_axi_arlen;
            r_id    <= s_axi_arid;
            r_burst <= s_axi_arburst;
            s_axi_arready <= 1'b0;
            r_st <= R_ISSUE;
          end
        end
        R_ISSUE: begin
          s_axi_arready <= 1'b0;
          s_axi_rvalid  <= 1'b0;
          r_st <= R_BEAT;
        end
        R_BEAT: begin
          s_axi_rvalid <= 1'b1;
          s_axi_rdata  <= r_q;
          s_axi_rid    <= r_id;
          s_axi_rlast  <= (r_left == 8'd0);
          if (s_axi_rvalid && s_axi_rready) begin
            s_axi_rvalid <= 1'b0;
            if (r_left == 8'd0) begin
              s_axi_rlast   <= 1'b0;
              s_axi_arready <= 1'b1;
              r_st <= R_IDLE;
            end else begin
              r_left <= r_left - 8'd1;
              r_addr <= next_addr(r_addr, r_burst);
              r_st <= R_ISSUE;
            end
          end
        end
        default: r_st <= R_IDLE;
      endcase
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      w_st <= W_IDLE;
      s_axi_awready <= 1'b1;
      s_axi_wready  <= 1'b0;
      s_axi_bvalid  <= 1'b0;
      s_axi_bid     <= '0;
      w_addr <= '0;
      w_left <= '0;
      w_id <= '0;
      w_burst <= 2'b01;
    end else begin
      unique case (w_st)
        W_IDLE: begin
          s_axi_awready <= 1'b1;
          s_axi_wready  <= 1'b0;
          s_axi_bvalid  <= 1'b0;
          if (s_axi_awvalid && s_axi_awready) begin
            w_addr  <= s_axi_awaddr;
            w_left  <= s_axi_awlen;
            w_id    <= s_axi_awid;
            w_burst <= s_axi_awburst;
            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b1;
            w_st <= W_DATA;
          end
        end
        W_DATA: begin
          if (s_axi_wvalid && s_axi_wready) begin
            if (s_axi_wlast || (w_left == 8'd0)) begin
              s_axi_wready <= 1'b0;
              s_axi_bid    <= w_id;
              s_axi_bvalid <= 1'b1;
              w_st <= W_RESP;
            end else begin
              w_left <= w_left - 8'd1;
              w_addr <= next_addr(w_addr, w_burst);
            end
          end
        end
        W_RESP: begin
          if (s_axi_bvalid && s_axi_bready) begin
            s_axi_bvalid  <= 1'b0;
            s_axi_awready <= 1'b1;
            w_st <= W_IDLE;
          end
        end
        default: w_st <= W_IDLE;
      endcase
    end
  end
endmodule
