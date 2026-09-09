# WO — ASTRA-C1-STREAM-INTERSECT-02 (N=256)

Independent audit PLAN.md P0-1 (read-only). Parent after AXI-BEAT auditor 20260907T1115Z ACCEPT_PARTIAL.

Archive: `qse-v2-intersect-01` N=256 KEY-INTERSECT KEEP. Do not silent-patch it.
Do NOT edit N=4096 bag. Do NOT write independent audit tree.
Do NOT patch C0 a7ng_sparse_dir_axi / extract / sparse.
Do NOT mix context keys / 65k dir / page-skip in this bag.
Do NOT load full posting into BRAM.
Do NOT freeze CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL / C1 800k.

NEW law: `qse-v2-stream-intersect-02`
```
postings sorted by nid (contract)
two-pointer merge, page buffer 1 beat (4 IDs)
rare-list-first (smaller occupancy drives)
CAND_CAP applies only AFTER emit
budget exhaust → SEARCH_INCOMPLETE, never empty-as-UNKNOWN
```

NEW RTL: a7ng_query_axi_sparse_stream_intersect.sv
Instantiate frozen extract + relbind + frozen dir. New merge walker only.

ONE UNKNOWN at N=256: late gold MUST appear in emit (place at least one gold nid at posting index ≥16 on both k0 and k1 so cap-then-AND would miss and AND-then-cap / stream merge must hit). Early-gold classes (direct {110,144,145} if same corpus) stay exact vs KEY-INTERSECT control.

PASS iff:
- late-gold class leak/miss = 0 (gold in emit)
- SEARCH_INCOMPLETE not used to hide a miss of declared gold
- direct still retrieves control gold if those records remain
- leftover A09 off poke_v=0 PROGRAM=NO

Bag: results/A7-NATIVE-GRAPH/ASTRA-C1-STREAM-INTERSECT-02/
Marker ASTRA_C1_STREAM_INTERSECT_02_XSIM_PASS only if FAIL=0 and late gold hit.
Headline precision_all = TP/emit_n (prec_ev1 diagnostic only).
