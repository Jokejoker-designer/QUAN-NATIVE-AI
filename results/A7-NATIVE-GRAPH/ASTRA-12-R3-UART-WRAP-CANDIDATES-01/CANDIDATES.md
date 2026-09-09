# CANDIDATES — ASTRA-12-R3-UART-WRAP-CANDIDATES-01

```text
GATE             = ASTRA-12-R3-UART-WRAP-CANDIDATES-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
UART_WRAP_ROWS   = 5
R2_POINTER_ROWS  = 4
CANDIDATE_COUNT  = 9
PROGRAM          = NO
write_bitstream  = not called
BIT              = NOT_BUILT (this bag)
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = BLOCKED
AUDITOR_PRIOR    = 20260906T1900Z ACCEPT_PARTIAL | REJECT_PROMOTION
HOLD_BAG         = ASTRA-11-A09R3-UART-IOBFF-HOLD-01 PASS_NARROW
FALSE_PATH_HOLD  = HONEST (not cheat; DTS WHS envelope-tautological)
BASE             = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
```

Parent does **not** pick a top. This bag **extends** the candidate table with UART
wraps (XSim + routed). It does **not** write `PRODUCTION_TOP=<module>`. Rows are
**not ranked**. Do not treat max WNS, IOB FF packed, or hold-exception WHS≥0 as a freeze.

Cited prior-bag files were **hashed in place**. Those files were **not rewritten**.
Their run scripts were **not rerun**. Frozen RTL was **not patched**. No `.bit`
was generated here. ASTRA-12-R2-TOP-CANDIDATES-01 was **not edited**.

Authority for WNS/WHS = each bag’s raw `timing_route.rpt` **Design Timing Summary**
(Design State = Routed), **not** that bag’s RESULTS.md. XSim row has **no** routed WNS.

Do not mix bags: +0.305 is IMPL-ROUTE; +0.681 is IODELAY; +0.115/−4.915 is IOBFF;
+0.115/+0.131 is IOBFF-HOLD; leftover A09 +1.041, wrap-route +5.733, SOC-WRAP −4.765,
TIMING-FIX +7.179 stay on their own reports.

---

## Table A — UART wraps (this bag; raw reports)

| # | Top (module) | Bag | Kind | WNS ns (raw DTS) | WHS ns (raw DTS) | Clock | UART D10/A9 | IOB FF | Hold policy | Bit |
|---|--------------|-----|------|-----------------:|-----------------:|-------|-------------|--------|-------------|-----|
| U1 | `a7ng_astra_09_r3_uart_wrap` | ASTRA-09-R3-UART-XSIM-01 | **XSim only** | **N/A** (no routed report) | **N/A** | UNISIM MMCME2_BASE 100→50 (not silicon) | ports YES; PACKAGE_PIN **NO** (no XDC) | N/A | none | **NOT_BUILT** |
| U2 | `a7ng_astra_11_a09r3_uart_impl_wrap` | ASTRA-11-A09R3-UART-IMPL-ROUTE-01 | Routed | **+0.305** TNS=0 | **+0.024** | `clk50u` 20.000 ns; pin E3 10.000 ns | **YES** D10 OUTPUT / A9 INPUT FIXED | **NO** (ILOGIC=0 OLOGIC=0) | none (UART I/O unconstrained) | **NOT_BUILT** |
| U3 | `a7ng_astra_11_a09r3_uart_iodelay_wrap` | ASTRA-11-A09R3-UART-IODELAY-01 | Routed | **+0.681** TNS=0 | **+0.100** | `clk50u` 20.000 ns + virtual `uart_io_vclk` 20.000 ns | **YES** D10 OUTPUT / A9 INPUT FIXED | **NO** (ILOGIC=0 OLOGIC=0) | delays **max 2.000 / min 0.500** | **NOT_BUILT** |
| U4 | `a7ng_astra_11_a09r3_uart_iobff_wrap` | ASTRA-11-A09R3-UART-IOBFF-01 | Routed | **+0.115** TNS=0 | **−4.915** THS=−4.915 (1 fail) | `clk50u` 20.000 ns + virtual `uart_io_vclk` 20.000 ns | **YES** D10 OUTPUT / A9 INPUT FIXED | **YES** (IOB FF=2; ILOGIC=1 OLOGIC=1) | delays **max 2.000 / min 0.500** | **NOT_BUILT** |
| U5 | `a7ng_astra_11_a09r3_uart_iobff_hold_wrap` | ASTRA-11-A09R3-UART-IOBFF-HOLD-01 | Routed | **+0.115** TNS=0 | **+0.131** | `clk50u` 20.000 ns + virtual `uart_io_vclk` 20.000 ns | **YES** D10 OUTPUT / A9 INPUT FIXED | **YES** (IOB FF=2; ILOGIC=1 OLOGIC=1) | **FALSE_PATH_HOLD_ASYNC_UART**; setup max **2.000**; min **NOT_APPLIED** | **NOT_BUILT** |

DUT under every UART wrap: instance **`u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf`**.
Leftover `a7ng_astra_09_integ_path` is **not** this DUT.

Do not add LUT/FF/BRAM/DSP across rows. Occupancy is **not** identity.

| # | LUT | FF | BRAM tile | DSP | Bonded IOB | IOB FF | util rpt |
|---|----:|---:|----------:|----:|-----------:|-------:|----------|
| U1 | N/A | N/A | N/A | N/A | N/A | N/A | XSim; no util_route |
| U2 | 4804 | 3500 | 0 | 2 | 15 | 0 | `util_route.rpt` |
| U3 | 4803 | 3500 | 0 | 2 | 15 | 0 | `util_route.rpt` |
| U4 | 4802 | 3500 | 0 | 2 | 15 | 2 | `util_route.rpt` |
| U5 | 4802 | 3500 | 0 | 2 | 15 | 2 | `util_route.rpt` |

---

## Table B — pointer to ASTRA-12-R2-TOP-CANDIDATES-01 (files not rewritten)

Four routed ASTRA board-level tops remain as recorded in
`results/A7-NATIVE-GRAPH/ASTRA-12-R2-TOP-CANDIDATES-01/`. This bag **does not rewrite**
that directory. Timing reports were **re-hashed in place**; hashes **MATCH** 12-R2
`SHA256.txt`. WNS below is quoted from those **same raw reports opened this bag**,
not from 12-R2 RESULTS.md.

| # | Top (module) | Bag | WNS ns (raw DTS) | UART D10/A9 | Bit |
|---|--------------|-----|-----------------:|-------------|-----|
| P1 | `a7ng_astra_11_a09_impl_wrap` | ASTRA-11-A09-IMPL-ROUTE-01 | **+1.041** TNS=0 WHS=+0.160 | **NO** | NOT_BUILT |
| P2 | `arty_a7_astra_rtp_soc_top` | ASTRA-SOC-RTP-WRAP-ROUTE | **+5.733** TNS=0 WHS=+0.029 | **YES** D10/A9 | UNPROGRAMMED `8116fa77…` |
| P3 | `arty_a7_astra09_soc_top` | ASTRA-11-SOC-WRAP | **−4.765** TNS=−2392.529 | **YES** D10/A9 | UNPROGRAMMED `c7442d16…` |
| P4 | `arty_a7_astra09_soc_top` | ASTRA-11-TIMING-FIX | **+7.179** TNS=0 WHS=+0.083 | **YES** D10/A9 | UNPROGRAMMED `a5c3f2c4…` |

P3 and P4 share a module name and are **not** the same compile. See 12-R2 `CANDIDATES.md`.
Pointer SHA256 of that file (unchanged): `ccfe51e2c6be0ee1cf312f9ea3f9f431c3b6896cfce608ed5b64fedd46619178`.

---

## UART D10/A9 per UART-wrap row

### U1 — ASTRA-09-R3-UART-XSIM-01 (no XDC)

Wrap ports: `uart_txd_in`, `uart_rxd_out`. **No PACKAGE_PIN.** XSim behavioral UART
at 115200; MAGIC **A2**. Not a routed IOB.

Raw `xsim.log` (session Sun Sep 6 21:45:37–21:46:37 2026, PID 19596):

```text
FRAME OVF_UART a2 46 00 00 00 00 00 00 00 00 00 00 04 00 00 0a
FRAME SMOKE_UART a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
ASTRA_09_R3_UART_XSIM_PASS
$finish called at time : 9631755 ns
```

### U2–U5 — bag-local XDC (cite Digilent names; do not edit `constraints/arty_a7_100.xdc`)

All four routed UART wraps:

```text
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]
```

Raw `io.rpt` on U2, U3, U4, U5 (Total User IO = **15**):

```text
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    | ... | FIXED
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    | ... | FIXED
```

UART present on a named UART wrap is **not** UART on a frozen production top
(identity UNKNOWN).

---

## Raw WNS/WHS quotes (authority files)

### U1. `ASTRA-09-R3-UART-XSIM-01/xsim.log`

SHA256 `e9b7f433b7bab28d9c92b359fdcfc075449f8b8dcf1e42c6bf2eb4a5f0110040`

No `timing_route.rpt`. No Design State=Routed. Do **not** invent a WNS.

### U2. `ASTRA-11-A09R3-UART-IMPL-ROUTE-01/timing_route.rpt`

SHA256 `c3225d49063fd26dae6fedf0b21821d08e311a554b67e667af8c8503e54b6165`

```text
Date         : Sun Sep  6 22:12:21 2026
Design       : a7ng_astra_11_a09r3_uart_impl_wrap
Device       : 7a100t-csg324
Design State : Routed
    WNS(ns)=0.305  TNS=0.000  WHS=0.024  THS=0.000
All user specified timing constraints are met.
clk50u period 20.000 (50.000 MHz)  intra WNS=0.305 WHS=0.024
check_timing: no_input_delay HIGH (1 input); no_output_delay HIGH (5 ports)
Inter Clock Table: empty
```

UART I/O delay **not applied**. WNS=+0.305 is **not** I/O-constrained UART STA.

### U3. `ASTRA-11-A09R3-UART-IODELAY-01/timing_route.rpt`

SHA256 `2fea85580cd8e67ba1bc356bc08090151ad689874402a1ccd5cd949cb8b82eb6`

```text
Date         : Sun Sep  6 22:39:44 2026
Design       : a7ng_astra_11_a09r3_uart_iodelay_wrap
Device       : 7a100t-csg324
Design State : Routed
    WNS(ns)=0.681  TNS=0.000  WHS=0.100  THS=0.000
All user specified timing constraints are met.
clk50u intra WNS=0.681 WHS=0.100
uart_io_vclk → clk50u  WNS=15.179 WHS=1.151
clk50u → uart_io_vclk  WNS=4.423  WHS=4.517
```

XDC delays (PREREG, not invented after WNS):

```text
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]
```

### U4. `ASTRA-11-A09R3-UART-IOBFF-01/timing_route.rpt`

SHA256 `95a7167792832340f72ac3aec9a9c4e658a35c3bf46d0cebfce8d622f4e6172c`

```text
Date         : Sun Sep  6 23:06:09 2026
Design       : a7ng_astra_11_a09r3_uart_iobff_wrap
Device       : 7a100t-csg324
Design State : Routed
    WNS(ns)=0.115  TNS=0.000  WHS=-4.915  THS=-4.915  THS failing=1
Timing constraints are not met.
clk50u intra WNS=0.115 WHS=0.131   (intra hold MET)
uart_io_vclk → clk50u  WNS=19.270 WHS=-4.915  (this is DTS WHS)
clk50u → uart_io_vclk  WNS=7.313  WHS=3.662
```

IOB FF from raw `util_route.rpt`: `IOB Flip Flops = 2`, `ILOGIC = 1`, `OLOGIC = 1`.
XDC same 2.000/0.500 min/max as U3 plus `set_property IOB TRUE` on UART pads.
**Do not overwrite this −4.915 bag.** It is the physical IBUF→IFF hold evidence
under min 0.500.

### U5. `ASTRA-11-A09R3-UART-IOBFF-HOLD-01/timing_route.rpt`

SHA256 `a7501ce47d03daa40812f73ccaae2008f29c88159b04fe32082cf06a8edf5f6b`

```text
Date         : Sun Sep  6 23:33:11 2026
Design       : a7ng_astra_11_a09r3_uart_iobff_hold_wrap
Device       : 7a100t-csg324
Design State : Routed
    WNS(ns)=0.115  TNS=0.000  WHS=0.131  THS=0.000
All user specified timing constraints are met.
clk50u intra WNS=0.115 WHS=0.131
uart_io_vclk → clk50u  WNS=19.270   hold BLANK
clk50u → uart_io_vclk  WNS=7.313    hold BLANK
check_timing: partial_input_delay HIGH (1); partial_output_delay HIGH (1)
```

XDC hold policy (PREREG `FALSE_PATH_HOLD_ASYNC_UART`; **no** `-min 0.500`):

```text
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_false_path -hold -from [get_ports uart_txd_in]
set_false_path -hold -to   [get_ports uart_rxd_out]
```

Raw `exceptions_route.rpt` Design State=Routed 23:33:16:

```text
Position  From                     To                   Setup  Hold
7         [get_ports uart_txd_in]  *                    -      false
8         *                        [get_ports uart_rxd_out]  -      false
9–14      uart_io_vclk ↔ clk50u                         -      false
```

Hold column **`false`**. Setup column **`-`** (setup **not** excepted).
DTS WHS=+0.131 is **intra clk50u**. UART I/O hold vs `uart_io_vclk` is **excepted**,
not physically MET. Auditor 20260906T1900Z: false-path-hold **HONEST** (not a
min-0.500 hide-WHS cheat); WHS≥0 is envelope-tautological.

IOB FF still packed: raw `util_route.rpt` `IOB Flip Flops = 2`, `ILOGIC = 1`, `OLOGIC = 1`.

### Pointer raw DTS (files not rewritten; hashes MATCH 12-R2)

| # | Report | SHA256 | DTS |
|---|--------|--------|-----|
| P1 | ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt | `2a72f98a149a953f1ef0d386d679fbc68d60b92861a66a1ece1b01941ed48f72` | WNS=1.041 WHS=0.160 Routed 19:48:09 Design `a7ng_astra_11_a09_impl_wrap` |
| P2 | ASTRA-SOC-RTP-WRAP-ROUTE/timing.rpt | `71664fba4f5ec2d22d2d2a5d1223ac072b714330317bd8e2fb6c8a2e0a4a79ac` | WNS=5.733 WHS=0.029 Routed 02:11:52 Design `arty_a7_astra_rtp_soc_top` |
| P3 | ASTRA-11-SOC-WRAP/timing.rpt | `870c0f1237944841ba98ce96e76b9c55d2ded4ecef786b66242cfc92d9dad92c` | WNS=-4.765 TNS=-2392.529 Routed 22:59:22 Design `arty_a7_astra09_soc_top` |
| P4 | ASTRA-11-TIMING-FIX/timing.rpt | `32232b9c41c548b5e476eeb1987f442c026998527b34095a0b4152553ee275c5` | WNS=7.179 WHS=0.083 Routed 01:09:37 Design `arty_a7_astra09_soc_top` |

---

## Hashes (this bag Get-FileHash; files not rewritten)

| Object | SHA256 |
|--------|--------|
| U1 `xsim.log` | `e9b7f433b7bab28d9c92b359fdcfc075449f8b8dcf1e42c6bf2eb4a5f0110040` |
| U1 wrap SV | `20cdeb8ef7a469d036ae4d780a96134cad5928539c349aa583060b6ca3e88b41` |
| U2 `timing_route.rpt` | `c3225d49063fd26dae6fedf0b21821d08e311a554b67e667af8c8503e54b6165` |
| U2 `io.rpt` | `c05755552a319e52b58efe8e9f345939e4d300e179df1604082bb115a30f5a30` |
| U2 XDC | `506a3e12bfd75d663fffbbc075c8504b8dced6c83f1d2b63b050fb1fd216856f` |
| U3 `timing_route.rpt` | `2fea85580cd8e67ba1bc356bc08090151ad689874402a1ccd5cd949cb8b82eb6` |
| U3 `io.rpt` | `8992df8ab323994fd720a737893666574b8cc4b9bff1e9cd7dde05f506c869a4` |
| U3 XDC | `7023fd8abdd9aff9992adea80846b1908c22b230a3838144c449848532531a00` |
| U4 `timing_route.rpt` | `95a7167792832340f72ac3aec9a9c4e658a35c3bf46d0cebfce8d622f4e6172c` |
| U4 `io.rpt` | `5af4b1783426df6969b5e84cc81f8d95bc5b043744551b692489b59643f56e79` |
| U4 XDC | `dad1dbf2ba79ff12380f1dc22d8c679ab38d922487423266aaa5f2b8d3ddeb1f` |
| U5 `timing_route.rpt` | `a7501ce47d03daa40812f73ccaae2008f29c88159b04fe32082cf06a8edf5f6b` |
| U5 `io.rpt` | `4210d843403758c5c9736f5facd1931c7381ee26672414b67a4ad0e9110a408c` |
| U5 XDC | `046a3cb26c4a09a54dbea901efce340ab53fc802d95a9aab59ff98df590376f9` |
| U5 `exceptions_route.rpt` | `f0f68ab8066ecf098e69d4d3eeba5f9aac0701ffd49142580134012b21ab37a3` |
| Frozen A09-R2 DUT | `15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23` |
| Auditor `20260906T1900Z/REPORT.md` | `6d93fffef28e5359931f28bb4a5c6c36c8285d86af73832eee75327fbcdb539a` |
| 12-R2 `CANDIDATES.md` (pointer; not rewritten) | `ccfe51e2c6be0ee1cf312f9ea3f9f431c3b6896cfce608ed5b64fedd46619178` |

Full list: `SHA256.txt`.

---

## Not claimed

PRODUCTION_TOP. Winner. write_bitstream. BOARD_PASS. ASTRA-13. ACCEPT_BOARD.
Physical IOB hold MET (U5 excepts the U4 −4.915 path). UART STA ladder as one envelope
(separate bags remain separate). Master ASTRA-12 unique-bit / UART plan.
Master ASTRA-11 FULLCHIP-COFIT. LM06 language. Master F3 10pp/CI. Master ASTRA-06.
Ranking a row as “the” top. Mixing U2 +0.305 with U3 +0.681 with U4/U5 +0.115.
Promoting U5 WHS=+0.131 to erase U4 WHS=−4.915.
