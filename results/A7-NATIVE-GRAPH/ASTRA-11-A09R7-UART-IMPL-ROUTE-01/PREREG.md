# PREREG — ASTRA-11-A09R7-UART-IMPL-ROUTE-01

Frozen before impl. PROGRAM=NO. No board program. No JTAG/xsdb/COM12/bitstream/write_bitstream/hw_server.
Does not edit ASTRA-09-R7-UART-QUERY-REW-01 / ASTRA-11-A09R3-UART-IOBFF-HOLD-01 /
ASTRA-11-A09R3-UART-IOBFF-01 / ASTRA-11-A09R3-UART-IODELAY-01 /
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 / ASTRA-09-R3-UART-XSIM-01 /
ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-11-A09-IMPL-ROUTE-01 /
ASTRA-SOC-RTP-WRAP-ROUTE / ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 /
frozen RTL / frozen `uart_rx.sv`.
Does not overwrite R7 XSim PASS_NARROW, HOLD wrap WNS=+0.115 WHS=+0.131,
IOB-FF wrap WNS=+0.115 WHS=−4.915, I/O-delay wrap WNS=+0.681,
UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, A09 wrap WNS=+1.041, or wrap-route WNS=+5.733.
Does not open LM06 / BOARD / DDR / Master F3. Does not close ASTRA-13, BOARD_PASS, production SoC UART, LM06.
PRODUCTION_TOP stays UNKNOWN. Do not silent-freeze a top.

## Claim this revision may close

One unknown, this bag only: after implement+route of a **new named R7 UART wrap**
that **instantiates** frozen `a7ng_astra_09_r2_cand_ovf` on `xc7a100tcsg324-1` at a
**declared 50 MHz** constraint with UART pins D10/A9 and the STA envelope frozen
here (delays 2.000/0.500 + FALSE_PATH_HOLD_ASYNC_UART, IOB FF if it still packs),
with **clock-network delay included**, is Design Timing Summary **WNS ≥ 0 and
WHS ≥ 0** — **without a bitstream** and without claiming BOARD_PASS.

ASTRA-09-R7-UART-QUERY-REW-01 XSim PASS_NARROW (ans=4 then w0=-5) is **not** this result.
ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed WNS=+0.115 WHS=+0.131 is **not** this result.
ASTRA-11-A09R3-UART-IOBFF-01 routed WNS=+0.115 WHS=−4.915 is **not** this result.
ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681 is **not** this result.
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305 is **not** this result.
A09R2 wrap routed WNS=+0.648 is **not** this result.
A09 wrap routed WNS=+1.041 is **not** this result.
Wrap-route WNS=+5.733 (`arty_a7_astra_rtp_soc_top`) is **not** this result.

## Frozen STA envelope (BEFORE impl) — copy, do not invent after WNS

Handoff: copy 2.000/0.500 + FALSE_PATH_HOLD from IOdelay/HOLD bags.

```text
STA_ENVELOPE    = UART_IO_DELAY_2P000_0P500 + FALSE_PATH_HOLD_ASYNC_UART
UART_IN_MAX_NS  = 2.000
UART_IN_MIN_NS  = 0.500
UART_OUT_MAX_NS = 2.000
UART_OUT_MIN_NS = 0.500
HOLD_POLICY     = FALSE_PATH_HOLD_ASYNC_UART
IO_CLK_REF      = uart_io_vclk  period 20.000 ns  (virtual I/O reference; same period as clk50u)
PIPE_CLK        = clk50u        period 20.000 ns  (MMCM+BUFG; REAL; not virtual)
UART_TXD_IN     = A9    FPGA RX   INPUT   set_input_delay  -max 2.000 -min 0.500
UART_RXD_OUT    = D10   FPGA TX   OUTPUT  set_output_delay -max 2.000 -min 0.500
```

Rationale (policy, not a post-route number):

- Numbers 2.000/0.500 are the repo UART I/O class already frozen in
  ASTRA-11-A09R3-UART-IODELAY-01 / IOBFF (and `vivado/tcl/build_a7eam01r.tcl`).
  Copied here before impl. Not fitted to a WNS/WHS residual.
- UART 115200 is asynchronous to pipe `clk50u` (bit period ~8.68 µs). There is no
  related FTDI launch clock on the FPGA.
- Auditor 20260906T1830Z: packing ILOGIC IFF puts **0.000 ns** IBUF→IFF route against
  virtual `uart_io_vclk` SCD=0 and real MMCM+BUFG destination delay. That collision
  is WHS=−4.915 when min 0.500 is checked **without** a hold exception.
- HOLD bag (20260906T1900Z ACCEPT_PARTIAL): FALSE_PATH_HOLD_ASYNC_UART made Design
  Timing Summary WHS=+0.131 (intra-`clk50u`) with UART I/O hold excepted.
- This bag applies **both**: delays 2.000/0.500 (IOdelay envelope) **and**
  FALSE_PATH_HOLD (HOLD envelope). Hold vs 20 ns virtual I/O clock is excepted;
  0.500 is **not** a silicon hold requirement and is **not** retuned.
- IOB FF + frozen `uart_rx` 2-FF synchronizer is the CDC.

XDC (ports exist at constraint apply):

```tcl
create_clock -name uart_io_vclk -period 20.000
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]
set_false_path -hold -from [get_ports uart_txd_in]
set_false_path -hold -to   [get_ports uart_rxd_out]
```

Post-synth (when MMCM-derived `clk50u` exists; same policy, clock-to-clock):

```tcl
set_false_path -hold -from [get_clocks uart_io_vclk] -to [get_clocks clk50u]
set_false_path -hold -from [get_clocks clk50u] -to [get_clocks uart_io_vclk]
```

`uart_io_vclk` remains the **I/O timing reference** for setup (and records min 0.500).
Pipe clock remains MMCM 100→50 + BUFG `clk50u` (propagated, generated, auto-derived).

## Frozen IOB FF policy (BEFORE impl)

Do **not** patch frozen `uart_rx.sv` / `uart_tx.sv`. Pack UART pad registers in this wrap
**if they still pack** (handoff: IOB FF if it still packs; bag does not FAIL solely on unpack
when WNS≥0 and WHS≥0):

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
GATE           = ASTRA-11-A09R7-UART-IMPL-ROUTE-01
PART           = xc7a100tcsg324-1
VIVADO         = 2026.1
LICENSE        = D:\Xilinx\licenses\vivado_basic.lic
TOP            = a7ng_astra_11_a09r7_uart_impl_wrap
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

After implement+route of that named R7 UART wrap on xc7a100tcsg324-1 at 50 MHz with
D10/A9 and the frozen delay/hold envelope, is WNS ≥ 0 and WHS ≥ 0 on Design Timing
Summary — without a bitstream?

## Wrapper law

- New named UART wrap only. Instantiates frozen A09-R2 DUT. Does not duplicate QSE /
  sparse / 2-hop / SGD RTL.
- R7 wrap `a7ng_astra_09_r7_uart_query_rew_wrap` is synthesizable (UART + A09-R2 +
  UNISIM MMCM). It is **not** this bag's top: a new named wrap is required for the
  STA/IOB envelope. This wrap carries the R7 query-rew UART FSM and instantiates
  frozen A09-R2. Do not copy-paste the graph. Do not edit the R7 bag.
- Frozen `a7ng_astra_09_integ_path.sv` is **not** compiled and **not** instantiated.
- Instantiates frozen `uart_rx` / `uart_tx`. UART pins constrained to official Arty
  D10 / A9 (cite Digilent Arty-A7-100-Master / `constraints/arty_a7_100.xdc`).
  Do not edit that file.
- Bag-local AXI plant is a **fixture** (not `a7ng_axi_bram128`, not silicon BRAM).
- `load_from_tb` path unused (`load_v_i` tied 0).
- Not `arty_a7_astra_rtp_soc_top`. Not `a7ng_astra_11_a09r3_uart_impl_wrap`.
- Not `a7ng_astra_11_a09r3_uart_iodelay_wrap`.
- Not `a7ng_astra_11_a09r3_uart_iobff_wrap`.
- Not `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`.
- Not `a7ng_astra_09_r7_uart_query_rew_wrap` (XSim bag top; KEEP).
- Not `a7ng_astra_09_r3_uart_wrap` (XSim bag top).
- Not PRODUCTION_TOP.

## Comparison (not identity)

- Do **not** quote ASTRA-09-R7 XSim as this routed result.
- Do **not** quote ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed WNS=+0.115 / WHS=+0.131 as this result.
- Do **not** quote ASTRA-11-A09R3-UART-IOBFF-01 routed WNS=+0.115 / WHS=−4.915 as this result.
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
`uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…`. Prior HOLD/IOBFF/IODELAY/UART-impl
wraps KEEP (not compiled as this top). R7 XSim wrap KEEP.

## If WNS < 0 or WHS < 0

FAIL this bag, keep the routed report, one bounded experiment in this bag
(post-route `phys_opt_design`; **same frozen STA envelope**; still 50 MHz;
still IOB=TRUE; still delays 2.000/0.500; still FALSE_PATH_HOLD). Still no bitstream.
Do not program a failing bit. Do not invent delay numbers after seeing WNS/WHS.
Do not patch frozen `uart_rx.sv`.

## Out of scope

Master ASTRA-09 production path. Master F3. LM06. BOARD_PASS. ASTRA-13.
write_bitstream. JTAG/xsdb/COM12/hw_server. PRODUCTION_TOP identity.
Silicon UART / silicon MMCM / silicon BRAM. LED I/O delay.
Retune of frozen 2.000/0.500. Silent freeze of R7 wrap as PRODUCTION_TOP.
