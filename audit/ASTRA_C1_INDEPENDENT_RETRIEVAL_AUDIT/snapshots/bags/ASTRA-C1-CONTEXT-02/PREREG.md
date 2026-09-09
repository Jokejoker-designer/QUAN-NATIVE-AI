# PREREG — ASTRA-C1-CONTEXT-02

Frozen before xvlog. Independent gold hashed **once** before the **first**
xvlog. PROGRAM=NO (no JTAG / xsdb / COM12 / `write_bitstream` / hw_server /
board program). Does not patch frozen C0 RTL. Instantiates frozen
`a7ng_query_role_extract` + **NEW** `a7ng_query_role_keys_ctx` + frozen
`a7ng_sparse_dir_axi` (C0 geometry, AXI idle) + frozen `a7ng_route_valid_gate`
inside **new** `a7ng_query_axi_sparse_intersect_context`. Walker is the
STREAM-02 two-pointer (1-beat, rare-first, CAND_CAP after emit) in a thin
named wrapper. Does **not** edit `a7ng_query_axi_sparse_stream_intersect.sv`
(hash-gated MATCH `14f75db7…`; **not** compiled as DUT). Does **not** edit
PAGE-SKIP `dab15d76…`. Does **not** compile leftover `a7ng_astra_09_integ_path`.
Does not write the V3.1 tree. Does not inspect or generate N>256. Does not
freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`. Does not claim C1 800k
closed. Does not edit KEEP bags PAGE-SKIP / STREAM-02 / DIR-FULL16 /
N4096-STREAM-02 / KEY-INTERSECT / AXI-BEAT. Does not write
`D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`. No bag `qse_role_lexicon.svh`
shadow. xvlog `-i` C0 query dir **first**.

## Primary unknown (Master V1.1 §7, N=256 context key law)

At N=256, new law `qse-v2-intersect-context-02` (ctx_valid independent of a
zero ctx_id *inside the packer*; if ctx_valid then k0/k1 fold packed
`{subj,rel,ctx}` / `{obj,rel,ctx}`; else pass through frozen `{subj,rel}` /
`{obj,rel}`; emit = stream(k0 ∩ k1)), does CLASS_wrong_context emit differ
from CLASS_direct `{110,144,145}` while CLASS_direct still retrieves those
gold ids?

C0 extract does not export `xh`. C0 lexicon CLS_CTX ids are `{1,2}` never 0,
so `ctx_valid := (ctx_id != 0)` ≡ `xh` on this freeze. Host dual-indexes
plain keys (unbound queries) **and** ctx-packed keys (bound queries). Do
**not** derive keys from nid. Do **not** set `relevant=router_union`. If C0
cannot distinguish wrong_context, FAIL the bag honestly (keep NOT_SELECTIVE).

## Claim this bag may close

N=256 context-key gate only.
`RESULT=PASS_THIS_GATE_ONLY` if XSim FAIL=0 **and** marker
`ASTRA_C1_CONTEXT_02_XSIM_PASS` **and** CLASS_wrong_context emit ≠
CLASS_direct **and** CLASS_direct gold hits >0 (control `{110,144,145}`)
**and** SEARCH_INCOMPLETE is not used to hide a miss of declared gold
**and** gold was not rewritten after FAIL.
`RESULT=FAIL` if wrong_context emit equals direct, or direct gold hits==0,
or any retrieve class with `gold_n>=1` misses declared gold (incomp does
not convert that to PASS), or C0 cannot bind a distinguishing ctx token.
Does **not** close Master evidence-recall ≥95% or candidate-reduction ≥90%.
C1 800k remains OPEN. `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` stay
NOT_FROZEN. BOARD_PASS not claimed.

## Not this bag

N>256. 800k. BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09
as DUT. Silent C0 RTL patch. V3.1 writes. Programming. Page-skip scheduler
change. N=16384. Loading full posting into BRAM. Patching
`a7ng_sparse_dir_axi`. Editing STREAM-02 `14f75db7…` / PAGE-SKIP
`dab15d76…`. Editing KEEP bags. nid-derived keys. `relevant=router_union`.
Bag lexicon shadow.

## Registered bounds (not CAND_CAP_FINAL / not DDR_QUERY_BOUND_FINAL)

```text
N                 = 256
CAND_CAP          = 16   (emit budget after AND; 16 < 256; not FINAL)
INDEX_HEAD        = 4
PAGE_BUFFER       = 1 beat (4 IDs); AXI AR arlen=0
RARE_LIST_FIRST   = smaller occupancy fetched first when both need a beat
MERGE_POST_AR_MAX = 256
N_TABLES          = 4
N_BUCKETS         = 4096
LAW               = qse-v2-intersect-context-02
EXTRACT           = qse-v2-role-00 (frozen instantiate; not patched)
CTX_KEYS          = qse-v2-intersect-context-02 (NEW named module)
LIVE_EPOCH        = 7
CAND_CAP_FINAL    = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
POKE_V            = 0
REDUCTION_X1000   = NOT_EMITTED
HEADLINE          = precision_all = TP/emit_n  (prec_ev1 diagnostic)
k0,k1             = frozen {subj,rel}/{obj,rel} when !ctx_valid;
                    packed {subj,ctx[3:0],rel[3:0]}/{obj,ctx[3:0],rel[3:0]}
                    when ctx_valid
k2                = {rel_id, ctx_id}  (indexed, not probed)
k3                = {subj_id, ctx_id} (indexed, not probed)
host_index        = always plain k0/k1; also ctx-packed k0/k1 if record ctx_valid
```

## Hash-gate (must MATCH C0 / KEEP before xvlog; FAIL bag on mismatch; do not invent)

```text
a7ng_query_role_extract.sv          cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
qse_role_lexicon.svh                381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
a7ng_sparse_dir_axi.sv              09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24
a7ng_query_axi_sparse.sv            5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa
a7ng_route_valid_gate.sv            49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385
a7ng_query_role_keys_relbind.sv     93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d
                                    (KEEP; MATCH; NOT compiled)
a7ng_query_axi_sparse_intersect.sv  a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c
                                    (KEEP; MATCH; NOT compiled as DUT)
a7ng_query_axi_sparse_stream_intersect.sv
                                    14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac
                                    (KEEP STREAM-02; MATCH; NOT compiled as DUT)
a7ng_query_axi_sparse_page_skip.sv  dab15d76da42b33a934d8c68c1108665a79b8544d44b4986b840972841135817
                                    (KEEP PAGE-SKIP; MATCH; NOT compiled as DUT)
```

## Gold discipline

Write `GOLDEN.json` + `query_gold.svh` + `corpus.json`, hash them to
`GOLD_HASH_PRE_XVLOG.txt` **and** `SHA256.txt`, **then** xvlog.
On XSim FAIL: copy `xsim.log` → `xsim_fail_r0.log`. Fix **only** TB token
packing / `G_BYTES` layout. **NEVER** regenerate gold after FAIL.
If labels must change, FAIL the bag (new bag), do not rewrite gold.

`G_BYTES` layout: LSB-first; character 0 at bits [7:0], matching
TB `bytes[8*bi +: 8]`.

Index rebuilt with postings **sorted by nid** (contract). Host twin is
two-pointer AND with CAND_CAP on emit only. Records are dual-indexed:
plain `{subj,rel}` always, plus ctx-packed keys when the record bound a
C0 ctx token.

## Required query classes (named checks in xsim.log)

```text
direct            → gold hits >0; control {110,144,145} bit-identical
paraphrase
role_reversal
wrong_relation
wrong_context     → CONTEXT_SELECTIVE; emit ≠ direct; gold {144} (water)
distractor        → gold = EXCLUDED set; leak_n; FAIL DISTRACTOR_LEAK if leak
unrelated         → UNRELATED_EMPTY_WALK if emit=0; do not score 0/0 as 1000
high_occupancy
overflow_page
high_id_sentinel
late_gold         → LATE_GOLD_HIT required (control; not this unknown)
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
                     not rewritten after FAIL; XSim FAIL=0; marker
                     ASTRA_C1_CONTEXT_02_XSIM_PASS; wrong_context emit ≠
                     direct; CLASS_direct gold hits >0 and emit
                     {110,144,145}; poke_v=0; leftover A09 not compiled;
                     CAND_CAP=16<256; C0 59-word runtime; no bag lexicon;
                     STREAM-02 14f75db7 not compiled; PAGE-SKIP not
                     compiled; C1 800k still OPEN; CAND_CAP_FINAL /
                     DDR_QUERY_BOUND_FINAL NOT_FROZEN
FAIL                 wrong_context emit == direct; direct gold hits==0;
                     retrieve gold miss hidden as SEARCH_INCOMPLETE;
                     hash mismatch; gold edited after FAIL; leftover A09
                     compiled; N>256 generated; C0 patched; nid-derived
                     keys; bag lexicon shadow
```
