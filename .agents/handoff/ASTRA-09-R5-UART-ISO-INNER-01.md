# ASTRA-09-R5-UART-ISO-INNER-01

Parent dispatch 2026-09-07 after auditor 20260907T0005Z ACCEPT_PARTIAL on ASTRA-09-R4-UART-ISO-01.
R4 CLOSED_NARROW UART-driven ISO on a **sibling** `u_iso`. Residual 5: UART tokens/reward must hit the **same** learner A09-R2 query uses (`u_sgd` inner), or record that sibling ISO is the production law check. Parent chooses the **inner learner** path. Not BOARD. Not freeze.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-09-R4-UART-ISO-01, ASTRA-09-R3, frozen A09-R2/SGD. Instantiate `a7ng_astra_09_r2_cand_ovf`. New named wrap/TB. Do not add a second SGD for the ISO numbers.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-09-R5-UART-ISO-INNER-01/ACK.json

## One unknown

Can UART 8N1 drive `go_upd`/`x`/`rew` into **A09-R2 inner `u_sgd`** (hierarchical `u_a09r2.u_sgd.w_o[0]`) so ISO_P3 w0=+5 and ISO_M3 w0=-6, with load_from_tb=0 — without a sibling SGD?

## Required

1. One SGD instance: the inner A09-R2 learner. TB/wrap must not instantiate a parallel `u_iso` for the pass numbers.
2. Raw log quotes inner w0. ISO_P3 +5, ISO_M3 -6.
3. PRODUCTION_TOP=UNKNOWN. Do not close ASTRA-13, BOARD, silicon UART.
4. PROGRAM=NO.

SHA including .svh before xvlog. One corrective if FAIL.
