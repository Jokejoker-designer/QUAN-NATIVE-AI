# ASTRA-F2R-R5-TXN-WRAP-RESET-01

Parent dispatch 2026-09-06 after auditor 20260906T0635Z ACCEPT_PARTIAL on ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01 (item 5 CLOSED narrow). Next residual: F2R_ACCEPTANCE item 6 wrap/reset lifetime.

Sole implementer. PROGRAM=NO. No JTAG/COM12/bit.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit F2R-01, F2R-R2, F2R-R3, F2R-R4 bags or frozen RTL
(`a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`,
`a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`).
Do not rerun their run_*.ps1 / run_xsim.ps1.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-F2R-R5-TXN-WRAP-RESET-01/ACK.json

## One unknown

Can a delayed reward with an old {gen,txn} after 8-bit wrap or after rst_n fail to update a new pending that reused {1,1} — with a written epoch/lifetime contract, not in-episode equality only?

## Required (item 6 remainder only)

1. Epoch/generation that does not silently reuse a live {gen,txn} pair after wrap or hard reset if a delayed reward can still arrive.
2. Tests: wrap (or equivalent unique-key collision); post-reset replay of pre-reset {gen,txn}; reset-during-update abort (weights/pending cleared, no silent half-commit); existing in-episode dup/wrong/stale/oor still pass.
3. Smoke retrieval→proof and UNREL no stale.
4. Do not close F3, LM06, BOARD. Do not claim interconnect cancel.

New named RTL/TB. May instantiate frozen SGD. PREREG + .svh hashes before xvlog. Raw XSim. One corrective if FAIL. PROGRAM=NO.
