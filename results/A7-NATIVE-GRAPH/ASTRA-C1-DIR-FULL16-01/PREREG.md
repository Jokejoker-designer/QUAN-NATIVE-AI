# PREREG — ASTRA-C1-DIR-FULL16-01

Frozen before xvlog. Independent gold hashed **once** before the **first**
xvlog. PROGRAM=NO (no JTAG / xsdb / COM12 / `write_bitstream` / hw_server /
board program). Does not patch frozen C0 RTL. Instantiates frozen
`a7ng_query_role_extract` + named `a7ng_query_role_keys_relbind` (not edited)
+ frozen `a7ng_sparse_dir_axi` with **parameter** `N_BUCKETS=65536` (C0 file
unedited, AXI idle) + frozen `a7ng_route_valid_gate` inside **existing**
STREAM-02 DUT `a7ng_query_axi_sparse_stream_intersect` instantiated
`.N_BUCKETS(65536)` (hash-gate live SHA `14f75db7…`; do **not** edit that
RTL; hash mismatch ⇒ FAIL this bag). Stream module already parameterizes
`N_BUCKETS`; no wrapper file. Does **not** edit or compile as DUT
`a7ng_query_axi_sparse.sv` (hash-gated MATCH C0). Does **not** compile
`a7ng_query_axi_sparse_intersect.sv` as DUT (KEEP KEY-INTERSECT). Does
**not** compile leftover `a7ng_astra_09_integ_path`. Does not write the
V3.1 tree. Does not inspect or generate N=16384. Does not freeze
`CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`. Does not claim C1 800k closed.
Does not edit KEEP bags KEY-INTERSECT / N4096-INTERSECT / STREAM-INTERSECT-02
/ N4096-STREAM-02 / AXI-BEAT / R1 / R2 / R3 / KEY-RELBIND. Does not write
`D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`. Does not change the merge
scheduler. Does not add context keys. Does not page-skip.

## Primary unknown (Master V1.1 §7, 16-bit exact bucket)

Instantiate frozen `a7ng_sparse_dir_axi` with **N_BUCKETS=65536** (parameter,
do not patch the `.sv`) + same stream-02 walker (instantiate, do not edit
`14f75db7…`) so two facts whose 16-bit keys share bits[11:0] but differ in
the high nibble **do not collide**. Query targeting the high-nibble entity
must **NOT** emit the 12-bit alias nid. Same queries on a 4096-bucket layout
would alias; FULL16 must retrieve the intended nid only. Direct control
`{110,144,145}` if those records remain.

## Claim this bag may close

16-bit exact-bucket gate only (same stream law as STREAM-02).
`RESULT=PASS_THIS_GATE_ONLY` if XSim FAIL=0 **and** alias-high emit is the
intended nid **and** the 12-bit alias nid is absent from that emit **and**
CLASS_direct gold hits `{110,144,145}` if those records remain **and** gold
was not rewritten after FAIL.
`RESULT=FAIL` if the high-nibble query emits the 12-bit alias nid, or
intended nid is missed, or any retrieve class with `gold_n>=1` misses
declared gold, or prints `SEARCH_INCOMPLETE` (incomp does not convert that
to PASS; do not emit PASS marker). Does **not** close Master
evidence-recall ≥95% or candidate-reduction ≥90%. C1 800k remains OPEN.
N=16384 is NOT this bag. `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` stay
NOT_FROZEN. Page-skip and context keys are NOT this bag.

## Not this bag

N=16384. 800k. BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09
as DUT. Silent C0 RTL patch. V3.1 writes. Programming. Context keys.
Page-skip. Loading full posting into BRAM. Patching `a7ng_sparse_dir_axi`.
Editing STREAM-02 RTL. Editing KEEP bags. Freezing DDR/CAND bounds.
Scheduler change.

## Registered bounds (not CAND_CAP_FINAL / not DDR_QUERY_BOUND_FINAL)

```text
N                 = 256
CAND_CAP          = 16   (emit budget after AND; 16 < 256; not FINAL)
INDEX_HEAD        = 4    (overflow page after 4 head ids)
PAGE_BUFFER       = 1 beat (4 IDs); AXI AR arlen=0
RARE_LIST_FIRST   = smaller occupancy fetched first when both need a beat
MERGE_POST_AR_MAX = 256  (SEARCH_INCOMPLETE if exhausted before AND finishes)
N_TABLES          = 4
N_BUCKETS         = 65536  (16-bit exact; bucket = key[15:0])
LAW               = qse-v2-stream-intersect-02
EXTRACT           = qse-v2-role-00 (frozen instantiate; not patched)
RELBIND           = qse-v2-relbind-01 keys instantiated, not edited
LIVE_EPOCH        = 7
MEM_DEPTH         = TB-only; must fit 4*65536*16 directory + postings
CAND_CAP_FINAL    = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
POKE_V            = 0
REDUCTION_X1000   = NOT_EMITTED
HEADLINE          = precision_all = TP/emit_n  (prec_ev1 diagnostic)
ALIAS_LOW         = subj 10 pump, rel 1, obj 11 valve; k0=0x0A01 k1=0x0B01
ALIAS_HIGH        = subj 26 boiler, rel 1, obj 27 header; k0=0x1A01 k1=0x1B01
                    (share bits[11:0] with ALIAS_LOW; differ in high nibble)
k0,k1             = frozen {subj,rel}/{obj,rel}; emit = stream(k0 ∩ k1)
k2                = {rel_id, subj_cue[7:0]}  (indexed, not probed)
k3                = {rel_id, obj_cue[7:0]}  (indexed, not probed)
```

## Hash-gate (must MATCH C0 / KEEP / STREAM-02 DUT before xvlog; FAIL bag on mismatch; do not invent)

```text
a7ng_query_role_extract.sv          cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
qse_role_lexicon.svh                381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
                                    (C0 FILE unedited; not the TB include-path copy)
a7ng_sparse_dir_axi.sv              09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24
a7ng_query_axi_sparse.sv            5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa
a7ng_route_valid_gate.sv            49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385
a7ng_query_role_keys_relbind.sv     93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d
a7ng_query_axi_sparse_intersect.sv  a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c
                                    (KEEP; MATCH; NOT compiled as DUT)
a7ng_query_axi_sparse_stream_intersect.sv
                                    14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac
                                    (STREAM-02 MATCH; instantiate .N_BUCKETS(65536); NOT edited)
```

`a7ng_query_axi_sparse.sv` is hash-gated MATCH C0 and **not** compiled as DUT.

## TB include-path entity extension (not a C0 file patch)

Frozen extract IDs are 1..12, so extract keys never set bits[15:12]. A 16-bit
directory is observationally identical to a 12-bit directory on those keys.
This bag prepends the bag directory on the xvlog include path so
`qse_role_lexicon.svh` compiled with extract is the **bag copy**: frozen
59-word table **plus** `boiler` id=26 and `header` id=27 (12-bit aliases of
`pump`=10 and `valve`=11). C0 file at
`rtl/native_graph/query/qse_role_lexicon.svh` is **not edited** (hash MATCH
`38189974…`). Old ids 1..12 are unchanged. poke_v stays 0. This is not a
context-key law and not a scheduler change.

## Gold discipline

Write `GOLDEN.json` + `query_gold.svh` + `corpus.json`, hash them to
`GOLD_HASH_PRE_XVLOG.txt` **and** `SHA256.txt`, **then** xvlog.
On XSim FAIL: copy `xsim.log` → `xsim_fail_r0.log`. Fix **only** TB token
packing / `G_BYTES` layout / TB MEM_DEPTH. **NEVER** regenerate gold after
FAIL. If labels must change, FAIL the bag (new bag), do not rewrite gold.

`G_BYTES` layout: LSB-first; character 0 at bits [7:0], matching
TB `bytes[8*bi +: 8]`.

Index rebuilt with postings **sorted by nid** (contract). Host twin is
two-pointer AND with CAND_CAP on emit only. Host also records the 12-bit
bucket merge of the alias pair as a diagnostic: high query on 4096 buckets
**would** emit the low alias nid; FULL16 must not.

## ALIAS PAIR (this unknown)

```text
low  : subj=10 pump  rel=1 supplies obj=11 valve   k0=0x0A01 k1=0x0B01
high : subj=26 boiler rel=1 supplies obj=27 header  k0=0x1A01 k1=0x1B01
k0 share bits[11:0] = 0x0A01; differ by 4096 (high nibble 0 vs 1)
k1 share bits[11:0] = 0x0B01; differ by 4096
CLASS_alias_high query "boiler supplies header" must emit high nid only
CLASS_alias_low  query "pump supplies valve"   must not emit high nid
12-bit layout would AND-merge both posting lists
DUT must AR a directory address whose table-0 key >= 4096 on alias_high
CLASS_direct still retrieves {110,144,145} if those records remain
```

## Required query classes (named checks in xsim.log)

```text
direct            → gold hits {110,144,145} if records remain
paraphrase
role_reversal
wrong_relation
wrong_context     → NOT_SELECTIVE (xid still not a key)
distractor        → gold = EXCLUDED set; leak_n; FAIL DISTRACTOR_LEAK if leak
unrelated         → UNRELATED_EMPTY_WALK if emit=0; do not score 0/0 as 1000
high_occupancy
overflow_page
high_id_sentinel
late_gold         → supporting same-law retrieve (not this unknown)
alias_high        → FULL16_HIT intended nid; FAIL if 12-bit alias nid emitted
alias_low         → must not emit high nid
```

Independent gold is label match on `{evidence,subj,rel,obj,ctx}` computed
**before** the walker twin and **before** xvlog. Occupancy fillers are
`evidence=0` and are not gold. CLASS lines report `gold_n, emit_n, tp,
fp_ev1, fp_fill0, prec_ev1, prec_all, rec`. Headline is `precision_all`.
If a **retrieve-class** relevant id is missed, the class FAILs the bag —
`SEARCH_INCOMPLETE` does not convert a gold miss into PASS.

## PASS / FAIL (this gate only)

```text
PASS_THIS_GATE_ONLY  hash-gate MATCH; gold hashed before first xvlog and
                     not rewritten after FAIL; XSim FAIL=0; alias-high
                     intended nid in emit; 12-bit alias nid absent from
                     that emit; CLASS_direct gold hits >0; poke_v=0;
                     leftover A09 not compiled; CAND_CAP=16<256;
                     C1 800k still OPEN; CAND_CAP_FINAL /
                     DDR_QUERY_BOUND_FINAL NOT_FROZEN
FAIL                 alias-high miss; 12-bit alias nid in high emit;
                     direct gold hits==0; retrieve gold miss hidden as
                     SEARCH_INCOMPLETE; hash mismatch; gold edited after
                     FAIL; leftover A09 compiled; C0 patched; stream DUT
                     edited
```
