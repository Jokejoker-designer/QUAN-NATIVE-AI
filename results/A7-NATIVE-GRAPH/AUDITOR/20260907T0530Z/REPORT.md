# ASTRA auditor REPORT — 20260907T0530Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA11_A09R7_BTN_IDELAY_INDEPENDENT_AUDIT; astra11_btn=AUDITOR_FAIL_WHS_M2068_BTN_PAD_HOLD; astra11_btn_idelay=IMPLEMENTER_CLAIM_WNS_P0574_WHS_P0131_TAP31_PENDING_AUDITOR; astra11_led=AUDITOR_PASS_NARROW_WNS_P0411_WHS_P0027_LED_IOB; astra12_r6=AUDITOR_PASS_NARROW_12_UNIQUE_1_NEW_PLUS_11_POINTERS; astra13=BLOCKED; production_top=UNKNOWN; production_top_freeze=NEEDS_OWNER_NOT_SILENT; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED; auditor=IN_PROGRESS
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-11 FULLCHIP-COFIT / ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-11-A09R7-BTN-IDELAY-01 + prior auditor 20260907T0500Z (BTN-IO FAIL_LOOP WHS=−2.068 P1 IDELAYE2 new bag; do not retune FAIL bag; do not false-path btn) + T0430Z (12-R6 LED table PASS_NARROW unique 12 ACCEPT_PARTIAL) + T0400Z (A09R7 LED-IO PASS_NARROW WNS=+0.411 WHS=+0.027) + T0200Z (A09R7 UART impl-route PASS_NARROW WNS=+0.336 WHS=+0.104)
EVIDENCE   = raw timing_route.rpt / timing_btn_in.rpt / timing_led_out.rpt / timing_uart_in.rpt / timing_uart_out.rpt / check_timing.rpt / exceptions_route.rpt / io.rpt / clocks_route.rpt / clock_util_route.rpt / util_route.rpt / util_hier_route.rpt / route_status.rpt / ram_route.rpt / drc.rpt / util_synth.rpt / timing_synth.rpt / vivado.log / vivado.jou / wrap SV / plant SV / svh / tcl / clk50_btn_idelay.xdc / btn_iodelay.xdc / led_iodelay.xdc / BTN_IOB.txt / BTN_IOBFF.txt / BTN_IDELAYE2.txt / BTN_IODELAY.txt / LED_IOB.txt / LED_IOBFF.txt / LED_IODELAY.txt / UART_IOB.txt / UART_IOBFF.txt / UART_IODELAY.txt / SHA manifests / PREREG / ACK / cited constraints/arty_a7_100.xdc / FAIL bag ASTRA-11-A09R7-BTN-IO-01 live timing_route.rpt + fail_r0/timing_route.rpt + btn_iodelay.xdc + SHA256.txt / prior LED-IO raw timing_route.rpt + SHA256.txt / prior UART-impl raw timing_route.rpt + SHA256.txt / 12-R6 SHA256.txt + RESULTS.md (NOT RESULTS.md of this bag as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_impl.ps1` / `run_impl.tcl` (would overwrite `vivado.log` / routed reports). Did not program the plugged board. Did not edit `docs/ASTRA/LOOP_STATE.json`. Did not generate a `.bit`. Did not retune FAIL bag `ASTRA-11-A09R7-BTN-IO-01`.

This process has **no independent `Get-FileHash`**. Hash check = (1) freeze-list strings vs opened `SHA256.txt` / `SHA256_POST.txt` / `SOURCE_HASHES.txt`, (2) overlapping DUT/SGD/A09/uart/FAIL-wrap/LED-wrap/UART-wrap/cite-XDC hashes vs `ASTRA-11-A09R7-BTN-IO-01/SHA256.txt`, `ASTRA-11-A09R7-LED-IO-01/SHA256.txt`, `ASTRA-11-A09R7-UART-IMPL-ROUTE-01/SHA256.txt`, `ASTRA-12-R6-LED-CANDIDATES-01/SHA256.txt`, and T0500Z / T0400Z / T0430Z / T0200Z freeze strings, (3) live wrap/XDC/PREREG/raw-report **content** vs PREREG/RESULTS quotes. Claimed SHA strings are **content-verified** against opened files, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R7-BTN-IDELAY-01/`

Top `a7ng_astra_11_a09r7_btn_idelay_wrap` (bag-local, **new named**) instance **`u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv`**. UART `u_rx` / `u_tx` from `rtl/board/uart_rx.sv` / `uart_tx.sv`. Wrap-level **IDELAYE2** on `btn[3:0]` (FIXED tap **31**, REFCLK **200 MHz**, `DELAY_SRC=IDATAIN`) plus **IDELAYCTRL** (`REFCLK=clk200`, `RST=~locked`, `IODELAY_GROUP=ASTRA_BTN_IDELAY`) then pad FFs `btn_q[3:0]` with `(* IOB = "TRUE" *)`. UART/LED pad FFs kept. Pin clock `CLK100MHZ` E3 period 10.000 ns. Pipe clock MMCM 100→50 + BUFG, generated `clk50u` period 20.000 ns (**real**, attributes P,G,A). IDELAYCTRL refclock MMCM 100→200 (`CLKOUT1_DIVIDE=5`) + BUFG, generated `clk200u` period 5.000 ns (**real**, attributes P,G,A). UART I/O timing reference `uart_io_vclk` period 20.000 ns (**virtual**, attribute V) with inherited UART `set_input_delay` / `set_output_delay` **max 2.000 min 0.500** and **`FALSE_PATH_HOLD_ASYNC_UART`**. LED outputs timed vs **related** `clk50u` with frozen `set_output_delay` **max 2.000 min 0.500**. BTN inputs timed vs **related** `clk50u` with frozen `set_input_delay` **max 2.000 min 0.500** and **`RELATED_CLK50U_NO_FALSE_PATH_HOLD`** (no `set_false_path` on `btn[*]`). Part `xc7a100tcsg324-1`. Mode **in-context** `synth_design` then `opt_design` / `place_design` / `route_design`. No bitstream.

Gate under review is **work-order ASTRA-11-A09R7-BTN-IDELAY-01 only** — one unknown (handoff):

> With **IDELAYE2** on BTN0–BTN3, tap **frozen in PREREG before impl** (do not invent after WHS), same pins D9/C9/B9/B8 and same 2.000/0.500 related-clock delays, after implement+route at 50 MHz, is Design Timing Summary **WHS ≥ 0 as well as WNS ≥ 0** — without a bitstream and without false-path on btn?

Parent after auditor **20260907T0500Z**: FAIL bag `ASTRA-11-A09R7-BTN-IO-01` **FAIL_LOOP** / **REJECT_PROMOTION**. P1: BTN pad hold `btn[*] → btn_q_reg[*]/D` vs clk50u Input Delay min 0.500, WHS=−2.068. New named bag. Do **not** retune 2.000/0.500 inside the FAIL bag. Do **not** `set_false_path` on `btn[*]`. Do **not** `set_false_path -hold` on BTN. Do not patch frozen A09-R2/uart. `phys_opt` exhausted. Board plugged. **PROGRAM=NO.** `PRODUCTION_TOP` stays UNKNOWN. ASTRA-13 BLOCKED.

**Not** Master ASTRA-11 fullchip close. **Not** ASTRA-13 board acceptance. **Not** freeze of `PRODUCTION_TOP`. **Not** FAIL-bag WNS=+0.452 WHS=−2.068 as this result. **Not** LED wrap WNS=+0.411 WHS=+0.027 as this result. **Not** A09R7 UART wrap WNS=+0.336 WHS=+0.104 as this result. **Not** HOLD wrap WNS=+0.115 WHS=+0.131 as this result (numeric coincidence hunt). **Not** 12-R6 LED table as this result.

Hunt (parent / work order / this dispatch):

1. Tap 31 frozen in PREREG **before** impl (timestamp vs `vivado.log`)? Not invented after WHS?
2. Quote raw DTS WNS and WHS. Claimed WNS=+0.574 WHS=+0.131 constraints met.
3. BTN pad hold path still related-clock (no `set_false_path` on `btn[*]`)? Quote `exceptions_route.rpt`.
4. Delays still 2.000/0.500? IDELAYE2=4 tap 31? IDELAYCTRL present?
5. FAIL bag not overwritten? Still WHS=−2.068 on disk? No `.bit`? `PRODUCTION_TOP` UNKNOWN?
6. Hash before impl including `.svh`?

Judged against:

1. Work order `.agents/handoff/ASTRA-11-A09R7-BTN-IDELAY-01.md` + PREREG: instantiate `a7ng_astra_09_r2_cand_ovf`; do **not** edit ASTRA-11-A09R7-BTN-IO-01 (keep fail_r0 + WHS=−2.068; do not retune 2.000/0.500 there); freeze IDELAYE2 tap + REFCLK **before** impl; keep 2.000/0.500; no `set_false_path` on btn; hash RTL+XDC+tcl before impl; impl+route at declared 50 MHz; quote routed Design State WNS **and** WHS; **FAIL if WHS<0**; one bounded tap experiment only if FAIL (new PREREG tap, not silent); still no bit; PROGRAM=NO; do not overwrite FAIL wrap WNS=+0.452 WHS=−2.068, LED wrap WNS=+0.411 WHS=+0.027, R7 UART wrap WNS=+0.336 WHS=+0.104, HOLD WNS=+0.115 WHS=+0.131, IOBFF WNS=+0.115 WHS=−4.915, I/O-delay WNS=+0.681, UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, A09 wrap WNS=+1.041, or wrap-route WNS=+5.733; do not close ASTRA-13, BOARD_PASS, LM06, Master F3; do not freeze `PRODUCTION_TOP`.
2. **Master ASTRA-11** (DAG: FULLCHIP-COFIT): whole-chip co-fit of the frozen SoC top (UART + MMCM + I/O + memory plant + production path together), not an isolated named BTN-IDELAY wrap with a fixture plant plus an inherited UART STA hold exception.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/LOOP_STATE.json`: *astra13=BLOCKED; program=false; production_top=UNKNOWN.* GSTACK_LOOP: ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate.
4. Auditor `20260907T0500Z`: BTN-IO **FAIL_LOOP** WHS=−2.068; P1 IDELAYE2 in a **new** bag; do not false-path btn; do not retune FAIL bag. Auditor `20260907T0400Z`: LED-IO **PASS_NARROW** WNS=+0.411 WHS=+0.027. This work order is **WNS ≥ 0 and WHS ≥ 0** under frozen tap 31 / delays 2.000/0.500 / related-clock BTN (not WNS-only).

**Master ASTRA-11 as a whole is not this bag’s close**, even if this wrapper’s routed WNS and WHS are ≥ 0 and IDELAYE2 packed.

Out of this bag’s close: freeze of `PRODUCTION_TOP`, silicon UART / silicon MMCM / silicon LED / silicon BTN / silicon IDELAY tap / silicon BRAM, `a7ng_axi_bram128` plant, bitstream, JTAG/COM12, LM06 language, Master ASTRA-09 production path, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, ASTRA-13 BOARD_PASS, wrap-route `arty_a7_astra_rtp_soc_top` WNS=+5.733 identity, A09R2 wrap WNS=+0.648 identity, leftover A09 wrap WNS=+1.041 identity, prior UART wrap WNS=+0.305 identity, prior I/O-delay wrap WNS=+0.681 identity, prior IOBFF wrap WNS=+0.115 WHS=−4.915 identity, prior HOLD wrap WNS=+0.115 WHS=+0.131 identity, A09R7 UART wrap WNS=+0.336 WHS=+0.104 identity, LED wrap WNS=+0.411 WHS=+0.027 identity, FAIL BTN-IO wrap WNS=+0.452 WHS=−2.068 identity, 12-R6 unique-12 table as this routed result, claim that UART IOB hold is now **physically MET**, claim that DTS WHS=+0.131 is BTN pad hold.

Frozen `a7ng_astra_09_r2_cand_ovf.sv` / `.svh`, leftover `a7ng_astra_09_integ_path.sv` / `.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `uart_rx.sv` / `uart_tx.sv`, F2R3/F2R4/F2R5, persist/R2/R3/R4 must remain **unpatched**. This wrap is a **new named** BTN-IDELAY impl/route wrapper. It must **instantiate** A09-R2, not copy the graph. It must **not** compile leftover A09 / `astra09_pipe` / `axi_bram128` / RTP SoC / R7 XSim wrap / prior UART impl wrap / prior LED-IO wrap / prior BTN-IO wrap as this top.

Prior bags `ASTRA-11-A09R7-BTN-IO-01`, `ASTRA-11-A09R7-LED-IO-01`, `ASTRA-11-A09R7-UART-IMPL-ROUTE-01`, `ASTRA-12-R6-LED-CANDIDATES-01`, `ASTRA-09-R7-UART-QUERY-REW-01`, `ASTRA-11-A09R3-UART-IOBFF-HOLD-01`, `ASTRA-11-A09R3-UART-IOBFF-01`, `ASTRA-11-A09R3-UART-IODELAY-01`, `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, `ASTRA-SOC-RTP-WRAP-ROUTE`, `ASTRA-09-R2-CAND-OVF-01` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`656000c9…203910a3`). `write_scope` = new bag + distinctly named BTN-IDELAY wrap that **instantiates** frozen `a7ng_astra_09_r2_cand_ovf` as `u_a09r2` with UART-class D10/A9 kept, LED LD4–LD7 H5/J5/T9/T10 kept, BTN0–BTN3 D9/C9/B9/B8 kept, BTN input delays **kept 2.000/0.500 vs clk50u**, and IDELAYE2+IDELAYCTRL on BTN with tap and REFCLK frozen in PREREG **before** impl. Do not edit ASTRA-11-A09R7-BTN-IO-01 (keep fail_r0 + WHS=−2.068). Do not edit LED-IO / UART-impl / 12-R6. Do not retune 2.000/0.500. Do not `set_false_path` on `btn[*]`. Frozen leftover A09 not compiled as DUT. A09-R2 DUT source not patched. `uart_rx`/`uart_tx` not patched. Prior bags not edited. `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, **ASTRA-11-A09R7-BTN-IO-01**, **ASTRA-11-A09R7-LED-IO-01**, **ASTRA-11-A09R7-UART-IMPL-ROUTE-01**, **ASTRA-12-R6-LED-CANDIDATES-01**, ASTRA-09-R7-UART-QUERY-REW-01, ASTRA-11-A09R3-UART-IOBFF-HOLD-01, ASTRA-11-A09R3-UART-IOBFF-01, ASTRA-11-A09R3-UART-IODELAY-01, ASTRA-11-A09R3-UART-IMPL-ROUTE-01, ASTRA-SOC-RTP-WRAP-UART-XSIM, ASTRA-09-R3-UART-XSIM-01, Master_ASTRA-10_whole_chip, production_top_identity, write_bitstream, silicon_UART, silicon_BTN, N64_INCOMP_repeat.

`run_impl.tcl` **renames** `write_bitstream` to abort (`astra_forbid_bit` → exit 1). `vivado.jou`: **no** `write_bitstream`, **no** `.bit`, **no** `program_hw` / `open_hw`. Compile list is pkg/query/sparse/SGD/**A09-R2**/uart_rx/uart_tx/bag plant/bag wrap only. Tcl forbids leftover A09 / `astra09_pipe` / RTP SoC / R7 XSim wrap / prior UART impl/IOdelay/IOBFF/HOLD wraps / **prior LED-IO wrap** / **prior BTN-IO wrap** / `axi_bram128`. Post-synth cell checks abort if leftover A09 cells exist.

Bag listing: **no** `.bit` / `.bin` / `.mcs`. Checkpoints are `ckpt/synth.dcp` and `ckpt/route.dcp` only. **No** `fail_r0/` (WHS≥0; no experiment required). **No** `PREREG_EXP.md` (bounded tap experiment **not run**; PREREG: only if WHS<0).

`vivado.log` grep for `write_bitstream`, `.bit`, `program_hw`, `open_hw`, `BOARD_PASS`: **no matches**. `PRODUCTION_TOP=UNKNOWN` at start (line 66) and DONE (line 1488).

Handoff base `5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1` MATCH ACK / CLOSEOUT.

---

### 1. Tap 31 frozen in PREREG **before** impl — MATCH; not invented after this bag’s WHS

PREREG (hashed in `SHA256.txt` CONFIG **before** impl) freezes:

```text
BTN_IDELAY_PRIMITIVE     = IDELAYE2
BTN_IDELAY_TYPE          = FIXED
BTN_IDELAY_VALUE         = 31
BTN_IDELAY_DELAY_SRC     = IDATAIN
BTN_IDELAY_REFCLK_MHZ    = 200.0
BTN_IDELAYCTRL           = YES
BTN_IODELAY_GROUP        = ASTRA_BTN_IDELAY
```

Rationale is the **FAIL-bag** residual (auditor T0500Z WHS=−2.068; need ≥2.068 ns extra min data delay) plus DS181/UG471 math at 200 MHz (31 × 78.125 ps = 2.422 ns typical). That uses a **prior** bag’s WHS, which is allowed. It is **not** fitted to a WHS this bag had not yet produced. Explicitly not picked: tap 0, mid tap 16, REFCLK 300/400 MHz, false-path on btn, retune of 2.000/0.500, `phys_opt` as the hold fix.

Wrap RTL (hashed **before** impl, `5fa1c354…e99b48ee`):

```text
localparam int unsigned BTN_IDELAY_VALUE = 31;
MMCME2_BASE #(.CLKOUT0_DIVIDE_F(20.0), .CLKOUT1_DIVIDE(5), ...)
IDELAYCTRL u_btn_idelayctrl (.RDY(idelay_rdy), .REFCLK(clk200), .RST(~locked));
IDELAYE2 #(.DELAY_SRC("IDATAIN"), .HIGH_PERFORMANCE_MODE("FALSE"),
           .IDELAY_TYPE("FIXED"), .IDELAY_VALUE(BTN_IDELAY_VALUE),
           .PIPE_SEL("FALSE"), .REFCLK_FREQUENCY(200.0), .SIGNAL_PATTERN("DATA"))
```

`HIGH_PERFORMANCE_MODE="FALSE"` MATCH PREREG (UART-hold sibling used TRUE; this freeze does **not** copy tap 16 or HP=TRUE). ACK `btn_idelaye2_frozen_before_impl.idelay_value = 31`. Tcl header and live `vivado.log` start banner print `BTN_IDELAY_VALUE=31` **before** `synth_design`.

**Timestamp order (authority):**

| Event | Stamp |
|-------|-------|
| `SHA256.txt` / `SOURCE_HASHES.txt` freeze BEFORE impl | **2026-09-07T04:48:09.8689055+07:00** (includes wrap, `btn_iodelay.xdc`, tcl, six `.svh`, PREREG, ACK) |
| `vivado.log` session start | **Mon Sep 7 04:48:11 2026** PID **46820** |
| Synth binds `IDELAY_VALUE` | `Parameter IDELAY_VALUE bound to: 31` (unisim IDELAYE2) |
| `timing_route.rpt` Date | **Mon Sep 7 04:52:55 2026** (first time this bag’s WHS exists) |
| `SHA256_POST.txt` AFTER impl | **2026-09-07T04:53:01.5024181+07:00** |

SHA freeze is **~2 s before** Vivado start and **~4 min 46 s before** the routed DTS. Tap 31 is in the hashed wrap/PREREG/ACK/tcl **before** that DTS. Not hash-after-scores theatre. Not a silent post-WHS tap edit.

`run_impl.ps1` writes SHA then launches Vivado (same pattern as T0500Z). PRE vs POST compiled RTL+XDC+tcl + transitive `.svh`: **identical strings**. Wrap `5fa1c354…` MATCH PRE and POST. `btn_iodelay.xdc` `61feabf3…` MATCH PRE and POST.

Hunt 1: **YES. TAP=31 frozen before impl. Not invented after this bag’s WHS.**

---

### 2. Raw routed WNS and WHS (authority) — MATCH claimed +0.574 / +0.131; constraints met

`timing_route.rpt` header:

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Mon Sep  7 04:52:55 2026
Command      : report_timing_summary -file .../ASTRA-11-A09R7-BTN-IDELAY-01/timing_route.rpt
Design       : a7ng_astra_11_a09r7_btn_idelay_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      0.574        0.000                      0                 8954        0.131        0.000                      0                 8952
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

Intra-clock table:

```text
  clk50u            0.574        0.000                      0                 7259        0.131        0.000                      0                 7259
```

Inter-clock table (hold columns **blank** — UART I/O hold excepted):

```text
uart_io_vclk  clk50u             19.270
clk50u        uart_io_vclk        7.313
```

clk50u path-group:

```text
Setup :            0  Failing Endpoints,  Worst Slack        0.574ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.131ns,  Total Violation        0.000ns
```

`check_timing` embedded in the same rpt: `no_output_delay (0)`, `partial_input_delay (0)`, `no_input_delay (4)` = `sw[*]` with false-path (MEDIUM). Verbose `check_timing.rpt` lists `sw[0]`…`sw[3]` only. **`btn[*]` is constrained.** LED ports are **not** in `no_output_delay`.

Worst **setup** path (clk50u intra, Slack MET 0.574 ns) — **intra-DUT**, not a recycled UART/LED number:

```text
Source  u_a09r2/pc2_reg[2][7]/C
Dest    u_a09r2/u_sgd/w_reg[19][1]/D
Requirement = 20.000 ns
Data Path Delay = 19.254 ns  (logic 10.243 / route 9.011)
Clock path includes E3 IBUF → MMCM CLKOUT0 → BUFG u_bufg50 → u_a09r2/clk
```

Worst **hold** path (clk50u intra, Slack MET 0.131 ns) — **not BTN pad hold**:

```text
Source  idelay_rdy_sync_reg[0]/C   (SLICE_X0Y187)
Dest    idelay_rdy_sync_reg[1]/D   (SLICE_X0Y187)
Path Type Hold (Min at Fast Process Corner)
Data Path Delay = 0.206 ns (logic 0.141 / route 0.065)
```

DTS WHS=+0.131 **is** the IDELAYCTRL RDY two-FF synchronizer. Implementer RESULTS **discloses** this. BTN pad hold is separately MET **+0.638** ns (`timing_btn_in.rpt`).

clk200u pulse-width: WPWS=+0.264 ns on `IDELAYCTRL/REFCLK` Max Period (required 5.264, actual 5.000) at `u_btn_idelayctrl` IDELAYCTRL_X0Y3. **MET.** Not a setup/hold fail. Confirms IDELAYCTRL is on the 200 MHz net.

`TIMING_EXTRACT.txt`: `WNS=0.574 TNS=0.000 WHS=0.131 THS=0.000 DESIGN_STATE=Routed`. `metrics.json` `"wns_ns": 0.574`, `"whs_ns": 0.131`, `"timing_constraints_met": true`, `"result": "PASS"`.

Clock network is **real**, not virtual: `clocks_route.rpt` Design State Routed:

```text
uart_io_vclk  20.000  V           {}
clk200u        5.000  P,G,A       {u_mmcm/CLKOUT1}
clk50u        20.000  P,G,A       {u_mmcm/CLKOUT0}
```

`clock_util_route.rpt`: BUFGCTRL used=**2** (`u_bufg50` fo=3630 on clk50u; `u_bufg200` fo=1 on clk200 → IDELAYCTRL), MMCM used=1. Pipe clock is not `create_clock -name virtual_*` on the DUT net.

`route_status.rpt`: nets with routing errors = **0**. Fully routed nets = 6205.

Hunt 2: **MATCH claim. Raw WNS=+0.574 ≥ 0. Raw WHS=+0.131 ≥ 0. All user specified timing constraints are met. Authority is this rpt, not RESULTS.md.**

**HOLD-wrap coincidence (adversary):** ASTRA-11-A09R3-UART-IOBFF-HOLD-01 also has DTS WHS=+0.131. That rpt is still Date **Sun Sep 6 23:33:11 2026**, Design `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`, WNS=0.115, TNS endpoints=**8601**. This bag is Date **04:52:55**, Design `a7ng_astra_11_a09r7_btn_idelay_wrap`, WNS=0.574, TNS endpoints=**8954**, worst hold = `idelay_rdy_sync_reg[0]→[1]` (cell does not exist on the HOLD wrap). **Not stolen.** Same 0.131 ns is 1 ps STA quantization on a different path.

This WNS is **not** LED wrap WNS=+0.411 (that bag still Date **Mon Sep 7 03:11:15 2026**, Design `a7ng_astra_11_a09r7_led_io_wrap`, WNS=0.411 WHS=0.027, TNS endpoints=8949). Endpoint delta vs FAIL bag 8953 → this 8954 is the extra IDELAYCTRL/rdy/clk200 related endpoint class.

This WNS is **not** UART wrap WNS=+0.336 (that bag still Date **Mon Sep 7 01:52:48 2026**, Design `a7ng_astra_11_a09r7_uart_impl_wrap`, WNS=0.336 WHS=0.104, TNS endpoints=8940).

This WNS is **not** FAIL BTN-IO wrap WNS=+0.452 (that bag still Date **Mon Sep 7 04:24:50 2026**, Design `a7ng_astra_11_a09r7_btn_io_wrap`, WNS=0.452 WHS=−2.068).

---

### 3. BTN pad hold still related-clock; no false-path on `btn[*]` — MATCH

`exceptions_route.rpt` Design State Routed (04:53:00), Design `a7ng_astra_11_a09r7_btn_idelay_wrap`. Entire exception table:

```text
Position  From                     Through  To                        Setup  Hold   Status
2         [get_ports {sw[*]}]      *        *                         false  false
8         [get_ports uart_txd_in]  *        *                         -      false
9         *                        *        [get_ports uart_rxd_out]  -      false
```

**No row on `btn[*]`.** No `set_false_path -hold` on BTN. UART hold remains excepted (`FALSE_PATH_HOLD_ASYNC_UART`). `sw[*]` remains false-pathed (not this unknown).

`clk50_btn_idelay.xdc` (hashed before impl): `set_false_path -from [get_ports {sw[*]}]` plus UART hold false-paths only. Comment: *btn[*] is timed. Do not false-path buttons.* `btn_iodelay.xdc`:

```tcl
set_input_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {btn[*]}]
set_input_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {btn[*]}]
```

`timing_btn_in.rpt` Design State Routed (04:53:00), command `report_timing -from [get_ports {btn[*]}] -delay_type min_max`. Four **hold MET** endpoints, all related `clk50u` (source = input port clocked by clk50u; dest = `btn_q_reg[*]` clocked by clk50u):

| Port | Pin | Dest | Hold slack | Setup slack | IDELAY site |
|------|-----|------|------------|-------------|-------------|
| btn[0] | D9 | `btn_q_reg[0]` ILOGIC_X0Y187 | **+0.638** | 15.514 | IDELAY_X0Y187 |
| btn[2] | B9 | `btn_q_reg[2]` ILOGIC_X0Y177 | +0.679 | 15.479 | IDELAY_X0Y177 |
| btn[1] | C9 | `btn_q_reg[1]` ILOGIC_X0Y178 | +0.681 | 15.477 | IDELAY_X0Y178 |
| btn[3] | B8 | `btn_q_reg[3]` ILOGIC_X0Y176 | +0.699 | 15.459 | IDELAY_X0Y176 |

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

FAIL-bag same skew family with data=1.417 IBUF-only → WHS=−2.068. This bag adds IDELAYE2 **2.707 ns** on that path (slow-corner; typical 31×78.125 ps = 2.422 ns). −2.068 + 2.707 = +0.639 ≈ +0.638 (1 ps). Setup remains ≫ 0 (FAIL-bag BTN setup was +18.616; this bag +15.459 with Input Delay max=2.000).

LED hold remains MET **+2.927** ns (`timing_led_out.rpt`, Output Delay=0.500 vs clk50u, dest `led[1]` J5). UART I/O hold columns remain blank because of positions 8–9.

Hunt 3: **YES. Related-clock. false-path-btn = NO. BTN pad hold MET +0.638 (not excepted).**

---

### 4. Delays still 2.000/0.500; IDELAYE2=4 tap 31; IDELAYCTRL present — MATCH

`btn_iodelay.xdc` still max 2.000 min 0.500 vs clk50u (KEEP from FAIL bag; not retuned). FAIL bag `ASTRA-11-A09R7-BTN-IO-01/btn_iodelay.xdc` **still** the same two `set_input_delay` lines (not overwritten). `led_iodelay.xdc` still 2.000/0.500 vs clk50u. UART envelope in `clk50_btn_idelay.xdc` still 2.000/0.500 + hold false-path on UART ports only.

Post-synth apply (raw `vivado.log`):

```text
BTN_IODELAY_APPLIED clk50u PERIOD=20.000 MAX=2.000 MIN=0.500
BTN_IDELAYE2_CELLS=4
BTN_IDELAYCTRL_CELLS=1
```

Synth parameter bind:

```text
Parameter DELAY_SRC bound to: IDATAIN
Parameter HIGH_PERFORMANCE_MODE bound to: FALSE
Parameter IDELAY_TYPE bound to: FIXED
Parameter IDELAY_VALUE bound to: 31
Parameter REFCLK_FREQUENCY bound to: 2.000000e+02
Parameter SIGNAL_PATTERN bound to: DATA
```

`BTN_IDELAYE2.txt`:

```text
BTN_IDELAY_VALUE_PREREG=31
IDELAYE2_CELLS=4
IDELAYE2_TAP31_CELLS=4
IDELAYCTRL_CELLS=1
IDELAYE2_CELL=g_btn_idelay[0].u_idelay IDELAY_VALUE=31 IDELAY_TYPE=FIXED REFCLK_FREQUENCY=200.000
IDELAYE2_CELL=g_btn_idelay[1].u_idelay IDELAY_VALUE=31 IDELAY_TYPE=FIXED REFCLK_FREQUENCY=200.000
IDELAYE2_CELL=g_btn_idelay[2].u_idelay IDELAY_VALUE=31 IDELAY_TYPE=FIXED REFCLK_FREQUENCY=200.000
IDELAYE2_CELL=g_btn_idelay[3].u_idelay IDELAY_VALUE=31 IDELAY_TYPE=FIXED REFCLK_FREQUENCY=200.000
IDELAYCTRL_CELL=u_btn_idelayctrl
```

`util_route.rpt` Design State Routed:

```text
| IDELAYCTRL                  |    1 |     0 | ... |         6 | 16.67 |
| IDELAYE2/IDELAYE2_FINEDELAY |    4 |     4 | ... |       300 |  1.33 |
|   IDELAYE2 only             |    4 |
| IOB Flip Flops              |   10 |
| ILOGIC                      |    5 |
| OLOGIC                      |    5 |
```

All four IDELAYE2 are **Fixed** (packed into IDELAY sites colocated with ILOGIC: IDELAY_X0Y187 with ILOGIC_X0Y187 for btn[0], and similarly Y178/Y177/Y176). IDELAYCTRL present at IDELAYCTRL_X0Y3, REFCLK=`clk200` (BUFG `u_bufg200`), RST=`~locked` in RTL.

`BTN_IODELAY.txt`: `BTN_IN_MAX_NS=2.000 BTN_IN_MIN_NS=0.500 BTN_CLK_REF=clk50u BTN_HOLD_POLICY=RELATED_CLK50U_NO_FALSE_PATH_HOLD BTN_IN_HOLD_SLACK=0.638`.

Hunt 4: **YES. Delays 2.000/0.500 kept. IDELAYE2=4 tap 31. IDELAYCTRL=1.**

---

### 5. FAIL bag not overwritten; still WHS=−2.068; no `.bit`; PRODUCTION_TOP UNKNOWN — MATCH

Live FAIL bag `ASTRA-11-A09R7-BTN-IO-01/timing_route.rpt`:

```text
Date         : Mon Sep  7 04:24:50 2026
Design       : a7ng_astra_11_a09r7_btn_io_wrap
Design State : Routed
WNS=0.452  TNS=0.000  WHS=-2.068  THS=-8.128  THS Failing Endpoints=4
Timing constraints are not met.
```

`fail_r0/timing_route.rpt`: same Date **04:24:50**, same Design, same DTS **WNS=0.452 WHS=−2.068 THS=−8.128**. `fail_r0/` still present. FAIL `btn_iodelay.xdc` still 2.000/0.500. FAIL wrap SHA `52e1b4f2…3eec6132` MATCH this bag’s KEEP list **and** FAIL `SHA256.txt` (freeze **2026-09-07T04:20:01.2603642+07:00**). FAIL XDC SHA `7d84834c…3239b7c9` MATCH KEEP.

This IDELAY bag did **not** retune the FAIL bag. Did **not** copy TAP=31 back into the FAIL wrap (FAIL wrap has **no** IDELAYE2).

Live LED bag **not overwritten**: `timing_route.rpt` still Date **03:11:15**, Design `a7ng_astra_11_a09r7_led_io_wrap`, WNS=0.411 WHS=0.027. LED wrap SHA `7bb960c0…77d6e7c` MATCH KEEP and LED `SHA256.txt` (freeze **03:06:25.2550197+07:00**) and 12-R6 cited hash of the same wrap. LED `clk50_led_io.xdc` `48558c4a…` MATCH KEEP.

Live UART impl **not overwritten**: `timing_route.rpt` still Date **01:52:48**, WNS=0.336 WHS=0.104. Wrap SHA `d1f66a54…08644bde` MATCH KEEP.

Live 12-R6 **not overwritten**: `SHA256.txt` still *Tabled 2026-09-07T03:32:14+07:00*, `PRODUCTION_TOP=UNKNOWN`, unique **12**, `RESULT=PASS_NARROW`. ACK hash `c1187d8a…e28c4cfb` MATCH T0430Z.

Live HOLD bag **not overwritten**: Date **Sun Sep 6 23:33:11 2026**, WNS=0.115 WHS=0.131, TNS endpoints=8601.

This bag listing: no `.bit` / `.bin` / `.mcs`. `ckpt/` = `synth.dcp` + `route.dcp` only. `vivado.jou`: no `write_bitstream`, no `program_hw`, no `open_hw`. Tcl renames `write_bitstream` to abort. ACK / PREREG / RESULTS / CLOSEOUT / metrics / DONE line: `PRODUCTION_TOP=UNKNOWN`, `BIT=NOT_BUILT`, `PROGRAM=NO`. RESULTS: *Not BOARD_PASS. Not BTN-IO wrap WNS=+0.452 WHS=-2.068. Not LED wrap WNS=+0.411. Not R7 UART wrap WNS=+0.336. Not 12-R6 LED table.*

Hunt 5: **YES. FAIL bag still WHS=−2.068 on disk. No bitstream. PRODUCTION_TOP UNKNOWN. No BOARD_PASS overclaim. No mixing this WNS=+0.574 with LED +0.411 / UART +0.336 / FAIL +0.452 / HOLD +0.131.**

---

### 6. Hash before impl including `.svh`; A09-R2 instantiated — MATCH

`synth_design -top a7ng_astra_11_a09r7_btn_idelay_wrap -part xc7a100tcsg324-1` (in-context). `vivado.log` synthesizing: wrap → IDELAYE2 → MMCME2_BASE → BUFG → **IDELAYCTRL** → uart_rx → uart_tx → **`a7ng_astra_09_r2_cand_ovf`** → bag plant. `U_A09R2_CELLS=11063`. Wrap SV line 198: `a7ng_astra_09_r2_cand_ovf u_a09r2 (`. `load_v_i` tied 0. Plant is bag-local `a7ng_astra_11_a09r7_btn_idelay_plant` (fixture; hier LUT=171 FF=73 BRAM=0), **not** `a7ng_axi_bram128`.

**Not synthesized:** `a7ng_astra_09_integ_path`, `a7ng_astra09_pipe`, `arty_a7_astra_rtp_soc_top`, `a7ng_axi_bram128`, `a7ng_astra_11_a09r7_btn_io_wrap`, `a7ng_astra_11_a09r7_led_io_wrap`, `a7ng_astra_11_a09r7_uart_impl_wrap`.

PRE vs POST compiled RTL+XDC+tcl + transitive `.svh`: **identical strings**. R2 DUT freeze `15a919f1…8b70ee23` MATCH PRE and POST and T0500Z/T0400Z. Frozen leftover A09 `9fdbe0d6…bb5c776c` MATCH provenance (KEEP; **not compiled**). Frozen SGD `b66ef328…5fc67aac` MATCH. `uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH. Bag wrap `5fa1c354…` MATCH PRE/POST. `.svh` **is** in the pre-impl freeze (R2 contract `feaed571…` + leftover A09 header + lexica + crc + bag `a7ng_astra_11_a09r7_btn_idelay.svh` `328e3c39…`). Six TRANSITIVE_INCLUDES.

Cited `constraints/arty_a7_100.xdc` SHA `1c12e6f8943261c7089984a3725642043d027b813549433b8256843227b6a9c2` MATCH KEEP (cite, not compiled as the impl XDC).

Hunt 6: **YES. Hash-before-impl includes `.svh`. PRE=POST. Frozen R2 instantiated not copied.**

---

### Pins / IOB / IDELAY pack (supporting, not a substitute for hunt 2)

Cited clone pinout `constraints/arty_a7_100.xdc` BTN D9/C9/B9/B8, LED H5/J5/T9/T10, UART A9/D10. `io.rpt` Design State Routed, Total User IO=15:

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

BTN IOB FF pack (`BTN_IOBFF.txt`): 4/4 `btn_q_reg[*]` BEL=ILOGICE2.IFF IOB=TRUE PACKED=YES (same ILOGIC sites as FAIL bag). LED IOB FF 4/4 OLOGICE2.OUTFF. UART IOB FF YES (`uart_rx_iob_reg` ILOGIC_X0Y171; `uart_tx_iob_reg` OLOGIC_X0Y161). Split: 4 BTN ILOGIC + 1 UART RX ILOGIC; 4 LED OLOGIC + 1 UART TX OLOGIC. IDELAYE2 sits **between** IBUF and the IOB FF (`btn` → IBUF → IDELAYE2 DATAOUT=`btn_dly` → `btn_q`).

---

## Resources (raw; not the WNS quote)

Quoted **synth** `util_synth.rpt` Design State Synthesized (`UTIL_EXTRACT_SYNTH.txt`): Slice LUTs **5795**, Slice Registers **5094**, BRAM **0**, DSP **2**, IDELAYCTRL **1**, IDELAYE2 **4**.

Quoted **routed** `util_route.rpt` Design State Routed:

```text
| Slice LUTs              | 4947 |     63400 |  7.80 |
| Slice Registers         | 3616 |    126800 |  2.85 |
| Block RAM Tile          |    0 |
| DSPs                    |    2 |       240 |  0.83 |
| Bonded IOB              |   15 |       210 |  7.14 |
| IOB Flip Flops          |   10 |
| ILOGIC                  |    5 |
| OLOGIC                  |    5 |
| IDELAYCTRL              |    1 |
| IDELAYE2                |    4 |
```

Hierarchical routed (`util_hier_route.rpt`): **`u_a09r2` LUT=4324 FF=2738 DSP=2**. Plant LUT=171 FF=73. Honest occupancy of a live R2 DUT, **not** a stub. Fixture plant BRAM=0 is honest. Do not add 4947 to LED wrap 4945 / UART wrap 4945 / FAIL wrap 4944 as a chip sum. DSP=2 is the frozen SGD (native-graph wrap class); a7-fpga-gate DSP=0 is the EAM03E law and is **not** this unknown.

---

## Classification vs work-order unknown

| Question | Answer |
|----------|--------|
| Work-order unknown | WNS ≥ 0 **and** WHS ≥ 0 after impl+route of named BTN-IDELAY wrap with IDELAYE2 tap **frozen before impl**, cited BTN pins, frozen delays 2.000/0.500 vs clk50u, **no** false-path on btn, no bitstream |
| Raw WNS ≥ 0? | **YES** +0.574 |
| Raw WHS ≥ 0? | **YES** +0.131 |
| All constraints met? | **YES** (*All user specified timing constraints are met.*) |
| TAP=31 before impl? | **YES** (SHA 04:48:09 < Vivado 04:48:11 < DTS 04:52:55) |
| false-path-btn? | **NO** |
| Delays retuned? | **NO** (still 2.000/0.500; FAIL bag still 2.000/0.500) |
| IDELAYE2=4 tap 31 + IDELAYCTRL? | **YES** |
| FAIL bag still WHS=−2.068? | **YES** |
| PASS of this unknown (bag-local)? | **YES** (implementer tagged PASS this bag only; raw DTS MATCH) |
| PASS of Master ASTRA-11 / ASTRA-13? | **NO** |
| PASS_NARROW (isolated named wrap; UART hold excepted; fixture plant; DTS WHS ≠ BTN pad)? | **YES** — same grade class as T0400Z LED-IO when that unknown was met |
| OVERCLAIM (hide WHS / BOARD_PASS / steal LED +0.411 / steal HOLD +0.131 / false-path btn)? | **NO** |
| FAIL of this unknown? | **NO** |

---

## Overclaim hunts (adversary)

| Hunt | Result |
|------|--------|
| Invent TAP after seeing this bag’s WHS | **NO.** SHA 04:48:09 / wrap localparam 31 / PREREG / ACK / tcl / synth bind 31 all precede DTS 04:52:55. |
| Recycle FAIL WNS=+0.452 / WHS=−2.068 as this bag | **NO.** Different top, date, PID, WNS, WHS, IDELAYE2 present here / absent there. FAIL raw rpt intact. |
| Recycle LED wrap WNS=+0.411 / WHS=+0.027 | **NO.** LED raw rpt intact 03:11:15. |
| Recycle UART wrap WNS=+0.336 / WHS=+0.104 | **NO.** UART raw rpt intact 01:52:48. |
| Recycle HOLD wrap WHS=+0.131 as this DTS WHS | **NO.** HOLD rpt Date 23:33:11 Design `…iobff_hold_wrap` WNS=0.115 endpoints=8601. This worst hold is `idelay_rdy_sync` on this wrap. |
| Recycle wrap-route WNS=+5.733 / A09R2 +0.648 / A09 +1.041 / UART +0.305 / IOdelay +0.681 / IOBFF −4.915 | **NO.** ACK/PREREG/RESULTS name those as not-this-result. Different Design name. |
| `set_false_path` on `btn[*]` to make WHS tautological | **NO.** `exceptions_route.rpt` has no btn row. `timing_btn_in.rpt` related-clock hold MET +0.638 with Input Delay min 0.500. |
| Retune 2.000/0.500 in this bag or the FAIL bag | **NO.** Both `btn_iodelay.xdc` files still 2.000/0.500. FAIL DTS still WHS=−2.068. |
| BOARD_PASS / ASTRA-13 / LM06 / silicon BTN / silicon IDELAY tap | **NO.** BIT=NOT_BUILT PROGRAM=NO. Plant fixture. |
| Silent `PRODUCTION_TOP` freeze | **NO.** UNKNOWN in ACK/PREREG/RESULTS/CLOSEOUT/metrics/vivado DONE. |
| Claim DTS WHS=+0.131 is BTN pad hold or UART I/O hold physically MET | Implementer RESULTS **discloses** intra-clk50u `idelay_rdy_sync` vs BTN pad +0.638 vs UART hold excepted. **Not an overclaim in RESULTS.** Must stay disclosed. |
| Compile leftover A09 / `axi_bram128` / prior BTN-IO wrap as this top | **NO** in `vivado.log` synth list. |
| Virtual pipe clock | **NO.** `clk50u` P,G,A; BUFG used; SCD included. `clk200u` P,G,A for IDELAYCTRL. |
| Edit FAIL / LED / UART / 12-R6 / frozen RTL | **NO** on opened timestamps/hashes. |

**No Master-gate overclaim found.** Implementer `RESULT=PASS (this bag only)` is the work-order unknown, not a Master 11/13 close.

---

## This bag vs Master ASTRA-11 / ASTRA-13

| Master item | This bag |
|---|---|
| ASTRA-11 FULLCHIP-COFIT (UART + MMCM + I/O + AXI BRAM/DDR plant + production path as one frozen top) | Named BTN-IDELAY wrap + MMCM/BUFG 50+200 + D10/A9 UART IOB + LED H5/J5/T9/T10 IOB + BTN D9/C9/B9/B8 IOB + IDELAYE2 tap 31 + IDELAYCTRL + IOB FFs + fixture AXI plant + inherited UART STA hold exception. No `axi_bram128`. No DDR. `PRODUCTION_TOP=UNKNOWN` |
| ASTRA-11-A09R7-BTN-IO-01 WNS=+0.452 WHS=−2.068 | Different wrap (**no** IDELAYE2); bag **not** overwritten; fail_r0 kept; this WNS=+0.574 WHS=+0.131 is **not** that number |
| ASTRA-11-A09R7-LED-IO-01 WNS=+0.411 WHS=+0.027 | Different wrap; bag **not** overwritten |
| ASTRA-11-A09R7-UART-IMPL-ROUTE-01 WNS=+0.336 WHS=+0.104 | Different wrap; bag **not** overwritten |
| ASTRA-12-R6 unique 12 | Different class (table); bag **not** overwritten |
| ASTRA-11-A09R3-UART-IOBFF-HOLD-01 WNS=+0.115 WHS=+0.131 | Different wrap / different path; bag not overwritten; **numeric WHS coincidence only** |
| ASTRA-11-A09R3-UART-IOBFF-01 WNS=+0.115 WHS=−4.915 | Different wrap; bag not overwritten; UART I/O hold still VIOLATED on that bag |
| ASTRA-11-A09R3-UART-IODELAY-01 WNS=+0.681 | Different wrap (UART IDELAY TAP=16 class, not BTN TAP=31); bag not overwritten |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 WNS=+0.305 | Different wrap; bag not overwritten |
| ASTRA-11-A09R2-IMPL-ROUTE-01 WNS=+0.648 | Different wrap; bag not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041 | Different DUT `a7ng_astra_09_integ_path`; bag not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733 | Different top `arty_a7_astra_rtp_soc_top`; bag not overwritten |
| ASTRA-13 FINAL-BOARD-ACCEPTANCE | BIT=NOT_BUILT; PROGRAM=NO; no JTAG/COM12; `PRODUCTION_TOP=UNKNOWN` |
| LM06 language | Not opened |

Master **ASTRA-11 FULLCHIP-COFIT** remains **OPEN** (fixture plant, not frozen SoC top, UART I/O hold excepted not physically MET, this is an additive BTN-IDELAY wrap not a production top).

Master **ASTRA-13 FINAL-BOARD-ACCEPTANCE** remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority.

Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-10 whole-chip remain **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-11-A09R7-BTN-IDELAY-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw routed reports: instantiate-not-copy of `a7ng_astra_09_r2_cand_ovf`, frozen leftover A09 not compiled, FAIL BTN-IO wrap KEEP not this top, LED-IO wrap KEEP, UART impl wrap KEEP, hash-before-impl including `.svh`, TAP=**31** frozen in PREREG/wrap/ACK/tcl **before** impl (SHA 04:48:09 < Vivado 04:48:11 < DTS 04:52:55; not invented after this WHS), real clock-network (clk50u and clk200u P,G,A; not virtual), WNS=+0.574 ≥ 0, WHS=+0.131 ≥ 0 (intra-clk50u `idelay_rdy_sync`; **BTN pad hold MET +0.638** vs clk50u related Input Delay min 0.500; UART I/O hold excepted), *All user specified timing constraints are met*, IDELAYE2=**4** FIXED tap 31 + IDELAYCTRL=**1** REFCLK 200 MHz, BTN delays 2.000/0.500 vs clk50u **kept not retuned**, **no** `set_false_path` on `btn[*]`, BTN IOB D9/C9/B9/B8 FIXED matching cited clone XDC, BTN IOB FFs packed 4/4 after IDELAY, UART D10/A9 kept FIXED, LED H5/J5/T9/T10 kept FIXED, PROGRAM=NO, no bitstream, `PRODUCTION_TOP=UNKNOWN`, FAIL bag **still WHS=−2.068** with fail_r0 intact, prior LED-IO / UART-impl / 12-R6 / HOLD / IOBFF bags not overwritten, no BOARD_PASS / ASTRA-13 / LM06 overclaim, no theft of LED +0.411, UART +0.336, FAIL −2.068, HOLD +0.131, or wrap-route +5.733.

Not PASS (Master ASTRA-11 fullchip, ASTRA-13 board, silicon BTN/UART/IDELAY tap, `axi_bram128` plant, UART I/O hold physically MET, `PRODUCTION_TOP` freeze, DTS WHS as BTN-pad margin).  
Not FAIL (raw WNS/WHS match claim and both ≥ 0; tap frozen before impl; delays kept; related-clock BTN hold MET; IDELAYE2=4 + IDELAYCTRL=1; FAIL bag not retuned; route 0 error; frozen R2/SGD/leftover A09/uart unpatched; leftover A09 not compiled; clock path real).  
Not OVERCLAIM (ACK/RESULTS keep Master 11/13/BOARD/LM06/`PRODUCTION_TOP` open; disclose DTS WHS intra-clk50u vs BTN pad +0.638 vs UART hold excepted; do not steal FAIL −2.068, LED +0.411/+0.027, UART +0.336/+0.104, HOLD +0.115/+0.131, IOBFF −4.915, I/O-delay +0.681, UART wrap +0.305, A09R2 wrap +0.648, leftover A09 wrap +1.041, wrap-route +5.733, or 12-R6 unique 12).

Classification of hunt 2 in one line: **PASS_NARROW of “WNS≥0 AND WHS≥0 with TAP=31 frozen before impl, delays 2.000/0.500 kept, no false-path btn”; not OVERCLAIM.**

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared routed-WNS-and-WHS-at-50 MHz-with-IDELAYE2-tap-31-frozen-before-impl-and-BTN-delays-2.000/0.500-vs-clk50u-no-false-path-btn claim.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this WNS=+0.574 / WHS=+0.131 / TAP=31 / BTN_IOB=YES / BTN_IOBFF=YES / BTN_IDELAYE2=YES to BOARD_PASS, ASTRA-13, FAIL wrap WNS=+0.452 WHS=−2.068, LED wrap WNS=+0.411 WHS=+0.027, UART wrap WNS=+0.336 WHS=+0.104, HOLD wrap WNS=+0.115 WHS=+0.131, IOBFF WHS=−4.915, or `PRODUCTION_TOP=a7ng_astra_11_a09r7_btn_idelay_wrap`.
2. Do **not** claim DTS WHS=+0.131 is BTN pad hold. BTN pad hold is MET **+0.638** ns (Input Delay min 0.500 vs related clk50u, IDELAYE2 2.707 ns on the path). DTS WHS is intra-clk50u `idelay_rdy_sync_reg[0]→[1]`. Do not retune 0.500.
3. Do **not** claim UART IOB hold is physically MET. UART I/O hold vs `uart_io_vclk` remains excepted (`FALSE_PATH_HOLD_ASYNC_UART`). The −4.915 IOBFF bag must remain on disk.
4. Do **not** `set_false_path` on `btn[*]` in a later bag to “clean up” STA. Related-clock BTN hold is now MET without that cheat.
5. Do **not** retune frozen 2.000/0.500. Do **not** edit FAIL bag `ASTRA-11-A09R7-BTN-IO-01`. That `timing_route.rpt` must stay 04:24:50 Design `a7ng_astra_11_a09r7_btn_io_wrap` WNS=0.452 WHS=−2.068. `fail_r0/` must stay. Wrap hash must stay `52e1b4f2…`.
6. Do **not** edit ASTRA-11-A09R7-LED-IO-01. That `timing_route.rpt` must stay 03:11:15 WNS=0.411 WHS=0.027. Wrap hash must stay `7bb960c0…`.
7. Do **not** edit ASTRA-11-A09R7-UART-IMPL-ROUTE-01. That `timing_route.rpt` must stay 01:52:48 WNS=0.336 WHS=0.104. Wrap hash must stay `d1f66a54…`.
8. Do **not** rewrite ASTRA-12-R6-LED-CANDIDATES-01. Unique 12 and `PRODUCTION_TOP=UNKNOWN` stay.
9. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`. Routed IDELAYE2 tap **≠** silicon button delay (IDELAYCTRL RDY / tap calibration unproven on the board).
10. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv`, frozen A09-R2 (`15a919f1…`), frozen SGD (`b66ef328…`), or frozen `uart_rx` / `uart_tx` from this WHS=+0.131 or TAP=31.
11. Host parsers must not mix this wrap’s BTN IDELAY STA/IOB envelope with the FAIL BTN-IO wrap, LED wrap, R7 UART impl wrap, HOLD wrap, IOBFF wrap, or RTP SoC wrap as one frozen production top.
12. Do not add this LUT/FF to LED wrap / UART wrap / FAIL wrap as a whole-chip sum. Fixture plant BRAM=0 is honest. Whole-chip co-fit needs **one** current-source SoC top (Master ASTRA-11) plus an explicit `PRODUCTION_TOP` decision.

T0500Z P1 (BTN pad hold under frozen related-clock envelope, IDELAYE2 in a **new** bag, no false-path btn, no retune of FAIL 2.000/0.500): **CLOSED_NARROW this bag as evidence class.**

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated implement+route of a **new named BTN-IDELAY wrap** instantiating frozen `a7ng_astra_09_r2_cand_ovf` at declared 50 MHz with **real routed clock-network**, IDELAYE2 tap **31** / IDELAYCTRL REFCLK **200 MHz frozen before impl**, WNS=+0.574 ≥ 0, WHS=+0.131 ≥ 0 (intra-clk50u; BTN pad hold MET +0.638 vs clk50u; UART I/O hold excepted by inherited FALSE_PATH_HOLD_ASYNC_UART), delays 2.000/0.500 **kept**, **no** false-path on `btn[*]`, BTN IOB **D9/C9/B9/B8 INPUT FIXED** matching cited clone XDC, BTN IOB FFs **packed** after four IDELAYE2 cells, FAIL bag **untouched** WHS=−2.068, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`, leftover A09 not compiled, LED-IO / UART-impl / 12-R6 bags not overwritten.

`REJECT_PROMOTION` — Master **ASTRA-11** (fullchip co-fit / frozen SoC UART+LED+BTN top / on-chip plant), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. Routed BTN-IDELAY wrap **≠** silicon buttons. UART I/O hold excepted **≠** physically MET. DTS WHS=+0.131 **≠** BTN pad hold. FAIL wrap WHS=−2.068 **≠** this WHS=+0.131.

Not `FAIL_LOOP`: the declared unknown is met on raw routed reports.  
Not `ACCEPT_BOARD`: no bitstream, no silicon, `PRODUCTION_TOP=UNKNOWN`, ASTRA-13 BLOCKED.

Master ASTRA-09: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-12-R6-LED-CANDIDATES-01: **untouched, still PASS_NARROW unique 12, not this routed result**.  
ASTRA-11-A09R7-BTN-IO-01 routed WNS=+0.452 WHS=−2.068: **untouched, still FAIL_WHS evidence**.  
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
T0500Z residual (IDELAYE2 on BTN in a new named wrap, tap frozen before impl, not a silent freeze, not a FAIL-bag retune): **CLOSED_NARROW this bag as evidence class.**

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**. BTN IOB: **YES**. BTN IOB FF: **YES**. BTN IDELAYE2: **YES TAP=31**. IDELAYCTRL: **YES**. LED IOB: **YES**. UART IOB: **YES**. false-path-btn: **NO**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0530Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — TAP=31 WNS=+0.574 WHS=+0.131 — false-path-btn NO — BOARD blocked YES.
