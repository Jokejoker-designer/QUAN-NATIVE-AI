# PREREG — ASTRA-C1-SEMANTIC-HELDOUT-01

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
bags SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02 / DIR-FULL16 /
N4096-STREAM-02 / KEY-INTERSECT / AXI-BEAT. Does not write
`D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`.

Named lexicon law `qse-v2-lex-semantic-16k-01` is **copied** from
SEMANTIC-16K (SHA `df0e8833…`), not rewritten, not a silent C0 59-word
claim:

- Named file: bag `qse_role_lexicon_semantic_16k.svh` (SHA in RESULTS / PRE).
- Include-name: bag `qse_role_lexicon.svh` is a one-line `` `include `` of
  the named file (frozen extract still includes that filename).
- xvlog `-i $bag -i $incq -i $incc` — bag **FIRST** so runtime table is the
  named law.
- C0 FILE `rtl/native_graph/query/qse_role_lexicon.svh` remains unedited
  (hash-gate MATCH `38189974…`).

Index fill is the same cartesian `{ent} {rel} {ent}` generator as
SEMANTIC-16K (`N=16384`). Gold **queries** are not that generator.

## Primary unknown (Master V1.1 §7, N=16384 held-out)

Held-out gold — queries whose surface form is **not** the index fill
template `{ent} {rel} {ent}`, independent labels, still retrieve labeled
nids under the same context-02 + stream-02 instantiate (`124be808…` keys +
`8255a798…` DUT, not edited); plus a fill-template control still hits.

`SEARCH_INCOMPLETE` on `gold_n>=1` retrieve = FAIL. C1 800k stays OPEN
even if this bag PASSes. If XSim cannot host 16384, FAIL honestly with
`FIRST_DIVERGENCE MEM`. Do **not** silently drop to N=256 clones.

## Claim this bag may close

N=16384 held-out query gate only (PLAN bag 7 remainder first slice, not
800k close, not Master ≥95%).
`RESULT=PASS_THIS_GATE_ONLY` if XSim FAIL=0 **and** marker
`ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS` **and** at least one paraphrase gold
hits **and** fill-template control gold hits **and** retrieve classes with
`gold_n>=1` hit labeled gold **and** `SEARCH_INCOMPLETE` is not used to
hide a miss **and** gold was not rewritten after FAIL.
`RESULT=FAIL` if paraphrase misses, or fill-template control misses, or
any retrieve class with `gold_n>=1` misses declared gold (incomp does not
convert that to PASS), or gold queries are still the cartesian fill
generator, or N is dropped, or C0 is silent-shadowed, or XSim cannot host
16384 (MEM). Does **not** close Master evidence-recall ≥95% or
candidate-reduction ≥90%. C1 800k remains OPEN. `CAND_CAP_FINAL` /
`DDR_QUERY_BOUND_FINAL` stay NOT_FROZEN. BOARD_PASS not claimed.

## Not this bag

800k. BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09 as DUT.
Silent C0 RTL patch. V3.1 writes. Programming. Page-skip scheduler change.
Loading full posting into BRAM. Patching `a7ng_sparse_dir_axi`. Editing
STREAM-02 `14f75db7…` / PAGE-SKIP `dab15d76…` / ctx keys `124be808…` /
context DUT `8255a798…`. Editing KEEP bags including SEMANTIC-16K.
nid-derived keys. `relevant=router_union`. Silent C0 lexicon claim.
12-entity clone corpus. Selling formulaic fill queries as held-out.

## Registered bounds (not CAND_CAP_FINAL / not DDR_QUERY_BOUND_FINAL)

```text
N                 = 16384
CAND_CAP          = 16   (emit budget after AND; 16 < 16384; not FINAL)
INDEX_HEAD        = 4
PAGE_BUFFER       = 1 beat (4 IDs); AXI AR arlen=0
RARE_LIST_FIRST   = smaller occupancy fetched first when both need a beat
MERGE_POST_AR_MAX = 256
N_TABLES          = 4
N_BUCKETS         = 65536  (16-bit exact; instantiate frozen dir parameter;
                            not a new dir unknown; DIR-FULL16 KEEP unedited)
LAW               = qse-v2-intersect-context-02
LEXICON_LAW       = qse-v2-lex-semantic-16k-01 (copied named df0e8833)
EXTRACT           = qse-v2-role-00 (frozen instantiate; not patched)
CTX_KEYS          = qse-v2-intersect-context-02 (instantiate, not edited)
LIVE_EPOCH        = 7
MEM_DEPTH         = TB-only; must fit 4*65536*16 directory + postings
CAND_CAP_FINAL    = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
POKE_V            = 0
REDUCTION_X1000   = NOT_EMITTED
HEADLINE          = precision_all = TP/emit_n  (prec_ev1 diagnostic)
k0,k1             = frozen {subj,rel}/{obj,rel} when !ctx_valid;
                    packed {subj,ctx[3:0],rel[3:0]}/{obj,ctx[3:0],rel[3:0]}
                    when ctx_valid
host_index        = always plain k0/k1; also ctx-packed k0/k1 if record ctx_valid
index_fill        = cartesian {ent} {rel} {ent} (same generator as SEMANTIC-16K)
held_out_queries  = paraphrase / role_reversal / wrong_relation / wrong_context
                    / high_occupancy / overflow_page / high_id_sentinel / late_gold
fill_template_control = "boiler feeds header"
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
```

Live Get-FileHash in `run_xsim.ps1` is authority; mismatch FAILs the bag.

## Gold discipline

Write `GOLDEN.json` + `query_gold.svh` + `corpus.json`; named lexicon is
the copied SEMANTIC-16K table (not regenerated). Hash gold+named-lex to
`GOLD_HASH_PRE_XVLOG.txt` **and** `SHA256.txt`, **then** xvlog.
On XSim FAIL: copy `xsim.log` → `xsim_fail_r0.log`. Fix **only** TB token
packing / `G_BYTES` layout / TB MEM_DEPTH. **NEVER** regenerate gold after
FAIL. If labels must change, FAIL the bag (new bag), do not rewrite gold.

`G_BYTES` layout: LSB-first; character 0 at bits [7:0], matching
TB `bytes[8*bi +: 8]`.

Index rebuilt with postings **sorted by nid** (contract). Host twin is
two-pointer AND with CAND_CAP on emit only. Records are dual-indexed:
plain `{subj,rel}` always, plus ctx-packed keys when the record bound a
ctx token.

Held-out query surface (must **not** match
`^([a-z]+) ([a-z]+) ([a-z]+)(?: ([a-z]+))?$`):

```text
paraphrase        "what does the boiler feed to the header"
role_reversal     "what does the header feed to the boiler"
wrong_relation    "does the boiler isolates the header"
wrong_context     "does the boiler feed the header glycol"
high_occupancy    "does the damper modulates the grille"
overflow_page     "does the strainer bypasses the riser"
high_id_sentinel  "does the hopper isolates the silo"
late_gold         "does the cyclone discharges the beacon"
```

Fill-template control (must match the cartesian regex):

```text
fill_template     "boiler feeds header"
```

Frozen extract still binds the held-out strings to the same SRO as the
fill rows (skip-class function words + RELCTX `feed` after subject).
Independent gold is label match on `{evidence,subj,rel,obj,ctx}` computed
**before** the walker twin and **before** xvlog.

## Required query classes (named checks in xsim.log)

```text
fill_template     → FILL_TEMPLATE_HIT; gold hits >0; cartesian control
paraphrase        → PARAPHRASE_HIT; same labels as fill_template; NOT fill regex
role_reversal
wrong_relation
wrong_context     → CONTEXT_SELECTIVE; emit ≠ fill_template
distractor        → gold = EXCLUDED set; leak_n; FAIL DISTRACTOR_LEAK if leak
unrelated         → UNRELATED_EMPTY_WALK if emit=0; do not score 0/0 as 1000
high_occupancy
overflow_page
high_id_sentinel
late_gold         → LATE_GOLD_HIT required; both-list index >=16
```

CLASS lines report `gold_n, emit_n, tp, fp_ev1, fp_fill0, prec_ev1,
prec_all, rec`. Headline is `precision_all`. If a **retrieve-class**
relevant id is missed, the class FAILs the bag — `SEARCH_INCOMPLETE` does
not convert a gold miss into PASS.

## PASS / FAIL (this gate only)

```text
PASS_THIS_GATE_ONLY  hash-gate MATCH; gold hashed before first xvlog and
                     not rewritten after FAIL; XSim FAIL=0; marker
                     ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS; N=16384;
                     FILL_TEMPLATE_HIT; PARAPHRASE_HIT; retrieve gold
                     hits; SEARCH_INCOMPLETE absent on gold_n>=1;
                     poke_v=0; leftover A09 not compiled;
                     CAND_CAP=16<16384; named lexicon df0e8833 copied;
                     C0 FILE unedited; STREAM-02 14f75db7 not compiled;
                     PAGE-SKIP not compiled; C1 800k still OPEN;
                     CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL NOT_FROZEN;
                     BOARD_PASS not claimed
FAIL                 paraphrase miss; fill-template control miss;
                     retrieve gold miss hidden as SEARCH_INCOMPLETE;
                     gold queries still cartesian fill generator;
                     N dropped to clone; hash mismatch; gold edited after
                     FAIL; leftover A09 compiled; C0 patched; nid-derived
                     keys; silent C0 lexicon claim; XSim cannot host 16384
                     (FIRST_DIVERGENCE MEM)
```
