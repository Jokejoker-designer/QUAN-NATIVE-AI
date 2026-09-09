# BRIEF — ASTRA-12-R5-FREEZE-BRIEF-01

```text
GATE             = ASTRA-12-R5-FREEZE-BRIEF-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
COLUMNS          = 2
COLUMN_A         = arty_a7_astra_rtp_soc_top
COLUMN_B         = a7ng_astra_11_a09r7_uart_impl_wrap
PROGRAM          = NO
write_bitstream  = not called
BIT              = NOT_BUILT (this bag)
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = BLOCKED
ACCEPT_BOARD     = MISSING
AUDITOR_PRIOR    = 20260907T0230Z ACCEPT_PARTIAL | REJECT_PROMOTION
TABLE_PRIOR      = ASTRA-12-R4-R7-UART-CANDIDATES-01 PASS_NARROW unique 11
BASE             = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
```

Parent residual 8: freeze a production top **or keep UNKNOWN**. Parent does **not**
pick. This bag is a **decision brief** of two strongest existing routed UART
candidates. It does **not** write `PRODUCTION_TOP=<module>`. Columns are **not
ranked**. Do not treat max WNS, UART present, IOB FF packed, hold-exception
WHS≥0, BRAM present, or a historical UNPROGRAMMED `.bit` as a freeze.

Cited prior-bag files were **hashed in place**. Those files were **not rewritten**.
Their run scripts were **not rerun**. Frozen RTL was **not patched**. No `.bit`
was generated here. R7 XSim `ans=4` / `w0=-5` is a **different bag**
(`ASTRA-09-R7-UART-QUERY-REW-01`) and is **not** column B’s routed result.

Authority for WNS/WHS = each bag’s raw timing report **Design Timing Summary**,
not RESULTS.md of those bags, not 12-R2/R3/R4 pack prose.

---

## Two columns (only)

| | **A** historical SoC wrap-route | **B** A09R7 UART impl-route |
|---|---|---|
| Top (module) | `arty_a7_astra_rtp_soc_top` | `a7ng_astra_11_a09r7_uart_impl_wrap` |
| Bag | `ASTRA-SOC-RTP-WRAP-ROUTE` | `ASTRA-11-A09R7-UART-IMPL-ROUTE-01` |
| Design / date | `arty_a7_astra_rtp_soc_top` Routed **Sun Sep 6 02:11:52 2026** | `a7ng_astra_11_a09r7_uart_impl_wrap` Routed **Mon Sep 7 01:52:48 2026** |
| Raw DTS WNS / TNS / WHS | **+5.733 / 0.000 / +0.029** (summary WNS is `**async_default**` clk50u→clk50u; intra `clk50u` WNS=+7.150 WHS=+0.029) | **+0.336 / 0.000 / +0.104** (intra `clk50u` same +0.336 / +0.104; Inter Clock hold columns **blank**) |
| Constraints | All user specified timing constraints are met | All user specified timing constraints are met |
| Pipe clock | `clk50u` 20.000 ns (50.000 MHz) `P,G,A {u_mmcm/CLKOUT0}` | `clk50u` 20.000 ns (50.000 MHz) `P,G,A {u_mmcm/CLKOUT0}` |
| UART I/O clock | **none** (no `uart_io_vclk`) | `uart_io_vclk` 20.000 ns **V** `{}` |
| UART D10 / A9 | **YES** A9 INPUT `uart_txd_in` FIXED / D10 OUTPUT `uart_rxd_out` FIXED; Total User IO **15** | **YES** A9 INPUT `uart_txd_in` FIXED / D10 OUTPUT `uart_rxd_out` FIXED; Total User IO **15** |
| IOB FF packed | **NO** ILOGIC=0 OLOGIC=0 (no IOB Flip Flops row) | **YES** IOB Flip Flops **2**; ILOGIC=1 `IFF_Register=1`; OLOGIC=1 `OUTFF_Register=1`; `UART_IOBFF=YES` RX `ILOGICE2.IFF` `ILOGIC_X0Y171` / TX `OLOGICE2.OUTFF` `OLOGIC_X0Y161` |
| Occupancy (raw util, not identity) | LUT **4244** FF **3810** BRAM tile **2** (RAMB36E1 only=2) DSP **0** Bonded IOB **15** | LUT **4945** FF **3615** BRAM tile **0** DSP **2** Bonded IOB **15** |
| Inner DUT | `a7ng_astra_rtp_pipe_r2` + `a7ng_axi_bram128` `.PLANT_R2_BASE(1'b1)` | frozen `a7ng_astra_09_r2_cand_ovf` as `u_a09r2` (query-learn SGD) |
| XDC | `constraints/arty_a7_100.xdc` (pin loc only) | bag-local `clk50_uart_impl.xdc` (D10/A9 + IOB TRUE + delays 2.000/0.500 + `FALSE_PATH_HOLD`) |
| This-bag bit | **NOT_BUILT** | **NOT_BUILT** |
| Historical bit in that bag | UNPROGRAMMED `8116fa77…` (`BITSTREAM.txt` STATUS=UNPROGRAMMED) | **none** (`write_bitstream` forbidden in that tcl) |

Do **not** add LUT/FF/BRAM/DSP across columns. Do **not** cite +5.733 as A09R7,
and do **not** cite +0.336 as the SoC wrap. Do **not** promote R7 XSim
`ans=4` / `w0=-5` as column B.

---

## Column A — raw quotes (authority files)

Bag: `results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-WRAP-ROUTE/`

### A.1 `timing.rpt` SHA256 `71664fba4f5ec2d22d2d2a5d1223ac072b714330317bd8e2fb6c8a2e0a4a79ac`

MATCH 12-R2 / 12-R3 / 12-R4 freeze lists (re-hashed this bag).

```text
Date         : Sun Sep  6 02:11:52 2026
Design       : arty_a7_astra_rtp_soc_top
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary numeric row:

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints
      5.733        0.000                      0                10150        0.029        0.000                      0                10150        3.000        0.000                       0                  3819
All user specified timing constraints are met.
```

Clock Summary: `sys_clk_pin` 10.000 ns (100.000 MHz); `clk50u` 20.000 ns (50.000 MHz).

Intra-clock `clk50u`: WNS=7.150 WHS=0.029.

Other Path Groups:

```text
**async_default**  clk50u             clk50u                   5.733        0.000                      0                 2592        0.705        0.000                      0                 2592
```

Summary WNS=+5.733 is the **async_default** group. Intra-clock `clk50u` is +7.150.
Do not cite +5.733 as A09R7 wrap, and do not cite A09R7 +0.336 as this top.

### A.2 `clocks.rpt` SHA256 `14e5da83795d399cd4c4f21d8f37e110dd41c3f5cc1d7536c090ce15fb4456f1`

```text
Date         : Sun Sep  6 02:11:54 2026
Design       : arty_a7_astra_rtp_soc_top
Design State : Routed
sys_clk_pin  10.000      {0.000 5.000}   P           {CLK100MHZ}
clk50u       20.000      {0.000 10.000}  P,G,A       {u_mmcm/CLKOUT0}
clkfb        10.000      {0.000 5.000}   P,G,A       {u_mmcm/CLKFBOUT}
```

No `uart_io_vclk`. Pipe clock is **real** MMCM+BUFG.

### A.3 `io.rpt` SHA256 `b4cb6178db5e26e0300d83a191a850e7778bae29b54a23438625f5d0f02f2236`

```text
Date                      : Sun Sep  6 02:11:54 2026
Design                    : arty_a7_astra_rtp_soc_top
Total User IO             : 15
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    | ... | FIXED
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    | ... | FIXED
```

Pins **not swapped**. Digilent names: `uart_rxd_out` = FPGA TX on D10; `uart_txd_in` = FPGA RX on A9.

### A.4 `util.rpt` SHA256 `bcf21d259c096fbdc1722f845033fbb4fd269f386c408d7c3e99fedddf604ec8`

```text
Slice LUTs              4244
Slice Registers         3810
Block RAM Tile             2
  RAMB36E1 only            2
DSPs                       0
Bonded IOB                15
ILOGIC                     0
OLOGIC                     0
```

No `IOB Flip Flops` row. IOB FF **not packed**.

### A.5 UART XDC — `constraints/arty_a7_100.xdc` SHA256 `1c12e6f8943261c7089984a3725642043d027b813549433b8256843227b6a9c2`

```text
## USB-UART Interface (Digilent names: uart_rxd_out = FPGA TX)
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]; #IO_L19N_T3_VREF_16 Sch=uart_rxd_out
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]; #IO_L14N_T2_SRCC_16 Sch=uart_txd_in
```

**No** `set_property IOB TRUE` on UART. **No** `set_input_delay` / `set_output_delay` on UART.
**No** `set_false_path -hold` on UART. Pin location only.

### A.6 Fixture plant — live wrap SV SHA256 `a1f7a063f95d9239739f321f31800037785f399f2178016426230770853905fa`

```text
// On-chip AXI BRAM with RTP-R2 BASE 17/34 plant. No MIG. freeze unused (no SGD).
a7ng_axi_bram128 #(
  .DEPTH_WORDS(256), .INDEX_BASE(INDEX_BASE), .PLANT_R2_BASE(1'b1)
```

Pipe SHA256 `3d27091d64ff778229cbdd4e4f57510eefefc165dc2e09653990f97f5cd65cbf` (`a7ng_astra_rtp_pipe_r2.sv`).
BRAM module SHA256 `6e25482890d69df9b7a7d5b6bddb90f7d9d1756bf5b01c4d13c057f296242cfc`.
Comment: **freeze unused (no SGD)**. DSP=0 MATCH util.

### A.7 Historical bit (UNPROGRAMMED; not adopted)

`SHA256_BIT.txt` / live Get-FileHash:

```text
8116fa77dfd38253e04a03563f71e22ed628dccb30b77a8f03a315d022b0171b  arty_a7_astra_rtp_soc_top.bit
STATUS=UNPROGRAMMED
PROGRAM=NO
```

`BITSTREAM.txt`: `STATUS=UNPROGRAMMED` `PROGRAM=NO` `COM12=UNTOUCHED` `JTAG=210319BE776EA UNTOUCHED`.
That bag’s `run_impl.tcl` historically called `write_bitstream`. **This bag does not.**
The bit is **not** the unique production bitstream. Not programmed.

---

## Column B — raw quotes (authority files)

Bag: `results/A7-NATIVE-GRAPH/ASTRA-11-A09R7-UART-IMPL-ROUTE-01/`

### B.1 `timing_route.rpt` SHA256 `0c45687b6f79e0fa6ade58d0754a76c160b718b100cc6c014fc0374048378d2b`

MATCH 12-R4 freeze list (re-hashed this bag). First-recorded there; content MATCH auditor 20260907T0200Z / T0230Z.

```text
Date         : Mon Sep  7 01:52:48 2026
Design       : a7ng_astra_11_a09r7_uart_impl_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary numeric row:

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints
      0.336        0.000                      0                 8940        0.104        0.000                      0                 8938        3.000        0.000                       0                  3622
All user specified timing constraints are met.
```

Clock Summary: `sys_clk_pin` 10.000 ns; `clk50u` 20.000 ns (50.000 MHz); `uart_io_vclk` 20.000 ns.

Intra-clock `clk50u`: WNS=0.336 WHS=0.104.

Inter-clock hold columns **blank**:

```text
uart_io_vclk  clk50u             19.270        0.000                      0                    1
clk50u        uart_io_vclk        7.313        0.000                      0                    1
```

DTS WHS=+0.104 is **intra clk50u**, not UART I/O hold vs `uart_io_vclk`.

### B.2 `clocks_route.rpt` SHA256 `443a61026e964080c83076c738cca86a6e2cb67d65427a7f72a75a807029adb3`

```text
Date         : Mon Sep  7 01:52:52 2026
Design       : a7ng_astra_11_a09r7_uart_impl_wrap
Design State : Routed
sys_clk_pin   10.000      {0.000 5.000}   P           {CLK100MHZ}
uart_io_vclk  20.000      {0.000 10.000}  V           {}
clk50u        20.000      {0.000 10.000}  P,G,A       {u_mmcm/CLKOUT0}
clkfb         10.000      {0.000 5.000}   P,G,A       {u_mmcm/CLKFBOUT}
```

Pipe clock **real**. UART I/O clock **virtual**.

### B.3 `io.rpt` SHA256 `08a1ba04cf0961b9f665c7e887bcf45446ff48314f323eecaf199b861cfe4eda`

```text
Date                      : Mon Sep  7 01:52:52 2026
Design                    : a7ng_astra_11_a09r7_uart_impl_wrap
Total User IO             : 15
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    | ... | FIXED
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    | ... | FIXED
```

Pins **not swapped**.

### B.4 `util_route.rpt` SHA256 `ef25405759cd6b9bbae2ae09853c1fec45801b32787a02c2fb30624000299f7e`

```text
Slice LUTs              4945
Slice Registers         3615
Block RAM Tile             0
DSPs                       2
Bonded IOB                15
  IOB Flip Flops           2
ILOGIC                     1
  IFF_Register             1
OLOGIC                     1
  OUTFF_Register           1
```

DSP=2 is frozen SGD on A09-R2, not a7-fpga-gate eam03e DSP=0. Occupancy is **this wrap**, not additive with column A 4244/3810 BRAM=2.

### B.5 `UART_IOBFF.txt` SHA256 `42acaa232498201fe3c9feeb107fb6a5a3362bb99a98fe2af7860f8b7e918dde`

```text
UART_RX_IOB_BEL=ILOGICE2.IFF
UART_RX_IOB_LOC=ILOGIC_X0Y171
UART_TX_IOB_BEL=OLOGICE2.OUTFF
UART_TX_IOB_LOC=OLOGIC_X0Y161
UART_IOBFF=YES
PROGRAM=NO
```

### B.6 XDC `clk50_uart_impl.xdc` SHA256 `720042357815a5e7cd80a8475eedef6dd3e7826d59d4e58e6412b1d7286c3e57`

MATCH A09R7 PRE/POST. HOLD_POLICY frozen in PREREG **before** impl:

```text
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]
set_false_path -hold -from [get_ports uart_txd_in]
set_false_path -hold -to   [get_ports uart_rxd_out]
set_property IOB TRUE [get_ports uart_txd_in]
set_property IOB TRUE [get_ports uart_rxd_out]
```

### B.7 `exceptions_route.rpt` SHA256 `2849f83baa4d4252eab44a8e3c599cb06f8a7f7defe4e435b3afde9a5865d237`

```text
Date         : Mon Sep  7 01:52:53 2026
Design       : a7ng_astra_11_a09r7_uart_impl_wrap
Design State : Routed
Position  From                     To                   Setup  Hold
9         [get_ports uart_txd_in]  *                    -      false
10        *                        [get_ports uart_rxd_out]  -      false
```

Hold column **`false`**. Setup column **`-`** (setup **not** excepted).
HOLD_POLICY **FALSE_PATH_HOLD_ASYNC_UART** is **HONEST** (UART I/O hold excepted, not physically MET).
Do **not** promote WHS=+0.104 as physical IOB hold MET. Keep U4 WHS=−4.915 on disk (12-R3/R4 pointer; not this bag).

### B.8 Fixture plant + inner DUT

Wrap SV SHA256 `d1f66a542f02c4932b821e5355c645e941b6beb057cb6bbb06dca56208644bde`:

```text
// Instantiates frozen a7ng_astra_09_r2_cand_ovf (no copy-paste graph).
// R7 wrap a7ng_astra_09_r7_uart_query_rew_wrap is synthesizable UART+A09-R2; KEEP, not this top.
// UART pins uart_rxd_out=D10 uart_txd_in=A9. Not PRODUCTION_TOP.
a7ng_astra_09_r2_cand_ovf u_a09r2 (
```

Plant SV SHA256 `2f5db739999e9dd21d76c0ebd54136bed4dd08f42de8d0e45f7c0ce8fc79ebda`:

```text
// Bag-local behavioral AXI plant. Not silicon BRAM. Not a7ng_axi_bram128 edit.
module a7ng_astra_11_a09r7_uart_impl_plant (
```

Frozen A09-R2 DUT SHA256 `15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23`.

That bag’s `run_impl.tcl`: `PROGRAM=NO. BIT=NO. write_bitstream forbidden.` ACK.json `"bitstream": "NOT_BUILT"`. No `.bit` in that bag.

### B.9 R7 XSim is a **different** bag

`ASTRA-09-R7-UART-QUERY-REW-01` XSim marker `ASTRA_09_R7_UART_QUERY_REW_PASS` (`ans=4` then `w0=-5`) is **not** this routed wrap. Handoff: XSim ans=4/w0=-5 is a **different** bag. Column B is impl-route of a **named** wrap instantiating frozen A09-R2. Do not mix.

---

## Gaps per column (required)

| Gap | **A** `arty_a7_astra_rtp_soc_top` | **B** `a7ng_astra_11_a09r7_uart_impl_wrap` |
|-----|----------------------------------|-------------------------------------------|
| **unique bit** | **MISSING as unique production bit.** Historical UNPROGRAMMED `.bit` `8116fa77…` exists in wrap-route bag; STATUS=UNPROGRAMMED; sibling bits exist (`c7442d16…` SOC-WRAP 100 MHz fail; `a5c3f2c4…` TIMING-FIX). Master ASTRA-12 unique-bit / UART plan remains OPEN. This bag does **not** adopt `8116fa77…`. | **MISSING.** BIT=NOT_BUILT. No `.bit` in A09R7 bag. That tcl **forbids** `write_bitstream`. DCP only. |
| **ACCEPT_BOARD** | **MISSING.** Auditor 20260907T0230Z: ACCEPT_BOARD missing; BOARD blocked YES. No auditor ACCEPT_BOARD of this timed bit. | **MISSING.** Same. T0200Z / T0230Z ACCEPT_PARTIAL on the **wrap bag / table**, not ACCEPT_BOARD. |
| **LM06** | **MISSING.** RTP-R2 pipe; wrap comment `freeze unused (no SGD)`; DSP=0. Not LM06 language / vocab checkpoint. | **MISSING.** A09-R2 query-learn SGD (DSP=2). Not LM06 language. |
| **fixture plant** | **PRESENT (silicon BRAM plant).** `a7ng_axi_bram128` `.PLANT_R2_BASE(1'b1)`; util BRAM tile=2 / RAMB36E1=2. On-chip AXI BRAM, **no MIG**. Plant is RTP-R2 BASE 17/34, not A09-R2 query-learn smoke/ovf. | **PRESENT (behavioral, not BRAM).** Bag-local `a7ng_astra_11_a09r7_uart_impl_plant` — “Not silicon BRAM. Not a7ng_axi_bram128 edit.” Util BRAM tile=0. |
| **FALSE_PATH_HOLD** | **ABSENT on UART.** `arty_a7_100.xdc` pin loc only; no I/O delay envelope; no `set_false_path -hold` on UART; ILOGIC=0. DTS WHS=+0.029 is intra `clk50u` **without** UART I/O STA. Not an honest hold waiver because no UART hold was checked. | **PRESENT, HONEST.** `FALSE_PATH_HOLD_ASYNC_UART` frozen before impl. exceptions Hold=`false` Setup=`-`. WHS=+0.104 is intra `clk50u`, **not** physical IOB hold MET. U4 WHS=−4.915 remains on disk. |
| **100 MHz fail sibling** | **EXISTS, distinct bag.** `arty_a7_astra09_soc_top` in `ASTRA-11-SOC-WRAP` `timing.rpt` SHA256 `870c0f1237944841ba98ce96e76b9c55d2ded4ecef786b66242cfc92d9dad92c`: Design State Routed Sat Sep 5 22:59:22 2026; WNS=**−4.765** TNS=**−2392.529** failing=587; `sys_clk_pin` 10.000 ns (100.000 MHz); **Timing constraints are not met.** Same UART D10/A9 family, **different module**, **no 50 MHz MMCM**. Do **not** collapse A +5.733 @ 50 MHz with this −4.765 @ 100 MHz. | **NOT this wrap.** B is 50 MHz `clk50u`. The 100 MHz fail sibling is still `ASTRA-11-SOC-WRAP` `arty_a7_astra09_soc_top` WNS=−4.765. Do **not** collapse B +0.336 with that −4.765. |

100 MHz sibling raw DTS (gap evidence; **not** a third column):

```text
Date         : Sat Sep  5 22:59:22 2026
Design       : arty_a7_astra09_soc_top
Design State : Routed
     -4.765    -2392.529                    587                 4034        0.046
Timing constraints are not met.
sys_clk_pin  {0.000 5.000}      10.000          100.000
```

---

## Production-top identity

**UNKNOWN.** Not frozen. Not silently chosen. Parent does not pick. This bag does
not pick. Column A WNS=+5.733 UART D10/A9 BRAM=2 is **not** that top. Column B
WNS=+0.336 WHS=+0.104 UART IOB YES IOB FF YES is **not** that top. Historical
UNPROGRAMMED bit `8116fa77…` is **not** that top. R7 XSim ans=4/w0=-5 is **not**
that top.

---

## Not claimed

PRODUCTION_TOP. Winner. Ranking A vs B. write_bitstream. BOARD_PASS. ASTRA-13.
ACCEPT_BOARD. Master ASTRA-12 unique-bit / UART plan. Master ASTRA-11 FULLCHIP-COFIT.
LM06 language. Master F3 10pp/CI. Master ASTRA-06 DDR/NVM. Physical IOB hold MET.
Programming any historical bit. Mixing N1 XSim with column B. Collapsing +5.733
with +0.336. Collapsing either column with 100 MHz WNS=−4.765. Adding occupancy
across columns.
