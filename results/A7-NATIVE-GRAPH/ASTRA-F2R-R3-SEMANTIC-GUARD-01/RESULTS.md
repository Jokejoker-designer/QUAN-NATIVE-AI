# RESULTS — ASTRA-F2R-R3-SEMANTIC-GUARD-01

PROGRAM=NO. No JTAG/COM12/bit. F2R-01 and F2R-R2 bags not edited. Frozen `a7ng_astra_f2r2_hs_law.sv` / `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` not patched.

```text
XSIM_MARKER      = ASTRA_F2R3_SEM_GUARD_XSIM_PASS
VERDICT_PROPOSED = PASS (this gate only: F2R_ACCEPTANCE item 4 semantic guards + F2R2 handshake/law regressions)
SIM_TIME         = 78905 ns
FAIL             = 0
FIRST_DIVERGENCE = none
BIT              = NOT_BUILT
PROGRAM          = false
```

## Law

Instantiated frozen `a7ng_shared_rank_sgd_q8_sym_f2r2` (hash `b66ef328…`). ISO +3 x0=50 → dw0=+5 (not floor +4). ISO −3 x0=64 → dw0=−6.

## Raw XSim (`xsim.log`)

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| ISO_M3_X64_DW6 | | PASS |
| SMOKE_TWO_PROOFS | npath=2 p0=17 p1=34 ans=4 sel=0 phi0=50 txn=1 gen=1 tbl=0 obj=0 ctx=2 st=0 | PASS |
| HS one-cycle −3 then bus invert | nupd=1 cmt=1 w0=−5 w1=−6; all-32 vs oracle | PASS |
| MUT snapshot | phi0 stays 50 | PASS |
| CONFLICT_DEST | npath=2 ans=0 p0=0 st=5 acc=0 (dest 4 vs 7, w0=−16) | PASS |
| CONFLICT_NO_UPD | nupd=0 | PASS |
| SLOT0..3 | npath=4, sel=slot, phi0=50, ans=4, 32-dw | PASS |
| ZERO / FREEZE / POS | | PASS |
| DUP / WRONG_TXN / STALE_GEN / OOR_M4 | | PASS |
| RETIRE pending / drain | | PASS |
| WRONG_OBJ | st=1 npath=0 ans=0 obj=11 ctx=2 | PASS |
| DIR_NO_STEAL | `pump requires compressor` st=1 npath=0 (2-hop not stolen) | PASS |
| IND_USE_2HOP | `pump requires indirect compressor` st=0 ans=4 npath=2 | PASS |
| DIR_1HOP | `pump requires chiller` st=0 ans=1 p1=0 | PASS |
| IND_NO_1HOP | `pump requires indirect chiller` on 1-hop only st=1 | PASS |
| POLARITY | pos+forbid dest 4 → st=5 ans=0 | PASS |
| CONTEXT | `pump requires water` ans=1 not high-conf valve fctx=2 | PASS |
| FIFTH | five 2-hops dest 4 → st=6 npath=5 ans=0 | PASS |
| UNREL_NO_STALE | st=1 npath=0 ans=0 p0=0 | PASS |

Marker present. `$finish` at 78905 ns.

## Hashes

SHA freeze BEFORE xvlog `2026-09-06T12:57:52.0959240+07:00`. xsim session Sun Sep 6 12:57:56–12:57:58 2026.
Compiled + `.svh` pre/post **12/12 MATCH**.
xsim.log SHA256 `806026f2772fd4a8d157473c48b60747966c61acb493089250618b921ebb56bc`.
Frozen F2R2 integrator provenance `5e2f23c3…` (not compiled). F2R2 bag `xsim.log` still `337ca164…`.

## Open (unchanged)

Item 5 post-timeout AXI drain, F3 transfer, LM06, SoC/timing, BOARD_PASS, gen/txn wrap lifetime.
Do not call this 5 independent training seeds or BOARD_PASS.
Manager independently accepts. Do not autonomously open the next gate.
