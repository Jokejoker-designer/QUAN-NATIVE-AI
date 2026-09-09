# PREREG — ASTRA-11-A09R7-BTN-IDELAY-01

Frozen before impl. PROGRAM=NO. No board program. No JTAG/xsdb/COM12/bitstream/write_bitstream/hw_server.
Does not edit ASTRA-11-A09R7-BTN-IO-01 (keep fail_r0 + WHS=−2.068; do not retune 2.000/0.500 there).
Does not edit ASTRA-11-A09R7-LED-IO-01 / ASTRA-11-A09R7-UART-IMPL-ROUTE-01 /
ASTRA-12-R6-LED-CANDIDATES-01 / ASTRA-09-R7-UART-QUERY-REW-01 /
ASTRA-11-A09R3-UART-IOBFF-HOLD-01 / ASTRA-11-A09R3-UART-IOBFF-01 /
ASTRA-11-A09R3-UART-IODELAY-01 / ASTRA-11-A09R3-UART-IMPL-ROUTE-01 /
ASTRA-09-R3-UART-XSIM-01 / ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-11-A09-IMPL-ROUTE-01 /
ASTRA-SOC-RTP-WRAP-ROUTE / ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 /
frozen RTL / frozen `uart_rx.sv`.
Does not overwrite BTN-IO wrap WNS=+0.452 WHS=−2.068, LED wrap WNS=+0.411 WHS=+0.027,
R7 UART wrap WNS=+0.336 WHS=+0.104, HOLD wrap WNS=+0.115 WHS=+0.131,
IOB-FF wrap WNS=+0.115 WHS=−4.915, I/O-delay wrap WNS=+0.681, UART wrap WNS=+0.305,
A09R2 wrap WNS=+0.648, A09 wrap WNS=+1.041, or wrap-route WNS=+5.733.
Does not open LM06 / BOARD / DDR / Master F3. Does not close ASTRA-13, BOARD_PASS, production SoC UART, LM06.
PRODUCTION_TOP stays UNKNOWN. Do not silent-freeze a top.
Do not `set_false_path` on `btn[*]`. Do not `set_false_path -hold` on BTN.

## Claim this revision may close

One unknown, this bag only: with **IDELAYE2** on BTN0–BTN3, **tap frozen here before impl**
(do not invent after WHS), same pins D9/C9/B9/B8 and same **2.000/0.500** related-clock
delays vs pipe `clk50u`, after implement+route of a **new named wrap** that **instantiates**
frozen `a7ng_astra_09_r2_cand_ovf` on `xc7a100tcsg324-1` at a **declared 50 MHz** constraint
with **clock-network delay included**, is Design Timing Summary **WHS ≥ 0 as well as
WNS ≥ 0** — **without a bitstream**, without false-path on btn, and without claiming BOARD_PASS.

ASTRA-11-A09R7-BTN-IO-01 routed WNS=+0.452 WHS=−2.068 is **not** this result
(that wrap has **no** IDELAYE2; this bag's residual).
ASTRA-11-A09R7-LED-IO-01 routed WNS=+0.411 WHS=+0.027 is **not** this result.
ASTRA-12-R6-LED-CANDIDATES-01 LED table PASS_NARROW is **not** this result.
ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed WNS=+0.336 WHS=+0.104 is **not** this result.
ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed WNS=+0.115 WHS=+0.131 is **not** this result.
ASTRA-11-A09R3-UART-IOBFF-01 routed WNS=+0.115 WHS=−4.915 is **not** this result.
ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681 is **not** this result.
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305 is **not** this result.
A09R2 wrap routed WNS=+0.648 is **not** this result.
A09 wrap routed WNS=+1.041 is **not** this result.
Wrap-route WNS=+5.733 (`arty_a7_astra_rtp_soc_top`) is **not** this result.

## Frozen IDELAYE2 tap + REFCLK policy (BEFORE impl) — do not invent after WHS

FAIL bag `ASTRA-11-A09R7-BTN-IO-01` (auditor 20260907T0500Z; do not edit that bag):

```text
WHS                 = -2.068 ns   (Design Timing Summary; Design State=Routed)
Path                = btn[0] D9 → btn_q_reg[0]/D  (ILOGICE2.IFF)
Input Delay min     = 0.500 ns
Data Path Delay     = 1.417 ns (IBUF; route 0.000)
Clock Path Skew     = 3.712 ns (DCD=6.515 SCD=2.656 CPR=0.147)
CU                  = 0.082 ns
Device hold         = 0.191 ns
Check               : 1.417 + 0.500 - 3.712 - 0.082 - 0.191 = -2.068
THS endpoints       = 4 (all four BTN pads)
phys_opt            = exhausted (netlist unmodified; WNS>=0)
IDELAYE2 in FAIL wrap = NONE
```

Need extra **min** data-path delay **≥ 2.068 ns** on `btn[*] → first FF`, without retuning
2.000/0.500 and without false-path on btn.

DS181 (Artix-7) / UG471 IDELAYE2 with IDELAYCTRL:

```text
TIDELAYRESOLUTION     = 1/(32 × 2 × FREF) = 1/(64 × 200 MHz) = 78.125 ps
Average tap @ 200 MHz = 78 ps  (DS181 footnote)
IDELAY_VALUE range    = 0 .. 31
31 taps × 78.125 ps   = 2.422 ns typical
27 taps × 78.125 ps   = 2.109 ns typical  (only 0.041 ns over 2.068; too tight)
```

200 MHz is the coarsest legal REFCLK (300 MHz = 52 ps/tap max 1.615 ns; 400 MHz N/A on -1
and max 1.210 ns). Only 200 MHz × 31 taps can cover 2.068 ns in one IDELAYE2.

```text
BTN_IDELAY_PRIMITIVE     = IDELAYE2
BTN_IDELAY_TYPE          = FIXED
BTN_IDELAY_VALUE         = 31
BTN_IDELAY_DELAY_SRC     = IDATAIN
BTN_IDELAY_SIGNAL        = DATA
BTN_IDELAY_HP_MODE       = FALSE
BTN_IDELAY_REFCLK_MHZ    = 200.0
BTN_IDELAY_REFCLK_SRC    = MMCME2_BASE CLKOUT1  (VCO 1000 MHz / 5) + BUFG clk200
BTN_IDELAYCTRL           = YES
BTN_IODELAY_GROUP        = ASTRA_BTN_IDELAY
BTN_IDELAY_PORTS         = btn[0] btn[1] btn[2] btn[3]
```

Tap **31** is frozen here from the FAIL-bag residual + DS181 tap math, **before** this bag's
impl. It is not fitted to a WHS this bag has not yet produced.

Not picked (written so they cannot be claimed later as this freeze):

- `IDELAY_VALUE=0` (FAIL wrap class; does not add the 2.068 ns).
- Mid tap 16 (16 × 78.125 ps = 1.250 ns < 2.068).
- REFCLK 300/400 MHz (less hold delay).
- `set_false_path` / `set_false_path -hold` on `btn[*]`.
- Retune of frozen 2.000/0.500.
- `phys_opt_design` as the hold fix (exhausted).

Setup: FAIL-bag BTN input setup slack was **+18.616 ns** (Input Delay max=2.000, period 20 ns).
31 taps adds ~2.4 ns typical (slow-corner more) and still leaves setup ≫ 0.

If WHS<0 after this freeze: FAIL this bag, keep the routed report, **one bounded tap
experiment with a new PREREG tap** (not a silent RTL edit; not a delay-number retune).
Still no bitstream. TAP=31 is already the IDELAYE2 maximum; the experiment tap (if needed)
is recorded in `PREREG_EXP.md` before that second impl.

## Frozen BTN pinout (BEFORE impl)

Cite, do not edit: `constraints/arty_a7_100.xdc`. Same set as FAIL bag.

```text
BTN[0]  = D9    BTN0   Sch=btn[0]   LVCMOS33
BTN[1]  = C9    BTN1   Sch=btn[1]   LVCMOS33
BTN[2]  = B9    BTN2   Sch=btn[2]   LVCMOS33
BTN[3]  = B8    BTN3   Sch=btn[3]   LVCMOS33
```

Proof after route: `io.rpt` shows those four sites FIXED on `btn[0:3]`.

## Frozen BTN input delay numbers (BEFORE impl) — copy, do not retune

Keep FAIL-bag numbers. Do **not** retune 2.000/0.500.

```text
STA_ENVELOPE_BTN = BTN_IO_DELAY_2P000_0P500_VS_CLK50U
BTN_IN_MAX_NS    = 2.000
BTN_IN_MIN_NS    = 0.500
BTN_CLK_REF      = clk50u  period 20.000 ns  (MMCM+BUFG; REAL; related)
BTN_HOLD_POLICY  = RELATED_CLK50U_NO_FALSE_PATH_HOLD
```

Do **not** `set_false_path -from [get_ports {btn[*]}]`.
Do **not** `set_false_path -hold` on `btn[*]`.
Do **not** time BTN against virtual `uart_io_vclk`.

`clk50u` is MMCM-derived and does not exist at pre-synth `read_xdc`. Delay
**numbers** are frozen here and in `btn_iodelay.xdc` before impl. That XDC is
`read_xdc` **after synth** (before opt/place/route) when `clk50u` exists.

```tcl
set_input_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {btn[*]}]
set_input_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {btn[*]}]
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

## Frozen IOB FF + IDELAYE2 policy (BEFORE impl)

Do **not** patch frozen `uart_rx.sv` / `uart_tx.sv`. Pack pad registers in this wrap.
BTN pads go through IDELAYE2 then the IOB FF.

```text
UART_RX_IOB_FF  = uart_rx_iob   samples uart_txd_in (A9)
UART_TX_IOB_FF  = uart_tx_iob   drives uart_rxd_out (D10)
LED_IOB_FF      = led_q[3:0]    drives led[3:0] (H5/J5/T9/T10)
BTN_IDELAY      = IDELAYE2 IDATAIN=btn[i] DATAOUT=btn_dly[i] IDELAY_VALUE=31
BTN_IOB_FF      = btn_q[3:0]    samples btn_dly[3:0] (D9/C9/B9/B8 after IDELAY)
IOB_XDC         = set_property IOB TRUE on uart_txd_in uart_rxd_out led[*] btn[*]
PACK_PROOF      = routed BEL/LOC in IOB / ILOGIC / IDELAYE2 / IDELAYCTRL
BTN_IOB_PROOF   = io.rpt D9/C9/B9/B8 FIXED (required)
BTN_IDELAY_PROOF= four IDELAYE2 cells IDELAY_VALUE=31 plus one IDELAYCTRL REFCLK=clk200
```

## Frozen build identity

```text
GATE           = ASTRA-11-A09R7-BTN-IDELAY-01
PART           = xc7a100tcsg324-1
VIVADO         = 2026.1
LICENSE        = D:\Xilinx\licenses\vivado_basic.lic
TOP            = a7ng_astra_11_a09r7_btn_idelay_wrap
DUT_MODULE     = a7ng_astra_09_r2_cand_ovf
DUT_INSTANCE   = u_a09r2
UART_RX        = uart_rx  (rtl/board/uart_rx.sv)
UART_TX        = uart_tx  (rtl/board/uart_tx.sv)
UART_RXD_OUT   = D10  (FPGA TX, Digilent uart_rxd_out)
UART_TXD_IN    = A9   (FPGA RX, Digilent uart_txd_in)
LED[0:3]       = H5/J5/T9/T10  (LD4–LD7; cited constraints/arty_a7_100.xdc)
BTN[0:3]       = D9/C9/B9/B8   (BTN0–BTN3; cited constraints/arty_a7_100.xdc)
BTN_IDELAY_VALUE = 31
BTN_IDELAY_REFCLK = 200 MHz MMCM CLKOUT1 + BUFG
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

With IDELAYE2 on BTN0–BTN3 (tap **31**, REFCLK **200 MHz**, frozen here before impl),
same pins D9/C9/B9/B8 and same 2.000/0.500 related-clock delays, after implement+route
of that named wrap on xc7a100tcsg324-1 at 50 MHz, is Design Timing Summary **WHS ≥ 0
as well as WNS ≥ 0** — without a bitstream and without false-path on btn?

## Wrapper law

- New named BTN-IDELAY wrap only. Instantiates frozen A09-R2 DUT. Does not duplicate QSE /
  sparse / 2-hop / SGD RTL.
- UART-class: keeps D10/A9 + R7 query-rew FSM. Keeps LED IOB FFs + LED delays.
  Adds IDELAYE2+IDELAYCTRL on BTN, then BTN IOB FFs. Keeps BTN delays 2.000/0.500.
  No `set_false_path` on `btn[*]`.
- Prior BTN-IO wrap `a7ng_astra_11_a09r7_btn_io_wrap` is **KEEP_NOT_COMPILED**.
  Do not edit that bag.
- Prior R7 UART impl wrap `a7ng_astra_11_a09r7_uart_impl_wrap` is **KEEP_NOT_COMPILED**.
- Prior LED-IO wrap `a7ng_astra_11_a09r7_led_io_wrap` is **KEEP_NOT_COMPILED**.
- Frozen `a7ng_astra_09_integ_path.sv` is **not** compiled and **not** instantiated.
- Instantiates frozen `uart_rx` / `uart_tx`. UART pins constrained to official Arty
  D10 / A9. LED pins constrained to cited H5/J5/T9/T10. BTN pins constrained to
  cited D9/C9/B9/B8. Do not edit `constraints/arty_a7_100.xdc`.
- Bag-local AXI plant is a **fixture** (not `a7ng_axi_bram128`, not silicon BRAM).
- `load_from_tb` path unused (`load_v_i` tied 0).
- Not `arty_a7_astra_rtp_soc_top`. Not `a7ng_astra_11_a09r7_uart_impl_wrap`.
- Not `a7ng_astra_11_a09r7_led_io_wrap`.
- Not `a7ng_astra_11_a09r7_btn_io_wrap`.
- Not `a7ng_astra_11_a09r3_uart_impl_wrap`.
- Not `a7ng_astra_11_a09r3_uart_iodelay_wrap`.
- Not `a7ng_astra_11_a09r3_uart_iobff_wrap`.
- Not `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`.
- Not `a7ng_astra_09_r7_uart_query_rew_wrap` (XSim bag top; KEEP).
- Not `a7ng_astra_09_r3_uart_wrap` (XSim bag top).
- Not PRODUCTION_TOP.

## Comparison (not identity)

- Do **not** quote ASTRA-11-A09R7-BTN-IO-01 routed WNS=+0.452 / WHS=−2.068 as this result.
- Do **not** quote ASTRA-11-A09R7-LED-IO-01 routed WNS=+0.411 / WHS=+0.027 as this result.
- Do **not** quote ASTRA-12-R6-LED-CANDIDATES-01 LED table as this result.
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
`uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…`. Prior BTN-IO wrap KEEP
(not compiled as this top). Prior UART-impl wrap KEEP. Prior LED-IO wrap KEEP.
R7 XSim wrap KEEP. Cited `constraints/arty_a7_100.xdc` hashed as pinout cite
(not compiled as the impl XDC).

## If WNS < 0 or WHS < 0

FAIL this bag, keep the routed report (`fail_r0/`). One bounded **tap** experiment:
write `PREREG_EXP.md` with a **new** tap **before** the second impl (not silent).
Still 50 MHz. Still IOB=TRUE. Still BTN delays 2.000/0.500 vs clk50u. Still no
`set_false_path` on btn. Still no bitstream. Do not program a failing bit.
Do not invent delay numbers. Do not patch frozen `uart_rx.sv`. Do not retune
BTN 2.000/0.500. Do not treat post-route `phys_opt_design` as the hold fix
(exhausted on the FAIL bag).

## Out of scope

Master ASTRA-09 production path. Master F3. LM06. BOARD_PASS. ASTRA-13.
write_bitstream. JTAG/xsdb/COM12/hw_server. PRODUCTION_TOP identity.
Silicon UART / silicon MMCM / silicon BRAM / silicon buttons. N=64 / 65536 / 800k.
Retune of frozen 2.000/0.500. Silent freeze of this wrap as PRODUCTION_TOP.
False-path on `btn[*]`. Edit of ASTRA-11-A09R7-BTN-IO-01.
