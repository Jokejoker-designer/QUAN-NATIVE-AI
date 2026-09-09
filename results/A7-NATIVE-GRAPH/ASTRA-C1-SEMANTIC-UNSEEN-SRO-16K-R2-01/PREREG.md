# PREREG — ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01

Frozen before xvlog. Independent gold hashed **once** before the **first**
xvlog. PROGRAM=NO (no JTAG / xsdb / COM12 / `write_bitstream` / hw_server /
board program). Does not patch frozen C0 RTL. Instantiates frozen
`a7ng_query_role_extract` + frozen `a7ng_query_role_keys_ctx` (hash-gate
MATCH `124be808…`, not edited) + frozen `a7ng_sparse_dir_axi` (parameter
`N_BUCKETS=65536`, file unedited, AXI idle) + frozen `a7ng_route_valid_gate`
inside frozen `a7ng_query_axi_sparse_intersect_context` (hash-gate MATCH
`8255a798…`; STREAM-02 two-pointer walker; not edited). STREAM-02 file
`a7ng_query_axi_sparse_stream_intersect.sv` hash-gated MATCH `14f75db7…`;
**not** compiled as DUT; **not** edited. PAGE-SKIP `dab15d76…` **not**
compiled. leftover `a7ng_astra_09_integ_path` **not** compiled. Does not
write the V3.1 tree. Does not freeze `CAND_CAP_FINAL` /
`DDR_QUERY_BOUND_FINAL`. Does not claim C1 800k closed. Does not edit KEEP
bag `ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` (corpus/lex copied hashed).
Does not edit KEEP UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K / CONTEXT-02 /
PAGE-SKIP / STREAM-02. Does not write
`D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`.

Named lexicon law `qse-v2-lex-semantic-16k-01` is **copied** from KEEP
UNSEEN-SRO-16K / SEMANTIC-16K (SHA `df0e8833…`), not rewritten:

- Named file: bag `qse_role_lexicon_semantic_16k.svh` (SHA in RESULTS / PRE).
- Include-name: bag `qse_role_lexicon.svh` is a one-line `` `include `` of
  the named file.
- xvlog `-i $bag -i $incq -i $incc` — bag **FIRST**.
- C0 FILE `rtl/native_graph/query/qse_role_lexicon.svh` remains unedited
  (hash-gate MATCH `38189974…`).

Corpus `corpus.json` is **copied hashed** from KEEP
`ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` SHA
`6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597`.
Plants 123–130 are the same eight off-grid C0 HVAC SROs. Host does **not**
rewrite corpus.

**N=16384** (registered). If XSim cannot host 16384, FAIL honestly with
`FIRST_DIVERGENCE MEM`. Do **not** silently drop to N=256.

## Primary unknown (Master V1.1 §7, remaining planted retrieve)

Auditor `20260907T1755Z` ACCEPT_PARTIAL closed KEEP 16K as **1-of-8**
retrieve (nid 123). This bag's one unknown:

> N=16384 same plants 123–130 — query **each** of 8 off-grid SROs; each
> HIT its nid; unbound SRO still `UNBOUND_EMPTY_WALK` not `{120,121,122}`.
> `SEARCH_INCOMPLETE` on any of 8 retrieve = FAIL.

```text
nid 123  text="chiller supplies condenser"         SRO=(1,1,2)
nid 124  text="chiller requires evaporator"        SRO=(1,2,3)
nid 125  text="compressor supplies condenser"      SRO=(4,1,2)
nid 126  text="ahu connects duct"                  SRO=(6,3,7)
nid 127  text="pump supplies valve"                SRO=(10,1,11)
nid 128  text="tower discharges condenser"         SRO=(9,8,2)
nid 129  text="sensor isolates ahu"                SRO=(12,5,6)
nid 130  text="evaporator bypasses compressor"     SRO=(3,6,4)
```

Fill-grid control `{120,121,122}` `"boiler feeds header"` SRO=(13,4,14)
must still HIT. Unbound `"boiler feeds chiller"` SRO=(13,4,1) is **not
indexed**; shares fill-grid k0 so k0-only would leak `{120,121,122}`.

`SEARCH_INCOMPLETE` on any of 8 retrieve = FAIL. C1 800k stays OPEN.
BOARD_PASS not claimed.

## Claim this bag may close

N=16384 unseen-SRO **8/8 retrieve** gate only (PLAN bag 7 remainder planted
classes, not 800k close, not Master ≥95%).
`RESULT=PASS_THIS_GATE_ONLY` if XSim FAIL=0 **and** marker
`ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS` **and** N actually 16384
**and** all 8 planted nids 123–130 HIT **and** unbound does not emit
`{120,121,122}` **and** fill-template control still hits `{120,121,122}`
**and** `SEARCH_INCOMPLETE` is not used to hide a miss **and** gold was
not rewritten after FAIL **and** KEEP 16K bag unmodified.
`RESULT=FAIL` if any planted nid misses, or unbound emits fill-grid
neighbors, or any retrieve class with `gold_n>=1` misses declared gold
(incomp does not convert that to PASS), or N is dropped. Does **not**
close Master evidence-recall ≥95% or candidate-reduction ≥90%. C1 800k
remains OPEN. `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` stay NOT_FROZEN.
BOARD_PASS not claimed.

## Not this bag

800k. BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09 as DUT.
Silent C0 RTL patch. V3.1 writes. Programming. Page-skip scheduler change.
Editing KEEP UNSEEN-SRO-16K-01. Editing STREAM-02 / PAGE-SKIP / ctx keys /
context DUT. nid-derived keys. `relevant=router_union`. Silent C0 lexicon
claim. Silent drop to N=256. N=65536. C1 800k close. True NL hold-out.
Independent audit tree writes.

## Registered bounds (not CAND_CAP_FINAL / not DDR_QUERY_BOUND_FINAL)

```text
N                 = 16384
CAND_CAP          = 16   (emit budget after AND; 16 < 16384; not FINAL)
INDEX_HEAD        = 4
PAGE_BUFFER       = 1 beat (4 IDs); AXI AR arlen=0
RARE_LIST_FIRST   = smaller occupancy fetched first when both need a beat
MERGE_POST_AR_MAX = 256
N_TABLES          = 4
N_BUCKETS         = 65536
LAW               = qse-v2-intersect-context-02
LEXICON_LAW       = qse-v2-lex-semantic-16k-01 (copied named df0e8833)
EXTRACT           = qse-v2-role-00 (frozen instantiate; not patched)
CTX_KEYS          = qse-v2-intersect-context-02 (instantiate, not edited)
LIVE_EPOCH        = 7
MEM_DEPTH         = TB-only; must match KEEP 286514
CAND_CAP_FINAL    = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
POKE_V            = 0
REDUCTION_X1000   = NOT_EMITTED
HEADLINE          = precision_all = TP/emit_n  (prec_ev1 diagnostic)
planted_n         = 8 off-grid C0 HVAC SROs at nids 123..130 (ALL queried)
unbound_sro       = (13,4,1) boiler feeds chiller       not indexed
fill_grid         = {120,121,122}
fill_template_control = "boiler feeds header"
corpus_sha        = 6991adc7… (KEEP copy; not rewritten)
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
                                    (CONTEXT-02 KEEP; MATCH instantiate as DUT; NOT edited)
qse_role_lexicon_semantic_16k.svh   df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4
                                    (copied named law; NOT rewritten)
corpus.json                         6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597
                                    (KEEP UNSEEN-SRO-16K copy; NOT rewritten)
```

Live Get-FileHash in `run_xsim.ps1` is authority; mismatch FAILs the bag.

## Gold discipline

Load copied `corpus.json` (do not rewrite). Write `GOLDEN.json` +
`query_gold.svh` for 11 queries (fill + 8 plants + unbound + unrelated).
Hash gold+named-lex+copied-corpus to `GOLD_HASH_PRE_XVLOG.txt` **and**
`SHA256.txt`, **then** xvlog.
On XSim FAIL: copy `xsim.log` → `xsim_fail_r0.log`. Fix **only** TB token
packing / `G_BYTES` layout / TB MEM_DEPTH. **NEVER** regenerate gold after
FAIL. If labels must change, FAIL the bag (new bag), do not rewrite gold.

`G_BYTES` layout: LSB-first; character 0 at bits [7:0], matching
TB `bytes[8*bi +: 8]`.

Independent gold is label match on `{evidence,subj,rel,obj,ctx}` computed
**before** the walker twin and **before** xvlog.

## Required query classes (named checks in xsim.log)

```text
fill_template     → FILL_TEMPLATE_HIT; emit {120,121,122}
unseen_sro_123    → UNSEEN_SRO_HIT nid=123
unseen_sro_124    → UNSEEN_SRO_HIT nid=124
unseen_sro_125    → UNSEEN_SRO_HIT nid=125
unseen_sro_126    → UNSEEN_SRO_HIT nid=126
unseen_sro_127    → UNSEEN_SRO_HIT nid=127
unseen_sro_128    → UNSEEN_SRO_HIT nid=128
unseen_sro_129    → UNSEEN_SRO_HIT nid=129
unseen_sro_130    → UNSEEN_SRO_HIT nid=130
unbound_sro       → UNBOUND_EMPTY_WALK; must NOT emit {120,121,122};
                    FAIL UNBOUND_FILL_GRID_LEAK if fill-grid neighbors leak
unrelated         → UNRELATED_EMPTY_WALK if emit=0; do not score 0/0 as 1000
```

PASS marker conjunct requires `unseen_hit_n == 8` and
`UNSEEN_SRO_8_OF_8_HIT`. Marker
`ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS` only if FAIL=0 and 8/8 HIT.

## PASS / FAIL (this gate only)

```text
PASS_THIS_GATE_ONLY  hash-gate MATCH; gold hashed before first xvlog and
                     not rewritten after FAIL; XSim FAIL=0; marker
                     ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS;
                     UNSEEN_SRO_8_OF_8_HIT; N=16384;
                     all 8 UNSEEN_SRO_HIT nid 123-130;
                     FILL_TEMPLATE_HIT {120,121,122};
                     unbound does not emit {120,121,122};
                     SEARCH_INCOMPLETE absent on gold_n>=1;
                     poke_v=0; leftover A09 not compiled;
                     CAND_CAP=16<16384; named lexicon df0e8833 copied;
                     corpus 6991adc7 copied; C0 FILE unedited;
                     STREAM-02 14f75db7 not compiled;
                     PAGE-SKIP not compiled; C1 800k still OPEN;
                     CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL NOT_FROZEN;
                     BOARD_PASS not claimed
FAIL                 any planted nid 123-130 miss; unbound emits
                     fill-grid {120,121,122}; retrieve gold miss hidden
                     as SEARCH_INCOMPLETE; N dropped to 256; hash
                     mismatch; gold edited after FAIL; leftover A09
                     compiled; C0 patched; nid-derived keys; silent C0
                     lexicon claim; KEEP 16K edited; XSim cannot host
                     16384 (FIRST_DIVERGENCE MEM)
```
