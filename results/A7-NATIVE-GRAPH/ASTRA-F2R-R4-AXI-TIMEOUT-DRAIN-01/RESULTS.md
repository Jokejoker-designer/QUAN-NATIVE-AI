# RESULTS — ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01

PROGRAM=NO. No JTAG/COM12/bit. F2R-01 / F2R-R2 / F2R-R3 bags not edited.
Frozen `a7ng_astra_f2r3_sem_guard.sv` / `a7ng_astra_f2r2_hs_law.sv` /
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv` not patched. `run_f2r.ps1` / `run_f2r2.ps1` /
`run_f2r3.ps1` not rerun.

```text
XSIM_MARKER      = ASTRA_F2R4_AXI_DRAIN_XSIM_PASS
VERDICT_PROPOSED = PASS (this gate only: F2R_ACCEPTANCE item 5 abort/drain/reset)
SIM_TIME         = 20625 ns
FAIL             = 0
FIRST_DIVERGENCE = none
BIT              = NOT_BUILT
PROGRAM          = false
```

## Contract (written, not drop-ARVALID-and-hope)

Fact-AXI: AR handshake sets `axi_ost`. AR timeout without handshake drops ARVALID and
aborts (INCOMP). R timeout / SLVERR / NOLAST / no-response enter **S_DRAIN**
(RREADY=1, no new fact-AR) then **S_ABORT** (ans/proof/pending cleared). Drain
timeout locally abandons `ost_rid` in `dead_mask` and rotates fact RID 2..15.
Late R with a dead RID is discarded, not forwarded to the sparse walker.

No post-timeout **recovery** of remaining facts on the same query.

## Raw XSim (`xsim.log`)

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| SMOKE_TWO_PROOFS | st=0 npath=2 ans=4 p0=17 tbl=0 arvalid=0 ost=0 | PASS |
| LATE_R_OK (20 < TO_CYC64) | st=0 npath=2 ans=4 | PASS |
| AR_STALL | st=6 narto=1 abort=1 ost=0 arvalid=0 ans=0 | PASS |
| SLVERR | st=6 nerr=1 abort=1 ans=0 | PASS |
| NOLAST | st=6 nerr=1 ndrain=1 ans=0 | PASS |
| NORESP | st=6 nrto=1 naban=1 dead=4 (RID 2) ost=0 | PASS |
| R_AFTER_TO (80 > 64) | st=6 ans=0 ndrain=1 **not** ANSWER 4 | PASS |
| CROSS next query | ANSWER 4 p0=17; ndrain 0→1 consumed old RID | PASS |
| SMOKE_AFTER | st=0 npath=2 ans=4 | PASS |
| UNREL_NO_STALE | st=1 npath=0 ans=0 p0=0 | PASS |

Marker present. `$finish` at 20625 ns. No FAIL lines. First recorded run is the
pass run (fail-archive clause not triggered).

## Hashes

SHA freeze BEFORE xvlog `2026-09-06T13:24:08.4678233+07:00`.
xsim session Sun Sep 6 13:24:12–13:24:14 2026 PID 47768.
Compiled + `.svh` pre/post **13/13 MATCH**.
xsim.log SHA256 `98297afcbc9fe33053355b199cb29c3b3e90d66816ba45e7d08e7e63fd607f6b`.
Frozen F2R3 DUT provenance `9a7a5941…` (not compiled). Frozen SGD `b66ef328…`.
F2R3 bag `xsim.log` still `806026f2…`. F2R2 bag `xsim.log` still `337ca164…`.

## Open (unchanged)

F3 transfer, LM06, SoC/timing, BOARD_PASS, gen/txn wrap lifetime.
Do **not** claim same-query post-timeout recovery, 5 independent training seeds,
or BOARD_PASS. Manager independently accepts. Do not autonomously open the next gate.
