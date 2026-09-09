# PREREG — ASTRA-02 U5-SCALE-SELECTIVITY-800K

```text
GATE            = ASTRA-02-U5-SCALE-SELECTIVITY-800K
PARENT          = ASTRA_GROK_PARENT
CWD             = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
BRANCH          = grok-orch/astra-native-v1-00
HEAD            = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
LAST_PASS       = ASTRA-01
QUERY_LAW       = qse-v1-lexicon-hdc-00  KEY VALUES UNCHANGED
VALIDITY_LAW    = U4A-R6 bind-state; NOT (key != 0)
KEYS            = actual QSE extract(); FORBIDDEN: k2=nid, k3=nid>>4
N_TABLES        = 4
N_BUCKETS       = 4096
HEAD_CAP        = 64
CAND_CAP        = 64
TH_RECALL       = 0.80  (not retargeted)
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
U4A-R4/R5/R6    = DO NOT REDO
```

## Primary unknown

With **independent gold** and **actual QSE keys**, does 4×4096 head-capped
sparse retrieval keep usable recall/precision/reduction as N scales
256 → 4096 → 16384 → 65536 → 262144 → 800000?

U5-MEM02 occupancy/sentinel is **not** this gate. Occupancy ≠ semantic recall.
A high-address sentinel alone is NOT enough.

## Must include

- Unrelated queries (payroll, soccer, adversarial nonce)
- Entity-context distractors
- Role reversal pair (measure; ASTRA-03 owns the fix)
- Relevant records in overflow / adversarial buckets
- Bytes = directory beats + posting beats (incl. discarded/padding), not 16×kept
- Per-class precision and candidate reduction
- Overflow flag vs overflow **walk** (head-only miss must not be called recall=1)

## Pass / fail law

Do not lower TH_RECALL to save the design.
If quality fails: record FAIL, do not skip remaining measurements,
next unblocked item = overflow-page walk or return-to-router (ASTRA-03).

## Not this gate

Board program, role-preserving parser rewrite, 2-hop, Gate14.
