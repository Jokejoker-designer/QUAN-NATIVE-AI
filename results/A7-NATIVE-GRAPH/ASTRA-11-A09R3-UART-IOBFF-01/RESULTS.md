# RESULTS — ASTRA-11-A09R3-UART-IOBFF-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. ASTRA-11-A09R3-UART-IODELAY-01 /
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 / ASTRA-09-R3-UART-XSIM-01 / ASTRA-11-A09R2-IMPL-ROUTE-01 /
ASTRA-11-A09-IMPL-ROUTE-01 / ASTRA-SOC-RTP-WRAP-ROUTE / ASTRA-SOC-RTP-WRAP-UART-XSIM /
ASTRA-09-R2-CAND-OVF-01 bags not edited. Frozen A09-R2 DUT instantiated, not copy-pasted. Frozen
`a7ng_astra_09_integ_path.sv` not compiled as DUT. Prior I/O-delay wrap WNS=+0.681 bag not
overwritten. Prior UART wrap WNS=+0.305 bag not overwritten. A09R2 wrap WNS=+0.648 bag not
overwritten. A09 wrap WNS=+1.041 bag not overwritten. Wrap-route WNS=+5.733 bag not overwritten.
LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened. PRODUCTION_TOP=UNKNOWN.

UART I/O delay numbers and IOB FF policy were frozen in PREREG/XDC **before** impl
(board-UART-class max 2.000 / min 0.500; wrap `(* IOB = "TRUE" *)` + XDC `IOB TRUE`).
Not invented after WNS. Frozen `uart_rx.sv` / `uart_tx.sv` not patched.

```text
GATE             = ASTRA-11-A09R3-UART-IOBFF-01
TOP              = a7ng_astra_11_a09r3_uart_iobff_wrap
DUT_MODULE       = a7ng_astra_09_r2_cand_ovf
DUT_INSTANCE     = u_a09r2
UART_RX / UART_TX= u_rx uart_rx / u_tx uart_tx  (rtl/board)
UART_RXD_OUT     = D10  (io.rpt OUTPUT LVCMOS33 FIXED)
UART_TXD_IN      = A9   (io.rpt INPUT  LVCMOS33 FIXED)
UART_IOB         = YES
UART_IOBFF       = YES
UART_RX_IOB_FF   = uart_rx_iob_reg  BEL=ILOGICE2.IFF  LOC=ILOGIC_X0Y171
UART_TX_IOB_FF   = uart_tx_iob_reg  BEL=OLOGICE2.OUTFF LOC=OLOGIC_X0Y161
UTIL_IOB_FFS     = 2
UTIL_ILOGIC      = 1
UTIL_OLOGIC      = 1
UART_IN_MAX_NS   = 2.000  (set_input_delay  -max uart_txd_in  A9)
UART_IN_MIN_NS   = 0.500  (set_input_delay  -min uart_txd_in  A9)
UART_OUT_MAX_NS  = 2.000  (set_output_delay -max uart_rxd_out D10)
UART_OUT_MIN_NS  = 0.500  (set_output_delay -min uart_rxd_out D10)
IO_CLK_REF       = uart_io_vclk 20.000 ns (virtual I/O reference; clocks_route.rpt V)
PIPE_CLK         = clk50u 20.000 ns (MMCM+BUFG; clocks_route.rpt P,G,A; REAL)
PART             = xc7a100tcsg324-1
VIVADO           = 2026.1  Build 6511674
PIN_CLK          = CLK100MHZ E3  period 10.000 ns  (100.000 MHz site)
MODE             = synth_design (in-context) ; opt_design ; place_design ; route_design
ROUTE            = COMPLETE  (route_status.rpt: nets with routing errors = 0)
MARKER           = ASTRA_11_A09R3_UART_IOBFF_DONE WNS=0.115 TNS=0.000 WHS=-4.915 UART_IOB=YES UART_IOBFF=YES UART_IODELAY=2.000/0.500 BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN
RESULT           = PASS_NARROW (this bag only: routed WNS of named UART wrap at declared 50 MHz with IOB FFs packed and frozen delays 2.000/0.500). HOLD_FINDING: Design Timing Summary WHS=-4.915 (1 UART IOB input hold endpoint). Intra clk50u hold MET +0.131. Do not claim all-constraints-met.
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
PRODUCTION_TOP   = UNKNOWN
```

## One unknown (answered)

With UART IOB FFs packed (`IOB=TRUE` wrap registers on `uart_txd_in` A9 / `uart_rxd_out` D10)
plus the same frozen delays 2.000/0.500, after implement+route of wrapper
`a7ng_astra_11_a09r3_uart_iobff_wrap` instance **`u_a09r2` = frozen
`a7ng_astra_09_r2_cand_ovf`** on `xc7a100tcsg324-1` at declared 50 MHz (MMCM-derived
`clk50u`, clock-network delay included):

Quoted from raw `timing_route.rpt` (Design State = **Routed**, 23:06:09):

```text
WNS(ns)=0.115  TNS=0.000  WHS=-4.915  THS=-4.915
TNS Failing Endpoints=0  THS Failing Endpoints=1
Clock clk50u       Period=20.000 ns  Frequency=50.000 MHz
Clock uart_io_vclk Period=20.000 ns  Frequency=50.000 MHz
Timing constraints are not met.
Intra clk50u WNS=0.115  WHS=0.131  failing endpoints=0
```

WNS **≥ 0**. No bitstream. Bounded WNS<0 experiment **not run** (not applicable).
Raw summary says constraints are **not** met because of **hold**, not setup.
`TIMING_EXTRACT.txt` CLOCK=clk50u (extract prefers clk50u among 20 ns clocks).
Authority for WNS is this Design Timing Summary / Intra clk50u table.

UART I/O paths (same rpt Inter Clock Table; also `timing_uart_in.rpt` /
`timing_uart_out.rpt` / `UART_IODELAY.txt`):

```text
uart_io_vclk → clk50u   setup WNS=19.270  hold WHS=-4.915  (uart_txd_in A9 → uart_rx_iob_reg ILOGIC_X0Y171)
clk50u → uart_io_vclk   setup WNS=7.313   hold WHS=3.662   (uart_tx_iob_reg OLOGIC_X0Y161 → uart_rxd_out D10)
Input Delay  (setup path) = 2.000 ns
Input Delay  (hold path)  = 0.500 ns
Output Delay (setup path) = 2.000 ns
Output Delay (hold path)  = 0.500 ns
```

HOLD_FINDING (not the WNS unknown): UART input hold fails because the IOB FF has **0.000 ns
route** from IBUF to `uart_rx_iob_reg/D` while destination clock delay through real
MMCM+BUFG is 6.503 ns and `uart_io_vclk` source clock delay is 0 (virtual). Arrival 1.955 ns
vs required 6.870 ns → slack **−4.915 ns**. Prior I/O-delay bag (fabric `u_rx/rx_sync0_reg`)
had +1.151 ns hold from 2.975 ns fabric route. This is an STA artifact of packing the pad FF
against a 20 ns virtual I/O clock with min delay 0.500. Intra-`clk50u` hold remains MET.
Do **not** retune 2.000/0.500 after seeing this (PREREG). Do not claim silicon UART.

Worst setup path remains inside instantiated A09-R2 (not an I/O tautology).

Quoted from raw `io.rpt` (Design `a7ng_astra_11_a09r3_uart_iobff_wrap`):

```text
| A9         | uart_txd_in  | ... | INPUT  | LVCMOS33 | ... | FIXED |
| D10        | uart_rxd_out | ... | OUTPUT | LVCMOS33 | ... | FIXED |
```

`UART_IOB.txt`: `UART_IOB=YES`. Bonded IOB=15 (clk+sw+btn+led+2 UART).

`UART_IOBFF.txt`: `UART_IOBFF=YES`. `util_route.rpt`: IOB Flip Flops=**2**, ILOGIC=**1**,
OLOGIC=**1**.

`check_timing.rpt`: `uart_txd_in` is **not** in `no_input_delay`; `uart_rxd_out` is
**not** in `no_output_delay`. Remaining HIGH unconstrained outputs are `led[0:3]`
(out of this bag). MEDIUM `no_input_delay` with false path: `btn[0]`, `sw[0]`, `sw[1]`.

This is **not** ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681 (no IOB FF; that rpt date
Sun Sep 6 22:39:44, Design `…uart_iodelay_wrap`, still on disk).
This is **not** ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305 (I/O unconstrained).
This is **not** ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648 (no UART).
This is **not** ASTRA-11-A09-IMPL-ROUTE-01 routed WNS=+1.041.
This is **not** ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733 (`arty_a7_astra_rtp_soc_top`).

Clock path on the routed worst setup path (clk50u intra, same rpt):

```text
E3 IBUF → MMCME2_ADV_X1Y2 u_mmcm/CLKOUT0 → BUFGCTRL_X0Y16 u_bufg50/O
→ net (fo=3502, routed) u_a09r2/clk
Source Clock Delay = 6.417 ns   Destination Clock Delay = 6.058 ns
Requirement = 20.000 ns
Source  u_a09r2/pv_reg[0][0]/C
Dest    u_a09r2/best_a_reg[0]/D
Data Path Delay = 19.796 ns  (logic 6.899 / route 12.897)
Slack (MET) = 0.115 ns
```

`clocks_route.rpt`: `clk50u` generated from `u_mmcm/CLKOUT0`, master `sys_clk_pin`
10.000 ns, attributes **P,G,A** (not V). `uart_io_vclk` attributes **V** (I/O
reference only). Pipe clock is not virtual.

## DUT identity (raw `vivado.log`, not RESULTS)

`synth_design -top a7ng_astra_11_a09r3_uart_iobff_wrap -part xc7a100tcsg324-1`
(in-context, **not** `-mode out_of_context`).

Synthesized: wrap (MMCME2_BASE + BUFG + `uart_rx_iob` / `uart_tx_iob`) →
`uart_rx` / `uart_tx` → **`u_a09r2` `a7ng_astra_09_r2_cand_ovf`** →
`u_sp` `a7ng_query_axi_sparse` → `g_law.u_qse` + `u_walk`;
`u_sgd` `a7ng_shared_rank_sgd_q8_sym_f2r2`; bag-local `u_plant`
`a7ng_astra_11_a09r3_uart_iobff_plant` (fixture, not `a7ng_axi_bram128`).
Markers `U_A09R2_CELLS=11064` `U_RX_CELLS=76` `U_TX_CELLS=56` `UART_IOBFF_CELLS=2`.

**Not synthesized:** `a7ng_astra_09_integ_path` (zero synthesizing-module lines),
`a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, `arty_a7_astra_rtp_soc_top`,
`a7ng_axi_bram128`, `a7ng_astra_11_a09r3_uart_impl_wrap`,
`a7ng_astra_11_a09r3_uart_iodelay_wrap`. File list forbids those.

## Resources (raw rpts)

Quoted **synth** `util_synth.rpt` Design State Synthesized (`UTIL_EXTRACT_SYNTH.txt`):

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **5682** | 63400 | 8.96 |
| Slice Registers (FF) | **5010** | 126800 | 3.95 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |

Quoted **routed** `util_route.rpt` Design State Routed:

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **4802** | 63400 | 7.57 |
| Slice Registers (FF) | **3500** | 126800 | 2.76 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |
| Bonded IOB | **15** | 210 | 7.14 |
| IOB Flip Flops | **2** | | |
| ILOGIC | **1** | 210 | 0.48 |
| OLOGIC | **1** | 210 | 0.48 |

Hierarchical routed (`util_hier_route.rpt`): wrap LUT=4802; **`u_a09r2` LUT=4293
FF=2692 DSP=2**; `u_sgd` LUT=530 FF=610 DSP=2; `u_sp` LUT=3334; `g_law.u_qse`
LUT=2328; `u_plant` LUT=170 FF=73. Plant is a **behavioral AXI fixture** (not
silicon BRAM). **Not** wrap-route BRAM=2.

Do **not** add these LUT/FF to wrap-route 4244/3810, to A09R2 wrap 1321/1103, to
A09 wrap 1305/1075, to prior UART wrap 4804/3500, or to I/O-delay wrap 4803/3500
as a whole-chip sum.

## Comparison (not identity)

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 4802 | 3500 | 0 | 2 | **Routed clk50u +0.115 IOB FF YES delays 2.000/0.500; WHS=-4.915 I/O hold** |
| This bag synth | 5682 | 5010 | 0 | 2 | Synthesized (not the quote) |
| ASTRA-11-A09R3-UART-IODELAY-01 routed | 4803 | 3500 | 0 | 2 | Routed delays 2.000/0.500 **no IOB FF +0.681** — not overwritten |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed | 4804 | 3500 | 0 | 2 | Routed UART IOB, **I/O unconstrained +0.305** — not overwritten |
| ASTRA-11-A09R2-IMPL-ROUTE-01 routed | 1321 | 1103 | 0 | 2 | Routed no-UART **+0.648** — not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed different DUT **+1.041** — not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |

## Hashes

SHA freeze BEFORE impl `2026-09-06T23:01:09.4037414+07:00`.
Vivado start `Sun Sep 6 23:01:10 2026`, exit `Sun Sep 6 23:06:14 2026`.
Frozen A09-R2 DUT `15a919f1…` MATCH ASTRA-09-R2-CAND-OVF-01. Frozen A09 leftover
`9fdbe0d6…` MATCH provenance (not compiled). Frozen SGD `b66ef328…` MATCH.
`uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH ASTRA-09-R3-UART-XSIM-01.
Prior UART impl wrap `1c3a95f4…` MATCH KEEP (not compiled as this top).
Prior I/O-delay wrap `34353bb7…` MATCH KEEP. Prior I/O-delay XDC `7023fd8a…` MATCH KEEP.
Compiled RTL+XDC+tcl + `.svh` PRE/POST **MATCH**. `write_bitstream` renamed
to abort; never invoked. No `.bit` in bag.

## Open (unchanged)

Master ASTRA-09 production path (fixture plant remains; not `a7ng_axi_bram128`).
Master F3 10pp/CI. Master ASTRA-06 DDR/NVM. Master ASTRA-10 whole-chip. LM06.
BOARD_PASS. ASTRA-13. PRODUCTION_TOP identity. Silicon UART / silicon MMCM /
silicon BRAM. LED I/O delay. UART IOB input **hold** vs virtual `uart_io_vclk`
(this bag's HOLD_FINDING). Do **not** call this BOARD_PASS, prior I/O-delay
WNS=+0.681, prior UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, wrap-route
WNS=+5.733, or all-constraints-met. Manager independently accepts.
Do not autonomously open the next gate. Do not freeze PRODUCTION_TOP.
