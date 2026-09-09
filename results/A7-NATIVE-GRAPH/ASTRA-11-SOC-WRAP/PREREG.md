# PREREG — ASTRA-11 SOC_WRAP + IMPL_ROUTE

```text
GATE       = ASTRA-11-SOC-WRAP
TOP        = arty_a7_astra09_soc_top
PART       = xc7a100tcsg324-1
XDC        = constraints/arty_a7_100.xdc (cite only; PINMAP_AUDIT DONE)
CLK        = CLK100MHZ E3 10 ns
UART_TX    = uart_rxd_out D10 (FPGA TX)
UART_RX    = uart_txd_in A9 (FPGA RX)
SW         = A8 C11 C10 A10
LED        = H5 J5 T9 T10
BTN        = D9 C9 B9 B8
MIG        = NO
DDR_PINS   = NOT INVENTED
FROZEN_SOC = NOT EDITED (arty_a7_ng_lm06_soc_top.sv etc)
MEM        = rtl/native_graph/memory/a7ng_axi_bram128.sv DEPTH=256 x 128b
INDEX_BASE = 0x05000000 mapped into BRAM (empty init OK)
PIPE       = a7ng_astra09_pipe LAW_SEL=1 qse-v2-role-00
QSE_V1     = UNCHANGED SHA ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768
BIT        = UNPROGRAMMED if written
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
```

## Unknown this gate

Can the glued ASTRA-09 pipe + UART + on-chip AXI SRAM close synth+impl+route on xc7a100tcsg324-1 at 100 MHz without MIG and without frozen-bit overwrite?

Primary evidence: WNS/TNS, utilization, route/DRC. Empty index is allowed. Timing/util is the unknown.

## Flow

1. NEW wrapper `rtl/board/arty_a7_astra09_soc_top.sv` (do not edit frozen SoC tops).
2. NEW `rtl/native_graph/memory/a7ng_axi_bram128.sv` (do not synth `a7ng_axi_mem_model`).
3. `synth_design` then `opt/place/route`. If impl fails, record FIRST_DIVERGENCE and still write reports.
4. Bitstream in this bag is UNPROGRAMMED. Never program COM12.

## PASS_NARROW

synth+impl+route complete, WNS/TNS reported, util reported, PROGRAM=NO.

## Not claimed

Gate14, NLU, LM06 language, MIG co-fit, BOARD_PASS, COM12, frozen-bit overwrite.
