# RESULTS — ASTRA-02 U5-SCALE-SELECTIVITY-800K

```text
GATE            = ASTRA-02-U5-SCALE-SELECTIVITY-800K
HOST            = ASTRA02_HOST_SELECTIVITY_DONE  RESULT=PASS
XSIM            = ASTRA02_OVERFLOW_XSIM_PASS
ASTRA01_REGRESS = ASTRA01_AXI_SPARSE_PASS (after overflow + cap-stop)
FIRST_DIVERGENCE= none
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
V31_WRITES      = 0
KEYS            = actual QSE extract(); nid-derived keys = NO
TH_RECALL       = 0.80 not retargeted
```

## What was measured

Independent gold = HVAC `ENTITY_CANON` titles only (not occupancy, not nid keys).
Synth rows reuse **actual** entity templates as distractors. Index head page=32
plus overflow page; CAND_CAP remains 64. Walker follows overflow until cap, then
stops (bytes do not grow with unread overflow).

| N | chiller rec | chiller prec | chiller bytes | paraphrase bytes | unrelated emit | role keys identical |
|--:|------------:|-------------:|--------------:|-----------------:|---------------:|---------------------|
| 256 | 1.00 | 0.111 | 320 | 304 | 0 | YES |
| 4096 | 1.00 | 0.111 | 320 | 304 | 0 | YES |
| 16384 | 1.00 | 0.111 | 320 | 304 | 0 | YES |
| 65536 | 1.00 | 0.111 | 320 | 304 | 0 | YES |
| 262144 | 1.00 | 0.111 | 320 | 304 | 0 | YES |
| 800000 | 1.00 | 0.111 | 320 | 304 | 0 | YES |

XSim overflow plant: head 32 collide IDs + overflow gold {0,1,2,3}.
`emit=36 dir=2 post=4 ovf=1 gold_hit=ALL`. Unknown payroll: emit=0 dir=0.

Without overflow walk, host previously dropped overflow-relevant (recall 0.76
or miss). Threshold was **not** lowered; walker gained overflow-page follow
using dir bits `[107:80]` base + `[123:108]` count. Unused in ASTRA-01 images
(ovf_count=0) so ASTRA-01 vectors still match.

## Narrow claim

Bounded FPGA QSE→4×4096 dir/posting, with overflow pages and cap-stop, retrieves
independent HVAC-title gold at recall=1.0 from N=256..800000 and rejects
unrelated queries. Bytes stay ≤320 on these queries.

## Not claimed

- High precision (chiller 11%, water-chiller 6.25% @64 with collide distractors)
- Role-preserving retrieval (`pump supplies chiller` keys == `chiller supplies pump`)
- 800k distinct semantic keys (lexicon key space is small; scale used honest collisions)
- Occupancy as recall
- Board / Gate14
