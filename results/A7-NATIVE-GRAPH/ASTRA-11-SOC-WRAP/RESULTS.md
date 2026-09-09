# RESULTS — ASTRA-11 SOC_WRAP + IMPL_ROUTE

```text
GATE       = ASTRA-11-SOC-WRAP
TOP        = arty_a7_astra09_soc_top
PART       = xc7a100tcsg324-1
SYNTH      = DONE
OPT        = DONE
PLACE      = DONE
ROUTE      = DONE (0 failed nets)
WNS        = -4.765 ns
TNS        = -2392.529 ns (587 failing endpoints)
WHS        = 0.046 ns
THS        = 0.000 ns
RESULT     = PASS_NARROW (synth+impl+route complete; WNS/TNS reported; PROGRAM=NO)
BIT        = UNPROGRAMMED (arty_a7_astra09_soc_top.bit SHA256 C7442D16…)
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
MIG        = NO
LAW_SEL    = 1 (qse-v2-role-00)
QSE_V1_SHA = ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768 UNCHANGED
```

## Utilization (post-route, `util.rpt`)

| Resource | Used | Avail | Util% | ASTRA-10B OOC pipe |
|----------|-----:|------:|------:|-------------------:|
| LUT | 2956 | 63400 | 4.66 | 3707 |
| FF | 1550 | 126800 | 1.22 | 2364 |
| BRAM tile | 0 | 135 | 0.00 | 0 |
| DSP48E1 | 2 | 240 | 0.83 | 2 |
| Bonded IOB | 15 | 210 | 7.14 | n/a (OOC) |
| BUFG | 1 | 32 | 3.13 | n/a |
| Slice | 1085 | 15850 | 6.85 | n/a |

Post-route LUT/FF below 10B OOC because opt/place combined the glued pipe; 10B was OOC synth-only.

## Pins (cited `constraints/arty_a7_100.xdc`, confirmed `io.rpt`)

| Signal | Pin | IOSTANDARD |
|--------|-----|------------|
| CLK100MHZ | E3 | LVCMOS33 10 ns |
| uart_rxd_out (FPGA TX) | D10 | LVCMOS33 |
| uart_txd_in (FPGA RX) | A9 | LVCMOS33 |
| sw[3:0] | A8 C11 C10 A10 | LVCMOS33 |
| led[3:0] | H5 J5 T9 T10 | LVCMOS33 |
| btn[3:0] | D9 C9 B9 B8 | LVCMOS33 |

No DDR pins. No MIG. Frozen SoC tops not edited.

## Timing

Signoff `timing.rpt` Design Timing Summary (routed, -1 PRODUCTION):

- WNS = **-4.765 ns**, TNS = **-2392.529 ns**, 587 failing endpoints / 4034
- WHS = **0.046 ns**, THS = 0
- Clock: `sys_clk_pin` 10.000 ns (100 MHz)
- Worst path: `u_pipe/u_sgd/i_reg[1]` → `u_pipe/u_sgd/w_reg[24][14]` (DSP48E1 + CARRY4, 18 logic levels, 14.562 ns data)

Timing constraints are **not met** at 100 MHz. PASS_NARROW does not require WNS≥0.

## DRC / route

- Route: 2776/2776 routable nets fully routed, 0 errors (`route_status.rpt`)
- DRC: 0 errors; warnings DPIP-1 / DPOP-1 / DPOP-2 on SGD DSP48 pipelining only (`drc.rpt`)
- 0 critical warnings during route

## AXI SRAM

`a7ng_axi_bram128` synthesized (read/write FSMs inferred). Empty init + write ports tied off → BRAM array const-propagated to 0 (BRAM tile = 0). Empty index is allowed for this co-fit. AXI AR/R handshake to the pipe remains.

## Bitstream

Written to bag as **UNPROGRAMMED**. Never programmed. COM12 / JTAG `210319BE776EA` untouched. Does not overwrite Gate14/LM06/01R/02M bits.

## Not claimed

Gate14, NLU, LM06 language, MIG co-fit, BOARD_PASS, 100 MHz timing met, COM12, exam on silicon.
