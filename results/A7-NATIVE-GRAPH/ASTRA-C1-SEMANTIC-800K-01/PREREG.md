# PREREG — ASTRA-C1-SEMANTIC-800K-01

Frozen before xvlog. Independent gold hashed **once** before the **first**
xvlog. PROGRAM=NO (no JTAG / xsdb / COM12 / `write_bitstream` / hw_server /
board program). Does not patch frozen C0 RTL. Instantiates frozen
`a7ng_query_role_extract` (hash-gate MATCH `cd7baf49…`, not edited) + named
synonym overlay `qse-v2-relctx-synonym-01` (rtl files not edited this bag) +
frozen `a7ng_query_role_keys_ctx` (hash-gate MATCH `124be808…`, not edited) +
frozen `a7ng_sparse_dir_axi` (parameter `N_BUCKETS=65536`, file unedited, AXI
idle) + frozen `a7ng_route_valid_gate` inside **existing** thin DUT wrap
`a7ng_query_axi_sparse_intersect_synonym` (STREAM-02 two-pointer walker copy;
not an edit of STREAM-02 file `14f75db7…`; not an edit of context DUT
`8255a798…`; not a silent-edit of C0). Context DUT **not** compiled as DUT.
STREAM-02 file **not** compiled as DUT. PAGE-SKIP `dab15d76…` **not**
compiled. leftover `a7ng_astra_09_integ_path` **not** compiled. C0
`a7ng_axi_mem_model.sv` **not** compiled (dense array cannot host 800k
honestly). Does not write the V3.1 tree. Does not freeze `CAND_CAP_FINAL` /
`DDR_QUERY_BOUND_FINAL`. Does not claim BOARD_PASS. Does not edit KEEP bags
including SYNONYM-LAW-01 / SEMANTIC-NL-01 / UNSEEN-SRO-16K-R2 / SEMANTIC-16K.
Does not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`.
Historical `ASTRA-02-U5-SCALE-SELECTIVITY-800K` (`qse-v1`) **cannot** close
this bag.

Named lexicon law `qse-v2-lex-semantic-800k-01` is **NEW** (16k 187-word
table cannot name 201 cartesian subjects × 20 rels):

- Named file: bag `qse_role_lexicon_semantic_800k.svh` (SHA in RESULTS / PRE).
- Include-name: bag `qse_role_lexicon.svh` is a one-line `` `include `` of
  the named file.
- xvlog `-i $bag -i $incq -i $incc` — bag **FIRST**.
- C0 FILE `rtl/native_graph/query/qse_role_lexicon.svh` remains unedited
  (hash-gate MATCH `38189974…`).
- KEEP 16k named lex `df0e8833…` is **not** rewritten.

Named synonym table `qse-v2-relctx-synonym-01` is **copied hashed** from rtl
(`551655a1…`); overlay/DUT rtl files instantiated not edited.

**N=800000** (registered). Sparse/on-demand procedural AXI mem is the host
for 800k **addressable** facts (closed-form cartesian generator; nid
`0..799999` including sentinel `799999`). A 16k clone with `N` printed
800000 is OVERCLAIM / FAIL. If XSim/xelab/MEM cannot host the 800k address
space: `FIRST_DIVERGENCE MEM` (or `XELAB`/`XSIM`), `RESULT=FAIL`, preserve
logs. Do **not** silently drop to N=16384/256.

## Primary unknown (Master V1.1 §7, C1 800k)

Owner 2026-09-07 explicit continue to 800k (overrides NOT_AUTO). Auditor
`20260907T1955Z` ACCEPT_PARTIAL closed the 1-alias synonym law at N=16384.
This bag's one unknown:

> N=**800000** records under current law stack
> (`qse-v2-relctx-synonym-01` overlay + ctx keys `124be808` + synonym DUT
> wrap). Fill-template control HIT `{120,121,122}`. High-id sentinel nid
> `799999` HIT. `SEARCH_INCOMPLETE` on `gold_n>=1` retrieve = FAIL.

```text
fill_template       "boiler feeds header"                       k0=3332 k1=3588  gold={120,121,122}
nl_synonym          "what does the boiler supply to the header"  frozen keys_match=0; syn keys_match=1
high_id_sentinel    procedural last-law SRO                     gold={799999}
unrelated           "payroll tax form"                           empty walk
```

Marker `ASTRA_C1_SEMANTIC_800K_XSIM_PASS` **only** if FAIL=0 AND N=800000
hosted AND `FILL_TEMPLATE_HIT` AND `HIGH_ID_HIT nid=799999` AND
`SEARCH_INCOMPLETE` absent on retrieve classes. BOARD_PASS not claimed.
`CAND_CAP_FINAL` not frozen.

## Claim this bag may close

N=800000 semantic retrieve gate on the frozen synonym-law stack only
(not BOARD_PASS, not Master ≥95%).
`RESULT=PASS_THIS_GATE_ONLY` if XSim FAIL=0 **and** marker
`ASTRA_C1_SEMANTIC_800K_XSIM_PASS` **and** N actually 800000 **and**
fill-template control hits `{120,121,122}` **and** sentinel 799999 HIT
**and** `SEARCH_INCOMPLETE` is not used to hide a miss **and** gold was
not rewritten after FAIL **and** KEEP bags unmodified **and** C0 extract /
C0 lexicon FILE unedited.
`RESULT=FAIL` if N dropped, or 16k clone labeled 800k, or retrieve gold
miss, or incomp on `gold_n>=1`, or XSim cannot host 800k (`FIRST_DIVERGENCE`).
Does **not** close Master evidence-recall ≥95% or candidate-reduction ≥90%.
`CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` stay NOT_FROZEN. BOARD_PASS not
claimed.

## Not this bag

BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09 as DUT.
Silent C0 RTL patch. Silent C0 extract alias. V3.1 writes. Programming.
Editing STREAM-02 `14f75db7…` / PAGE-SKIP `dab15d76…` / ctx keys
`124be808…` / context DUT `8255a798…` / synonym overlay rtl. Editing KEEP
bags. nid-derived keys. `relevant=router_union`. Relabeling fill gold.
Silent drop to N=16k/256. Closing C1 from historical U5 `qse-v1`.

## Registered bounds (not CAND_CAP_FINAL / not DDR_QUERY_BOUND_FINAL)

```text
N                 = 800000
CAND_CAP          = 16   (emit budget after AND; 16 < 800000; not FINAL)
INDEX_HEAD        = 4
PAGE_BUFFER       = 1 beat (4 IDs); AXI AR arlen=0
RARE_LIST_FIRST   = smaller occupancy fetched first when both need a beat
MERGE_POST_AR_MAX = 256
N_TABLES          = 4
N_BUCKETS         = 65536  (16-bit exact; instantiate frozen dir parameter)
LAW               = qse-v2-relctx-synonym-01
CTX_LAW           = qse-v2-intersect-context-02 (keys instantiate, not edited)
LEXICON_LAW       = qse-v2-lex-semantic-800k-01 (NEW named)
EXTRACT           = qse-v2-role-00 (frozen instantiate; not patched)
LIVE_EPOCH        = 7
MEM               = bag procedural AXI slave; 800k nids addressable by
                    closed-form cartesian generator; not dense 800k array
CAND_CAP_FINAL    = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
POKE_V            = 0
REDUCTION_X1000   = NOT_EMITTED
HEADLINE          = precision_all = TP/emit_n  (prec_ev1 diagnostic)
fill_template_control = "boiler feeds header"  k0=3332 k1=3588 gold={120,121,122}
nl_synonym            = "what does the boiler supply to the header"
high_id_sentinel_nid  = 799999
N_SUBJECTS            = 201 NEW cartesian subjects (ids 13..213)
N_RELS                = 20
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
qse_relctx_synonym_01.svh           551655a1cda97463841a681e34f8073e22b1b2c1beb2ae03847bdc9a5bb41dfd
                                    (copied named synonym table; NOT rewritten)
a7ng_query_role_relctx_synonym.sv   e862208ce34d8835c34fef1b2f2e4d32a91938a26cf22bc3854593ff852ea922
                                    (KEEP instantiate; NOT edited this bag)
a7ng_query_axi_sparse_intersect_synonym.sv
                                    a84bbf7e9a2c0b9e3753b3cb2e1ae734c2afde59267d733aa0e52108e47d8ec8
                                    (KEEP instantiate as DUT; NOT edited this bag)
```

Live Get-FileHash in `run_xsim.ps1` is authority; mismatch FAILs the bag.

## Gold discipline

Write `GOLDEN.json` + `query_gold.svh` + `corpus.json` (generator metadata,
not a 16k record dump) + named lexicon. Hash gold+named-lex+corpus+synonym
table to `GOLD_HASH_PRE_XVLOG.txt` **and** `SHA256.txt`, **then** xvlog.
On XSim FAIL: copy `xsim.log` → `xsim_fail_r0.log`. Fix **only** TB token
packing / `G_BYTES` layout / procedural mem decode. **NEVER** regenerate
gold after FAIL. If labels must change, FAIL the bag (new bag), do not
rewrite gold. Do not fake high-id keys. Do not set relevant = walker emit.

`G_BYTES` layout: LSB-first; character 0 at bits [7:0], matching
TB `bytes[8*bi +: 8]`.

Index is procedural: postings **sorted by nid** (contract). Host twin is
two-pointer AND with CAND_CAP on emit only after synonym remap. Records
are unique cartesian SROs (occupancy 1 except fill-grid 3-nid plant).

## Required query classes (named checks in xsim.log)

```text
fill_template      → FILL_TEMPLATE_HIT; gold {120,121,122}; cartesian control
nl_synonym         → FROZEN_KEYS_VS_FILL keys_match=0 vs fill 3332/3588
                     SYN_KEYS_VS_FILL keys_match=1 (overlay remapped)
                     NL_GOLD_HIT tp=3 emit {120,121,122} not nid 131
high_id_sentinel   → HIGH_ID_HIT nid=799999; proves N=800000 addressable
unrelated          → UNRELATED_EMPTY_WALK if emit=0; do not score 0/0 as 1000
```

CLASS lines report `gold_n, emit_n, tp, fp_ev1, fp_fill0, prec_ev1,
prec_all, rec`. Headline is `precision_all`. If a **retrieve-class**
relevant id is missed, the class FAILs the bag — `SEARCH_INCOMPLETE` does
not convert a gold miss into PASS. Marker is **not** emitted on that FAIL.

## PASS / FAIL (this gate only)

```text
PASS_THIS_GATE_ONLY  hash-gate MATCH; gold hashed before first xvlog and
                     not rewritten after FAIL; XSim FAIL=0; marker
                     ASTRA_C1_SEMANTIC_800K_XSIM_PASS; N=800000 hosted;
                     FILL_TEMPLATE_HIT {120,121,122};
                     HIGH_ID_HIT nid=799999;
                     SEARCH_INCOMPLETE absent on gold_n>=1;
                     poke_v=0; leftover A09 not compiled;
                     CAND_CAP=16<800000; named lexicon 800k documented;
                     C0 FILE unedited; C0 extract unedited;
                     STREAM-02 14f75db7 not compiled;
                     context DUT 8255a798 not compiled as DUT;
                     PAGE-SKIP not compiled;
                     CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL NOT_FROZEN;
                     BOARD_PASS not claimed
FAIL                 fill-template control miss; high-id miss;
                     retrieve gold miss hidden as SEARCH_INCOMPLETE;
                     N dropped to 16k/256 clone labeled 800k;
                     hash mismatch; gold edited after FAIL;
                     leftover A09 compiled; C0 patched; nid-derived keys;
                     silent C0 lexicon claim; XSim cannot host 800k
                     (FIRST_DIVERGENCE MEM|XELAB|XSIM)
```
