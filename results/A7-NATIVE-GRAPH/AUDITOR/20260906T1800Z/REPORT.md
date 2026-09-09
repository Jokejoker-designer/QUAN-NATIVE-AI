# ASTRA auditor REPORT — 20260906T1800Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA11_A09R3_UART_IODELAY_INDEPENDENT_AUDIT; astra11_a09r3=AUDITOR_PASS_NARROW_ROUTED_WNS_P0305_UART_IOB; astra11_iodelay=IMPLEMENTER_CLAIM_ROUTED_WNS_P0681_PENDING_AUDITOR; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-11 FULLCHIP-COFIT / ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-11-A09R3-UART-IODELAY-01 + prior auditor 20260906T1730Z (UART impl-route ACCEPT_PARTIAL PASS_NARROW WNS=+0.305 UART IOB A9/D10; residual 5 = UART I/O unconstrained — this bag is additive set_input_delay/set_output_delay on a new named wrap, not a patch of the +0.305 bag) + auditor 20260906T1700Z (UART XSim PASS_NARROW) + auditor 20260906T1630Z (A09R2 wrap-route WNS=+0.648; do not overwrite)
EVIDENCE   = raw timing_route.rpt / timing_uart_in.rpt / timing_uart_out.rpt / check_timing.rpt / io.rpt / clocks_route.rpt / clock_util_route.rpt / util_route.rpt / util_hier_route.rpt / route_status.rpt / ram_route.rpt / drc.rpt / util_synth.rpt / timing_synth.rpt / vivado.log / vivado.jou / wrap SV / plant SV / tcl / XDC / UART_IOB.txt / UART_IODELAY.txt / SHA manifests / PREREG / ACK (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_impl.ps1` / `run_impl.tcl` (would overwrite `vivado.log` / routed reports). Did not program the plugged board.

This process has **no independent `Get-FileHash`**. Freeze lists were compared to opened files and to overlapping hashes in `ASTRA-09-R2-CAND-OVF-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, and T1630/T1700/T1730 freeze strings.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R3-UART-IODELAY-01/`

Top `a7ng_astra_11_a09r3_uart_iodelay_wrap` (bag-local, **new named**) instance **`u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv`**. UART `u_rx` / `u_tx` from `rtl/board/uart_rx.sv` / `uart_tx.sv`. Pin clock `CLK100MHZ` E3 period 10.000 ns. Pipe clock MMCM 100→50 + BUFG, generated `clk50u` period 20.000 ns (**real**, attributes P,G,A). I/O timing reference `uart_io_vclk` period 20.000 ns (**virtual**, attribute V) with frozen `set_input_delay` / `set_output_delay` **max 2.000 / min 0.500** on `uart_txd_in` A9 and `uart_rxd_out` D10. Part `xc7a100tcsg324-1`. Mode **in-context** `synth_design` (not `-mode out_of_context`) then `opt_design` / `place_design` / `route_design`. No bitstream.

Gate under review is **work-order ASTRA-11-A09R3-UART-IODELAY-01 only** — one unknown: with `set_input_delay` / `set_output_delay` on `uart_txd_in` A9 and `uart_rxd_out` D10 (**values frozen in PREREG before impl**, board-UART-class, **not invented after seeing WNS**), after implement+route of a **new named UART wrap** instantiating frozen A09-R2 on `xc7a100tcsg324-1` at a declared 50 MHz constraint with clock-network delay included, is routed WNS ≥ 0 — **without a bitstream**. Quote UART I/O paths if they appear in timing. **Not** a patch of `ASTRA-11-A09R3-UART-IMPL-ROUTE-01` (that bag’s routed WNS=+0.305 must remain on disk). **Not** Master ASTRA-11 fullchip close. **Not** ASTRA-13 board acceptance. **Not** freeze of `PRODUCTION_TOP`.

Parent residual from auditor `20260906T1730Z`: UART impl-route CLOSED_NARROW WNS=+0.305 UART IOB A9/D10 FIXED. Residual 5: UART I/O unconstrained (no input/output delay; no IOB FF). Parent does **not** freeze `PRODUCTION_TOP`. This bag is **additive I/O-delay impl+route** of a new named UART wrap.

Hunt (parent / work order / this dispatch):

1. Delay numbers frozen in PREREG **before** impl (2.000/0.500) match XDC, not edited after WNS?
2. Quote routed WNS from `timing_route.rpt` Design State=Routed. Claimed +0.681.
3. UART in/out path slacks from `timing_uart_*.rpt` (claimed in +15.179 out +4.423).
4. `check_timing`: UART ports no longer unconstrained?
5. No `.bit`? `PRODUCTION_TOP` UNKNOWN? Not claiming +0.305 bag as this WNS?
6. Hash before impl including `.svh`?

Confirm: `ASTRA-11-A09R3-UART-IMPL-ROUTE-01` (+0.305) was **not overwritten**; `a7ng_astra_09_r2_cand_ovf` instantiated; frozen leftover A09 **not** compiled.

Judged against:

1. Work order `.agents/handoff/ASTRA-11-A09R3-UART-IODELAY-01.md` + PREREG: instantiate `a7ng_astra_09_r2_cand_ovf` (not copy-paste graph; not compile frozen leftover A09); do **not** edit `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`; PREREG freeze delay numbers **before** impl; hash RTL+XDC+tcl before impl; impl+route at declared 50 MHz; quote routed Design State; if WNS<0 FAIL bag, keep report, one bounded experiment, still no bit; PROGRAM=NO; do not overwrite UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, A09 wrap WNS=+1.041, or wrap-route WNS=+5.733; do not close ASTRA-13, BOARD_PASS, LM06, Master F3; do not freeze `PRODUCTION_TOP`.
2. **Master ASTRA-11** (DAG: FULLCHIP-COFIT): whole-chip co-fit of the frozen SoC top (UART + MMCM + I/O + memory plant + production path together), not an isolated named UART wrap with a fixture plant plus STA I/O delays.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.*
4. Auditor `20260906T1730Z`: ASTRA-11-A09R3-UART-IMPL-ROUTE-01 PASS_NARROW WNS=+0.305 UART IOB YES; residual = UART I/O delay (this bag). That +0.305 bag must remain unoverwritten.

**Master ASTRA-11 as a whole is not this bag’s close**, even if this wrapper’s routed WNS is ≥ 0 and UART I/O delays are present.

Out of this bag’s close: freeze of `PRODUCTION_TOP`, silicon UART / silicon MMCM / silicon BRAM, `a7ng_axi_bram128` plant, bitstream, JTAG/COM12, LM06 language, Master ASTRA-09 production path, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, ASTRA-13 BOARD_PASS, wrap-route `arty_a7_astra_rtp_soc_top` WNS=+5.733 identity, A09R2 wrap WNS=+0.648 identity, leftover A09 wrap WNS=+1.041 identity, prior UART wrap WNS=+0.305 identity, UART XSim MAGIC A2 as this bag, IOB FF pack, LED I/O delay, FT2232H silicon Tsu.

Frozen `a7ng_astra_09_r2_cand_ovf.sv` / `.svh`, leftover `a7ng_astra_09_integ_path.sv` / `.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `uart_rx.sv` / `uart_tx.sv`, F2R3/F2R4/F2R5, persist/R2/R3/R4 must remain **unpatched**. This wrap is a **new named** UART I/O-delay wrapper. It must **instantiate** A09-R2, not copy the graph. It must **not** compile leftover A09 / `astra09_pipe` / `axi_bram128` / RTP SoC / XSim wrap / prior UART impl wrap as this top.

Prior bags `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, `ASTRA-SOC-RTP-WRAP-ROUTE`, `ASTRA-09-R2-CAND-OVF-01` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`fec9dad5…cd28098d`). `write_scope` = new bag + distinctly named UART I/O-delay wrap that **instantiates** frozen `a7ng_astra_09_r2_cand_ovf` with `set_input_delay`/`set_output_delay` on A9/D10 (delay numbers frozen in PREREG before impl; board-UART-class from `vivado/tcl/build_a7eam01r.tcl` max 2.000 / min 0.500; no copy-paste graph; frozen leftover A09 not compiled as DUT; A09-R2 DUT source not patched; prior bags not edited **including ASTRA-11-A09R3-UART-IMPL-ROUTE-01 WNS=+0.305**). `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, **ASTRA-11-A09R3-UART-IMPL-ROUTE-01**, ASTRA-SOC-RTP-WRAP-UART-XSIM, ASTRA-09-R3-UART-XSIM-01, Master_ASTRA-10_whole_chip, production_top_identity, write_bitstream, IOB_FF_pack.

`run_impl.tcl` **renames** `write_bitstream` to abort (`astra_forbid_bit`). Compile list forbids leftover A09 / `astra09_pipe` / RTP SoC / XSim wrap / prior UART impl wrap / `axi_bram128`. Post-synth cell checks abort if leftover A09 cells exist, or if `u_a09r2` / `u_rx` / `u_tx` cells are missing, or if `uart_io_vclk` is missing. UART IOB extract requires A9=`uart_txd_in` and D10=`uart_rxd_out` in `io.rpt`.

Bag listing: **no** `.bit`, no `fail_r0/`, no `FIRST_DIVERGENCE.txt`, no `timing_route_exp.rpt`. Checkpoints are `ckpt/synth.dcp` and `ckpt/route.dcp` only. `vivado.jou`: **no** `write_bitstream` and **no** `.bit`.

`vivado.log` grep for `write_bitstream`, `a7ng_astra_09_integ_path`, `astra09_pipe`, `axi_bram128`: **no matches**.

---

### 1. Delay numbers frozen in PREREG **before** impl match XDC, not edited after WNS?

**PREREG (no WNS numbers — policy before impl):**

```text
UART_TXD_IN     = A9    FPGA RX   INPUT   set_input_delay
UART_RXD_OUT    = D10   FPGA TX   OUTPUT  set_output_delay
UART_IN_MAX_NS  = 2.000
UART_IN_MIN_NS  = 0.500
UART_OUT_MAX_NS = 2.000
UART_OUT_MIN_NS = 0.500
IO_CLK_REF      = uart_io_vclk  period 20.000 ns  (virtual I/O reference; same period as clk50u)
PIPE_CLK        = clk50u        period 20.000 ns  (MMCM+BUFG; REAL; not virtual)
```

PREREG cites board-UART-class envelope already used on this Arty A7-100T program (`vivado/tcl/build_a7eam01r.tcl` and `build_a7eam00s.tcl`). **Not** FT2232H silicon Tsu. **Not invented after WNS.** Do not edit after impl.

**XDC `clk50_uart_iodelay.xdc` (same numbers):**

```text
create_clock -name uart_io_vclk -period 20.000
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]
```

Comment in XDC: *UART I/O delay FROZEN in PREREG before impl. … Do not invent numbers after seeing WNS. Do not edit after impl.*

**EAM source (opened, not RESULTS):** `vivado/tcl/build_a7eam01r.tcl` lines 55–60:

```text
set_input_delay  -clock $io_clk -max 2.000 $p
set_input_delay  -clock $io_clk -min 0.500 $p
set_output_delay -clock $io_clk -max 2.000 $p
set_output_delay -clock $io_clk -min 0.500 $p
```

Same pair in `build_a7eam00s.tcl`. Numbers **MATCH** PREREG/XDC/ACK (`uart_iodelay_frozen_before_impl`). Methodology differs slightly (EAM binds delays to the **real** `eam_clk` on all GPIO; this bag binds UART-only delays to a **virtual** `uart_io_vclk` of the same 20.000 ns period as pipe `clk50u`). That is a declared STA envelope for async FTDI UART, **not** a post-WNS invention of 2.000/0.500. Pipe clock remains MMCM+BUFG `clk50u` (real).

**Hash order (cannot be “edited after WNS” without changing POST digest):**

| Event | Stamp |
|-------|-------|
| `SHA256.txt` / `SOURCE_HASHES.txt` **BEFORE impl** | `2026-09-06T22:34:41.8633774+07:00` |
| Vivado start (`vivado.log`) | `Sun Sep 6 22:34:43 2026` (PID 42164) — **~2 s later** |
| Reports | `22:38:07` (synth util) … `22:39:43` (util_route) … `22:39:44` (timing_route) … `22:39:48` (io/clocks/check_timing/uart_in/out/drc) |
| Vivado exit | `Sun Sep 6 22:39:49 2026` |
| `SHA256_POST.txt` **AFTER impl** | `2026-09-06T22:39:49.8142186+07:00` |

XDC digest **PRE = POST**:

`7023fd8abdd9aff9992adea80846b1908c22b230a3838144c449848532531a00  …/clk50_uart_iodelay.xdc`

Wrap / plant / tcl / five `.svh` PRE=POST as well (see hunt 6). If delay numbers had been edited after seeing WNS, the XDC POST hash would differ. It does not.

`run_impl.ps1` live-checks frozen leftover A09 / R2 DUT / SGD / uart_rx / uart_tx hashes, writes SHA256 of compiled + **`.svh`** + CONFIG (including PREREG/ACK) + KEEP + provenance **then** calls Vivado. Not hash-after-scores theatre.

`vivado.log` header (before synth) already prints the frozen numbers:

```text
UART_IO_VCLK=uart_io_vclk period=20.000ns
UART_IN_MAX_NS=2.000 UART_IN_MIN_NS=0.500
UART_OUT_MAX_NS=2.000 UART_OUT_MIN_NS=0.500
PROGRAM=NO
BIT=NOT_BUILT
PRODUCTION_TOP=UNKNOWN
```

Raw routed paths quote the same delays: `timing_uart_in.rpt` **Input Delay = 2.000 ns** (setup) / **0.500 ns** (hold); `timing_uart_out.rpt` **Output Delay = 2.000 ns** (setup) / **0.500 ns** (hold).

Hunt 1: **MET. 2.000/0.500 frozen before impl; XDC matches; POST XDC hash unchanged.**

---

### 2. Raw routed WNS/TNS (authority)

`timing_route.rpt` header:

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Sun Sep  6 22:39:44 2026
Command      : report_timing_summary -file .../ASTRA-11-A09R3-UART-IODELAY-01/timing_route.rpt
Design       : a7ng_astra_11_a09r3_uart_iodelay_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Timer settings of record: **Ignore I/O Paths : No**. Enable Input Delay Default Clock : No. I/O paths are in the summary; UART delays are explicit, not a default-clock cheat.

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      0.681        0.000                      0                 8601        0.100        0.000                      0                 8601
All user specified timing constraints are met.
```

Clock Summary (same rpt):

```text
sys_clk_pin   {0.000 5.000}      10.000          100.000
  clk50u      {0.000 10.000}     20.000          50.000
  clkfb       {0.000 5.000}      10.000          100.000
uart_io_vclk  {0.000 10.000}     20.000          50.000
```

Intra-clock table:

```text
  clk50u            0.681        0.000                      0                 7021        0.100        0.000                      0                 7021
```

Inter-clock table (UART I/O, same rpt):

```text
uart_io_vclk  clk50u             15.179        0.000                      0                    1        1.151        0.000                      0                    1
clk50u        uart_io_vclk        4.423        0.000                      0                    1        4.517        0.000                      0                    1
```

clk50u group: Setup 0 failing, Worst Slack **0.681 ns**, Total Violation 0.000 ns. Hold 0 failing, Worst Slack **0.100 ns**.

Implementer claim **WNS=+0.681 @ clk50u 20.000 ns MATCHES raw routed timing**. TNS=0.000 WHS=0.100 THS=0.000. Failing endpoints = 0. `metrics.json` `clock_name=clk50u` / `wns_ns=0.681` match. `vivado.log` DONE line: `ASTRA_11_A09R3_UART_IODELAY_DONE WNS=0.681 TNS=0.000 WHS=0.100 UART_IOB=YES UART_IODELAY=2.000/0.500 BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN`.

**`TIMING_EXTRACT.txt` caveat (not authority for WNS):** extract prints `CLOCK=uart_io_vclk` / `WNS=0.681`. That is the extract’s **first/last 20 ns clock name** in Clock Summary (`uart_io_vclk` is listed as a 20.000 ns clock). `uart_io_vclk` has **no intra-clock WNS** (virtual; no registers). Design Timing Summary WNS=0.681 **is** Intra `clk50u` 0.681 (I/O slacks 15.179 / 4.423 are looser). Implementer RESULTS correctly names Design Timing Summary / Intra clk50u as authority and flags the extract. **Not OVERCLAIM of WNS source** if the quote is the raw summary (it is). Residual: do not promote `TIMING_EXTRACT.txt` CLOCK= field as the WNS clock.

Endpoint count **8601 vs prior UART-impl-route 8599** = +2, matching the two UART I/O endpoints in the Inter Clock Table. Consistent with adding delays, not with recycling the +0.305 report.

Worst setup path (same rpt): `Slack (MET) : 0.681ns`; source `u_a09r2/FSM_sequential_st_reg[2]_rep/C` → dest `u_a09r2/u_sgd/w_reg[19][2]/D`; **Requirement 20.000 ns**; Data Path Delay 19.136 ns (logic 10.346 / route 8.790); 23 logic levels (CARRY4=13 + DSP48E1=1 + LUT*); Path Group `clk50u`. Source Clock Delay **6.420 ns**, Destination Clock Delay **6.065 ns**. This is a real SGD/weight path **inside instantiated A09-R2**, not a wrap-only tautology and **not** an I/O-delay manufactured slack.

Clock path on that worst setup (same rpt):

```text
E3  CLK100MHZ
E3  IBUF          CLK100MHZ_IBUF_inst/O
MMCME2_ADV_X1Y2   u_mmcm/CLKOUT0     net clk50u (fo=1, routed)
BUFGCTRL_X0Y16    u_bufg50/O
net (fo=3500, routed) u_a09r2/clk
Source Clock Delay = 6.420 ns
```

Worst hold path: `Slack (MET) : 0.100ns`; source `u_a09r2/u_sp/g_law.u_qse/xh_reg/C` → dest `u_a09r2/u_sp/g_law.u_qse/ctx_id_o_reg[0]/D`. MET. Inside QSE. Not a hold fail.

`route_status.rpt`: logical nets 12279; fully routed 6006; **routing errors = 0**.

DRC: 9 checks, all Warning (DSP DPIP/DPOP pipeline on `u_a09r2/u_sgd` acc0). **0 Error / 0 Critical**. Unpipelined DSP is consistent with frozen F2R2 SGD.

Synth-only contrast (not the WNS quote): `TIMING_EXTRACT_SYNTH.txt` Design State **Synthesized** `WNS=2.141` (and synth WHS negative, pre-route). Implementer correctly quotes **routed** 0.681, not synth 2.141. `vivado.log`: `synth_design -top a7ng_astra_11_a09r3_uart_iodelay_wrap -part xc7a100tcsg324-1` (no `-mode out_of_context`).

WNS ≥ 0. Bounded WNS<0 experiment **not run** (not applicable). Hunt 2: **MET. Routed WNS=+0.681.**

---

### 3. UART in/out path slacks from `timing_uart_*.rpt`

Both reports Design State **Routed**, Date `Sun Sep 6 22:39:48 2026`, Design `a7ng_astra_11_a09r3_uart_iodelay_wrap`.

**Input (`timing_uart_in.rpt`)** — `uart_txd_in` A9 → `u_rx/rx_sync0_reg/D`:

| Type | Slack | Delay used |
|------|------:|------------|
| Setup (Max Slow) | **15.179 ns MET** | Input Delay **2.000 ns** |
| Hold  (Min Fast) | **1.151 ns MET** | Input Delay **0.500 ns** |

Path: A9 IBUF → net `u_rx/rx` (routed) → `SLICE_X12Y143` `u_rx/rx_sync0_reg`. Destination clock is **real** clk50u (E3 IBUF → MMCME2_ADV_X1Y2 → BUFGCTRL_X0Y16 → `u_rx/clk` fo=3500 routed). Source clock `uart_io_vclk` is virtual (SCD=0.000, ideal network). That is the declared I/O-reference method, not a hidden virtual pipe clock.

**Output (`timing_uart_out.rpt`)** — `u_tx/tx_reg/C` → `uart_rxd_out` D10:

| Type | Slack | Delay used |
|------|------:|------------|
| Setup (Max Slow) | **4.423 ns MET** | Output Delay **2.000 ns** |
| Hold  (Min Fast) | **4.517 ns MET** | Output Delay **0.500 ns** |

Path: `SLICE_X36Y169` `u_tx/tx_reg` → net `uart_rxd_out_OBUF` → D10 OBUF. Source clock is **real** clk50u (SCD=6.414 ns, same E3 IBUF→MMCM→BUFG, fo=3500). Destination `uart_io_vclk` DCD=0.000 (virtual).

These four numbers MATCH Inter Clock Table, `UART_IODELAY.txt`, `metrics.json`, and RESULTS. UART I/O slacks are **looser** than internal clk50u WNS=+0.681. Worst path remains inside instantiated A09-R2. Not an I/O tautology manufacturing the quoted WNS.

`uart_io_vclk` period 20.000 ns is a **conservative STA envelope** versus async 115200 UART (bit period ~8.68 µs). It is **not** an FT2232H pin clock, and implementer PREREG says so. Meeting 2.000/0.500 vs a 20 ns virtual reference does **not** prove silicon UART. It does prove the named wrap still times at 50 MHz after those delays are applied.

Hunt 3: **MET. in setup +15.179 / out setup +4.423 (hold in +1.151 / out +4.517).**

---

### 4. `check_timing`: UART ports no longer unconstrained?

Standalone `check_timing.rpt` Design State **Routed** 22:39:48 (same checks embedded in `timing_route.rpt`):

```text
1. checking no_clock (0)
4. checking unconstrained_internal_endpoints (0)
5. checking no_input_delay (3)
   There are 0 input ports with no input delay specified.
   There are 3 input ports with no input delay but user has a false path constraint. (MEDIUM)
   btn[0]
   sw[0]
   sw[1]
6. checking no_output_delay (4)
   There are 4 ports with no output delay specified. (HIGH)
   led[0]
   led[1]
   led[2]
   led[3]
10. checking partial_input_delay (0)
11. checking partial_output_delay (0)
```

**`uart_txd_in` is not in `no_input_delay`.** **`uart_rxd_out` is not in `no_output_delay`.** Partial delays = 0 (both max and min present).

Contrast (T1730, prior UART-impl-route bag, I/O unconstrained): `no_input_delay` 4 (1 HIGH + 3 MEDIUM false-path) with HIGH = `uart_txd_in`; `no_output_delay` 5 HIGH including `uart_rxd_out` + 4 LEDs. This bag removes UART from that residual. Remaining HIGH unconstrained outputs are **LEDs only** (out of this work order). MEDIUM false-path sw/btn is the existing `set_false_path`.

Hunt 4: **MET. UART ports constrained.**

---

### 5. No `.bit`? PRODUCTION_TOP UNKNOWN? Not claiming +0.305 bag as this WNS? Prior bag not overwritten? A09-R2 instantiated?

**No bitstream / PROGRAM=NO / PRODUCTION_TOP=UNKNOWN**

- Bag directory: no `.bit` / `.bin` / `.mcs`. `ckpt/` holds `synth.dcp` + `route.dcp` only.
- `vivado.log` DONE: `BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN`. Exit `Sun Sep 6 22:39:49 2026`. No `write_bitstream` command.
- `vivado.jou`: no `write_bitstream`, no `.bit`.
- TCL: `write_bitstream` renamed to abort before synth. WNS≥0 path never calls it. WNS<0 path also never calls it.
- ACK / PREREG / RESULTS / CLOSEOUT / metrics: `PRODUCTION_TOP=UNKNOWN`, `PROGRAM=NO`.
- LOOP_STATE (read-only): `program=false`, `board_pass=false`, `astra13=BLOCKED`, `production_top=UNKNOWN`, `com12=USER_SAYS_PLUGGED_UNPROGRAMMED`.

Board plugged ≠ programmed.

**Not claiming +0.305 as this WNS**

Implementer RESULTS/CLOSEOUT/ACK cite +0.305 only as **not this result** / **not overwritten**. Marker is bag-local `ASTRA_11_A09R3_UART_IODELAY_DONE WNS=0.681`. Design name in raw rpt is `a7ng_astra_11_a09r3_uart_iodelay_wrap`, not `…uart_impl_wrap`. WNS=+0.681 is a **new place/route** (worst path FSM→SGD `w_reg[19][2]`, SCD=6.420; prior bag worst path was `pv_reg[0][1]`→`best_a_reg[13]`, WNS=+0.305, SCD=6.429). Occupancy is nearly the same live UART wrap (LUT 4803 vs prior 4804), not a stub. No `BOARD_PASS` vocabulary used as a pass.

**Prior bags still on disk (headers opened this session):**

| Bag | Raw identity still on disk |
|-----|----------------------------|
| **ASTRA-11-A09R3-UART-IMPL-ROUTE-01** | `timing_route.rpt` **Sun Sep 6 22:12:21**, Design `a7ng_astra_11_a09r3_uart_impl_wrap`, Design Timing Summary **WNS=0.305**, extract **WNS=0.305**. Wrap SHA KEEP `1c3a95f4…` MATCH this bag KEEP. Prior XDC `506a3e12…` MATCH KEEP. **No `set_input_delay`/`set_output_delay` in that XDC.** **Not overwritten.** |
| ASTRA-11-A09R2-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 21:26:25**, Design `a7ng_astra_11_a09r2_impl_wrap`, extract **WNS=0.648**. Wrap SHA KEEP `1932ee4c…` MATCH. **Not overwritten.** |
| ASTRA-11-A09-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 19:48:09**, Design `a7ng_astra_11_a09_impl_wrap`, extract **WNS=1.041**. **Not overwritten.** |
| ASTRA-SOC-RTP-WRAP-ROUTE | `timing.rpt` **Sun Sep 6 02:11:52**, Design `arty_a7_astra_rtp_soc_top`, raw **WNS(ns)=5.733**. **Not overwritten.** |

This routed WNS=+0.681 is **not** recycled +0.305 / +0.648 / +1.041 / +5.733. It is **better** than the prior UART wrap’s +0.305 because it is a **separate impl** of a new named wrap (placer WNS post-place 0.703; route converged 0.681), not because I/O delay was tuned after seeing slack. Hunt 5: **MET.**

**A09-R2 instantiated; frozen leftover A09 not compiled**

Bag contains new wrap + bag-local AXI plant only as RTL (no copied integrator `.sv` in the bag). Wrap:

```text
(* keep_hierarchy = "yes" *)
uart_rx ... u_rx ( .rx(uart_txd_in), ... );
uart_tx ... u_tx ( .tx(uart_rxd_out), ... );
(* keep_hierarchy = "yes" *)
a7ng_astra_09_r2_cand_ovf u_a09r2 ( ... );
(* keep_hierarchy = "yes" *)
a7ng_astra_11_a09r3_uart_iodelay_plant u_plant ( ... );
load_v_i tied 0.
```

No QSE/sparse/2-hop/SGD duplicated in the wrap. Frozen leftover A09 **not instantiated**. Plant header: *Bag-local behavioral AXI plant. Not silicon BRAM. Not a7ng_axi_bram128.*

Raw log elaboration (not RESULTS):

```text
synthesizing module 'a7ng_astra_11_a09r3_uart_iodelay_wrap' [.../ASTRA-11-A09R3-UART-IODELAY-01/a7ng_astra_11_a09r3_uart_iodelay_wrap.sv:8]
synthesizing module 'MMCME2_BASE'
synthesizing module 'BUFG'
synthesizing module 'uart_rx' [.../rtl/board/uart_rx.sv:2]
synthesizing module 'uart_tx' [.../rtl/board/uart_tx.sv:2]
synthesizing module 'a7ng_astra_09_r2_cand_ovf' [.../rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv:9]
synthesizing module 'a7ng_query_axi_sparse'
synthesizing module 'a7ng_shared_rank_sgd_q8_sym_f2r2'
synthesizing module 'a7ng_astra_11_a09r3_uart_iodelay_plant' [.../a7ng_astra_11_a09r3_uart_iodelay_plant.sv:6]
U_A09R2_CELLS=11064
U_RX_CELLS=76
U_TX_CELLS=56
```

**Not synthesized:** `a7ng_astra_09_integ_path` (zero log matches), `a7ng_astra09_pipe`, `arty_a7_astra_rtp_soc_top`, `a7ng_axi_bram128`, `a7ng_astra_11_a09r3_uart_impl_wrap`. **Required instantiate-not-copy and frozen-A09-not-compiled: MET.**

---

### 6. Hash before impl including `.svh`? UART IOB FIXED?

PRE vs POST compiled RTL+XDC+tcl + transitive `.svh`: **19/19 identical strings** (opened manifests; not re-hashed):

| Path | SHA256 |
|------|--------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6` |
| `.../a7ng_query_struct_extract.sv` | `ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768` |
| `.../a7ng_query_role_extract.sv` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` |
| `.../a7ng_route_valid_gate.sv` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` |
| `.../a7ng_sparse_dir_axi.sv` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` |
| `.../a7ng_query_axi_sparse.sv` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` |
| `.../a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac` |
| `.../a7ng_astra_09_r2_cand_ovf.sv` | `15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23` |
| `rtl/board/uart_rx.sv` | `8e802d0b4f7466d7683c9b0109d6666ba5b5d77cf67e45f5ab7c0564bcd5369a` |
| `rtl/board/uart_tx.sv` | `b4b7d09758cc95bb52a382bf5c11b5861ddcf0f74055d478824386531b36367b` |
| bag `a7ng_astra_11_a09r3_uart_iodelay_plant.sv` | `db452de54119ae40e77ae9de70476fd4ff9e06950790ee9b4d112e0c19b1af87` |
| bag `a7ng_astra_11_a09r3_uart_iodelay_wrap.sv` | `34353bb751689d170d047d4a343346697768b87f12a82ad1c3065717bb1ac348` |
| bag `clk50_uart_iodelay.xdc` | `7023fd8abdd9aff9992adea80846b1908c22b230a3838144c449848532531a00` |
| bag `run_impl.tcl` | `170cb8221f6531e2d522ab88e62bcef6368a61961d703c67f475580da27779ac` |
| `a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `a7ng_astra_09_integ_path.svh` | `ad2d66d4783bba33cfbd324fc0a9661fb2a46eeaffb5b4fb6989246fb4e94302` |
| `a7ng_astra_09_r2_cand_ovf.svh` | `feaed571ce02bec4218e2105986349a464d6c44bcf1a818260ee27a171afd329` |

`.svh` **is** in the pre-impl freeze (R2 contract + leftover A09 header + lexica + crc). Hunt 6: **MET.**

R2 DUT `15a919f1…` **MATCH** prior UART-impl-route freeze and T1630/T1700/T1730. Frozen leftover A09 `9fdbe0d6…` **MATCH** provenance (KEEP; **not compiled**). Frozen SGD `b66ef328…` MATCH. `uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH ASTRA-09-R3-UART-XSIM-01. Prior UART impl wrap `1c3a95f4…` MATCH KEEP (not compiled as this top). Prior UART impl XDC `506a3e12…` MATCH KEEP. Prior A09R2 wrap `1932ee4c…` MATCH. Prior XSim UART wrap `20cdeb8e…` MATCH KEEP.

**UART IOB (supporting, not a numbered hunt but required to trust the delay ports):**

Bag-local XDC pins D10 / A9 / E3. Official `constraints/arty_a7_100.xdc` (cited, not edited from this bag):

```text
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]; #IO_L19N_T3_VREF_16 Sch=uart_rxd_out
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]; #IO_L14N_T2_SRCC_16 Sch=uart_txd_in
```

Raw `io.rpt` Design `a7ng_astra_11_a09r3_uart_iodelay_wrap`, Total User IO=15, Date 22:39:48:

```text
| A9         | uart_txd_in  | ... | INPUT  | LVCMOS33 | ... | FIXED |
| D10        | uart_rxd_out | ... | OUTPUT | LVCMOS33 | ... | FIXED |
| E3         | CLK100MHZ    | ... | INPUT  | LVCMOS33 | ... | FIXED |
```

Direction matches Digilent names: **A9 = FPGA RX (`uart_txd_in`) INPUT FIXED**; **D10 = FPGA TX (`uart_rxd_out`) OUTPUT FIXED**. Pins are **not swapped**. `UART_IOB.txt`: `UART_IOB=YES`. `util_route.rpt` Bonded IOB **15 / 15 FIXED**; primitives **IBUF=10** **OBUF=5**. ILOGIC=0 / OLOGIC=0: UART is **pin-FIXED IBUF/OBUF**, not IOB-registered IFF/OFF. Handoff is delay constraints only (do not pack IOB FF). Residual vs a later IOB-FF pack, **not** a miss of this work order.

**Clock-network real vs virtual (pipe vs I/O ref):**

`clocks_route.rpt` Design State **Routed** 22:39:48:

```text
Clock         Period(ns)  Waveform(ns)    Attributes  Sources
sys_clk_pin   10.000      {0.000 5.000}   P           {CLK100MHZ}
uart_io_vclk  20.000      {0.000 10.000}  V           {}
clk50u        20.000      {0.000 10.000}  P,G,A       {u_mmcm/CLKOUT0}
clkfb         10.000      {0.000 5.000}   P,G,A       {u_mmcm/CLKFBOUT}
```

`clk50u` is Propagated + Generated + Auto-derived from `u_mmcm/CLKOUT0`, master `sys_clk_pin`. **`uart_io_vclk` is Virtual** (I/O reference only; empty Sources). `clock_util_route.rpt`: MMCM=1, BUFGCTRL=1 at **BUFGCTRL_X0Y16**, clock loads **3500**, period 20.000, driver `u_bufg50/O` net `clk`, source `MMCME2_ADV/CLKOUT0` site **MMCME2_ADV_X1Y2**. Pipe clock is **not** virtual. Quoted internal WNS includes clock-network delay (SCD=6.420 ns).

---

## Resources (raw; not the WNS quote)

Quoted **synth** `util_synth.rpt` Design State Synthesized 22:38:07:

```text
| Slice LUTs*             | 5682 |     0 |          0 |     63400 |  8.96 |
| Slice Registers         | 5008 |     0 |          0 |    126800 |  3.95 |
| Block RAM Tile          |    0 |
| DSPs                    |    2 |
```

Quoted **routed** `util_route.rpt` Design State Routed 22:39:43:

```text
| Slice LUTs              | 4803 |     0 |          0 |     63400 |  7.58 |
| Slice Registers         | 3500 |     0 |          0 |    126800 |  2.76 |
| Block RAM Tile          |    0 |
| DSPs                    |    2 | ...  DSP48E1 only
| Bonded IOB              |   15 |    15 |          0 |       210 |  7.14 |
| ILOGIC                  |    0 |
| OLOGIC                  |    0 |
| BUFGCTRL                |    1 |
| MMCME2_ADV              |    1 |
```

Hierarchical routed (`util_hier_route.rpt`):

```text
| a7ng_astra_11_a09r3_uart_iodelay_wrap | (top)                            | 4803 | 3500 | 0 | 2 |
|   u_a09r2                             | a7ng_astra_09_r2_cand_ovf        | 4293 | 2692 | 0 | 2 |
|     u_sgd                             | a7ng_shared_rank_sgd...          |  529 |  610 | 0 | 2 |
|     u_sp                              | a7ng_query_axi_sparse            | 3334 |  696 | 0 | 0 |
|       u_walk                          | a7ng_sparse_dir_axi              | 1005 |  450 |
|       g_law.u_qse                     | a7ng_query_role_extract          | 2329 |  202 |
|   u_plant                             | a7ng_astra_11_a09r3_uart_iodelay_plant | 171 | 73 | 0 | 0 |
```

Honest occupancy of a **live UART wrap**: QSE LUT=2329 is **not** the I/O-folded QSE=39 of A09R2 wrap. Plant is behavioral (LUT=171, BRAM=0), **not** wrap-route BRAM=2. SGD DSP×2 remains. Worst setup path still inside `u_a09r2`. **Not a stub DUT.** Also **not** whole-chip `axi_bram128` / DDR occupancy. Do not add 4803 to prior UART wrap 4804, A09R2 wrap 1321, leftover A09 wrap 1305, or wrap-route 4244 as a chip sum.

Comparison (not identity):

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 4803 | 3500 | 0 | 2 | **Routed clk50u +0.681 UART I/O delay 2.000/0.500** |
| This bag synth | 5682 | 5008 | 0 | 2 | Synthesized (not the WNS quote; extract +2.141) |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed | 4804 | 3500 | 0 | 2 | Routed UART IOB, **I/O unconstrained +0.305** — not overwritten |
| ASTRA-11-A09R2-IMPL-ROUTE-01 routed | 1321 | 1103 | 0 | 2 | Routed no-UART **+0.648** — not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed different DUT **+1.041** — not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |

---

## Overclaim / cheat / tautology

| Hunt | Finding |
|------|---------|
| Delay numbers invented after WNS / XDC edited after impl | **Not found.** PREREG 2.000/0.500, no WNS in PREREG; SHA PRE 22:34:41 < Vivado 22:34:43; XDC PRE=POST `7023fd8a…`; EAM source 2.000/0.500 opened |
| RESULTS vs raw rpt mismatch on WNS/TNS/WHS | **None.** +0.681 / 0.000 / 0.100 Design State Routed, Intra clk50u |
| UART in/out slack mismatch | **None.** +15.179 / +4.423 setup; hold +1.151 / +4.517; Input/Output Delay 2.000/0.500 on the paths |
| UART still unconstrained | **Not found.** `uart_txd_in` / `uart_rxd_out` absent from `no_input_delay` / `no_output_delay` |
| +0.305 bag overwritten or quoted as this WNS | **Not overwritten** (22:12:21 still 0.305, design `uart_impl_wrap`). **Not quoted as this result** |
| Wrap-route WNS=+5.733 claimed or overwritten | **Not claimed. Not overwritten** (02:11:52 still 5.733) |
| A09R2 wrap WNS=+0.648 claimed or overwritten | **Not claimed. Not overwritten** (21:26:25 still 0.648) |
| A09 wrap WNS=+1.041 overwritten | **Not overwritten** (19:48:09 still 1.041) |
| BOARD_PASS / silicon UART | **Not claimed.** BIT=NOT_BUILT; PROGRAM=NO; `uart_io_vclk` is V |
| Pipe clock virtual / no SCD | **Not found.** P,G,A `clk50u`; E3 IBUF→MMCM→BUFG→`u_a09r2/clk` fo=3500 routed; SCD=6.420 ns. Only I/O ref is virtual (declared) |
| Copy-paste graph called instantiate | **Not found.** Thin UART FIFO wrap + live RTL path in synth log |
| Frozen leftover A09 compiled as DUT | **Not found.** Zero synth/log matches; tcl forbids; KEEP hash only |
| Stub / empty DUT | **Not found.** Hier `u_a09r2` LUT=4293; QSE=2329; SGD DSP48E1×2; U_A09R2_CELLS=11064; worst path inside DUT SGD |
| Bitstream / PROGRAM | **No bit in this bag.** ACK/RESULTS PROGRAM=NO |
| `PRODUCTION_TOP` frozen | **UNKNOWN** in ACK / log DONE / RESULTS / CLOSEOUT / LOOP_STATE |
| Hash freeze after looking at WNS / `.svh` omitted | **Not found.** PRE 22:34:41 < Vivado 22:34:43; 5 `.svh` in PRE; POST 19/19 MATCH |
| UART XSim MAGIC A2 claimed as this bag | **Not claimed.** ASTRA-09-R3-UART-XSIM-01 still its own PASS_NARROW |
| Fail r0 wipe | **N/A.** Single successful session; WNS≥0; no fail_r0 artifact to wipe |
| LUT used as whole-chip occupancy | **Not claimed.** Documented fixture plant / BRAM=0 vs wrap-route BRAM=2 |
| `TIMING_EXTRACT.txt` CLOCK=uart_io_vclk as WNS clock | **Parser artifact, caveated.** Authority is Design Timing Summary / Intra clk50u. Not OVERCLAIM if RESULTS is the claim surface (it caveats). Do not promote the extract CLOCK= field |

qstack adversary: worst setup path is a real placed/routed A09-R2 SGD update (`FSM_sequential_st_reg` → `u_sgd/w_reg[19][2]`, 23 logic levels, DSP48E1 in path) under a **propagated generated** 20 ns clock with SCD=6.420 ns and 3500 routed clock loads. `set_false_path` on sw/btn and remaining unconstrained LED I/O **do not** create that 0.681 ns slack. UART I/O delays 2.000/0.500 produce **separate** inter-clock slacks (+15.179 / +4.423) that are looser than internal WNS. Virtual `uart_io_vclk` with DCD/SCD=0 on the I/O side is the standard STA construction for an async external UART; it does not virtualize the pipe clock. `keep_hierarchy` preserves `u_a09r2` / `u_rx` / `u_tx` identity. QSE remaining large (2329) is consistent with a live UART token path + responding AXI plant. WNS=+0.681 is a **new P&R** of a new named wrap, not a recycled +0.305 report (different design name, different date, different worst path, prior bag intact). Delay numbers match the pre-existing EAM GPIO envelope and were hashed before Vivado started.

---

## Logic bugs

No route FAIL. No critical warnings. No RESULTS/raw contradiction on the quoted WNS/TNS/WHS or UART in/out slacks. Route complete (0 failed nets). UART I/O delays applied as required. UART ports off the unconstrained lists. WNS ≥ 0 so the handoff WNS<0 bounded experiment was correctly **not** run.

Residuals (not this-bag FAIL):

1. `uart_io_vclk` is **virtual**. I/O STA is an envelope at the pipe period (20 ns) with 2.000/0.500 delays, **not** FT2232H Tsu and **not** a 115200 baud clock. Meeting those delays ≠ silicon UART. PREREG already says this.
2. `TIMING_EXTRACT.txt` / `TIMING_EXTRACT_SYNTH.txt` `CLOCK=uart_io_vclk` is a parser artifact (20 ns clock name). Do not quote extract CLOCK= as the WNS domain. Intra clk50u is the WNS domain.
3. ILOGIC=0 / OLOGIC=0: UART is IBUF/OBUF at A9/D10, **not** IOB-registered. Handoff forbade IOB FF pack in this bag. Residual vs a later pack if parent wants it.
4. LED outputs remain HIGH `no_output_delay` (`led[0:3]`). Out of this work order.
5. DRC DSP unpipelined (DPIP/DPOP) — expected; frozen F2R2 SGD. Do not patch from this bag.
6. Bag-local `a7ng_astra_11_a09r3_uart_iodelay_plant` is a **behavioral fixture** (BRAM=0). Master ASTRA-11 fullchip plant (`a7ng_axi_bram128` / DDR) remains open.
7. Occupancy LUT=4803 / QSE=2329 is **this UART I/O-delay wrap**, not additive with prior UART wrap 4804, A09R2 wrap 1321, leftover A09 wrap 1305, or wrap-route 4244 BRAM=2. WNS=+0.681 vs prior UART wrap +0.305 is **separate P&R**, not a delta on the same DCP.
8. No independent `Get-FileHash` this process. Overlapping R2/SGD/A09/uart/pkg hashes MATCH prior bags. Wrap/XDC/tcl/plant digests are first-recorded here; PRE=POST strings match.
9. Functional MAGIC A2 / OVF INCOMP on the byte stream remains **XSim** (T1700). This bag does not re-prove UART protocol on silicon or in XSim.
10. Named wrap is a **candidate** UART SoC path with STA I/O delays, not a silent `PRODUCTION_TOP` freeze. T1730 residual 5 is **physically evidenced** (UART ports constrained, delays 2.000/0.500, WNS≥0) and **not closed as production identity**.

No DUT logic patch requested. Auditor does not fix.

---

## This bag vs Master ASTRA-11 / ASTRA-13

Work-order unknown **answered**: for wrapper `a7ng_astra_11_a09r3_uart_iodelay_wrap` / instance `u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf` on `xc7a100tcsg324-1`, with UART I/O delays **frozen before impl at max 2.000 / min 0.500** on `uart_txd_in` A9 / `uart_rxd_out` D10, post-route (Design State **Routed**) is **WNS=+0.681 ns TNS=0.000 ns WHS=+0.100 ns @ clk50u 20.000 ns (50 MHz)** with **real** E3 IBUF → MMCME2_ADV_X1Y2 → BUFGCTRL_X0Y16 → `u_a09r2/clk` (SCD=6.420 ns, fo=3500 routed), UART I/O setup **in +15.179 ns / out +4.423 ns**, UART ports **off** unconstrained lists, UART IOB **A9 INPUT / D10 OUTPUT FIXED**, **BIT=NOT_BUILT**, **PROGRAM=NO**, **PRODUCTION_TOP=UNKNOWN**. Frozen leftover A09 **not compiled**. ASTRA-11-A09R3-UART-IMPL-ROUTE-01 WNS=+0.305 **not overwritten**. A09R2 wrap WNS=+0.648 **not overwritten**. Wrap-route WNS=+5.733 **not overwritten**.

T1730 residual 5 (**UART I/O unconstrained**) is **closed as evidence class** for *this named wrap with frozen 2.000/0.500 delays, UART ports constrained, WNS≥0, no bitstream*. It is **not** permission to mark Master ASTRA-11 or ASTRA-13 done, and **not** permission to freeze `PRODUCTION_TOP`.

| Master item | This bag |
|---|---|
| ASTRA-11 FULLCHIP-COFIT (UART + MMCM + I/O + AXI BRAM/DDR plant + production path as one frozen top) | Named UART wrap + MMCM/BUFG + D10/A9 IOB + STA I/O delays + fixture AXI plant. No `axi_bram128`. No DDR. `PRODUCTION_TOP=UNKNOWN` |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 WNS=+0.305 | Different wrap (`uart_impl_wrap`); I/O unconstrained; bag **not overwritten**; this WNS=+0.681 is **not** that number |
| ASTRA-11-A09R2-IMPL-ROUTE-01 WNS=+0.648 | Different wrap, no UART; bag not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041 | Different DUT `a7ng_astra_09_integ_path`; bag not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733 | Different top `arty_a7_astra_rtp_soc_top`; bag not overwritten |
| ASTRA-11-SOC-WRAP historical routed WNS=-4.765 | Different top; not this result |
| ASTRA-13 FINAL-BOARD-ACCEPTANCE | BIT=NOT_BUILT; PROGRAM=NO; no JTAG/COM12; `PRODUCTION_TOP=UNKNOWN` |
| LM06 language | Not opened |
| ASTRA-09-R3-UART-XSIM-01 MAGIC A2 | Prior XSim bag; not this impl/route result |

**No Master-gate overclaim found.**

Master **ASTRA-11 FULLCHIP-COFIT** remains **OPEN** (fixture plant, not frozen SoC top, not wrap-route identity, IOB FF not packed).

Master **ASTRA-13 FINAL-BOARD-ACCEPTANCE** remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority.

Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-10 whole-chip remain **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-11-A09R3-UART-IODELAY-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw routed reports: instantiate-not-copy of `a7ng_astra_09_r2_cand_ovf`, frozen leftover A09 not compiled, hash-before-impl including `.svh`, delay numbers **2.000/0.500 frozen in PREREG before impl and matching XDC/EAM class (not edited after WNS)**, real pipe clock-network (not virtual), virtual I/O ref only as declared, WNS=+0.681 ≥ 0, TNS=0, UART in setup +15.179 / out setup +4.423, UART ports no longer unconstrained, UART IOB A9 INPUT / D10 OUTPUT FIXED, PROGRAM=NO, no bitstream, `PRODUCTION_TOP=UNKNOWN`, prior UART impl-route WNS=+0.305 / A09R2 wrap / leftover A09 wrap / wrap-route / UART XSim bags not overwritten, no BOARD_PASS / ASTRA-13 / LM06 overclaim, no theft of +0.305 / +0.648 / +1.041 / +5.733.

Not PASS (Master ASTRA-11 fullchip, ASTRA-13 board, silicon UART, `axi_bram128` plant, IOB FF pack, `PRODUCTION_TOP` freeze, FT2232H Tsu).  
Not FAIL (raw WNS matches claim; delays frozen before impl match XDC; UART ports constrained; route 0 error / 0 critical; frozen R2/SGD/leftover A09/uart/F2R/persist unpatched; leftover A09 not compiled; pipe clock path real; prior WNS bags intact including +0.305).  
Not OVERCLAIM (ACK/RESULTS keep Master 11/13/BOARD/LM06/`PRODUCTION_TOP` open; do not steal prior UART wrap +0.305, A09R2 wrap +0.648, leftover A09 wrap +1.041, wrap-route +5.733, or UART XSim MAGIC A2; extract CLOCK=uart_io_vclk is caveated).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared routed-WNS-at-50 MHz-with-frozen-UART-I/O-delays-2.000/0.500 claim.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this WNS=+0.681 / delays 2.000/0.500 to BOARD_PASS, ASTRA-13, prior UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, wrap-route WNS=+5.733, leftover A09 wrap WNS=+1.041, UART XSim MAGIC A2, or `PRODUCTION_TOP=a7ng_astra_11_a09r3_uart_iodelay_wrap`.
2. Do **not** add this LUT/FF to prior UART wrap 4804/3500, A09R2 wrap 1321/1103, leftover A09 wrap 1305/1075, or wrap-route 4244/3810 BRAM=2. Fixture plant BRAM=0 is honest. Whole-chip co-fit needs **one** current-source SoC top (Master ASTRA-11) plus an explicit `PRODUCTION_TOP` decision.
3. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
4. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv` and do **not** patch frozen R2 DUT / uart_rx / uart_tx from DRC DSP warnings.
5. `uart_io_vclk` remains a virtual STA envelope. IOB FF pack and LED I/O delay remain residuals. If parent wants IOB-registered UART or FT2232H-class delays, that is a **new** named bag — not a P1 on this one.
6. Do not quote `TIMING_EXTRACT.txt` `CLOCK=uart_io_vclk` as the WNS domain. Authority is `timing_route.rpt` Design Timing Summary / Intra clk50u.
7. Functional UART 8N1 / MAGIC A2 remains T1700 XSim. This bag is physical route + I/O delay STA, not silicon UART.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated implement+route of a **new named UART wrap** instantiating frozen `a7ng_astra_09_r2_cand_ovf` at declared 50 MHz with **real routed clock-network**, frozen UART I/O delays **max 2.000 / min 0.500** (PREREG before impl, XDC match, not edited after WNS), WNS=+0.681 ≥ 0, UART in setup +15.179 / out setup +4.423, UART ports constrained, UART IOB **A9 INPUT / D10 OUTPUT FIXED**, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`, leftover A09 not compiled, prior UART impl-route WNS=+0.305 bag **not overwritten**.

`REJECT_PROMOTION` — Master **ASTRA-11** (fullchip co-fit / frozen SoC UART top / on-chip plant), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. Routed UART wrap with STA I/O delays **≠** silicon UART.

Master ASTRA-09: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305: **untouched**.  
ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648: **untouched**.  
ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041: **untouched, different DUT**.  
ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733: **untouched, different top**.  
ASTRA-09-R3-UART-XSIM-01: **untouched, still not BOARD**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1800Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-11-A09R3-UART-IODELAY-01; Master ASTRA-11/13 OPEN; delays IN/OUT max 2.000 min 0.500 frozen before impl; raw routed WNS=+0.681 TNS=0.000 WHS=+0.100 (Design State Routed, clk50u 20.000 ns, SCD=6.420 ns E3 IBUF→MMCM→BUFG→u_a09r2/clk routed fo=3500); UART in setup +15.179 / out setup +4.423; UART ports constrained; PROGRAM=NO; BOARD still blocked YES.
