# WO — ASTRA-C1-N4096-STREAM-02 late-gold stress

Auditor 20260907T1145Z ACCEPT_PARTIAL on STREAM-INTERSECT-02 N=256. P1 none.
SAME law qse-v2-stream-intersect-02. Instantiate a7ng_query_axi_sparse_stream_intersect.sv (hash-gate live SHA 14f75db7… from N=256 bag). Do not edit it unless mismatch then FAIL.

KEEP unedited: ASTRA-C1-N4096-INTERSECT-01 (old cap-then-AND archive), STREAM-02 N=256, KEY-INTERSECT, AXI-BEAT, C0 RTL, independent audit tree (do not write).

ONE UNKNOWN: at N=4096, stream merge (AND-then-cap, rare-first, 1-beat), does LATE gold (index ≥16 on BOTH k0 and k1, preferably near end like 4095) HIT, and do retrieve classes with gold_n>=1 FAIL the bag if SEARCH_INCOMPLETE / emit miss?

PASS marker only if FAIL=0 AND late gold in emit AND no SEARCH_INCOMPLETE on any gold_n>=1 retrieve class.
Do not PASS with incomp=1 on sentinel.
Do not prefix-luck (gold must be late on both lists; independent host check printed).
CAND_CAP=16 after emit, not FINAL. leftover A09 off poke_v=0 PROGRAM=NO.
Headline precision_all=TP/emit_n.
Do not freeze C1 800k / DDR bound / CAND_CAP_FINAL.
No context keys / 65k dir / page-skip this bag.

Bag: results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-STREAM-02/
Marker ASTRA_C1_N4096_STREAM_02_XSIM_PASS
MEM_DEPTH TB-only as needed.
