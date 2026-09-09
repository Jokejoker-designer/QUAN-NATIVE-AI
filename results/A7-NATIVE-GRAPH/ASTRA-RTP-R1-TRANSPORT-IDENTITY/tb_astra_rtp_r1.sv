// RTP-R1 TB. PROGRAM=NO. Original RTP bag not rewritten.
`timescale 1ns / 1ps

module tb_astra_rtp_r1;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000;
  localparam logic [27:0] POST_HEAP  = 28'h0504_0000;
  localparam logic [27:0] FACT_BASE  = 28'h0580_0000;
  localparam int EPOCH = 7;
  localparam int SLOTS = 64;
  localparam int CLK_NS = 10;

  logic clk, rst_n;
  initial clk = 0;
  always #(CLK_NS/2) clk = ~clk;

  int inj; // 0 ok 1 badrid 2 slverr 3 nolast 4 timeout
  logic [15:0] epoch;
  logic tok_v, tok_r, fire, retire, busy, result_v, tb_load, ovf, neg, amb;
  logic [7:0] tok, subj, obj, rel, ctx, ncand, nload;
  logic [19:0] ans, p0, p1;
  logic [3:0] st;
  logic [15:0] nfar, nfok, nferr, nfto, ndir, nhost;
  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst;
  logic arvalid, arready, rready, rlast, rvalid;
  logic [3:0] rid; logic [127:0] rdata; logic [1:0] rresp;

  logic [27:0] mk[0:SLOTS-1]; logic [127:0] mv[0:SLOTS-1]; logic mvld[0:SLOTS-1];
  integer nslot, fail, i;

  function automatic integer slot_of(input logic [27:0] a);
    integer s; begin slot_of = -1;
      for (s = 0; s < SLOTS; s = s + 1) if (mvld[s] && mk[s] == a) slot_of = s;
    end
  endfunction

  task automatic mem_wr(input logic [27:0] a, input logic [127:0] d);
    integer s; begin
      s = slot_of(a);
      if (s < 0) begin s = nslot; nslot = nslot + 1; end
      mk[s] = a; mv[s] = d; mvld[s] = 1'b1;
    end
  endtask

  function automatic logic [127:0] dir_pack(
      input logic [27:0] base, input int count, input int ovfbit, input int ep);
    dir_pack = {48'd0, ep[15:0], 15'd0, ovfbit[0], count[15:0], 4'd0, base};
  endfunction

  // rtp-desc-v1
  function automatic logic [127:0] fact_pack(
      input int s, o, r, e, input bit trans, pol, valid);
    fact_pack = {52'd0, 4'd1, 1'b0, valid, pol, trans, e[19:0], r[7:0], o[19:0], s[19:0]};
  endfunction

  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl * 65536 + (key & 12'hFFF) * 16;
  endfunction

  task automatic plant_dir_ids(input int ids[$], input int ovfbit);
    integer t, klist[4], n, lane;
    logic [127:0] beat;
    begin
      klist[0] = 2562; klist[1] = 2; klist[2] = 766; klist[3] = 0;
      n = ids.size(); beat = 0;
      for (lane = 0; lane < n && lane < 4; lane = lane + 1)
        beat = beat | (ids[lane][31:0] << (32 * lane));
      mem_wr(POST_HEAP, beat);
      for (t = 0; t < 4; t = t + 1)
        mem_wr(dir_addr(t, klist[t]), dir_pack(POST_HEAP, n, ovfbit, EPOCH));
    end
  endtask

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      arready <= 1'b1; rvalid <= 1'b0; rlast <= 1'b0; rdata <= '0; rid <= '0; rresp <= 2'b00;
    end else begin
      if (rvalid && rready) begin rvalid <= 1'b0; rlast <= 1'b0; end
      if (arvalid && arready && !(rvalid && !rready)) begin
        if ((araddr >= FACT_BASE) && (inj == 4)) begin
          // timeout: swallow AR, no R
        end else begin
          rid   <= ((araddr >= FACT_BASE) && (inj == 1)) ? 4'd7 : arid;
          rresp <= ((araddr >= FACT_BASE) && (inj == 2)) ? 2'b10 : 2'b00;
          rlast <= ((araddr >= FACT_BASE) && (inj == 3)) ? 1'b0 : 1'b1;
          rvalid <= 1'b1;
          rdata  <= (slot_of(araddr) >= 0) ? mv[slot_of(araddr)] : 128'd0;
        end
      end
    end
  end

  a7ng_astra_rtp_pipe_r1 u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(epoch),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .busy_o(busy), .result_v_o(result_v),
    .subj_id_o(subj), .obj_id_o(obj), .rel_id_o(rel), .ctx_id_o(ctx),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1), .status_o(st),
    .n_cand_o(ncand), .n_load_o(nload),
    .n_fact_ar_o(nfar), .n_fact_ok_o(nfok), .n_fact_err_o(nferr), .n_fact_to_o(nfto),
    .n_dir_ar_o(ndir), .n_host_any_o(nhost),
    .ovf_o(ovf), .neg_o(neg), .amb_o(amb), .load_from_tb_o(tb_load),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
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
    begin @(posedge clk); retire <= 1'b1; @(posedge clk); retire <= 1'b0; repeat (4) @(posedge clk); end
  endtask

  task automatic reset_mem;
    begin for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 0; nslot = 0; end
  endtask

  task automatic plant_base(input int ovfbit);
    begin
      plant_dir_ids('{17, 34}, ovfbit);
      mem_wr(FACT_BASE + (17 << 4), fact_pack(10, 1, 2, 17, 1, 1, 1));
      mem_wr(FACT_BASE + (34 << 4), fact_pack(1, 4, 2, 34, 1, 1, 1));
    end
  endtask

  task automatic dump(input string name);
    $display("CASE %s st=%0d ans=%0d p0=%0d p1=%0d nc=%0d nl=%0d nfar=%0d nok=%0d nerr=%0d nto=%0d ovf=%0d neg=%0d amb=%0d tbl=%0d nhost=%0d",
      name, st, ans, p0, p1, ncand, nload, nfar, nfok, nferr, nfto, ovf, neg, amb, tb_load, nhost);
  endtask

  task automatic expect_ans(input string name, input [3:0] es, input int ea, input int ep0, input int ep1);
    begin
      dump(name);
      if (tb_load) begin $display("FAIL %s TB_LOAD", name); fail = fail + 1; end
      if (nhost != 0) begin $display("FAIL %s NHOST", name); fail = fail + 1; end
      if (st !== es || ans !== ea[19:0]) begin
        $display("FAIL %s got st=%0d ans=%0d exp st=%0d ans=%0d", name, st, ans, es, ea);
        fail = fail + 1;
      end else if (es == 4'd0 && (p0 !== ep0[19:0] || p1 !== ep1[19:0])) begin
        $display("FAIL %s proof", name); fail = fail + 1;
      end else $display("PASS %s", name);
    end
  endtask

  initial begin
    fail = 0; nslot = 0; inj = 0;
    rst_n = 0; epoch = EPOCH; tok_v = 0; tok = 0; fire = 0; retire = 0;
    for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 0;
    repeat (8) @(posedge clk); rst_n = 1; repeat (8) @(posedge clk);

    inj = 0; reset_mem(); plant_base(0);
    send_text("pump requires indirect"); wait_done();
    expect_ans("BASE", 4'd0, 4, 17, 34); retire_q();

    inj = 0; reset_mem(); plant_dir_ids('{17}, 0);
    mem_wr(FACT_BASE + (17 << 4), fact_pack(10, 1, 2, 17, 1, 1, 1));
    mem_wr(FACT_BASE + (34 << 4), fact_pack(1, 4, 2, 34, 1, 1, 1));
    send_text("pump requires indirect"); wait_done();
    expect_ans("POST_DROP_BC", 4'd1, 0, 0, 0); retire_q();

    inj = 0; reset_mem(); plant_dir_ids('{17, 34}, 0);
    mem_wr(FACT_BASE + (17 << 4), fact_pack(10, 1, 2, 17, 1, 1, 1));
    mem_wr(FACT_BASE + (34 << 4), fact_pack(1, 7, 2, 34, 1, 1, 1));
    send_text("pump requires indirect"); wait_done();
    expect_ans("DESC_SWAP", 4'd0, 7, 17, 34); retire_q();

    inj = 0; reset_mem(); plant_base(0);
    send_text("payroll tax form"); wait_done(); dump("UNREL");
    if (st==4'd1 && ncand==0 && nload==0 && nfar==0) $display("PASS UNREL");
    else begin $display("FAIL UNREL nc/nl/nfar"); fail = fail + 1; end
    retire_q();

    inj = 1; reset_mem(); plant_base(0);
    send_text("pump requires indirect"); wait_done(); dump("AXI_BAD_RID");
    if (nferr == 0) begin $display("FAIL AXI_BAD_RID no err"); fail = fail + 1; end
    else if (st == 4'd0 && ans == 20'd4) begin $display("FAIL AXI_BAD_RID still 4"); fail = fail + 1; end
    else $display("PASS AXI_BAD_RID");
    retire_q();

    inj = 2; reset_mem(); plant_base(0);
    send_text("pump requires indirect"); wait_done(); dump("AXI_SLVERR");
    if (nferr == 0 || (st == 4'd0 && ans == 20'd4)) begin $display("FAIL AXI_SLVERR"); fail = fail + 1; end
    else $display("PASS AXI_SLVERR");
    retire_q();

    inj = 3; reset_mem(); plant_base(0);
    send_text("pump requires indirect"); wait_done(); dump("AXI_NOLAST");
    if (nferr == 0 || (st == 4'd0 && ans == 20'd4)) begin $display("FAIL AXI_NOLAST"); fail = fail + 1; end
    else $display("PASS AXI_NOLAST");
    retire_q();

    inj = 4; reset_mem(); plant_base(0);
    send_text("pump requires indirect"); wait_done(); dump("AXI_TIMEOUT");
    if (st == 4'd6 && nfto != 0) $display("PASS AXI_TIMEOUT");
    else begin $display("FAIL AXI_TIMEOUT"); fail = fail + 1; end
    retire_q();

    inj = 0; reset_mem(); plant_base(1);
    send_text("pump requires indirect"); wait_done(); dump("OVF");
    if (st == 4'd6 && ovf) $display("PASS OVF");
    else begin $display("FAIL OVF"); fail = fail + 1; end
    retire_q();

    inj = 0; reset_mem(); plant_base(0);
    send_text("not pump requires indirect"); wait_done(); dump("NEG");
    if (st == 4'd8 && neg && ans == 0) $display("PASS NEG");
    else begin $display("FAIL NEG"); fail = fail + 1; end
    retire_q();

    inj = 0; reset_mem(); plant_base(0);
    send_text("pump requires chiller or valve"); wait_done(); dump("AMB");
    if (st == 4'd7 && amb && ans == 0) $display("PASS AMB");
    else begin $display("FAIL AMB"); fail = fail + 1; end
    retire_q();

    if (fail == 0) $display("ASTRA_RTP_R1_XSIM_PASS");
    else $display("ASTRA_RTP_R1_XSIM_FAIL n=%0d", fail);
    $finish;
  end
endmodule
