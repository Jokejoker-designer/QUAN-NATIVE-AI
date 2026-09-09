# ASTRA auditor REPORT — 20260907T0500Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA11_A09R7_BTN_IO_INDEPENDENT_AUDIT; astra11_btn=IMPLEMENTER_CLAIM_FAIL_WHS_M2068_PENDING_AUDITOR; astra12_r6=AUDITOR_PASS_NARROW_12_UNIQUE_1_NEW_PLUS_11_POINTERS; astra11_led=AUDITOR_PASS_NARROW_WNS_P0411_WHS_P0027_LED_IOB; astra13=BLOCKED; production_top=UNKNOWN; production_top_freeze=NEEDS_OWNER_NOT_SILENT; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED; auditor=IN_PROGRESS
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-11 FULLCHIP-COFIT / ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-11-A09R7-BTN-IO-01 + prior auditor 20260907T0430Z (12-R6 LED table PASS_NARROW unique 12 ACCEPT_PARTIAL; PRODUCTION_TOP=UNKNOWN; ASTRA-13 BLOCKED; BOARD blocked YES) + T0400Z (A09R7 LED-IO impl-route PASS_NARROW WNS=+0.411 WHS=+0.027 LED IOB YES UART D10/A9 kept; DTS WHS intra-clk50u not LED pad hold; btn[*] false-pathed residual) + T0200Z (A09R7 UART impl-route PASS_NARROW WNS=+0.336 WHS=+0.104) + T1830Z (IOBFF WNS=+0.115 WHS=−4.915 PASS_NARROW of WNS-only unknown)
EVIDENCE   = raw timing_route.rpt / timing_route_exp.rpt / fail_r0/timing_route.rpt / timing_btn_in.rpt / timing_led_out.rpt / timing_uart_in.rpt / timing_uart_out.rpt / check_timing.rpt / exceptions_route.rpt / io.rpt / clocks_route.rpt / clock_util_route.rpt / util_route.rpt / util_hier_route.rpt / route_status.rpt / ram_route.rpt / drc.rpt / util_synth.rpt / timing_synth.rpt / vivado.log / vivado.jou / wrap SV / plant SV / svh / tcl / clk50_btn_io.xdc / btn_iodelay.xdc / led_iodelay.xdc / BTN_IOB.txt / BTN_IOBFF.txt / BTN_IODELAY.txt / LED_IOB.txt / LED_IOBFF.txt / LED_IODELAY.txt / UART_IOB.txt / UART_IOBFF.txt / UART_IODELAY.txt / FIRST_DIVERGENCE.txt / fail_r0/* / SHA manifests / PREREG / ACK / cited constraints/arty_a7_100.xdc / prior LED-IO raw timing_route.rpt + SHA256.txt + wrap + clk50_led_io.xdc / prior UART-impl raw timing_route.rpt + SHA256.txt / 12-R6 SHA256.txt + RESULTS.md (NOT RESULTS.md of this bag as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_impl.ps1` / `run_impl.tcl` (would overwrite `vivado.log` / routed reports / fail_r0). Did not program the plugged board. Did not edit `docs/ASTRA/LOOP_STATE.json`. Did not generate a `.bit`.

This process has **no independent `Get-FileHash`**. Hash check = (1) freeze-list strings vs opened `SHA256.txt` / `SHA256_POST.txt` / `SOURCE_HASHES.txt`, (2) overlapping DUT/SGD/A09/uart/LED-wrap/UART-wrap/cite-XDC hashes vs `ASTRA-11-A09R7-LED-IO-01/SHA256.txt`, `ASTRA-11-A09R7-UART-IMPL-ROUTE-01/SHA256.txt`, `ASTRA-12-R6-LED-CANDIDATES-01/SHA256.txt`, and T0400Z / T0430Z / T0200Z freeze strings, (3) live wrap/XDC/PREREG/raw-report **content** vs PREREG/RESULTS quotes. Claimed SHA strings are **content-verified** against opened files, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R7-BTN-IO-01/`

Top `a7ng_astra_11_a09r7_btn_io_wrap` (bag-local, **new named**) instance **`u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv`**. UART `u_rx` / `u_tx` from `rtl/board/uart_rx.sv` / `uart_tx.sv`. Wrap-level pad FFs `uart_rx_iob` / `uart_tx_iob` / `led_q[3:0]` / `btn_q[3:0]` with `(* IOB = "TRUE" *)` plus XDC `set_property IOB TRUE` on UART, `led[*]`, and `btn[*]`. Pin clock `CLK100MHZ` E3 period 10.000 ns. Pipe clock MMCM 100→50 + BUFG, generated `clk50u` period 20.000 ns (**real**, attributes P,G,A). UART I/O timing reference `uart_io_vclk` period 20.000 ns (**virtual**, attribute V) with inherited UART `set_input_delay` / `set_output_delay` **max 2.000 min 0.500** and **`FALSE_PATH_HOLD_ASYNC_UART`**. LED outputs timed vs **related** `clk50u` with frozen `set_output_delay` **max 2.000 min 0.500** and **`RELATED_CLK50U_NO_FALSE_PATH_HOLD`**. BTN inputs timed vs **related** `clk50u` with frozen `set_input_delay` **max 2.000 min 0.500** and **`RELATED_CLK50U_NO_FALSE_PATH_HOLD`** (no `set_false_path` on `btn[*]`; that was the LED-bag residual). Part `xc7a100tcsg324-1`. Mode **in-context** `synth_design` (not `-mode out_of_context`) then `opt_design` / `place_design` / `route_design`. No bitstream.

Gate under review is **work-order ASTRA-11-A09R7-BTN-IO-01 only** — one unknown (handoff):

> With BTN0–BTN3 mapped from the cited clone XDC plus frozen input delays, after implement+route at 50 MHz, is WNS ≥ 0 and WHS ≥ 0 — without a bitstream?

Parent after auditor **20260907T0430Z**: 12-R6 LED table CLOSED_NARROW unique 12. LED table CLOSED_NARROW. Residual that still fits impl (not freeze, not 65536): **button I/O** on a new named wrap instantiating frozen A09-R2. Cite Arty A7 XDC in this clone for BTN0–BTN3. Freeze input delays in PREREG. implement+route, no bitstream. `PRODUCTION_TOP` stays UNKNOWN. ASTRA-13 BLOCKED. Board plugged. **PROGRAM=NO.**

**Not** Master ASTRA-11 fullchip close. **Not** ASTRA-13 board acceptance. **Not** freeze of `PRODUCTION_TOP`. **Not** LED wrap WNS=+0.411 WHS=+0.027 as this result. **Not** A09R7 UART wrap WNS=+0.336 WHS=+0.104 as this result. **Not** 12-R6 LED table as this result.

Hunt (parent / work order / this dispatch):

1. Quote WNS and WHS from RAW Design Timing Summary. Implementer claimed WNS=+0.452 WHS=−2.068 FAIL_WHS. Did they hide WHS in RESULTS?
2. Button pins D9/C9/B9/B8 match cited clone XDC? IOB FFs packed?
3. fail_r0 preserved? One phys_opt experiment didn't retune delays?
4. No `.bit`? `PRODUCTION_TOP` UNKNOWN?
5. Overclaim BOARD_PASS / mixing with LED WNS=+0.411?

Confirm: frozen A09-R2 instantiated; ASTRA-11-A09R7-LED-IO-01 **not** overwritten; UART impl / 12-R6 **not** overwritten.

Judged against:

1. Work order `.agents/handoff/ASTRA-11-A09R7-BTN-IO-01.md` + PREREG: instantiate `a7ng_astra_09_r2_cand_ovf`; do **not** edit ASTRA-11-A09R7-LED-IO-01 / UART impl / 12-R6 / frozen A09-R2; freeze BTN pinout + delay numbers **before** impl; cite Arty A7 master XDC in this clone; UART+LED pins may stay; hash RTL+XDC+tcl before impl; impl+route at declared 50 MHz; quote routed Design State WNS **and** WHS; button IOB in `io.rpt`; **FAIL if WNS<0 or WHS<0**; keep report; one bounded experiment; still no bit; PROGRAM=NO; do not overwrite LED wrap WNS=+0.411 WHS=+0.027, R7 UART wrap WNS=+0.336 WHS=+0.104, HOLD WNS=+0.115 WHS=+0.131, IOBFF WNS=+0.115 WHS=−4.915, I/O-delay WNS=+0.681, UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, A09 wrap WNS=+1.041, or wrap-route WNS=+5.733; do not close ASTRA-13, BOARD_PASS, LM06, Master F3; do not freeze `PRODUCTION_TOP`.
2. **Master ASTRA-11** (DAG: FULLCHIP-COFIT): whole-chip co-fit of the frozen SoC top (UART + MMCM + I/O + memory plant + production path together), not an isolated named BTN-IO wrap with a fixture plant plus an inherited UART STA hold exception plus a failing related-clock BTN pad hold.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/LOOP_STATE.json`: *astra13=BLOCKED; program=false; production_top=UNKNOWN.* `docs/ASTRA/PROJECT_PATHS.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.* GSTACK_LOOP: ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate.
4. Auditor `20260907T0430Z`: 12-R6 PASS_NARROW unique 12; do not repeat the LED table. Auditor `20260907T0400Z`: LED-IO bag PASS_NARROW WNS=+0.411 WHS=+0.027; LED IOB H5/J5/T9/T10; UART D10/A9 kept; `btn[*]` false-pathed (this bag’s residual). Auditor `20260906T1830Z`: IOBFF WNS=+0.115 WHS=−4.915 graded **PASS_NARROW of a WNS-only unknown**. **This work order is not WNS-only.** Handoff unknown is **WNS ≥ 0 and WHS ≥ 0**. a7-fpga-gate numeric: WNS ≥ 0; TNS = 0; **WHS/THS report; negative hold is a finding**. Here the work order **elevates** WHS≥0 into the unknown itself.

**Master ASTRA-11 as a whole is not this bag’s close**, even if this wrapper’s routed WNS is ≥ 0 and BTN IOB FFs packed.

Out of this bag’s close: freeze of `PRODUCTION_TOP`, silicon UART / silicon MMCM / silicon LED / silicon BTN / silicon BRAM, `a7ng_axi_bram128` plant, bitstream, JTAG/COM12, LM06 language, Master ASTRA-09 production path, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, ASTRA-13 BOARD_PASS, wrap-route `arty_a7_astra_rtp_soc_top` WNS=+5.733 identity, A09R2 wrap WNS=+0.648 identity, leftover A09 wrap WNS=+1.041 identity, prior UART wrap WNS=+0.305 identity, prior I/O-delay wrap WNS=+0.681 identity, prior IOBFF wrap WNS=+0.115 WHS=−4.915 identity, prior HOLD wrap WNS=+0.115 WHS=+0.131 identity, A09R7 UART wrap WNS=+0.336 WHS=+0.104 identity, LED wrap WNS=+0.411 WHS=+0.027 identity, 12-R6 unique-12 table as this routed result, claim that UART IOB hold is now **physically MET**, claim that LED hold is this DTS WHS, claim that all user timing constraints are met.

Frozen `a7ng_astra_09_r2_cand_ovf.sv` / `.svh`, leftover `a7ng_astra_09_integ_path.sv` / `.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `uart_rx.sv` / `uart_tx.sv`, F2R3/F2R4/F2R5, persist/R2/R3/R4 must remain **unpatched**. This wrap is a **new named** BTN-IO impl/route wrapper. It must **instantiate** A09-R2, not copy the graph. It must **not** compile leftover A09 / `astra09_pipe` / `axi_bram128` / RTP SoC / R7 XSim wrap / prior UART impl wrap / prior LED-IO wrap as this top.

Prior bags `ASTRA-11-A09R7-LED-IO-01`, `ASTRA-11-A09R7-UART-IMPL-ROUTE-01`, `ASTRA-12-R6-LED-CANDIDATES-01`, `ASTRA-07-SCALE-MID-01`, `ASTRA-09-R7-UART-QUERY-REW-01`, `ASTRA-11-A09R3-UART-IOBFF-HOLD-01`, `ASTRA-11-A09R3-UART-IOBFF-01`, `ASTRA-11-A09R3-UART-IODELAY-01`, `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, `ASTRA-SOC-RTP-WRAP-ROUTE`, `ASTRA-09-R2-CAND-OVF-01` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`b31e6110…962db6ad`). `write_scope` = new bag + distinctly named BTN-IO wrap that **instantiates** frozen `a7ng_astra_09_r2_cand_ovf` as `u_a09r2` with UART-class D10/A9 kept, LED LD4–LD7 H5/J5/T9/T10 kept, and BTN0–BTN3 pins plus BTN input delays frozen in PREREG **before** impl (BTN IN max 2.000 min 0.500 vs pipe `clk50u`; LED OUT 2.000/0.500 vs clk50u; UART envelope copied 2.000/0.500 + FALSE_PATH_HOLD_ASYNC_UART). Cited pinout `constraints/arty_a7_100.xdc` (Digilent Arty-A7-100-Master) BTN D9/C9/B9/B8. Do not edit ASTRA-11-A09R7-LED-IO-01. Do not edit ASTRA-11-A09R7-UART-IMPL-ROUTE-01. Do not edit ASTRA-12-R6-LED-CANDIDATES-01. Frozen leftover A09 not compiled as DUT. A09-R2 DUT source not patched. `uart_rx`/`uart_tx` not patched. Prior bags not edited. `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, **ASTRA-12-R6-LED-CANDIDATES-01**, **ASTRA-11-A09R7-LED-IO-01**, **ASTRA-11-A09R7-UART-IMPL-ROUTE-01**, ASTRA-07-SCALE-MID-01, ASTRA-09-R7-UART-QUERY-REW-01, ASTRA-11-A09R3-UART-IOBFF-HOLD-01, ASTRA-11-A09R3-UART-IOBFF-01, ASTRA-11-A09R3-UART-IODELAY-01, ASTRA-11-A09R3-UART-IMPL-ROUTE-01, ASTRA-SOC-RTP-WRAP-UART-XSIM, ASTRA-09-R3-UART-XSIM-01, Master_ASTRA-10_whole_chip, production_top_identity, write_bitstream, silicon_UART, silicon_BTN, N64_INCOMP_repeat.

`run_impl.tcl` **renames** `write_bitstream` to abort (`astra_forbid_bit` → exit 1). `vivado.jou`: **no** `write_bitstream`, **no** `.bit`, **no** `program_hw` / `open_hw`. Compile list is pkg/query/sparse/SGD/**A09-R2**/uart_rx/uart_tx/bag plant/bag wrap only. Tcl forbids leftover A09 / `astra09_pipe` / RTP SoC / R7 XSim wrap / prior UART impl/IOdelay/IOBFF/HOLD wraps / **prior LED-IO wrap** / `axi_bram128`. Post-synth cell checks abort if leftover A09 / pipe / BRAM cells exist, or if `u_a09r2` / `u_rx` / `u_tx` cells are missing. BTN IOB extract requires D9/C9/B9/B8 = `btn[0:3]` in `io.rpt`. LED IOB extract requires H5/J5/T9/T10. UART IOB extract requires A9=`uart_txd_in` and D10=`uart_rxd_out`.

Bag listing: **no** `.bit` / `.bin` / `.mcs`. Checkpoints are `ckpt/synth.dcp` and `ckpt/route.dcp` only. `fail_r0/` **present** (WHS<0 protocol). `FIRST_DIVERGENCE.txt` present (`WHS_NEG`). `timing_route_exp.rpt` present (one bounded experiment).

`vivado.log` grep for `write_bitstream`, `.bit`, `program_hw`, `open_hw`, `BOARD_PASS`: **no matches**. `PRODUCTION_TOP=UNKNOWN` at start (line 61) and DONE (line 1512).

Handoff base `5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1` MATCH ACK / CLOSEOUT.

---

### 1. Raw routed WNS and WHS (authority) — MATCH claimed +0.452 / −2.068; WHS NOT hidden

`timing_route.rpt` header:

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Mon Sep  7 04:24:50 2026
Command      : report_timing_summary -file .../ASTRA-11-A09R7-BTN-IO-01/timing_route.rpt
Design       : a7ng_astra_11_a09r7_btn_io_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      0.452        0.000                      0                 8953       -2.068       -8.128                      4                 8951
Timing constraints are not met.
```

Clock Summary (same rpt):

```text
sys_clk_pin  {0.000 5.000}      10.000          100.000
  clk50u     {0.000 10.000}     20.000          50.000
  clkfb      {0.000 5.000}      10.000          100.000
uart_io_vclk {0.000 10.000}     20.000          50.000
```

Intra-clock table:

```text
  clk50u            0.452        0.000                      0                 7258       -2.068       -8.128                      4                 7258
```

Inter-clock table (hold columns **blank** — UART I/O hold excepted):

```text
uart_io_vclk  clk50u             19.270
clk50u        uart_io_vclk        7.313
```

clk50u path-group:

```text
Setup :            0  Failing Endpoints,  Worst Slack        0.452ns,  Total Violation        0.000ns
Hold  :            4  Failing Endpoints,  Worst Slack       -2.068ns,  Total Violation       -8.128ns
```

`check_timing` embedded in the same rpt: `no_output_delay (0)`, `partial_input_delay (0)`, `no_input_delay (4)` = `sw[*]` with false-path (MEDIUM). Verbose `check_timing.rpt` lists `sw[0]`…`sw[3]` only. **`btn[*]` is constrained.** LED ports are **not** in `no_output_delay`.

Worst **setup** path (clk50u intra, Slack MET 0.452 ns):

```text
Source  u_a09r2/pv_reg[0][3]/C
Dest    u_a09r2/best_a_reg[15]/D
Requirement = 20.000 ns
Data Path Delay = 19.388 ns  (logic 5.609 / route 13.779)
```

Worst **hold** path (clk50u intra, Slack VIOLATED −2.068 ns) — **BTN pad hold**, not intra-core DUT hold:

```text
Source  btn[0]  (input port clocked by clk50u)
Dest    btn_q_reg[0]/D  (FDRE ILOGIC_X0Y187 ILOGICE2.IFF)
Path Type Hold (Min at Slow Process Corner)
Input Delay = 0.500 ns
Data Path Delay = 1.417 ns (IBUF; route 0.000)
Clock Path Skew = 3.712 ns (DCD=6.515 SCD=2.656 CPR=0.147)
Package pin D9
```

`timing_btn_in.rpt` (Design State Routed) four hold VIOLATED endpoints, all BTN pad → IOB FF:

| Port | Pin | Dest | Hold slack | Setup slack (same rpt class) |
|------|-----|------|------------|------------------------------|
| btn[0] | D9 | `btn_q_reg[0]` ILOGIC_X0Y187 | **−2.068** | 18.616 (RESULTS; Input Delay max=2.000) |
| btn[2] | B9 | `btn_q_reg[2]` ILOGIC_X0Y177 | −2.027 | |
| btn[1] | C9 | `btn_q_reg[1]` ILOGIC_X0Y178 | −2.025 | |
| btn[3] | B8 | `btn_q_reg[3]` ILOGIC_X0Y176 | −2.007 | |

THS=−8.128 is the sum of those four BTN pad-hold endpoints (−2.068 + −2.027 + −2.025 + −2.007 = −8.127; 1 ps rounding). DTS WHS=−2.068 **is** BTN pad hold.

LED hold remains MET **+2.927** ns (`timing_led_out.rpt`, Output Delay=0.500 vs clk50u). UART I/O hold columns are blank because of `FALSE_PATH_HOLD_ASYNC_UART` (`exceptions_route.rpt` positions 8–9: Hold=`false` on `uart_txd_in` / `uart_rxd_out`). Position 2: `sw[*]` false setup+hold. **No exception on `btn[*]`.**

**EVIDENCE:** claimed WNS=+0.452 / WHS=−2.068 MATCH raw Design Timing Summary, Design State=Routed, TNS=0, THS=−8.128, THS failing endpoints=4. Authority is this rpt, not RESULTS.md.

**Did RESULTS hide WHS? NO.**

RESULTS marker:

```text
MARKER = ASTRA_11_A09R7_BTN_IO_DONE WNS=0.452 WHS=-2.068 ... RESULT=FAIL_WHS PRODUCTION_TOP=UNKNOWN
RESULT = FAIL_WHS (this bag only: Design Timing Summary WNS>=0 but WHS<0 ...)
```

CLOSEOUT `RESULT = FAIL_WHS`, `WHS = -2.068 ns`, `BTN_IN_HOLD_SLACK = -2.068 ns (VIOLATED)`. `metrics.json` `"whs_ns": -2.068`, `"timing_constraints_met": false`, `"result": "FAIL_WHS"`. `TIMING_EXTRACT.txt` `WHS=-2.068`. `FIRST_DIVERGENCE.txt` `FIRST_DIVERGENCE WHS_NEG`. `vivado.log` DONE line quotes `WHS=-2.068 RESULT=FAIL_WHS`. Implementer **did not hide WHS**. Implementer **did not claim all-constraints-met**. Implementer **did not claim BOARD_PASS**.

This WNS is **not** LED wrap WNS=+0.411 (that bag’s raw `timing_route.rpt` is still Date **Mon Sep 7 03:11:15 2026**, Design `a7ng_astra_11_a09r7_led_io_wrap`, WNS=0.411 WHS=0.027, TNS endpoints=8949 vs this bag 8953). Endpoint delta **+4** is the four constrained BTN input paths (LED bag left `btn[*]` false-pathed; `check_timing` there was `no_input_delay (8)` = sw+btn).

This WNS is **not** UART wrap WNS=+0.336 (that bag still Date **Mon Sep 7 01:52:48 2026**, Design `a7ng_astra_11_a09r7_uart_impl_wrap`, WNS=0.336 WHS=0.104, TNS endpoints=8940).

Clock network is **real**, not virtual: `clocks_route.rpt` Design State Routed: `clk50u` attributes **P,G,A** source `{u_mmcm/CLKOUT0}` master `sys_clk_pin`; `uart_io_vclk` attributes **V** sources `{}`. `clock_util_route.rpt`: BUFGCTRL used=1, MMCM used=1. Worst-hold destination clock is E3 IBUF → MMCM → BUFG `u_bufg50` net `clk` fo=3624. Pipe clock is not `create_clock -name virtual_*` on the DUT net.

`route_status.rpt`: nets with routing errors = **0**. Fully routed nets = 6201.

Hunt 1: **MATCH claim. WHS not hidden. Raw WNS=+0.452 ≥ 0. Raw WHS=−2.068 < 0. Work-order unknown (WNS≥0 AND WHS≥0) = FAIL.**

---

### 2. Button pins D9/C9/B9/B8 match cited clone XDC; IOB FFs packed — MATCH

**Cited clone pinout** `constraints/arty_a7_100.xdc` header: *Source: Digilent digilent-xdc / Arty-A7-100-Master.xdc (Rev. D and Rev. E).* Live lines:

```text
set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]; #IO_L6N_T0_VREF_16 Sch=btn[0]
set_property -dict { PACKAGE_PIN C9    IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; #IO_L11P_T1_SRCC_16 Sch=btn[1]
set_property -dict { PACKAGE_PIN B9    IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; #IO_L11N_T1_SRCC_16 Sch=btn[2]
set_property -dict { PACKAGE_PIN B8    IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]; #IO_L12P_T1_MRCC_16 Sch=btn[3]
```

This clone’s master XDC has **no other BTN set**. Handoff: cite the clone XDC — **this is the cited set**. SHA `1c12e6f8943261c7089984a3725642043d027b813549433b8256843227b6a9c2` MATCH LED-bag KEEP list and 12-R6 freeze of the same file. File is hashed as **cite**, not compiled as the impl XDC (`clk50_btn_io.xdc` is the impl pin XDC).

Bag XDC `clk50_btn_io.xdc` copies the same four PACKAGE_PIN lines. PREREG frozen **before** impl:

```text
BTN[0]  = D9    BTN0   Sch=btn[0]   LVCMOS33
BTN[1]  = C9    BTN1   Sch=btn[1]   LVCMOS33
BTN[2]  = B9    BTN2   Sch=btn[2]   LVCMOS33
BTN[3]  = B8    BTN3   Sch=btn[3]   LVCMOS33
BTN_IN_MAX_NS    = 2.000
BTN_IN_MIN_NS    = 0.500
BTN_CLK_REF      = clk50u
BTN_HOLD_POLICY  = RELATED_CLK50U_NO_FALSE_PATH_HOLD
```

`btn_iodelay.xdc` (hashed in COMPILED list **before** impl):

```tcl
set_input_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {btn[*]}]
set_input_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {btn[*]}]
```

Hash order: `SHA256.txt` stamp **BEFORE impl** `2026-09-07T04:20:01.2603642+07:00` includes `btn_iodelay.xdc` `af42128d…786d15cd` and `PREREG.md` `70a509e4…be79a600`. `vivado.log` session start **Mon Sep 7 04:20:02 2026** PID **15476** — one second after the freeze. `run_impl.ps1` writes SHA then launches Vivado. Delay numbers were **not** invented after seeing WHS.

Post-synth apply (raw `vivado.log`):

```text
BTN_IODELAY_APPLIED clk50u PERIOD=20.000 MAX=2.000 MIN=0.500
```

`io.rpt` Design State Routed (04:24:54), Total User IO=15:

```text
D9   btn[0]        INPUT   LVCMOS33  FIXED
C9   btn[1]        INPUT   LVCMOS33  FIXED
B9   btn[2]        INPUT   LVCMOS33  FIXED
B8   btn[3]        INPUT   LVCMOS33  FIXED
H5   led[0]        OUTPUT  LVCMOS33  FIXED
J5   led[1]        OUTPUT  LVCMOS33  FIXED
T9   led[2]        OUTPUT  LVCMOS33  FIXED
T10  led[3]        OUTPUT  LVCMOS33  FIXED
A9   uart_txd_in   INPUT   LVCMOS33  FIXED
D10  uart_rxd_out  OUTPUT  LVCMOS33  FIXED
E3   CLK100MHZ     INPUT   LVCMOS33  FIXED
```

BTN IOB FF pack (`BTN_IOBFF.txt`):

```text
BTN_IOBFF_CELLS=4
BTN_IOBFF_PACKED_CELLS=4
BTN_IOBFF=YES
BTN_CELL=btn_q_reg[0] BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y187 IOB=TRUE PACKED=YES
BTN_CELL=btn_q_reg[1] BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y178 IOB=TRUE PACKED=YES
BTN_CELL=btn_q_reg[2] BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y177 IOB=TRUE PACKED=YES
BTN_CELL=btn_q_reg[3] BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y176 IOB=TRUE PACKED=YES
```

Wrap RTL: `(* IOB = "TRUE" *) logic [3:0] btn_q` sampled `always_ff @(posedge clk) btn_q <= btn`. No IDELAYE2 / IDELAYCTRL in this wrap. Hold datapath is IBUF-only (route 0.000) into the IOB FF — packing succeeded; that does **not** close hold.

`util_route.rpt` Design State Routed: IOB Flip Flops=**10**, ILOGIC=**5**, OLOGIC=**5**. Split: 4 BTN ILOGIC + 1 UART RX ILOGIC; 4 LED OLOGIC + 1 UART TX OLOGIC. UART_IOBFF YES (`uart_rx_iob_reg` ILOGICE2.IFF ILOGIC_X0Y171; `uart_tx_iob_reg` OLOGICE2.OUTFF OLOGIC_X0Y161). LED_IOBFF YES (led_q_reg[0:3] OLOGICE2.OUTFF).

Hunt 2: **YES. Pins MATCH cited clone XDC. BTN IOB FIXED. BTN IOB FFs packed 4/4.**

---

### 3. fail_r0 preserved; one phys_opt experiment; delays not retuned — MATCH

PREREG: if WNS<0 or WHS<0, FAIL this bag, keep the routed report, one bounded experiment (post-route `phys_opt_design`; **same frozen STA envelope**; still 50 MHz; still IOB=TRUE; still BTN delays 2.000/0.500 vs clk50u). Still no bitstream. Do not invent delay numbers. Do not retune BTN 2.000/0.500.

`FIRST_DIVERGENCE.txt`:

```text
FIRST_DIVERGENCE WHS_NEG
routed WHS=-2.068 < 0; bag FAIL; keep report; one bounded experiment
```

`run_impl.tcl` `astra_copy_fail_r0` copies the routed reports into `fail_r0/` **before** the experiment. Live `fail_r0/` contains `timing_route.rpt`, `timing_btn_in.rpt`, `io.rpt`, `BTN_IOB.txt`, `BTN_IOBFF.txt`, `BTN_IODELAY.txt`, and siblings listed in the copy proc.

`fail_r0/timing_route.rpt`: Date **Mon Sep 7 04:24:50 2026**, Design State=**Routed**, Design `a7ng_astra_11_a09r7_btn_io_wrap`, DTS **WNS=0.452 WHS=−2.068 THS=−8.128**, *Timing constraints are not met.* Same numbers as live `timing_route.rpt` (live file is the FAIL report; experiment writes `timing_route_exp.rpt`, does **not** overwrite the routed authority).

`fail_r0/BTN_IODELAY.txt` / live `BTN_IODELAY.txt` / `BTN_IODELAY_EXP.txt` all:

```text
BTN_IN_MAX_NS=2.000
BTN_IN_MIN_NS=0.500
BTN_CLK_REF=clk50u
BTN_HOLD_POLICY=RELATED_CLK50U_NO_FALSE_PATH_HOLD
BTN_IN_HOLD_SLACK=-2.068
```

Post-route experiment `timing_route_exp.rpt` header:

```text
Date         : Mon Sep  7 04:24:58 2026
Command      : report_timing_summary -file .../timing_route_exp.rpt
Design       : a7ng_astra_11_a09r7_btn_io_wrap
Design State : Physopt postRoute
```

DTS identical: **WNS=0.452 WHS=−2.068 THS=−8.128**. *Timing constraints are not met.*

Raw `vivado.log` experiment:

```text
Command: phys_opt_design
INFO: [Vivado_Tcl 4-232] No setup violation found. The netlist was not modified.
phys_opt_design completed successfully
ASTRA_11_A09R7_BTN_IO_DONE WNS=0.452 WHS=-2.068 ... RESULT=FAIL_WHS PRODUCTION_TOP=UNKNOWN
```

`phys_opt_design` cannot repair IOB input hold when WNS≥0 (setup opts skipped) and the data path is already IBUF-only into a packed IOB FF. Delays **not** retuned. Frozen `uart_rx.sv` not patched. `btn_iodelay.xdc` still 2.000/0.500. `clk50_btn_io.xdc` still IOB TRUE on `btn[*]`, still **no** `set_false_path` on `btn[*]`.

Hunt 3: **YES. fail_r0 preserved. One post-route phys_opt. Netlist unmodified. Delays not retuned. WHS still −2.068.**

---

### 4. No `.bit`; PRODUCTION_TOP UNKNOWN — MATCH

Bag listing: no `.bit` / `.bin` / `.mcs`. `ckpt/` = `synth.dcp` + `route.dcp` only. `vivado.jou`: no `write_bitstream`, no `program_hw`, no `open_hw`. `vivado.log`: no `write_bitstream` / `.bit` / `BOARD_PASS`. Tcl renames `write_bitstream` to abort. ACK / PREREG / RESULTS / CLOSEOUT / metrics / DONE line: `PRODUCTION_TOP=UNKNOWN`, `BIT=NOT_BUILT`, `PROGRAM=NO`.

Hunt 4: **YES. No bitstream. PRODUCTION_TOP UNKNOWN.**

---

### 5. Overclaim BOARD_PASS / mixing with LED WNS=+0.411? — NO overclaim of those

RESULTS: *Not BOARD_PASS. Not LED wrap WNS=+0.411. Not R7 UART wrap WNS=+0.336. Not 12-R6 LED table.* CLOSEOUT: *Do not freeze PRODUCTION_TOP. PROGRAM=NO. … not silicon buttons.* ACK `does_not_close` includes BOARD_PASS, ASTRA-13, ASTRA-11-A09R7-LED-IO-01. `metrics.json` `"result": "FAIL_WHS"`, `"production_top": "UNKNOWN"`, `"bitstream": false`.

Live LED bag **not overwritten**: `timing_route.rpt` still Date **03:11:15**, Design `a7ng_astra_11_a09r7_led_io_wrap`, WNS=0.411 WHS=0.027. LED wrap SHA `7bb960c0…77d6e7c` MATCH this bag’s KEEP list and LED `SHA256.txt` (freeze **03:06:25.2550197+07:00**) and 12-R6 cited hash of the same wrap. LED `clk50_led_io.xdc` `48558c4a…1ac348` MATCH KEEP.

Live UART impl **not overwritten**: `timing_route.rpt` still Date **01:52:48**, WNS=0.336 WHS=0.104. Wrap SHA `d1f66a54…6c3e57` MATCH KEEP.

Live 12-R6 **not overwritten**: `SHA256.txt` still *Tabled 2026-09-07T03:32:14+07:00*, `PRODUCTION_TOP=UNKNOWN`, unique **12**, `RESULT=PASS_NARROW`. ACK hash `c1187d8a…e28c4cfb` MATCH T0430Z.

Hunt 5: **NO BOARD_PASS overclaim. NO mixing this WNS=+0.452 with LED WNS=+0.411. LED / UART / 12-R6 bags intact.**

---

### A09-R2 instantiated; leftover A09 not compiled; hash-before-impl includes `.svh`

`synth_design -top a7ng_astra_11_a09r7_btn_io_wrap -part xc7a100tcsg324-1` (in-context). `vivado.log`: synthesizing module `a7ng_astra_11_a09r7_btn_io_wrap`; `U_A09R2_CELLS=11063`; `BTN_IOBFF_CELLS=4`. Wrap SV line 147: `a7ng_astra_09_r2_cand_ovf u_a09r2 (`. `load_v_i` tied 0. Plant is bag-local `a7ng_astra_11_a09r7_btn_io_plant` (fixture; hier LUT=170 FF=73 BRAM=0), **not** `a7ng_axi_bram128`.

**Not synthesized:** `a7ng_astra_09_integ_path`, `a7ng_astra09_pipe`, `arty_a7_astra_rtp_soc_top`, `a7ng_axi_bram128`, `a7ng_astra_11_a09r7_led_io_wrap`, `a7ng_astra_11_a09r7_uart_impl_wrap`.

PRE vs POST compiled RTL+XDC+tcl + transitive `.svh`: **identical strings** on the opened manifests. R2 DUT freeze `15a919f1…8b70ee23` MATCH PRE and POST and T0400Z. Frozen leftover A09 `9fdbe0d6…bb5c776c` MATCH provenance (KEEP; **not compiled**). Frozen SGD `b66ef328…5fc67aac` MATCH. `uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH. Bag wrap `52e1b4f2…3eec6132` MATCH PRE/POST. `.svh` **is** in the pre-impl freeze (R2 contract + leftover A09 header + lexica + crc + bag `a7ng_astra_11_a09r7_btn_io.svh`).

PRE 04:20:01+07 < Vivado 04:20:02. POST 04:25:01+07 after route/exp. Not hash-after-scores theatre.

---

## Resources (raw; not the WNS quote)

Quoted **synth** `util_synth.rpt` Design State Synthesized (`UTIL_EXTRACT_SYNTH.txt`): Slice LUTs **5792**, Slice Registers **5092**, BRAM **0**, DSP **2**.

Quoted **routed** `util_route.rpt` Design State Routed:

```text
| Slice LUTs              | 4944 |     63400 |  7.80 |
| Slice Registers         | 3614 |    126800 |  2.85 |
| Block RAM Tile          |    0 |
| DSPs                    |    2 |       240 |  0.83 |
| Bonded IOB              |   15 |       210 |  7.14 |
| IOB Flip Flops          |   10 |
| ILOGIC                  |    5 |       210 |  2.38 |
| OLOGIC                  |    5 |       210 |  2.38 |
```

Hierarchical routed (`util_hier_route.rpt`): **`u_a09r2` LUT=4325 FF=2738 DSP=2**. Plant LUT=170 FF=73. Honest occupancy of a live R2 DUT, **not** a stub. Fixture plant BRAM=0 is honest. Do not add 4944 to LED wrap 4945 / UART wrap 4945 as a chip sum.

---

## Classification vs work-order unknown (not vs WNS-only IOBFF)

| Question | Answer |
|----------|--------|
| Work-order unknown | WNS ≥ 0 **and** WHS ≥ 0 after impl+route of named BTN-IO wrap with cited BTN pins + frozen delays 2.000/0.500 vs clk50u, no bitstream |
| Raw WNS ≥ 0? | **YES** +0.452 |
| Raw WHS ≥ 0? | **NO** −2.068 |
| All constraints met? | **NO** (*Timing constraints are not met.*) |
| PASS of this unknown? | **NO** |
| PASS_NARROW (WNS-only), as T1830Z IOBFF? | **NO.** T1830Z work order asked WNS≥0 only; WHS was a finding. **This** handoff / PREREG / RESULTS one-unknown is explicitly **WNS ≥ 0 and WHS ≥ 0**. PREREG: *FAIL this bag if WNS<0 or WHS<0.* |
| OVERCLAIM (hide WHS / BOARD_PASS / steal LED +0.411)? | **NO.** Implementer tagged **FAIL_WHS**, quoted WHS, kept LED/UART/12-R6 identity separate, `PRODUCTION_TOP=UNKNOWN`. |
| FAIL of this unknown? | **YES.** |

Hold physics (finding, not a hidden cheat): related-clock BTN input min-delay 0.500 vs MMCM+BUFG insertion. Source clock delay of the input-delay path is MMCM `CLKOUT0` only (SCD=2.656 ns, no BUFG). Destination clock includes BUFG+net (DCD=6.515 ns). Skew 3.712 ns + CU 0.082 + hold 0.191 against data 1.417 (IBUF) + 0.500 min-delay → slack −2.068. Same *family* as UART IOBFF WHS=−4.915 (IOB FF + min 0.500 vs MMCM DCD), different clock (related `clk50u` here, virtual `uart_io_vclk` there). Packing the IOB FF **removed route** from the data path and **does not help hold**. `phys_opt_design` with WNS≥0 does not insert hold delay on IOB inputs.

Observation, not this unknown: wrap uses `btn_q[0]` as active-high POR/reset (`btn0_sync` clears `por_cnt`); `btn_q[1]` and `btn_q[3:2]` OR into `led_q[3]`. Live ACK.json does **not** freeze a BTN1=`start_pulse` / BTN2=`clear_error` / BTN3=`debug_step` function map. Pin STA is the unknown. Function map is not a PASS of WHS.

---

## Comparison (not identity)

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 4944 | 3614 | 0 | 2 | **Routed clk50u WNS=+0.452 IOB FF YES delays 2.000/0.500; WHS=−2.068 BTN pad hold FAIL** |
| ASTRA-11-A09R7-LED-IO-01 | — | — | 0 | 2 | Routed WNS=+0.411 WHS=+0.027; `btn[*]` false-pathed; bag **not overwritten** (03:11:15) |
| ASTRA-11-A09R7-UART-IMPL-ROUTE-01 | — | — | 0 | 2 | Routed WNS=+0.336 WHS=+0.104; bag **not overwritten** (01:52:48) |
| ASTRA-11-A09R3-UART-IOBFF-01 | 4802 | 3500 | 0 | 2 | WNS=+0.115 WHS=−4.915 uart_io_vclk IOB input hold; **WNS-only** unknown |
| ASTRA-12-R6-LED-CANDIDATES-01 | n/a | n/a | n/a | n/a | Table unique 12; **not overwritten** |

| Claim | This bag vs |
|-------|-------------|
| ASTRA-11 FULLCHIP-COFIT | Named BTN-IO wrap + MMCM/BUFG + D10/A9 UART IOB + LED H5/J5/T9/T10 IOB + BTN D9/C9/B9/B8 IOB + IOB FFs + fixture AXI plant + inherited UART STA hold exception + **BTN pad hold VIOLATED**. No `axi_bram128`. No DDR. `PRODUCTION_TOP=UNKNOWN` |
| ASTRA-11-A09R7-LED-IO-01 WNS=+0.411 WHS=+0.027 | Different wrap; bag **not** overwritten; this WNS=+0.452 WHS=−2.068 is **not** that number |
| ASTRA-11-A09R7-UART-IMPL-ROUTE-01 WNS=+0.336 WHS=+0.104 | Different wrap; bag **not** overwritten |
| ASTRA-12-R6 unique 12 | Different class (table); bag **not** overwritten |
| ASTRA-11-A09R3-UART-IOBFF-01 WNS=+0.115 WHS=−4.915 | Different wrap / different ports; same *class* of IOB-FF + min 0.500 vs MMCM DCD |
| ASTRA-13 FINAL-BOARD-ACCEPTANCE | BIT=NOT_BUILT; PROGRAM=NO; no JTAG/COM12; `PRODUCTION_TOP=UNKNOWN` |
| LM06 language | Not opened |

Master **ASTRA-11 FULLCHIP-COFIT** remains **OPEN**.

Master **ASTRA-13 FINAL-BOARD-ACCEPTANCE** remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority.

Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-10 whole-chip remain **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

---

## Verdict per bag: FAIL

`ASTRA-11-A09R7-BTN-IO-01`: **FAIL**

Work-order unknown answered **no** with raw routed reports: instantiate-not-copy of `a7ng_astra_09_r2_cand_ovf`, frozen leftover A09 not compiled, LED-IO wrap KEEP not this top, UART impl wrap KEEP, hash-before-impl including `.svh`, real clock-network (not virtual), WNS=+0.452 ≥ 0, **WHS=−2.068 < 0** (BTN pad hold, 4 endpoints, THS=−8.128), BTN IOB D9/C9/B9/B8 FIXED matching cited clone `constraints/arty_a7_100.xdc` BTN0–BTN3, BTN IOB FFs packed, BTN delays 2.000/0.500 vs clk50u frozen in PREREG before impl and applied post-synth, **not retuned**, fail_r0 preserved, one post-route `phys_opt_design` (netlist unmodified; WHS unchanged), UART D10/A9 kept FIXED, LED H5/J5/T9/T10 kept FIXED, PROGRAM=NO, no bitstream, `PRODUCTION_TOP=UNKNOWN`, prior LED-IO / UART-impl / 12-R6 / HOLD / IOBFF bags not overwritten, no BOARD_PASS / ASTRA-13 / LM06 overclaim, no theft of LED wrap +0.411 or UART wrap +0.336.

Not PASS (WHS<0; *Timing constraints are not met.*; work-order AND-gate fails).  
Not PASS_NARROW (this unknown is not WNS-only; PREREG/handoff FAIL on WHS<0).  
Not OVERCLAIM (ACK/RESULTS keep Master 11/13/BOARD/LM06/`PRODUCTION_TOP` open; disclose FAIL_WHS and DTS WHS=−2.068 as BTN pad hold; do not steal LED wrap +0.411/+0.027, UART wrap +0.336/+0.104, HOLD +0.115/+0.131, IOBFF −4.915, I/O-delay +0.681, UART wrap +0.305, A09R2 wrap +0.648, leftover A09 wrap +1.041, wrap-route +5.733, or 12-R6 unique 12).

Classification of hunt 1 in one line: **FAIL of “WNS≥0 AND WHS≥0”; WHS not hidden; not OVERCLAIM.**

---

## Required fixes (for parent to dispatch)

**P1: BTN pad hold under the frozen related-clock envelope.** Close `btn[*] → btn_q_reg[*]/D` hold vs `clk50u` with Input Delay min **0.500** (currently WHS=−2.068, 4 endpoints, THS=−8.128). Do this in a **new named bag**. Do **not** retune 2.000/0.500 inside `ASTRA-11-A09R7-BTN-IO-01`. Do **not** `set_false_path` on `btn[*]` (that reopens the LED-bag residual and would make WHS tautological). Do **not** `set_false_path -hold` on BTN. Do **not** patch frozen `uart_rx.sv` / A09-R2 / leftover A09. Do **not** `write_bitstream`. `phys_opt_design` with WNS≥0 is **exhausted** on this netlist (netlist unmodified). A new bag may freeze a **new** honest STA/device envelope in PREREG **before** impl (example class: IDELAYE2 tap on BTN with value frozen before impl — this wrap has **no** IDELAYE2). Auditor does **not** invent the next delay number.

**P2 / residuals (do not reopen this bag as PASS by excepting hold):**

1. Do **not** promote this WNS=+0.452 / WHS=−2.068 / BTN_IOB=YES / BTN_IOBFF=YES to BOARD_PASS, ASTRA-13, LED wrap WNS=+0.411 WHS=+0.027, UART wrap WNS=+0.336 WHS=+0.104, HOLD wrap WNS=+0.115 WHS=+0.131, IOBFF WHS=−4.915, or `PRODUCTION_TOP=a7ng_astra_11_a09r7_btn_io_wrap`.
2. Do **not** claim DTS WHS=−2.068 is intra-core DUT hold. It is BTN pad hold (`btn[0]` D9 → `btn_q_reg[0]` ILOGIC_X0Y187). LED hold remains MET +2.927. UART I/O hold remains excepted.
3. Do **not** claim UART IOB hold is physically MET. UART I/O hold vs `uart_io_vclk` remains excepted (`FALSE_PATH_HOLD_ASYNC_UART`). The −4.915 IOBFF bag must remain on disk.
4. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
5. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv`, frozen A09-R2 (`15a919f1…`), frozen SGD (`b66ef328…`), or frozen `uart_rx` / `uart_tx` from this WHS.
6. Do **not** edit ASTRA-11-A09R7-LED-IO-01. That `timing_route.rpt` must stay 03:11:15 Design `a7ng_astra_11_a09r7_led_io_wrap` WNS=0.411 WHS=0.027. Wrap hash must stay `7bb960c0…`.
7. Do **not** edit ASTRA-11-A09R7-UART-IMPL-ROUTE-01. That `timing_route.rpt` must stay 01:52:48 WNS=0.336 WHS=0.104. Wrap hash must stay `d1f66a54…`.
8. Do **not** rewrite ASTRA-12-R6-LED-CANDIDATES-01. Unique 12 and `PRODUCTION_TOP=UNKNOWN` stay.
9. Keep `fail_r0/` on disk. Do not rerun `run_impl.tcl` in this bag (would wipe routed authority and fail_r0).
10. Host parsers must not mix this wrap’s BTN STA/IOB envelope with the LED wrap, R7 UART impl wrap, HOLD wrap, IOBFF wrap, or RTP SoC wrap as one frozen production top.

---

## Final: FAIL_LOOP | REJECT_PROMOTION

`FAIL_LOOP` — work-order unknown **WNS ≥ 0 and WHS ≥ 0** is **not met**. Raw routed Design Timing Summary WNS=+0.452 / WHS=−2.068. Implementer correctly tagged **FAIL_WHS**, preserved `fail_r0`, ran one post-route `phys_opt_design` without retuning frozen 2.000/0.500, still no bitstream. Experiment left WHS=−2.068. Parent must dispatch a **new** residual for BTN pad hold. This bag is closed as FAIL evidence, not as a production wrap.

`REJECT_PROMOTION` — Master **ASTRA-11** (fullchip co-fit / frozen SoC UART+LED+BTN top / on-chip plant), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. Routed BTN wrap **≠** silicon buttons. UART I/O hold excepted **≠** physically MET. LED wrap WNS=+0.411 **≠** this WNS=+0.452.

Not `ACCEPT_PARTIAL`: the declared unknown failed. Honest process does not convert FAIL_WHS into a narrow accept of WNS-only.

Master ASTRA-09: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-12-R6-LED-CANDIDATES-01: **untouched, still PASS_NARROW unique 12, not this routed result**.  
ASTRA-11-A09R7-LED-IO-01 routed WNS=+0.411 WHS=+0.027: **untouched**.  
ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed WNS=+0.336 WHS=+0.104: **untouched**.  
ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed WNS=+0.115 WHS=+0.131: **untouched**.  
ASTRA-11-A09R3-UART-IOBFF-01 routed WNS=+0.115 WHS=−4.915: **untouched**.  
ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681: **untouched**.  
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305: **untouched**.  
ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648: **untouched**.  
ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041: **untouched, different DUT**.  
ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733: **untouched, different top**.  
PRODUCTION_TOP: **UNKNOWN**.  
T0430Z residual (button I/O on a new named wrap, not a silent freeze): **FAIL this bag as evidence class; unknown not closed.**

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**. BTN IOB: **YES**. BTN IOB FF: **YES**. LED IOB: **YES**. UART IOB: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0500Z\REPORT.md — Final FAIL_LOOP | REJECT_PROMOTION — WNS=+0.452 WHS=−2.068 — BTN IOB YES — BOARD blocked YES.
