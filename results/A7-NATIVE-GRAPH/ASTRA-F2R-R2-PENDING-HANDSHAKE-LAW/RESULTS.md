# RESULTS — ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW

PROGRAM=NO. No JTAG/COM12/bit. F2R-01 bag not edited.

```text
XSIM_MARKER      = ASTRA_F2R2_HS_LAW_XSIM_PASS
VERDICT_PROPOSED = PASS (this gate only: selected-pending / handshake / integer-law)
SIM_TIME         = 67695 ns
FAIL             = 0 (after one in-bag corrective)
FIRST_DIVERGENCE_R0 = ISO_M3_X64_DW6  (preserved xsim_fail_r0.log)
BIT              = NOT_BUILT
PROGRAM          = false
```

## Law

`native-rank-sgd-q8-v1-sym-f2r2` — sequential MAC, symmetric RSH, acc signed40, v clamp ±768, err clamp ±1536, SHIFT=6.
ISO +3 x0=50 → dw0=+5 (floor-shift F2R was +4). ISO -3 x0=64 → dw0=-6.

Floor-shift F2R remains `ASTRA-F2R-SHARED-RANK-PENDING-01`.

## Raw XSim (xsim.log)

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| ISO_M3_X64_DW6 | | PASS |
| SMOKE_TWO_PROOFS | npath=2 p0=17 p1=34 ans=4 sel=0 phi0=50 txn=1 gen=1 tbl=0 | PASS |
| HS one-cycle -3 then bus invert | nupd=1 cmt=1 w0=-5 w1=-6; all-32 vs oracle | PASS |
| MUT_PHI_FROZEN + snapshot update | phi0 stays 50 after descriptor change | PASS |
| SHARE_P0 different hop2 | npath=2 p0=17 p1=36 ans=7 sel=1 phi0=2; 32-dw | PASS |
| SLOT0..3 | npath=4, sel=slot, phi0=50, 32-dw each | PASS |
| ZERO / FREEZE / POS | | PASS |
| DUP / WRONG_TXN / STALE_GEN / OOR_M4 | | PASS |
| RETIRE pending / drain-during-upd | | PASS |
| UNREL_NO_STALE | st=1 npath=0 ans=0 p0=0 | PASS |

## Corrective r0

Negative dw used `32'(part-select)` zero-extend → sat16(+32767). Fail log kept. One RTL sign-extend fix. TB oracles not changed.

## Hashes (pass run)

xsim.log SHA256 `337ca164ce48171c9b54c1f0d3d047c6ab871f445a84ef0791a73353d4bcf3db`
Compiled+includes pre/post match (`SHA256.txt` / `SHA256_POST.txt`), including `.svh`.

## Open (unchanged)

F3 transfer, object/context/conflict ranking, post-timeout AXI recovery, LM06, SoC/timing, BOARD_PASS.
Do not call this 5 independent training seeds.
Manager independently accepts. Do not autonomously open the next gate.
