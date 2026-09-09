# CANDIDATES — ASTRA-12-R6-LED-CANDIDATES-01

```text
GATE             = ASTRA-12-R6-LED-CANDIDATES-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
LED_NEW_ROWS     = 1
R4_POINTER_ROWS  = 11 unique (files not rewritten)
R5_POINTER       = BRIEF two-column (files not rewritten; not extra unique tops)
CANDIDATE_COUNT  = 12
PROGRAM          = NO
write_bitstream  = not called
BIT              = NOT_BUILT (this bag)
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = BLOCKED
LM06             = OPEN
AUDITOR_PRIOR    = 20260907T0400Z ACCEPT_PARTIAL | REJECT_PROMOTION
LED_ROUTE_BAG    = ASTRA-11-A09R7-LED-IO-01 PASS_NARROW CLOSED_NARROW
LED_HOLD_POLICY  = RELATED_CLK50U_NO_FALSE_PATH_HOLD
UART_HOLD_POLICY = FALSE_PATH_HOLD_ASYNC_UART (inherited; honest; not physically MET)
BASE             = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
```

Parent does **not** pick a top. This bag **extends** the candidate table with
the LED wrap. It does **not** write `PRODUCTION_TOP=<module>`. Rows are **not
ranked**. Do not treat max WNS, LED IOB packed, UART IOB packed, or
hold-exception WHS≥0 as a freeze.

Cited prior-bag files were **hashed in place**. Those files were **not rewritten**.
Their run scripts were **not rerun**. Frozen RTL was **not patched**. No `.bit`
was generated here. ASTRA-12-R2 / R3 / R4 / R5 and ASTRA-11-A09R7-LED-IO-01
and A09R7 UART impl were **not edited**.

Authority for the new row WNS/WHS = that bag’s raw `timing_route.rpt`
**Design Timing Summary** (Design State = Routed), **not** that bag’s RESULTS.md,
not auditor prose, not 12-R4/R5 pack summaries.

Do not mix bags: this L1 routed result is **+0.411 / +0.027**; A09R7 UART wrap
is still **+0.336 / +0.104**; HOLD +0.115/+0.131, IOBFF +0.115/−4.915,
IODELAY +0.681, UART wrap +0.305, leftover A09 +1.041, wrap-route +5.733,
SOC-WRAP −4.765, TIMING-FIX +7.179 stay on their own reports.

`CANDIDATE_COUNT=12` = **1 new** (this bag) + **11** unique from
ASTRA-12-R4-R7-UART-CANDIDATES-01. 12-R5 is a two-column brief of two of those
already-counted tops; it is **pointed**, not double-counted.

---

## Table A — LED new row (this bag; raw reports)

| # | Top (module) | Bag | Kind | WNS ns (raw DTS) | WHS ns (raw DTS) | Clock | LED H5/J5/T9/T10 | UART D10/A9 | IOB FF | Hold policy | Bit |
|---|--------------|-----|------|-----------------:|-----------------:|-------|------------------|-------------|--------|-------------|-----|
| L1 | `a7ng_astra_11_a09r7_led_io_wrap` | ASTRA-11-A09R7-LED-IO-01 | Routed | **+0.411** TNS=0 | **+0.027** | `clk50u` 20.000 ns (P,G,A real) + virtual `uart_io_vclk` 20.000 ns | **YES** H5/J5/T9/T10 OUTPUT FIXED LD4–LD7 | **YES** D10 OUTPUT / A9 INPUT FIXED | **YES** (IOB FF=6; ILOGIC=1 OLOGIC=5) | LED **RELATED_CLK50U_NO_FALSE_PATH_HOLD** delays **max 2.000 / min 0.500**; UART **FALSE_PATH_HOLD_ASYNC_UART** delays **max 2.000 / min 0.500** | **NOT_BUILT** |

DUT under L1: instance **`u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf`**.
Leftover `a7ng_astra_09_integ_path` is **not** this DUT.
Prior `a7ng_astra_11_a09r7_uart_impl_wrap` is **KEEP, not this top**.

Do not add LUT/FF/BRAM/DSP across rows. Occupancy is **not** identity.
Do **not** add L1 LUT/FF to UART wrap 4945/3615 as a whole-chip sum.

| # | LUT | FF | BRAM tile | DSP | Bonded IOB | IOB FF | util rpt |
|---|----:|---:|----------:|----:|-----------:|-------:|----------|
| L1 | 4945 | 3615 | 0 | 2 | 15 | 6 | `util_route.rpt` Design State Routed |

L1 Slice LUT=4945 / FF=3615 matching the UART wrap is expected: four LED FFs
packed in IOB, not slice. Physical difference vs N2: IOB Flip Flops 2→6,
`no_output_delay` 4→0, new Design name/date/PID/WNS/WHS/endpoints.

DTS WHS=+0.027 is **intra-clk50u DUT hold**, **not** LED pad hold and **not**
UART I/O hold. LED hold is MET **+2.927 ns** (`timing_led_out.rpt`, Output
Delay=0.500 vs related clk50u). UART I/O hold columns are blank because of
`FALSE_PATH_HOLD_ASYNC_UART`. Do **not** promote WHS=+0.027 as LED pad margin.

---

## Table B — pointer to ASTRA-12-R4-R7-UART-CANDIDATES-01 (files not rewritten)

Eleven unique candidates remain as recorded in
`results/A7-NATIVE-GRAPH/ASTRA-12-R4-R7-UART-CANDIDATES-01/`. This bag **does not
rewrite** that directory. `CANDIDATES.md` and `SHA256.txt` were **re-hashed in
place**; hashes **MATCH** 12-R4 `SHA256.txt` / `SHA256_POST.txt` and 12-R5 freeze
of the same `CANDIDATES.md`.

Pointer SHA256 of 12-R4 `CANDIDATES.md` (unchanged):
`4d694af0be83100a94c682ff678f94487f19691f1cf953e42c51efe54baea84d`.

Pointer SHA256 of 12-R4 `SHA256.txt` (unchanged):
`3cf418341d8cc3c0b92353a4c1dd12bbd24ef4183e2aef1631486b1d96101c2a`.

Identities pointed, **not** re-derived as this bag’s authority:

| # | Top (module) | Bag |
|---|--------------|-----|
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

N2 UART wrap raw `timing_route.rpt` **re-hashed this bag, not rewritten**:
SHA256 `0c45687b6f79e0fa6ade58d0754a76c160b718b100cc6c014fc0374048378d2b`
MATCH 12-R4 / 12-R5 freeze. That file remains Date **Mon Sep 7 01:52:48 2026**,
Design `a7ng_astra_11_a09r7_uart_impl_wrap`. L1 does **not** steal N2
WNS=+0.336 WHS=+0.104.

U4 WHS=−4.915 bag **not overwritten**. L1 WHS=+0.027 does **not** erase U4.
N2 WHS=+0.104 does **not** erase U4.

---

## Table C — pointer to ASTRA-12-R5-FREEZE-BRIEF-01 (files not rewritten)

Two-column brief remains as recorded in
`results/A7-NATIVE-GRAPH/ASTRA-12-R5-FREEZE-BRIEF-01/`. This bag **does not
rewrite** that directory. Columns A/B are **already** P2 and N2 in the unique-11
set. They are **not** extra unique candidates.

Pointer SHA256 of 12-R5 `BRIEF.md` (unchanged):
`736500b0da266fd1e4542ad2e707ffe99286e510c47015ad657c50ca24b3315f`.

Pointer SHA256 of 12-R5 `SHA256.txt` (unchanged):
`1ae466a59dc904e8794955a84f62a07706497bc700604c18c8975c03ef83c1d2`.

12-R5 WINNER = NOT_FROZEN. PRODUCTION_TOP = UNKNOWN. This bag does not promote
either column, and does not add L1 as a third brief column.

---

## LED H5/J5/T9/T10 and UART D10/A9 (L1)

Bag-local XDC (cite Digilent names; do **not** edit `constraints/arty_a7_100.xdc`):

```text
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { led[0] }]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { led[1] }]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { led[2] }]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]
set_property IOB TRUE [get_ports uart_txd_in]
set_property IOB TRUE [get_ports uart_rxd_out]
set_property IOB TRUE [get_ports {led[*]}]
```

Raw `io.rpt` on L1 (Design `a7ng_astra_11_a09r7_led_io_wrap`, Total User IO = **15**,
Date Mon Sep 7 03:11:19 2026):

```text
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    | ... | FIXED
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| H5         | led[0]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| J5         | led[1]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| T9         | led[2]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| T10        | led[3]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
```

UART present on a named LED-IO wrap is **not** UART on a frozen production top
(identity UNKNOWN). LED IOB YES is **not** silicon LEDs.

---

## Raw WNS/WHS quotes (authority files)

### L1. `ASTRA-11-A09R7-LED-IO-01/timing_route.rpt`

SHA256 `4fbd3e42e633dcf59e96276227314982398a81d59802b0341676bb83b0d52585`

```text
Date         : Mon Sep  7 03:11:15 2026
Design       : a7ng_astra_11_a09r7_led_io_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary numeric row:

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints
      0.411        0.000                      0                 8949        0.027        0.000                      0                 8947        3.000        0.000                       0                  3626
All user specified timing constraints are met.
```

Clock Summary (same rpt):

```text
sys_clk_pin  {0.000 5.000}      10.000          100.000
  clk50u     {0.000 10.000}     20.000          50.000
  clkfb      {0.000 5.000}      10.000          100.000
uart_io_vclk {0.000 10.000}     20.000          50.000
```

Intra-clock `clk50u`: WNS=0.411 WHS=0.027 (TNS endpoints 7254).

Inter-clock hold columns **blank**:

```text
uart_io_vclk  clk50u             19.270
clk50u        uart_io_vclk        7.313
```

check_timing embedded in the same rpt: `no_output_delay (0)`,
`partial_output_delay (0)`, `no_input_delay (8)` = `sw[*]`/`btn[*]` with
false-path (MEDIUM). LED ports are **not** in `no_output_delay`.

Worst **setup** path (clk50u intra, Slack MET 0.411 ns):

```text
Source  u_a09r2/FSM_sequential_st_reg[3]/C
Dest    u_a09r2/u_sgd/w_reg[24][2]/D
Requirement = 20.000 ns
Data Path Delay = 19.402 ns  (logic 10.274 / route 9.128)
```

Worst **hold** path (clk50u intra, Slack MET 0.027 ns):

```text
Source  u_a09r2/u_sp/u_walk/ntrunc_reg[2]/C
Dest    u_a09r2/u_sp/u_walk/n_trunc_o_reg[2]/D
Data Path Delay = 0.358 ns
```

DTS WHS=+0.027 is **intra clk50u**, not LED hold vs clk50u, not UART I/O hold
vs `uart_io_vclk`.

### L1 clocks — `clocks_route.rpt`

SHA256 `a0ba99514d703b4b634435dd79ae74f10f2becfd928953d36565e417e2a022c0`

```text
Date         : Mon Sep  7 03:11:19 2026
Design       : a7ng_astra_11_a09r7_led_io_wrap
Design State : Routed
sys_clk_pin   10.000      {0.000 5.000}   P           {CLK100MHZ}
uart_io_vclk  20.000      {0.000 10.000}  V           {}
clk50u        20.000      {0.000 10.000}  P,G,A       {u_mmcm/CLKOUT0}
clkfb         10.000      {0.000 5.000}   P,G,A       {u_mmcm/CLKFBOUT}
```

Pipe clock is **real** (not virtual). Only UART I/O ref is virtual (declared).

### L1 LED STA — `timing_led_out.rpt`

SHA256 `335f735dd12a6ef7ea82a922536c9b3762dbb9cfcf5d171c092e94c3e78d89f9`

Design State Routed, Date Mon Sep 7 03:11:21 2026, Design
`a7ng_astra_11_a09r7_led_io_wrap`:

```text
led_q_reg[3] → led[3]  Max/setup Slack (MET) 10.321 ns  Output Delay=2.000  dest T10
led_q_reg[1] → led[1]  Min/hold  Slack (MET)  2.927 ns  Output Delay=0.500  dest J5
```

LED hold policy RELATED_CLK50U_NO_FALSE_PATH_HOLD is **honored**. Do not cite
DTS WHS=+0.027 as this LED hold number.

### L1 delays + hold policy (PREREG / XDC hashed before impl; **not** invented after WNS)

`led_iodelay.xdc` SHA256 `9d25526c796fda83ea1a1e8b7ba7837a1ad3d12399709c5c21fa9a2cc49c8707`

```text
set_output_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {led[*]}]
set_output_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {led[*]}]
```

`clk50_led_io.xdc` SHA256 `48558c4a44b12436725c4b75b35d682d1d7ed5abe92121aadf9cf1a132f8b78b`

```text
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]
set_false_path -hold -from [get_ports uart_txd_in]
set_false_path -hold -to   [get_ports uart_rxd_out]
```

Raw `exceptions_route.rpt` Design State=Routed 03:11:20 SHA256
`2400019f6213ec181a7afafef2b74be3168bc72553d1903c609cb2cb571ef81f`:

```text
Position  From                     To                   Setup  Hold
2         [get_ports {sw[*]}]      *                    false  false
3         [get_ports {btn[*]}]     *                    false  false
9         [get_ports uart_txd_in]  *                    -      false
10        *                        [get_ports uart_rxd_out]  -      false
```

**No** `led[*]` exception. UART Hold column **`false`**. UART Setup column **`-`**
(setup **not** excepted). UART I/O hold vs `uart_io_vclk` is **excepted**, not
physically MET. Prior IOBFF bag WHS=−4.915 remains on disk.

### L1 IOB FF packed

Raw `util_route.rpt` SHA256 `48f6366cb8b87a94118d3dc04dd48e5f9c1e5e305a257f6dfb24d7ad12b1b9a7`
Design State Routed 03:11:14:

```text
Slice LUTs              4945
Slice Registers         3615
Block RAM Tile             0
DSPs                       2
Bonded IOB                15
  IOB Flip Flops           6
ILOGIC                     1
OLOGIC                     5
```

Raw `LED_IOBFF.txt`: `led_q_reg[0..3]` BEL=OLOGICE2.OUTFF PACKED=YES
LOC=OLOGIC_X1Y101 / X1Y100 / X0Y52 / X0Y51.

Raw `UART_IOBFF.txt`: RX BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y171 PACKED=YES /
TX BEL=OLOGICE2.OUTFF LOC=OLOGIC_X0Y161 PACKED=YES.

Raw `LED_IOB.txt`: H5/J5/T9/T10 = LD4–LD7 YES. Cite `constraints/arty_a7_100.xdc`.

---

## Hashes (this bag Get-FileHash; files not rewritten)

| Object | SHA256 |
|--------|--------|
| L1 `timing_route.rpt` | `4fbd3e42e633dcf59e96276227314982398a81d59802b0341676bb83b0d52585` |
| L1 `io.rpt` | `a09c4fa233bc7301503882c278887fde0d3018fae6da2939856346d94eea2e24` |
| L1 `util_route.rpt` | `48f6366cb8b87a94118d3dc04dd48e5f9c1e5e305a257f6dfb24d7ad12b1b9a7` |
| L1 `exceptions_route.rpt` | `2400019f6213ec181a7afafef2b74be3168bc72553d1903c609cb2cb571ef81f` |
| L1 `clocks_route.rpt` | `a0ba99514d703b4b634435dd79ae74f10f2becfd928953d36565e417e2a022c0` |
| L1 `timing_led_out.rpt` | `335f735dd12a6ef7ea82a922536c9b3762dbb9cfcf5d171c092e94c3e78d89f9` |
| L1 `clk50_led_io.xdc` | `48558c4a44b12436725c4b75b35d682d1d7ed5abe92121aadf9cf1a132f8b78b` |
| L1 `led_iodelay.xdc` | `9d25526c796fda83ea1a1e8b7ba7837a1ad3d12399709c5c21fa9a2cc49c8707` |
| L1 wrap SV | `7bb960c09ec79d95554ffa08c58de13496ea35327d27ba449ba18bdda77d6e7c` |
| L1 plant SV | `42e99ee8231e8c695c787fe600a32d1fec05d8b04e296a008f60f8f9d6c6bfb3` |
| L1 `LED_IOB.txt` | `6a89bcc2a1514b5db960e5d2af0cf732345e3330706d0e16d7c0da481a9d2e07` |
| L1 `LED_IOBFF.txt` | `ac043c21fcf0a658405c5b35a22b371468743bef310052261d732cd3975f5973` |
| L1 `UART_IOB.txt` | `07099d615a6a648736c1a603502a492ac53c8dcec6d969e1e9e50971620e8a23` |
| L1 `UART_IOBFF.txt` | `eae1da4e0d526e139596b75c78345ad99b1b304b17eb504fcae084567ba38c35` |
| L1 PREREG | `f9cc309d8fa1d46292d58913c694dbf40d9b41c866717eb3d39788d9baa892b6` |
| Frozen A09-R2 DUT | `15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23` |
| Cite `constraints/arty_a7_100.xdc` | `1c12e6f8943261c7089984a3725642043d027b813549433b8256843227b6a9c2` |
| N2 `timing_route.rpt` (not rewritten) | `0c45687b6f79e0fa6ade58d0754a76c160b718b100cc6c014fc0374048378d2b` |
| Auditor `20260907T0400Z/REPORT.md` | `0d15df731447f6df4ce066dc1c6cccfb4df0d860846d1f4bfeba37b1e975b736` |
| 12-R4 `CANDIDATES.md` (pointer; not rewritten) | `4d694af0be83100a94c682ff678f94487f19691f1cf953e42c51efe54baea84d` |
| 12-R5 `BRIEF.md` (pointer; not rewritten) | `736500b0da266fd1e4542ad2e707ffe99286e510c47015ad657c50ca24b3315f` |
| This bag `ACK.json` (written first) | `c1187d8ae2a8ead8b866911373d9331453f25dccfadb38015be3bd85e28c4cfb` |

Full list: `SHA256.txt`.

---

## Not claimed

PRODUCTION_TOP. Winner. write_bitstream. BOARD_PASS. ASTRA-13. ACCEPT_BOARD.
LM06. Physical IOB hold MET (UART I/O hold vs `uart_io_vclk` excepted; U4
−4.915 remains). DTS WHS=+0.027 as LED pad hold (LED hold is +2.927).
UART STA ladder as one envelope (separate bags remain separate). Master ASTRA-12
unique-bit / UART plan. Master ASTRA-11 FULLCHIP-COFIT. Master F3 10pp/CI.
Master ASTRA-06. Ranking a row as “the” top.
Mixing L1 +0.411 with N2 +0.336 / U2 +0.305 / U3 +0.681 / U4/U5 +0.115 /
P2 +5.733.
Promoting L1 WHS=+0.027 to erase U4 WHS=−4.915 or N2 WHS=+0.104.
Silent freeze of `a7ng_astra_11_a09r7_led_io_wrap` as PRODUCTION_TOP.
Closing 12-R5 residual (freeze a top **or keep UNKNOWN**) — this bag **keeps UNKNOWN**.
