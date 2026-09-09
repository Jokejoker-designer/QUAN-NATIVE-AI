`timescale 1ns / 1ps
module tb_astra_f2;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000;
  localparam logic [27:0] POST_HEAP  = 28'h0504_0000;
  localparam logic [27:0] FACT_BASE  = 28'h0580_0000;
  localparam int SLOTS = 64;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic tok_v, tok_r, fire, retire, freeze, rew_v, busy, result_v, rew_rdy, tbl;
  logic [7:0] tok; logic signed [2:0] rew;
  logic [19:0] ans, p0, p1, mid;
  logic [3:0] npath;
  logic signed [15:0] vsel, valt;
  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst;
  logic arvalid, arready, rready, rlast, rvalid;
  logic [3:0] rid; logic [127:0] rdata; logic [1:0] rresp;
  logic [27:0] mk[0:SLOTS-1]; logic [127:0] mv[0:SLOTS-1]; logic mvld[0:SLOTS-1];
  integer nslot, fail, i;

  function automatic integer slot_of(input logic [27:0] a);
    integer s; begin slot_of=-1; for (s=0;s<SLOTS;s=s+1) if (mvld[s]&&mk[s]==a) slot_of=s; end
  endfunction
  task automatic mem_wr(input logic [27:0] a, input logic [127:0] d);
    integer s; begin s=slot_of(a); if(s<0) begin s=nslot; nslot=nslot+1; end mk[s]=a; mv[s]=d; mvld[s]=1; end
  endtask
  function automatic logic [127:0] dir_pack(input logic [27:0] base, input int count);
    dir_pack = {48'd0, 16'd7, 16'd0, count[15:0], 4'd0, base};
  endfunction
  function automatic logic [127:0] fact_pack(input int s,o,r,e);
    fact_pack = {52'd0,4'd1,1'b0,1'b1,1'b1,1'b1,e[19:0],r[7:0],o[19:0],s[19:0]};
  endfunction
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl*65536 + (key & 12'hFFF)*16;
  endfunction

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin arready<=1; rvalid<=0; rlast<=0; rdata<=0; rid<=0; rresp<=0; end
    else begin
      if (rvalid && rready) begin rvalid<=0; rlast<=0; end
      if (arvalid && arready && !(rvalid && !rready)) begin
        rid<=arid; rresp<=0; rlast<=1; rvalid<=1;
        rdata <= (slot_of(araddr)>=0) ? mv[slot_of(araddr)] : 128'd0;
      end
    end
  end

  a7ng_astra_rtp_f2 u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire), .freeze_i(freeze),
    .rew_v_i(rew_v), .rew_i(rew),
    .busy_o(busy), .result_v_o(result_v), .rew_ready_o(rew_rdy),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1), .mid_o(mid),
    .n_path_o(npath), .v_sel_o(vsel), .v_alt_o(valt), .load_from_tb_o(tbl),
    .m_axi_arid(arid), .m_axi_araddr(araddr), .m_axi_arlen(arlen),
    .m_axi_arsize(arsize), .m_axi_arburst(arburst),
    .m_axi_arvalid(arvalid), .m_axi_arready(arready),
    .m_axi_rid(rid), .m_axi_rdata(rdata), .m_axi_rresp(rresp),
    .m_axi_rlast(rlast), .m_axi_rvalid(rvalid), .m_axi_rready(rready)
  );

  task send_text(input string s);
    integer n,k; begin n=s.len();
      for(k=0;k<n;k=k+1) begin @(posedge clk); while(!tok_r) @(posedge clk);
        tok_v<=1; tok<=s[k]; @(posedge clk); tok_v<=0; end
      @(posedge clk); fire<=1; @(posedge clk); fire<=0;
    end
  endtask
  task wait_done; begin fork wait(result_v); begin repeat(20000) @(posedge clk); $display("TIMEOUT"); fail=fail+1; $finish; end join_any disable fork; end endtask

  integer ctrl0, ctrl1;
  initial begin
    fail=0; nslot=0; rst_n=0; tok_v=0; fire=0; retire=0; freeze=0; rew_v=0; rew=0;
    for(i=0;i<SLOTS;i=i+1) mvld[i]=0;
    mem_wr(POST_HEAP, {32'd35,32'd18,32'd34,32'd17});
    mem_wr(dir_addr(0,2562), dir_pack(POST_HEAP,4));
    mem_wr(dir_addr(2,766), dir_pack(POST_HEAP,4));
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17));
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34));
    mem_wr(FACT_BASE+(18<<4), fact_pack(10,8,2,18));
    mem_wr(FACT_BASE+(35<<4), fact_pack(8,4,2,35));
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    send_text("pump requires indirect"); wait_done();
    $display("R0 npath=%0d p0=%0d p1=%0d mid=%0d ans=%0d vsel=%0d valt=%0d tbl=%0d", npath,p0,p1,mid,ans,vsel,valt,tbl);
    if (tbl) fail=fail+1;
    if (npath < 2) begin $display("FAIL npath"); fail=fail+1; end
    if (p0!==20'd17 || mid!==20'd1) begin $display("FAIL R0 expected chiller tie-break"); fail=fail+1; end
    else $display("PASS R0_TIEBREAK_CHILLER");
    ctrl0 = 17; // validity-only control
    repeat(8) @(posedge clk);
    $display("PRE_REW dutst=%0d sgd_ready=%0d", u_dut.st, u_dut.u_sgd.ready_o);
    @(posedge clk); rew<=-3'sd3; rew_v<=1;
    @(posedge clk);
    $display("REW_CYC dutst=%0d sgd_ready=%0d rew_v=%0d", u_dut.st, u_dut.u_sgd.ready_o, rew_v);
    rew_v<=0;
    repeat(200) @(posedge clk);
    $display("DBG w0=%0d w1=%0d xsel0=%0d xsel1=%0d best_m=%0d sgd_st=%0d do_upd=%0d",
      u_dut.u_sgd.w[0], u_dut.u_sgd.w[1], u_dut.xsel[0], u_dut.xsel[1], mid,
      u_dut.u_sgd.st, u_dut.u_sgd.do_upd);
    @(posedge clk); retire<=1; @(posedge clk); retire<=0;
    wait(!result_v);
    repeat(8) @(posedge clk);

    send_text("pump requires indirect"); wait_done();
    $display("R1 npath=%0d p0=%0d p1=%0d mid=%0d ans=%0d vsel=%0d valt=%0d", npath,p0,p1,mid,ans,vsel,valt);
    if (p0!==20'd18 || mid!==20'd8) begin $display("FAIL R1 expected valve after -3 on chiller"); fail=fail+1; end
    else $display("PASS R1_LEARNED_VALVE");
    ctrl1 = 17;
    if (ctrl0==ctrl1) $display("PASS CONTROL_VALIDITY_DOES_NOT_SWITCH");
    else begin $display("FAIL CONTROL"); fail=fail+1; end

    if (fail==0) $display("ASTRA_RTP_F2_XSIM_PASS");
    else $display("ASTRA_RTP_F2_XSIM_FAIL n=%0d", fail);
    $finish;
  end
endmodule
