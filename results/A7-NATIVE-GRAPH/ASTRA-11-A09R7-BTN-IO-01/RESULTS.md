# RESULTS — ASTRA-11-A09R7-BTN-IO-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. ASTRA-11-A09R7-LED-IO-01 /
ASTRA-11-A09R7-UART-IMPL-ROUTE-01 / ASTRA-12-R6-LED-CANDIDATES-01 /
ASTRA-09-R7-UART-QUERY-REW-01 / ASTRA-11-A09R3-UART-IOBFF-HOLD-01 /
ASTRA-11-A09R3-UART-IOBFF-01 / ASTRA-11-A09R3-UART-IODELAY-01 /
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 / ASTRA-09-R3-UART-XSIM-01 /
ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-11-A09-IMPL-ROUTE-01 /
ASTRA-SOC-RTP-WRAP-ROUTE / ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 bags
not edited. Frozen A09-R2 DUT instantiated, not copy-pasted. Frozen
`a7ng_astra_09_integ_path.sv` not compiled as DUT. Frozen `uart_rx.sv` / `uart_tx.sv`
not patched. Prior LED-IO wrap KEEP (not this top). Prior R7 UART impl wrap KEEP.
LED wrap WNS=+0.411 WHS=+0.027 not overwritten. UART wrap WNS=+0.336 WHS=+0.104 not
overwritten. 12-R6 LED table not repeated. LM06 / BOARD / DDR / Master F3 / ASTRA-13
not opened. PRODUCTION_TOP=UNKNOWN.

BTN pinout (D9/C9/B9/B8 = BTN0–BTN3, cited `constraints/arty_a7_100.xdc`) and BTN
input delays (IN max 2.000 min 0.500 vs clk50u) were frozen in PREREG/XDC **before**
impl. Delay numbers were copied from the repo 3.3 V CMOS I/O class, not invented
after WNS. UART D10/A9 and LED H5/J5/T9/T10 kept.

```text
GATE             = ASTRA-11-A09R7-BTN-IO-01
TOP              = a7ng_astra_11_a09r7_btn_io_wrap
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
LED_IOB          = YES
LED_IOBFF        = YES
BTN[0]           = D9   BTN0  Sch=btn[0]  (io.rpt INPUT LVCMOS33 FIXED)
BTN[1]           = C9   BTN1  Sch=btn[1]  (io.rpt INPUT LVCMOS33 FIXED)
BTN[2]           = B9   BTN2  Sch=btn[2]  (io.rpt INPUT LVCMOS33 FIXED)
BTN[3]           = B8   BTN3  Sch=btn[3]  (io.rpt INPUT LVCMOS33 FIXED)
BTN_CITE         = constraints/arty_a7_100.xdc
BTN_IOB          = YES
BTN_IOBFF        = YES
BTN_Q[0]         = btn_q_reg[0] BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y187
BTN_Q[1]         = btn_q_reg[1] BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y178
BTN_Q[2]         = btn_q_reg[2] BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y177
BTN_Q[3]         = btn_q_reg[3] BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y176
UTIL_IOB_FFS     = 10
UTIL_ILOGIC      = 5
UTIL_OLOGIC      = 5
HOLD_POLICY      = FALSE_PATH_HOLD_ASYNC_UART (UART only)
LED_HOLD_POLICY  = RELATED_CLK50U_NO_FALSE_PATH_HOLD
BTN_HOLD_POLICY  = RELATED_CLK50U_NO_FALSE_PATH_HOLD
BTN_IN_MAX_NS    = 2.000  (set_input_delay -max btn[*] vs clk50u)
BTN_IN_MIN_NS    = 0.500  (set_input_delay -min btn[*] vs clk50u)
LED_OUT_MAX_NS   = 2.000
LED_OUT_MIN_NS   = 0.500
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
MARKER           = ASTRA_11_A09R7_BTN_IO_DONE WNS=0.452 WHS=-2.068 BTN_IOB=YES LED_IOB=YES UART_IOB=YES UART_IOBFF=YES LED_IOBFF=YES BTN_IOBFF=YES BIT=NOT_BUILT PROGRAM=NO RESULT=FAIL_WHS PRODUCTION_TOP=UNKNOWN
RESULT           = FAIL_WHS (this bag only: Design Timing Summary WNS>=0 but WHS<0 of named BTN-IO wrap at declared 50 MHz with BTN0-BTN3 D9/C9/B9/B8 and BTN delays 2.000/0.500 vs clk50u frozen before impl; BTN IOB FIXED; BTN IOB FFs packed). Not BOARD_PASS. Not LED wrap WNS=+0.411. Not R7 UART wrap WNS=+0.336. Not 12-R6 LED table.
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
PRODUCTION_TOP   = UNKNOWN
```

## One unknown (answered)

With BTN0–BTN3 mapped (cited `constraints/arty_a7_100.xdc`: D9/C9/B9/B8) plus frozen
BTN input delays IN max 2.000 min 0.500 vs clk50u, after implement+route of named wrap
`a7ng_astra_11_a09r7_btn_io_wrap` instance **`u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf`**
on `xc7a100tcsg324-1` at declared 50 MHz (MMCM-derived `clk50u`, clock-network delay
included), is Design Timing Summary **WNS ≥ 0 and WHS ≥ 0** — without a bitstream?

Quoted from raw `timing_route.rpt` (Design State = **Routed**, 04:24:50):

```text
WNS(ns)=0.452  TNS=0.000  WHS=-2.068  THS=-8.128
TNS Failing Endpoints=0  THS Failing Endpoints=4
Clock clk50u       Period=20.000 ns  Frequency=50.000 MHz
Clock uart_io_vclk Period=20.000 ns  Frequency=50.000 MHz
Timing constraints are not met.
Intra clk50u WNS=0.452  WHS=-2.068  hold failing endpoints=4
```

WNS **≥ 0**. WHS **< 0**. Bag **FAIL_WHS**. No bitstream.

BTN I/O paths (`timing_btn_in.rpt` / `BTN_IODELAY.txt`; Input Delay max=2.000 min=0.500
vs clk50u, related, hold **not** excepted):

```text
btn[0] → btn_q_reg[0]/D  setup WNS=18.616  (Input Delay=2.000)
btn[0] → btn_q_reg[0]/D  hold  WHS=-2.068  (Input Delay=0.500; VIOLATED)
  Path Type Hold (Min at Slow Process Corner)
  Data Path Delay=1.417 ns (IBUF)
  Clock Path Skew=3.712 ns (DCD=6.515 SCD=2.656 CPR=0.147)
  Destination btn_q_reg[0] ILOGIC_X0Y187 ILOGICE2.IFF
```

THS=−8.128 is the sum of the four BTN pad-hold endpoints. DTS WHS=−2.068 **is**
BTN pad hold (not intra-core hold, not LED hold). LED hold remains MET +2.927.
UART I/O hold remains excepted (`FALSE_PATH_HOLD_ASYNC_UART`).

`check_timing.rpt`: `no_output_delay`=0; `partial_input_delay`=0; remaining
`no_input_delay`=4 is `sw[*]` only (false-pathed). `btn[*]` is constrained.

This is **not** ASTRA-11-A09R7-LED-IO-01 routed WNS=+0.411 WHS=+0.027
(that bag left `btn[*]` false-pathed).
This is **not** ASTRA-12-R6-LED-CANDIDATES-01 LED table PASS_NARROW.
This is **not** ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed WNS=+0.336 WHS=+0.104.
This is **not** ASTRA-11-A09R3-UART-IOBFF-01 routed WNS=+0.115 WHS=−4.915
(same *class* of related-clock I/O hold vs MMCM DCD, different ports).
This is **not** ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed WNS=+0.115 WHS=+0.131.

## Bounded experiment (same frozen STA envelope; still no bit)

PREREG: if WNS<0 or WHS<0, keep the routed report, one bounded experiment
(`phys_opt_design` post-route; still 50 MHz; still IOB=TRUE; still BTN delays
2.000/0.500 vs clk50u; still no bitstream). Do not invent delay numbers.

fail_r0 preserved: `fail_r0/timing_route.rpt` and siblings (WNS=0.452 WHS=−2.068).

Post-route `phys_opt_design`: Vivado skipped setup opts because WNS≥0
(`No setup violation found. The netlist was not modified.`). Experiment timing
`timing_route_exp.rpt` Design Timing Summary:

```text
WNS(ns)=0.452  TNS=0.000  WHS=-2.068  THS=-8.128
Timing constraints are not met.
```

WHS unchanged. Delays not retuned. Frozen `uart_rx.sv` not patched.

## DUT identity (raw `vivado.log`, not RESULTS)

`synth_design -top a7ng_astra_11_a09r7_btn_io_wrap -part xc7a100tcsg324-1`
(in-context, **not** `-mode out_of_context`).

Synthesized: wrap (MMCME2_BASE + BUFG + UART IOB FFs + LED IOB FFs + BTN IOB FFs
+ R7 query-rew FSM) → `uart_rx` / `uart_tx` → **`u_a09r2` `a7ng_astra_09_r2_cand_ovf`**
→ bag-local `u_plant` `a7ng_astra_11_a09r7_btn_io_plant` (fixture, not
`a7ng_axi_bram128`). Markers `U_A09R2_CELLS=11063` `BTN_IOBFF_CELLS=4`
`BTN_IODELAY_APPLIED clk50u PERIOD=20.000 MAX=2.000 MIN=0.500`.

Cited `constraints/arty_a7_100.xdc` hashed `1c12e6f8…` (not compiled as the impl XDC).
R2 DUT freeze `15a919f1…` MATCH PRE and POST.

**Not synthesized:** `a7ng_astra_09_integ_path`, `a7ng_astra09_pipe`,
`arty_a7_astra_rtp_soc_top`, `a7ng_axi_bram128`,
`a7ng_astra_11_a09r7_led_io_wrap`, `a7ng_astra_11_a09r7_uart_impl_wrap`.

## Resources (raw rpts)

Quoted **synth** `util_synth.rpt` Design State Synthesized (`UTIL_EXTRACT_SYNTH.txt`):

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **5792** | 63400 | 9.14 |
| Slice Registers (FF) | **5092** | 126800 | 4.01 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |

Quoted **routed** `util_route.rpt` Design State Routed:

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **4944** | 63400 | 7.80 |
| Slice Registers (FF) | **3614** | 126800 | 2.85 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |
| Bonded IOB | **15** | 210 | 7.14 |
| IOB Flip Flops | **10** | | |
| ILOGIC | **5** | 210 | 2.38 |
| OLOGIC | **5** | 210 | 2.38 |

Hierarchical routed (`util_hier_route.rpt`): **`u_a09r2` LUT=4325 FF=2738 DSP=2**.

BTN IOB (`io.rpt` Design State Routed):

```text
D9   btn[0]  INPUT   LVCMOS33  FIXED
C9   btn[1]  INPUT   LVCMOS33  FIXED
B9   btn[2]  INPUT   LVCMOS33  FIXED
B8   btn[3]  INPUT   LVCMOS33  FIXED
H5   led[0]  OUTPUT  LVCMOS33  FIXED
J5   led[1]  OUTPUT  LVCMOS33  FIXED
T9   led[2]  OUTPUT  LVCMOS33  FIXED
T10  led[3]  OUTPUT  LVCMOS33  FIXED
A9   uart_txd_in   INPUT   LVCMOS33  FIXED
D10  uart_rxd_out  OUTPUT  LVCMOS33  FIXED
```

BTN IOB FF pack (`BTN_IOBFF.txt`): four `btn_q_reg[*]` in ILOGICE2.IFF.

## Production-top identity

**UNKNOWN.** Not frozen. FAIL_WHS does not freeze this wrap. LED wrap WNS=+0.411
does not freeze. UART wrap WNS=+0.336 does not freeze.

## Open (unchanged)

Master ASTRA-09. Master ASTRA-11 FULLCHIP-COFIT. Master ASTRA-12 unique-bit /
UART plan. Master ASTRA-06 DDR/NVM. Master F3 10pp/CI. LM06. BOARD_PASS.
ASTRA-13. Production-top identity. Auditor ACCEPT_BOARD. Physical IOB hold MET
on BTN pads. Do **not** call this BOARD_PASS or ASTRA-13. Do not retune frozen
2.000/0.500. Do not autonomously open the next gate.
