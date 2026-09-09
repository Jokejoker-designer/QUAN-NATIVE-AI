# ASTRA auditor REPORT — 20260907T0400Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA11_A09R7_LED_IO_INDEPENDENT_AUDIT; astra11_led=IMPLEMENTER_CLAIM_WNS_P0411_WHS_P0027_PENDING_AUDITOR; astra07_mid=AUDITOR_PASS_NARROW_N64_INCOMP_ANS0; astra13=BLOCKED; production_top=UNKNOWN; production_top_freeze=NEEDS_OWNER_NOT_SILENT; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED; auditor=IN_PROGRESS
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-11 FULLCHIP-COFIT / ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-11-A09R7-LED-IO-01 + prior auditor 20260907T0330Z (ASTRA-07-SCALE-MID-01 N=64 INCOMP PASS_NARROW ACCEPT_PARTIAL; do not repeat N=64; ASTRA-13 BLOCKED; PRODUCTION_TOP=UNKNOWN; BOARD blocked YES) + T0200Z (A09R7 UART impl-route PASS_NARROW WNS=+0.336 WHS=+0.104 UART IOB YES FALSE_PATH_HOLD HONEST; LED I/O delay residual) + T1900 / T1830 / T1800 / T1730 / T1630
EVIDENCE   = raw timing_route.rpt / exceptions_route.rpt / timing_led_out.rpt / timing_uart_in.rpt / timing_uart_out.rpt / check_timing.rpt / io.rpt / clocks_route.rpt / clock_util_route.rpt / util_route.rpt / util_hier_route.rpt / route_status.rpt / ram_route.rpt / drc.rpt / util_synth.rpt / timing_synth.rpt / vivado.log / vivado.jou / wrap SV / plant SV / svh / tcl / clk50_led_io.xdc / led_iodelay.xdc / LED_IOB.txt / LED_IOBFF.txt / LED_IODELAY.txt / UART_IOB.txt / UART_IOBFF.txt / UART_IODELAY.txt / SHA manifests / PREREG / ACK / cited constraints/arty_a7_100.xdc / prior UART-impl raw timing_route.rpt + SHA256.txt + io.rpt + check_timing.rpt (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_impl.ps1` / `run_impl.tcl` (would overwrite `vivado.log` / routed reports). Did not program the plugged board. Did not edit `docs/ASTRA/LOOP_STATE.json`. Did not generate a `.bit`.

This process has **no independent `Get-FileHash`**. Hash check = (1) freeze-list strings vs opened `SHA256.txt` / `SHA256_POST.txt` / `SOURCE_HASHES.txt`, (2) overlapping DUT/SGD/A09/uart/UART-wrap/cite-XDC hashes vs `ASTRA-11-A09R7-UART-IMPL-ROUTE-01/SHA256.txt`, `ASTRA-09-R2-CAND-OVF-01/SHA256.txt`, `ASTRA-07-SCALE-MID-01/SHA256.txt`, and T0200Z / T0330Z freeze strings, (3) live wrap/XDC/PREREG/raw-report **content** vs PREREG/RESULTS quotes. Claimed SHA strings are **content-verified** against opened files, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R7-LED-IO-01/`

Top `a7ng_astra_11_a09r7_led_io_wrap` (bag-local, **new named**) instance **`u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv`**. UART `u_rx` / `u_tx` from `rtl/board/uart_rx.sv` / `uart_tx.sv`. Wrap-level pad FFs `uart_rx_iob` / `uart_tx_iob` / `led_q[3:0]` with `(* IOB = "TRUE" *)` plus XDC `set_property IOB TRUE` on UART **and** `led[*]`. Pin clock `CLK100MHZ` E3 period 10.000 ns. Pipe clock MMCM 100→50 + BUFG, generated `clk50u` period 20.000 ns (**real**, attributes P,G,A). UART I/O timing reference `uart_io_vclk` period 20.000 ns (**virtual**, attribute V) with frozen UART `set_input_delay` / `set_output_delay` **max 2.000 min 0.500** and **`FALSE_PATH_HOLD_ASYNC_UART`**. LED outputs timed vs **related** `clk50u` with frozen `set_output_delay` **max 2.000 min 0.500** and **`RELATED_CLK50U_NO_FALSE_PATH_HOLD`**. Part `xc7a100tcsg324-1`. Mode **in-context** `synth_design` (not `-mode out_of_context`) then `opt_design` / `place_design` / `route_design`. No bitstream.

Gate under review is **work-order ASTRA-11-A09R7-LED-IO-01 only** — one unknown (handoff):

> With LD4–LD7 mapped (Digilent Arty A7: H5/J5/T9/T10 unless a cited XDC in this clone already uses another set — then use that cited set) plus frozen LED I/O delays, after implement+route at 50 MHz, is WNS ≥ 0 and WHS ≥ 0 — without a bitstream?

Parent after auditor **20260907T0330Z**: scale-mid N=64 INCOMP CLOSED_NARROW. Residual that still fits impl (not 65536, not freeze): **LED I/O** on a new named wrap instantiating frozen A09-R2, Arty A7 LED pins, I/O delay frozen in PREREG, implement+route, no bitstream. `PRODUCTION_TOP` stays UNKNOWN. ASTRA-13 BLOCKED. Board plugged. **PROGRAM=NO.**

**Not** Master ASTRA-11 fullchip close. **Not** ASTRA-13 board acceptance. **Not** freeze of `PRODUCTION_TOP`. **Not** scale-mid N=64 as this routed result. **Not** A09R7 UART wrap WNS=+0.336 WHS=+0.104 as this result.

Hunt (parent / work order / this dispatch):

1. Quote WNS/WHS from RAW `timing_route.rpt` Design State=Routed. Claimed WNS=+0.411 WHS=+0.027.
2. LED IOB H5/J5/T9/T10 FIXED matching cited clone XDC? Delays 2.000/0.500 frozen before impl?
3. UART D10/A9 still present or dropped?
4. No `.bit`? `PRODUCTION_TOP` UNKNOWN? Not claiming A09R7 UART WNS=+0.336 as this result?
5. Hash before impl including `.svh`?

Confirm: frozen A09-R2 instantiated; ASTRA-11-A09R7-UART-IMPL-ROUTE-01 **not** overwritten; prior UART WNS bags **not** overwritten.

Judged against:

1. Work order `.agents/handoff/ASTRA-11-A09R7-LED-IO-01.md` + PREREG: instantiate `a7ng_astra_09_r2_cand_ovf`; do **not** edit ASTRA-11-A09R7-UART-IMPL-ROUTE-01 / scale-mid / frozen A09-R2; freeze LED pinout + delay numbers **before** impl; cite Arty A7 master XDC in this clone if present; UART D10/A9 may stay if UART-class wrap; hash RTL+XDC+tcl before impl; impl+route at declared 50 MHz; quote routed Design State WNS **and** WHS; LED IOB in `io.rpt`; FAIL if WNS<0 or WHS<0; PROGRAM=NO; do not overwrite R7 UART wrap WNS=+0.336 WHS=+0.104, HOLD WNS=+0.115 WHS=+0.131, IOBFF WNS=+0.115 WHS=−4.915, I/O-delay WNS=+0.681, UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, A09 wrap WNS=+1.041, or wrap-route WNS=+5.733; do not close ASTRA-13, BOARD_PASS, LM06, Master F3; do not freeze `PRODUCTION_TOP`.
2. **Master ASTRA-11** (DAG: FULLCHIP-COFIT): whole-chip co-fit of the frozen SoC top (UART + MMCM + I/O + memory plant + production path together), not an isolated named LED-IO wrap with a fixture plant plus an inherited UART STA hold exception.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/LOOP_STATE.json`: *astra13=BLOCKED; program=false; production_top=UNKNOWN.* `docs/ASTRA/PROJECT_PATHS.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.* GSTACK_LOOP: ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate.
4. Auditor `20260907T0330Z`: ASTRA-07-SCALE-MID-01 PASS_NARROW N=64 INCOMP ans=0; do not repeat N=64. Auditor `20260907T0200Z`: A09R7 UART impl-route PASS_NARROW WNS=+0.336 WHS=+0.104; UART IOB YES IOB FF packed; FALSE_PATH_HOLD HONEST; UART bag CLOSEOUT residual = LED I/O delay. a7-fpga-gate numeric: WNS ≥ 0; TNS = 0; **WHS/THS report; negative hold is a finding**.

**Master ASTRA-11 as a whole is not this bag’s close**, even if this wrapper’s routed WNS and DTS WHS are ≥ 0 and LED IOB FFs packed.

Out of this bag’s close: freeze of `PRODUCTION_TOP`, silicon UART / silicon MMCM / silicon LED / silicon BRAM, `a7ng_axi_bram128` plant, bitstream, JTAG/COM12, LM06 language, Master ASTRA-09 production path, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, ASTRA-13 BOARD_PASS, wrap-route `arty_a7_astra_rtp_soc_top` WNS=+5.733 identity, A09R2 wrap WNS=+0.648 identity, leftover A09 wrap WNS=+1.041 identity, prior UART wrap WNS=+0.305 identity, prior I/O-delay wrap WNS=+0.681 identity, prior IOBFF wrap WNS=+0.115 WHS=−4.915 identity, prior HOLD wrap WNS=+0.115 WHS=+0.131 identity, A09R7 UART wrap WNS=+0.336 WHS=+0.104 identity, scale-mid N=64 INCOMP as this routed result, claim that UART IOB hold is now **physically MET**, claim that DTS WHS=+0.027 is LED hold.

Frozen `a7ng_astra_09_r2_cand_ovf.sv` / `.svh`, leftover `a7ng_astra_09_integ_path.sv` / `.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `uart_rx.sv` / `uart_tx.sv`, F2R3/F2R4/F2R5, persist/R2/R3/R4 must remain **unpatched**. This wrap is a **new named** LED-IO impl/route wrapper. It must **instantiate** A09-R2, not copy the graph. It must **not** compile leftover A09 / `astra09_pipe` / `axi_bram128` / RTP SoC / R7 XSim wrap / prior UART impl wrap as this top.

Prior bags `ASTRA-11-A09R7-UART-IMPL-ROUTE-01`, `ASTRA-07-SCALE-MID-01`, `ASTRA-09-R7-UART-QUERY-REW-01`, `ASTRA-11-A09R3-UART-IOBFF-HOLD-01`, `ASTRA-11-A09R3-UART-IOBFF-01`, `ASTRA-11-A09R3-UART-IODELAY-01`, `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, `ASTRA-SOC-RTP-WRAP-ROUTE`, `ASTRA-09-R2-CAND-OVF-01` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`c2905cdb…e5744fb6`). `write_scope` = new bag + distinctly named LED-IO wrap that **instantiates** frozen `a7ng_astra_09_r2_cand_ovf` as `u_a09r2` with UART-class D10/A9 kept and LD4–LD7 LED pins plus LED I/O delays frozen in PREREG **before** impl (LED OUT max 2.000 min 0.500 vs pipe `clk50u`; UART envelope copied 2.000/0.500 + FALSE_PATH_HOLD_ASYNC_UART). Cited pinout `constraints/arty_a7_100.xdc` (Digilent Arty-A7-100-Master) H5/J5/T9/T10. Do not edit ASTRA-11-A09R7-UART-IMPL-ROUTE-01. Do not edit ASTRA-07-SCALE-MID-01. Frozen leftover A09 not compiled as DUT. A09-R2 DUT source not patched. `uart_rx`/`uart_tx` not patched. Prior bags not edited. `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, **ASTRA-07-SCALE-MID-01**, **ASTRA-11-A09R7-UART-IMPL-ROUTE-01**, ASTRA-09-R7-UART-QUERY-REW-01, ASTRA-11-A09R3-UART-IOBFF-HOLD-01, ASTRA-11-A09R3-UART-IOBFF-01, ASTRA-11-A09R3-UART-IODELAY-01, ASTRA-11-A09R3-UART-IMPL-ROUTE-01, ASTRA-SOC-RTP-WRAP-UART-XSIM, ASTRA-09-R3-UART-XSIM-01, Master_ASTRA-10_whole_chip, production_top_identity, write_bitstream, silicon_UART, N64_INCOMP_repeat.

`run_impl.tcl` **renames** `write_bitstream` to abort (`astra_forbid_bit` → exit 1). `vivado.jou`: **no** `write_bitstream`, **no** `.bit`, **no** `program_hw` / `open_hw`. Compile list is pkg/query/sparse/SGD/**A09-R2**/uart_rx/uart_tx/bag plant/bag wrap only. Tcl forbids leftover A09 / `astra09_pipe` / RTP SoC / R7 XSim wrap / prior UART impl/IOdelay/IOBFF/HOLD wraps / `axi_bram128`. Post-synth cell checks abort if leftover A09 / pipe / BRAM cells exist, or if `u_a09r2` / `u_rx` / `u_tx` cells are missing. LED IOB extract requires H5/J5/T9/T10 = `led[0:3]` in `io.rpt`. UART IOB extract requires A9=`uart_txd_in` and D10=`uart_rxd_out`.

Bag listing: **no** `.bit` / `.bin` / `.mcs`, no `fail_r0/`, no `FIRST_DIVERGENCE.txt`, no `timing_route_exp.rpt`. Checkpoints are `ckpt/synth.dcp` and `ckpt/route.dcp` only. Bounded WNS<0/WHS<0 experiment **not run** (DTS WNS ≥ 0 and WHS ≥ 0).

`vivado.log` grep for `write_bitstream`, `.bit`, `program_hw`, `open_hw`, `a7ng_astra_09_integ_path`, `a7ng_astra_11_a09r7_uart_impl_wrap`, `axi_bram128`, `BOARD_PASS`: **no matches**. `PRODUCTION_TOP=UNKNOWN` at start and DONE.

Handoff base `5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1` MATCH ACK / CLOSEOUT.

---

### 1. Raw routed WNS and WHS (authority) — MATCH claimed +0.411 / +0.027

`timing_route.rpt` header:

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Mon Sep  7 03:11:15 2026
Command      : report_timing_summary -file .../ASTRA-11-A09R7-LED-IO-01/timing_route.rpt
Design       : a7ng_astra_11_a09r7_led_io_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      0.411        0.000                      0                 8949        0.027        0.000                      0                 8947
All user specified timing constraints are met.
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
  clk50u            0.411        0.000                      0                 7254        0.027        0.000                      0                 7254
```

Inter-clock table (hold columns **blank**):

```text
uart_io_vclk  clk50u             19.270
clk50u        uart_io_vclk        7.313
```

`check_timing` embedded in the same rpt: `no_output_delay (0)`, `partial_output_delay (0)`, `no_input_delay (8)` = `sw[*]`/`btn[*]` with false-path (MEDIUM). LED ports are **not** in `no_output_delay`.

Worst **setup** path (clk50u intra, Slack MET 0.411 ns):

```text
Source  u_a09r2/FSM_sequential_st_reg[3]/C
Dest    u_a09r2/u_sgd/w_reg[24][2]/D
Requirement = 20.000 ns
Data Path Delay = 19.402 ns  (logic 10.274 / route 9.128)
Source Clock Delay = 6.235 ns
Destination Clock Delay = 5.889 ns
E3 IBUF → MMCME2_ADV_X1Y2 u_mmcm/CLKOUT0 → BUFGCTRL_X0Y16 u_bufg50/O → u_a09r2/clk (fo=3621)
```

Worst **hold** path (clk50u intra, Slack MET 0.027 ns):

```text
Source  u_a09r2/u_sp/u_walk/ntrunc_reg[2]/C
Dest    u_a09r2/u_sp/u_walk/n_trunc_o_reg[2]/D
Data Path Delay = 0.358 ns
```

**EVIDENCE:** claimed WNS=+0.411 / WHS=+0.027 MATCH raw Design Timing Summary, Design State=Routed, TNS=0, THS=0, failing endpoints=0. Authority is this rpt, not RESULTS.md.

**HONEST split (not a FAIL):** DTS WHS=+0.027 is **intra-clk50u DUT hold**, not LED hold and not UART I/O hold. LED hold is MET +2.927 ns (`timing_led_out.rpt`, Output Delay=0.500 vs clk50u). UART I/O hold columns are blank because of `FALSE_PATH_HOLD_ASYNC_UART` (inherited; `exceptions_route.rpt` positions 9–10). Do **not** promote WHS=+0.027 as “LED hold MET with 27 ps of LED pad margin.”

Clock network is **real**, not virtual: `clocks_route.rpt` Design State Routed: `clk50u` attributes **P,G,A** source `{u_mmcm/CLKOUT0}` master `sys_clk_pin`; `uart_io_vclk` attributes **V** sources `{}`. `clock_util_route.rpt`: BUFGCTRL used=1. Worst-path clock is E3 IBUF → MMCM → BUFG `u_bufg50`. Pipe clock is not `create_clock -name virtual_*` on the DUT net.

`route_status.rpt`: nets with routing errors = **0**. Fully routed nets = 6199.

This WNS is **not** A09R7 UART wrap WNS=+0.336 (that bag’s raw `timing_route.rpt` is still Date **Mon Sep 7 01:52:48 2026**, Design `a7ng_astra_11_a09r7_uart_impl_wrap`, WNS=0.336 WHS=0.104, TNS endpoints=8940 vs this bag 8949). Endpoint delta +9 is consistent with adding constrained LED output paths to a UART-class wrap.

---

### 2. LED IOB H5/J5/T9/T10 FIXED + delays 2.000/0.500 frozen before impl — MATCH cited clone XDC

**Cited clone pinout** `constraints/arty_a7_100.xdc` header: *Source: Digilent digilent-xdc / Arty-A7-100-Master.xdc (Rev. D and Rev. E).* Live lines:

```text
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; #IO_L24N_T3_35 Sch=led[4]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; #IO_25_35 Sch=led[5]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { led[2] }]; #IO_L24P_T3_A01_D17_14 Sch=led[6]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]; #IO_L24N_T3_A00_D16_14 Sch=led[7]
```

This clone’s master XDC has **no other LED set** (no `led0_b` / `led0_g` / G6 / E1 RGB block). Handoff: use H5/J5/T9/T10 unless a cited XDC in this clone already uses another set — **this is the cited set**. SHA `1c12e6f8943261c7089984a3725642043d027b813549433b8256843227b6a9c2` MATCH LED-bag KEEP list and ASTRA-12-R5 freeze of the same file. File is hashed as **cite**, not compiled as the impl XDC (`clk50_led_io.xdc` is the impl pin XDC).

Bag XDC `clk50_led_io.xdc` copies the same four PACKAGE_PIN lines. PREREG frozen **before** impl:

```text
LED[0]  = H5    LD4   Sch=led[4]   LVCMOS33
LED[1]  = J5    LD5   Sch=led[5]   LVCMOS33
LED[2]  = T9    LD6   Sch=led[6]   LVCMOS33
LED[3]  = T10   LD7   Sch=led[7]   LVCMOS33
LED_OUT_MAX_NS   = 2.000
LED_OUT_MIN_NS   = 0.500
LED_CLK_REF      = clk50u
LED_HOLD_POLICY  = RELATED_CLK50U_NO_FALSE_PATH_HOLD
```

`led_iodelay.xdc` (hashed in COMPILED list **before** impl):

```tcl
set_output_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {led[*]}]
set_output_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {led[*]}]
```

Hash order: `SHA256.txt` stamp **BEFORE impl** `2026-09-07T03:06:25.2550197+07:00` includes `led_iodelay.xdc` `9d25526c…49c8707` and `PREREG.md` `f9cc309d…baa892b6`. `vivado.log` session start **Mon Sep 7 03:06:26 2026** PID **19176** — one second after the freeze. `run_impl.ps1` writes SHA then launches Vivado. Delay numbers were **not** invented after seeing WNS.

Post-synth apply (raw `vivado.log`):

```text
Parsing XDC File .../led_iodelay.xdc
LED_IODELAY_APPLIED clk50u PERIOD=20.000 MAX=2.000 MIN=0.500
```

`clk50u` does not exist at pre-synth `read_xdc`; applying LED delays after synth when the generated clock exists is the frozen method, not a post-WNS retune.

`io.rpt` Command `report_io` Date **Mon Sep 7 03:11:19 2026**, Design `a7ng_astra_11_a09r7_led_io_wrap`, Device xc7a100t csg324:

```text
H5    led[0]        OUTPUT  LVCMOS33  FIXED
J5    led[1]        OUTPUT  LVCMOS33  FIXED
T9    led[2]        OUTPUT  LVCMOS33  FIXED
T10   led[3]        OUTPUT  LVCMOS33  FIXED
```

LED IOB FF pack (`LED_IOBFF.txt` / `util_route.rpt` Design State Routed):

```text
led_q_reg[0] BEL=OLOGICE2.OUTFF LOC=OLOGIC_X1Y101 PACKED=YES
led_q_reg[1] BEL=OLOGICE2.OUTFF LOC=OLOGIC_X1Y100 PACKED=YES
led_q_reg[2] BEL=OLOGICE2.OUTFF LOC=OLOGIC_X0Y52  PACKED=YES
led_q_reg[3] BEL=OLOGICE2.OUTFF LOC=OLOGIC_X0Y51  PACKED=YES
IOB Flip Flops = 6
ILOGIC = 1
OLOGIC = 5
```

Wrap SV: `(* IOB = "TRUE" *) logic [3:0] led_q` clocked by pipe `clk`; `assign led = led_q`. XDC `set_property IOB TRUE [get_ports {led[*]}]`.

LED path STA (`timing_led_out.rpt` Design State Routed):

```text
led_q_reg[3] → led[3]  Max/setup Slack (MET) 10.321 ns  Output Delay=2.000  dest T10 OBUF
led_q_reg[1] → led[1]  Min/hold  Slack (MET)  2.927 ns  Output Delay=0.500  dest J5  OBUF
```

Hold clock path on that LED hold path is the same real network: E3 IBUF → MMCM → BUFG `u_bufg50` → `led_q_reg[1]/C` in `OLOGIC_X1Y100`.

`exceptions_route.rpt` Design State Routed: false-path-hold exists for `uart_txd_in` / `uart_rxd_out` and false-path (setup+hold) for `sw[*]` / `btn[*]`. **No** `led[*]` exception. LED hold policy RELATED_CLK50U_NO_FALSE_PATH_HOLD is **honored**.

Prior UART bag residual (raw, not RESULTS): `ASTRA-11-A09R7-UART-IMPL-ROUTE-01/check_timing.rpt` `no_output_delay (4)` lists `led[0]`…`led[3]`. That bag **did** already pin-LOC H5/J5/T9/T10 FIXED in its `io.rpt` and `clk50_uart_impl.xdc`, but it had **no LED output delay** and **IOB Flip Flops=2** (UART only). Implementer phrase “left `led[0:3]` unconstrained” is **STA-correct** (no_output_delay HIGH on those four ports), not “pins missing.” This bag’s unknown is mapped pins **plus frozen LED delays 2.000/0.500 vs clk50u** plus LED IOB FF pack. `check_timing.rpt` this bag: `no_output_delay (0)`.

---

### 3. UART D10/A9 still present — MATCH (UART-class wrap; allowed)

Handoff: *UART D10/A9 may stay if the wrap is UART-class; add LEDs.* This wrap keeps UART.

`io.rpt`:

```text
A9    uart_txd_in   INPUT   LVCMOS33  FIXED
D10   uart_rxd_out  OUTPUT  LVCMOS33  FIXED
```

`clk50_led_io.xdc`: PACKAGE_PIN D10 / A9, UART delays 2.000/0.500 vs `uart_io_vclk`, `set_false_path -hold` on UART ports, `set_property IOB TRUE` on UART ports.

UART IOB FFs packed (`UART_IOBFF.txt`):

```text
uart_rx_iob_reg  ILOGICE2.IFF     ILOGIC_X0Y171  PACKED=YES
uart_tx_iob_reg  OLOGICE2.OUTFF   OLOGIC_X0Y161  PACKED=YES
```

`UART_IODELAY.txt`: IN setup 19.270 / OUT setup 7.313; IN/OUT hold slacks **blank**; `HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART`. Same class as T0200Z: DTS WHS is intra-clk50u, **not** physical UART I/O hold MET.

UART was **not** dropped. Not a finding.

---

### 4. No .bit / PRODUCTION_TOP UNKNOWN / not stealing UART WNS=+0.336 — MATCH

Bag listing: no `.bit` / `.bin` / `.mcs`. Checkpoints `ckpt/synth.dcp` + `ckpt/route.dcp` only.

`vivado.log`: Start Mon Sep 7 03:06:26 PID 19176; `synth_design -top a7ng_astra_11_a09r7_led_io_wrap -part xc7a100tcsg324-1`; `route_design completed successfully`; DONE line:

```text
ASTRA_11_A09R7_LED_IO_DONE WNS=0.411 TNS=0.000 WHS=0.027 LED_IOB=YES UART_IOB=YES UART_IOBFF=YES LED_IOBFF=YES BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN
```

Exit `Mon Sep 7 03:11:21 2026`. **No** `write_bitstream`. **No** `.bit`. **No** `program_hw`.

ACK / PREREG / RESULTS / CLOSEOUT / metrics.json: `PRODUCTION_TOP=UNKNOWN`, `BIT=NOT_BUILT`, `PROGRAM=NO`. RESULTS explicitly: *This is **not** ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed WNS=+0.336 WHS=+0.104.* Marker does not say BOARD_PASS / ASTRA-13 / LM06.

**UART bag not overwritten (raw):**

| Artifact | UART-impl bag still | This LED bag |
|----------|---------------------|--------------|
| `timing_route.rpt` Date | Mon Sep 7 **01:52:48** 2026 | Mon Sep 7 **03:11:15** 2026 |
| Design | `a7ng_astra_11_a09r7_uart_impl_wrap` | `a7ng_astra_11_a09r7_led_io_wrap` |
| DTS WNS/WHS | 0.336 / 0.104 | 0.411 / 0.027 |
| TNS endpoints | 8940 | 8949 |
| `vivado.log` | 01:47:47 PID **17968** | 03:06:26 PID **19176** |
| wrap SHA256 | `d1f66a54…08644bde` | `7bb960c0…a77d6e7c` |
| IOB Flip Flops | 2 | 6 |
| `no_output_delay` | 4 (`led[0:3]`) | 0 |

LED-bag KEEP hash of the UART wrap file is **the same** `d1f66a54…` as UART-bag COMPILED wrap hash. UART `clk50_uart_impl.xdc` KEEP `72004235…` MATCH UART bag. Scale-mid `xsim.log` still Start **Mon Sep 7 02:47:58 2026** PID **21092** snapshot `a07sm` (T0330Z identity). Frozen A09-R2 hash `15a919f1…8b70ee23` MATCH ASTRA-09-R2 / ASTRA-07-SCALE-MID / UART-impl bags.

---

### 5. Hash before impl including `.svh` — MATCH

`run_impl.ps1`: live-hash guards leftover A09 `9fdbe0d6…`, A09-R2 `15a919f1…`, SGD `b66ef328…`, `uart_rx` `8e802d0b…`, `uart_tx` `b4b7d097…` **then** writes `SHA256.txt` (COMPILED + TRANSITIVE_INCLUDES + CONFIG + KEEP + PROVENANCE) **then** copies `SOURCE_HASHES.txt` **then** launches Vivado. POST hashes compiled + `.svh` after impl.

`SOURCE_HASHES.txt` first line MATCH PRE stamp `2026-09-07T03:06:25.2550197+07:00`. `SHA256_POST.txt` stamp **AFTER impl** `2026-09-07T03:11:22.0254046+07:00` (matches log exit 03:11:21).

Compiled + transitive `.svh` PRE vs POST (opened manifests; not re-hashed): **22/22 MATCH**.

| Path | PRE / POST |
|------|------------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf98852…5aee57a6` |
| `rtl/native_graph/query/a7ng_query_struct_extract.sv` | `ede064f0…05496768` |
| `rtl/native_graph/query/a7ng_query_role_extract.sv` | `cd7baf49…cd83a9f27` |
| `rtl/native_graph/query/a7ng_route_valid_gate.sv` | `49a66da2…a1be3a385` |
| `rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` | `09334e42…a6c36bb24` |
| `rtl/native_graph/integrate/a7ng_query_axi_sparse.sv` | `5a4ad04d…b9b9c5c0fa` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef328…fc67aac` |
| `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv` | `15a919f1…8b70ee23` |
| `rtl/board/uart_rx.sv` | `8e802d0b…bcd5369a` |
| `rtl/board/uart_tx.sv` | `b4b7d097…1b36367b` |
| bag `a7ng_astra_11_a09r7_led_io_plant.sv` | `42e99ee8…d6c6bfb3` |
| bag `a7ng_astra_11_a09r7_led_io_wrap.sv` | `7bb960c0…a77d6e7c` |
| bag `clk50_led_io.xdc` | `48558c4a…32f8b78b` |
| bag `led_iodelay.xdc` | `9d25526c…49c8707` |
| bag `run_impl.tcl` | `72320e11…9478636087` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d3…e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `38189974…fa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9…49c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_09_integ_path.svh` | `ad2d66d4…fb4e94302` |
| `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.svh` | `feaed571…171afd329` |
| bag `a7ng_astra_11_a09r7_led_io.svh` | `4e1d8114…efcdf4729` |

`.svh` **is** in the pre-impl freeze (R2 contract, frozen A09 header, bag-local wrap header, lexica, CRC). PROGRAM=NO.

---

### DUT identity (raw `vivado.log`, not RESULTS)

Synthesized modules include `a7ng_astra_11_a09r7_led_io_wrap`, `MMCME2_BASE`, `a7ng_astra_09_r2_cand_ovf` from `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv`, `a7ng_astra_11_a09r7_led_io_plant`. **No** `synthesizing module 'a7ng_astra_09_integ_path'`. **No** `a7ng_astra_11_a09r7_uart_impl_wrap`. Markers `U_A09R2_CELLS=11063` `U_RX_CELLS=76` `LED_IOBFF_CELLS=4`.

Wrap instantiates `a7ng_astra_09_r2_cand_ovf u_a09r2` with `keep_hierarchy`. `load_v_i` tied 0. Plant is bag-local `a7ng_astra_11_a09r7_led_io_plant` (behavioral AXI fixture; comment *Not silicon BRAM. Not a7ng_axi_bram128*). Hierarchical routed util: **`u_a09r2` LUT=4326 FF=2738 DSP=2**; `u_plant` LUT=170 FF=73 RAMB=0; top LUT=4945 FF=3615 DSP=2 BRAM=0.

Prior R7 UART impl wrap KEEP hashed, **not compiled** as this top.

---

### Resources (raw `util_route.rpt` Design State Routed)

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **4945** | 63400 | 7.80 |
| Slice Registers (FF) | **3615** | 126800 | 2.85 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |
| Bonded IOB | **15** | 210 | 7.14 |
| IOB Flip Flops | **6** | | |
| ILOGIC | **1** | 210 | 0.48 |
| OLOGIC | **5** | 210 | 2.38 |

Do **not** add these LUT/FF to UART wrap 4945/3615 as a whole-chip sum. Slice LUT/FF matching the UART bag is expected: four LED FFs packed in IOB, not slice. The **physical** difference is IOB Flip Flops 2→6, `no_output_delay` 4→0, and a **new route** (WNS/WHS/endpoints/date/PID/top name all differ).

Synth util (`util_synth.rpt`) LUT=5792 FF=5089 is **not** the WNS quote.

---

## Hunt table

| # | Hunt | Result |
|---|------|--------|
| 1 | Raw `timing_route.rpt` Design State=Routed WNS/WHS vs claimed +0.411 / +0.027 | **MATCH.** WNS=0.411 TNS=0.000 WHS=0.027 THS=0.000. Intra clk50u same. Constraints met. Clock path real IBUF→MMCM→BUFG. |
| 2 | LED IOB H5/J5/T9/T10 FIXED matching cited clone XDC? Delays 2.000/0.500 frozen before impl? | **MATCH.** Cite `constraints/arty_a7_100.xdc` Sch=led[4:7] LD4–LD7. `io.rpt` FIXED. Delays in PREREG + `led_iodelay.xdc` hashed 03:06:25 before Vivado 03:06:26. Applied post-synth. LED hold not excepted. LED IOB FFs packed. |
| 3 | UART D10/A9 still present or dropped? | **PRESENT** (UART-class; allowed). A9 INPUT / D10 OUTPUT FIXED. UART IOB FFs packed. UART hold still excepted. |
| 4 | No `.bit`? `PRODUCTION_TOP` UNKNOWN? Not claiming UART WNS=+0.336 as this result? | **MATCH.** BIT=NOT_BUILT. `PRODUCTION_TOP=UNKNOWN`. UART bag timing still 01:52:48 WNS=0.336. No BOARD_PASS. |
| 5 | Hash before impl including `.svh`? | **MATCH.** Six `.svh` in TRANSITIVE_INCLUDES. PRE/POST compiled+svh 22/22 MATCH. |

---

## Overclaim hunts (adversary)

| Hunt | Result |
|------|--------|
| Recycle UART wrap WNS=+0.336 as this bag | **NO.** Different top, date, PID, WNS, WHS, endpoint count, wrap hash. UART raw rpt intact. |
| Recycle wrap-route WNS=+5.733 / A09R2 +0.648 / A09 +1.041 / UART +0.305 / IOdelay +0.681 / IOBFF −4.915 / HOLD +0.115/+0.131 | **NO.** ACK/PREREG/RESULTS name those as not-this-result. Different Design name. |
| BOARD_PASS / ASTRA-13 / LM06 / silicon LED | **NO.** BIT=NOT_BUILT PROGRAM=NO. Plant fixture. |
| Silent `PRODUCTION_TOP` freeze | **NO.** UNKNOWN in ACK/PREREG/RESULTS/CLOSEOUT/metrics/vivado DONE. |
| Claim DTS WHS=+0.027 is LED pad hold or UART I/O hold physically MET | Implementer RESULTS **discloses** intra-clk50u vs LED +2.927 vs UART hold excepted. **Not an overclaim in RESULTS.** Must stay disclosed. |
| Invent delay numbers after WNS | **NO.** PREREG + `led_iodelay.xdc` hashed before impl; numbers copied from repo 3.3 V CMOS class. |
| Edit UART-impl bag / scale-mid / frozen RTL | **NO** on opened timestamps/hashes. |
| Compile leftover A09 / `axi_bram128` / prior UART wrap as this top | **NO** in `vivado.log` synth list. |
| Virtual pipe clock | **NO.** `clk50u` P,G,A; BUFG used; SCD included. |
| Wrong LED set vs cited clone XDC | **NO.** Clone has only H5/J5/T9/T10 for `led[0:3]`. |
| Promote this as Master ASTRA-11 FULLCHIP-COFIT | ACK `does_not_close` includes it. Fixture plant BRAM=0. |

**No Master-gate overclaim found.**

---

## This bag vs Master ASTRA-11 / ASTRA-13

| Master item | This bag |
|---|---|
| ASTRA-11 FULLCHIP-COFIT (UART + MMCM + I/O + AXI BRAM/DDR plant + production path as one frozen top) | Named LED-IO wrap + MMCM/BUFG + D10/A9 UART IOB + LED H5/J5/T9/T10 IOB + IOB FFs + fixture AXI plant + inherited UART STA hold exception. No `axi_bram128`. No DDR. `PRODUCTION_TOP=UNKNOWN` |
| ASTRA-11-A09R7-UART-IMPL-ROUTE-01 WNS=+0.336 WHS=+0.104 | Different wrap (no LED delay / no LED IOB FF); bag **not** overwritten; this WNS=+0.411 WHS=+0.027 is **not** that number |
| ASTRA-07-SCALE-MID-01 N=64 INCOMP | Different class (XSim); bag **not** overwritten; not this routed result |
| ASTRA-11-A09R3-UART-IOBFF-HOLD-01 WNS=+0.115 WHS=+0.131 | Different wrap; bag not overwritten |
| ASTRA-11-A09R3-UART-IOBFF-01 WNS=+0.115 WHS=−4.915 | Different wrap; bag not overwritten; UART I/O hold still VIOLATED on that bag |
| ASTRA-11-A09R3-UART-IODELAY-01 WNS=+0.681 | Different wrap, no IOB FF; bag not overwritten |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 WNS=+0.305 | Different wrap; bag not overwritten |
| ASTRA-11-A09R2-IMPL-ROUTE-01 WNS=+0.648 | Different wrap, no UART; bag not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041 | Different DUT `a7ng_astra_09_integ_path`; bag not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733 | Different top `arty_a7_astra_rtp_soc_top`; bag not overwritten |
| ASTRA-13 FINAL-BOARD-ACCEPTANCE | BIT=NOT_BUILT; PROGRAM=NO; no JTAG/COM12; `PRODUCTION_TOP=UNKNOWN` |
| LM06 language | Not opened |

Master **ASTRA-11 FULLCHIP-COFIT** remains **OPEN** (fixture plant, not frozen SoC top, not wrap-route identity, UART I/O hold excepted not physically MET, this is an additive LED-IO wrap not a production top).

Master **ASTRA-13 FINAL-BOARD-ACCEPTANCE** remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority.

Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-10 whole-chip remain **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-11-A09R7-LED-IO-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw routed reports: instantiate-not-copy of `a7ng_astra_09_r2_cand_ovf`, frozen leftover A09 not compiled, R7 UART impl wrap KEEP not this top, hash-before-impl including `.svh`, real clock-network (not virtual), WNS=+0.411 ≥ 0, WHS=+0.027 ≥ 0 (intra-clk50u; LED hold MET +2.927 vs clk50u related; UART I/O hold excepted), LED IOB H5/J5/T9/T10 FIXED matching cited clone `constraints/arty_a7_100.xdc` LD4–LD7, LED IOB FFs packed, LED delays 2.000/0.500 vs clk50u frozen in PREREG before impl and applied post-synth, UART D10/A9 kept FIXED, PROGRAM=NO, no bitstream, `PRODUCTION_TOP=UNKNOWN`, prior UART-impl / scale-mid / HOLD / IOBFF / IOdelay / UART-impl-R3 / A09R2 wrap / leftover A09 wrap / wrap-route bags not overwritten, no BOARD_PASS / ASTRA-13 / LM06 overclaim, no theft of UART wrap +0.336 or wrap-route +5.733.

Not PASS (Master ASTRA-11 fullchip, ASTRA-13 board, silicon LED/UART, `axi_bram128` plant, UART I/O hold physically MET, `PRODUCTION_TOP` freeze, DTS WHS as LED-pad margin).  
Not FAIL (raw WNS/WHS match claim; LED IOB FIXED and LED IOB FFs packed; delays frozen before impl; route 0 error / 0 critical; frozen R2/SGD/leftover A09/uart unpatched; leftover A09 not compiled; clock path real; UART bag intact; cited pinout MATCH).  
Not OVERCLAIM (ACK/RESULTS keep Master 11/13/BOARD/LM06/`PRODUCTION_TOP` open; disclose DTS WHS intra-clk50u vs LED hold +2.927 vs UART hold excepted; do not steal UART wrap +0.336/+0.104, HOLD +0.115/+0.131, IOBFF −4.915, I/O-delay +0.681, UART wrap +0.305, A09R2 wrap +0.648, leftover A09 wrap +1.041, wrap-route +5.733, or scale-mid N=64).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared routed-WNS-and-WHS-at-50 MHz-with-LD4–LD7-H5/J5/T9/T10-and-frozen-LED-delays-2.000/0.500-vs-clk50u claim.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this WNS=+0.411 / WHS=+0.027 / LED_IOB=YES / LED_IOBFF=YES to BOARD_PASS, ASTRA-13, UART wrap WNS=+0.336 WHS=+0.104, HOLD wrap WNS=+0.115 WHS=+0.131, IOBFF WHS=−4.915, I/O-delay WNS=+0.681, UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, wrap-route WNS=+5.733, scale-mid N=64, or `PRODUCTION_TOP=a7ng_astra_11_a09r7_led_io_wrap`.
2. Do **not** claim DTS WHS=+0.027 is LED pad hold. LED hold is MET +2.927 ns (Output Delay min 0.500 vs related clk50u). DTS WHS is intra-clk50u `ntrunc_reg[2] → n_trunc_o_reg[2]` (27 ps — thin, still MET). Do not retune 0.500.
3. Do **not** claim UART IOB hold is physically MET. UART I/O hold vs `uart_io_vclk` remains excepted (`FALSE_PATH_HOLD_ASYNC_UART`). The −4.915 IOBFF bag must remain on disk.
4. Do **not** add this LUT/FF to UART wrap 4945/3615 as a whole-chip sum. Fixture plant BRAM=0 is honest. Whole-chip co-fit needs **one** current-source SoC top (Master ASTRA-11) plus an explicit `PRODUCTION_TOP` decision.
5. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
6. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv`, frozen A09-R2 (`15a919f1…`), frozen SGD (`b66ef328…`), or frozen `uart_rx` / `uart_tx` from thin WHS=+0.027 or DSP warnings.
7. Do **not** edit ASTRA-11-A09R7-UART-IMPL-ROUTE-01. That `timing_route.rpt` must stay 01:52:48 Design `a7ng_astra_11_a09r7_uart_impl_wrap` WNS=0.336 WHS=0.104. Wrap hash must stay `d1f66a54…`.
8. Do **not** repeat ASTRA-07-SCALE-MID-01 N=64. That `xsim.log` must stay 02:47:58 PID 21092.
9. Functional UART 8N1 / MAGIC A2 / inner w0=−5 remains T0130 XSim. Silicon LEDs remain unproven. This bag is physical route + LED IOB + LED STA envelope, not BOARD_PASS.
10. Host parsers must not mix this wrap’s LED STA/IOB envelope with the R7 UART impl wrap, HOLD wrap, IOBFF wrap, or RTP SoC wrap as one frozen production top.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated implement+route of a **new named LED-IO wrap** instantiating frozen `a7ng_astra_09_r2_cand_ovf` at declared 50 MHz with **real routed clock-network**, WNS=+0.411 ≥ 0, WHS=+0.027 ≥ 0 (intra-clk50u; LED hold MET +2.927 vs clk50u; UART I/O hold excepted by inherited FALSE_PATH_HOLD_ASYNC_UART), LED IOB **H5/J5/T9/T10 OUTPUT FIXED** matching cited clone XDC LD4–LD7, LED IOB FFs **packed**, LED delays 2.000/0.500 copied not invented and frozen before impl, UART D10/A9 **kept**, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`, leftover A09 not compiled, UART-impl bag not overwritten, scale-mid not repeated.

`REJECT_PROMOTION` — Master **ASTRA-11** (fullchip co-fit / frozen SoC UART+LED top / on-chip plant), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. Routed LED wrap **≠** silicon LEDs. UART I/O hold excepted **≠** physically MET. DTS WHS=+0.027 **≠** LED pad hold.

Master ASTRA-09: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-07-SCALE-MID-01: **untouched, still PASS_NARROW N=64 INCOMP, not this routed result**.  
ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed WNS=+0.336 WHS=+0.104: **untouched**.  
ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed WNS=+0.115 WHS=+0.131: **untouched**.  
ASTRA-11-A09R3-UART-IOBFF-01 routed WNS=+0.115 WHS=−4.915: **untouched**.  
ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681: **untouched**.  
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305: **untouched**.  
ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648: **untouched**.  
ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041: **untouched, different DUT**.  
ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733: **untouched, different top**.  
PRODUCTION_TOP: **UNKNOWN**.  
T0200Z residual (LED I/O delay on a new named wrap, not a silent freeze): **CLOSED_NARROW this bag as evidence class**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**. LED IOB: **YES**. UART IOB: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0400Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — WNS=+0.411 WHS=+0.027 — LED IOB YES — BOARD blocked YES.
