# PREREG — ASTRA-04 RELATION-ENGINE-2HOP

```text
GATE            = ASTRA-04-RELATION-ENGINE-2HOP
LAST_PASS       = ASTRA-03
ROLE_LAW        = qse-role-v1-00
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
```

## Primary unknown

Can a bounded FPGA rule engine derive a 2-hop fact and emit a proof path
from stored edges, without an LM and without an answer ROM?

Input: role packet (subj, rel, obj/var) + candidate facts.
Output: derived result + edge-ID proof, or UNKNOWN / CONFLICT / SEARCH_INCOMPLETE.

Mandatory tests: stored fact, 1-hop, 2-hop, invalid chain, wrong direction,
non-transitive relation, cycle, duplicate edge, missing edge.

Do not store READ_A→CALIB_C as a precomputed exam row.
Do not redo U4A-R4/R5/R6 or qse-v1.
