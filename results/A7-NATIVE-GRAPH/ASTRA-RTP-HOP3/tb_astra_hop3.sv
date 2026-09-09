`timescale 1ns / 1ps
module tb_astra_hop3;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS=64;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  logic tok_v, tok_r, fire, retire, busy, result_v, tbl;
  logic [7:0] tok, nload;
  logic [19:0] ans, p0, p1, p2;
  logic [3:0] st;
  logic [15:0] nfar;
  logic [3:0] arid; logic [27:0] araddr; logic [7:0] arlen;
  logic [2:0] arsize; logic [1:0] arburst;
  logic arvalid, arready, rready, rlast, rvalid;
  logic [3:0] rid; logic [127:0] rdata; logic [1:0] rresp;
  logic [27:0] mk[0:SLOTS-1]; logic [127:0] mv[0:SLOTS-1]; logic mvld[0:SLOTS-1];
  integer nslot, fail, i;

  function automatic integer slot_of(input logic [27:0] a);
    integer s; begin slot_of=-1; for(s=0;s<SLOTS;s=s+1) if(mvld[s]&&mk[s]==a) slot_of=s; end
  endfunction
  task automatic mem_wr(input logic [27:0] a, input logic [127:0] d);
    integer s; begin s=slot_of(a); if(s<0) begin s=nslot; nslot=nslot+1; end mk[s]=a; mv[s]=d; mvld[s]=1; end
  endtask
  function automatic logic [127:0] dir_pack(input int count);
    dir_pack = {48'd0,16'd7,16'd0,count[15:0],4'd0,POST_HEAP};
  endfunction
  function automatic logic [127:0] fact_pack(input int s,o,r,e);
    fact_pack = {52'd0,4'd1,1'b0,1'b1,1'b1,1'b1,e[19:0],r[7:0],o[19:0],s[19:0]};
  endfunction
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl*65536 + (key & 12'hFFF)*16;
  endfunction

  assign arready = 1'b1;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin rvalid<=0; rlast<=0; rdata<=0; rid<=0; rresp<=0; end
    else begin
      if (rvalid && rready) begin rvalid<=0; rlast<=0; end
      if (arvalid && arready && !(rvalid && !rready)) begin
        rid<=arid; rresp<=0; rlast<=1; rvalid<=1;
        rdata <= (slot_of(araddr)>=0)? mv[slot_of(araddr)] : 128'd0;
      end
    end
  end

  a7ng_astra_rtp_hop3 u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .busy_o(busy), .result_v_o(result_v),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1), .proof2_o(p2),
    .status_o(st), .n_load_o(nload), .n_fact_ar_o(nfar), .load_from_tb_o(tbl),
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
  task wait_done;
    begin fork wait(result_v); begin repeat(30000) @(posedge clk); $display("TIMEOUT"); fail=fail+1; $finish; end join_any disable fork; end
  endtask
  task retire_q; begin @(posedge clk); retire<=1; @(posedge clk); retire<=0; repeat(4) @(posedge clk); end endtask
  task reset_mem; begin for(i=0;i<SLOTS;i=i+1) mvld[i]=0; nslot=0; end endtask
  task plant_post(input int n, input int a, input int b, input int c);
    logic [127:0] beat; begin
      beat = 0;
      if (n>=1) beat = beat | a;
      if (n>=2) beat = beat | (b << 32);
      if (n>=3) beat = beat | (c << 64);
      mem_wr(POST_HEAP, beat);
      mem_wr(dir_addr(0,2562), dir_pack(n));
      mem_wr(dir_addr(2,766), dir_pack(n));
    end
  endtask

  initial begin
    fail=0; nslot=0; rst_n=0; tok_v=0; fire=0; retire=0;
    for(i=0;i<SLOTS;i=i+1) mvld[i]=0;
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    reset_mem(); plant_post(3,17,34,51);
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17));
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34));
    mem_wr(FACT_BASE+(51<<4), fact_pack(4,7,2,51));
    send_text("pump requires indirect"); wait_done();
    $display("BASE st=%0d ans=%0d p=%0d,%0d,%0d tbl=%0d", st,ans,p0,p1,p2,tbl);
    if (st==0 && ans==7 && p0==17 && p1==34 && p2==51 && !tbl) $display("PASS BASE");
    else begin $display("FAIL BASE"); fail=fail+1; end
    retire_q();

    reset_mem(); plant_post(2,17,34,0);
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17));
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34));
    mem_wr(FACT_BASE+(51<<4), fact_pack(4,7,2,51));
    send_text("pump requires indirect"); wait_done();
    $display("DROP_LAST st=%0d ans=%0d", st,ans);
    if (st==1 && ans!=7) $display("PASS DROP_LAST"); else begin $display("FAIL DROP_LAST"); fail=fail+1; end
    retire_q();

    reset_mem(); plant_post(2,17,34,0);
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17));
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34));
    send_text("pump requires indirect"); wait_done();
    $display("TWO_ONLY st=%0d ans=%0d", st,ans);
    if (st==1 && ans!=4) $display("PASS TWO_ONLY"); else begin $display("FAIL TWO_ONLY"); fail=fail+1; end
    retire_q();

    reset_mem(); plant_post(3,17,34,51);
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17));
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34));
    mem_wr(FACT_BASE+(51<<4), fact_pack(4,7,2,51));
    send_text("payroll tax form"); wait_done();
    $display("UNREL st=%0d nfar=%0d", st,nfar);
    if (st==1 && nfar==0) $display("PASS UNREL"); else begin $display("FAIL UNREL"); fail=fail+1; end

    if (fail==0) $display("ASTRA_RTP_HOP3_XSIM_PASS");
    else $display("ASTRA_RTP_HOP3_XSIM_FAIL n=%0d", fail);
    $finish;
  end
endmodule
