# ASTRA-09-R6-UART-ISO-PUBLIC-01

Parent dispatch 2026-09-07 after auditor 20260907T0030Z ACCEPT_PARTIAL on ASTRA-09-R5-UART-ISO-INNER-01.
R5 CLOSED_NARROW inner `u_sgd` w0=+5/−6. Residual 5: that path used XSim `force`/`release` of inner ports. Need UART → **exported ports / query-learn FSM**, no sim force. Do not patch frozen A09-R2. New named DUT if ports must be added.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-09-R5, frozen `a7ng_astra_09_r2_cand_ovf.sv` (15a919f1…), frozen SGD. Copy to a new module name if you need public `iso_*` / `rew_*` ports.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-09-R6-UART-ISO-PUBLIC-01/ACK.json

## One unknown

Can UART 8N1 drive the learner **without** `force`/`release`/`deposit` — only module ports and FSM — so ISO_P3 inner w0=+5 and ISO_M3 w0=-6, load_from_tb=0?

## Required

1. Grep TB/wrap: no `force`, `release`, `deposit`. FAIL if present.
2. One SGD, the DUT’s inner instance. ISO_P3 +5, ISO_M3 -6 on hierarchical w_o[0] after port-driven update.
3. Frozen A09-R2 hash unchanged if unused; if new named copy, list it.
4. PRODUCTION_TOP=UNKNOWN. PROGRAM=NO.

SHA including .svh before xvlog. One corrective if FAIL.
