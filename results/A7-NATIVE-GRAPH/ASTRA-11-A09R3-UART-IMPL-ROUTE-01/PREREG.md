# PREREG — ASTRA-11-A09R3-UART-IMPL-ROUTE-01

Frozen before impl. PROGRAM=NO. No board program. No JTAG/xsdb/COM12/bitstream/write_bitstream/hw_server.
Does not edit ASTRA-09-R3-UART-XSIM-01 / ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-11-A09-IMPL-ROUTE-01 /
ASTRA-SOC-RTP-WRAP-ROUTE / ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 / frozen RTL.
Does not overwrite A09R2 wrap WNS=+0.648, A09 wrap WNS=+1.041, or wrap-route WNS=+5.733.
Does not open LM06 / BOARD / DDR / Master F3. Does not close ASTRA-13, BOARD_PASS, production SoC UART, LM06.
PRODUCTION_TOP stays UNKNOWN. Do not silent-freeze a top.

## Claim this revision may close

One unknown, this bag only: after **implement+route** of a **new named UART wrap** that
**instantiates** frozen `a7ng_astra_09_r2_cand_ovf` (does **not** copy-paste the graph; does
**not** compile frozen `a7ng_astra_09_integ_path.sv` as DUT) on `xc7a100tcsg324-1`
at a **declared 50 MHz** constraint with **clock-network delay included**, with
`uart_rxd_out` **D10** and `uart_txd_in` **A9** constrained, is routed WNS ≥ 0 —
**without a bitstream**. IOB UART must be present in `io.rpt`.

A09R2 wrap routed WNS=+0.648 (`ASTRA-11-A09R2-IMPL-ROUTE-01`, no UART) is **not** this result.
A09 wrap routed WNS=+1.041 is **not** this result.
Wrap-route WNS=+5.733 (`arty_a7_astra_rtp_soc_top`) is **not** this result.
ASTRA-09-R3-UART-XSIM-01 PASS_NARROW is **not** this result.

## Frozen build identity

```text
GATE           = ASTRA-11-A09R3-UART-IMPL-ROUTE-01
PART           = xc7a100tcsg324-1
VIVADO         = 2026.1
LICENSE        = D:\Xilinx\licenses\vivado_basic.lic
TOP            = a7ng_astra_11_a09r3_uart_impl_wrap
DUT_MODULE     = a7ng_astra_09_r2_cand_ovf
DUT_INSTANCE   = u_a09r2
UART_RX        = uart_rx  (rtl/board/uart_rx.sv)
UART_TX        = uart_tx  (rtl/board/uart_tx.sv)
UART_RXD_OUT   = D10  (FPGA TX, Digilent uart_rxd_out)
UART_TXD_IN    = A9   (FPGA RX, Digilent uart_txd_in)
PIN_CLK        = CLK100MHZ E3  period 10.000 ns  (board oscillator site; not 50 MHz identity)
PIPE_CLK       = MMCME2_BASE 100→50 + BUFG  (declared 50.000 MHz / 20.000 ns)
CLOCK_JUSTIFY  = handoff default 50 MHz; MMCM+BUFG so routed WNS includes clock-network delay
MODE           = synth_design (in-context, not OOC) ; opt_design ; place_design ; route_design
BIT            = NOT_BUILT
write_bitstream= FORBIDDEN
PROGRAM        = NO
COM12          = UNTOUCHED
JTAG           = 210319BE776EA UNTOUCHED
PRODUCTION_TOP = UNKNOWN
```

## One unknown

After implement+route of that named UART wrap on xc7a100tcsg324-1 at 50 MHz with
`uart_rxd_out` D10 and `uart_txd_in` A9 constrained, is WNS ≥ 0 — without a bitstream?

## Wrapper law

- New named UART wrap only. Instantiates frozen A09-R2 DUT. Does not duplicate QSE /
  sparse / 2-hop / SGD RTL.
- Frozen `a7ng_astra_09_integ_path.sv` is **not** compiled and **not** instantiated.
- Instantiates frozen `uart_rx` / `uart_tx`. UART pins constrained to official Arty
  D10 / A9 (cite Digilent Arty-A7-100-Master / `constraints/arty_a7_100.xdc`).
  Do not edit that file.
- Bag-local AXI plant is a **fixture** (not `a7ng_axi_bram128`, not silicon BRAM).
- `load_from_tb` path unused (`load_v_i` tied 0).
- Not `arty_a7_astra_rtp_soc_top`. Not `a7ng_astra_09_r3_uart_wrap` (XSim bag top).
- Not PRODUCTION_TOP.

## Comparison (not identity)

- Do **not** quote ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648 as this result.
- Do **not** quote ASTRA-11-A09-IMPL-ROUTE-01 routed WNS=+1.041 as this result.
- Do **not** overwrite or claim wrap-route `ASTRA-SOC-RTP-WRAP-ROUTE` WNS=+5.733.
- Do **not** claim ASTRA-09-R3-UART-XSIM-01 MAGIC A2 as this bag.
- Do **not** freeze PRODUCTION_TOP.

## Hash

SHA256 of every file Vivado compiles (RTL + XDC + tcl) **before** impl, plus
transitive `.svh` and this PREREG/ACK. R2 DUT freeze `15a919f1…`. Frozen A09
`9fdbe0d6…` MATCH provenance only (not compiled). Frozen SGD `b66ef328…`.
`uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…`.

## If WNS < 0

FAIL this bag, keep the routed report, one bounded clock/constraint experiment
in this bag. Still no bitstream. Do not program a failing bit.

## Out of scope

Master ASTRA-09 production path. Master F3. LM06. BOARD_PASS. ASTRA-13.
write_bitstream. JTAG/xsdb/COM12/hw_server. PRODUCTION_TOP identity.
Silicon UART / silicon MMCM / silicon BRAM.
