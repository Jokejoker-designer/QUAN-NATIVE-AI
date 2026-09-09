# ASTRA-11-A09R3-UART-IMPL-ROUTE-01

Parent dispatch 2026-09-06 after auditor 20260906T1700Z ACCEPT_PARTIAL on ASTRA-09-R3-UART-XSIM-01.
UART 8N1 XSim CLOSED_NARROW. Residual 5: production UART path still needs a **named SoC top**. Parent does **not** freeze PRODUCTION_TOP. This bag is **impl+route** of a new named UART wrap instantiating frozen A09-R2, with Arty UART pins D10/A9 in XDC, **no bitstream**.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-09-R3-UART-XSIM-01, ASTRA-11-A09R2-IMPL-ROUTE-01, wrap-route SoC, frozen A09/A09-R2 sources. Instantiate `a7ng_astra_09_r2_cand_ovf`. New named top. Do not overwrite prior WNS bags.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-11-A09R3-UART-IMPL-ROUTE-01/ACK.json

## One unknown

After implement+route of that named UART wrap on xc7a100tcsg324-1 at 50 MHz with `uart_rxd_out` D10 and `uart_txd_in` A9 constrained, is WNS ≥ 0 — without a bitstream?

## Required

1. XDC: clk E3, UART D10/A9. Hash before impl.
2. impl+route, no write_bitstream. Quote routed WNS/TNS from raw report. IOB UART present in io.rpt.
3. If WNS<0: FAIL, keep report, one bounded experiment, still no bit.
4. PRODUCTION_TOP=UNKNOWN. Do not close ASTRA-13, BOARD, LM06.

PROGRAM=NO.
