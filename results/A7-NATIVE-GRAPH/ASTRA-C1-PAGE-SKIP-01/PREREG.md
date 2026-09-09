# PREREG — ASTRA-C1-PAGE-SKIP-01

Frozen before xvlog. Independent gold hashed **once** before the **first**
xvlog. PROGRAM=NO (no JTAG / xsdb / COM12 / `write_bitstream` / hw_server /
board program). Does not patch frozen C0 RTL. Instantiates frozen
`a7ng_query_role_extract` + named `a7ng_query_role_keys_relbind` (not edited)
+ frozen `a7ng_sparse_dir_axi` (C0 geometry, AXI idle) + frozen
`a7ng_route_valid_gate` inside **new**
`a7ng_query_axi_sparse_page_skip`. New walker only (sorted-nid two-pointer
AND + posting page min/max skip). Does **not** edit STREAM-02 walker
`14f75db7…`. Does **not** patch `a7ng_sparse_dir_axi.sv`. Does **not**
compile leftover `a7ng_astra_09_integ_path`. Does **not** put a bag
`qse_role_lexicon.svh` on the include path (C0 59-word table first).
Does not write the independent audit tree. Does not freeze
`CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`. Does not claim C1 800k closed.
Does not edit KEEP bags DIR-FULL16 / STREAM-02 / N4096-STREAM-02 /
KEY-INTERSECT / AXI-BEAT.

## Primary unknown (Master V1.1 §7, N=256 page skip)

At N=256, new named walker `qse-v2-page-skip-01` (posting page `{min,max,nrec}`
headers; skip remaining POST AR/R when page.max < other-stream cursor),
does CLASS_direct emit stay bit-identical `{110,144,145}` **and** does
high_occupancy `POST_R_BEATS` stay strictly **< AXI-BEAT baseline 14**
**and** is at least one page actually skipped (not headers-only packing)
**and** if STREAM-02 late-gold nid **254** remains in this corpus, is it
still in emit (SEARCH_INCOMPLETE must not hide a miss)?

## Claim this bag may close

N=256 page-skip gate only.
`RESULT=PASS_THIS_GATE_ONLY` if XSim FAIL=0 **and** direct emit
`{110,144,145}` **and** hoc `POST_R_BEATS < 14` **and** hoc `n_page_skip>=1`
**and** nid 254 in emit **and** gold was not rewritten after FAIL.
`RESULT=FAIL` if skip is absent, or hoc POST_R ≥ 14, or direct IDs drift,
or late-gold 254 missed (incomp does not convert that to PASS).
Does **not** close Master evidence-recall ≥95% or candidate-reduction ≥90%.
C1 800k remains OPEN. `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` stay
NOT_FROZEN.

## Not this bag

N>256. 800k. BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09
as DUT. Silent C0 RTL patch. Context keys. 65k directory. Loading full
posting into BRAM. Patching `a7ng_sparse_dir_axi`. Editing STREAM-02 /
DIR-FULL16 / N4096-STREAM-02 / KEY-INTERSECT / AXI-BEAT bags. Freezing
DDR/CAND bounds. Bag lexicon shadow.

## Registered bounds (not CAND_CAP_FINAL / not DDR_QUERY_BOUND_FINAL)

```text
N                 = 256
CAND_CAP          = 16   (emit budget after AND; 16 < 256; not FINAL)
INDEX_HEAD        = 4    (overflow page after 4 head ids; ovf flag only)
PAGE_N            = 16   IDs / posting page
PAGE_HDR          = 1 beat {min_id, max_id, nrec, magic=A7A1}
PAGE_DATA         = ceil(nrec/4) beats; skipped when page.max < other cursor
N_TABLES          = 4
N_BUCKETS         = 4096
LAW               = qse-v2-page-skip-01
EXTRACT           = qse-v2-role-00 (frozen instantiate; C0 59-word lexicon)
RELBIND           = qse-v2-relbind-01 keys instantiated, not edited
LIVE_EPOCH        = 7
AXI_BEAT_HOC_POST_R = 14  (baseline; hoc must be strictly less)
CAND_CAP_FINAL    = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
POKE_V            = 0
REDUCTION_X1000   = NOT_EMITTED
HEADLINE          = precision_all = TP/emit_n  (prec_ev1 diagnostic)
k0,k1             = frozen {subj,rel}/{obj,rel}; emit = stream(k0 ∩ k1)
```

## Hash-gate (must MATCH C0 / KEEP before xvlog; FAIL bag on mismatch; do not invent)

```text
a7ng_query_role_extract.sv          cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
qse_role_lexicon.svh                381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
a7ng_sparse_dir_axi.sv              09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24
a7ng_query_axi_sparse.sv            5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa
a7ng_route_valid_gate.sv            49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385
a7ng_query_role_keys_relbind.sv     93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d
a7ng_query_axi_sparse_intersect.sv  a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c
                                    (KEEP; MATCH; NOT compiled as DUT)
a7ng_query_axi_sparse_stream_intersect.sv
                                    14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac
                                    (KEEP STREAM-02; MATCH; NOT compiled as DUT)
```

xvlog `-i` order: C0 `rtl/native_graph/query` **first**, then control, then bag
(gold svh only). No bag lexicon copy.

## Gold discipline

Write `GOLDEN.json` + `query_gold.svh` + `corpus.json`, hash them to
`GOLD_HASH_PRE_XVLOG.txt` **and** `SHA256.txt`, **then** xvlog.
On XSim FAIL: copy `xsim.log` → `xsim_fail_r0.log`. Fix **only** TB token
packing / `G_BYTES` layout / walker skip. **NEVER** regenerate gold after FAIL.
If labels must change, FAIL the bag (new bag), do not rewrite gold.

Page headers live in the postings payload (host + new walker contract).
Directory 16-byte entries unchanged (do not patch `sparse_dir`).

## Required query classes (named checks in xsim.log)

```text
direct            → emit bit-identical {110,144,145}
paraphrase
role_reversal
wrong_relation
wrong_context     → NOT_SELECTIVE (xid not a key)
distractor        → excluded polarity; leak=FAIL
unrelated         → UNRELATED_EMPTY_WALK
high_occupancy    → POST_R_BEATS < 14 AND n_page_skip >= 1
overflow_page     → q_overflow=1
high_id_sentinel  → id=255
late_gold         → id=254 in emit; SEARCH_INCOMPLETE must not hide a miss
```
