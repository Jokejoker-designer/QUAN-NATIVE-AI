// WRAP-XSIM TB. PROGRAM=NO. Wrap-equivalent r2 + axi_bram128. UART/MMCM not in this TB.
`timescale 1ns / 1ps

module tb_astra_soc_rtp_wrap;
  localparam int CLK_NS = 20;
  localparam int EPOCH  = 7;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000;
  localparam logic [27:0] FACT_BASE  = 28'h0580_0000;

  logic clk, rst_n, fill;
  initial clk = 0;
  always #(CLK_NS/2) clk = ~clk;

  logic tok_v, tok_r, fire, retire, busy, result_v, tb_load;
  logic [7:0] tok, subj, obj, rel, ctx, ncand, nload;
  logic [19:0] ans, p0, p1;
  logic [3:0] st;
  logic [15:0] nfar, nfok, nferr, nfto, narto, ndir, nhost;
  logic ovf, neg, amb;
  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst;
  logic arvalid, arready, rready, rlast, rvalid;
  logic [3:0] rid; logic [127:0] rdata; logic [1:0] rresp;
  integer fail, n_ar, n_r;

  logic arready_p, arready_e, rvalid_p, rvalid_e, rlast_p, rlast_e;
  logic [3:0] rid_p, rid_e;
  logic [127:0] rdata_p, rdata_e;
  logic [1:0] rresp_p, rresp_e;

  always @(posedge clk) begin
    if (arvalid && arready) begin
      n_ar = n_ar + 1;
      $display("AR n=%0d addr=%h arid=%0d len=%0d t=%0t", n_ar, araddr, arid, arlen, $time);
    end
    if (rvalid && rready) begin
      n_r = n_r + 1;
      $display("R  n=%0d data=%h rid=%0d last=%0d t=%0t", n_r, rdata, rid, rlast, $time);
    end
  end

  a7ng_astra_rtp_pipe_r2 #(
    .N_EDGES(16), .ID_W(20), .WALK_ID_W(20), .CAND_CAP(16),
    .INDEX_BASE(INDEX_BASE), .FACT_BASE(FACT_BASE)
  ) u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(EPOCH[15:0]),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .busy_o(busy), .result_v_o(result_v),
    .subj_id_o(subj), .obj_id_o(obj), .rel_id_o(rel), .ctx_id_o(ctx),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1), .status_o(st),
    .n_cand_o(ncand), .n_load_o(nload),
    .n_fact_ar_o(nfar), .n_fact_ok_o(nfok), .n_fact_err_o(nferr),
    .n_fact_to_o(nfto), .n_ar_to_o(narto),
    .n_dir_ar_o(ndir), .n_host_any_o(nhost),
    .ovf_o(ovf), .neg_o(neg), .amb_o(amb), .load_from_tb_o(tb_load),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  assign arready = fill ? arready_p : arready_e;
  assign rvalid  = fill ? rvalid_p  : rvalid_e;
  assign rlast   = fill ? rlast_p   : rlast_e;
  assign rid     = fill ? rid_p     : rid_e;
  assign rdata   = fill ? rdata_p   : rdata_e;
  assign rresp   = fill ? rresp_p   : rresp_e;

  a7ng_axi_bram128 #(
    .DEPTH_WORDS(256), .INDEX_BASE(INDEX_BASE), .PLANT_R2_BASE(1'b1)
  ) u_sram_plant (
    .clk(clk), .rst_n(rst_n),
    .s_axi_awid(4'd0), .s_axi_awaddr(28'd0), .s_axi_awlen(8'd0),
    .s_axi_awsize(3'd4), .s_axi_awburst(2'b01),
    .s_axi_awvalid(1'b0), .s_axi_awready(),
    .s_axi_wdata(128'd0), .s_axi_wstrb(16'd0), .s_axi_wlast(1'b0),
    .s_axi_wvalid(1'b0), .s_axi_wready(),
    .s_axi_bid(), .s_axi_bresp(), .s_axi_bvalid(), .s_axi_bready(1'b1),
    .s_axi_arid(arid), .s_axi_araddr(araddr), .s_axi_arlen(arlen),
    .s_axi_arsize(arsize), .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid && fill), .s_axi_arready(arready_p),
    .s_axi_rid(rid_p), .s_axi_rdata(rdata_p), .s_axi_rresp(rresp_p),
    .s_axi_rlast(rlast_p), .s_axi_rvalid(rvalid_p), .s_axi_rready(rready)
  );

  a7ng_axi_bram128 #(
    .DEPTH_WORDS(256), .INDEX_BASE(INDEX_BASE), .PLANT_R2_BASE(1'b0)
  ) u_sram_empty (
    .clk(clk), .rst_n(rst_n),
    .s_axi_awid(4'd0), .s_axi_awaddr(28'd0), .s_axi_awlen(8'd0),
    .s_axi_awsize(3'd4), .s_axi_awburst(2'b01),
    .s_axi_awvalid(1'b0), .s_axi_awready(),
    .s_axi_wdata(128'd0), .s_axi_wstrb(16'd0), .s_axi_wlast(1'b0),
    .s_axi_wvalid(1'b0), .s_axi_wready(),
    .s_axi_bid(), .s_axi_bresp(), .s_axi_bvalid(), .s_axi_bready(1'b1),
    .s_axi_arid(arid), .s_axi_araddr(araddr), .s_axi_arlen(arlen),
    .s_axi_arsize(arsize), .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid && !fill), .s_axi_arready(arready_e),
    .s_axi_rid(rid_e), .s_axi_rdata(rdata_e), .s_axi_rresp(rresp_e),
    .s_axi_rlast(rlast_e), .s_axi_rvalid(rvalid_e), .s_axi_rready(rready)
  );

  task automatic send_text(input string s);
    integer n, k; begin
      n = s.len();
      for (k = 0; k < n; k = k + 1) begin
        @(posedge clk); while (!tok_r) @(posedge clk);
        tok_v <= 1'b1; tok <= s[k]; @(posedge clk); tok_v <= 1'b0;
      end
      @(posedge clk); fire <= 1'b1; @(posedge clk); fire <= 1'b0;
    end
  endtask

  task automatic wait_done;
    begin
      fork
        wait (result_v);
        begin repeat (400000) @(posedge clk); $display("TIMEOUT"); fail = fail + 1; end
      join_any disable fork;
    end
  endtask

  task automatic retire_q;
    begin @(posedge clk); retire <= 1'b1; @(posedge clk); retire <= 1'b0; repeat (8) @(posedge clk); end
  endtask

  task automatic por;
    begin
      rst_n = 1'b0; tok_v = 1'b0; tok = 8'd0; fire = 1'b0; retire = 1'b0;
      repeat (8) @(posedge clk); rst_n = 1'b1; repeat (16) @(posedge clk);
    end
  endtask

  task automatic dump(input string name);
    $display("CASE %s st=%0d ans=%0d p0=%0d p1=%0d nc=%0d nl=%0d nfar=%0d nok=%0d nerr=%0d nto=%0d narto=%0d ndir=%0d ovf=%0d neg=%0d amb=%0d tbl=%0d nhost=%0d fill=%0d",
      name, st, ans, p0, p1, ncand, nload, nfar, nfok, nferr, nfto, narto, ndir, ovf, neg, amb, tb_load, nhost, fill);
  endtask

  initial begin
    fail = 0; n_ar = 0; n_r = 0;
    fill = 1'b1;
    por();

    send_text("pump requires indirect"); wait_done(); dump("BASE");
    if (tb_load) begin $display("FAIL BASE TB_LOAD"); fail = fail + 1; end
    if (nhost != 0) begin $display("FAIL BASE NHOST"); fail = fail + 1; end
    if (st !== 4'd0 || ans !== 20'd4 || p0 !== 20'd17 || p1 !== 20'd34 || nload !== 8'd2) begin
      $display("FAIL BASE got st=%0d ans=%0d p0=%0d p1=%0d nl=%0d", st, ans, p0, p1, nload);
      fail = fail + 1;
    end else $display("PASS BASE");
    retire_q();

    fill = 1'b0;
    por();
    send_text("pump requires indirect"); wait_done(); dump("EMPTY");
    if (tb_load) begin $display("FAIL EMPTY TB_LOAD"); fail = fail + 1; end
    if (ans === 20'd4 && st === 4'd0) begin
      $display("FAIL EMPTY hardcoded ans=4"); fail = fail + 1;
    end else $display("PASS EMPTY");
    retire_q();

    if (fail == 0) $display("ASTRA_SOC_RTP_WRAP_XSIM_PASS");
    else $display("ASTRA_SOC_RTP_WRAP_XSIM_FAIL n=%0d", fail);
    $finish;
  end
endmodule
