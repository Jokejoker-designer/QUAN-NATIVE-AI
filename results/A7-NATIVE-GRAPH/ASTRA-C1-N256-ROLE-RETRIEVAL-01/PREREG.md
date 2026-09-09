# PREREG — ASTRA-C1-N256-ROLE-RETRIEVAL-01

Frozen before xvlog. Independent gold hashed before xvlog. PROGRAM=NO
(no JTAG / xsdb / COM12 / `write_bitstream` / hw_server / board program).
Does not patch frozen RTL. Instantiates C0-hashed
`a7ng_query_role_extract` + `qse_role_lexicon.svh` + `a7ng_sparse_dir_axi`
+ `a7ng_query_axi_sparse` (`LAW_SEL=1`) + `a7ng_route_valid_gate`.
Does **not** compile leftover `a7ng_astra_09_integ_path` as DUT.
Does not write the V3.1 tree. Does not inspect or generate N>256.
Does not freeze `CAND_CAP_FINAL`. Does not claim C1 800k closed.
Historical `ASTRA-02-U5` is qse-v1 and **cannot** close this bag.
Does not set `relevant=set(router_union)`. Does not use `cap>=256`
(or cap>=dataset) as selectivity proof.

## Primary unknown (Master V1.1 §7, first rung N=256)

With frozen `qse-v2-role-00` + frozen sparse AXI directory (C0 hashes),
at corpus **N=256**, do the required query classes retrieve with
**independent gold**, no host semantic route, no cap≥N as selectivity?

## Claim this bag may close

N=256 role-law sparse retrieval quality against independent gold
(this gate only). `RESULT=PASS_THIS_GATE_ONLY` if XSim FAIL=0 and no
class is closed by tautology. C1 800k remains OPEN.

## Not this bag

N>256. 800k. BOARD_PASS. ASTRA-13. PRODUCTION_TOP. DDR/MIG. leftover A09
as DUT. Frozen-RTL patch. V3.1 writes. Programming. Historical U5 close.

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
```

## Hash-gate (must MATCH C0 before xvlog; FAIL bag on mismatch; do not invent)

```text
a7ng_query_role_extract.sv  cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
qse_role_lexicon.svh        381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
a7ng_sparse_dir_axi.sv      09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24
a7ng_query_axi_sparse.sv    5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa
a7ng_route_valid_gate.sv    49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385
```

## Required query classes (named checks in xsim.log)

```text
direct
paraphrase
role_reversal
wrong_relation
wrong_context
distractor
unrelated
high_occupancy
overflow_page
high_id_sentinel
```

Independent gold is label match on `{evidence,subj,rel,obj,ctx}` computed
**before** the walker twin and **before** xvlog. Occupancy fillers are
`evidence=0` and are not gold. If a relevant id is beyond CAND_CAP /
unwalked overflow, the class reports `SEARCH_INCOMPLETE` — never a false
UNKNOWN/NO.

## PASS / FAIL (this gate only)

```text
PASS_THIS_GATE_ONLY  hash-gate MATCH; gold hashed before xvlog; XSim FAIL=0;
                     10 named class markers; n_host=0; CAND_CAP=16<256;
                     no tautological gold; C1 800k still OPEN
FAIL                 hash mismatch (do not invent); gold edited after FAIL;
                     walker/packet mismatch; host semantic route;
                     leftover A09 compiled as DUT; N>256 generated
```
