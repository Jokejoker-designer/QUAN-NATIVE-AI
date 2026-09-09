# PREREG — ASTRA-C1-N4096-STREAM-02

Frozen before xvlog. Independent gold hashed **once** before the **first**
xvlog. PROGRAM=NO (no JTAG / xsdb / COM12 / `write_bitstream` / hw_server /
board program). Does not patch frozen C0 RTL. Instantiates frozen
`a7ng_query_role_extract` + named `a7ng_query_role_keys_relbind` (not edited)
+ frozen `a7ng_sparse_dir_axi` (C0 geometry, AXI idle) + frozen
`a7ng_route_valid_gate` inside **existing** STREAM-02 DUT
`a7ng_query_axi_sparse_stream_intersect` (hash-gate live SHA `14f75db7…`;
do **not** edit that RTL; hash mismatch ⇒ FAIL this bag). Does **not** edit
or compile as DUT `a7ng_query_axi_sparse.sv` (hash-gated MATCH C0). Does
**not** compile `a7ng_query_axi_sparse_intersect.sv` as DUT (KEEP
KEY-INTERSECT). Does **not** compile leftover `a7ng_astra_09_integ_path`.
Does not write the V3.1 tree. Does not inspect or generate N=16384. Does not
freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`. Does not claim C1 800k
closed. Does not edit KEEP bags KEY-INTERSECT / N4096-INTERSECT /
STREAM-INTERSECT-02 / AXI-BEAT / R1 / R2 / R3 / KEY-RELBIND. Does not write
`D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`.

## Primary unknown (Master V1.1 §7, N=4096 same stream law)

At N=4096, same law `qse-v2-stream-intersect-02` (postings sorted by nid;
two-pointer merge; 1-beat page buffer; rare-list-first; CAND_CAP after emit),
does LATE gold (posting index ≥16 on both k0 and k1, so cap-then-AND would
miss; include a sentinel near 4095) HIT, and do retrieve classes with
`gold_n>=1` FAIL the bag if `SEARCH_INCOMPLETE` / emit miss?

Scale of merge, not prefix luck. Independent host check printed:
`CAP_THEN_AND_WOULD_MISS` vs `STREAM_HIT` with k0/k1 indices.

## Claim this bag may close

N=4096 stream-intersect **scale** gate only (same law as STREAM-02 N=256).
`RESULT=PASS_THIS_GATE_ONLY` if XSim FAIL=0 **and** late gold in emit
**and** no `SEARCH_INCOMPLETE` on any retrieve class with `gold_n>=1`
**and** CLASS_direct gold hits >0 (control `{110,144,145}` if those records
remain) **and** gold was not rewritten after FAIL.
`RESULT=FAIL` if late gold missed, or any retrieve class with `gold_n>=1`
misses declared gold, or prints `SEARCH_INCOMPLETE` (incomp does not convert
that to PASS; do not emit PASS marker). Does **not** close Master
evidence-recall ≥95% or candidate-reduction ≥90%. C1 800k remains OPEN.
N=16384 is NOT this bag. `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` stay
NOT_FROZEN.

## Not this bag

N=16384. 800k. BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09
as DUT. Silent C0 RTL patch. V3.1 writes. Programming. Context keys. 65k
directory. Page-skip. Loading full posting into BRAM. Patching
`a7ng_sparse_dir_axi`. Editing KEY-INTERSECT / N4096-INTERSECT /
STREAM-INTERSECT-02 / AXI-BEAT bags. Freezing DDR/CAND bounds. Silent patch
of STREAM-02 RTL.

## Registered bounds (not CAND_CAP_FINAL / not DDR_QUERY_BOUND_FINAL)

```text
N                 = 4096
CAND_CAP          = 16   (emit budget after AND; 16 < 4096; not FINAL)
INDEX_HEAD        = 4    (overflow page after 4 head ids)
PAGE_BUFFER       = 1 beat (4 IDs); AXI AR arlen=0
RARE_LIST_FIRST   = smaller occupancy fetched first when both need a beat
MERGE_POST_AR_MAX = 256  (SEARCH_INCOMPLETE if exhausted before AND finishes)
N_TABLES          = 4
N_BUCKETS         = 4096
LAW               = qse-v2-stream-intersect-02
EXTRACT           = qse-v2-role-00 (frozen instantiate; not patched)
RELBIND           = qse-v2-relbind-01 keys instantiated, not edited
LIVE_EPOCH        = 7
MEM_DEPTH         = TB-only; must fit 4096-record index
CAND_CAP_FINAL    = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
POKE_V            = 0
REDUCTION_X1000   = NOT_EMITTED
HEADLINE          = precision_all = TP/emit_n  (prec_ev1 diagnostic)
HIGH_ID_SENTINEL  = nid 4095 (near 4095)
k0,k1             = frozen {subj,rel}/{obj,rel}; emit = stream(k0 ∩ k1)
k2                = {rel_id, subj_cue[7:0]}  (indexed, not probed)
k3                = {rel_id, obj_cue[7:0]}  (indexed, not probed)
```

## Hash-gate (must MATCH C0 / STREAM-02 DUT before xvlog; FAIL bag on mismatch; do not invent)

```text
a7ng_query_role_extract.sv                 cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
qse_role_lexicon.svh                       381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
a7ng_sparse_dir_axi.sv                     09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24
a7ng_query_axi_sparse.sv                   5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa
a7ng_route_valid_gate.sv                   49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385
a7ng_query_role_keys_relbind.sv            93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d
a7ng_query_axi_sparse_intersect.sv         a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c
                                           (KEEP; MATCH; NOT compiled as DUT)
a7ng_query_axi_sparse_stream_intersect.sv  14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac
                                           (STREAM-02 DUT; MATCH; instantiate; do not edit)
```

`a7ng_query_axi_sparse.sv` is hash-gated MATCH C0 and **not** compiled as DUT.
Stream DUT hash mismatch ⇒ FAIL this bag (do not silent-patch RTL).

## Gold discipline

Write `GOLDEN.json` + `query_gold.svh` + `corpus.json`, hash them to
`GOLD_HASH_PRE_XVLOG.txt` **and** `SHA256.txt`, **then** xvlog.
On XSim FAIL: copy `xsim.log` → `xsim_fail_r0.log`. Fix **only** TB token
packing / `G_BYTES` layout / TB MEM_DEPTH. **NEVER** regenerate gold after
FAIL. If labels must change, FAIL the bag (new bag), do not rewrite gold.

`G_BYTES` layout: LSB-first; character 0 at bits [7:0], matching
TB `bytes[8*bi +: 8]`.

Index rebuilt with postings **sorted by nid** (contract). Host twin is
two-pointer AND with CAND_CAP on emit only. Cap-then-AND of first 16 of
each list is recorded as a diagnostic: LATE gold must be absent there
and present in stream emit. Host prints `CAP_THEN_AND_WOULD_MISS` vs
`STREAM_HIT` with k0/k1 posting indices.

## LATE_GOLD (this unknown)

```text
gold nid at posting index ≥16 on both k0 and k1
sentinel / late nid near 4095
cap-then-AND (first CAND_CAP of each list) misses
stream AND-then-cap / two-pointer must hit
SEARCH_INCOMPLETE on gold_n>=1 retrieve class FAILS the bag
  (do not emit PASS marker; do not hide a miss)
CLASS_direct still retrieves {110,144,145} if those records remain
Do not prefix-luck (independent host check printed)
```

## Required query classes (named checks in xsim.log)

```text
direct            → gold hits >0; control {110,144,145} if records remain
paraphrase
role_reversal
wrong_relation
wrong_context     → NOT_SELECTIVE (xid still not a key)
distractor        → gold = EXCLUDED set; leak_n; FAIL DISTRACTOR_LEAK if leak
unrelated         → UNRELATED_EMPTY_WALK if emit=0; do not score 0/0 as 1000
high_occupancy
overflow_page
high_id_sentinel  → nid 4095; gold_n>=1 miss or SEARCH_INCOMPLETE = FAIL
late_gold         → LATE_GOLD_HIT required for PASS marker
```

Independent gold is label match on `{evidence,subj,rel,obj,ctx}` computed
**before** the walker twin and **before** xvlog. Occupancy fillers are
`evidence=0` and are not gold. CLASS lines report `gold_n, emit_n, tp,
fp_ev1, fp_fill0, prec_ev1, prec_all, rec`. Headline is `precision_all`.
If a **retrieve-class** relevant id is missed, the class FAILs the bag —
`SEARCH_INCOMPLETE` does not convert a gold miss into PASS. If a retrieve
class with `gold_n>=1` prints `SEARCH_INCOMPLETE`, the bag FAILs even if
gold already appeared in emit.

## PASS / FAIL (this gate only)

```text
PASS_THIS_GATE_ONLY  hash-gate MATCH (incl. stream DUT 14f75db7…);
                     gold hashed before first xvlog and not rewritten
                     after FAIL; XSim FAIL=0; late gold in emit;
                     no SEARCH_INCOMPLETE on gold_n>=1 retrieve class;
                     CLASS_direct gold hits >0; poke_v=0; leftover A09
                     not compiled; CAND_CAP=16<4096; C1 800k still OPEN;
                     CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL NOT_FROZEN
FAIL                 late gold miss; SEARCH_INCOMPLETE on gold_n>=1
                     retrieve class; direct gold hits==0; hash mismatch
                     (do not invent / do not edit stream RTL); gold edited
                     after FAIL; leftover A09 compiled; N=16384 generated;
                     C0 patched; CAND_CAP>=N
```
