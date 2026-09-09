# Cursor 验收 — C3→C6 ladder (independent of DeepSeek)

DeepSeek may draft. This file is the **accept plan** if DeepSeek hangs, overclaims, or mixes unknowns.
PROGRAM=NO. BOARD_PASS stays REJECT until C7.

## Honest closeability

| Gate | Can DeepSeek/Cursor close tonight? | Why |
|---|---|---|
| C3 XSim bag | Implementable as first named bag after WO READY | Needs 4-arm TB + disjoint worlds; not A09R8 w0 |
| C3 Master | NO until HIT letter + optional reload bag | 5 seeds, CI, gain≥10pp |
| C4 | NO without LM06-BYTE256 image + ablations | Language gate, not composer arithmetic |
| C5 | NO until C3+C4 blocks exist to instantiate | One top; A09R8 is checkpoint not production top |
| C6 | NO without Vivado impl of that top | WNS>=0 unique bit; A09R8 excluded |

## Ordered bags (one unknown)

| # | Bag | Unknown | Evidence |
|---|---|---|---|
| 1 | `ASTRA-C3-HELD-OUT-01` | gain A vs B on disjoint held-out, 5 seeds, 4 arms | XSIM |
| 2 | `ASTRA-C3-HELD-OUT-RELOAD-01` | retention drop ≤5pp after C2 persist clr+reload | XSIM (C2 KEEP submodule) |
| 3 | `ASTRA-C4-LM06-BYTE256-CONTRACT-01` | versioned 8-bit token law + provenance manifest | XSIM/HOST law freeze |
| 4 | `ASTRA-C4-LM06-GROUNDED-GEN-01` | tokens from materialized proof; 3 ablations | XSIM |
| 5 | `ASTRA-C5-DDR-ARB-01` | one DDR owner, no mid-flight owner change | XSIM |
| 6 | `ASTRA-C5-PROD-TOP-01` | instantiate parser+MIG index+persist+LM+UART; no plant authority | XSIM |
| 7 | `ASTRA-C6-OOC-PREFLIGHT-01` | OOC of changed blocks only | OOC |
| 8 | `ASTRA-C6-WHOLECHIP-COFIT-01` | WNS>=0 TNS=0 on **that** top; freeze manifest | POST_ROUTE |

Do not start bag N+1 before bag N RESULTS exist (except 7 may preflight estimates).
Do not stamp C3–C6 CLOSED_XSIM from this document.

## Unblock if DeepSeek stuck

Cursor implements bag 1 only: TB CLASS names from `c3_heldout_prereg_gate.py` required list.
Instantiate C1 synonym wrap KEEP + C2 persist KEEP as submodules; do not edit KEEP.
Gold hashed before xvlog. PROGRAM=NO.
