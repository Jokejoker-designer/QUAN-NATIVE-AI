# RESULTS — ASTRA-11-A09R7-LED-IO-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. ASTRA-11-A09R7-UART-IMPL-ROUTE-01 /
ASTRA-07-SCALE-MID-01 / ASTRA-09-R7-UART-QUERY-REW-01 /
ASTRA-11-A09R3-UART-IOBFF-HOLD-01 / ASTRA-11-A09R3-UART-IOBFF-01 /
ASTRA-11-A09R3-UART-IODELAY-01 / ASTRA-11-A09R3-UART-IMPL-ROUTE-01 /
ASTRA-09-R3-UART-XSIM-01 / ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-11-A09-IMPL-ROUTE-01 /
ASTRA-SOC-RTP-WRAP-ROUTE / ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 bags
not edited. Frozen A09-R2 DUT instantiated, not copy-pasted. Frozen
`a7ng_astra_09_integ_path.sv` not compiled as DUT. Frozen `uart_rx.sv` / `uart_tx.sv`
not patched. Prior R7 UART impl wrap KEEP (not this top). Prior UART wrap WNS=+0.336
WHS=+0.104 not overwritten. Scale-mid N=64 INCOMP not repeated. LM06 / BOARD / DDR /
Master F3 / ASTRA-13 not opened. PRODUCTION_TOP=UNKNOWN.

LED pinout (H5/J5/T9/T10 = LD4–LD7, cited `constraints/arty_a7_100.xdc`) and LED I/O
delays (OUT max 2.000 min 0.500 vs clk50u) were frozen in PREREG/XDC **before** impl.
Delay numbers were copied from the repo 3.3 V CMOS I/O class, not invented after WNS.

```text
GATE             = ASTRA-11-A09R7-LED-IO-01
TOP              = a7ng_astra_11_a09r7_led_io_wrap
DUT_MODULE       = a7ng_astra_09_r2_cand_ovf
DUT_INSTANCE     = u_a09r2
UART_RX / UART_TX= u_rx uart_rx / u_tx uart_tx  (rtl/board)
UART_RXD_OUT     = D10  (io.rpt OUTPUT LVCMOS33 FIXED)
UART_TXD_IN      = A9   (io.rpt INPUT  LVCMOS33 FIXED)
UART_IOB         = YES
UART_IOBFF       = YES
LED[0]           = H5   LD4  Sch=led[4]  (io.rpt OUTPUT LVCMOS33 FIXED)
LED[1]           = J5   LD5  Sch=led[5]  (io.rpt OUTPUT LVCMOS33 FIXED)
LED[2]           = T9   LD6  Sch=led[6]  (io.rpt OUTPUT LVCMOS33 FIXED)
LED[3]           = T10  LD7  Sch=led[7]  (io.rpt OUTPUT LVCMOS33 FIXED)
LED_CITE         = constraints/arty_a7_100.xdc
LED_IOB          = YES
LED_IOBFF        = YES
LED_Q[0]         = led_q_reg[0] BEL=OLOGICE2.OUTFF LOC=OLOGIC_X1Y101
LED_Q[1]         = led_q_reg[1] BEL=OLOGICE2.OUTFF LOC=OLOGIC_X1Y100
LED_Q[2]         = led_q_reg[2] BEL=OLOGICE2.OUTFF LOC=OLOGIC_X0Y52
LED_Q[3]         = led_q_reg[3] BEL=OLOGICE2.OUTFF LOC=OLOGIC_X0Y51
UTIL_IOB_FFS     = 6
UTIL_ILOGIC      = 1
UTIL_OLOGIC      = 5
HOLD_POLICY      = FALSE_PATH_HOLD_ASYNC_UART (UART only)
LED_HOLD_POLICY  = RELATED_CLK50U_NO_FALSE_PATH_HOLD
LED_OUT_MAX_NS   = 2.000  (set_output_delay -max led[*] vs clk50u)
LED_OUT_MIN_NS   = 0.500  (set_output_delay -min led[*] vs clk50u)
UART_IN_MAX_NS   = 2.000
UART_IN_MIN_NS   = 0.500
UART_OUT_MAX_NS  = 2.000
UART_OUT_MIN_NS  = 0.500
IO_CLK_REF       = uart_io_vclk 20.000 ns (virtual I/O reference; clocks_route.rpt V)
PIPE_CLK         = clk50u 20.000 ns (MMCM+BUFG; clocks_route.rpt P,G,A; REAL)
PART             = xc7a100tcsg324-1
VIVADO           = 2026.1  Build 6511674
PIN_CLK          = CLK100MHZ E3  period 10.000 ns  (100.000 MHz site)
MODE             = synth_design (in-context) ; opt_design ; place_design ; route_design
ROUTE            = COMPLETE  (route_status.rpt: nets with routing errors = 0)
MARKER           = ASTRA_11_A09R7_LED_IO_DONE WNS=0.411 TNS=0.000 WHS=0.027 LED_IOB=YES UART_IOB=YES UART_IOBFF=YES LED_IOBFF=YES BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN
RESULT           = PASS_NARROW (this bag only: Design Timing Summary WNS>=0 and WHS>=0 of named LED-IO wrap at declared 50 MHz with LD4-LD7 H5/J5/T9/T10 and LED delays 2.000/0.500 vs clk50u frozen before impl, LED IOB FIXED, LED IOB FFs packed). Not BOARD_PASS. Not R7 UART wrap WNS=+0.336. Not scale-mid N=64.
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
PRODUCTION_TOP   = UNKNOWN
```

## One unknown (answered)

With LD4–LD7 mapped (cited `constraints/arty_a7_100.xdc`: H5/J5/T9/T10) plus frozen
LED I/O delays OUT max 2.000 min 0.500 vs clk50u, after implement+route of named wrap
`a7ng_astra_11_a09r7_led_io_wrap` instance **`u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf`**
on `xc7a100tcsg324-1` at declared 50 MHz (MMCM-derived `clk50u`, clock-network delay
included), is Design Timing Summary **WNS ≥ 0 and WHS ≥ 0** — without a bitstream?

Quoted from raw `timing_route.rpt` (Design State = **Routed**, 03:11:15):

```text
WNS(ns)=0.411  TNS=0.000  WHS=0.027  THS=0.000
TNS Failing Endpoints=0  THS Failing Endpoints=0
Clock clk50u       Period=20.000 ns  Frequency=50.000 MHz
Clock uart_io_vclk Period=20.000 ns  Frequency=50.000 MHz
All user specified timing constraints are met.
Intra clk50u WNS=0.411  WHS=0.027  failing endpoints=0
```

WNS **≥ 0**. WHS **≥ 0**. No bitstream. Bounded WNS<0/WHS<0 experiment **not run**
(not applicable). Authority is this Design Timing Summary.

LED I/O paths (`timing_led_out.rpt` / `LED_IODELAY.txt`; Output Delay max=2.000 min=0.500
vs clk50u, related, hold **not** excepted):

```text
led_q_reg[3] → led[3]  setup WNS=10.321  (Output Delay=2.000)
led_q_reg[1] → led[1]  hold  WHS=2.927   (Output Delay=0.500)
```

UART I/O paths (same rpt Inter Clock Table; also `timing_uart_in.rpt` /
`timing_uart_out.rpt` / `UART_IODELAY.txt`):

```text
uart_io_vclk → clk50u   setup WNS=19.270  hold = (blank / excepted)
clk50u → uart_io_vclk   setup WNS=7.313   hold = (blank / excepted)
```

WHS=+0.027 is **intra-clk50u** hold (worst path `u_a09r2/u_sp/u_walk/ntrunc_reg[2]` →
`n_trunc_o_reg[2]`, Slack MET 0.027 ns). It is **not** LED hold (LED hold MET +2.927).
`check_timing.rpt` reports `no_output_delay` = 0 and `partial_output_delay` = 0
(`led[0:3]` constrained). Remaining `no_input_delay` = 8 is `sw[*]`/`btn[*]`
(false-pathed; not this bag's unknown).

This is **not** ASTRA-07-SCALE-MID-01 N=64 INCOMP.
This is **not** ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed WNS=+0.336 WHS=+0.104
(that bag left `led[0:3]` unconstrained).
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
Source Clock Delay = 6.235 ns   Destination Clock Delay = 5.889 ns
Requirement = 20.000 ns
Source  u_a09r2/FSM_sequential_st_reg[3]/C
Dest    u_a09r2/u_sgd/w_reg[24][2]/D
Data Path Delay = 19.402 ns  (logic 10.274 / route 9.128)
Slack (MET) = 0.411 ns
```

`clocks_route.rpt`: `clk50u` generated from `u_mmcm/CLKOUT0`, master `sys_clk_pin`
10.000 ns, attributes **P,G,A** (not V). `uart_io_vclk` attributes **V** (I/O
reference only). Pipe clock is not virtual.

LED IOB (`io.rpt` Design State Routed):

```text
H5   led[0]  OUTPUT  LVCMOS33  FIXED
J5   led[1]  OUTPUT  LVCMOS33  FIXED
T9   led[2]  OUTPUT  LVCMOS33  FIXED
T10  led[3]  OUTPUT  LVCMOS33  FIXED
A9   uart_txd_in   INPUT   LVCMOS33  FIXED
D10  uart_rxd_out  OUTPUT  LVCMOS33  FIXED
```

LED IOB FF pack (`LED_IOBFF.txt` / `util_route.rpt`): four `led_q_reg[*]` in
OLOGICE2.OUTFF; IOB Flip Flops=6 (2 UART + 4 LED) ILOGIC=1 OLOGIC=5.

## DUT identity (raw `vivado.log`, not RESULTS)

`synth_design -top a7ng_astra_11_a09r7_led_io_wrap -part xc7a100tcsg324-1`
(in-context, **not** `-mode out_of_context`).

Synthesized: wrap (MMCME2_BASE + BUFG + UART IOB FFs + LED IOB FFs + R7
query-rew FSM) → `uart_rx` / `uart_tx` → **`u_a09r2` `a7ng_astra_09_r2_cand_ovf`**
→ `u_sp` `a7ng_query_axi_sparse` → `g_law.u_qse` + `u_walk`;
`u_sgd` `a7ng_shared_rank_sgd_q8_sym_f2r2`; bag-local `u_plant`
`a7ng_astra_11_a09r7_led_io_plant` (fixture, not `a7ng_axi_bram128`).
Markers `U_A09R2_CELLS=11063` `U_RX_CELLS=76` `LED_IOBFF_CELLS=4`
`LED_IODELAY_APPLIED clk50u PERIOD=20.000 MAX=2.000 MIN=0.500`.

Prior R7 UART impl wrap KEEP hashed `d1f66a54…` MATCH ASTRA-11-A09R7-UART-IMPL-ROUTE-01
SHA (**not compiled** as this top). Cited `constraints/arty_a7_100.xdc` hashed
`1c12e6f8…` (not compiled as the impl XDC).

**Not synthesized:** `a7ng_astra_09_integ_path`, `a7ng_astra09_pipe`,
`arty_a7_astra09_soc_top`, `arty_a7_astra_rtp_soc_top`, `a7ng_axi_bram128`,
`a7ng_astra_09_r7_uart_query_rew_wrap`, `a7ng_astra_11_a09r7_uart_impl_wrap`,
`a7ng_astra_11_a09r3_uart_impl_wrap`. File list forbids those.

## Resources (raw rpts)

Quoted **synth** `util_synth.rpt` Design State Synthesized (`UTIL_EXTRACT_SYNTH.txt`):

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **5792** | 63400 | 9.14 |
| Slice Registers (FF) | **5089** | 126800 | 4.01 |
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
| IOB Flip Flops | **6** | | |
| ILOGIC | **1** | 210 | 0.48 |
| OLOGIC | **5** | 210 | 2.38 |

Hierarchical routed (`util_hier_route.rpt`): wrap LUT=4945 FF=3615 DSP=2;
**`u_a09r2` LUT=4326 FF=2738 DSP=2**; `u_sgd` LUT=554 FF=615 DSP=2; `u_sp`
LUT=3334; `g_law.u_qse` LUT=2328; `u_plant` LUT=170 FF=73. Plant is a
**behavioral AXI fixture** (not silicon BRAM).

Do **not** add these LUT/FF to prior UART wrap 4945/3615 as a whole-chip sum.

## Comparison (not identity)

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 4945 | 3615 | 0 | 2 | **Routed clk50u WNS=+0.411 WHS=+0.027 LED IOB YES LED IOBFF YES delays 2.000/0.500 vs clk50u** |
| This bag synth | 5792 | 5089 | 0 | 2 | Synthesized (not the quote) |
| ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed | 4945 | 3615 | 0 | 2 | Routed UART IOB YES **WNS=+0.336 WHS=+0.104 led unconstrained** — not overwritten |
| ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed | 4802 | 3500 | 0 | 2 | Routed IOB FF YES HOLD **WNS=+0.115 WHS=+0.131** — not overwritten |
| ASTRA-11-A09R3-UART-IOBFF-01 routed | 4802 | 3500 | 0 | 2 | Routed IOB FF YES delays 2.000/0.500 **WNS=+0.115 WHS=−4.915** — not overwritten |
| ASTRA-11-A09R3-UART-IODELAY-01 routed | 4803 | 3500 | 0 | 2 | Routed delays 2.000/0.500 **no IOB FF +0.681** — not overwritten |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed | 4804 | 3500 | 0 | 2 | Routed UART IOB, **I/O unconstrained +0.305** — not overwritten |
| ASTRA-11-A09R2-IMPL-ROUTE-01 routed | 1321 | 1103 | 0 | 2 | Routed no-UART **+0.648** — not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed different DUT **+1.041** — not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |
| ASTRA-07-SCALE-MID-01 | — | — | — | — | XSim N=64 INCOMP — not this routed result |

## Hashes

SHA freeze BEFORE impl `2026-09-07T03:06:25.2550197+07:00`.
Vivado start `Mon Sep 7 03:06:26 2026`, exit `Mon Sep 7 03:11:21 2026`.
Frozen A09-R2 DUT `15a919f1…` MATCH ASTRA-09-R2-CAND-OVF-01. Frozen A09 leftover
`9fdbe0d6…` MATCH provenance (not compiled). Frozen SGD `b66ef328…` MATCH.
`uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH.
Prior R7 UART impl wrap KEEP `d1f66a54…` MATCH ASTRA-11-A09R7-UART-IMPL-ROUTE-01 SHA
(not compiled as this top). Cited `constraints/arty_a7_100.xdc` `1c12e6f8…`.
Compiled RTL+XDC+tcl + `.svh` PRE/POST **MATCH**.
`write_bitstream` renamed to abort; never invoked (`vivado.log` has no
`write_bitstream`). No `.bit` in bag.

## Open (unchanged)

Master ASTRA-09 production path (fixture plant remains; not `a7ng_axi_bram128`).
Master F3 10pp/CI. Master ASTRA-06 DDR/NVM. Master ASTRA-10 whole-chip. LM06.
BOARD_PASS. ASTRA-13. PRODUCTION_TOP identity. Silicon UART / silicon MMCM /
silicon BRAM. N=64 / 65536 / 800k. Do **not** call this BOARD_PASS, R7 UART wrap
WNS=+0.336, scale-mid N=64, prior HOLD WNS=+0.115 WHS=+0.131, or wrap-route
WNS=+5.733. Manager independently accepts. Do not autonomously open the next gate.
Do not freeze PRODUCTION_TOP.
