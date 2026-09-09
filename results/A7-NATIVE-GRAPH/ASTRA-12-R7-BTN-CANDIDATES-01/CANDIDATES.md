# CANDIDATES — ASTRA-12-R7-BTN-CANDIDATES-01

```text
GATE             = ASTRA-12-R7-BTN-CANDIDATES-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
BTN_NEW_ROWS     = 2
R6_POINTER_ROWS  = 12 unique (files not rewritten)
CANDIDATE_COUNT  = 14
PROGRAM          = NO
write_bitstream  = not called
BIT              = NOT_BUILT (this bag)
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = BLOCKED
LM06             = OPEN
AUDITOR_PRIOR    = 20260907T0530Z ACCEPT_PARTIAL | REJECT_PROMOTION
BTN_IO_BAG       = ASTRA-11-A09R7-BTN-IO-01 FAIL_WHS WHS=-2.068 (stays on disk)
BTN_IDELAY_BAG   = ASTRA-11-A09R7-BTN-IDELAY-01 PASS_NARROW CLOSED_NARROW TAP=31
BTN_HOLD_POLICY  = RELATED_CLK50U_NO_FALSE_PATH_HOLD (both rows; false-path-btn NO)
UART_HOLD_POLICY = FALSE_PATH_HOLD_ASYNC_UART (inherited; honest; not physically MET)
BASE             = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
```

Parent does **not** pick a top. This bag **extends** the candidate table with
two BTN rows (FAIL bag kept as FAIL_WHS evidence; IDELAY bag PASS_NARROW).
It does **not** write `PRODUCTION_TOP=<module>`. Rows are **not ranked**.
Do not treat max WNS, TAP=31, BTN IOB packed, or WHS≥0 as a freeze.

Cited prior-bag files were **hashed in place**. Those files were **not rewritten**.
Those bags' run scripts were **not rerun**. Frozen RTL was **not patched**. No `.bit`
was generated here. ASTRA-12-R6 / R5 / R4 / R3 / R2, ASTRA-11-A09R7-BTN-IO-01,
ASTRA-11-A09R7-BTN-IDELAY-01, ASTRA-11-A09R7-LED-IO-01, and A09R7 UART impl
were **not edited**.

Authority for the new-row WNS/WHS = that bag’s raw `timing_route.rpt`
**Design Timing Summary** (Design State = Routed), **not** that bag’s RESULTS.md,
not auditor prose, not 12-R6 pack summaries.

Do not mix bags: this F1 routed result is **+0.452 / −2.068**; this I1 routed
result is **+0.574 / +0.131**; LED wrap is still **+0.411 / +0.027**; A09R7 UART
wrap is still **+0.336 / +0.104**; HOLD +0.115/+0.131, IOBFF +0.115/−4.915,
IODELAY +0.681, UART wrap +0.305, leftover A09 +1.041, wrap-route +5.733,
SOC-WRAP −4.765, TIMING-FIX +7.179 stay on their own reports.

`CANDIDATE_COUNT=14` = **2 new** (this bag) + **12** unique from
ASTRA-12-R6-LED-CANDIDATES-01. 12-R6 is **pointed**, not rewritten, not
double-counted.

---

## Table A — BTN new rows (this bag; raw reports)

| # | Top (module) | Bag | Kind | WNS ns (raw DTS) | WHS ns (raw DTS) | Clock | BTN D9/C9/B9/B8 | UART D10/A9 | LED H5/J5/T9/T10 | IOB FF | IDELAY | Hold policy | Bit |
|---|--------------|-----|------|-----------------:|-----------------:|-------|-----------------|-------------|------------------|--------|--------|-------------|-----|
| F1 | `a7ng_astra_11_a09r7_btn_io_wrap` | ASTRA-11-A09R7-BTN-IO-01 | Routed **FAIL_WHS** | **+0.452** TNS=0 | **−2.068** THS=−8.128 (4 endpoints) | `clk50u` 20.000 ns (P,G,A real) + virtual `uart_io_vclk` 20.000 ns | **YES** D9/C9/B9/B8 INPUT FIXED BTN0–BTN3 | **YES** D10 OUTPUT / A9 INPUT FIXED | **YES** H5/J5/T9/T10 OUTPUT FIXED LD4–LD7 | **YES** (IOB FF=10; ILOGIC=5 OLOGIC=5) | **NO** IDELAYE2=0 IDELAYCTRL=0 | BTN **RELATED_CLK50U_NO_FALSE_PATH_HOLD** delays **max 2.000 / min 0.500**; UART **FALSE_PATH_HOLD_ASYNC_UART** | **NOT_BUILT** |
| I1 | `a7ng_astra_11_a09r7_btn_idelay_wrap` | ASTRA-11-A09R7-BTN-IDELAY-01 | Routed **PASS_NARROW** | **+0.574** TNS=0 | **+0.131** (intra clk50u; **not** BTN pad) | `clk50u` 20.000 ns (P,G,A real) + `clk200u` 5.000 ns (P,G,A real) + virtual `uart_io_vclk` 20.000 ns | **YES** D9/C9/B9/B8 INPUT FIXED BTN0–BTN3 | **YES** D10 OUTPUT / A9 INPUT FIXED | **YES** H5/J5/T9/T10 OUTPUT FIXED LD4–LD7 | **YES** (IOB FF=10; ILOGIC=5 OLOGIC=5) | **YES TAP=31** IDELAYE2=4 FIXED + IDELAYCTRL=1 REFCLK 200 MHz | BTN **RELATED_CLK50U_NO_FALSE_PATH_HOLD** delays **max 2.000 / min 0.500**; **false-path-btn NO**; UART **FALSE_PATH_HOLD_ASYNC_UART** | **NOT_BUILT** |

DUT under F1 and I1: instance **`u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf`**.
Leftover `a7ng_astra_09_integ_path` is **not** this DUT.
Prior `a7ng_astra_11_a09r7_uart_impl_wrap` / `a7ng_astra_11_a09r7_led_io_wrap`
are **KEEP, not these tops**.

F1 stays **FAIL_WHS**. I1 WHS=+0.131 does **not** erase F1 WHS=−2.068.
I1 is **not** a freeze of `PRODUCTION_TOP`.

Do not add LUT/FF/BRAM/DSP across rows. Occupancy is **not** identity.
Do **not** add F1/I1 LUT/FF to LED wrap 4945/3615 or UART wrap 4945/3615 as a
whole-chip sum.

| # | LUT | FF | BRAM tile | DSP | Bonded IOB | IOB FF | IDELAYE2 | IDELAYCTRL | util rpt |
|---|----:|---:|----------:|----:|-----------:|-------:|---------:|-----------:|----------|
| F1 | 4944 | 3614 | 0 | 2 | 15 | 10 | 0 | 0 | `util_route.rpt` Design State Routed |
| I1 | 4947 | 3616 | 0 | 2 | 15 | 10 | 4 | 1 | `util_route.rpt` Design State Routed |

DTS WHS=−2.068 on F1 **is** BTN pad hold (`btn[0]` D9 → `btn_q_reg[0]/D`,
Input Delay min 0.500, data=1.417 IBUF-only). DTS WHS=+0.131 on I1 is
**intra-clk50u** `idelay_rdy_sync_reg[0]→[1]`, **not** BTN pad hold and **not**
UART I/O hold. I1 BTN pad hold is MET **+0.638 ns** (`timing_btn_in.rpt`,
Input Delay=0.500 vs related clk50u, IDELAYE2 2.707 ns on the path).
UART I/O hold columns are blank because of `FALSE_PATH_HOLD_ASYNC_UART`.
Do **not** promote I1 DTS WHS=+0.131 as BTN pad margin.

HOLD-wrap DTS WHS=+0.131 (Date Sun Sep 6 23:33:11 2026, Design
`a7ng_astra_11_a09r3_uart_iobff_hold_wrap`, WNS=+0.115) is a **numeric
coincidence**, not this I1 path.

---

## Table B — pointer to ASTRA-12-R6-LED-CANDIDATES-01 (files not rewritten)

Twelve unique candidates remain as recorded in
`results/A7-NATIVE-GRAPH/ASTRA-12-R6-LED-CANDIDATES-01/`. This bag **does not
rewrite** that directory. `CANDIDATES.md` and `SHA256.txt` were **re-hashed in
place**; hashes **MATCH** 12-R6 `SHA256.txt` / `SHA256_POST.txt`.

Pointer SHA256 of 12-R6 `CANDIDATES.md` (unchanged):
`917537363da034cc4192e42731a5a78a8b70136e3648dbc1ae2b328d50b07212`.

Pointer SHA256 of 12-R6 `SHA256.txt` (unchanged):
`6aeff64838408ac1f4b93db68721d28eb8c415456efe317af50bc09af1a54bfa`.

Identities pointed, **not** re-derived as this bag’s authority:

| # | Top (module) | Bag |
|---|--------------|-----|
| L1 | `a7ng_astra_11_a09r7_led_io_wrap` | ASTRA-11-A09R7-LED-IO-01 |
| N1 | `a7ng_astra_09_r7_uart_query_rew_wrap` | ASTRA-09-R7-UART-QUERY-REW-01 |
| N2 | `a7ng_astra_11_a09r7_uart_impl_wrap` | ASTRA-11-A09R7-UART-IMPL-ROUTE-01 |
| U1 | `a7ng_astra_09_r3_uart_wrap` | ASTRA-09-R3-UART-XSIM-01 |
| U2 | `a7ng_astra_11_a09r3_uart_impl_wrap` | ASTRA-11-A09R3-UART-IMPL-ROUTE-01 |
| U3 | `a7ng_astra_11_a09r3_uart_iodelay_wrap` | ASTRA-11-A09R3-UART-IODELAY-01 |
| U4 | `a7ng_astra_11_a09r3_uart_iobff_wrap` | ASTRA-11-A09R3-UART-IOBFF-01 |
| U5 | `a7ng_astra_11_a09r3_uart_iobff_hold_wrap` | ASTRA-11-A09R3-UART-IOBFF-HOLD-01 |
| P1 | `a7ng_astra_11_a09_impl_wrap` | ASTRA-11-A09-IMPL-ROUTE-01 |
| P2 | `arty_a7_astra_rtp_soc_top` | ASTRA-SOC-RTP-WRAP-ROUTE |
| P3 | `arty_a7_astra09_soc_top` | ASTRA-11-SOC-WRAP |
| P4 | `arty_a7_astra09_soc_top` | ASTRA-11-TIMING-FIX |

L1 LED wrap raw `timing_route.rpt` **re-hashed this bag, not rewritten**:
SHA256 `4fbd3e42e633dcf59e96276227314982398a81d59802b0341676bb83b0d52585`
MATCH 12-R6 freeze. That file remains Date **Mon Sep 7 03:11:15 2026**,
Design `a7ng_astra_11_a09r7_led_io_wrap`, WNS=+0.411 WHS=+0.027.
F1/I1 do **not** steal L1.

N2 UART wrap raw `timing_route.rpt` **re-hashed this bag, not rewritten**:
SHA256 `0c45687b6f79e0fa6ade58d0754a76c160b718b100cc6c014fc0374048378d2b`
MATCH 12-R6 / 12-R4 / 12-R5 freeze. That file remains Date **Mon Sep 7 01:52:48 2026**,
Design `a7ng_astra_11_a09r7_uart_impl_wrap`, WNS=+0.336 WHS=+0.104.

U4 WHS=−4.915 bag **not overwritten**. I1 WHS=+0.131 does **not** erase U4.
U5 WHS=+0.131 bag **not overwritten**. I1 WHS=+0.131 does **not** steal U5.

12-R6 WINNER = NOT_FROZEN. PRODUCTION_TOP = UNKNOWN. This bag does not promote
L1, N2, F1, or I1.

---

## BTN D9/C9/B9/B8, LED H5/J5/T9/T10, UART D10/A9 (F1 and I1)

Bag-local XDC (cite Digilent names; do **not** edit `constraints/arty_a7_100.xdc`):

```text
set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]
set_property -dict { PACKAGE_PIN C9    IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]
set_property -dict { PACKAGE_PIN B9    IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]
set_property -dict { PACKAGE_PIN B8    IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { led[0] }]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { led[1] }]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { led[2] }]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]
```

Raw `io.rpt` on F1 (Design `a7ng_astra_11_a09r7_btn_io_wrap`, Total User IO = **15**,
Date Mon Sep 7 04:24:54 2026) and I1 (Design `a7ng_astra_11_a09r7_btn_idelay_wrap`,
Total User IO = **15**, Date Mon Sep 7 04:52:58 2026):

```text
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    | ... | FIXED
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| D9         | btn[0]       | ... | INPUT       | LVCMOS33    | ... | FIXED
| C9         | btn[1]       | ... | INPUT       | LVCMOS33    | ... | FIXED
| B9         | btn[2]       | ... | INPUT       | LVCMOS33    | ... | FIXED
| B8         | btn[3]       | ... | INPUT       | LVCMOS33    | ... | FIXED
| H5         | led[0]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| J5         | led[1]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| T9         | led[2]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| T10        | led[3]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
```

UART/LED/BTN present on a named BTN wrap is **not** those pads on a frozen
production top (identity UNKNOWN). BTN IOB YES is **not** silicon buttons.
Routed IDELAYE2 tap **≠** silicon button delay.

---

## Raw WNS/WHS quotes (authority files)

### F1. `ASTRA-11-A09R7-BTN-IO-01/timing_route.rpt`

SHA256 `8749d728e0ea79aef93a8128a53da7ec9fed096974ee7f89f2b02ae2d28b1525`

Live file Date **Mon Sep 7 04:24:50 2026**. `fail_r0/timing_route.rpt` is the
**same SHA256** (same Date, same Design, same DTS). FAIL bag **not retuned**.

```text
Date         : Mon Sep  7 04:24:50 2026
Design       : a7ng_astra_11_a09r7_btn_io_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary numeric row:

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints
      0.452        0.000                      0                 8953       -2.068       -8.128                      4                 8951        3.000        0.000                       0                  3629
Timing constraints are not met.
```

Clock Summary (same rpt):

```text
sys_clk_pin  {0.000 5.000}      10.000          100.000
  clk50u     {0.000 10.000}     20.000          50.000
  clkfb      {0.000 5.000}      10.000          100.000
uart_io_vclk {0.000 10.000}     20.000          50.000
```

Intra-clock `clk50u`: WNS=0.452 WHS=−2.068 (TNS endpoints 7258; THS failing=4).

Inter-clock hold columns **blank**:

```text
uart_io_vclk  clk50u             19.270
clk50u        uart_io_vclk        7.313
```

Worst **setup** path (clk50u intra, Slack MET 0.452 ns):

```text
Source  u_a09r2/pv_reg[0][3]/C
Dest    u_a09r2/best_a_reg[15]/D
Requirement = 20.000 ns
Data Path Delay = 19.388 ns  (logic 5.609 / route 13.779)
```

Worst **hold** path (clk50u intra, Slack VIOLATED −2.068 ns) — **is** BTN pad hold:

```text
Source  btn[0]  (D9, input port clocked by clk50u)
Dest    btn_q_reg[0]/D  (ILOGIC_X0Y187)
Path Type Hold (Min at Slow Process Corner)
Data Path Delay = 1.417 ns  (IBUF=1; route 0.000)
Input Delay = 0.500 ns
Clock Path Skew = 3.712 ns (DCD=6.515 SCD=2.656 CPR=0.147)
Clock Uncertainty = 0.082 ns
Device hold = 0.191 ns
Check : 1.417 + 0.500 − 3.712 − 0.082 − 0.191 = −2.068
```

F1 `util_route.rpt`: IDELAYE2=0, IDELAYCTRL=0.

### I1. `ASTRA-11-A09R7-BTN-IDELAY-01/timing_route.rpt`

SHA256 `196966834b9a07d53a5a4b0f9cbf68f28065f0518cc18d3d5d0ed82dd4a97be6`

```text
Date         : Mon Sep  7 04:52:55 2026
Design       : a7ng_astra_11_a09r7_btn_idelay_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary numeric row:

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints
      0.574        0.000                      0                 8954        0.131        0.000                      0                 8952        0.264        0.000                       0                  3638
All user specified timing constraints are met.
```

Clock Summary (same rpt):

```text
sys_clk_pin  {0.000 5.000}      10.000          100.000
  clk200u    {0.000 2.500}       5.000          200.000
  clk50u     {0.000 10.000}     20.000           50.000
  clkfb      {0.000 5.000}      10.000          100.000
uart_io_vclk {0.000 10.000}     20.000           50.000
```

Intra-clock `clk50u`: WNS=0.574 WHS=0.131 (TNS endpoints 7259).

Inter-clock hold columns **blank**:

```text
uart_io_vclk  clk50u             19.270
clk50u        uart_io_vclk        7.313
```

clk50u path-group: Setup worst slack 0.574 ns, Hold worst slack 0.131 ns,
0 failing endpoints.

Worst **setup** path (clk50u intra, Slack MET 0.574 ns) — **intra-DUT**, not a
recycled UART/LED/FAIL number:

```text
Source  u_a09r2/pc2_reg[2][7]/C
Dest    u_a09r2/u_sgd/w_reg[19][1]/D
Requirement = 20.000 ns
Data Path Delay = 19.254 ns  (logic 10.243 / route 9.011)
```

Worst **hold** path (clk50u intra, Slack MET 0.131 ns) — **not BTN pad hold**:

```text
Source  idelay_rdy_sync_reg[0]/C   (SLICE_X0Y187)
Dest    idelay_rdy_sync_reg[1]/D   (SLICE_X0Y187)
Path Type Hold (Min at Fast Process Corner)
Data Path Delay = 0.206 ns (logic 0.141 / route 0.065)
```

### I1 clocks — `clocks_route.rpt`

SHA256 `338fb36a4721ee4c0cf363837c4aa18efb2b91b401278bc8a1855bd0e04ae7dc`

```text
Date         : Mon Sep  7 04:52:58 2026
Design       : a7ng_astra_11_a09r7_btn_idelay_wrap
Design State : Routed
sys_clk_pin   10.000      {0.000 5.000}   P           {CLK100MHZ}
uart_io_vclk  20.000      {0.000 10.000}  V           {}
clk200u        5.000      {0.000 2.500}   P,G,A       {u_mmcm/CLKOUT1}
clk50u        20.000      {0.000 10.000}  P,G,A       {u_mmcm/CLKOUT0}
clkfb         10.000      {0.000 5.000}   P,G,A       {u_mmcm/CLKFBOUT}
```

Pipe clock is **real** (not virtual). IDELAYCTRL refclock is **real**.
Only UART I/O ref is virtual (declared).

F1 `clocks_route.rpt` SHA256 `0db0d0611bbdfb1179b52b672c4c08fcc3bf033aee71a711aca6c74dc97c7ebe`:
`clk50u` P,G,A; `uart_io_vclk` V; **no** `clk200u` (no IDELAYCTRL).

### I1 BTN STA — `timing_btn_in.rpt`

SHA256 `5c3409e23e77b50952dd698d8080d1899f21286a6b394b81f8916ea292c39763`

Design State Routed, Date Mon Sep 7 04:53:00 2026, Design
`a7ng_astra_11_a09r7_btn_idelay_wrap`, command
`report_timing -from [get_ports {btn[*]}] -delay_type min_max`:

```text
btn[0] D9 → btn_q_reg[0]  Min/hold Slack (MET)  0.638 ns  Input Delay=0.500  IDELAY_X0Y187
btn[2] B9 → btn_q_reg[2]  Min/hold Slack (MET)  0.679 ns  Input Delay=0.500  IDELAY_X0Y177
btn[1] C9 → btn_q_reg[1]  Min/hold Slack (MET)  0.681 ns  Input Delay=0.500  IDELAY_X0Y178
btn[3] B8 → btn_q_reg[3]  Min/hold Slack (MET)  0.699 ns  Input Delay=0.500  IDELAY_X0Y176
```

Hold path `btn[0]` (Min at Slow Process Corner):

```text
Input Delay            = 0.500 ns
Data Path Delay        = 4.123 ns  (IBUF=1.417 + IDELAYE2=2.707; route 0.000)
Logic Levels           = 2  (IBUF=1 IDELAYE2=1)
Clock Path Skew        = 3.712 ns (DCD=6.515 SCD=2.656 CPR=0.147)
Clock Uncertainty      = 0.082 ns
Device hold            = 0.191 ns
Check                  : 4.123 + 0.500 − 3.712 − 0.082 − 0.191 = +0.638
```

F1 same skew family with data=1.417 IBUF-only → WHS=−2.068. I1 adds IDELAYE2
**2.707 ns** on that path. −2.068 + 2.707 = +0.639 ≈ +0.638 (1 ps).

BTN hold policy RELATED_CLK50U_NO_FALSE_PATH_HOLD is **honored** on both rows.
Do not cite I1 DTS WHS=+0.131 as this BTN hold number.

F1 `timing_btn_in.rpt` SHA256 `9793532824286108b660632037d44fc72f4b3bd5d463590f6f79f85d3b2ca02b`
Date Mon Sep 7 04:24:55 2026: Slack (VIOLATED) −2.068 ns `btn[0]` → `btn_q_reg[0]/D`.

### Delays + hold policy (PREREG / XDC hashed before impl; **not** invented after WNS)

F1 `btn_iodelay.xdc` SHA256 `af42128d6e4400f8c76eaaebbd26bb8cc58681c4f31f5cf8746f7b3a786d15cd`

I1 `btn_iodelay.xdc` SHA256 `61feabf3e7a4ed3fe32b064c8034e5623c8b00c8bdacff8116dee2905f6e8494`

Both files:

```text
set_input_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {btn[*]}]
set_input_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {btn[*]}]
```

I1 TAP=31 is **not** in the XDC; it is frozen in wrap RTL / PREREG **before**
impl (wrap SHA256 `5fa1c354a85fd3f7837da41c511888b7b7ab924ca63542bade489484e99b48ee`,
PREREG SHA256 `51719c2802fbce2231979f73d349a532629ac0149bcf2f421c0c62aff809f849`).
F1 wrap has **no** IDELAYE2 (wrap SHA256
`52e1b4f2a3c3b2902eea32d8dfdbe908c25f92231c847e6ca68a56e63eec6132`).

Raw I1 `exceptions_route.rpt` Design State=Routed 04:53:00 SHA256
`630a479c4066fcdd330846c290ed6cbf21ac999550064491f480ddb7254e6cd7`:

```text
Position  From                     To                   Setup  Hold
2         [get_ports {sw[*]}]      *                    false  false
8         [get_ports uart_txd_in]  *                    -      false
9         *                        [get_ports uart_rxd_out]  -      false
```

Raw F1 `exceptions_route.rpt` Design State=Routed 04:24:55 SHA256
`1ee5f969bfaea75fe79fdcd8bbee5fca93e0262a1184d9f2a8c5b6b0a83c2177`: **same three
rows**. **No** `btn[*]` exception on either bag. UART Hold column **`false`**.
UART Setup column **`-`** (setup **not** excepted). UART I/O hold vs
`uart_io_vclk` is **excepted**, not physically MET. Prior IOBFF bag WHS=−4.915
remains on disk.

**false-path-btn = NO** on F1 and I1.

### I1 IDELAYE2 TAP=31

Raw `BTN_IDELAYE2.txt` SHA256 `6e72b9b64afca04db1400347a61d84c3f85299e3b6ec0882a1051908701e4a42`:

```text
BTN_IDELAY_VALUE_PREREG=31
IDELAYE2_CELLS=4
IDELAYE2_TAP31_CELLS=4
IDELAYCTRL_CELLS=1
IDELAYE2_CELL=g_btn_idelay[0].u_idelay IDELAY_VALUE=31 IDELAY_TYPE=FIXED REFCLK_FREQUENCY=200.000
IDELAYCTRL_CELL=u_btn_idelayctrl
```

Raw I1 `util_route.rpt` SHA256 `717e494cd39edbf832636906db7a78a837750d8549db96a9fa8e117076766c74`
Design State Routed 04:52:53:

```text
Slice LUTs              4947
Slice Registers         3616
Block RAM Tile             0
DSPs                       2
Bonded IOB                15
  IOB Flip Flops          10
ILOGIC                     5
OLOGIC                     5
IDELAYCTRL                 1
IDELAYE2                   4
```

Raw F1 `util_route.rpt` SHA256 `b20b5d7077850746be508d31e816c3766d4d18da47610d17892be0c51a3f9471`
Design State Routed 04:24:49:

```text
Slice LUTs              4944
Slice Registers         3614
Block RAM Tile             0
DSPs                       2
Bonded IOB                15
  IOB Flip Flops          10
ILOGIC                     5
OLOGIC                     5
IDELAYCTRL                 0
IDELAYE2                   0
```

Raw F1/I1 `BTN_IOBFF.txt` (same SHA256
`a81845acc8d000d8cd3bfd7b0c6b8c4de8e9547a5886492e460a1bc6f406e90c`):
`btn_q_reg[0..3]` BEL=ILOGICE2.IFF PACKED=YES
LOC=ILOGIC_X0Y187 / X0Y178 / X0Y177 / X0Y176.

Raw F1/I1 `BTN_IOB.txt` (same SHA256
`f4a58912a14e037ea2ae172b3838f11c192df153622766c682d1f892f4b7bf8a`):
D9/C9/B9/B8 = BTN0–BTN3 YES. Cite `constraints/arty_a7_100.xdc`.

---

## Hashes (this bag Get-FileHash; files not rewritten)

| Object | SHA256 |
|--------|--------|
| F1 `timing_route.rpt` (live = fail_r0) | `8749d728e0ea79aef93a8128a53da7ec9fed096974ee7f89f2b02ae2d28b1525` |
| F1 `io.rpt` | `954fd447fa78740172ed8308cd67235c273a06f19f486f7bd1ceb60084e79738` |
| F1 `util_route.rpt` | `b20b5d7077850746be508d31e816c3766d4d18da47610d17892be0c51a3f9471` |
| F1 `exceptions_route.rpt` | `1ee5f969bfaea75fe79fdcd8bbee5fca93e0262a1184d9f2a8c5b6b0a83c2177` |
| F1 `clocks_route.rpt` | `0db0d0611bbdfb1179b52b672c4c08fcc3bf033aee71a711aca6c74dc97c7ebe` |
| F1 `timing_btn_in.rpt` | `9793532824286108b660632037d44fc72f4b3bd5d463590f6f79f85d3b2ca02b` |
| F1 `clk50_btn_io.xdc` | `7d84834cabf74da988b38d6f354270aa6419571c43528e454ffa93cf3239b7c9` |
| F1 `btn_iodelay.xdc` | `af42128d6e4400f8c76eaaebbd26bb8cc58681c4f31f5cf8746f7b3a786d15cd` |
| F1 wrap SV | `52e1b4f2a3c3b2902eea32d8dfdbe908c25f92231c847e6ca68a56e63eec6132` |
| I1 `timing_route.rpt` | `196966834b9a07d53a5a4b0f9cbf68f28065f0518cc18d3d5d0ed82dd4a97be6` |
| I1 `io.rpt` | `0344112568fd8e5e01af9075723126fad5547284f543f895b1b5eb5bba571a53` |
| I1 `util_route.rpt` | `717e494cd39edbf832636906db7a78a837750d8549db96a9fa8e117076766c74` |
| I1 `exceptions_route.rpt` | `630a479c4066fcdd330846c290ed6cbf21ac999550064491f480ddb7254e6cd7` |
| I1 `clocks_route.rpt` | `338fb36a4721ee4c0cf363837c4aa18efb2b91b401278bc8a1855bd0e04ae7dc` |
| I1 `timing_btn_in.rpt` | `5c3409e23e77b50952dd698d8080d1899f21286a6b394b81f8916ea292c39763` |
| I1 `clk50_btn_idelay.xdc` | `dc1b8849829878946d5cdf3ed46b9ae68f0e1f09dad4d83acf25b2e8ac7ebf85` |
| I1 `btn_iodelay.xdc` | `61feabf3e7a4ed3fe32b064c8034e5623c8b00c8bdacff8116dee2905f6e8494` |
| I1 wrap SV | `5fa1c354a85fd3f7837da41c511888b7b7ab924ca63542bade489484e99b48ee` |
| I1 `BTN_IDELAYE2.txt` | `6e72b9b64afca04db1400347a61d84c3f85299e3b6ec0882a1051908701e4a42` |
| I1 PREREG | `51719c2802fbce2231979f73d349a532629ac0149bcf2f421c0c62aff809f849` |
| Frozen A09-R2 DUT | `15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23` |
| Cite `constraints/arty_a7_100.xdc` | `1c12e6f8943261c7089984a3725642043d027b813549433b8256843227b6a9c2` |
| L1 `timing_route.rpt` (not rewritten) | `4fbd3e42e633dcf59e96276227314982398a81d59802b0341676bb83b0d52585` |
| N2 `timing_route.rpt` (not rewritten) | `0c45687b6f79e0fa6ade58d0754a76c160b718b100cc6c014fc0374048378d2b` |
| Auditor `20260907T0530Z/REPORT.md` | `6fa7b0f04fe5b65b92e11bc34bc9989b9055a4f426aa419f0b6a55d895feea51` |
| 12-R6 `CANDIDATES.md` (pointer; not rewritten) | `917537363da034cc4192e42731a5a78a8b70136e3648dbc1ae2b328d50b07212` |
| This bag `ACK.json` (written first) | `89e8e4546d91bf1236736b0f07d861a0a9fdea83b0a80a8dc5cf0f19cd7c7274` |

Full list: `SHA256.txt`.

---

## Not claimed

PRODUCTION_TOP. Winner. write_bitstream. BOARD_PASS. ASTRA-13. ACCEPT_BOARD.
LM06. Physical IOB hold MET (UART I/O hold vs `uart_io_vclk` excepted; U4
−4.915 remains). DTS WHS=+0.131 as BTN pad hold (BTN hold is +0.638).
F1 WHS=−2.068 as closed. UART STA ladder as one envelope (separate bags remain
separate). Master ASTRA-12 unique-bit / UART plan. Master ASTRA-11
FULLCHIP-COFIT. Master F3 10pp/CI. Master ASTRA-06. Ranking a row as “the” top.
Mixing I1 +0.574 with L1 +0.411 / N2 +0.336 / U2 +0.305 / U3 +0.681 / U4/U5
+0.115 / P2 +5.733 / F1 +0.452.
Promoting I1 WHS=+0.131 to erase F1 WHS=−2.068, U4 WHS=−4.915, U5 WHS=+0.131,
or N2 WHS=+0.104.
Silent freeze of `a7ng_astra_11_a09r7_btn_idelay_wrap` as PRODUCTION_TOP.
Closing 12-R6 residual (freeze a top **or keep UNKNOWN**) — this bag **keeps UNKNOWN**.
`set_false_path` on `btn[*]`. Retune of frozen 2.000/0.500.
Editing FAIL bag `ASTRA-11-A09R7-BTN-IO-01`.
