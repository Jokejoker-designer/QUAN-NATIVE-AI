# CANDIDATES — ASTRA-12-R4-R7-UART-CANDIDATES-01

```text
GATE             = ASTRA-12-R4-R7-UART-CANDIDATES-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
R7_NEW_ROWS      = 2
R3_POINTER_ROWS  = 9
R2_POINTER_ROWS  = 4
CANDIDATE_COUNT  = 11
PROGRAM          = NO
write_bitstream  = not called
BIT              = NOT_BUILT (this bag)
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = BLOCKED
AUDITOR_PRIOR    = 20260907T0200Z ACCEPT_PARTIAL | REJECT_PROMOTION
R7_XSIM_BAG      = ASTRA-09-R7-UART-QUERY-REW-01 PASS_NARROW (ans=4 then w0=-5)
A09R7_ROUTE_BAG  = ASTRA-11-A09R7-UART-IMPL-ROUTE-01 PASS_NARROW
FALSE_PATH_HOLD  = HONEST (not cheat; DTS WHS intra-clk50u; UART I/O hold excepted)
BASE             = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
```

Parent does **not** pick a top. This bag **extends** the candidate table with
R7 UART query-rew XSim and A09R7 UART impl-route. It does **not** write
`PRODUCTION_TOP=<module>`. Rows are **not ranked**. Do not treat max WNS,
IOB FF packed, or hold-exception WHS≥0 as a freeze.

Cited prior-bag files were **hashed in place**. Those files were **not rewritten**.
Their run scripts were **not rerun**. Frozen RTL was **not patched**. No `.bit`
was generated here. ASTRA-12-R2-TOP-CANDIDATES-01 and
ASTRA-12-R3-UART-WRAP-CANDIDATES-01 were **not edited**.

Authority for WNS/WHS = each bag’s raw `timing_route.rpt` **Design Timing Summary**
(Design State = Routed), **not** that bag’s RESULTS.md. XSim row has **no** routed WNS.

Do not mix bags: R7 XSim is behavioral (no WNS); A09R7 routed is **+0.336 / +0.104**;
HOLD +0.115/+0.131, IOBFF +0.115/−4.915, IODELAY +0.681, UART wrap +0.305,
leftover A09 +1.041, wrap-route +5.733, SOC-WRAP −4.765, TIMING-FIX +7.179
stay on their own reports.

`CANDIDATE_COUNT=11` = **2 new** (this bag) + **5** 12-R3 UART wraps + **4** 12-R2
routed tops. 12-R3’s 9-row table already includes those 4 R2 tops; they are
**pointed**, not double-counted as extra unique candidates.

---

## Table A — R7 new rows (this bag; raw reports)

| # | Top (module) | Bag | Kind | WNS ns (raw DTS) | WHS ns (raw DTS) | Clock | UART D10/A9 | IOB FF | Hold policy | Bit |
|---|--------------|-----|------|-----------------:|-----------------:|-------|-------------|--------|-------------|-----|
| N1 | `a7ng_astra_09_r7_uart_query_rew_wrap` | ASTRA-09-R7-UART-QUERY-REW-01 | **XSim only** | **N/A** (no routed report) | **N/A** | UNISIM MMCME2_BASE 100→50 (not silicon) | ports YES; PACKAGE_PIN **NO** (no XDC) | N/A | none | **NOT_BUILT** |
| N2 | `a7ng_astra_11_a09r7_uart_impl_wrap` | ASTRA-11-A09R7-UART-IMPL-ROUTE-01 | Routed | **+0.336** TNS=0 | **+0.104** | `clk50u` 20.000 ns (P,G,A real) + virtual `uart_io_vclk` 20.000 ns | **YES** D10 OUTPUT / A9 INPUT FIXED | **YES** (IOB FF=2; ILOGIC=1 OLOGIC=1) | **FALSE_PATH_HOLD_ASYNC_UART**; delays **max 2.000 / min 0.500** | **NOT_BUILT** |

DUT under both R7 rows: instance **`u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf`**.
Leftover `a7ng_astra_09_integ_path` is **not** this DUT.

Do not add LUT/FF/BRAM/DSP across rows. Occupancy is **not** identity.

| # | LUT | FF | BRAM tile | DSP | Bonded IOB | IOB FF | util rpt |
|---|----:|---:|----------:|----:|-----------:|-------:|----------|
| N1 | N/A | N/A | N/A | N/A | N/A | N/A | XSim; no util_route |
| N2 | 4945 | 3615 | 0 | 2 | 15 | 2 | `util_route.rpt` |

N2 LUT=4945 / FF=3615 is **this R7 UART wrap**, not additive with HOLD 4802/3500,
IOBFF 4802/3500, I/O-delay 4803/3500, UART wrap 4804/3500, leftover A09 wrap
1305/1075, or wrap-route 4244/3810 BRAM=2.

---

## Table B — pointer to ASTRA-12-R3-UART-WRAP-CANDIDATES-01 (files not rewritten)

Nine rows remain as recorded in
`results/A7-NATIVE-GRAPH/ASTRA-12-R3-UART-WRAP-CANDIDATES-01/`. This bag **does not rewrite**
that directory. Timing reports and `CANDIDATES.md` were **re-hashed in place**; hashes
**MATCH** 12-R3 `SHA256.txt` / `SHA256_POST.txt`. WNS below is quoted from those
**same raw reports opened this bag**, not from 12-R3 RESULTS.md.

| # | Top (module) | Bag | Kind | WNS ns (raw DTS) | WHS ns (raw DTS) | UART D10/A9 | IOB FF | Bit |
|---|--------------|-----|------|-----------------:|-----------------:|-------------|--------|-----|
| U1 | `a7ng_astra_09_r3_uart_wrap` | ASTRA-09-R3-UART-XSIM-01 | XSim | **N/A** | **N/A** | ports YES; PACKAGE_PIN NO | N/A | NOT_BUILT |
| U2 | `a7ng_astra_11_a09r3_uart_impl_wrap` | ASTRA-11-A09R3-UART-IMPL-ROUTE-01 | Routed | **+0.305** | **+0.024** | YES | NO | NOT_BUILT |
| U3 | `a7ng_astra_11_a09r3_uart_iodelay_wrap` | ASTRA-11-A09R3-UART-IODELAY-01 | Routed | **+0.681** | **+0.100** | YES | NO | NOT_BUILT |
| U4 | `a7ng_astra_11_a09r3_uart_iobff_wrap` | ASTRA-11-A09R3-UART-IOBFF-01 | Routed | **+0.115** | **−4.915** | YES | YES | NOT_BUILT |
| U5 | `a7ng_astra_11_a09r3_uart_iobff_hold_wrap` | ASTRA-11-A09R3-UART-IOBFF-HOLD-01 | Routed | **+0.115** | **+0.131** | YES | YES | NOT_BUILT |
| P1 | `a7ng_astra_11_a09_impl_wrap` | ASTRA-11-A09-IMPL-ROUTE-01 | Routed | **+1.041** | **+0.160** | **NO** | — | NOT_BUILT |
| P2 | `arty_a7_astra_rtp_soc_top` | ASTRA-SOC-RTP-WRAP-ROUTE | Routed | **+5.733** | **+0.029** | YES | — | UNPROGRAMMED `8116fa77…` |
| P3 | `arty_a7_astra09_soc_top` | ASTRA-11-SOC-WRAP | Routed | **−4.765** | — | YES | — | UNPROGRAMMED `c7442d16…` |
| P4 | `arty_a7_astra09_soc_top` | ASTRA-11-TIMING-FIX | Routed | **+7.179** | **+0.083** | YES | — | UNPROGRAMMED `a5c3f2c4…` |

Pointer SHA256 of 12-R3 `CANDIDATES.md` (unchanged):
`713ecb714bd482f02aff1e491fcdef2d13844acea8446ad79487291b5fbecf87`.

U5 HOLD_POLICY **FALSE_PATH_HOLD_ASYNC_UART** (honest; UART I/O hold excepted).
U4 WHS=−4.915 bag **not overwritten**. N2 WHS=+0.104 does **not** erase U4.

---

## Table C — pointer to ASTRA-12-R2-TOP-CANDIDATES-01 (files not rewritten)

Four routed ASTRA board-level tops remain as recorded in
`results/A7-NATIVE-GRAPH/ASTRA-12-R2-TOP-CANDIDATES-01/`. This bag **does not rewrite**
that directory. These are the **same** P1–P4 as Table B. Cited for handoff
completeness; **not** extra unique candidates.

Pointer SHA256 of 12-R2 `CANDIDATES.md` (unchanged):
`ccfe51e2c6be0ee1cf312f9ea3f9f431c3b6896cfce608ed5b64fedd46619178`.

P3 and P4 share a module name and are **not** the same compile. See 12-R2 `CANDIDATES.md`.

---

## UART D10/A9 per new row

### N1 — ASTRA-09-R7-UART-QUERY-REW-01 (no XDC)

Wrap ports: `uart_txd_in`, `uart_rxd_out`. **No PACKAGE_PIN.** XSim behavioral UART
at 115200 8N1; MAGIC **A2**. Not a routed IOB.

Raw `xsim.log` (session Mon Sep 7 01:24:47–01:26:05 2026, PID 46472, snapshot `a09r7qr`):

```text
TB ASTRA-09-R7-UART-QUERY-REW DUT=a7ng_astra_09_r7_uart_query_rew_wrap INNER=a7ng_astra_09_r2_cand_ovf.u_sgd PROGRAM=NO
UART 115200 8N1 CPB_PIN100=868 BIT_NS=8680 PRODUCTION_TOP=UNKNOWN
FRAME SMOKE_UART a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
DECODE SMOKE_UART magic=a2 tbl=0 st=0 ans=4 p0=17 p1=34 npath=2 ntrunc=0 rov=0 wov=0 acc=1 eol=0a hier_tbl=0 w0=0 phi0=50 txn=1
INNER_UPD rew=-3 phi0=50 t=3994945000
FRAME REW_OBS a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a
DECODE REW_OBS magic=a2 w0=-5 phi0=50 nupd=1 nbad=0 nstale=0 ndup=0 txn=1 gen=1 tag=57 hier_w0=-5 sgd_w0=-5 pub_w0=-5 tbl=0 cmt=1
ASTRA_09_R7_UART_QUERY_REW_PASS
$finish called at time : 11975335 ns
```

Raw `xelab.log`: `unisims_ver.MMCME2_BASE` / `BUFG` (not silicon MMCM).

### N2 — bag-local XDC (cite Digilent names; do not edit `constraints/arty_a7_100.xdc`)

```text
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]
set_property IOB TRUE [get_ports uart_txd_in]
set_property IOB TRUE [get_ports uart_rxd_out]
```

Raw `io.rpt` on N2 (Design `a7ng_astra_11_a09r7_uart_impl_wrap`, Total User IO = **15**, Date 01:52:52):

```text
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    | ... | FIXED
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    | ... | FIXED
```

UART present on a named UART wrap is **not** UART on a frozen production top
(identity UNKNOWN).

---

## Raw WNS/WHS quotes (authority files)

### N1. `ASTRA-09-R7-UART-QUERY-REW-01/xsim.log`

SHA256 `7cdffce10f07ff20cf2e1866f6275f6c5f4738f01aee0741bf4895d989b256d5`

No `timing_route.rpt`. No Design State=Routed. Do **not** invent a WNS.
Functional claim from this log only: **ans=4** then **w0=-5** (UART OBS `fb ff`).
This is **not** the A09R7 routed result.

### N2. `ASTRA-11-A09R7-UART-IMPL-ROUTE-01/timing_route.rpt`

SHA256 `0c45687b6f79e0fa6ade58d0754a76c160b718b100cc6c014fc0374048378d2b`

```text
Date         : Mon Sep  7 01:52:48 2026
Design       : a7ng_astra_11_a09r7_uart_impl_wrap
Device       : 7a100t-csg324
Design State : Routed
    WNS(ns)=0.336  TNS=0.000  WHS=0.104  THS=0.000
All user specified timing constraints are met.
clk50u period 20.000 (50.000 MHz)  intra WNS=0.336 WHS=0.104
uart_io_vclk → clk50u  WNS=19.270   hold BLANK
clk50u → uart_io_vclk  WNS=7.313    hold BLANK
check_timing: partial_input_delay=0; partial_output_delay=0
no_input_delay MEDIUM (3 false-path); no_output_delay HIGH (4 LED ports)
```

XDC delays + hold policy (PREREG, hashed before impl; **not** invented after WNS):

```text
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]
set_false_path -hold -from [get_ports uart_txd_in]
set_false_path -hold -to   [get_ports uart_rxd_out]
```

Raw `exceptions_route.rpt` Design State=Routed 01:52:53:

```text
Position  From                     To                   Setup  Hold
9         [get_ports uart_txd_in]  *                    -      false
10        *                        [get_ports uart_rxd_out]  -      false
```

Hold column **`false`**. Setup column **`-`** (setup **not** excepted).
DTS WHS=+0.104 is **intra clk50u**. UART I/O hold vs `uart_io_vclk` is **excepted**,
not physically MET. Auditor 20260907T0200Z: false-path-hold **HONEST** (not a
hide-WHS cheat); UART I/O hold excepted ≠ physically MET. Prior IOBFF bag
WHS=−4.915 remains on disk.

IOB FF packed: raw `util_route.rpt` `IOB Flip Flops = 2`, `ILOGIC = 1` (`IFF_Register=1`),
`OLOGIC = 1` (`OUTFF_Register=1`). Raw `UART_IOBFF.txt`:
`RX BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y171` / `TX BEL=OLOGICE2.OUTFF LOC=OLOGIC_X0Y161`.

Raw `clocks_route.rpt` Design State=Routed 01:52:52:

```text
sys_clk_pin   10.000   P           {CLK100MHZ}
uart_io_vclk  20.000   V           {}
clk50u        20.000   P,G,A       {u_mmcm/CLKOUT0}
```

Pipe clock is **real** (not virtual). Only I/O ref is virtual (declared).

### Pointer raw DTS (files not rewritten; hashes MATCH 12-R3 / 12-R2)

| # | Report | SHA256 | DTS |
|---|--------|--------|-----|
| U1 | ASTRA-09-R3-UART-XSIM-01/xsim.log | `e9b7f433b7bab28d9c92b359fdcfc075449f8b8dcf1e42c6bf2eb4a5f0110040` | XSim; MAGIC A2 PASS; no routed WNS |
| U2 | ASTRA-11-A09R3-UART-IMPL-ROUTE-01/timing_route.rpt | `c3225d49063fd26dae6fedf0b21821d08e311a554b67e667af8c8503e54b6165` | WNS=0.305 WHS=0.024 Routed 22:12:21 Design `a7ng_astra_11_a09r3_uart_impl_wrap` |
| U3 | ASTRA-11-A09R3-UART-IODELAY-01/timing_route.rpt | `2fea85580cd8e67ba1bc356bc08090151ad689874402a1ccd5cd949cb8b82eb6` | WNS=0.681 WHS=0.100 Routed 22:39:44 Design `a7ng_astra_11_a09r3_uart_iodelay_wrap` |
| U4 | ASTRA-11-A09R3-UART-IOBFF-01/timing_route.rpt | `95a7167792832340f72ac3aec9a9c4e658a35c3bf46d0cebfce8d622f4e6172c` | WNS=0.115 WHS=-4.915 Routed 23:06:09 Design `a7ng_astra_11_a09r3_uart_iobff_wrap` |
| U5 | ASTRA-11-A09R3-UART-IOBFF-HOLD-01/timing_route.rpt | `a7501ce47d03daa40812f73ccaae2008f29c88159b04fe32082cf06a8edf5f6b` | WNS=0.115 WHS=0.131 Routed 23:33:11 Design `a7ng_astra_11_a09r3_uart_iobff_hold_wrap` |
| P1 | ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt | `2a72f98a149a953f1ef0d386d679fbc68d60b92861a66a1ece1b01941ed48f72` | WNS=1.041 WHS=0.160 Routed 19:48:09 Design `a7ng_astra_11_a09_impl_wrap` |
| P2 | ASTRA-SOC-RTP-WRAP-ROUTE/timing.rpt | `71664fba4f5ec2d22d2d2a5d1223ac072b714330317bd8e2fb6c8a2e0a4a79ac` | WNS=5.733 WHS=0.029 Routed 02:11:52 Design `arty_a7_astra_rtp_soc_top` |
| P3 | ASTRA-11-SOC-WRAP/timing.rpt | `870c0f1237944841ba98ce96e76b9c55d2ded4ecef786b66242cfc92d9dad92c` | WNS=-4.765 TNS=-2392.529 Routed 22:59:22 Design `arty_a7_astra09_soc_top` |
| P4 | ASTRA-11-TIMING-FIX/timing.rpt | `32232b9c41c548b5e476eeb1987f442c026998527b34095a0b4152553ee275c5` | WNS=7.179 WHS=0.083 Routed 01:09:37 Design `arty_a7_astra09_soc_top` |

---

## Hashes (this bag Get-FileHash; files not rewritten)

| Object | SHA256 |
|--------|--------|
| N1 `xsim.log` | `7cdffce10f07ff20cf2e1866f6275f6c5f4738f01aee0741bf4895d989b256d5` |
| N1 wrap SV | `aeb7e1949cd38ab16aa9e2df749fb814d13fc0bf46af25ac00468e74fc2c608c` |
| N2 `timing_route.rpt` | `0c45687b6f79e0fa6ade58d0754a76c160b718b100cc6c014fc0374048378d2b` |
| N2 `io.rpt` | `08a1ba04cf0961b9f665c7e887bcf45446ff48314f323eecaf199b861cfe4eda` |
| N2 `util_route.rpt` | `ef25405759cd6b9bbae2ae09853c1fec45801b32787a02c2fb30624000299f7e` |
| N2 `exceptions_route.rpt` | `2849f83baa4d4252eab44a8e3c599cb06f8a7f7defe4e435b3afde9a5865d237` |
| N2 XDC | `720042357815a5e7cd80a8475eedef6dd3e7826d59d4e58e6412b1d7286c3e57` |
| N2 wrap SV | `d1f66a542f02c4932b821e5355c645e941b6beb057cb6bbb06dca56208644bde` |
| Frozen A09-R2 DUT | `15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23` |
| Auditor `20260907T0200Z/REPORT.md` | `7c0afb48ba0ba3f03b89f71f33873caf45acfb7e02d475c8f673f11712a79de5` |
| 12-R3 `CANDIDATES.md` (pointer; not rewritten) | `713ecb714bd482f02aff1e491fcdef2d13844acea8446ad79487291b5fbecf87` |
| 12-R2 `CANDIDATES.md` (pointer; not rewritten) | `ccfe51e2c6be0ee1cf312f9ea3f9f431c3b6896cfce608ed5b64fedd46619178` |

Full list: `SHA256.txt`.

---

## Not claimed

PRODUCTION_TOP. Winner. write_bitstream. BOARD_PASS. ASTRA-13. ACCEPT_BOARD.
Physical IOB hold MET (N2 excepts UART I/O hold vs `uart_io_vclk`; U4 −4.915 remains).
UART STA ladder as one envelope (separate bags remain separate). Master ASTRA-12
unique-bit / UART plan. Master ASTRA-11 FULLCHIP-COFIT. LM06 language.
Master F3 10pp/CI. Master ASTRA-06. Ranking a row as “the” top.
Mixing N2 +0.336 with U2 +0.305 / U3 +0.681 / U4/U5 +0.115 / P2 +5.733.
Promoting N2 WHS=+0.104 to erase U4 WHS=−4.915.
Promoting N1 XSim ans=4/w0=-5 as this routed result.
Silent freeze of `a7ng_astra_11_a09r7_uart_impl_wrap` as PRODUCTION_TOP.
