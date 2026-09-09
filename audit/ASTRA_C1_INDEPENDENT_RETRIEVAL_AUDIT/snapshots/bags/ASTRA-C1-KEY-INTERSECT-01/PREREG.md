# PREREG — ASTRA-C1-KEY-INTERSECT-01

Frozen before xvlog. Independent gold hashed **once** before the **first**
xvlog. PROGRAM=NO (no JTAG / xsdb / COM12 / `write_bitstream` / hw_server /
board program). Does not patch frozen C0 RTL. Instantiates frozen
`a7ng_query_role_extract` + named `a7ng_query_role_keys_relbind` (not edited)
+ frozen `a7ng_sparse_dir_axi` + frozen `a7ng_route_valid_gate` inside
**new** `a7ng_query_axi_sparse_intersect`. Does **not** edit or compile as DUT
`a7ng_query_axi_sparse.sv` (hash-gated MATCH C0). Does **not** compile
`a7ng_query_axi_sparse_relbind.sv` as DUT. Does **not** compile leftover
`a7ng_astra_09_integ_path`. Does not write the V3.1 tree. Does not inspect
or generate N>256. Does not freeze `CAND_CAP_FINAL`. Does not claim C1 800k
closed. Does not edit KEEP bags R1 / R2 / R3 / KEY-RELBIND.

FAIL routing (auditor 20260907T0955Z): no threshold drop; no
`relevant=router_union`; no nid-derived keys; no silent C0 patch;
no k2/k3-only rebind as the exclusion mechanism.
New registered law id only: `qse-v2-intersect-01`.

## Primary unknown (Master V1.1 §7, N=256 named key law)

At N=256, new law `qse-v2-intersect-01` (emit ids in **k0∩k1** when both
keys valid; relbind keys reused; k2/k3 not unioned), does CLASS_distractor
`leak_n=0` on R3 excluded gold while CLASS_direct still retrieves its gold
ids (expect `{110,144,145}` for `"pump supplies chiller"`)?

## Claim this bag may close

N=256 intersect key-law gate only.
`RESULT=PASS_THIS_GATE_ONLY` if XSim FAIL=0 **including leak_n=0**
**and** CLASS_direct gold hits >0
**and** distractor gold_n≥1 (excluded evidence=1 nids)
**and** unrelated is not scored 0/0 as 1000/1000
**and** wrong_context is labeled NOT_SELECTIVE
**and** gold was not rewritten after FAIL.
`RESULT=FAIL` if any excluded id appears in emit (`FAIL DISTRACTOR_LEAK`)
or direct gold hits==0 or any other named fail. Does **not** close Master
evidence-recall ≥95% or candidate-reduction ≥90% (those apply at N≥4096 /
800k). C1 800k remains OPEN. N=4096 is NOT STARTED.

## Not this bag

N>256. 800k. BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09
as DUT. Silent C0 RTL patch. V3.1 writes. Programming. Historical U5 close.
Fake context keys. Reuse of query `"supply duct"` + gold `{72,73,74,75}`.
Threshold drop. `relevant=router_union`. nid-derived keys.
k2/k3-only rebind as exclusion. Patching `a7ng_sparse_dir_axi`.

## Registered bounds (not CAND_CAP_FINAL)

```text
N                 = 256
CAND_CAP          = 16   (checkpoint default; 16 < 256)
INDEX_HEAD        = 4    (overflow page after 4 head ids)
N_TABLES          = 4
N_BUCKETS         = 4096
LAW               = qse-v2-intersect-01
EXTRACT           = qse-v2-role-00 (frozen instantiate; not patched)
RELBIND           = qse-v2-relbind-01 keys instantiated, not edited
LIVE_EPOCH        = 7
CAND_CAP_FINAL    = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
POKE_V            = 0
REDUCTION_X1000   = NOT_EMITTED
DISTRACTOR_QUERY  = "pump supplies chiller"
DISTRACTOR_GOLD   = EXCLUDED two-role overlap (wrong-entity / wrong-relation /
                    wrong-object evidence=1). Not retrieve-subset. Not lambda False.
k0,k1             = frozen {subj,rel}/{obj,rel}; emit = k0∩k1 when both valid
k2                = {rel_id, subj_cue[7:0]}  (indexed, not probed)
k3                = {rel_id, obj_cue[7:0]}  (indexed, not probed)
```

## Hash-gate (must MATCH C0 before xvlog; FAIL bag on mismatch; do not invent)

```text
a7ng_query_role_extract.sv  cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
qse_role_lexicon.svh        381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
a7ng_sparse_dir_axi.sv      09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24
a7ng_query_axi_sparse.sv    5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa
a7ng_route_valid_gate.sv    49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385
```

## Gold discipline

Write `GOLDEN.json` + `query_gold.svh` + `corpus.json`, hash them to
`GOLD_HASH_PRE_XVLOG.txt` **and** `SHA256.txt`, **then** xvlog.
On XSim FAIL: copy `xsim.log` → `xsim_fail_r0.log`. Fix **only** TB token
packing / `G_BYTES` layout. **NEVER** regenerate gold after FAIL.
If labels must change, FAIL the bag (new bag), do not rewrite gold.

`G_BYTES` layout: LSB-first; character 0 at bits [7:0], matching
TB `bytes[8*bi +: 8]`.

Distractor gold is computed **before** the walker twin: evidence=1 records
that share two of {subj=pump, rel=supplies, obj=chiller} and mismatch the
third. PSC `{subj=10,rel=1,obj=1}` is **not** in the excluded set.
Reuse R3 excluded nids if labels unchanged.

Index rebuilt with the same relbind function as RTL (host twin). Walker
twin intersects k0 and k1 postings (same as RTL).

## Distractor scoring (frozen before xvlog)

```text
gold_n >= 1 excluded nids
if any excluded id appears in emit:
  print FAIL DISTRACTOR_LEAK
  increment fail
  do not count as tp
also print leak_n, emit_n, fp_ev1, fp_fill0
PASS distractor only if leak_n=0 and gold_n>=1
PASS marker also requires CLASS_direct gold hits >0
do not print rec_x1000=1000 on this class
```

## Required query classes (named checks in xsim.log)

```text
direct            → gold hits >0 required for PASS marker
paraphrase
role_reversal
wrong_relation
wrong_context     → NOT_SELECTIVE + k0–k3 vs direct (xid still not a key)
distractor        → gold = EXCLUDED set; leak_n; FAIL DISTRACTOR_LEAK if leak
unrelated         → UNRELATED_EMPTY_WALK if emit=0; do not score 0/0 as 1000
high_occupancy
overflow_page
high_id_sentinel
```

Independent gold is label match on `{evidence,subj,rel,obj,ctx}` computed
**before** the walker twin and **before** xvlog. Occupancy fillers are
`evidence=0` and are not gold. CLASS lines report `gold_n, emit_n, tp,
fp_ev1, fp_fill0, prec_ev1, rec` except distractor (excluded; `leak_n`;
`rec_undef`). `prec_ev1` excludes fillers from the denominator when
`prec_all` is also printed. If a **retrieve-class** relevant id is beyond
CAND_CAP / unwalked overflow, the class reports `SEARCH_INCOMPLETE` —
never a false UNKNOWN/NO. Excluded ids **not** in emit are not misses.

## PASS / FAIL (this gate only)

```text
PASS_THIS_GATE_ONLY  hash-gate MATCH; gold hashed before first xvlog and
                     not rewritten after FAIL; XSim FAIL=0 including leak_n=0;
                     CLASS_direct gold hits >0; 10 named class markers;
                     n_host=0; CAND_CAP=16<256; poke_v=0; leftover A09 not
                     compiled; distractor gold_n>=1 excluded polarity;
                     unrelated UNRELATED_EMPTY_WALK; wrong_context
                     NOT_SELECTIVE; reduction_x1000 not emitted as cap/N;
                     C1 800k still OPEN
FAIL                 DISTRACTOR_LEAK (excluded id in emit); direct gold
                     hits==0; hash mismatch (do not invent); gold edited
                     after FAIL; walker/packet mismatch; host semantic
                     route; leftover A09 compiled; N>256 generated;
                     distractor gold_n==0; unrelated 0/0 scored 1000/1000;
                     wrong_context claimed as recall win; distractor scored
                     as tp/rec=1000 on excluded ids
```
