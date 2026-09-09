# PREREG — ASTRA-11-A09R7-LED-IO-01

Frozen before impl. PROGRAM=NO. No board program. No JTAG/xsdb/COM12/bitstream/write_bitstream/hw_server.
Does not edit ASTRA-11-A09R7-UART-IMPL-ROUTE-01 / ASTRA-07-SCALE-MID-01 /
ASTRA-09-R7-UART-QUERY-REW-01 / ASTRA-11-A09R3-UART-IOBFF-HOLD-01 /
ASTRA-11-A09R3-UART-IOBFF-01 / ASTRA-11-A09R3-UART-IODELAY-01 /
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 / ASTRA-09-R3-UART-XSIM-01 /
ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-11-A09-IMPL-ROUTE-01 /
ASTRA-SOC-RTP-WRAP-ROUTE / ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 /
frozen RTL / frozen `uart_rx.sv`.
Does not overwrite scale-mid N=64 INCOMP PASS_NARROW, R7 UART wrap WNS=+0.336 WHS=+0.104,
HOLD wrap WNS=+0.115 WHS=+0.131, IOB-FF wrap WNS=+0.115 WHS=−4.915,
I/O-delay wrap WNS=+0.681, UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648,
A09 wrap WNS=+1.041, or wrap-route WNS=+5.733.
Does not open LM06 / BOARD / DDR / Master F3. Does not close ASTRA-13, BOARD_PASS, production SoC UART, LM06.
PRODUCTION_TOP stays UNKNOWN. Do not silent-freeze a top.
Do not repeat N=64.

## Claim this revision may close

One unknown, this bag only: with **LD4–LD7 mapped** (cited `constraints/arty_a7_100.xdc`:
H5/J5/T9/T10) plus **frozen LED I/O delays** OUT max **2.000** min **0.500** vs pipe
`clk50u`, after implement+route of a **new named wrap** that **instantiates** frozen
`a7ng_astra_09_r2_cand_ovf` on `xc7a100tcsg324-1` at a **declared 50 MHz** constraint
with **clock-network delay included**, is Design Timing Summary **WNS ≥ 0 and
WHS ≥ 0** — **without a bitstream** and without claiming BOARD_PASS.

ASTRA-07-SCALE-MID-01 N=64 INCOMP PASS_NARROW is **not** this result.
ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed WNS=+0.336 WHS=+0.104 is **not** this result
(that bag left `led[0:3]` unconstrained — this bag's residual).
ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed WNS=+0.115 WHS=+0.131 is **not** this result.
ASTRA-11-A09R3-UART-IOBFF-01 routed WNS=+0.115 WHS=−4.915 is **not** this result.
ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681 is **not** this result.
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305 is **not** this result.
A09R2 wrap routed WNS=+0.648 is **not** this result.
A09 wrap routed WNS=+1.041 is **not** this result.
Wrap-route WNS=+5.733 (`arty_a7_astra_rtp_soc_top`) is **not** this result.

## Frozen LED pinout (BEFORE impl)

Cite, do not edit: `constraints/arty_a7_100.xdc` (header: Digilent digilent-xdc /
Arty-A7-100-Master.xdc Rev. D and Rev. E). This clone's master XDC already uses
H5/J5/T9/T10 for `led[0:3]` = schematic `led[4:7]` = board **LD4–LD7**. No other
LED set is used.

```text
LED[0]  = H5    LD4   Sch=led[4]   LVCMOS33
LED[1]  = J5    LD5   Sch=led[5]   LVCMOS33
LED[2]  = T9    LD6   Sch=led[6]   LVCMOS33
LED[3]  = T10   LD7   Sch=led[7]   LVCMOS33
```

Proof after route: `io.rpt` shows those four sites FIXED on `led[0:3]`.

## Frozen LED I/O delay numbers (BEFORE impl) — copy, do not invent after WNS

Board 3.3 V CMOS I/O class already used on this Arty A7-100T program
(`vivado/tcl/build_a7eam01r.tcl` and ASTRA-11-A09R3-UART-IODELAY-01:
`set_output_delay` **-max 2.000** / **-min 0.500**). Copied here before impl.
Not fitted to a WNS/WHS residual. Not FT2232H silicon (LEDs are on-board).

```text
STA_ENVELOPE_LED = LED_IO_DELAY_2P000_0P500_VS_CLK50U
LED_OUT_MAX_NS   = 2.000
LED_OUT_MIN_NS   = 0.500
LED_CLK_REF      = clk50u  period 20.000 ns  (MMCM+BUFG; REAL; related)
LED_HOLD_POLICY  = RELATED_CLK50U_NO_FALSE_PATH_HOLD
```

LEDs are launched by wrap-level IOB FFs on `clk50u`. They are **related**.
Do **not** time LED outputs against virtual `uart_io_vclk` (that class created
UART WHS=−4.915 when min 0.500 was checked with SCD=0 vs MMCM DCD).
Do **not** `set_false_path -hold` on `led[*]`.
Do **not** retune 0.500 after seeing WNS/WHS.

`clk50u` is MMCM-derived and does not exist at pre-synth `read_xdc`. Delay
**numbers** are frozen here and in `led_iodelay.xdc` before impl. That XDC is
`read_xdc` **after synth** (before opt/place/route) when `clk50u` exists.

XDC (`led_iodelay.xdc`, applied post-synth):

```tcl
set_output_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {led[*]}]
set_output_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {led[*]}]
```

## Frozen UART envelope kept (UART-class wrap; not this bag's unknown)

Handoff: UART D10/A9 may stay if the wrap is UART-class; add LEDs.

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

## Frozen IOB FF policy (BEFORE impl)

Do **not** patch frozen `uart_rx.sv` / `uart_tx.sv`. Pack pad registers in this wrap:

```text
UART_RX_IOB_FF  = uart_rx_iob   samples uart_txd_in (A9)
UART_TX_IOB_FF  = uart_tx_iob   drives uart_rxd_out (D10)
LED_IOB_FF      = led_q[3:0]    drives led[3:0] (H5/J5/T9/T10)
IOB_XDC         = set_property IOB TRUE on uart_txd_in uart_rxd_out led[*]
PACK_PROOF      = routed BEL/LOC in IOB / ILOGIC / OLOGIC, or util IOB Flip Flops
LED_IOB_PROOF   = io.rpt H5/J5/T9/T10 FIXED (required). LED IOB FF pack if it still packs
                  (bag does not FAIL solely on LED unpack when WNS>=0 and WHS>=0 and pins FIXED)
```

## Frozen build identity

```text
GATE           = ASTRA-11-A09R7-LED-IO-01
PART           = xc7a100tcsg324-1
VIVADO         = 2026.1
LICENSE        = D:\Xilinx\licenses\vivado_basic.lic
TOP            = a7ng_astra_11_a09r7_led_io_wrap
DUT_MODULE     = a7ng_astra_09_r2_cand_ovf
DUT_INSTANCE   = u_a09r2
UART_RX        = uart_rx  (rtl/board/uart_rx.sv)
UART_TX        = uart_tx  (rtl/board/uart_tx.sv)
UART_RXD_OUT   = D10  (FPGA TX, Digilent uart_rxd_out)
UART_TXD_IN    = A9   (FPGA RX, Digilent uart_txd_in)
LED[0:3]       = H5/J5/T9/T10  (LD4–LD7; cited constraints/arty_a7_100.xdc)
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

With LD4–LD7 mapped (H5/J5/T9/T10) plus frozen LED I/O delays 2.000/0.500 vs clk50u,
after implement+route of that named wrap on xc7a100tcsg324-1 at 50 MHz, is WNS ≥ 0
and WHS ≥ 0 on Design Timing Summary — without a bitstream?

## Wrapper law

- New named LED-IO wrap only. Instantiates frozen A09-R2 DUT. Does not duplicate QSE /
  sparse / 2-hop / SGD RTL.
- UART-class: keeps D10/A9 + R7 query-rew FSM. Adds LED IOB FFs + LED delays.
- Prior R7 UART impl wrap `a7ng_astra_11_a09r7_uart_impl_wrap` is **KEEP_NOT_COMPILED**.
  Do not edit that bag.
- Frozen `a7ng_astra_09_integ_path.sv` is **not** compiled and **not** instantiated.
- Instantiates frozen `uart_rx` / `uart_tx`. UART pins constrained to official Arty
  D10 / A9. LED pins constrained to cited H5/J5/T9/T10. Do not edit
  `constraints/arty_a7_100.xdc`.
- Bag-local AXI plant is a **fixture** (not `a7ng_axi_bram128`, not silicon BRAM).
- `load_from_tb` path unused (`load_v_i` tied 0).
- Not `arty_a7_astra_rtp_soc_top`. Not `a7ng_astra_11_a09r7_uart_impl_wrap`.
- Not `a7ng_astra_11_a09r3_uart_impl_wrap`.
- Not `a7ng_astra_11_a09r3_uart_iodelay_wrap`.
- Not `a7ng_astra_11_a09r3_uart_iobff_wrap`.
- Not `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`.
- Not `a7ng_astra_09_r7_uart_query_rew_wrap` (XSim bag top; KEEP).
- Not `a7ng_astra_09_r3_uart_wrap` (XSim bag top).
- Not PRODUCTION_TOP.

## Comparison (not identity)

- Do **not** quote ASTRA-07-SCALE-MID-01 N=64 INCOMP as this routed result.
- Do **not** quote ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed WNS=+0.336 / WHS=+0.104 as this result.
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
`uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…`. Prior UART-impl wrap KEEP
(not compiled as this top). R7 XSim wrap KEEP. Cited `constraints/arty_a7_100.xdc`
hashed as pinout cite (not compiled as the impl XDC).

## If WNS < 0 or WHS < 0

FAIL this bag, keep the routed report, one bounded experiment in this bag
(post-route `phys_opt_design`; **same frozen STA envelope**; still 50 MHz;
still IOB=TRUE; still LED delays 2.000/0.500 vs clk50u; still UART
FALSE_PATH_HOLD). Still no bitstream.
Do not program a failing bit. Do not invent delay numbers after seeing WNS/WHS.
Do not patch frozen `uart_rx.sv`. Do not retune LED 2.000/0.500.

## Out of scope

Master ASTRA-09 production path. Master F3. LM06. BOARD_PASS. ASTRA-13.
write_bitstream. JTAG/xsdb/COM12/hw_server. PRODUCTION_TOP identity.
Silicon UART / silicon MMCM / silicon BRAM. N=64 / 65536 / 800k.
Retune of frozen 2.000/0.500. Silent freeze of this wrap as PRODUCTION_TOP.
