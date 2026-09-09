# PREREG — ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01

Frozen before xvlog. Independent gold hashed **once** before the **first**
xvlog. PROGRAM=NO (no JTAG / xsdb / COM12 / `write_bitstream` / hw_server /
board program). Does not patch frozen RTL. Instantiates C0-hashed
`a7ng_query_role_extract` + `qse_role_lexicon.svh` + `a7ng_sparse_dir_axi`
+ `a7ng_query_axi_sparse` (`LAW_SEL=1`) + `a7ng_route_valid_gate`.
Does **not** compile leftover `a7ng_astra_09_integ_path` as DUT.
Does not write the V3.1 tree. Does not inspect or generate N>256.
Does not freeze `CAND_CAP_FINAL`. Does not claim C1 800k closed.
Does not edit `ASTRA-C1-N256-ROLE-RETRIEVAL-01` (KEEP fail_r0 + gold rewrite).
Historical `ASTRA-02-U5` is qse-v1 and **cannot** close this bag.
Does not set `relevant=set(router_union)`. Does not use `cap>=256`
as selectivity proof. Does **not** emit `reduction_x1000=1-CAND_CAP/N`.

Parent triage (auditor 20260907T0840Z): wrong_context is **NOT_SELECTIVE**
under frozen qse-v2 (xid not a directory key). Do not invent a new key law.

## Primary unknown (Master V1.1 §7, first rung N=256, P1 quality reporting)

With frozen `qse-v2-role-00` + frozen sparse AXI directory (C0 hashes),
at corpus **N=256**, do the required query classes retrieve with
**independent gold**, no host semantic route, no cap≥N as selectivity,
with P1 metrics (fp_ev1 vs fp_fill0, distractor gold_n≥1, unrelated
empty-walk, wrong_context NOT_SELECTIVE)?

## Claim this bag may close

N=256 role-law sparse retrieval **quality-reporting** gate only.
`RESULT=PASS_THIS_GATE_ONLY` if XSim FAIL=0 **and** distractor gold_n≥1
**and** unrelated is not scored 0/0 as 1000/1000 **and** wrong_context
is labeled NOT_SELECTIVE **and** gold was not rewritten after FAIL.
Does **not** close Master evidence-recall ≥95% or candidate-reduction ≥90%
(those apply at N≥4096 / 800k). C1 800k remains OPEN.

## Not this bag

N>256. 800k. BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09
as DUT. Frozen-RTL patch. V3.1 writes. Programming. Historical U5 close.
New key law for context.

## Registered bounds (not CAND_CAP_FINAL)

```text
N                 = 256
CAND_CAP          = 16   (checkpoint default; 16 < 256)
INDEX_HEAD        = 4    (overflow page after 4 head ids)
N_TABLES          = 4
N_BUCKETS         = 4096
LAW_SEL           = 1    (qse-v2-role-00)
LIVE_EPOCH        = 7
CAND_CAP_FINAL    = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
POKE_V            = 0
REDUCTION_X1000   = NOT_EMITTED
```

## Hash-gate (must MATCH C0 before xvlog; FAIL bag on mismatch; do not invent)

```text
a7ng_query_role_extract.sv  cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
qse_role_lexicon.svh        381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
a7ng_sparse_dir_axi.sv      09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24
a7ng_query_axi_sparse.sv    5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa
a7ng_route_valid_gate.sv    49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385
```

## Gold discipline (P1-1)

Write `GOLDEN.json` + `query_gold.svh` + `corpus.json`, hash them to
`GOLD_HASH_PRE_XVLOG.txt` **and** `SHA256.txt`, **then** xvlog.
On XSim FAIL: copy `xsim.log` → `xsim_fail_r0.log`. Fix **only** TB token
packing / `G_BYTES` layout. **NEVER** regenerate gold after FAIL.
If labels must change, FAIL the bag (new bag), do not rewrite gold.

`G_BYTES` layout: LSB-first; character 0 at bits [7:0], matching
TB `bytes[8*bi +: 8]`.

## Required query classes (named checks in xsim.log)

```text
direct
paraphrase
role_reversal
wrong_relation
wrong_context     → NOT_SELECTIVE + k0–k3 vs direct (frozen law)
distractor        → gold_n>=1 (entity-context; not lambda False)
unrelated         → UNRELATED_EMPTY_WALK if emit=0; do not score 0/0 as 1000
high_occupancy
overflow_page
high_id_sentinel
```

Independent gold is label match on `{evidence,subj,rel,obj,ctx}` computed
**before** the walker twin and **before** xvlog. Occupancy fillers are
`evidence=0` and are not gold. CLASS lines report `gold_n, emit_n, tp,
fp_ev1, fp_fill0, prec_ev1, rec`. `prec_ev1` excludes fillers from the
denominator when `prec_all` is also printed. If a relevant id is beyond
CAND_CAP / unwalked overflow, the class reports `SEARCH_INCOMPLETE` —
never a false UNKNOWN/NO.

## PASS / FAIL (this gate only)

```text
PASS_THIS_GATE_ONLY  hash-gate MATCH; gold hashed before first xvlog and
                     not rewritten after FAIL; XSim FAIL=0; 10 named class
                     markers; n_host=0; CAND_CAP=16<256; poke_v=0;
                     leftover A09 not compiled; distractor gold_n>=1;
                     unrelated UNRELATED_EMPTY_WALK (not prec=1000 rec=1000);
                     wrong_context NOT_SELECTIVE; reduction_x1000 not emitted
                     as cap/N; C1 800k still OPEN
FAIL                 hash mismatch (do not invent); gold edited after FAIL;
                     walker/packet mismatch; host semantic route;
                     leftover A09 compiled as DUT; N>256 generated;
                     distractor gold_n==0; unrelated 0/0 scored 1000/1000;
                     wrong_context claimed as recall/selectivity win
```
