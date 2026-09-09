# PREREG — ASTRA-C5-EDGE-MUTATION-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, C3 held-out
KEEP, C4 adapters, C5 DDR arbiter, `a7ng_lm_graph_arb.sv`, leftover A09,
frozen LM-06 `tiny_gpt803k_core`, or official `mig.prj`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. Does not self-stamp `C5_MASTER`.

Observe ports `c3_ans_o` / `c3_p0_o` / `c3_p1_o` were added on the live
production top so the TB can measure destination/proof identity. They are
not a qid-map. KEEP RTL is unedited. Plant stays in this TB.

## One unknown

On the same C5 production hierarchy, after a planted 2-hop ANSWER, does
mutating the decisive second-hop fact (delete / replace destination /
reverse subject-object) change the C3 result the way Master §11 requires?

## HIT letter this bag may measure (XSim modeled AXI)

```text
base 2-hop ANSWER dest=64 proof eids 16,17
delete second hop → UNKNOWN (not still dest 64)
replace second hop dest 80 → ANSWER dest=80 proof p1=17
reverse second hop S/O → UNKNOWN (not dest 80)
```

## Out of scope

- CONFLICT opcode (KEEP C3 has none)
- MIG PHY / silicon / 90% LM
- 800k corpus

## FAIL if

- KEEP hashes drift
- GOLDEN edited after xvlog
- PROGRAM=YES
- bag claims C5_MASTER closed
