# PREREG — ASTRA-C5-PROD-TOP-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, C3 held-out,
C4 adapters, C5 DDR arbiter, `a7ng_lm_graph_arb.sv`, leftover A09, frozen
LM-06 `tiny_gpt803k_core`, or official `mig.prj`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. A09R8 is not this top.

## One unknown

Can UART, role parser, sparse DDR index, descriptor fetch, shared scorer,
typed proof, pending reward, C2 persist, evidence materializer, LM06 compact
gen, and UART egress coexist in **one** production hierarchy whose DDR
clients share the C5 exclusive owner, with forbidden shortcuts absent from
the DUT?

## HIT letter this bag may measure (XSim modeled AXI)

```text
UART ingress bytes reach the role parser
parser + sparse index + descriptor path produce a C3 result
shared scorer + typed proof + pending commit visible
C2 persist journal at AWADDR=0x06000000 through owner=ckpt
evidence → compact LM06 gen → UART egress
six client grants observed; dual_err=0
qid-map / host-winner / A09 / in-DUT plant = 0
```

Unified Master regression (role reversal, 2-hop, CONFLICT, flush/reload, 90%
language) is **out of scope**. MIG PHY and whole-chip WNS are C6.
This bag must not self-stamp `C5_MASTER=CLOSED`.

## Quality bound

Modeled AXI AR/AW, not Digilent MIG. Compact C4 head, not 802k.
Simulation plant lives in the TB only.

## FAIL if

- KEEP hashes drift
- A09 or `tiny_gpt803k_core` compiled as DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
- `a7ng_lm_graph_arb` edited
- synth `mig_7series_0_mig.v` compiled
