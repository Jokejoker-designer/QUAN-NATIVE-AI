// ASTRA-C3-HELD-OUT-800K-01. PROGRAM=NO.
// No include-guard: mem and TB both in-module include (C1 G_* pattern).
// C3 fact_pack at FACT_BASE outside gen_800k post-heap. Does not edit KEEP.
localparam logic [27:0] C3K_FACT_BASE = 28'h0E00_0000;
localparam int unsigned C3K_NID_MAX   = 800000;
localparam int unsigned C3K_GOLD_MOD  = 16;
localparam int unsigned C3K_GOLD_REM  = 9;
localparam logic [7:0]  C3K_CONF_HI   = 8'd200;
localparam logic [7:0]  C3K_CONF_LO   = 8'd40;

function automatic logic [7:0] c3k_conf(input int nid);
  c3k_conf = ((nid % C3K_GOLD_MOD) == C3K_GOLD_REM) ? C3K_CONF_HI : C3K_CONF_LO;
endfunction

function automatic bit c3k_nid_to_sro(input int nid, output int s, output int r, output int o);
  int si, cidx, s_idx, rem, r_idx, oi;
  begin
    s=0; r=0; o=0; c3k_nid_to_sro=1'b0;
    if ((nid==120) || (nid==121) || (nid==122)) begin
      s=13; r=4; o=14; c3k_nid_to_sro=1'b1;
    end else if (nid==799999) begin
      s=G_SEN_S; r=G_SEN_R; o=G_SEN_O; c3k_nid_to_sro=1'b1;
    end else if ((nid>=0) && (nid<800000) && (nid!=120) && (nid!=121) && (nid!=122)) begin
      si = (nid < 120) ? nid : (nid - 3);
      cidx = si;
      if (si >= 600) cidx = si + 1;
      s_idx = cidx / 4000;
      rem = cidx % 4000;
      r_idx = rem / 200;
      oi = rem % 200;
      s = G_ENT0 + s_idx;
      r = 1 + r_idx;
      if (oi < (s - G_ENT0)) o = G_ENT0 + oi;
      else o = G_ENT0 + oi + 1;
      c3k_nid_to_sro = (s >= G_ENT0) && (s <= G_ENT_HI) && (r>=1) && (r<=G_N_REL);
    end
  end
endfunction

function automatic logic [127:0] c3k_fact_pack(input int nid);
  int s, r, o;
  logic [7:0] conf;
  begin
    if (!c3k_nid_to_sro(nid, s, r, o))
      c3k_fact_pack = 128'd0;
    else begin
      conf = c3k_conf(nid);
      c3k_fact_pack = {28'd0, conf, 8'd0, 4'd1, 1'b0, 1'b1, 1'b1, 1'b1,
                       nid[19:0], r[7:0], o[19:0], s[19:0]};
    end
  end
endfunction

function automatic int c3k_gold_nid(input int s, input int r);
  int ids [0:255];
  int n, i, nid, found;
  begin
    n = g_collect_k0(s, r, ids);
    n = g_sort_ids(ids, n);
    if (n > 16) n = 16;
    found = 0;
    c3k_gold_nid = 0;
    for (i = 0; i < n; i = i + 1) begin
      nid = ids[i];
      if ((found==0) && ((nid % C3K_GOLD_MOD) == C3K_GOLD_REM)) begin
        c3k_gold_nid = nid;
        found = 1;
      end
    end
  end
endfunction
