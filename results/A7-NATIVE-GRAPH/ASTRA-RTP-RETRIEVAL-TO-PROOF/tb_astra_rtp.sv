// RETRIEVAL_TO_PROOF_CAUSALITY TB. PROGRAM=NO.
// No TB load_v into the engine. Facts come from AXI descriptors keyed by walker IDs.
`timescale 1ns / 1ps

module tb_astra_rtp;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000;
  localparam logic [27:0] POST_HEAP  = 28'h0504_0000;
  localparam logic [27:0] FACT_BASE  = 28'h0580_0000;
  localparam int unsigned EPOCH = 7;
  localparam int unsigned SLOTS = 64;
  localparam int CLK_NS = 10;

  logic clk, rst_n;
  initial clk = 0;
  always #(CLK_NS/2) clk = ~clk;

  logic [15:0] epoch;
  logic tok_v, tok_r, fire, retire, busy, result_v;
  logic [7:0] tok, subj, obj, rel, ctx, ncand, nload;
  logic [7:0] ans, p0, p1;
  logic [2:0] st;
  logic [15:0] ndir, nhost;
  logic tb_load;
  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst;
  logic arvalid, arready, rready;
  logic [3:0] rid; logic [127:0] rdata; logic [1:0] rresp;
  logic rlast, rvalid;

  logic [27:0]  mk [0:SLOTS-1];
  logic [127:0] mv [0:SLOTS-1];
  logic         mvld [0:SLOTS-1];
  integer       nslot;
  integer       fail;
  integer       i;

  function automatic integer slot_of(input logic [27:0] a);
    integer s;
    begin
      slot_of = -1;
      for (s = 0; s < SLOTS; s = s + 1)
        if (mvld[s] && mk[s] == a) slot_of = s;
    end
  endfunction

  task automatic mem_wr(input logic [27:0] a, input logic [127:0] d);
    integer s;
    begin
      s = slot_of(a);
      if (s < 0) begin
        s = nslot;
        nslot = nslot + 1;
        if (nslot > SLOTS) begin
          $display("MEM_OVERFLOW");
          $finish;
        end
      end
      mk[s] = a; mv[s] = d; mvld[s] = 1'b1;
    end
  endtask

  function automatic logic [127:0] dir_pack(
      input logic [27:0] base, input int count, input int ovf, input int ep);
    dir_pack = ((ep[15:0]) << 64) | ((ovf[0]) << 48) | ((count[15:0]) << 32) | {4'd0, base};
  endfunction

  function automatic logic [127:0] fact_pack(
      input byte s, r, o, e, input bit trans, pol, valid);
    fact_pack = {93'd0, valid, pol, trans, e, o, r, s};
  endfunction

  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl * 65536 + (key & 12'hFFF) * 16;
  endfunction

  task automatic plant_dir_ids(input int ids[$]);
    integer t, klist[4];
    logic [127:0] beat;
    integer n, lane;
    begin
      klist[0] = 2562; klist[1] = 2; klist[2] = 766; klist[3] = 0;
      n = ids.size();
      beat = 0;
      for (lane = 0; lane < n && lane < 4; lane = lane + 1)
        beat = beat | (ids[lane][31:0] << (32 * lane));
      mem_wr(POST_HEAP, beat);
      for (t = 0; t < 4; t = t + 1)
        mem_wr(dir_addr(t, klist[t]), dir_pack(POST_HEAP, n, 0, EPOCH));
    end
  endtask

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      arready <= 1'b1;
      rvalid <= 1'b0; rlast <= 1'b0; rdata <= '0; rid <= '0; rresp <= 2'b00;
    end else begin
      if (rvalid && rready) begin
        rvalid <= 1'b0; rlast <= 1'b0;
      end
      if (arvalid && arready && !(rvalid && !rready)) begin
        rid <= arid;
        rresp <= 2'b00;
        rlast <= 1'b1;
        rvalid <= 1'b1;
        if (slot_of(araddr) >= 0)
          rdata <= mv[slot_of(araddr)];
        else
          rdata <= 128'd0;
      end
    end
  end

  a7ng_astra_rtp_pipe u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(epoch),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .busy_o(busy), .result_v_o(result_v),
    .subj_id_o(subj), .obj_id_o(obj), .rel_id_o(rel), .ctx_id_o(ctx),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1), .status_o(st),
    .n_cand_o(ncand), .n_load_o(nload), .n_dir_ar_o(ndir),
    .n_host_any_o(nhost), .load_from_tb_o(tb_load),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  task automatic send_text(input string s);
    integer n, k;
    begin
      n = s.len();
      for (k = 0; k < n; k = k + 1) begin
        @(posedge clk);
        while (!tok_r) @(posedge clk);
        tok_v <= 1'b1; tok <= s[k];
        @(posedge clk);
        tok_v <= 1'b0;
      end
      @(posedge clk);
      fire <= 1'b1;
      @(posedge clk);
      fire <= 1'b0;
    end
  endtask

  task automatic wait_done;
    begin
      fork
        begin : w
          wait (result_v);
        end
        begin : to
          repeat (200000) @(posedge clk);
          $display("TIMEOUT");
          fail = fail + 1;
        end
      join_any
      disable fork;
    end
  endtask

  task automatic retire_q;
    begin
      @(posedge clk); retire <= 1'b1; @(posedge clk); retire <= 1'b0;
      repeat (4) @(posedge clk);
    end
  endtask

  task automatic check(
      input string name, input [2:0] exp_st, input [7:0] exp_ans,
      input [7:0] exp_p0, input [7:0] exp_p1);
    begin
      $display("CASE %s st=%0d ans=%0d p0=%0d p1=%0d nc=%0d nl=%0d ndir=%0d nhost=%0d tbl=%0d",
               name, st, ans, p0, p1, ncand, nload, ndir, nhost, tb_load);
      if (tb_load) begin
        $display("FAIL %s TB_LOAD_USED", name);
        fail = fail + 1;
      end
      if (nhost != 0) begin
        $display("FAIL %s N_HOST", name);
        fail = fail + 1;
      end
      if (st !== exp_st || ans !== exp_ans) begin
        $display("FAIL %s got st=%0d ans=%0d exp st=%0d ans=%0d", name, st, ans, exp_st, exp_ans);
        fail = fail + 1;
      end else if (exp_st == 3'd0 && (p0 !== exp_p0 || p1 !== exp_p1)) begin
        $display("FAIL %s proof got %0d,%0d exp %0d,%0d", name, p0, p1, exp_p0, exp_p1);
        fail = fail + 1;
      end else
        $display("PASS %s", name);
    end
  endtask

  task automatic reset_mem;
    begin
      for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 1'b0;
      nslot = 0;
    end
  endtask

  initial begin
    fail = 0; nslot = 0;
    rst_n = 0; epoch = EPOCH[15:0];
    tok_v = 0; tok = 0; fire = 0; retire = 0;
    for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 0;
    repeat (8) @(posedge clk);
    rst_n = 1;
    repeat (8) @(posedge clk);

    // BASE
    reset_mem();
    plant_dir_ids('{17, 34});
    mem_wr(FACT_BASE + (17 << 4), fact_pack(10, 2, 1, 17, 1, 1, 1));
    mem_wr(FACT_BASE + (34 << 4), fact_pack(1, 2, 4, 34, 1, 1, 1));
    send_text("pump requires indirect");
    wait_done();
    check("BASE", 3'd0, 8'd4, 8'd17, 8'd34);
    retire_q();

    // POST_DROP_BC: posting drops 34; descriptor 34 remains
    reset_mem();
    plant_dir_ids('{17});
    mem_wr(FACT_BASE + (17 << 4), fact_pack(10, 2, 1, 17, 1, 1, 1));
    mem_wr(FACT_BASE + (34 << 4), fact_pack(1, 2, 4, 34, 1, 1, 1));
    send_text("pump requires indirect");
    wait_done();
    check("POST_DROP_BC", 3'd1, 8'd0, 8'd0, 8'd0);
    if (st == 3'd0 && ans == 8'd4) begin
      $display("FAIL POST_DROP_BC still answered 4 with posting drop");
      fail = fail + 1;
    end
    retire_q();

    // DESC_SWAP: posting still has 34, object becomes 7
    reset_mem();
    plant_dir_ids('{17, 34});
    mem_wr(FACT_BASE + (17 << 4), fact_pack(10, 2, 1, 17, 1, 1, 1));
    mem_wr(FACT_BASE + (34 << 4), fact_pack(1, 2, 7, 34, 1, 1, 1));
    send_text("pump requires indirect");
    wait_done();
    check("DESC_SWAP", 3'd0, 8'd7, 8'd17, 8'd34);
    retire_q();

    // UNREL
    reset_mem();
    plant_dir_ids('{17, 34});
    mem_wr(FACT_BASE + (17 << 4), fact_pack(10, 2, 1, 17, 1, 1, 1));
    mem_wr(FACT_BASE + (34 << 4), fact_pack(1, 2, 4, 34, 1, 1, 1));
    send_text("payroll tax form");
    wait_done();
    check("UNREL", 3'd1, 8'd0, 8'd0, 8'd0);
    if (nload != 0 && st == 3'd0) begin
      $display("FAIL UNREL loaded facts into answer");
      fail = fail + 1;
    end
    retire_q();

    if (fail == 0) begin
      $display("ASTRA_RTP_XSIM_PASS");
      $display("NOT_CLAIMED=board,nlu,lm06,timing,sgd_select");
    end else begin
      $display("ASTRA_RTP_XSIM_FAIL n=%0d", fail);
    end
    $finish;
  end
endmodule
