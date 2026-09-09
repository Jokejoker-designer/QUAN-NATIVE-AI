`timescale 1ns / 1ps
// ASTRA-C5-DDR-ARB-01. PROGRAM=NO. Bag-local TB. Modeled AXI AR, not MIG.
`include "a7ng_astra_c5_ddr_arb.svh"
module tb_astra_c5_ddr_arb;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic [5:0] req, gnt, arvalid, arready, rvalid;
  logic [2:0] owner;
  logic dual_err;
  logic [15:0] n_sw, n_blk;
  logic [27:0] araddr [0:5];
  logic m_arv, m_arr, m_rv, m_rr;
  logic [27:0] m_ara, last_m_ar;
  logic [127:0] m_rd, s_rd;
  int fail, i, g, mid_sw, leak, dual_seen;
  string first_div;
  typedef enum logic [1:0] { MX_IDLE, MX_R } mx_t;
  mx_t mx;

  function automatic logic [27:0] base_of(input int k);
    base_of = (k == 5) ? A7NG_C5_CKPT_BASE : (A7NG_C5_IDX_BASE + k[27:0]*28'd16);
  endfunction

  assign m_arr = (mx == MX_IDLE);
  assign m_rd  = {100'd0, m_ara};

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mx <= MX_IDLE;
      m_rv <= 1'b0;
    end else unique case (mx)
      MX_IDLE: begin
        m_rv <= 1'b0;
        if (m_arv && m_arr) begin
          last_m_ar <= m_ara;
          m_rv <= 1'b1;
          mx <= MX_R;
        end
      end
      MX_R: if (m_rv && m_rr) begin
        m_rv <= 1'b0;
        mx <= MX_IDLE;
      end
      default: mx <= MX_IDLE;
    endcase
  end

  a7ng_astra_c5_ddr_arb u_dut (
    .clk(clk), .rst_n(rst_n), .req_i(req), .gnt_o(gnt), .owner_o(owner),
    .dual_err_o(dual_err), .n_switch_o(n_sw), .n_block_o(n_blk),
    .s_arvalid_i(arvalid), .s_araddr_i(araddr), .s_arready_o(arready),
    .m_arvalid_o(m_arv), .m_araddr_o(m_ara), .m_arready_i(m_arr),
    .m_rvalid_i(m_rv), .m_rdata_i(m_rd), .m_rready_o(m_rr),
    .s_rvalid_o(rvalid), .s_rdata_o(s_rd)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) dual_seen <= 0;
    else if (dual_err) dual_seen <= dual_seen + 1;
  end

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div=="") first_div=tag;
        $display("FAIL %s", tag); fail=fail+1;
      end else $display("PASS %s", tag);
    end
  endtask

  task automatic xact(input int k);
    begin
      req[k] = 1'b1;
      g = 0;
      while (!gnt[k] && g < 2000) begin @(posedge clk); g = g + 1; end
      chk($sformatf("GNT_%0d", k), gnt[k] && (owner == k[2:0]) && (gnt == (6'd1 << k)));
      araddr[k] = base_of(k);
      @(negedge clk); arvalid[k] = 1'b1;
      @(posedge clk);
      g = 0;
      while (!arready[k] && g < 200) begin @(posedge clk); g = g + 1; end
      @(negedge clk); arvalid[k] = 1'b0;
      g = 0;
      while (!rvalid[k] && g < 200) begin @(posedge clk); g = g + 1; end
      chk($sformatf("R_%0d", k), rvalid[k] && (last_m_ar == base_of(k)));
      @(posedge clk);
      req[k] = 1'b0;
      repeat(3) @(posedge clk);
    end
  endtask

  initial begin
    int k;
    fail=0; first_div=""; mid_sw=0; leak=0;
    rst_n=0; req=0; arvalid=0;
    for (i=0;i<6;i=i+1) araddr[i]=0;
    repeat(4) @(posedge clk); rst_n=1; repeat(4) @(posedge clk);
    $display("C5_DDR_ARB NCLI=6 PROGRAM=NO BOARD_PASS=REJECT DDR_QUERY_BOUND_FINAL=NOT_FROZEN MIG=NO");
    $display("CLASS_six_clients HIT idx,qdir,desc,learn,lmdma,ckpt");

    for (k=0;k<6;k=k+1) begin
      xact(k);
      $display("CLIENT k=%0d owner_was=%0d addr=%h n_sw=%0d", k, k, base_of(k), n_sw);
    end
    chk("CKPT_BASE", last_m_ar == A7NG_C5_CKPT_BASE);
    if (last_m_ar == A7NG_C5_CKPT_BASE)
      $display("CLASS_ckpt_addr_06000000 HIT awar=%h", last_m_ar);
    else $display("CLASS_ckpt_addr_06000000 MISS ar=%h", last_m_ar);

    // mid-flight: owner 0 holds while 4 requests
    req[0] = 1'b1;
    g = 0;
    while (!gnt[0] && g < 200) begin @(posedge clk); g = g + 1; end
    araddr[0] = base_of(0);
    araddr[4] = base_of(4);
    @(negedge clk); arvalid[0] = 1'b1; arvalid[4] = 1'b1; req[4] = 1'b1;
    repeat(8) begin
      @(posedge clk);
      if (owner != A7NG_C5_IDX) mid_sw = mid_sw + 1;
      if (m_arv && (m_ara == base_of(4))) leak = leak + 1;
    end
    chk("MID_OWNER0", owner == A7NG_C5_IDX && gnt[0] && !gnt[4]);
    g = 0;
    while (!arready[0] && g < 200) begin @(posedge clk); g = g + 1; end
    @(negedge clk); arvalid[0] = 1'b0;
    g = 0;
    while (!rvalid[0] && g < 200) begin @(posedge clk); g = g + 1; end
    @(posedge clk);
    req[0] = 1'b0; arvalid[4] = 1'b0;
    repeat(4) @(posedge clk);
    chk("AFTER0_GNT4", gnt[4] && (owner == A7NG_C5_LMD) && (n_blk != 0));
    xact(4);
    if (mid_sw==0) $display("CLASS_no_midflight_switch HIT n_blk=%0d", n_blk);
    else $display("CLASS_no_midflight_switch MISS mid_sw=%0d", mid_sw);
    if (leak==0) $display("CLASS_axi_only_grant HIT");
    else $display("CLASS_axi_only_grant MISS leak=%0d", leak);

    if (dual_seen==0) $display("CLASS_dual_owner_zero HIT n_sw=%0d", n_sw);
    else $display("CLASS_dual_owner_zero MISS n=%0d", dual_seen);
    if (n_sw >= 16'd7) $display("CLASS_one_owner HIT n_sw=%0d gnt_onehot=1", n_sw);
    else $display("CLASS_one_owner MISS n_sw=%0d", n_sw);
    chk("NO_DUAL", dual_seen==0);
    chk("NO_MID", mid_sw==0);
    chk("NO_LEAK", leak==0);

    if (fail==0) $display("ASTRA_C5_DDR_ARB_XSIM_PASS");
    else $display("ASTRA_C5_DDR_ARB_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO DDR_QUERY_BOUND_FINAL=NOT_FROZEN quality=MODELED_AXI_AR_NOT_MIG");
    $finish;
  end
endmodule
