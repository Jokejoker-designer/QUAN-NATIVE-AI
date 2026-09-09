# CANDIDATES — ASTRA-12-R2-TOP-CANDIDATES-01

```text
GATE             = ASTRA-12-R2-TOP-CANDIDATES-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
CANDIDATE_COUNT  = 4
UNIQUE_MODULES   = 3
PROGRAM          = NO
write_bitstream  = not called
BIT              = NOT_BUILT (this bag)
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = BLOCKED
AUDITOR_PRIOR    = 20260906T1430Z ACCEPT_PARTIAL | REJECT_PROMOTION
BASE             = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
```

Parent does **not** pick a top. This bag **tables existing routed candidates**.
It does **not** write `PRODUCTION_TOP=<module>`. Rows are **not ranked**.
Do not treat max WNS, UART present, or bit-exists as a freeze.

Cited prior-bag files were **hashed in place**. Those files were **not rewritten**.
Their run scripts were **not rerun**. Frozen RTL was **not patched**. No `.bit`
was generated here.

---

## Table — routed ASTRA board-level tops (Design State = Routed)

Authority for WNS = each bag’s raw timing report **Design Timing Summary**,
not RESULTS.md.

| # | Top (module) | Bag | DUT under top | WNS ns (raw summary) | Clock | UART XDC | Bonded IOB / Total User IO | Bit in that bag |
|---|--------------|-----|---------------|---------------------:|-------|----------|---------------------------:|-----------------|
| 1 | `a7ng_astra_11_a09_impl_wrap` | ASTRA-11-A09-IMPL-ROUTE-01 | `u_a09` = `a7ng_astra_09_integ_path` | **+1.041** TNS=0 WHS=+0.160 | `clk50u` 20.000 ns (50 MHz); pin E3 `sys_clk_pin` 10.000 ns | **absent** (`clk50_impl.xdc`) | **13** | **NOT_BUILT** (DCP only) |
| 2 | `arty_a7_astra_rtp_soc_top` | ASTRA-SOC-RTP-WRAP-ROUTE | `a7ng_astra_rtp_pipe_r2` + `a7ng_axi_bram128` PLANT_R2_BASE=1 | **+5.733** TNS=0 WHS=+0.029 | `clk50u` 20.000 ns (intra WNS=+7.150); pin E3 10.000 ns | **D10 / A9** (`constraints/arty_a7_100.xdc`) | **15** | UNPROGRAMMED `8116fa77…` |
| 3 | `arty_a7_astra09_soc_top` | ASTRA-11-SOC-WRAP | `a7ng_astra09_pipe` | **−4.765** TNS=−2392.529 (587 fail) WHS=+0.046 | `sys_clk_pin` 10.000 ns (100 MHz); **constraints not met** | **D10 / A9** (`constraints/arty_a7_100.xdc`) | **15** | UNPROGRAMMED `c7442d16…` |
| 4 | `arty_a7_astra09_soc_top` | ASTRA-11-TIMING-FIX | `a7ng_astra09_pipe` (50 MHz MMCM retiming of same module name) | **+7.179** TNS=0 WHS=+0.083 | `clk50u` 20.000 ns (50 MHz); pin E3 10.000 ns | **D10 / A9** (`constraints/arty_a7_100.xdc`) | **15** | UNPROGRAMMED `a5c3f2c4…` |

Rows 3 and 4 share a **module name** and are **not** the same compile:

- Row 3 freeze-before-impl top SHA (copied from that bag `SHA256.txt`, not live tree): `f8cef9a011a2cbdcaa11c283d5b87a2a06754b344d5bc05f514d22e79f13e0de`
- Row 4 freeze-before-impl top SHA: `71f4ebe08e846bccda61d182351c8503cceb8ec3d5c24cf7fdd46b38cf014554`
- Live `rtl/board/arty_a7_astra09_soc_top.sv` SHA256 = `71f4ebe0…` (matches row 4 freeze, **not** row 3)

Do not add LUT/FF/BRAM/DSP across rows. Do not call any row the frozen production top.

Post-route occupancy (raw util, **not** identity):

| # | LUT | FF | BRAM tile | DSP | util rpt |
|---|----:|---:|----------:|----:|----------|
| 1 | 1305 | 1075 | 0 | 2 | `util_route.rpt` |
| 2 | 4244 | 3810 | 2 | 0 | `util.rpt` |
| 3 | 2956 | 1550 | 0 | 2 | `util.rpt` |
| 4 | 3102 | 1577 | 0 | 2 | `util.rpt` |

---

## UART pin names from each XDC

### Row 1 — ASTRA-11-A09-IMPL-ROUTE-01 `clk50_impl.xdc`

Comment in file: `# Do not edit that file. No UART. No DDR. Not BOARD_PASS.`

Ports constrained: `CLK100MHZ` E3, `sw[3:0]` A8/C11/C10/A10, `led[3:0]` H5/J5/T9/T10, `btn[3:0]` D9/C9/B9/B8.

**No `uart_*` ports. No PACKAGE_PIN D10. No PACKAGE_PIN A9 as UART.**

Wrap SV ports = `CLK100MHZ`, `sw[3:0]`, `btn[3:0]`, `led[3:0]` only.

Raw `io.rpt` (Design `a7ng_astra_11_a09_impl_wrap`, Total User IO = **13**):

```text
| A9         |             | ... | User IO     |             |
| D10        |             | ... | User IO     |             |
```

A9 and D10 are **unbonded** on this wrap.

### Rows 2–4 — `constraints/arty_a7_100.xdc` (read_xdc in those bags’ `run_impl.tcl`)

```text
## USB-UART Interface (Digilent names: uart_rxd_out = FPGA TX)
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]; #IO_L19N_T3_VREF_16 Sch=uart_rxd_out
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]; #IO_L14N_T2_SRCC_16 Sch=uart_txd_in
```

Raw `io.rpt` on rows 2, 3, and 4 (Total User IO = **15**):

```text
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    |
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    |
```

Shared crystal/LED/SW/BTN sites are **not** identity of tops. UART present on a SoC wrap is **not** UART on a frozen production top (identity UNKNOWN).

---

## Raw WNS quotes (authority files)

### 1. `ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt`

SHA256 `2a72f98a149a953f1ef0d386d679fbc68d60b92861a66a1ece1b01941ed48f72`

```text
Date         : Sun Sep  6 19:48:09 2026
Design       : a7ng_astra_11_a09_impl_wrap
Device       : 7a100t-csg324
Design State : Routed
    WNS(ns)=1.041  TNS=0.000  WHS=0.160  THS=0.000
All user specified timing constraints are met.
clk50u period 20.000 (50.000 MHz)  intra WNS=1.041 WHS=0.160
```

### 2. `ASTRA-SOC-RTP-WRAP-ROUTE/timing.rpt`

SHA256 `71664fba4f5ec2d22d2d2a5d1223ac072b714330317bd8e2fb6c8a2e0a4a79ac`

```text
Date         : Sun Sep  6 02:11:52 2026
Design       : arty_a7_astra_rtp_soc_top
Device       : 7a100t-csg324
Design State : Routed
    WNS(ns)=5.733  TNS=0.000  WHS=0.029  THS=0.000
All user specified timing constraints are met.
clk50u period 20.000 (50.000 MHz)  intra WNS=7.150 WHS=0.029
**async_default** clk50u→clk50u WNS=5.733
```

Summary WNS=+5.733 is the **async_default** group. Intra-clock `clk50u` is +7.150.
Do not cite +5.733 as A09 wrap, and do not cite A09 +1.041 as this top.

### 3. `ASTRA-11-SOC-WRAP/timing.rpt`

SHA256 `870c0f1237944841ba98ce96e76b9c55d2ded4ecef786b66242cfc92d9dad92c`

```text
Date         : Sat Sep  5 22:59:22 2026
Design       : arty_a7_astra09_soc_top
Device       : 7a100t-csg324
Design State : Routed
    WNS(ns)=-4.765  TNS=-2392.529  failing=587/4034  WHS=0.046
Timing constraints are not met.
sys_clk_pin period 10.000 (100.000 MHz)  intra WNS=-4.765
```

### 4. `ASTRA-11-TIMING-FIX/timing.rpt`

SHA256 `32232b9c41c548b5e476eeb1987f442c026998527b34095a0b4152553ee275c5`

```text
Date         : Sun Sep  6 01:09:37 2026
Design       : arty_a7_astra09_soc_top
Device       : 7a100t-csg324
Design State : Routed
    WNS(ns)=7.179  TNS=0.000  WHS=0.083  THS=0.000
All user specified timing constraints are met.
clk50u period 20.000 (50.000 MHz)  intra WNS=7.179 WHS=0.083
```

Dates match prior pack / auditor 1430Z comparison (not rewritten).

---

## Hashes (this bag Get-FileHash; files not rewritten)

| Object | SHA256 |
|--------|--------|
| A09 wrap `timing_route.rpt` | `2a72f98a149a953f1ef0d386d679fbc68d60b92861a66a1ece1b01941ed48f72` |
| A09 wrap `io.rpt` | `af08de5ff7b806391b23d26e4b2063f9e7882e53e099456b64a4db5fc0f2f1e2` |
| A09 wrap `clk50_impl.xdc` | `9daf143e240660b98cd0d7092cd23710cb46e26614f799127255089e0cb195f8` |
| A09 wrap SV | `399aa22a358af5a9593b581a0ac65666ff57a63c848c76eade6f3ce4bb2a5f42` |
| wrap-route `timing.rpt` | `71664fba4f5ec2d22d2d2a5d1223ac072b714330317bd8e2fb6c8a2e0a4a79ac` |
| wrap-route `io.rpt` | `b4cb6178db5e26e0300d83a191a850e7778bae29b54a23438625f5d0f02f2236` |
| wrap-route bit (UNPROGRAMMED) | `8116fa77dfd38253e04a03563f71e22ed628dccb30b77a8f03a315d022b0171b` |
| SOC-WRAP `timing.rpt` | `870c0f1237944841ba98ce96e76b9c55d2ded4ecef786b66242cfc92d9dad92c` |
| SOC-WRAP `io.rpt` | `18505a0ec132c318b2f87352d9a284740204b01e416628dd8799be57f88fd395` |
| SOC-WRAP bit (UNPROGRAMMED) | `c7442d16a685c91fdbb5e50f1b612b5a3a99dcf911587744887515e4155d1d99` |
| TIMING-FIX `timing.rpt` | `32232b9c41c548b5e476eeb1987f442c026998527b34095a0b4152553ee275c5` |
| TIMING-FIX `io.rpt` | `1f4c7a22858b87a4460a9e2b53d476c5de001c7f956e24fac5b830e7fb5be0c2` |
| TIMING-FIX bit (UNPROGRAMMED) | `a5c3f2c4245ac185ed5e0e957d80e7e73c90fedb84ca69f1bc924b35b030e84a` |
| `constraints/arty_a7_100.xdc` | `1c12e6f8943261c7089984a3725642043d027b813549433b8256843227b6a9c2` |
| Auditor `20260906T1430Z/REPORT.md` | `a72b65428e78764276b40b31eb2195ae757e4f0f63bbeccb3a196d831e0658ca` |
| Frozen A09 DUT `a7ng_astra_09_integ_path.sv` | `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` |
| `a7ng_astra09_pipe.sv` | `48c9e480cbf2f6820f61a379f95f948f942340fbf478f6fb036fa011212b488b` |
| `a7ng_astra_rtp_pipe_r2.sv` | `3d27091d64ff778229cbdd4e4f57510eefefc165dc2e09653990f97f5cd65cbf` |
| Live `arty_a7_astra_rtp_soc_top.sv` | `a1f7a063f95d9239739f321f31800037785f399f2178016426230770853905fa` |

Historical bits remain **UNPROGRAMMED** (`BITSTREAM.txt` STATUS=UNPROGRAMMED in those bags). This bag does **not** adopt them as the production bitstream.

---

## Out of this freeze table (not silent extras)

**Not routed (ASTRA SoC attempt):** `ASTRA-11-RTP-SOC` — `ckpt/synth.dcp` only; no `timing.rpt`; no route; not a candidate.

**OOC / synth-only (not implemented board tops):** ASTRA-10-RESOURCE-BOUND-01, ASTRA-10-OOC-RESOURCE, ASTRA-10B-OOC-ASTRA09-PIPE (`Design State : Synthesized` / Optimized).

**Other-lane routed reports in this clone** (NG-01/02/03, LM06-SOC/UA, E1-AB-COFIT, BRAM-WM/CONSOL, WF-GLOBAL-TOPK, INTEGRATE, GROK-ORCH OOC, TINYGPT, MIG-BOARD, HS02): **not** this ASTRA production-top table. Not adopted. Not hashed here as freeze evidence.

---

## Not claimed

PRODUCTION_TOP. Winner. write_bitstream. BOARD_PASS. ASTRA-13. ACCEPT_BOARD.
Master ASTRA-12 unique-bit / UART plan. Master ASTRA-11 FULLCHIP-COFIT.
LM06 language. Master F3 10pp/CI. Master ASTRA-06 DDR/NVM.
Programming any historical bit. Ranking a row as “the” top.
