# PREREG — RETRIEVAL_TO_PROOF_CAUSALITY

```text
GATE     = ASTRA-RTP-RETRIEVAL-TO-PROOF
BASE     = keep ASTRA-03/04/05/09 units; do not retarget them
BIT      = NO
PROGRAM  = NO
COM12    = PLUGGED_UNPROGRAMMED
```

Independent acceptance F1: walker IDs must fetch descriptors that become reasoner facts.
TB must NOT load the 2-hop edge table as authority during the query.

## Frozen cases (registered before run)

Query bytes (object unbound so descriptor can change the derived object):
`pump requires indirect` (qse-v2: subj=10 obj=0 rel=2 ctx=2 k0=2562 k2=766; k1/k3 invalid).

Facts in AXI only (nid=eid):
- nid 17: requires(pump=10, chiller=1) trans=1
- nid 34: requires(chiller=1, compressor=4) trans=1  [BASE]
- nid 34': requires(chiller=1, other=7) trans=1       [DESC_SWAP only]

Directory/posting plant those nids into the four query buckets.

| Case | Intervention | Expected |
|------|----------------|----------|
| BASE | posting {17,34}, descriptors 17 and 34 as above | ANSWER ans=4 proof 17,34 |
| POST_DROP_BC | posting {17} only; descriptor 34 **still in fact RAM** | UNKNOWN, not keep 4 |
| DESC_SWAP | posting {17,34}; descriptor 34 object=7 | ANSWER ans=7 proof 17,34 |
| UNREL | query `payroll tax form`; same mem as BASE | UNKNOWN, n_fetch=0 |

Fail if: TB `load_v` during query; ans equals a posting plant that has no descriptor; BASE still answers 4 after POST_DROP_BC.

Not in this gate: LM06 transformer, SGD path selection, board, 100 MHz close.
