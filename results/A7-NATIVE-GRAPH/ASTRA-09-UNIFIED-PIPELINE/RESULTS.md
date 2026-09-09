# RESULTS — ASTRA-09 UNIFIED-PIPELINE

```text
GATE            = ASTRA-09-UNIFIED-PIPELINE
HOST            = GOLDEN.json ASTRA09_HOST_COMPARE_PASS
XSIM            = ASTRA09_UNIFIED_XSIM_PASS
RESULT          = PASS_NARROW (XSim integrate, not board; language OPEN)
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
EXAM_PAIR_STORED= false
N_HOST          = 0
LM06_CLASS      = LANGUAGE_UNPROVEN
SPARSE_AXI      = omitted (optional; ASTRA-01)
```

Path: UART-like bytes → `a7ng_query_role_extract` (qse-v2-role-00) → `a7ng_rel_engine_2hop` (loaded edges) → `a7ng_shared_rank_sgd_q8` (`freeze_i=1`) → `a7ng_evidence_compose` compact proof bytes.

TB does not drive engine `q_s`/`q_o`/`q_r` or poke a winner. Packet gold is the qse-v2 twin. A→C is not a stored fact (1-hop `pump requires compressor` = UNKNOWN while 2-hop ANSWER compressor + two edge IDs).

| Case | Query | Expected | XSim |
|------|-------|----------|------|
| C1_FWD | pump supplies chiller | packet subj=10 obj=1 rel=1 k0=2561; 1-hop ANSWER | st=0 ans=1 p0=3 |
| C1_REV | chiller supplies pump | packet swapped k0=257; WRONGDIR | st=2 ans=0 |
| C1_NTRANS | pump supplies indirect condenser | two_hop=1 NTRANS (not 2-hop ANSWER) | st=3 |
| C2_1HOP | pump requires chiller | ANSWER + proof | st=0 ans=1 p0=1 |
| C3_2HOP | pump requires indirect compressor | ANSWER C + two edge IDs | st=0 ans=4 p0=1 p1=2 |
| C3_NO_AC | pump requires compressor | UNKNOWN (A→C not stored) | st=1 |
| C4_UNREL | payroll tax form | no triple / UNKNOWN skip | st=1 trip=0 skip=1 |
| C5_MISS | same 2-hop after DELETE B→C | UNKNOWN, not keep C | st=1 ans=0 |
| C6_REV1 | chiller requires pump | WRONGDIR, not keep chiller | st=2 ans=0 |
| C6_REV2 | compressor requires indirect pump | UNKNOWN, not keep pump | st=1 ans=0 |

v_q8=0 on all cases (zero weights, freeze). n_host_*=0. ntok=14 compact proof bytes (not language).

## Narrow claim

One connected XSim path binds roles from raw bytes, joins loaded `requires` edges for a 2-hop proof, scores with frozen shared SGD, and refuses unrelated / missing / reverse / non-transitive supplies.

## Not claimed

Gate14, board, NLU, 800k DDR graph, LM language generation, AXI sparse walker in this integrate.
