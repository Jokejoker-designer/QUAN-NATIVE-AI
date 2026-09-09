# PREREG — ASTRA-11-A09R3-UART-IOBFF-01

Frozen before impl. PROGRAM=NO. No board program. No JTAG/xsdb/COM12/bitstream/write_bitstream/hw_server.
Does not edit ASTRA-11-A09R3-UART-IODELAY-01 / ASTRA-11-A09R3-UART-IMPL-ROUTE-01 /
ASTRA-09-R3-UART-XSIM-01 / ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-11-A09-IMPL-ROUTE-01 /
ASTRA-SOC-RTP-WRAP-ROUTE / ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 /
frozen RTL.
Does not overwrite I/O-delay wrap WNS=+0.681, UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648,
A09 wrap WNS=+1.041, or wrap-route WNS=+5.733.
Does not open LM06 / BOARD / DDR / Master F3. Does not close ASTRA-13, BOARD_PASS, production SoC UART, LM06.
PRODUCTION_TOP stays UNKNOWN. Do not silent-freeze a top.

## Claim this revision may close

One unknown, this bag only: with **UART IOB FFs packed** (`IOB=TRUE` or equivalent wrap-level
IOB registers on `uart_txd_in` **A9** and `uart_rxd_out` **D10**) **plus the same frozen**
`set_input_delay` / `set_output_delay` **max 2.000 / min 0.500**, after **implement+route** of a
**new named UART wrap** that **instantiates** frozen `a7ng_astra_09_r2_cand_ovf` (does **not**
copy-paste the graph; does **not** compile frozen `a7ng_astra_09_integ_path.sv` as DUT) on
`xc7a100tcsg324-1` at a **declared 50 MHz** constraint with **clock-network delay included**,
is routed WNS ≥ 0 — **without a bitstream**. Quote whether IOB FFs packed.

ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681 (delays 2.000/0.500, IOB FF residual) is **not** this result.
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305 (UART IOB yes, I/O unconstrained) is **not** this result.
A09R2 wrap routed WNS=+0.648 is **not** this result.
A09 wrap routed WNS=+1.041 is **not** this result.
Wrap-route WNS=+5.733 (`arty_a7_astra_rtp_soc_top`) is **not** this result.

## Frozen UART I/O delay numbers (BEFORE impl)

Same board-UART-class envelope as ASTRA-11-A09R3-UART-IODELAY-01
(`vivado/tcl/build_a7eam01r.tcl` / `build_a7eam00s.tcl`:
`set_input_delay`/`set_output_delay` **-max 2.000** / **-min 0.500**). Not FT2232H silicon Tsu
(UART is async 115200; bit period ~8.68 µs). Not invented after WNS. Do not edit after impl.
Do **not** retune 2.000/0.500 from the +0.681 bag.

```text
UART_TXD_IN     = A9    FPGA RX   INPUT   set_input_delay
UART_RXD_OUT    = D10   FPGA TX   OUTPUT  set_output_delay
UART_IN_MAX_NS  = 2.000
UART_IN_MIN_NS  = 0.500
UART_OUT_MAX_NS = 2.000
UART_OUT_MIN_NS = 0.500
IO_CLK_REF      = uart_io_vclk  period 20.000 ns  (virtual I/O reference; same period as clk50u)
PIPE_CLK        = clk50u        period 20.000 ns  (MMCM+BUFG; REAL; not virtual)
```

`uart_io_vclk` is the **I/O timing reference** for async FT2232HQ Channel B UART. It is **not**
a substitute for the pipe clock. Pipe clock remains MMCM 100→50 + BUFG `clk50u` (propagated,
generated, auto-derived).

## Frozen IOB FF policy (BEFORE impl)

Do **not** patch frozen `uart_rx.sv` / `uart_tx.sv`. Pack UART pad registers in this wrap:

```text
IOB_FF_POLICY   = wrap-level (* IOB = "TRUE" *) + XDC set_property IOB TRUE on UART ports
UART_RX_IOB_FF  = uart_rx_iob   samples uart_txd_in (A9), feeds uart_rx.rx
UART_TX_IOB_FF  = uart_tx_iob   registered uart_tx.tx, drives uart_rxd_out (D10)
IOB_XDC         = set_property IOB TRUE [get_ports {uart_txd_in uart_rxd_out}]
PACK_PROOF      = routed BEL/LOC in IOB / ILOGIC / OLOGIC, or util IOB Flip Flops / ILOGIC / OLOGIC
```

LED I/O delay remains out of this bag.

## Frozen build identity

```text
GATE           = ASTRA-11-A09R3-UART-IOBFF-01
PART           = xc7a100tcsg324-1
VIVADO         = 2026.1
LICENSE        = D:\Xilinx\licenses\vivado_basic.lic
TOP            = a7ng_astra_11_a09r3_uart_iobff_wrap
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

With UART IOB FFs packed (`IOB=TRUE` or equivalent on `uart_txd_in` / `uart_rxd_out`) plus
the same frozen delays 2.000/0.500, after implement+route at 50 MHz, is WNS ≥ 0 — without a bitstream?

## Wrapper law

- New named UART wrap only. Instantiates frozen A09-R2 DUT. Does not duplicate QSE /
  sparse / 2-hop / SGD RTL.
- Frozen `a7ng_astra_09_integ_path.sv` is **not** compiled and **not** instantiated.
- Instantiates frozen `uart_rx` / `uart_tx`. UART pins constrained to official Arty
  D10 / A9 (cite Digilent Arty-A7-100-Master / `constraints/arty_a7_100.xdc`).
  Do not edit that file.
- Bag-local AXI plant is a **fixture** (not `a7ng_axi_bram128`, not silicon BRAM).
- `load_from_tb` path unused (`load_v_i` tied 0).
- Not `arty_a7_astra_rtp_soc_top`. Not `a7ng_astra_11_a09r3_uart_impl_wrap`.
- Not `a7ng_astra_11_a09r3_uart_iodelay_wrap` (prior bag).
- Not `a7ng_astra_09_r3_uart_wrap` (XSim bag top).
- Not PRODUCTION_TOP.

## Comparison (not identity)

- Do **not** quote ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681 as this result.
- Do **not** quote ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305 as this result.
- Do **not** quote ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648 as this result.
- Do **not** quote ASTRA-11-A09-IMPL-ROUTE-01 routed WNS=+1.041 as this result.
- Do **not** overwrite or claim wrap-route `ASTRA-SOC-RTP-WRAP-ROUTE` WNS=+5.733.
- Do **not** freeze PRODUCTION_TOP.

## Hash

SHA256 of every file Vivado compiles (RTL + XDC + tcl) **before** impl, plus
transitive `.svh` and this PREREG/ACK. R2 DUT freeze `15a919f1…`. Frozen A09
`9fdbe0d6…` MATCH provenance only (not compiled). Frozen SGD `b66ef328…`.
`uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…`. Prior I/O-delay wrap KEEP
(not compiled as this top). Prior UART impl wrap KEEP `1c3a95f4…`.

## If WNS < 0

FAIL this bag, keep the routed report, one bounded clock/constraint experiment
in this bag (post-route phys_opt; **same frozen delay numbers**; still 50 MHz;
still IOB=TRUE). Still no bitstream. Do not program a failing bit. Do not invent
new delay numbers after seeing WNS.

## Out of scope

Master ASTRA-09 production path. Master F3. LM06. BOARD_PASS. ASTRA-13.
write_bitstream. JTAG/xsdb/COM12/hw_server. PRODUCTION_TOP identity.
Silicon UART / silicon MMCM / silicon BRAM. LED I/O delay.
