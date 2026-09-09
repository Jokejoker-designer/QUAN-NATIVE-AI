// tb_astra02_overflow.sv — overflow-page walk, actual QSE keys. PROGRAM=NO.
`timescale 1ns / 1ps

module tb_astra02_overflow;
  import a7ng_pkg::*;
  `include "ovf_gold.svh"

  localparam int unsigned ID_W = 20;
  localparam int unsigned CAND_CAP = 64;
  localparam int unsigned MEM_DEPTH = 32768;
  localparam logic [27:0] POST_HEAP = 28'h05040000;
  localparam logic [27:0] DIR_LO = 28'h05000000;
  localparam logic [27:0] DIR_HI = 28'h0503FFF0;

  logic clk, rst_n, tok_v, tok_r, fire, retire;
  logic qse_valid, qse_busy, qse_acc, poke_v;
  logic [7:0] tok, eid, iid, rid, xid;
  logic [15:0] k0, k1, k2, k3, n_host_any, live_epoch;
  logic v0, v1, v2, v3;
  logic walk_ready, cand_v, cand_ready, q_done, q_ovf;
  logic [15:0] n_emit, n_dup, n_trunc, n_dir, n_post;
  logic [3:0] pmask;
  logic [ID_W-1:0] cand_id;
  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst; logic arvalid, arready;
  logic [3:0] ridb; logic [127:0] rdata; logic [1:0] rresp;
  logic rlast, rvalid, rready;
  logic [15:0] pk0, pk1, pk2, pk3;
  logic pv0, pv1, pv2, pv3;

  integer i, bi, timeout, n_got, n_dar, g, found, fail;
  logic [ID_W-1:0] got [0:127];
  logic [27:0] dar [0:7];

  a7ng_axi_mem_model #(.DEPTH_WORDS(MEM_DEPTH)) u_mem (
    .clk(clk), .rst_n(rst_n),
    .s_axi_awid(4'd0), .s_axi_awaddr(28'd0), .s_axi_awlen(8'd0),
    .s_axi_awsize(3'd4), .s_axi_awburst(2'b01),
    .s_axi_awvalid(1'b0), .s_axi_awready(),
    .s_axi_wdata(128'd0), .s_axi_wstrb(16'h0), .s_axi_wlast(1'b0),
    .s_axi_wvalid(1'b0), .s_axi_wready(),
    .s_axi_bid(), .s_axi_bresp(), .s_axi_bvalid(), .s_axi_bready(1'b1),
    .s_axi_arid(arid), .s_axi_araddr(araddr), .s_axi_arlen(arlen),
    .s_axi_arsize(arsize), .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid), .s_axi_arready(arready),
    .s_axi_rid(ridb), .s_axi_rdata(rdata), .s_axi_rresp(rresp),
    .s_axi_rlast(rlast), .s_axi_rvalid(rvalid), .s_axi_rready(rready)
  );

  a7ng_query_axi_sparse #(
    .N_TABLES(4), .N_BUCKETS(4096), .CAND_CAP(CAND_CAP),
    .ID_W(ID_W), .INDEX_BASE(NG_DDR_INDEX_BASE)
  ) dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(live_epoch),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .poke_v_i(poke_v),
    .poke_k0_i(pk0), .poke_k1_i(pk1), .poke_k2_i(pk2), .poke_k3_i(pk3),
    .poke_v0_i(pv0), .poke_v1_i(pv1), .poke_v2_i(pv2), .poke_v3_i(pv3),
    .qse_valid_o(qse_valid), .qse_busy_o(qse_busy), .qse_accepted_o(qse_acc),
    .entity_id_o(eid), .intent_id_o(iid), .relation_id_o(rid), .context_id_o(xid),
    .k0_o(k0), .k1_o(k1), .k2_o(k2), .k3_o(k3),
    .k0_valid_o(v0), .k1_valid_o(v1), .k2_valid_o(v2), .k3_valid_o(v3),
    .n_host_any_o(n_host_any),
    .walk_ready_o(walk_ready),
    .cand_v(cand_v), .cand_ready(cand_ready), .cand_id(cand_id),
    .q_done(q_done), .q_overflow_o(q_ovf),
    .n_emit_o(n_emit), .n_dup_o(n_dup), .n_trunc_o(n_trunc),
    .n_dir_ar_o(n_dir), .n_post_ar_o(n_post), .probed_mask_o(pmask),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(ridb), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  task automatic diverge(input string code, input string d);
    begin
      $display("FIRST_DIVERGENCE %s %s", code, d);
      fail = fail + 1;
      #20 $finish;
    end
  endtask

  task automatic feed(input int n, input logic [8*48-1:0] bytes);
    begin
      for (bi = 0; bi < n; bi = bi + 1) begin
        @(posedge clk);
        tok_v <= 1'b1;
        tok   <= bytes[8*bi +: 8];
        @(posedge clk);
        if (!tok_r) diverge("KEY_MISMATCH", "NOT_READY");
        tok_v <= 1'b0;
      end
      @(posedge clk); fire <= 1'b1;
      @(posedge clk); fire <= 1'b0;
    end
  endtask

  task automatic observe;
    begin
      n_got = 0; n_dar = 0; timeout = 0; cand_ready = 1'b1;
      while (!q_done) begin
        @(posedge clk);
        if (arvalid && arready) begin
          if (araddr >= DIR_LO && araddr <= DIR_HI) begin
            dar[n_dar] = araddr;
            n_dar = n_dar + 1;
          end else if (araddr < POST_HEAP)
            diverge("HIDDEN_FULL_SCAN", $sformatf("AR=%h", araddr));
        end
        if (cand_v && cand_ready) begin
          got[n_got] = cand_id;
          n_got = n_got + 1;
        end
        timeout = timeout + 1;
        if (timeout > 80000) diverge("AXI_PROTOCOL_ERROR", "TIMEOUT");
      end
      @(posedge clk);
    end
  endtask

  initial begin
    fail = 0;
    rst_n = 0; tok_v = 0; tok = 0; fire = 0; retire = 0; poke_v = 0;
    cand_ready = 1; live_epoch = 16'd7;
    pk0 = 0; pk1 = 0; pk2 = 0; pk3 = 0;
    pv0 = 0; pv1 = 0; pv2 = 0; pv3 = 0;
    for (i = 0; i < MEM_DEPTH; i = i + 1)
      u_mem.mem[i] = '0;
    repeat (8) @(posedge clk);
    rst_n = 1;
    repeat (4) @(posedge clk);
    for (i = 0; i < G_N_WR; i = i + 1)
      u_mem.mem[G_WR_I[i]] = G_WR_D[i];
    repeat (2) @(posedge clk);

    while (!walk_ready) @(posedge clk);
    feed(G_QLEN, G_QBYTES);
    timeout = 0;
    while (!qse_valid) begin
      @(posedge clk);
      timeout = timeout + 1;
      if (timeout > 64) diverge("KEY_MISMATCH", "NO_VALID");
    end
    if (k0 !== G_K0 || k1 !== G_K1 || k2 !== G_K2 || k3 !== G_K3)
      diverge("KEY_MISMATCH", $sformatf("k %h %h %h %h", k0, k1, k2, k3));
    if (v0 !== G_V0 || v1 !== G_V1 || v2 !== G_V2 || v3 !== G_V3)
      diverge("VALIDITY_MISMATCH", "valid bits");
    if (n_host_any != 0)
      diverge("HOST_SEMANTIC_LEAK", $sformatf("%0d", n_host_any));
    observe();
    if (n_got != G_N_EMIT || n_emit != G_N_EMIT)
      diverge("CAP_ERROR", $sformatf("emit %0d exp %0d", n_got, G_N_EMIT));
    for (i = 0; i < n_got; i = i + 1)
      if (got[i] !== G_EMIT[i])
        diverge("CANDIDATE_ID_MISMATCH", $sformatf("i=%0d act=%h exp=%h", i, got[i], G_EMIT[i]));
    for (g = 0; g < G_N_GOLD; g = g + 1) begin
      found = 0;
      for (i = 0; i < n_got; i = i + 1)
        if (got[i] === G_GOLD[g]) found = 1;
      if (!found)
        diverge("OVERFLOW_MISS", $sformatf("gold %h not retrieved", G_GOLD[g]));
    end
    if (n_dar > 4) diverge("HIDDEN_FULL_SCAN", $sformatf("dir=%0d", n_dar));
    if (!q_ovf) diverge("OVERFLOW_MISS", "q_overflow_o=0 with overflow pages");
    $display("OVF_QSE chiller emit=%0d dir=%0d post=%0d ovf=%0d gold_hit=ALL",
      n_got, n_dir, n_post, q_ovf);
    @(posedge clk); retire <= 1'b1;
    @(posedge clk); retire <= 1'b0;
    @(posedge clk);

    while (!walk_ready) @(posedge clk);
    feed(G_ULEN, G_UBYTES);
    timeout = 0;
    while (!qse_valid) begin
      @(posedge clk);
      timeout = timeout + 1;
      if (timeout > 64) diverge("KEY_MISMATCH", "UNK NO_VALID");
    end
    observe();
    if (n_got != 0 || n_dir != 0)
      diverge("UNKNOWN_ZERO", $sformatf("unk emit=%0d dir=%0d", n_got, n_dir));
    $display("OVF_QSE payroll emit=0 dir=0");

    $display("ASTRA02_OVERFLOW_XSIM_PASS");
    $display("NOT_CLAIMED=board,role_parse,Gate14");
    #20 $finish;
  end
endmodule
