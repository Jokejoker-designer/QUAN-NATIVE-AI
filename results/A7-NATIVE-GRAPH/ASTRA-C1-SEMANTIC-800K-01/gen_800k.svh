// gen_800k.svh — closed-form N=800000 cartesian generator. PROGRAM=NO.
// Must match host_astra_c1_semantic_800k.py nids_of_sro / posting_k0 / posting_k1.
// Requires query_gold.svh (G_* constants) included first.
`ifndef ASTRA_C1_GEN_800K_SVH
`define ASTRA_C1_GEN_800K_SVH

function automatic int g_oi(input int s, input int o);
  if (o < s)
    g_oi = o - G_ENT0;
  else
    g_oi = o - G_ENT0 - 1;
endfunction

function automatic int g_cidx(input int s, input int r, input int o);
  g_cidx = ((s - G_ENT0) * G_N_REL + (r - 1)) * 200 + g_oi(s, o);
endfunction

function automatic int g_cidx_to_stream(input int cidx);
  int skip;
  int si;
  if ((cidx == G_FILL_CIDX) || (cidx == G_SENT_CIDX))
    g_cidx_to_stream = -1;
  else begin
    skip = 0;
    if (cidx > G_FILL_CIDX) skip = skip + 1;
    if (cidx > G_SENT_CIDX) skip = skip + 1;
    si = cidx - skip;
    if ((si < 0) || (si >= G_N_STREAM))
      g_cidx_to_stream = -1;
    else
      g_cidx_to_stream = si;
  end
endfunction

function automatic int g_stream_to_nid(input int si);
  if (si < 120)
    g_stream_to_nid = si;
  else
    g_stream_to_nid = si + 3;
endfunction

function automatic int g_nid_primary(input int s, input int r, input int o);
  int c;
  int st;
  if ((s == 13) && (r == 4) && (o == 14))
    g_nid_primary = 120;
  else if ((s == G_SEN_S) && (r == G_SEN_R) && (o == G_SEN_O))
    g_nid_primary = 799999;
  else begin
    c = g_cidx(s, r, o);
    st = g_cidx_to_stream(c);
    if (st < 0)
      g_nid_primary = -1;
    else
      g_nid_primary = g_stream_to_nid(st);
  end
endfunction

function automatic bit g_key_ok(input int id, input int r);
  g_key_ok = (id >= G_ENT0) && (id <= G_ENT_HI) && (r >= 1) && (r <= G_N_REL);
endfunction

function automatic int g_collect_k0(input int s, input int r, output int ids [0:255]);
  int o;
  int n;
  int nid;
  n = 0;
  if (!g_key_ok(s, r)) begin
    g_collect_k0 = 0;
  end else begin
    for (o = G_ENT0; o <= G_ENT_HI; o = o + 1) begin
      if (o != s) begin
        if ((s == 13) && (r == 4) && (o == 14)) begin
          ids[n] = 120; n = n + 1;
          ids[n] = 121; n = n + 1;
          ids[n] = 122; n = n + 1;
        end else begin
          nid = g_nid_primary(s, r, o);
          if (nid >= 0) begin
            ids[n] = nid;
            n = n + 1;
          end
        end
      end
    end
    g_collect_k0 = n;
  end
endfunction

function automatic int g_collect_k1(input int o, input int r, output int ids [0:255]);
  int s;
  int n;
  int nid;
  n = 0;
  if (!g_key_ok(o, r)) begin
    g_collect_k1 = 0;
  end else begin
    for (s = G_ENT0; s <= G_ENT_HI; s = s + 1) begin
      if (s != o) begin
        if ((s == 13) && (r == 4) && (o == 14)) begin
          ids[n] = 120; n = n + 1;
          ids[n] = 121; n = n + 1;
          ids[n] = 122; n = n + 1;
        end else begin
          nid = g_nid_primary(s, r, o);
          if (nid >= 0) begin
            ids[n] = nid;
            n = n + 1;
          end
        end
      end
    end
    g_collect_k1 = n;
  end
endfunction

function automatic int g_sort_ids(inout int ids [0:255], input int n);
  int i;
  int j;
  int tmp;
  for (i = 0; i < n; i = i + 1) begin
    for (j = i + 1; j < n; j = j + 1) begin
      if (ids[j] < ids[i]) begin
        tmp = ids[i];
        ids[i] = ids[j];
        ids[j] = tmp;
      end
    end
  end
  g_sort_ids = n;
endfunction

function automatic int g_occ_of(input int tbl, input int key);
  int s;
  int r;
  int ids [0:255];
  int n;
  s = (key >> 8) & 8'hFF;
  r = key & 8'hFF;
  if (tbl == 0)
    n = g_collect_k0(s, r, ids);
  else if (tbl == 1)
    n = g_collect_k1(s, r, ids);
  else
    n = 0;
  g_occ_of = n;
endfunction

function automatic logic [127:0] g_pack_dir(input int tbl, input int key);
  int occ;
  int hcnt;
  int ocnt;
  logic [27:0] hbase;
  logic [27:0] obase;
  occ = g_occ_of(tbl, key);
  if (occ <= 0)
    g_pack_dir = 128'd0;
  else begin
    hcnt = (occ >= 4) ? 4 : occ;
    ocnt = (occ > 4) ? (occ - 4) : 0;
    hbase = G_POST_HEAP + ((((tbl << 16) + key) * G_STRIDE_BEATS) << 4);
    obase = hbase + 28'd16;
    g_pack_dir = (128'(ocnt[15:0]) << 108)
               | (128'(obase) << 80)
               | (128'(G_EPOCH) << 64)
               | (128'((ocnt != 0) ? 1 : 0) << 48)
               | (128'(hcnt[15:0]) << 32)
               | 128'(hbase);
  end
endfunction

function automatic logic [127:0] g_pack_post(input int tbl, input int key, input int beat);
  int ids [0:255];
  int n;
  int s;
  int r;
  int i;
  int base;
  logic [127:0] v;
  s = (key >> 8) & 8'hFF;
  r = key & 8'hFF;
  if (tbl == 0)
    n = g_collect_k0(s, r, ids);
  else if (tbl == 1)
    n = g_collect_k1(s, r, ids);
  else
    n = 0;
  n = g_sort_ids(ids, n);
  base = beat * 4;
  v = 128'd0;
  for (i = 0; i < 4; i = i + 1) begin
    if ((base + i) < n)
      v[32*i +: 32] = ids[base + i][31:0];
  end
  g_pack_post = v;
endfunction

function automatic logic [127:0] g_rdata_of(input logic [27:0] addr);
  int rel;
  int t;
  int key;
  int slot;
  int beat;
  int off;
  if ((addr >= G_DIR_LO) && (addr <= G_DIR_HI)) begin
    rel = (addr - 28'h05000000) >> 4;
    t = rel / 65536;
    key = rel % 65536;
    g_rdata_of = g_pack_dir(t, key);
  end else if (addr >= G_POST_HEAP) begin
    off = (addr - G_POST_HEAP) >> 4;
    slot = off / G_STRIDE_BEATS;
    beat = off % G_STRIDE_BEATS;
    t = slot / 65536;
    key = slot % 65536;
    g_rdata_of = g_pack_post(t, key, beat);
  end else
    g_rdata_of = 128'd0;
endfunction

`endif
