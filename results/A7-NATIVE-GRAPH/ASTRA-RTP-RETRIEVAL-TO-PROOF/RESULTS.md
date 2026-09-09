# RESULTS — RETRIEVAL_TO_PROOF_CAUSALITY

```text
GATE     = ASTRA-RTP-RETRIEVAL-TO-PROOF
XSIM     = ASTRA_RTP_XSIM_PASS
RESULT   = PASS_NARROW (XSim causality; not SoC, not LM06, not board)
TB_LOAD  = 0 (load_from_tb_o tied 0)
N_HOST   = 0
PROGRAM  = NO
COM12    = PLUGGED_UNPROGRAMMED
```

Query (all causal cases): `pump requires indirect` — object unbound.

| Case | Intervention | XSim |
|------|----------------|------|
| BASE | posting {17,34} + descriptors AB, BC | ANSWER ans=4 proof 17,34 nc=2 nl=2 |
| POST_DROP_BC | posting {17}; descriptor 34 **still in RAM** | UNKNOWN ans=0 nc=1 nl=1 (does not keep 4) |
| DESC_SWAP | posting {17,34}; descriptor 34 object 4→7 | ANSWER ans=7 proof 17,34 |
| UNREL | `payroll tax form` | UNKNOWN nc=0 nl=0 ndir=0 |

F1 closed on this XSim path: retrieved IDs fetch descriptors that become engine facts; posting/descriptor intervention changes proof. Unit 03/04/05/09 RTL not retargeted (`a7ng_astra09_pipe` untouched).

## Not closed

F2 ranker-before-select / reward commit. F3 competing legal proofs. F4 LM06_NOT_INTEGRATED. F5 empty SoC / WNS. Board.

Acceptance: ACCEPT_PARTIAL_RESEARCH / REJECT_FINAL_PROMOTION still holds.
