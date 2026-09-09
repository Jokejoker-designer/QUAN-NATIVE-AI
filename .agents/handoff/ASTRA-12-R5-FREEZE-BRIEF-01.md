# ASTRA-12-R5-FREEZE-BRIEF-01

Parent dispatch 2026-09-07 after auditor 20260907T0230Z ACCEPT_PARTIAL on ASTRA-12-R4-R7-UART-CANDIDATES-01.
Table CLOSED_NARROW. Residual 8: freeze a production top **or keep UNKNOWN**. Parent does **not** pick. This bag is a **decision brief** comparing two strongest existing routed UART candidates. PRODUCTION_TOP stays UNKNOWN. PROGRAM=NO.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit 12-R2/R3/R4, A09R7 impl-route, wrap-route SoC, R7 XSim. Do not rerun impl. Do not generate a .bit. Do not write PRODUCTION_TOP= a module name.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-12-R5-FREEZE-BRIEF-01/ACK.json

## Required

1. BRIEF.md two columns only (quote raw reports, hashes):
   - **A:** `arty_a7_astra_rtp_soc_top` wrap-route WNS=+5.733 UART D10/A9 BRAM=2 (historical SoC)
   - **B:** `a7ng_astra_11_a09r7_uart_impl_wrap` WNS=+0.336 WHS=+0.104 UART IOB YES A09-R2 query-learn (XSim ans=4/w0=-5 is a **different** bag)
2. Gaps per column: unique bit, ACCEPT_BOARD, LM06, fixture plant, FALSE_PATH_HOLD, 100 MHz fail sibling.
3. PRODUCTION_TOP=UNKNOWN. Do not recommend a winner as frozen.
4. Do not close ASTRA-13, BOARD_PASS.

PROGRAM=NO.
