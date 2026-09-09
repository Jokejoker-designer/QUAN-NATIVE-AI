# RESULTS — ASTRA-11-A09R3-UART-IMPL-ROUTE-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. ASTRA-09-R3-UART-XSIM-01 /
ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-11-A09-IMPL-ROUTE-01 / ASTRA-SOC-RTP-WRAP-ROUTE /
ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 bags not edited. Frozen A09-R2
DUT instantiated, not copy-pasted. Frozen `a7ng_astra_09_integ_path.sv` not compiled
as DUT. A09R2 wrap WNS=+0.648 bag not overwritten. A09 wrap WNS=+1.041 bag not
overwritten. Wrap-route WNS=+5.733 bag not overwritten. LM06 / BOARD / DDR /
Master F3 / ASTRA-13 not opened. PRODUCTION_TOP=UNKNOWN.

```text
GATE             = ASTRA-11-A09R3-UART-IMPL-ROUTE-01
TOP              = a7ng_astra_11_a09r3_uart_impl_wrap
DUT_MODULE       = a7ng_astra_09_r2_cand_ovf
DUT_INSTANCE     = u_a09r2
UART_RX / UART_TX= u_rx uart_rx / u_tx uart_tx  (rtl/board)
UART_RXD_OUT     = D10  (io.rpt OUTPUT LVCMOS33 FIXED)
UART_TXD_IN      = A9   (io.rpt INPUT  LVCMOS33 FIXED)
UART_IOB         = YES
PART             = xc7a100tcsg324-1
VIVADO           = 2026.1  Build 6511674
PIN_CLK          = CLK100MHZ E3  period 10.000 ns  (100.000 MHz site)
PIPE_CLK         = clk50u  period 20.000 ns  (50.000 MHz)  MMCM 100→50 + BUFG
MODE             = synth_design (in-context) ; opt_design ; place_design ; route_design
ROUTE            = COMPLETE  (route_status.rpt: nets with routing errors = 0)
MARKER           = ASTRA_11_A09R3_UART_IMPL_ROUTE_DONE WNS=0.305 TNS=0.000 WHS=0.024 UART_IOB=YES BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN
RESULT           = PASS_NARROW (this bag only: routed WNS of named UART wrap at declared 50 MHz with D10/A9 IOB)
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
PRODUCTION_TOP   = UNKNOWN
```

## One unknown (answered)

After implement+route of wrapper `a7ng_astra_11_a09r3_uart_impl_wrap` instance
**`u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf`** on `xc7a100tcsg324-1` at declared
50 MHz (MMCM-derived `clk50u`, clock-network delay included), with `uart_rxd_out`
D10 and `uart_txd_in` A9 constrained:

Quoted from raw `timing_route.rpt` (Design State = **Routed**, 22:12:21):

```text
WNS(ns)=0.305  TNS=0.000  WHS=0.024  THS=0.000
TNS Failing Endpoints=0  THS Failing Endpoints=0
Clock clk50u  Period=20.000 ns  Frequency=50.000 MHz
All user specified timing constraints are met.
Intra clk50u WNS=0.305  WHS=0.024  failing endpoints=0
```

WNS **≥ 0**. No bitstream. Bounded WNS<0 experiment **not run** (not applicable).

Quoted from raw `io.rpt` (Design `a7ng_astra_11_a09r3_uart_impl_wrap`, Total User IO=15):

```text
| A9         | uart_txd_in  | ... | INPUT  | LVCMOS33 | ... | FIXED |
| D10        | uart_rxd_out | ... | OUTPUT | LVCMOS33 | ... | FIXED |
| E3         | CLK100MHZ    | ... | INPUT  | LVCMOS33 | ... | FIXED |
```

`UART_IOB.txt`: `UART_IOB=YES`. Bonded IOB=15 (clk+sw+btn+led+2 UART).

This is **not** ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648 (no UART).
This is **not** ASTRA-11-A09-IMPL-ROUTE-01 routed WNS=+1.041.
This is **not** ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733 (`arty_a7_astra_rtp_soc_top`).
This is **not** ASTRA-09-R3-UART-XSIM-01 MAGIC A2.

Clock path on the routed worst setup path:

```text
E3 IBUF → MMCME2_ADV_X1Y2 u_mmcm/CLKOUT0 → BUFGCTRL_X0Y16 u_bufg50/O
→ net (fo=3500, routed) u_a09r2/clk
Source Clock Delay = 6.429 ns   Destination Clock Delay = 5.875 ns
Requirement = 20.000 ns
Source  u_a09r2/pv_reg[0][1]/C
Dest    u_a09r2/best_a_reg[13]/D
Data Path Delay = 19.328 ns  (logic 6.867 / route 12.461)
Slack (MET) = 0.305 ns
```

`clocks_route.rpt`: `clk50u` generated from `u_mmcm/CLKOUT0`, master `sys_clk_pin`
10.000 ns. `clock_util_route.rpt`: MMCM=1, BUFGCTRL=1 at BUFGCTRL_X0Y16, 3500
clock loads, period 20.000. Not a virtual clock.

## DUT identity (raw `vivado.log`, not RESULTS)

`synth_design -top a7ng_astra_11_a09r3_uart_impl_wrap -part xc7a100tcsg324-1`
(in-context, **not** `-mode out_of_context`).

Synthesized: wrap (MMCME2_BASE + BUFG) → `uart_rx` / `uart_tx` →
**`u_a09r2` `a7ng_astra_09_r2_cand_ovf`** → `u_sp` `a7ng_query_axi_sparse`
(LAW_SEL=1, N_BUCKETS=4096, CAND_CAP=16) → `g_law.u_qse` + `u_walk`;
`u_sgd` `a7ng_shared_rank_sgd_q8_sym_f2r2`; bag-local `u_plant`
`a7ng_astra_11_a09r3_axi_plant` (fixture, not `a7ng_axi_bram128`).
Markers `U_A09R2_CELLS=11064` `U_RX_CELLS=76` `U_TX_CELLS=56`.

**Not synthesized:** `a7ng_astra_09_integ_path` (zero synthesizing-module lines),
`a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, `arty_a7_astra_rtp_soc_top`,
`a7ng_axi_bram128`. File list forbids those.

## Resources (raw rpts)

Quoted **synth** `util_synth.rpt` Design State Synthesized:

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **5682** | 63400 | 8.96 |
| Slice Registers (FF) | **5008** | 126800 | 3.95 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |

Quoted **routed** `util_route.rpt` Design State Routed 22:12:20:

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **4804** | 63400 | 7.58 |
| Slice Registers (FF) | **3500** | 126800 | 2.76 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |
| Bonded IOB | **15** | 210 | 7.14 |

Hierarchical routed (`util_hier_route.rpt`): wrap LUT=4804; **`u_a09r2` LUT=4294
FF=2692 DSP=2**; `u_sgd` LUT=529 FF=610 DSP=2; `u_sp` LUT=3336; `u_plant` LUT=171
FF=73. Plant is a **behavioral AXI fixture** (not silicon BRAM). **Not** wrap-route
BRAM=2 (no `a7ng_axi_bram128` in this instance).

Do **not** add these LUT/FF to wrap-route 4244/3810, to A09R2 wrap 1321/1103, or to
A09 wrap 1305/1075 as a whole-chip sum.

## Comparison (not identity)

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 4804 | 3500 | 0 | 2 | **Routed clk50u +0.305 UART IOB YES** |
| This bag synth | 5682 | 5008 | 0 | 2 | Synthesized (not the quote) |
| ASTRA-11-A09R2-IMPL-ROUTE-01 routed | 1321 | 1103 | 0 | 2 | Routed no-UART **+0.648** — not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed different DUT **+1.041** — not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |

## Hashes

SHA freeze BEFORE impl `2026-09-06T22:07:20.3622740+07:00`.
Vivado start `Sun Sep 6 22:07:21 2026`, exit `Sun Sep 6 22:12:26 2026`.
Frozen A09-R2 DUT `15a919f1…` MATCH ASTRA-09-R2-CAND-OVF-01. Frozen A09 leftover
`9fdbe0d6…` MATCH provenance (not compiled). Frozen SGD `b66ef328…` MATCH.
`uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH ASTRA-09-R3-UART-XSIM-01.
Prior A09R2 wrap `1932ee4c…` MATCH (not edited). Prior XSim UART wrap
`20cdeb8e…` MATCH (not compiled as this top). Compiled RTL+XDC+tcl + `.svh`
PRE/POST **19/19 MATCH**. `write_bitstream` renamed to abort; never invoked.
No `.bit` in bag.

## Open (unchanged)

Master ASTRA-09 production path (fixture plant remains; not `a7ng_axi_bram128`).
Master F3 10pp/CI. Master ASTRA-06 DDR/NVM. Master ASTRA-10 whole-chip. LM06.
BOARD_PASS. ASTRA-13. PRODUCTION_TOP identity. Silicon UART / silicon MMCM /
silicon BRAM. Do **not** call this BOARD_PASS, A09R2 wrap WNS=+0.648, wrap-route
WNS=+5.733, or ASTRA-09-R3-UART-XSIM MAGIC A2. Manager independently accepts.
Do not autonomously open the next gate. Do not freeze PRODUCTION_TOP.
