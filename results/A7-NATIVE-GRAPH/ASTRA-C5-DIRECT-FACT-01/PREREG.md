# PREREG — ASTRA-C5-DIRECT-FACT-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, C3 held-out
KEEP, C4 adapters, C5 DDR arbiter, `a7ng_lm_graph_arb.sv`, leftover A09,
frozen LM-06 `tiny_gpt803k_core`, or official `mig.prj`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. Does not self-stamp `C5_MASTER`.

Plant stays in this TB. Live prod_top observe ports `c3_ans_o`/`c3_p0_o`/`c3_p1_o`
are reused; no new DUT ports this bag.

## One unknown

On the same C5 production hierarchy, does a 1-hop planted fact
(`r_two=0`, no "indirect") return ANSWER with that destination, while a
different UART line with "indirect" still uses the planted 2-hop path?

## HIT letter this bag may measure (XSim modeled AXI)

```text
"pump requires valve" → ANSWER dest=11 proof eid 20 (1-hop, p1=0)
"pump requires indirect" → ANSWER dest=64 proof eids 16,17 (2-hop)
```

## Out of scope

CONFLICT opcode, MIG PHY, silicon, 90% LM, 800k.

## FAIL if

KEEP hashes drift, GOLDEN edited after xvlog, PROGRAM=YES, C5_MASTER claimed.
