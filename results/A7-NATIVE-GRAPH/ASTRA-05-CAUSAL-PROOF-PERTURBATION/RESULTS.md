# RESULTS — ASTRA-05 CAUSAL-PROOF-PERTURBATION

```text
GATE            = ASTRA-05-CAUSAL-PROOF-PERTURBATION
HOST            = GOLDEN.json result_host=PASS
XSIM            = ASTRA05_CAUSAL_XSIM_PASS
RESULT          = PASS_NARROW (unit edge table, not DDR graph)
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
EXAM_PAIR_STORED= false
```

IDs (not string ROM): READ_A=161 READY_B=178 CALIB_C=195 CALIB_D=212 REL_REQ=33 EID_AB=17 EID_BC=34 EID_BD=51

| Case | Expected | XSim |
|------|----------|------|
| BASE 2-hop A→B→C | ANSWER ans=195 proof 17,34 | st=0 ans=195 p0=17 p1=34 |
| BASE_NOT_STORED A→C fact absent | UNKNOWN | st=1 |
| DEL second edge | UNKNOWN, not keep C | st=1 ans=0 |
| REP C→D | ANSWER 212 proof 17,51 | st=0 ans=212 p0=17 p1=51 |
| CONF_NEG / CONF_TWO | CONFLICT | st=5 |
| CAP scan=1 / hop cap | SEARCH_INCOMPLETE not UNKNOWN | st=6 |
| CAP_RESTORE | ANSWER 195 again | st=0 ans=195 |
| INV reverse support | not keep C | st=1 |
| RND isomorphic IDs | ANSWER structure-equivalent | st=0 ans=7 p0=84 p1=168 |

## Narrow claim

On a bounded loaded-edge engine, deleting/replacing/contradicting/capping search changes the derived 2-hop result. The A→C exam pair is not stored as a fact.

## Not claimed

Open-world causality, DDR 800k graph, LM, Gate14, board.
