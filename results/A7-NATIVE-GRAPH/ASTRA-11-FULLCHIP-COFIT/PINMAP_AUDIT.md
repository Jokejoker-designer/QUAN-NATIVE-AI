# ASTRA-11 PINMAP_AUDIT — evidence only, not a co-fit PASS

```text
GATE     = ASTRA-11-FULLCHIP-COFIT
ITEM     = PINMAP_AUDIT
BIT      = NO
PROGRAM  = NO
COM12    = UNTOUCHED
INVENTED_PINS = NO
```

## CONFIRMED (files in this clone)

| Signal | Package pin | Source |
|--------|-------------|--------|
| CLK100MHZ | E3 LVCMOS33, 10 ns | `constraints/arty_a7_100.xdc` (Digilent Arty-A7-100 master) |
| uart_rxd_out (FPGA TX) | D10 LVCMOS33 | same XDC |
| uart_txd_in (FPGA RX) | A9 LVCMOS33 | same XDC |
| sw[3:0] | A8 C11 C10 A10 | same XDC |
| led[3:0] | H5 J5 T9 T10 | same XDC |
| btn[3:0] | D9 C9 B9 B8 | same XDC |
| DDR3 | Digilent MIG preset, not this XDC | XDC comment: do not invent DDR pins |

Frozen SoC tops already use that UART/CLK set:

- `rtl/board/arty_a7_ng_lm06_soc_top.sv`
- `rtl/board/arty_a7_ng_native_v1_ab_soc_top.sv`
- `rtl/board/arty_a7_ng_integrate_soc_top.sv`

`a7ng_g1g5_cofit` has **no** board pins (clk/rst + graph/C9 ports only).
`a7ng_unified_pipe` has **no** board pins (clk/rst + token/load/status).

## OBSERVED gap

ASTRA pipe is an inner module. Fullchip requires a **new** SoC wrapper that:

1. Reuses the existing UART/CLK/LED/SW/BTN pins above (no new I/O).
2. Reuses Digilent MIG pinout already in frozen LM06 SoC — not a hand-drawn DDR map.
3. Does **not** overwrite a frozen Gate14/LM06 bitstream.
4. Defines an address/byte protocol so UART tokens feed `tok_i` without host-supplied winners.

That wrapper is **not** this audit. Creating it is a separate RTL item and still BIT=NO / PROGRAM=NO.

## INFERRED (not confirmed)

OOC LUT 2966 + historical U2R ~36911 may fit xc7a100t on paper. That is not post-route co-fit of ASTRA+LM06+MIG together.

## Result

`PINMAP_AUDIT` = DONE. `astra11` remains `BLOCKED_NO_PINMAP` for **impl/route/bit**.
Board pins for a future wrapper are **cited**, not invented.

NEXT unblocked: `SPARSE09_GLUE`.
