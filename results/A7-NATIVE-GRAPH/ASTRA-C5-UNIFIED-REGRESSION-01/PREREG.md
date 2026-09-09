# PREREG — ASTRA-C5-UNIFIED-REGRESSION-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, C3 held-out
KEEP, C4 adapters, C5 DDR arbiter, `a7ng_lm_graph_arb.sv`, leftover A09,
frozen LM-06 `tiny_gpt803k_core`, or official `mig.prj`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. A09R8 is not this top.
Does not self-stamp `C5_MASTER=CLOSED` or `BOARD_PASS`.

Live DUT `a7ng_astra_c5_prod_top.sv` is allowed to loop ST_DONE→ST_UART and
to decode UART control bytes for flush/reload/freeze/learn. KEEP RTL is not
edited. Simulation plant stays in this TB.

## One unknown

Can the same C5 production hierarchy, after the first UART query completes,
run a second (and later) UART line and measure Master §11 status classes
that the prior C5 prod-top bags explicitly left out of scope?

## HIT letter this bag may measure (XSim modeled AXI)

```text
typed 2-hop ANSWER on planted "pump requires indirect"
UNKNOWN on unrelated tokens with no planted keys
role reversal ("valve requires pump") is not the same ANSWER object
parser AMBIGUOUS on two-entity "pump valve requires"
SEARCH_INCOMPLETE when dir[48] overflow is planted
C2 persist_clr then reload restores persist_w0
teacher-off (ctrl!=0) ANSWER does not start a new persist
```

## Out of scope (quality bound)

- Official MIG PHY (that is ASTRA-C5-PROD-TOP-MIG-01)
- TinyGPT-802k / 90% grounded language
- Silicon UART baud / C7
- KEEP C3 has no CONFLICT opcode (parser AMB ≠ ASTRA-05 contradiction)
- Causal edge delete/replace on DDR facts
- C6 whole-chip rebuild (bit already stale vs axi1b)

## FAIL if

- KEEP hashes drift
- A09 or `tiny_gpt803k_core` compiled as DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
- `a7ng_lm_graph_arb` edited
- synth `mig_7series_0_mig.v` compiled
- bag claims C5_MASTER closed
