`timescale 1ns / 1ps
module tb_astra_rtp_r2;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000;
  localparam logic [27:0] POST_HEAP  = 28'h0504_0000;
  localparam logic [27:0] FACT_BASE  = 28'h0580_0000;
  localparam int HID0 = 20'hA0011, HID1 = 20'hA0022, EPOCH = 7, SLOTS = 64;
  logic clk, rst_n; initial clk=0; always #5 clk=~clk;
  int inj; // 0 ok 5 arstall 6 later
  int late_cnt;
  logic tok_v, tok_r, fire, retire, busy, result_v, tbl, ovf, neg, amb;
  logic [7:0] tok, subj, obj, rel, ctx, ncand, nload;
  logic [19:0] ans, p0, p1;
  logic [3:0] st;
  logic [15:0] nfar, nfok, nferr, nfto, narto, ndir, nhost;
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
  function automatic logic [127:0] dir_pack(input logic [27:0] base, input int count);
    dir_pack = {48'd0,16'd7,16'd0,count[15:0],4'd0,base};
  endfunction
  function automatic logic [127:0] fact_pack(input int s,o,r,e);
    fact_pack = {52'd0,4'd1,1'b0,1'b1,1'b1,1'b1,e[19:0],r[7:0],o[19:0],s[19:0]};
  endfunction
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl*65536 + (key & 12'hFFF)*16;
  endfunction
  task automatic plant_ids(input int a, input int b);
    integer t; logic [127:0] beat;
    begin
      beat = b; beat = beat << 32; beat = beat | a;
      mem_wr(POST_HEAP, beat);
      mem_wr(dir_addr(0,2562), dir_pack(POST_HEAP,2));
      mem_wr(dir_addr(2,766), dir_pack(POST_HEAP,2));
    end
  endtask

  assign arready = !((inj == 5) && arvalid && (araddr >= FACT_BASE));
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rvalid<=0; rlast<=0; rdata<=0; rid<=0; rresp<=0; late_cnt<=0;
    end else begin
      if (rvalid && rready) begin rvalid<=0; rlast<=0; end
      if (arvalid && arready && !(rvalid && !rready)) begin
        if (inj==6 && araddr>=FACT_BASE) begin
          late_cnt <= 20;
          rid <= arid; rresp <= 0; rlast <= 1;
          rdata <= (slot_of(araddr)>=0)? mv[slot_of(araddr)] : 128'd0;
        end else begin
          rid<=arid; rresp<=0; rlast<=1; rvalid<=1;
          rdata <= (slot_of(araddr)>=0)? mv[slot_of(araddr)] : 128'd0;
        end
      end else if (late_cnt>0) begin
        late_cnt <= late_cnt-1;
        if (late_cnt==1) rvalid <= 1'b1;
      end
    end
  end

  a7ng_astra_rtp_pipe_r2 u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .busy_o(busy), .result_v_o(result_v),
    .subj_id_o(subj), .obj_id_o(obj), .rel_id_o(rel), .ctx_id_o(ctx),
    .ans_o(ans), .proof0_o(p0), .proof1_o(p1), .status_o(st),
    .n_cand_o(ncand), .n_load_o(nload),
    .n_fact_ar_o(nfar), .n_fact_ok_o(nfok), .n_fact_err_o(nferr),
    .n_fact_to_o(nfto), .n_ar_to_o(narto),
    .n_dir_ar_o(ndir), .n_host_any_o(nhost),
    .ovf_o(ovf), .neg_o(neg), .amb_o(amb), .load_from_tb_o(tbl),
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

  initial begin
    fail=0; nslot=0; inj=0; rst_n=0; tok_v=0; fire=0; retire=0;
    for(i=0;i<SLOTS;i=i+1) mvld[i]=0;
    repeat(8) @(posedge clk); rst_n=1; repeat(8) @(posedge clk);

    inj=0; reset_mem(); plant_ids(17,34);
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17));
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34));
    send_text("pump requires indirect"); wait_done();
    $display("BASE st=%0d ans=%0d p0=%0d p1=%0d", st,ans,p0,p1);
    if (st==0 && ans==4 && p0==17 && p1==34) $display("PASS BASE"); else begin $display("FAIL BASE"); fail=fail+1; end
    retire_q();

    inj=0; reset_mem(); plant_ids(HID0,HID1);
    mem_wr(FACT_BASE+(HID0<<4), fact_pack(10,1,2,HID0));
    mem_wr(FACT_BASE+(HID1<<4), fact_pack(1,4,2,HID1));
    send_text("pump requires indirect"); wait_done();
    $display("HIGH_ID st=%0d ans=%0d p0=%0h p1=%0h nl=%0d", st,ans,p0,p1,nload);
    if (st==0 && ans==4 && p0==HID0 && p1==HID1) $display("PASS HIGH_ID"); else begin $display("FAIL HIGH_ID"); fail=fail+1; end
    retire_q();

    inj=0; reset_mem(); plant_ids(HID0,HID1);
    mem_wr(FACT_BASE+(HID0<<4), fact_pack(10,1,2,20'h00EE)); // eid mismatch
    mem_wr(FACT_BASE+(HID1<<4), fact_pack(1,4,2,HID1));
    send_text("pump requires indirect"); wait_done();
    $display("EID_MISMATCH st=%0d ans=%0d nferr=%0d nl=%0d", st,ans,nferr,nload);
    if (st!=0 && nferr>=1 && ans!=4) $display("PASS EID_MISMATCH"); else begin $display("FAIL EID_MISMATCH"); fail=fail+1; end
    retire_q();

    inj=5; reset_mem(); plant_ids(17,34);
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17));
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34));
    send_text("pump requires indirect"); wait_done();
    $display("AR_STALL st=%0d narto=%0d", st,narto);
    if (st==6 && narto>=1) $display("PASS AR_STALL"); else begin $display("FAIL AR_STALL"); fail=fail+1; end
    retire_q();

    inj=6; reset_mem(); plant_ids(17,34);
    mem_wr(FACT_BASE+(17<<4), fact_pack(10,1,2,17));
    mem_wr(FACT_BASE+(34<<4), fact_pack(1,4,2,34));
    send_text("pump requires indirect"); wait_done();
    $display("LATE_R st=%0d ans=%0d p0=%0d p1=%0d", st,ans,p0,p1);
    if (st==0 && ans==4 && p0==17 && p1==34) $display("PASS LATE_R"); else begin $display("FAIL LATE_R"); fail=fail+1; end
    retire_q();

    if (fail==0) $display("ASTRA_RTP_R2_XSIM_PASS");
    else $display("ASTRA_RTP_R2_XSIM_FAIL n=%0d", fail);
    $finish;
  end
endmodule
