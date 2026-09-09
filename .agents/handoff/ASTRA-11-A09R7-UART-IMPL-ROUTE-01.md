# ASTRA-11-A09R7-UART-IMPL-ROUTE-01

Parent dispatch 2026-09-07 after auditor 20260907T0130Z ACCEPT_PARTIAL on ASTRA-09-R7-UART-QUERY-REW-01.
R7 CLOSED_NARROW UART query-learn XSim (ans=4 then w0=-5, no force). Residual 5: not a silent production UART freeze. Parent does **not** freeze PRODUCTION_TOP. Next: **impl+route** of a new named wrap instantiating frozen A09-R2 with UART pins D10/A9 — same STA envelope as IOdelay/HOLD (delays 2.000/0.500, FALSE_PATH_HOLD_ASYNC_UART, IOB FF if it still packs). No bitstream.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-09-R7, ASTRA-11 UART IOdelay/IOBFF/HOLD bags, frozen A09-R2. Instantiate `a7ng_astra_09_r2_cand_ovf`. New named wrap. May instantiate R7 wrap module if it is synthesizable (UART+A09-R2); do not copy-paste the graph.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-11-A09R7-UART-IMPL-ROUTE-01/ACK.json

## One unknown

After implement+route of that named R7 UART wrap on xc7a100tcsg324-1 at 50 MHz with D10/A9 and the frozen delay/hold envelope, is WNS ≥ 0 and WHS ≥ 0 on Design Timing Summary — without a bitstream?

## Required

1. PREREG freeze STA envelope **before** impl (copy 2.000/0.500 + FALSE_PATH_HOLD from HOLD bag, do not invent after WNS).
2. Hash before impl. impl+route, no write_bitstream. Quote raw WNS **and** WHS. UART IOB in io.rpt.
3. If WNS<0 or WHS<0: FAIL, keep report, one bounded experiment, still no bit.
4. PRODUCTION_TOP=UNKNOWN. Do not close ASTRA-13, BOARD, LM06.

PROGRAM=NO.
