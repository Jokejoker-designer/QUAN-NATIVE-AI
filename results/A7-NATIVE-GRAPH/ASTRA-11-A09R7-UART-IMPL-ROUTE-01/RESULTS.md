# RESULTS — ASTRA-11-A09R7-UART-IMPL-ROUTE-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. ASTRA-09-R7-UART-QUERY-REW-01 /
ASTRA-11-A09R3-UART-IOBFF-HOLD-01 / ASTRA-11-A09R3-UART-IOBFF-01 /
ASTRA-11-A09R3-UART-IODELAY-01 / ASTRA-11-A09R3-UART-IMPL-ROUTE-01 /
ASTRA-09-R3-UART-XSIM-01 / ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-11-A09-IMPL-ROUTE-01 /
ASTRA-SOC-RTP-WRAP-ROUTE / ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 bags
not edited. Frozen A09-R2 DUT instantiated, not copy-pasted. Frozen
`a7ng_astra_09_integ_path.sv` not compiled as DUT. Frozen `uart_rx.sv` / `uart_tx.sv`
not patched. R7 XSim wrap KEEP (not this top). Prior HOLD wrap WNS=+0.115 WHS=+0.131
not overwritten. LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened.
PRODUCTION_TOP=UNKNOWN.

STA envelope (IN/OUT max 2.000 min 0.500 + FALSE_PATH_HOLD_ASYNC_UART) and IOB FF
policy were frozen in PREREG/XDC **before** impl. Delay numbers were copied from
IOdelay/HOLD, not invented after WNS.

```text
GATE             = ASTRA-11-A09R7-UART-IMPL-ROUTE-01
TOP              = a7ng_astra_11_a09r7_uart_impl_wrap
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
HOLD_POLICY      = FALSE_PATH_HOLD_ASYNC_UART
UART_IN_MAX_NS   = 2.000  (set_input_delay  -max uart_txd_in  A9)
UART_IN_MIN_NS   = 0.500  (set_input_delay  -min; hold still excepted)
UART_OUT_MAX_NS  = 2.000  (set_output_delay -max uart_rxd_out D10)
UART_OUT_MIN_NS  = 0.500  (set_output_delay -min; hold still excepted)
IO_CLK_REF       = uart_io_vclk 20.000 ns (virtual I/O reference; clocks_route.rpt V)
PIPE_CLK         = clk50u 20.000 ns (MMCM+BUFG; clocks_route.rpt P,G,A; REAL)
PART             = xc7a100tcsg324-1
VIVADO           = 2026.1  Build 6511674
PIN_CLK          = CLK100MHZ E3  period 10.000 ns  (100.000 MHz site)
MODE             = synth_design (in-context) ; opt_design ; place_design ; route_design
ROUTE            = COMPLETE  (route_status.rpt: nets with routing errors = 0)
MARKER           = ASTRA_11_A09R7_UART_IMPL_ROUTE_DONE WNS=0.336 TNS=0.000 WHS=0.104 UART_IOB=YES UART_IOBFF=YES HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN
RESULT           = PASS_NARROW (this bag only: Design Timing Summary WNS>=0 and WHS>=0 of named R7 UART wrap at declared 50 MHz with D10/A9, delays 2.000/0.500 + FALSE_PATH_HOLD_ASYNC_UART frozen before impl, IOB FFs packed). UART I/O hold vs uart_io_vclk is excepted (Inter Clock hold columns blank). Intra clk50u hold MET +0.104. Not BOARD_PASS. Not R7 XSim. Not prior HOLD WNS=+0.115 WHS=+0.131.
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
PRODUCTION_TOP   = UNKNOWN
```

## One unknown (answered)

After implement+route of named R7 UART wrap `a7ng_astra_11_a09r7_uart_impl_wrap`
instance **`u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf`** on `xc7a100tcsg324-1`
at declared 50 MHz (MMCM-derived `clk50u`, clock-network delay included) with
UART D10/A9 and the frozen delay/hold envelope, is Design Timing Summary
**WNS ≥ 0 and WHS ≥ 0** — without a bitstream?

Quoted from raw `timing_route.rpt` (Design State = **Routed**, 01:52:48):

```text
WNS(ns)=0.336  TNS=0.000  WHS=0.104  THS=0.000
TNS Failing Endpoints=0  THS Failing Endpoints=0
Clock clk50u       Period=20.000 ns  Frequency=50.000 MHz
Clock uart_io_vclk Period=20.000 ns  Frequency=50.000 MHz
All user specified timing constraints are met.
Intra clk50u WNS=0.336  WHS=0.104  failing endpoints=0
```

WNS **≥ 0**. WHS **≥ 0**. No bitstream. Bounded WNS<0/WHS<0 experiment **not run**
(not applicable). Authority is this Design Timing Summary.

UART I/O paths (same rpt Inter Clock Table; also `timing_uart_in.rpt` /
`timing_uart_out.rpt` / `UART_IODELAY.txt` / `exceptions_route.rpt`):

```text
uart_io_vclk → clk50u   setup WNS=19.270  hold = (blank / excepted)
clk50u → uart_io_vclk   setup WNS=7.313   hold = (blank / excepted)
Input Delay  (setup path) = 2.000 ns
Output Delay (setup path) = 2.000 ns
HOLD_POLICY exceptions (Hold=false, Setup not false):
  set_false_path -hold -from [get_ports uart_txd_in]
  set_false_path -hold -to   [get_ports uart_rxd_out]
```

Post-synth clock-to-clock `set_false_path -hold` uart_io_vclk↔clk50u applied
(`vivado.log` HOLD_POLICY_CLK_FALSE_PATH_HOLD_APPLIED=2, three times).

WHS=+0.104 is **intra-clk50u** hold (worst path `u_a09r2/best_p0_reg[15]` →
`tx_bytes_reg[6][7]`, Slack MET 0.104 ns). It is **not** the prior IOBFF-bag UART
IOB input hold of −4.915 ns now magically MET under min delay 0.500. That class of
path is excepted by the frozen HOLD_POLICY. `check_timing.rpt` reports
`partial_input_delay` = 0 and `partial_output_delay` = 0 (min 0.500 **was**
applied). `uart_txd_in` is **not** in `no_input_delay`; `uart_rxd_out` is **not**
in `no_output_delay`. Remaining HIGH unconstrained outputs are `led[0:3]`
(out of this bag). MEDIUM false-path-only inputs: `btn[0]`, `sw[0]`, `sw[1]`.

This is **not** ASTRA-09-R7-UART-QUERY-REW-01 XSim (ans=4 then w0=-5).
This is **not** ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed WNS=+0.115 WHS=+0.131.
This is **not** ASTRA-11-A09R3-UART-IOBFF-01 routed WNS=+0.115 WHS=−4.915.
This is **not** ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681.
This is **not** ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305.
This is **not** ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648.
This is **not** ASTRA-11-A09-IMPL-ROUTE-01 routed WNS=+1.041.
This is **not** ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733 (`arty_a7_astra_rtp_soc_top`).

Clock path on the routed worst setup path (clk50u intra, same rpt):

```text
E3 IBUF → MMCME2_ADV_X1Y2 u_mmcm/CLKOUT0 → BUFGCTRL_X0Y16 u_bufg50/O
→ net (fo=3617, routed) u_a09r2/clk
Source Clock Delay = 6.427 ns   Destination Clock Delay = 6.066 ns
Requirement = 20.000 ns
Source  u_a09r2/pc2_reg[2][3]/C
Dest    u_a09r2/u_sgd/w_reg[0][5]/D
Data Path Delay = 19.440 ns  (logic 10.452 / route 8.988)
Slack (MET) = 0.336 ns
```

`clocks_route.rpt`: `clk50u` generated from `u_mmcm/CLKOUT0`, master `sys_clk_pin`
10.000 ns, attributes **P,G,A** (not V). `uart_io_vclk` attributes **V** (I/O
reference only). Pipe clock is not virtual.

UART IOB (`io.rpt` Design State Routed):

```text
A9   uart_txd_in   INPUT   LVCMOS33  FIXED
D10  uart_rxd_out  OUTPUT  LVCMOS33  FIXED
```

IOB FF pack (`UART_IOBFF.txt` / `util_route.rpt`): `uart_rx_iob_reg`
ILOGICE2.IFF ILOGIC_X0Y171; `uart_tx_iob_reg` OLOGICE2.OUTFF OLOGIC_X0Y161;
IOB Flip Flops=2 ILOGIC=1 OLOGIC=1.

## DUT identity (raw `vivado.log`, not RESULTS)

`synth_design -top a7ng_astra_11_a09r7_uart_impl_wrap -part xc7a100tcsg324-1`
(in-context, **not** `-mode out_of_context`).

Synthesized: wrap (MMCME2_BASE + BUFG + `uart_rx_iob` / `uart_tx_iob` + R7
query-rew FSM) → `uart_rx` / `uart_tx` → **`u_a09r2` `a7ng_astra_09_r2_cand_ovf`**
→ `u_sp` `a7ng_query_axi_sparse` → `g_law.u_qse` + `u_walk`;
`u_sgd` `a7ng_shared_rank_sgd_q8_sym_f2r2`; bag-local `u_plant`
`a7ng_astra_11_a09r7_uart_impl_plant` (fixture, not `a7ng_axi_bram128`).
Markers `U_A09R2_CELLS=11063` `U_RX_CELLS=76` `U_TX_CELLS=56` `UART_IOBFF_CELLS=2`.

R7 wrap `a7ng_astra_09_r7_uart_query_rew_wrap` is synthesizable UART+A09-R2
(KEEP hashed `aeb7e194…`, **not compiled** as this top). New named wrap required
for this bag's STA/IOB envelope. Graph not copy-pasted.

**Not synthesized:** `a7ng_astra_09_integ_path` (zero synthesizing-module lines),
`a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, `arty_a7_astra_rtp_soc_top`,
`a7ng_axi_bram128`, `a7ng_astra_09_r7_uart_query_rew_wrap`,
`a7ng_astra_11_a09r3_uart_impl_wrap`, `a7ng_astra_11_a09r3_uart_iodelay_wrap`,
`a7ng_astra_11_a09r3_uart_iobff_wrap`, `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`.
File list forbids those.

## Resources (raw rpts)

Quoted **synth** `util_synth.rpt` Design State Synthesized (`UTIL_EXTRACT_SYNTH.txt`):

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **5793** | 63400 | 9.14 |
| Slice Registers (FF) | **5085** | 126800 | 4.01 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |

Quoted **routed** `util_route.rpt` Design State Routed:

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **4945** | 63400 | 7.80 |
| Slice Registers (FF) | **3615** | 126800 | 2.85 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |
| Bonded IOB | **15** | 210 | 7.14 |
| IOB Flip Flops | **2** | | |
| ILOGIC | **1** | 210 | 0.48 |
| OLOGIC | **1** | 210 | 0.48 |

Hierarchical routed (`util_hier_route.rpt`): wrap LUT=4945 FF=3615 DSP=2;
**`u_a09r2` LUT=4325 FF=2738 DSP=2**; `u_sgd` LUT=554 FF=615 DSP=2; `u_sp`
LUT=3334; `g_law.u_qse` LUT=2328; `u_plant` LUT=170 FF=73. Plant is a
**behavioral AXI fixture** (not silicon BRAM). **Not** wrap-route BRAM=2.

Do **not** add these LUT/FF to wrap-route 4244/3810, to A09R2 wrap 1321/1103, to
A09 wrap 1305/1075, to prior UART wrap 4804/3500, to I/O-delay wrap 4803/3500,
to IOB-FF wrap 4802/3500, or to HOLD wrap 4802/3500 as a whole-chip sum.

## Comparison (not identity)

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 4945 | 3615 | 0 | 2 | **Routed clk50u WNS=+0.336 WHS=+0.104 IOB FF YES delays 2.000/0.500 FALSE_PATH_HOLD** |
| This bag synth | 5793 | 5085 | 0 | 2 | Synthesized (not the quote) |
| ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed | 4802 | 3500 | 0 | 2 | Routed IOB FF YES HOLD **WNS=+0.115 WHS=+0.131** — not overwritten |
| ASTRA-11-A09R3-UART-IOBFF-01 routed | 4802 | 3500 | 0 | 2 | Routed IOB FF YES delays 2.000/0.500 **WNS=+0.115 WHS=−4.915** — not overwritten |
| ASTRA-11-A09R3-UART-IODELAY-01 routed | 4803 | 3500 | 0 | 2 | Routed delays 2.000/0.500 **no IOB FF +0.681** — not overwritten |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed | 4804 | 3500 | 0 | 2 | Routed UART IOB, **I/O unconstrained +0.305** — not overwritten |
| ASTRA-11-A09R2-IMPL-ROUTE-01 routed | 1321 | 1103 | 0 | 2 | Routed no-UART **+0.648** — not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed different DUT **+1.041** — not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |
| ASTRA-09-R7-UART-QUERY-REW-01 | — | — | — | — | XSim only (ans=4 then w0=-5) — not this routed result |

## Hashes

SHA freeze BEFORE impl `2026-09-07T01:47:46.1996747+07:00`.
Vivado start `Mon Sep 7 01:47:47 2026`, exit `Mon Sep 7 01:52:53 2026`.
Frozen A09-R2 DUT `15a919f1…` MATCH ASTRA-09-R2-CAND-OVF-01. Frozen A09 leftover
`9fdbe0d6…` MATCH provenance (not compiled). Frozen SGD `b66ef328…` MATCH.
`uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH ASTRA-09-R3-UART-XSIM-01.
R7 wrap KEEP `aeb7e194…` MATCH ASTRA-09-R7 SHA (not compiled as this top).
Prior HOLD wrap KEEP. Compiled RTL+XDC+tcl + `.svh` PRE/POST **MATCH**.
`write_bitstream` renamed to abort; never invoked (`vivado.log` has no
`write_bitstream`). No `.bit` in bag.

## Open (unchanged)

Master ASTRA-09 production path (fixture plant remains; not `a7ng_axi_bram128`).
Master F3 10pp/CI. Master ASTRA-06 DDR/NVM. Master ASTRA-10 whole-chip. LM06.
BOARD_PASS. ASTRA-13. PRODUCTION_TOP identity. Silicon UART / silicon MMCM /
silicon BRAM. LED I/O delay. Do **not** call this BOARD_PASS, R7 XSim,
prior HOLD WNS=+0.115 WHS=+0.131, prior IOB-FF WNS=+0.115 WHS=−4.915,
prior I/O-delay WNS=+0.681, prior UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648,
or wrap-route WNS=+5.733. Manager independently accepts. Do not autonomously
open the next gate. Do not freeze PRODUCTION_TOP.
