# PREREG — ASTRA-11-A09R7-SW-IO-01

Frozen before impl. PROGRAM=NO. No board program. No JTAG/xsdb/COM12/bitstream/write_bitstream/hw_server.
Does not edit ASTRA-11-A09R7-BTN-IDELAY-01 / ASTRA-11-A09R7-BTN-IO-01 /
ASTRA-11-A09R7-LED-IO-01 / ASTRA-11-A09R7-UART-IMPL-ROUTE-01 /
ASTRA-12-R7-BTN-CANDIDATES-01 / ASTRA-12-R6-LED-CANDIDATES-01 /
ASTRA-09-R7-UART-QUERY-REW-01 / ASTRA-11-A09R3-UART-IOBFF-HOLD-01 /
ASTRA-11-A09R3-UART-IOBFF-01 / ASTRA-11-A09R3-UART-IODELAY-01 /
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 / ASTRA-09-R3-UART-XSIM-01 /
ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-11-A09-IMPL-ROUTE-01 /
ASTRA-SOC-RTP-WRAP-ROUTE / ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 /
frozen RTL / frozen `uart_rx.sv`.
Does not overwrite BTN-IDELAY wrap WNS=+0.574 WHS=+0.131, BTN-IO wrap WNS=+0.452 WHS=−2.068,
LED wrap WNS=+0.411 WHS=+0.027, R7 UART wrap WNS=+0.336 WHS=+0.104,
HOLD wrap WNS=+0.115 WHS=+0.131, IOB-FF wrap WNS=+0.115 WHS=−4.915,
I/O-delay wrap WNS=+0.681, UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648,
A09 wrap WNS=+1.041, or wrap-route WNS=+5.733.
Does not open LM06 / BOARD / DDR / Master F3. Does not close ASTRA-13, BOARD_PASS, production SoC UART, LM06.
PRODUCTION_TOP stays UNKNOWN. Do not silent-freeze a top.
Do not `set_false_path` on `sw[*]`. Do not `set_false_path -hold` on SW.

## Claim this revision may close

One unknown, this bag only: with **SW0–SW3 mapped** (cited `constraints/arty_a7_100.xdc`:
A8/C11/C10/A10) plus **frozen SW input delays** IN max **2.000** min **0.500** vs pipe
`clk50u`, after implement+route of a **new named wrap** that **instantiates** frozen
`a7ng_astra_09_r2_cand_ovf` on `xc7a100tcsg324-1` at a **declared 50 MHz** constraint
with **clock-network delay included**, is Design Timing Summary **WNS ≥ 0 and
WHS ≥ 0** — **without a bitstream**, without `set_false_path` on `sw[*]`, and
without claiming BOARD_PASS.

ASTRA-11-A09R7-BTN-IDELAY-01 routed WNS=+0.574 WHS=+0.131 is **not** this result
(that wrap false-pathed `sw[*]` — this bag's residual).
ASTRA-11-A09R7-BTN-IO-01 routed WNS=+0.452 WHS=−2.068 is **not** this result
(that wrap also false-pathed `sw[*]`; fail_r0 kept).
ASTRA-12-R7-BTN-CANDIDATES-01 BTN table PASS_NARROW is **not** this result.
ASTRA-11-A09R7-LED-IO-01 routed WNS=+0.411 WHS=+0.027 is **not** this result.
ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed WNS=+0.336 WHS=+0.104 is **not** this result.

## Frozen SW pinout (BEFORE impl)

Cite, do not edit: `constraints/arty_a7_100.xdc` (header: Digilent digilent-xdc /
Arty-A7-100-Master.xdc Rev. D and Rev. E). This clone's master XDC already uses
A8/C11/C10/A10 for `sw[0:3]` = schematic `sw[0:3]` = board **SW0–SW3**. No other
SW set is used.

```text
SW[0]  = A8    SW0   Sch=sw[0]   LVCMOS33
SW[1]  = C11   SW1   Sch=sw[1]   LVCMOS33
SW[2]  = C10   SW2   Sch=sw[2]   LVCMOS33
SW[3]  = A10   SW3   Sch=sw[3]   LVCMOS33
```

Proof after route: `io.rpt` shows those four sites FIXED on `sw[0:3]`.

## Frozen SW input delay numbers (BEFORE impl) — copy, do not invent after WNS

Board 3.3 V CMOS I/O class already used on this Arty A7-100T program
(`vivado/tcl/build_a7eam01r.tcl`, ASTRA-11-A09R3-UART-IODELAY-01,
ASTRA-11-A09R7-LED-IO-01, ASTRA-11-A09R7-BTN-IO-01: **max 2.000** / **min 0.500**).
Copied here before impl. Not fitted to a WNS/WHS residual. Not FT2232H silicon
(slide switches are on-board).

```text
STA_ENVELOPE_SW  = SW_IO_DELAY_2P000_0P500_VS_CLK50U
SW_IN_MAX_NS     = 2.000
SW_IN_MIN_NS     = 0.500
SW_CLK_REF       = clk50u  period 20.000 ns  (MMCM+BUFG; REAL; related)
SW_HOLD_POLICY   = RELATED_CLK50U_NO_FALSE_PATH_HOLD
SW_IDELAY_FIRST  = NONE  (first impl has no IDELAYE2; measure pad hold honestly)
```

Slide switches are captured by wrap-level IOB FFs on `clk50u`. They are **related**.
Do **not** time SW inputs against virtual `uart_io_vclk` (that class created
UART WHS=−4.915 when min 0.500 was checked with SCD=0 vs MMCM DCD).
Do **not** `set_false_path -from [get_ports {sw[*]}]` (BTN/LED bag residual).
Do **not** `set_false_path -hold` on `sw[*]`.
Do **not** retune 0.500 after seeing WNS/WHS.

`clk50u` is MMCM-derived and does not exist at pre-synth `read_xdc`. Delay
**numbers** are frozen here and in `sw_iodelay.xdc` before impl. That XDC is
`read_xdc` **after synth** (before opt/place/route) when `clk50u` exists.

XDC (`sw_iodelay.xdc`, applied post-synth):

```tcl
set_input_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {sw[*]}]
set_input_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {sw[*]}]
```

## Frozen SW function map (BEFORE impl)

```text
SW[1:0]  = plant_sel after IOB FF sw_q (fixture; never raw sw)
SW[3:2]  = LED mix after IOB FF sw_q
SW[3:0]  = all four pads timed pad → sw_q IOB FF
```

## Frozen LED envelope kept (UART+LED may stay; not this bag's unknown)

```text
LED[0]           = H5    LD4   Sch=led[4]
LED[1]           = J5    LD5   Sch=led[5]
LED[2]           = T9    LD6   Sch=led[6]
LED[3]           = T10   LD7   Sch=led[7]
LED_OUT_MAX_NS   = 2.000
LED_OUT_MIN_NS   = 0.500
LED_CLK_REF      = clk50u
LED_HOLD_POLICY  = RELATED_CLK50U_NO_FALSE_PATH_HOLD
```

## Frozen UART envelope kept (UART-class wrap; not this bag's unknown)

```text
UART_IN_MAX_NS  = 2.000
UART_IN_MIN_NS  = 0.500
UART_OUT_MAX_NS = 2.000
UART_OUT_MIN_NS = 0.500
HOLD_POLICY     = FALSE_PATH_HOLD_ASYNC_UART
IO_CLK_REF      = uart_io_vclk  period 20.000 ns  (virtual I/O reference)
PIPE_CLK        = clk50u        period 20.000 ns  (MMCM+BUFG; REAL; not virtual)
UART_TXD_IN     = A9    FPGA RX   INPUT
UART_RXD_OUT    = D10   FPGA TX   OUTPUT
```

## Frozen BTN pins kept, false-pathed (BTN unknown already closed)

BTN pad hold is **not** this bag's unknown. ASTRA-11-A09R7-BTN-IO-01 FAIL_WHS
WHS=−2.068 and ASTRA-11-A09R7-BTN-IDELAY-01 TAP=31 WHS=+0.131 stay on disk.
Keep board pins. `btn[0]` is LED-wrap-class async reset (2-FF). False-path `btn[*]`
so BTN pad hold cannot pollute this WHS.

```text
BTN[0]           = D9    BTN0  (async reset; false-pathed)
BTN[1]           = C9    BTN1  (false-pathed)
BTN[2]           = B9    BTN2  (false-pathed)
BTN[3]           = B8    BTN3  (false-pathed)
BTN_HOLD_POLICY  = FALSE_PATH_BTN_NOT_THIS_UNKNOWN
```

## Frozen IOB FF policy (BEFORE impl)

Do **not** patch frozen `uart_rx.sv` / `uart_tx.sv`. Pack pad registers in this wrap:

```text
UART_RX_IOB_FF  = uart_rx_iob   samples uart_txd_in (A9)
UART_TX_IOB_FF  = uart_tx_iob   drives uart_rxd_out (D10)
LED_IOB_FF      = led_q[3:0]    drives led[3:0] (H5/J5/T9/T10)
SW_IOB_FF       = sw_q[3:0]     samples sw[3:0] (A8/C11/C10/A10)
IOB_XDC         = set_property IOB TRUE on uart_txd_in uart_rxd_out led[*] sw[*]
PACK_PROOF      = routed BEL/LOC in IOB / ILOGIC / OLOGIC, or util IOB Flip Flops
SW_IOB_PROOF    = io.rpt A8/C11/C10/A10 FIXED (required). SW IOB FF pack if it still packs
                  (bag does not FAIL solely on SW unpack when WNS>=0 and WHS>=0 and pins FIXED)
```

## Frozen build identity

```text
GATE           = ASTRA-11-A09R7-SW-IO-01
PART           = xc7a100tcsg324-1
VIVADO         = 2026.1
LICENSE        = D:\Xilinx\licenses\vivado_basic.lic
TOP            = a7ng_astra_11_a09r7_sw_io_wrap
DUT_MODULE     = a7ng_astra_09_r2_cand_ovf
DUT_INSTANCE   = u_a09r2
UART_RX        = uart_rx  (rtl/board/uart_rx.sv)
UART_TX        = uart_tx  (rtl/board/uart_tx.sv)
UART_RXD_OUT   = D10  (FPGA TX, Digilent uart_rxd_out)
UART_TXD_IN    = A9   (FPGA RX, Digilent uart_txd_in)
LED[0:3]       = H5/J5/T9/T10  (LD4–LD7; cited constraints/arty_a7_100.xdc)
SW[0:3]        = A8/C11/C10/A10 (SW0–SW3; cited constraints/arty_a7_100.xdc)
BTN[0:3]       = D9/C9/B9/B8   (kept, false-pathed; not this unknown)
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

With SW0–SW3 mapped (A8/C11/C10/A10) plus frozen SW input delays 2.000/0.500 vs clk50u,
after implement+route of that named wrap on xc7a100tcsg324-1 at 50 MHz, is WNS ≥ 0
and WHS ≥ 0 on Design Timing Summary — without a bitstream and without
`set_false_path` on `sw[*]`?

## Wrapper law

- New named SW-IO wrap only. Instantiates frozen A09-R2 DUT. Does not duplicate QSE /
  sparse / 2-hop / SGD RTL.
- UART-class: keeps D10/A9 + R7 query-rew FSM. Keeps LED IOB FFs + LED delays.
  Adds SW IOB FFs + SW input delays. Removes `set_false_path` on `sw[*]`.
  False-paths `btn[*]` (BTN unknown already closed).
- Prior BTN-IO wrap `a7ng_astra_11_a09r7_btn_io_wrap` is **KEEP_NOT_COMPILED**.
- Prior BTN-IDELAY wrap `a7ng_astra_11_a09r7_btn_idelay_wrap` is **KEEP_NOT_COMPILED**.
- Prior R7 UART impl wrap `a7ng_astra_11_a09r7_uart_impl_wrap` is **KEEP_NOT_COMPILED**.
- Prior LED-IO wrap `a7ng_astra_11_a09r7_led_io_wrap` is **KEEP_NOT_COMPILED**.
- Frozen `a7ng_astra_09_integ_path.sv` is **not** compiled and **not** instantiated.
- Instantiates frozen `uart_rx` / `uart_tx`. UART pins constrained to official Arty
  D10 / A9. LED pins constrained to cited H5/J5/T9/T10. SW pins constrained to
  cited A8/C11/C10/A10. Do not edit `constraints/arty_a7_100.xdc`.
- Bag-local AXI plant is a **fixture** (not `a7ng_axi_bram128`, not silicon BRAM).
- `load_from_tb` path unused (`load_v_i` tied 0).
- Not `arty_a7_astra_rtp_soc_top`. Not `a7ng_astra_11_a09r7_uart_impl_wrap`.
- Not `a7ng_astra_11_a09r7_led_io_wrap`.
- Not `a7ng_astra_11_a09r7_btn_io_wrap`.
- Not `a7ng_astra_11_a09r7_btn_idelay_wrap`.
- Not PRODUCTION_TOP.

## Comparison (not identity)

- Do **not** quote ASTRA-11-A09R7-BTN-IDELAY-01 routed WNS=+0.574 / WHS=+0.131 as this result.
- Do **not** quote ASTRA-11-A09R7-BTN-IO-01 routed WNS=+0.452 / WHS=−2.068 as this result.
- Do **not** quote ASTRA-12-R7-BTN-CANDIDATES-01 BTN table as this result.
- Do **not** quote ASTRA-11-A09R7-LED-IO-01 routed WNS=+0.411 / WHS=+0.027 as this result.
- Do **not** quote ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed WNS=+0.336 / WHS=+0.104 as this result.
- Do **not** freeze PRODUCTION_TOP.

## Hash

SHA256 of every file Vivado compiles (RTL + XDC + tcl) **before** impl, plus
transitive `.svh` and this PREREG/ACK. R2 DUT freeze `15a919f1…`. Frozen A09
`9fdbe0d6…` MATCH provenance only (not compiled). Frozen SGD `b66ef328…`.
`uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…`. Prior BTN-IO wrap KEEP
(not compiled as this top). Prior BTN-IDELAY wrap KEEP. Prior UART-impl wrap KEEP.
Prior LED-IO wrap KEEP. R7 XSim wrap KEEP. Cited `constraints/arty_a7_100.xdc`
hashed as pinout cite (not compiled as the impl XDC).

## If WNS < 0 or WHS < 0

FAIL this bag, keep the routed report (`fail_r0/`). One bounded **IDELAY**
experiment: write `PREREG_EXP.md` with a **new** tap **before** the second impl
(not silent; not a delay-number retune; not `phys_opt` as the hold fix — that
was exhausted on the BTN FAIL bag). Still 50 MHz. Still IOB=TRUE on SW. Still
SW delays 2.000/0.500 vs clk50u. Still no `set_false_path` on `sw[*]`. Still no
bitstream. Do not program a failing bit. Do not invent delay numbers. Do not
patch frozen `uart_rx.sv`. Do not retune SW 2.000/0.500.

If pad hold fails like BTN (IBUF ~1.4 ns + min 0.500 vs MMCM skew ~3.7 ns),
FAIL honestly. The experiment tap (if needed) is recorded in `PREREG_EXP.md`
from that residual + DS181 tap math, **before** the second impl.

## Out of scope

Master ASTRA-09 production path. Master F3. LM06. BOARD_PASS. ASTRA-13.
write_bitstream. JTAG/xsdb/COM12/hw_server. PRODUCTION_TOP identity.
Silicon UART / silicon MMCM / silicon BRAM / silicon buttons / silicon switches.
N=64 / 65536 / 800k. Retune of frozen 2.000/0.500. Silent freeze of this wrap
as PRODUCTION_TOP. False-path on `sw[*]`. Edit of ASTRA-11-A09R7-BTN-IO-01 /
BTN-IDELAY-01 / LED-IO-01 / 12-R7.
