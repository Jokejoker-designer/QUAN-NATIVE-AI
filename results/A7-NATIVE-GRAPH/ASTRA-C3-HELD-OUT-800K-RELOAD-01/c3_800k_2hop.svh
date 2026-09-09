// ASTRA-C3-HELD-OUT-800K-2HOP-01. PROGRAM=NO.
// Ctx-folded k0 overlay only. Cartesian fact_pack / 1-hop dir unedited.
// k0={subj, ctx=2, rel_nibble=4} is empty in gen_800k (r=0x24 not a rel id).
// Hops are cartesian SRO nids; gold dest=28 via mid=29, both nid%16==9 (conf 200).
// Distractor low-conf (nid%16!=9) has smaller p0 so frozen tie-break misses gold.
localparam logic [27:0] C3K2_POST_BASE = 28'h0C00_0000;
localparam logic [7:0]  C3K2_CTX_REL   = 8'h24;
localparam int          C3K2_GOLD_DEST = 28;
localparam int          C3K2_GOLD_P1   = 64617;

function automatic bit c3k2_is_subj(input int s);
  c3k2_is_subj = (s==13) || (s==15) || (s==16) || (s==19) || (s==20);
endfunction

function automatic int c3k2_slot(input int s);
  begin
    if (s==13) c3k2_slot = 0;
    else if (s==15) c3k2_slot = 1;
    else if (s==16) c3k2_slot = 2;
    else if (s==19) c3k2_slot = 3;
    else if (s==20) c3k2_slot = 4;
    else c3k2_slot = -1;
  end
endfunction

function automatic int c3k2_nid(input int s, input int i);
  begin
    c3k2_nid = 0;
    if (s==13) begin
      if (i==0) c3k2_nid = 120;
      else if (i==1) c3k2_nid = 4603;
      else if (i==2) c3k2_nid = 617;
      else if (i==3) c3k2_nid = 64617;
    end else if (s==15) begin
      if (i==0) c3k2_nid = 8602;
      else if (i==1) c3k2_nid = 120;
      else if (i==2) c3k2_nid = 8617;
      else if (i==3) c3k2_nid = 64617;
    end else if (s==16) begin
      if (i==0) c3k2_nid = 12602;
      else if (i==1) c3k2_nid = 120;
      else if (i==2) c3k2_nid = 12617;
      else if (i==3) c3k2_nid = 64617;
    end else if (s==19) begin
      if (i==0) c3k2_nid = 24602;
      else if (i==1) c3k2_nid = 120;
      else if (i==2) c3k2_nid = 24617;
      else if (i==3) c3k2_nid = 64617;
    end else if (s==20) begin
      if (i==0) c3k2_nid = 28602;
      else if (i==1) c3k2_nid = 120;
      else if (i==2) c3k2_nid = 28617;
      else if (i==3) c3k2_nid = 64617;
    end
  end
endfunction

function automatic int c3k2_gold_p0(input int s);
  begin
    if (s==13) c3k2_gold_p0 = 617;
    else if (s==15) c3k2_gold_p0 = 8617;
    else if (s==16) c3k2_gold_p0 = 12617;
    else if (s==19) c3k2_gold_p0 = 24617;
    else if (s==20) c3k2_gold_p0 = 28617;
    else c3k2_gold_p0 = 0;
  end
endfunction

function automatic bit c3k2_dir_hit(input logic [27:0] addr, output int s);
  int key, subj;
  begin
    s = 0;
    c3k2_dir_hit = 1'b0;
    if ((addr >= 28'h0500_0000) && (addr < 28'h0510_0000)) begin
      key = (addr - 28'h0500_0000) >> 4;
      if ((key[7:0] == C3K2_CTX_REL)) begin
        subj = key[15:8];
        if (c3k2_is_subj(subj)) begin
          s = subj;
          c3k2_dir_hit = 1'b1;
        end
      end
    end
  end
endfunction

function automatic logic [127:0] c3k2_pack_dir(input int s, input logic [15:0] epoch);
  int slot;
  logic [27:0] hbase;
  begin
    slot = c3k2_slot(s);
    hbase = C3K2_POST_BASE + (28'(slot) << 4);
    c3k2_pack_dir = (128'(epoch) << 64) | (128'(16'd4) << 32) | 128'(hbase);
  end
endfunction

function automatic bit c3k2_post_hit(input logic [27:0] addr, output int s);
  int off;
  begin
    s = 0;
    c3k2_post_hit = 1'b0;
    if ((addr >= C3K2_POST_BASE) && (addr < (C3K2_POST_BASE + 28'd80))) begin
      off = (addr - C3K2_POST_BASE) >> 4;
      if (off == 0) s = 13;
      else if (off == 1) s = 15;
      else if (off == 2) s = 16;
      else if (off == 3) s = 19;
      else if (off == 4) s = 20;
      if (s != 0) c3k2_post_hit = 1'b1;
    end
  end
endfunction

function automatic logic [127:0] c3k2_pack_post(input int s);
  logic [127:0] v;
  begin
    v = 128'd0;
    v[31:0]   = c3k2_nid(s, 0);
    v[63:32]  = c3k2_nid(s, 1);
    v[95:64]  = c3k2_nid(s, 2);
    v[127:96] = c3k2_nid(s, 3);
    c3k2_pack_post = v;
  end
endfunction
