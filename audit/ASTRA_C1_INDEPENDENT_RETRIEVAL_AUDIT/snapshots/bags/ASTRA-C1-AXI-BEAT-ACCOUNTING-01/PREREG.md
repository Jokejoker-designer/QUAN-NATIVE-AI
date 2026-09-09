# PREREG — ASTRA-C1-AXI-BEAT-ACCOUNTING-01

Frozen before xvlog. Independent gold is a **byte-identical copy** of
`ASTRA-C1-KEY-INTERSECT-01` `GOLDEN.json` / `query_gold.svh` / `corpus.json`,
hashed **once** before the **first** xvlog. Original KEY-INTERSECT files are
not rewritten (timestamps/hashes KEEP). PROGRAM=NO (no JTAG / xsdb / COM12 /
`write_bitstream` / hw_server / board program). Does not patch frozen C0 RTL.
Does not edit `a7ng_query_axi_sparse_intersect.sv` (instantiate hash-gate
MATCH `a912786f…`). Does not edit N4096 bag. Does not introduce
`qse-v2-stream-intersect-02`. leftover A09 not compiled. poke_v=0.

## Primary unknown (P0-2 measurement; no new retrieval law)

On frozen N=256 KEY-INTERSECT queries, through the same intersect DUT, do
**accepted R-beats** (`rvalid && rready`) measure AXI bytes as
`R_BYTES=16*(DIR_R_BEATS+POST_R_BEATS)` (not host-only `AR×16`), and are
emit IDs **bit-identical** to KEY-INTERSECT GOLDEN (direct `{110,144,145}`)?

## Claim this bag may close

AXI beat-accounting gate only.
`RESULT=PASS_THIS_GATE_ONLY` if hash-gate MATCH; gold hashed before first
xvlog and not rewritten after FAIL; every replayed class emit-identical to
KEY-INTERSECT GOLDEN; RTL probe prints `DIR_R_BEATS` / `POST_R_BEATS` /
`TOTAL_AXI_BYTES` / `AR_BYTES` / `RATIO_x1000`; classes that issued AXI
reads have nonzero R-beat counters; `R_BYTES >= AR_BYTES` (drain >= issue);
marker `ASTRA_C1_AXI_BEAT_XSIM_PASS` emitted.
`RESULT=FAIL` otherwise.

Does **not** freeze `DDR_QUERY_BOUND_FINAL` / `CAND_CAP_FINAL`. Does **not**
close C1 800k. Does **not** claim stream-intersect-02 done. N=16384 not this
bag.

## Not this bag

N>256. 800k. BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09
as DUT. Silent C0 RTL patch. Editing KEY-INTERSECT gold/corpus/TB/RTL.
Editing N4096. New intersect law. `qse-v2-stream-intersect-02`.
Freezing DDR/CAND bounds from AR×16 or from this R-beat ratio.

## Registered bounds (not CAND_CAP_FINAL / not DDR_QUERY_BOUND_FINAL)

```text
N                 = 256
CAND_CAP          = 16
INDEX_HEAD        = 4
N_TABLES          = 4
N_BUCKETS         = 4096
LAW               = qse-v2-intersect-01 (replay)
LIVE_EPOCH        = 7
CAND_CAP_FINAL    = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
POKE_V            = 0
REDUCTION_X1000   = NOT_EMITTED (not 1-CAND_CAP/N)
AR_BYTES          = 16*(n_dir_ar+n_post_ar)
R_BYTES           = 16*(DIR_R_BEATS+POST_R_BEATS)
RATIO_x1000       = R_BYTES*1000/AR_BYTES (NA if AR=0)
TOTAL_AXI_BYTES   = R_BYTES
```

## Hash-gate (must MATCH before xvlog; FAIL bag on mismatch; do not invent)

```text
a7ng_query_role_extract.sv             cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
qse_role_lexicon.svh                   381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
a7ng_sparse_dir_axi.sv                 09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24
a7ng_query_axi_sparse.sv               5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa
a7ng_route_valid_gate.sv               49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385
a7ng_query_role_keys_relbind.sv        93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d
a7ng_query_axi_sparse_intersect.sv     a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c
```

`a7ng_query_axi_sparse.sv` is hash-gated MATCH C0 and **not** compiled as DUT.

## Gold discipline

Copy KEY-INTERSECT gold into this bag. Hash copies to
`GOLD_HASH_PRE_XVLOG.txt` **and** `SHA256.txt`, **then** xvlog.
Do **not** run the KEY-INTERSECT host to regenerate gold.
On XSim FAIL: copy `xsim.log` → `xsim_fail_r0.log`. Fix **only** TB / probe.
**NEVER** regenerate gold after FAIL. If labels must change, FAIL the bag.

`G_BYTES` layout: LSB-first; character 0 at bits [7:0].

## Probe (RTL-visible)

New named module `a7ng_query_axi_rbeat_probe`:
- increment `DIR_R_BEATS` / `POST_R_BEATS` on `m_axi_rvalid && m_axi_rready`
- classify dir vs posting by latched AR address
  (`[INDEX_BASE, POST_HEAP)` dir; `>= POST_HEAP` posting)
- `TOTAL_AXI_BYTES = 16*(DIR_R_BEATS+POST_R_BEATS)`
- not host-only; not a patch of frozen dir / intersect

## PASS / FAIL (this gate only)

```text
PASS_THIS_GATE_ONLY  hash-gate MATCH; gold hashed before first xvlog and
                     not rewritten after FAIL; emit IDs bit-identical to
                     KEY-INTERSECT GOLDEN for all 10 classes (direct
                     {110,144,145}); AXI_BEAT lines print DIR_R_BEATS
                     POST_R_BEATS TOTAL_AXI_BYTES AR_BYTES R_BYTES
                     RATIO_x1000; R-beat counters nonzero on classes that
                     issued AXI reads; R_BYTES >= AR_BYTES; poke_v=0;
                     leftover A09 not compiled; C1 800k still OPEN;
                     DDR_QUERY_BOUND_FINAL NOT_FROZEN
FAIL                 emit mismatch vs KEY-INTERSECT GOLDEN; R-beats zero
                     on a class with AR>0; R_BYTES < AR_BYTES; hash
                     mismatch; gold edited after FAIL; leftover A09
                     compiled; stream-intersect-02 introduced; N4096 or
                     KEY-INTERSECT files edited
```
