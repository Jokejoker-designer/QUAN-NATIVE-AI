# PREREG — ASTRA-C6-OOC-PREFLIGHT-01

PROGRAM=NO. Frozen before Vivado. Does not edit C0/C1/C2 KEEP, C3/C4/C5 named
modules, leftover A09, frozen LM-06 `tiny_gpt803k_core`, or official `mig.prj`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. A09R8 is not C6 co-fit.

## One unknown

Do OOC synth resource estimates for the materially changed C3–C5 blocks
(parser, synonym index, C3 proof/learner wrap, C2 persist, C4 compact LM,
C5 production top) complete on `xc7a100tcsg324-1` without compiling MIG or A09?

## HIT letter this bag may measure (OOC synth)

```text
each named top synth_design -mode out_of_context completes
Slice LUT / FF / BRAM / DSP extracted from util reports
preferred envelope LUT<=40k FF<=50k BRAM36eq<=115 DSP<=32 is reported, not a hard fail
A09 not top; synth mig.v not compiled
whole-chip routed WNS is NOT this bag
```

Whole-chip WNS≥0 unique bit is `ASTRA-C6-WHOLECHIP-COFIT-01`.
This bag must not self-stamp `C6_MASTER=CLOSED` or `BOARD_PASS`.

## Quality bound

OOC synth utilization, not place/route, not MIG PHY, not BOARD.

## FAIL if

- KEEP hashes drift
- A09 or `tiny_gpt803k_core` or synth `mig_7series_0_mig.v` compiled
- GOLDEN edited after first Vivado
- PROGRAM=YES
- whole-chip route claimed as this bag
