# WO — ASTRA-C1-N65536-SCALE-01

Owner Anh 2026-09-07: skip optional unseen-SRO as NEXT bag. Open this scale rung.

Auditor 20260907T1550Z ACCEPT_PARTIAL HELDOUT **query surface only** (QSE skip-class).
REJECT 800k / N=65536 auto-start from that audit. **This WO is the owner override for N=65536 only.**

ONE UNKNOWN: same frozen law `qse-v2-intersect-context-02` at **N=65536 records**
(not “N_BUCKETS already 65536”). Instantiate KEEP ctx keys `124be808…` + ctx DUT
`8255a798…` (STREAM-02 two-pointer copy). Do **not** edit those files, STREAM-02
`14f75db7…`, PAGE-SKIP `dab15d76…`, C0 extract `cd7baf49…`, C0 lexicon FILE
`38189974…`, dir FILE `09334e42…`. Named lexicon `qse-v2-lex-semantic-16k-01`
`df0e8833…` copy if needed (xvlog `-i $bag` FIRST; do not silent-shadow C0).

PASS this bag only if:
- N is actually 65536 (contiguous nids). Silent drop to 16384/4096/256 = FAIL.
- FAIL=0. Marker `ASTRA_C1_N65536_SCALE_XSIM_PASS`.
- Late gold nid **65534** (or independently proven k0_idx≥16 AND k1_idx≥16) HITS.
  Sentinel **65535** HITS. `SEARCH_INCOMPLETE` on any `gold_n>=1` retrieve = FAIL
  (do not PASS with incomp=1).
- Direct / fill-template still retrieves labeled gold. Distractor `leak_n=0`.
- Gold hashed BEFORE first xvlog. leftover A09 off. `poke_v=0`. PROGRAM=NO.

If XSim/xelab/host RAM cannot host N=65536: FAIL honestly `FIRST_DIVERGENCE MEM`.
Do not shrink N. Do not plant-only 800k. Do not start N=262144 or N=800000 in this bag.

CAND_CAP=16 after emit, **not** FINAL. Do **not** freeze `CAND_CAP_FINAL` /
`DDR_QUERY_BOUND_FINAL` / C1 800k / BOARD_PASS. Cartesian 16k-style fill is allowed
as **scale stress** but RESULTS must say it does **not** close Master ≥95% / ≥90%
reduction / true semantic mass. 12-entity clone = FAIL. Independent audit tree:
do not write. Do not edit KEEP HELDOUT / 16k / CONTEXT-02 / PAGE-SKIP / STREAM-02.

Bag: `results/A7-NATIVE-GRAPH/ASTRA-C1-N65536-SCALE-01/`
Marker: `ASTRA_C1_N65536_SCALE_XSIM_PASS`

After auditor ACCEPT_PARTIAL + P1 none on **this** bag, parent MAY open
`ASTRA-C1-N262144-SCALE-01` (same law, N=262144, late gold 262142, sentinel 262143).
After that ACCEPT_PARTIAL + P1 none, parent MAY open `ASTRA-C1-N800000-SCALE-01`
(N=800000, sentinel near 799999). **Never** chain 65k+262k+800k in one XSim.
Historical U5 800k plant cannot close C1. Never ACCEPT_BOARD.
