# WO — ASTRA-C1-AXI-BEAT-ACCOUNTING-01

Authority: independent audit D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\PLAN.md
+ parent REJECT of C1 scale freeze (N=4096 sentinel SEARCH_INCOMPLETE).

Do NOT edit:
- ASTRA-C1-N4096-INTERSECT-01 (archive on disk)
- ASTRA-C1-KEY-INTERSECT-01 gold/corpus/RTL
- C0 frozen files / a7ng_sparse_dir_axi / a7ng_query_axi_sparse_intersect.sv

ONE UNKNOWN: on frozen N=256 KEY-INTERSECT queries, do **accepted R-beats** (`rvalid && rready`) measure AXI bytes, and are emit IDs **bit-identical** to KEY-INTERSECT gold?

PASS iff:
1. Per-class emit ID lists equal KEY-INTERSECT GOLDEN emit (direct {110,144,145} etc.)
2. RTL counters: DIR_R_BEATS, POST_R_BEATS, TOTAL_AXI_BYTES = 16*(dir+post R-beats)
3. TOTAL_AXI_BYTES >= reported AR×16 with printed ratio (expected ≥1; N256 hoc ~2.67× vs full-drain model is the *model*, this bag measures live R-beats)
4. Do **not** freeze DDR_QUERY_BOUND_FINAL / CAND_CAP_FINAL
5. Do **not** introduce stream-intersect-02 in this bag

Probe on existing intersect wrapper AXI ports (TB or thin named probe module). Counters must be RTL-visible, not host-only.

Replay KEY-INTERSECT corpus/gold **copies hashed**; original bag files unchanged.
leftover A09 off. poke_v=0. PROGRAM=NO.
Hash-gate C0 + intersect SHA a912786f… + relbind 93811ed1…

Bag: results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/
Marker ASTRA_C1_AXI_BEAT_XSIM_PASS only if emit identical AND R-beat counters present.
C1 800k OPEN. N=16384 not this bag. Stream-intersect-02 is NEXT after this auditor ACCEPT.
