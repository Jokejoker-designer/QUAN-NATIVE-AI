# PREREG — ASTRA-C1-SYNONYM-LAW-01

Frozen before xvlog. Independent gold hashed **once** before the **first**
xvlog. PROGRAM=NO (no JTAG / xsdb / COM12 / `write_bitstream` / hw_server /
board program). Does not patch frozen C0 RTL. Instantiates frozen
`a7ng_query_role_extract` (hash-gate MATCH `cd7baf49…`, not edited) + **NEW**
named synonym overlay `qse-v2-relctx-synonym-01` + frozen
`a7ng_query_role_keys_ctx` (hash-gate MATCH `124be808…`, not edited) + frozen
`a7ng_sparse_dir_axi` (parameter `N_BUCKETS=65536`, file unedited, AXI idle)
+ frozen `a7ng_route_valid_gate` inside **NEW** thin DUT wrap
`a7ng_query_axi_sparse_intersect_synonym` (STREAM-02 two-pointer walker copy;
not an edit of STREAM-02 file `14f75db7…`; not an edit of context DUT
`8255a798…`). Context DUT **not** compiled as DUT. STREAM-02 file **not**
compiled as DUT. PAGE-SKIP `dab15d76…` **not** compiled. leftover
`a7ng_astra_09_integ_path` **not** compiled. Does not write the V3.1 tree.
Does not freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`. Does not claim
C1 800k closed. Does not edit KEEP bags including SEMANTIC-NL-01 (honest
FAIL evidence). Does not write
`D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`. Does not relabel gold as
`{131}`.

Named lexicon law `qse-v2-lex-semantic-16k-01` is **copied** from KEEP
UNSEEN-SRO-16K / SEMANTIC-16K (SHA `df0e8833…`), not rewritten:

- Named file: bag `qse_role_lexicon_semantic_16k.svh` (SHA in RESULTS / PRE).
- Include-name: bag `qse_role_lexicon.svh` is a one-line `` `include `` of
  the named file.
- xvlog `-i $bag -i $incq -i $incc` — bag **FIRST**.
- C0 FILE `rtl/native_graph/query/qse_role_lexicon.svh` remains unedited
  (hash-gate MATCH `38189974…`).

Named synonym table `qse-v2-relctx-synonym-01`:

- Canonical: `rtl/native_graph/query/qse_relctx_synonym_01.svh`
- Bag copy byte-identical (hash-gated).
- Overlay module: `a7ng_query_role_relctx_synonym.sv`
- Alias: REL/RELCTX id **1** (`supply`/`supplies`) → REL id **4** (`feeds`/`feed`)
- Rebuilds pack_plain `{subj,rel_syn}` / `{obj,rel_syn}` then frozen ctx keys.

Corpus `corpus.json` is **copied hashed** from KEEP
`ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` SHA
`6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597`.
Host does **not** rewrite corpus.

**N=16384** (KEEP copy). If XSim cannot host 16384, FAIL honestly with
`FIRST_DIVERGENCE MEM`. Do **not** silently drop to N=256.

## Primary unknown (Master V1.1 §7, named synonym law)

Auditor `20260907T1910Z` ACCEPT_PARTIAL of SEMANTIC-NL measurement; honest
FAIL `NOT_SELECTIVE_NL`; required fix is a **NEW named synonym law**, not a
silent C0 extract patch. This bag's one unknown:

> Named overlay so `"what does the boiler supply to the header"` retrieves
> fill-meaning gold `{120,121,122}` (feeds), **not** cartesian
> `"boiler supplies header"` nid 131.

Frozen extract still binds `supply` RELCTX → REL id=1 (keys 3329/3585).
That frozen keys_match vs fill **must stay 0** (proves C0 unpatched).
Synonym overlay remaps rel 1→4 so DUT keys become fill 3332/3588 and the
walker HITs `{120,121,122}`. Do **not** relabel gold as `{131}`.

NL probe:

```text
fill_template  "boiler feeds header"                       k0=3332 k1=3588  SRO=(13,4,14)
nl_synonym     "what does the boiler supply to the header"  frozen supply RELCTX→REL id=1
                                                            frozen k0=3329 k1=3585
                                                            synonym rel=4 keys 3332/3588
unrelated      "payroll tax form"                           empty walk
```

Independent gold for **that meaning** (boiler feeds header) remains fill-grid
`{120,121,122}`. Marker `ASTRA_C1_SYNONYM_LAW_XSIM_PASS` **only** if
`NL_GOLD_HIT` tp=3 on `{120,121,122}` AND FAIL=0 AND fill-template control
hits AND frozen keys_match=0 AND synonym keys_match=1 AND emit is not nid
131. `SEARCH_INCOMPLETE` on `gold_n>=1` retrieve = FAIL. C1 800k stays OPEN.
BOARD_PASS not claimed.

## Claim this bag may close

Named synonym-law retrieve gate only (not 800k close, not Master ≥95%).
`RESULT=PASS_THIS_GATE_ONLY` if XSim FAIL=0 **and** marker
`ASTRA_C1_SYNONYM_LAW_XSIM_PASS` **and** N actually 16384 **and**
frozen keys_match=0 vs fill-template **and** synonym keys remap to fill
**and** labeled fill-meaning gold HIT `{120,121,122}` **and** fill-template
control still hits `{120,121,122}` **and** emit is not `{131}` **and**
`SEARCH_INCOMPLETE` is not used to hide a miss **and** gold was not
rewritten after FAIL **and** KEEP bags unmodified **and** C0 extract /
C0 lexicon FILE unedited.
Does **not** close Master evidence-recall ≥95% or candidate-reduction ≥90%.
C1 800k remains OPEN. `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` stay
NOT_FROZEN. BOARD_PASS not claimed.

## Not this bag

800k. BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09 as DUT.
Silent C0 RTL patch. Silent C0 extract alias `supply`↔`feeds`. V3.1 writes.
Programming. Page-skip scheduler change. Loading full posting into BRAM.
Patching `a7ng_sparse_dir_axi`. Editing STREAM-02 `14f75db7…` / PAGE-SKIP
`dab15d76…` / ctx keys `124be808…` / context DUT `8255a798…`. Editing KEEP
bags including SEMANTIC-NL-01 / UNSEEN-SRO-16K-R2 / UNSEEN-SRO-16K /
HELDOUT / SEMANTIC-16K. nid-derived keys. `relevant=router_union`.
Relabeling gold as `{131}`.

## Registered bounds (not CAND_CAP_FINAL / not DDR_QUERY_BOUND_FINAL)

```text
N                 = 16384
CAND_CAP          = 16   (emit budget after AND; 16 < 16384; not FINAL)
INDEX_HEAD        = 4
PAGE_BUFFER       = 1 beat (4 IDs); AXI AR arlen=0
RARE_LIST_FIRST   = smaller occupancy fetched first when both need a beat
MERGE_POST_AR_MAX = 256
N_TABLES          = 4
N_BUCKETS         = 65536  (16-bit exact; instantiate frozen dir parameter)
LAW               = qse-v2-relctx-synonym-01
CTX_LAW           = qse-v2-intersect-context-02 (keys instantiate, not edited)
LEXICON_LAW       = qse-v2-lex-semantic-16k-01 (copied named df0e8833)
EXTRACT           = qse-v2-role-00 (frozen instantiate; not patched)
LIVE_EPOCH        = 7
MEM_DEPTH         = TB-only; must fit 4*65536*16 directory + postings
CAND_CAP_FINAL    = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
POKE_V            = 0
REDUCTION_X1000   = NOT_EMITTED
HEADLINE          = precision_all = TP/emit_n  (prec_ev1 diagnostic)
fill_template_control = "boiler feeds header"  k0=3332 k1=3588
nl_synonym            = "what does the boiler supply to the header"
heldout_not_this      = "what does the boiler feed to the header" (same keys)
gold_nl               = {120,121,122}  NOT {131}
```

## Hash-gate (must MATCH C0 / KEEP before xvlog; FAIL bag on mismatch; do not invent)

```text
a7ng_query_role_extract.sv          cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
qse_role_lexicon.svh                381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
                                    (C0 FILE KEEP unedited; NOT runtime this bag)
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
a7ng_query_role_keys_ctx.sv         124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1
                                    (CONTEXT-02 KEEP; MATCH instantiate; NOT edited)
a7ng_query_axi_sparse_intersect_context.sv
                                    8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989
                                    (CONTEXT-02 KEEP; MATCH; NOT compiled as DUT; NOT edited)
qse_role_lexicon_semantic_16k.svh   df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4
                                    (copied named law; NOT rewritten)
```

Live Get-FileHash in `run_xsim.ps1` is authority; mismatch FAILs the bag.

## Gold discipline

Write `GOLDEN.json` + `query_gold.svh`; corpus/named lexicon are KEEP copies
(not regenerated). Hash gold+named-lex+corpus+synonym-table to
`GOLD_HASH_PRE_XVLOG.txt` **and** `SHA256.txt`, **then** xvlog.
On XSim FAIL: copy `xsim.log` → `xsim_fail_r0.log`. Fix **only** TB token
packing / `G_BYTES` layout / TB MEM_DEPTH. **NEVER** regenerate gold after
FAIL. If labels must change, FAIL the bag (new bag), do not rewrite gold.
Do not fake NL keys. Do not set relevant = walker emit. Do not relabel
gold as `{131}`.

`G_BYTES` layout: LSB-first; character 0 at bits [7:0], matching
TB `bytes[8*bi +: 8]`.

Index rebuilt with postings **sorted by nid** (contract). Host twin is
two-pointer AND with CAND_CAP on emit only after synonym remap.

## Required query classes (named checks in xsim.log)

```text
fill_template  → FILL_TEMPLATE_HIT; gold {120,121,122}; cartesian control
nl_synonym     → FROZEN_KEYS_VS_FILL keys_match=0 vs fill 3332/3588
                 SYN_KEYS_VS_FILL keys_match=1 (overlay remapped)
                 NL_GOLD_HIT tp=3 emit {120,121,122} not nid 131
unrelated      → UNRELATED_EMPTY_WALK if emit=0; do not score 0/0 as 1000
```

CLASS lines report `gold_n, emit_n, tp, fp_ev1, fp_fill0, prec_ev1,
prec_all, rec`. Headline is `precision_all`. If a **retrieve-class**
relevant id is missed, the class FAILs the bag — `SEARCH_INCOMPLETE` does
not convert a gold miss into PASS. Marker is **not** emitted on that FAIL.

## PASS / FAIL (this gate only)

```text
PASS_THIS_GATE_ONLY  hash-gate MATCH; gold hashed before first xvlog and
                     not rewritten after FAIL; XSim FAIL=0; marker
                     ASTRA_C1_SYNONYM_LAW_XSIM_PASS; N=16384;
                     FILL_TEMPLATE_HIT; frozen keys_match=0 AND
                     synonym keys_match=1 AND NL_GOLD_HIT tp=3 on
                     {120,121,122} not nid 131;
                     SEARCH_INCOMPLETE absent on gold_n>=1;
                     poke_v=0; leftover A09 not compiled;
                     CAND_CAP=16<16384; named lexicon df0e8833 copied;
                     C0 FILE unedited; C0 extract unedited;
                     STREAM-02 14f75db7 not compiled;
                     context DUT 8255a798 not compiled as DUT;
                     PAGE-SKIP not compiled; C1 800k still OPEN;
                     CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL NOT_FROZEN;
                     BOARD_PASS not claimed
FAIL                 fill-template control miss; frozen extract aliased
                     (C0 patch); synonym overlay did not remap;
                     gold miss; emit nid 131; gold relabeled to {131};
                     retrieve gold miss hidden as SEARCH_INCOMPLETE;
                     N dropped to clone; hash mismatch; gold edited after
                     FAIL; leftover A09 compiled; C0 patched; nid-derived
                     keys; silent C0 lexicon claim; XSim cannot host 16384
                     (FIRST_DIVERGENCE MEM)
```
