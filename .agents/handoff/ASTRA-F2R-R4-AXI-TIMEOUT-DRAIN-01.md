# ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01

Parent dispatch 2026-09-06 after auditor 20260906T0605Z ACCEPT_PARTIAL on ASTRA-F2R-R3-SEMANTIC-GUARD-01 (item 4 CLOSED narrow). Next residual: F2R_ACCEPTANCE item 5.

Sole implementer. PROGRAM=NO. No JTAG/COM12/bit.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit F2R-01, F2R-R2, F2R-R3 bags or their frozen RTL (`a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv` if that is the R3 DUT). Do not rerun run_f2r.ps1 / run_f2r2.ps1 / run_f2r3.ps1.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01/ACK.json

## One unknown

On the actual F2R3 (or new named wrapper) AXI path, after AR timeout / SLVERR / missing RLAST / late R after timeout / late R crossing the next query: does the DUT abort, drain, and reset without a stale proof or hung ARVALID — with a written contract, not a dropped ARVALID and hope?

## Required (item 5 only)

1. Register abort/drain/reset contract for AR timeout (not only drop ARVALID).
2. Tests: response after timeout; late R crossing subsequent query; SLVERR; NOLAST; no-response; stall (keep existing stall result).
3. Smoke: retrieval→proof still works; UNREL no stale; do not claim post-timeout recovery without those tests.
4. Do not close F3, LM06, BOARD.

New named RTL/TB. PREREG + .svh hashes before xvlog. Raw XSim. One corrective if FAIL. PROGRAM=NO.
