# RESULTS — ASTRA-11-A09R3-UART-IODELAY-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. ASTRA-11-A09R3-UART-IMPL-ROUTE-01 /
ASTRA-09-R3-UART-XSIM-01 / ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-11-A09-IMPL-ROUTE-01 /
ASTRA-SOC-RTP-WRAP-ROUTE / ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 bags
not edited. Frozen A09-R2 DUT instantiated, not copy-pasted. Frozen
`a7ng_astra_09_integ_path.sv` not compiled as DUT. Prior UART wrap WNS=+0.305 bag not
overwritten. A09R2 wrap WNS=+0.648 bag not overwritten. A09 wrap WNS=+1.041 bag not
overwritten. Wrap-route WNS=+5.733 bag not overwritten. LM06 / BOARD / DDR /
Master F3 / ASTRA-13 not opened. PRODUCTION_TOP=UNKNOWN.

UART I/O delay numbers were frozen in PREREG/XDC **before** impl (board-UART-class
from `vivado/tcl/build_a7eam01r.tcl`: max 2.000 / min 0.500). Not invented after WNS.

```text
GATE             = ASTRA-11-A09R3-UART-IODELAY-01
TOP              = a7ng_astra_11_a09r3_uart_iodelay_wrap
DUT_MODULE       = a7ng_astra_09_r2_cand_ovf
DUT_INSTANCE     = u_a09r2
UART_RX / UART_TX= u_rx uart_rx / u_tx uart_tx  (rtl/board)
UART_RXD_OUT     = D10  (io.rpt OUTPUT LVCMOS33 FIXED)
UART_TXD_IN      = A9   (io.rpt INPUT  LVCMOS33 FIXED)
UART_IOB         = YES
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
MARKER           = ASTRA_11_A09R3_UART_IODELAY_DONE WNS=0.681 TNS=0.000 WHS=0.100 UART_IOB=YES UART_IODELAY=2.000/0.500 BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN
RESULT           = PASS_NARROW (this bag only: routed WNS of named UART wrap at declared 50 MHz with frozen UART I/O delays)
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
PRODUCTION_TOP   = UNKNOWN
```

## One unknown (answered)

With `set_input_delay` / `set_output_delay` on `uart_txd_in` A9 and `uart_rxd_out` D10
(values frozen in PREREG before impl: max 2.000 / min 0.500), after implement+route of
wrapper `a7ng_astra_11_a09r3_uart_iodelay_wrap` instance **`u_a09r2` = frozen
`a7ng_astra_09_r2_cand_ovf`** on `xc7a100tcsg324-1` at declared 50 MHz (MMCM-derived
`clk50u`, clock-network delay included):

Quoted from raw `timing_route.rpt` (Design State = **Routed**, 22:39:44):

```text
WNS(ns)=0.681  TNS=0.000  WHS=0.100  THS=0.000
TNS Failing Endpoints=0  THS Failing Endpoints=0
Clock clk50u       Period=20.000 ns  Frequency=50.000 MHz
Clock uart_io_vclk Period=20.000 ns  Frequency=50.000 MHz
All user specified timing constraints are met.
Intra clk50u WNS=0.681  WHS=0.100  failing endpoints=0
```

WNS **≥ 0**. No bitstream. Bounded WNS<0 experiment **not run** (not applicable).
`TIMING_EXTRACT.txt` CLOCK=uart_io_vclk is the extract's first 20 ns clock name;
authority for WNS is this Design Timing Summary / Intra clk50u table, not the
virtual I/O clock.

UART I/O paths (same rpt Inter Clock Table; also `timing_uart_in.rpt` /
`timing_uart_out.rpt` / `UART_IODELAY.txt`):

```text
uart_io_vclk → clk50u   setup WNS=15.179  hold WHS=1.151   (uart_txd_in A9 → u_rx/rx_sync0_reg)
clk50u → uart_io_vclk   setup WNS=4.423   hold WHS=4.517   (u_tx/tx_reg → uart_rxd_out D10)
Input Delay  (setup path) = 2.000 ns
Input Delay  (hold path)  = 0.500 ns
Output Delay (setup path) = 2.000 ns
Output Delay (hold path)  = 0.500 ns
```

UART I/O slacks are **looser** than the internal clk50u WNS=+0.681. Worst path remains
inside instantiated A09-R2, not a manufactured I/O tautology.

Quoted from raw `io.rpt` (Design `a7ng_astra_11_a09r3_uart_iodelay_wrap`):

```text
| A9         | uart_txd_in  | ... | INPUT  | LVCMOS33 | ... | FIXED |
| D10        | uart_rxd_out | ... | OUTPUT | LVCMOS33 | ... | FIXED |
| E3         | CLK100MHZ    | ... | INPUT  | LVCMOS33 | ... | FIXED |
```

`UART_IOB.txt`: `UART_IOB=YES`. Bonded IOB=15 (clk+sw+btn+led+2 UART).

`check_timing.rpt`: `uart_txd_in` is **not** in `no_input_delay`; `uart_rxd_out` is
**not** in `no_output_delay`. Remaining HIGH unconstrained outputs are `led[0:3]`
(out of this bag). MEDIUM `no_input_delay` with false path: `btn[0]`, `sw[0]`, `sw[1]`.

This is **not** ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305 (I/O unconstrained).
This is **not** ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648 (no UART).
This is **not** ASTRA-11-A09-IMPL-ROUTE-01 routed WNS=+1.041.
This is **not** ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733 (`arty_a7_astra_rtp_soc_top`).

Clock path on the routed worst setup path (clk50u intra, same rpt):

```text
E3 IBUF → MMCME2_ADV_X1Y2 u_mmcm/CLKOUT0 → BUFGCTRL_X0Y16 u_bufg50/O
→ net (fo=3500, routed) u_a09r2/clk
Source Clock Delay = 6.420 ns   Destination Clock Delay = 6.065 ns
Requirement = 20.000 ns
Source  u_a09r2/FSM_sequential_st_reg[2]_rep/C
Dest    u_a09r2/u_sgd/w_reg[19][2]/D
Data Path Delay = 19.136 ns  (logic 10.346 / route 8.790)
Slack (MET) = 0.681 ns
```

`clocks_route.rpt`: `clk50u` generated from `u_mmcm/CLKOUT0`, master `sys_clk_pin`
10.000 ns, attributes **P,G,A** (not V). `uart_io_vclk` attributes **V** (I/O
reference only). `clock_util_route.rpt`: MMCM=1, BUFGCTRL=1 at BUFGCTRL_X0Y16,
3500 clock loads, period 20.000. Pipe clock is not virtual.

## DUT identity (raw `vivado.log`, not RESULTS)

`synth_design -top a7ng_astra_11_a09r3_uart_iodelay_wrap -part xc7a100tcsg324-1`
(in-context, **not** `-mode out_of_context`).

Synthesized: wrap (MMCME2_BASE + BUFG) → `uart_rx` / `uart_tx` →
**`u_a09r2` `a7ng_astra_09_r2_cand_ovf`** → `u_sp` `a7ng_query_axi_sparse`
(LAW_SEL=1, N_BUCKETS=4096, CAND_CAP=16) → `g_law.u_qse` + `u_walk`;
`u_sgd` `a7ng_shared_rank_sgd_q8_sym_f2r2`; bag-local `u_plant`
`a7ng_astra_11_a09r3_uart_iodelay_plant` (fixture, not `a7ng_axi_bram128`).
Markers `U_A09R2_CELLS=11064` `U_RX_CELLS=76` `U_TX_CELLS=56`.

**Not synthesized:** `a7ng_astra_09_integ_path` (zero synthesizing-module lines),
`a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, `arty_a7_astra_rtp_soc_top`,
`a7ng_axi_bram128`, `a7ng_astra_11_a09r3_uart_impl_wrap`. File list forbids those.

## Resources (raw rpts)

Quoted **synth** `util_synth.rpt` Design State Synthesized (`UTIL_EXTRACT_SYNTH.txt`):

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **5682** | 63400 | 8.96 |
| Slice Registers (FF) | **5008** | 126800 | 3.95 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |

Quoted **routed** `util_route.rpt` Design State Routed:

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **4803** | 63400 | 7.58 |
| Slice Registers (FF) | **3500** | 126800 | 2.76 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |
| Bonded IOB | **15** | 210 | 7.14 |

Hierarchical routed (`util_hier_route.rpt`): wrap LUT=4803; **`u_a09r2` LUT=4293
FF=2692 DSP=2**; `u_sgd` LUT=529 FF=610 DSP=2; `u_sp` LUT=3334; `g_law.u_qse`
LUT=2329; `u_plant` LUT=171 FF=73. Plant is a **behavioral AXI fixture** (not
silicon BRAM). **Not** wrap-route BRAM=2.

Do **not** add these LUT/FF to wrap-route 4244/3810, to A09R2 wrap 1321/1103, to
A09 wrap 1305/1075, or to prior UART wrap 4804/3500 as a whole-chip sum.

## Comparison (not identity)

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 4803 | 3500 | 0 | 2 | **Routed clk50u +0.681 UART I/O delay 2.000/0.500** |
| This bag synth | 5682 | 5008 | 0 | 2 | Synthesized (not the quote) |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed | 4804 | 3500 | 0 | 2 | Routed UART IOB, **I/O unconstrained +0.305** — not overwritten |
| ASTRA-11-A09R2-IMPL-ROUTE-01 routed | 1321 | 1103 | 0 | 2 | Routed no-UART **+0.648** — not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed different DUT **+1.041** — not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |

## Hashes

SHA freeze BEFORE impl `2026-09-06T22:34:41.8633774+07:00`.
Vivado start `Sun Sep 6 22:34:43 2026`, exit `Sun Sep 6 22:39:49 2026`.
Frozen A09-R2 DUT `15a919f1…` MATCH ASTRA-09-R2-CAND-OVF-01. Frozen A09 leftover
`9fdbe0d6…` MATCH provenance (not compiled). Frozen SGD `b66ef328…` MATCH.
`uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH ASTRA-09-R3-UART-XSIM-01.
Prior UART impl wrap `1c3a95f4…` MATCH KEEP (not compiled as this top).
Prior UART impl XDC `506a3e12…` MATCH KEEP. Prior A09R2 wrap `1932ee4c…` MATCH.
Compiled RTL+XDC+tcl + `.svh` PRE/POST **19/19 MATCH**. `write_bitstream` renamed
to abort; never invoked. No `.bit` in bag.

## Open (unchanged)

Master ASTRA-09 production path (fixture plant remains; not `a7ng_axi_bram128`).
Master F3 10pp/CI. Master ASTRA-06 DDR/NVM. Master ASTRA-10 whole-chip. LM06.
BOARD_PASS. ASTRA-13. PRODUCTION_TOP identity. Silicon UART / silicon MMCM /
silicon BRAM. LED I/O delay. IOB FF pack. Do **not** call this BOARD_PASS, prior
UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, wrap-route WNS=+5.733, or
ASTRA-09-R3-UART-XSIM MAGIC A2. Manager independently accepts.
Do not autonomously open the next gate. Do not freeze PRODUCTION_TOP.
