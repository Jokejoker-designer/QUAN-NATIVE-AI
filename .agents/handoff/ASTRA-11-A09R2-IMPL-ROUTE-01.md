# ASTRA-11-A09R2-IMPL-ROUTE-01

Parent dispatch 2026-09-06 after auditor 20260906T1600Z ACCEPT_PARTIAL on ASTRA-09-R2-CAND-OVF-01.
Named A09-R2 DUT closes ntrunc→INCOMP. Frozen A09 leftover still ans=4. Do not promote R2 to PRODUCTION_TOP. Next physical evidence: **implement+route** of `a7ng_astra_09_r2_cand_ovf` at 50 MHz with clock-network, no bitstream.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-09-R2-CAND-OVF-01, ASTRA-11-A09-IMPL-ROUTE-01, frozen A09, wrap-route SoC bags. Instantiate `a7ng_astra_09_r2_cand_ovf`. New named wrap. Do not copy-paste the graph. Do not overwrite A09 wrap WNS=+1.041 evidence.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-11-A09R2-IMPL-ROUTE-01/ACK.json

## One unknown

After implement+route of instantiated A09-R2 on xc7a100tcsg324-1 at 50 MHz (clock-network included), is WNS ≥ 0 — without a bitstream?

## Required

1. Hash RTL+XDC+tcl before impl. impl+route, no write_bitstream.
2. Quote WNS/TNS from **routed** report. If WNS<0: FAIL bag, keep report, one bounded experiment, still no bit.
3. PRODUCTION_TOP stays UNKNOWN. Do not close ASTRA-13, BOARD, LM06, Master F3.

PROGRAM=NO.
