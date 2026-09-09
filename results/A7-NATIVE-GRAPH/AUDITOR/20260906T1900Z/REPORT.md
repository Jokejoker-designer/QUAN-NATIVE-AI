# ASTRA auditor REPORT — 20260906T1900Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA11_A09R3_UART_IOBFF_HOLD_INDEPENDENT_AUDIT; astra11_iobff=AUDITOR_PASS_NARROW_WNS_P0115_WHS_M4915_IOBFF_YES; astra11_iobff_hold=IMPLEMENTER_CLAIM_WNS_P0115_WHS_P0131_FALSE_PATH_HOLD_PENDING_AUDITOR; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-11 FULLCHIP-COFIT / ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-11-A09R3-UART-IOBFF-HOLD-01 + prior auditor 20260906T1830Z (IOBFF bag ACCEPT_PARTIAL PASS_NARROW WNS=+0.115 IOB FF YES; residual UART IOB input hold vs uart_io_vclk WHS=−4.915 — this bag is additive STA-envelope HOLD, not a patch of the +0.115 bag) + T1800 / T1730 / T1700 / T1630
EVIDENCE   = raw timing_route.rpt / exceptions_route.rpt / timing_uart_in.rpt / timing_uart_out.rpt / check_timing.rpt / io.rpt / clocks_route.rpt / clock_util_route.rpt / util_route.rpt / util_hier_route.rpt / route_status.rpt / ram_route.rpt / drc.rpt / util_synth.rpt / timing_synth.rpt / vivado.log / vivado.jou / wrap SV / plant SV / tcl / XDC / UART_IOB.txt / UART_IOBFF.txt / UART_IODELAY.txt / SHA manifests / PREREG / ACK (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_impl.ps1` / `run_impl.tcl` (would overwrite `vivado.log` / routed reports). Did not program the plugged board.

This process has **no independent `Get-FileHash`**. Freeze lists were compared to opened files and to overlapping hashes in `ASTRA-11-A09R3-UART-IOBFF-01`, `ASTRA-11-A09R3-UART-IODELAY-01`, `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, `ASTRA-09-R3-UART-XSIM-01`, and T1630/T1700/T1730/T1800/T1830 freeze strings.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R3-UART-IOBFF-HOLD-01/`

Top `a7ng_astra_11_a09r3_uart_iobff_hold_wrap` (bag-local, **new named**) instance **`u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv`**. UART `u_rx` / `u_tx` from `rtl/board/uart_rx.sv` / `uart_tx.sv`. Wrap-level pad FFs `uart_rx_iob` / `uart_tx_iob` with `(* IOB = "TRUE" *)` plus XDC `set_property IOB TRUE`. Pin clock `CLK100MHZ` E3 period 10.000 ns. Pipe clock MMCM 100→50 + BUFG, generated `clk50u` period 20.000 ns (**real**, attributes P,G,A). I/O timing reference `uart_io_vclk` period 20.000 ns (**virtual**, attribute V) with frozen `set_input_delay` / `set_output_delay` **max 2.000 only** (`-min` **NOT_APPLIED**). HOLD_POLICY frozen in PREREG before impl: **`FALSE_PATH_HOLD_ASYNC_UART`**. Part `xc7a100tcsg324-1`. Mode **in-context** `synth_design` (not `-mode out_of_context`) then `opt_design` / `place_design` / `route_design`. No bitstream.

Gate under review is **work-order ASTRA-11-A09R3-UART-IOBFF-HOLD-01 only** — one unknown: can a **new STA envelope** (handoff allowed pick: false-path-hold, async UART exception, extra IOB sample, or a different virtual clock; implementer picked **false-path-hold** and wrote it in PREREG **before** impl) keep UART IOB FFs packed and make Design Timing Summary **WHS ≥ 0 as well as WNS ≥ 0** after implement+route of a **new named UART wrap** instantiating frozen A09-R2 on `xc7a100tcsg324-1` at declared 50 MHz with clock-network delay included — **without a bitstream** and without claiming BOARD_PASS. FAIL this bag if WHS<0. Do **not** retune frozen 2.000/0.500 inside the +0.115 bag. Do **not** copy-paste 2.000/0.500 min delay then hide WHS. **Not** a patch of `ASTRA-11-A09R3-UART-IOBFF-01` (that bag’s routed WNS=+0.115 **WHS=−4.915** must remain on disk). **Not** Master ASTRA-11 fullchip close. **Not** ASTRA-13 board acceptance. **Not** freeze of `PRODUCTION_TOP`.

Parent residual from auditor `20260906T1830Z`: IOBFF CLOSED_NARROW for WNS≥0 + IOB FF packed. Residual 2: UART IOB input **hold** vs virtual `uart_io_vclk` WHS=−4.915. Parent does **not** freeze `PRODUCTION_TOP`. This bag is **additive STA-envelope impl+route** of a new named UART wrap.

Hunt (parent / work order / this dispatch):

1. HOLD_POLICY `FALSE_PATH_HOLD_ASYNC_UART`: is `set_false_path -hold` an honest async UART exception frozen in PREREG, or a hide-WHS cheat? Quote XDC + `exceptions_route.rpt`.
2. Design Timing Summary WNS **and** WHS from RAW `timing_route.rpt`. Claimed WNS=+0.115 WHS=+0.131 constraints met.
3. Setup delays 2.000 still applied? Min 0.500 not applied — disclosed?
4. IOB FF still packed?
5. Prior IOBFF bag still WHS=−4.915 on disk?
6. Overclaim BOARD_PASS / all-constraints-met including the excepted hold?
7. Hash before impl? No `.bit`? `PRODUCTION_TOP` UNKNOWN?

Confirm: `ASTRA-11-A09R3-UART-IOBFF-01` (WNS=+0.115 WHS=−4.915) was **not overwritten**; `a7ng_astra_09_r2_cand_ovf` instantiated; frozen leftover A09 **not** compiled.

Judged against:

1. Work order `.agents/handoff/ASTRA-11-A09R3-UART-IOBFF-HOLD-01.md` + PREREG: instantiate `a7ng_astra_09_r2_cand_ovf`; do **not** edit `ASTRA-11-A09R3-UART-IOBFF-01`; freeze hold policy **before** impl; do not copy-paste 2.000/0.500 min delay then hide WHS; hash RTL+XDC+tcl before impl; impl+route at declared 50 MHz; quote routed Design State WNS **and** WHS; IOB FF still packed; FAIL if WHS<0; PROGRAM=NO; do not overwrite IOBFF wrap WNS=+0.115 WHS=−4.915, I/O-delay wrap WNS=+0.681, UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, A09 wrap WNS=+1.041, or wrap-route WNS=+5.733; do not close ASTRA-13, BOARD_PASS, LM06, Master F3; do not freeze `PRODUCTION_TOP`.
2. **Master ASTRA-11** (DAG: FULLCHIP-COFIT): whole-chip co-fit of the frozen SoC top (UART + MMCM + I/O + memory plant + production path together), not an isolated named UART wrap with a fixture plant plus an STA hold exception.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md` / `GSTACK_LOOP.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.* ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate.
4. Auditor `20260906T1830Z`: ASTRA-11-A09R3-UART-IOBFF-01 PASS_NARROW WNS=+0.115 IOB FF YES; WHS=−4.915 disclosed (1 UART IOB input hold vs `uart_io_vclk`). That −4.915 bag must remain unoverwritten. a7-fpga-gate numeric: WNS ≥ 0; TNS = 0; **WHS/THS report; negative hold is a finding**.

**Master ASTRA-11 as a whole is not this bag’s close**, even if this wrapper’s routed WNS and DTS WHS are ≥ 0 and UART IOB FFs packed.

Out of this bag’s close: freeze of `PRODUCTION_TOP`, silicon UART / silicon MMCM / silicon BRAM, `a7ng_axi_bram128` plant, bitstream, JTAG/COM12, LM06 language, Master ASTRA-09 production path, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, ASTRA-13 BOARD_PASS, wrap-route `arty_a7_astra_rtp_soc_top` WNS=+5.733 identity, A09R2 wrap WNS=+0.648 identity, leftover A09 wrap WNS=+1.041 identity, prior UART wrap WNS=+0.305 identity, prior I/O-delay wrap WNS=+0.681 identity, prior IOBFF wrap WNS=+0.115 WHS=−4.915 identity, UART XSim MAGIC A2 as this bag, LED I/O delay, FT2232H silicon Tsu, claim that UART IOB hold is now **physically MET**.

Frozen `a7ng_astra_09_r2_cand_ovf.sv` / `.svh`, leftover `a7ng_astra_09_integ_path.sv` / `.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `uart_rx.sv` / `uart_tx.sv`, F2R3/F2R4/F2R5, persist/R2/R3/R4 must remain **unpatched**. This wrap is a **new named** UART IOB-FF HOLD wrapper. It must **instantiate** A09-R2, not copy the graph. It must **not** compile leftover A09 / `astra09_pipe` / `axi_bram128` / RTP SoC / XSim wrap / prior UART impl wrap / prior I/O-delay wrap / prior IOBFF wrap as this top.

Prior bags `ASTRA-11-A09R3-UART-IOBFF-01`, `ASTRA-11-A09R3-UART-IODELAY-01`, `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, `ASTRA-SOC-RTP-WRAP-ROUTE`, `ASTRA-09-R2-CAND-OVF-01` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`035ac044…9549e7f9`). `write_scope` = new bag + distinctly named UART IOB-FF HOLD wrap that **instantiates** frozen `a7ng_astra_09_r2_cand_ovf` with `IOB=TRUE` wrap pad FFs on A9/D10 plus a **NEW STA hold envelope frozen in PREREG before impl** (`FALSE_PATH_HOLD_ASYNC_UART`: `set_false_path -hold` on UART pads; setup max 2.000 kept; do **NOT** copy-paste min 0.500 then hide WHS); no copy-paste graph; frozen leftover A09 not compiled as DUT; A09-R2 DUT source not patched; `uart_rx`/`uart_tx` not patched; prior bags not edited **including ASTRA-11-A09R3-UART-IOBFF-01 WNS=+0.115 WHS=−4.915 IOB FF YES**. `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`hold_policy_frozen_before_impl.name` = `FALSE_PATH_HOLD_ASYNC_UART`. `picked` = `false-path-hold`. `not_picked` = extra IOB sample / different virtual clock / min-delay retune.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, **ASTRA-11-A09R3-UART-IOBFF-01**, **ASTRA-11-A09R3-UART-IODELAY-01**, **ASTRA-11-A09R3-UART-IMPL-ROUTE-01**, ASTRA-SOC-RTP-WRAP-UART-XSIM, ASTRA-09-R3-UART-XSIM-01, Master_ASTRA-10_whole_chip, production_top_identity, write_bitstream, LED_IO_delay.

`run_impl.tcl` **renames** `write_bitstream` to abort (`astra_forbid_bit`). `vivado.jou`: **no** `write_bitstream` and **no** `.bit`. Compile list forbids leftover A09 / `astra09_pipe` / RTP SoC / XSim wrap / prior UART impl wrap / prior I/O-delay wrap / prior IOBFF wrap / `axi_bram128`.

Bag listing: **no** `.bit` / `.bin` / `.mcs`, no `fail_r0/`, no `FIRST_DIVERGENCE.txt`, no `timing_route_exp.rpt`. Checkpoints are `ckpt/synth.dcp` and `ckpt/route.dcp` only. Bounded WHS<0 experiment **not run** (DTS WHS ≥ 0).

`vivado.log` grep for `write_bitstream`, `a7ng_astra_09_integ_path`, `BOARD_PASS`: **no matches**. `PRODUCTION_TOP=UNKNOWN` at start and DONE.

---

### 1. HOLD_POLICY — honest async UART exception, or hide-WHS cheat?

**XDC `clk50_uart_iobff_hold.xdc` (opened; SHA PRE=POST `046a3cb2…590376f9`):**

```tcl
create_clock -name uart_io_vclk -period 20.000
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
# HOLD POLICY (PREREG): FALSE_PATH_HOLD_ASYNC_UART.
set_false_path -hold -from [get_ports uart_txd_in]
set_false_path -hold -to   [get_ports uart_rxd_out]
```

**No `-min` anywhere in this XDC.** Comment block: “Do NOT apply -min 0.500. Do not retune the +0.115 bag.”

**PREREG (no routed WNS/WHS numbers — policy before impl):**

```text
HOLD_POLICY     = FALSE_PATH_HOLD_ASYNC_UART
PICKED          = false-path-hold
NOT_PICKED      = extra IOB sample; different virtual clock; min-delay retune
UART_IN_MAX_NS  = 2.000
UART_IN_MIN_NS  = NOT_APPLIED   (FALSE_PATH_HOLD; do not reuse 0.500)
UART_OUT_MAX_NS = 2.000
UART_OUT_MIN_NS = NOT_APPLIED
```

Post-synth clock-to-clock (same PREREG; applied by `astra_apply_hold_policy` after synth/opt/place when `clk50u` exists):

```tcl
set_false_path -hold -from [get_clocks uart_io_vclk] -to [get_clocks clk50u]
set_false_path -hold -from [get_clocks clk50u] -to [get_clocks uart_io_vclk]
```

**Raw `exceptions_route.rpt` Design State=Routed 23:33:16, Design `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`:**

```text
Position  From                              To                                Setup           Hold
2         [get_ports {sw[*]}]               *                                 false           false
3         [get_ports {btn[*]}]              *                                 false           false
7         [get_ports uart_txd_in]           *                                 -               false
8         *                                 [get_ports uart_rxd_out]          -               false
9         [get_clocks -quiet uart_io_vclk]  [get_clocks -quiet clk50u]        -               false
10        [get_clocks -quiet clk50u]        [get_clocks -quiet uart_io_vclk]  -               false
11–14     (same clock-to-clock pair repeated twice more)
```

Hold column **`false`**. Setup column **`-`** (setup **not** excepted) on UART pad and clock-to-clock rows. sw/btn remain full false-path (both setup and hold) — same as prior UART bags, not this hold policy.

`vivado.log`: `HOLD_POLICY_CLK_FALSE_PATH_HOLD_APPLIED=2` after synth, after opt, and after place (three applications → exceptions positions 9–14). Redundant, same policy, not a post-WHS invention.

**Adversary classification of Hunt 1:**

| Test | Result |
|------|--------|
| Frozen in PREREG **before** impl? | **YES.** ACK + PREREG + XDC hashed `2026-09-06T23:28:09.0098459+07:00`. Vivado start `Sun Sep 6 23:28:10 2026` (~1 s later). Header already prints `HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART` / `UART_IN_MIN_NS=NOT_APPLIED` **before** `synth_design`. |
| Handoff-allowed pick? | **YES.** Handoff: “false-path-hold, async UART exception, extra IOB sample, or a different virtual clock — pick one and write it.” Picked false-path-hold. Wrote it. |
| Forbidden cheat “copy-paste 2.000/0.500 min delay then hide WHS”? | **NOT DONE.** This XDC has **no** `-min 0.500`. Prior IOBFF XDC still **has** `-min 0.500` on disk (`clk50_uart_iobff.xdc` KEEP `dad1dbf2…`). |
| Setup still checked? | **YES.** UART pad exceptions are hold-only. `timing_uart_in.rpt` setup Input Delay **2.000 ns**, Slack MET **19.270 ns**. `timing_uart_out.rpt` setup Output Delay **2.000 ns**, Slack MET **7.313 ns**. Inter Clock Table still reports those setup WNS values. |
| Hold physically “fixed”? | **NO.** IBUF→IFF route remains **0.000 ns** (same ILOGIC_X0Y171). Prior bag with min 0.500 still shows Slack (VIOLATED) **−4.915 ns** on that exact path. This bag’s `timing_uart_in.rpt` / `timing_uart_out.rpt` contain **setup only** (`-delay_type min_max` produced no hold path). Inter Clock hold columns are **blank**. `UART_IODELAY.txt`: `UART_IN_HOLD_SLACK=NA`. |
| Disclosure vs hide? | **DISCLOSED.** RESULTS/CLOSEOUT/metrics `hold_policy_note`: DTS WHS is intra-clk50u +0.131; UART I/O hold vs `uart_io_vclk` is excepted; not a retune of frozen min 0.500. `check_timing` HIGH `partial_input_delay` / `partial_output_delay` on `uart_txd_in` / `uart_rxd_out` because `-min` is NOT_APPLIED — expected, not hidden. |

**Technical honesty of the exception (not a silicon claim):** UART 115200 on Arty A7 has **no related FTDI launch clock** on the FPGA. Bit period ~8.68 µs. Packed ILOGIC IFF + frozen `uart_rx` 2-FF is the CDC. Hold vs a 20 ns **virtual** `uart_io_vclk` with SCD=0 against real MMCM+BUFG DCD (~6.5 ns) is an STA envelope collision, not a 115200 silicon hold requirement. T1830 already said that. Replacing the meaningless related-clock hold check with an explicit hold-only false path, **keeping setup max 2.000**, is a legitimate async-I/O STA envelope — **provided** it is frozen before impl and not sold as “the −4.915 path now METs.”

**Tautology (why this is not a clean PASS):** Design Timing Summary WHS ≥ 0 is **true because the only failing hold was excepted**. WNS=+0.115, Intra clk50u WHS=+0.131, UART setup 19.270/7.313, LUT=4802 FF=3500, ILOGIC_X0Y171 / OLOGIC_X0Y161, clock loads 3502, worst setup `pv_reg[0][0]`→`best_a_reg[0]` are **identical** to the prior IOBFF bag. This is an STA-envelope delta on the same physical P&R class, not a new hold-clean place/route. Envelope-tautological WHS≥0 answers the **declared** unknown (handoff asked for a new STA envelope). It does **not** make UART IOB hold physically MET.

Hunt 1: **HONEST async UART exception frozen in PREREG. Not a hide-WHS cheat of the min-delay type. WHS≥0 is envelope-tautological, not a physical IOB hold fix.**

---

### 2. Raw routed WNS **and** WHS (authority)

`timing_route.rpt` header:

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Sun Sep  6 23:33:11 2026
Command      : report_timing_summary -file .../ASTRA-11-A09R3-UART-IOBFF-HOLD-01/timing_route.rpt
Design       : a7ng_astra_11_a09r3_uart_iobff_hold_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Timer settings of record: **Ignore I/O Paths : No**. Enable Input Delay Default Clock : No. I/O paths are in the summary; UART setup delays are explicit. Hold on those I/O paths is excepted (Hunt 1), not ignored via Ignore I/O Paths.

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      0.115        0.000                      0                 8601        0.131        0.000                      0                 8599
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
  clk50u            0.115        0.000                      0                 7021        0.131        0.000                      0                 7021
```

Inter-clock table (UART I/O, same rpt) — **hold columns blank**:

```text
uart_io_vclk  clk50u             19.270        0.000                      0                    1
clk50u        uart_io_vclk        7.313        0.000                      0                    1
```

Contrast prior IOBFF bag Inter Clock (still on disk, Design `uart_iobff_wrap`, 23:06:09):

```text
uart_io_vclk  clk50u             19.270        0.000                      0                    1       -4.915       -4.915                      1                    1
clk50u        uart_io_vclk        7.313        0.000                      0                    1        3.662        0.000                      0                    1
```

clk50u group this bag: Setup 0 failing, Worst Slack **0.115 ns**. Hold 0 failing, Worst Slack **0.131 ns**.

Implementer claim **WNS=+0.115 and WHS=+0.131 MATCHES raw routed Design Timing Summary**. TNS=0.000 THS=0.000. Setup failing endpoints = 0. Hold failing endpoints = 0. `metrics.json` `wns_ns=0.115` / `whs_ns=0.131` / `timing_constraints_met=true` match **the DTS after exceptions**. `TIMING_EXTRACT.txt`: `WNS=0.115 TNS=0.000 WHS=0.131 THS=0.000 CLOCK=clk50u PERIOD_NS=20.000 DESIGN_STATE=Routed`. `vivado.log` DONE line: `ASTRA_11_A09R3_UART_IOBFF_HOLD_DONE WNS=0.115 TNS=0.000 WHS=0.131 UART_IOB=YES UART_IOBFF=YES HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN`.

**No RESULTS vs raw-rpt contradiction on DTS WNS/TNS/WHS.** RESULTS correctly states WHS=+0.131 is **intra-clk50u** (`btn0_q_reg[0]` → `btn0_q_reg[1]`, Slack MET 0.131 ns) and **not** the prior-bag UART IOB input hold of −4.915 now magically MET under min delay 0.500.

Worst setup path (same rpt): `Slack (MET) : 0.115ns`; source `u_a09r2/pv_reg[0][0]/C` → dest `u_a09r2/best_a_reg[0]/D`; **Requirement 20.000 ns**; Data Path Delay 19.796 ns (logic 6.899 / route 12.897); 23 logic levels (CARRY4=7 + LUT2/3/4/5/6); Path Group `clk50u`. Source Clock Delay **6.417 ns**, Destination Clock Delay **6.058 ns**. Real walker/proof path **inside instantiated A09-R2**, not a wrap-only tautology and **not** an exception-manufactured slack.

Clock path on that worst setup (same rpt):

```text
E3  CLK100MHZ
E3  IBUF          CLK100MHZ_IBUF_inst/O
MMCME2_ADV_X1Y2   u_mmcm/CLKOUT0     net clk50u (fo=1, routed)
BUFGCTRL_X0Y16    u_bufg50/O
net (fo=3502, routed) u_a09r2/clk
Source Clock Delay = 6.417 ns
```

Worst **design** hold path this bag (Intra clk50u, same rpt): `Slack (MET) : 0.131ns`; source `btn0_q_reg[0]/C` → dest `btn0_q_reg[1]/D`. MET. This **is** the Design Timing Summary WHS. UART IOB hold is not in the list.

`route_status.rpt`: logical nets 12281; fully routed 6005; **routing errors = 0**.

Synth-only contrast (not the WNS quote): `TIMING_EXTRACT_SYNTH.txt` Design State **Synthesized** `WNS=2.141` `WHS=0.045`. Implementer correctly quotes **routed** 0.115 / 0.131, not synth. `vivado.log`: `synth_design -top a7ng_astra_11_a09r3_uart_iobff_hold_wrap -part xc7a100tcsg324-1` (no `-mode out_of_context`). Synth WHS already ≥ 0 because XDC port-level hold false paths exist at synth; clock-to-clock copies are added after.

WNS ≥ 0. WHS ≥ 0 (DTS). Bounded WHS<0 experiment **not run** (not applicable). Hunt 2: **MET vs raw. Claimed +0.115 / +0.131 matches Design Timing Summary. “Constraints met” is Vivado after exceptions.**

---

### 3. Setup delays 2.000 still applied? Min 0.500 not applied — disclosed?

**PREREG (policy before impl):** max 2.000 kept; min NOT_APPLIED.

**XDC:** `-max 2.000` only. No `-min`.

**Raw setup paths still quote 2.000:**

| Path | Setup slack | Delay used | Hold in this bag |
|------|------------:|------------|------------------|
| `uart_txd_in` A9 → `uart_rx_iob_reg` ILOGIC_X0Y171 | **+19.270 ns MET** | Input Delay **2.000 ns**; route 0.000 ns; DCD 1.931 ns (Fast) | **excepted** (no hold path in `timing_uart_in.rpt`) |
| `uart_tx_iob_reg` OLOGIC_X0Y161 → `uart_rxd_out` D10 | **+7.313 ns MET** | Output Delay **2.000 ns** | **excepted** (no hold path in `timing_uart_out.rpt`) |

`UART_IODELAY.txt`:

```text
UART_IN_MAX_NS=2.000
UART_IN_MIN_NS=NOT_APPLIED
UART_OUT_MAX_NS=2.000
UART_OUT_MIN_NS=NOT_APPLIED
HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART
UART_IN_SETUP_SLACK=19.270
UART_IN_HOLD_SLACK=NA
UART_OUT_SETUP_SLACK=7.313
UART_OUT_HOLD_SLACK=
```

`UART_OUT_HOLD_SLACK` blank vs `NA` is an extract quirk (`get_timing_paths -hold` returned empty). Same meaning: no hold path. `metrics.json` stores both hold slacks as `null`.

**`check_timing.rpt` Design State Routed 23:33:16:**

```text
5. checking no_input_delay (3)  — 0 HIGH unconstrained inputs; 3 MEDIUM false-path: btn[0] sw[0] sw[1]
6. checking no_output_delay (4) HIGH: led[0] led[1] led[2] led[3]
10. partial_input_delay (1) HIGH: uart_txd_in
11. partial_output_delay (1) HIGH: uart_rxd_out
```

**`uart_txd_in` is not in `no_input_delay`.** **`uart_rxd_out` is not in `no_output_delay`.** HIGH partial min-delay on those two ports is the **disclosed** consequence of NOT applying `-min`. Remaining HIGH unconstrained outputs are **LEDs only** (out of this work order).

If min 0.500 had been applied **and** hold false-pathed, that would be the forbidden “copy-paste then hide.” It was not.

Hunt 3: **MET. Setup max 2.000 still applied and visible on raw paths. Min 0.500 NOT applied. Partial-delay HIGH is disclosed.**

---

### 4. IOB FFs still packed?

Wrap (opened, not RESULTS):

```text
(* IOB = "TRUE" *) logic uart_rx_iob = 1'b1;
(* IOB = "TRUE" *) logic uart_tx_iob = 1'b1;
always_ff @(posedge clk) begin
  uart_rx_iob <= uart_txd_in;
  uart_tx_iob <= tx_int;
end
assign uart_rxd_out = uart_tx_iob;
uart_rx u_rx ( .rx(uart_rx_iob), ... );
uart_tx u_tx ( .tx(tx_int), ... );
a7ng_astra_09_r2_cand_ovf u_a09r2 ( ... );
```

XDC: `set_property IOB TRUE [get_ports uart_txd_in]` and `uart_rxd_out`. Frozen `uart_rx.sv` / `uart_tx.sv` **not patched** (hashes MATCH T1700 / T1830).

Raw `util_route.rpt` Design State Routed:

```text
| Bonded IOB                  |   15 |    15 |          0 |       210 |  7.14 |
|   IOB Flip Flops            |    2 |     2 |            |           |       |
| ILOGIC                      |    1 |     1 |          0 |       210 |  0.48 |
|   IFF_Register              |    1 |     1 |            |           |       |
| OLOGIC                      |    1 |     1 |          0 |       210 |  0.48 |
|   OUTFF_Register            |    1 |     1 |            |           |       |
```

`UART_IOBFF.txt` / `vivado.log` post-route extract:

```text
UART_RX_IOB_CELL=uart_rx_iob_reg  BEL=ILOGICE2.IFF  LOC=ILOGIC_X0Y171  PACKED=YES
UART_TX_IOB_CELL=uart_tx_iob_reg  BEL=OLOGICE2.OUTFF LOC=OLOGIC_X0Y161 PACKED=YES
UTIL_IOB_FLIP_FLOPS=2  UTIL_ILOGIC=1  UTIL_OLOGIC=1  UART_IOBFF=YES
```

Timing path locations independently show the same sites: input dest `ILOGIC_X0Y171 uart_rx_iob_reg/D`; output source `OLOGIC_X0Y161 uart_tx_iob_reg`. Same BEL/LOC as the prior IOBFF bag. Clock loads **3502** (`clock_util_route.rpt` BUFGCTRL_X0Y16 `u_bufg50/O` net `clk` period 20.000).

`io.rpt` Design `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`, Total User IO=15, Date 23:33:15:

```text
| A9         | uart_txd_in  | ... | INPUT  | LVCMOS33 | ... | FIXED |
| D10        | uart_rxd_out | ... | OUTPUT | LVCMOS33 | ... | FIXED |
```

Direction matches Digilent names: **A9 = FPGA RX (`uart_txd_in`) INPUT FIXED**; **D10 = FPGA TX (`uart_rxd_out`) OUTPUT FIXED**. Pins are **not swapped**. `UART_IOB.txt`: `UART_IOB=YES`.

Hunt 4: **MET. IOB FFs still packed YES (ILOGIC IFF + OLOGIC OUTFF). `IOB=TRUE` was not ignored.**

---

### 5. Prior IOBFF bag still WHS=−4.915 on disk?

Headers opened this session (not RESULTS):

| Bag | Raw identity still on disk |
|-----|----------------------------|
| **ASTRA-11-A09R3-UART-IOBFF-01** | `timing_route.rpt` **Sun Sep 6 23:06:09**, Design `a7ng_astra_11_a09r3_uart_iobff_wrap`, Design Timing Summary **WNS=0.115 WHS=−4.915**, line “Timing constraints are not met.” Inter Clock `uart_io_vclk→clk50u` hold **−4.915**. Hold path Slack (VIOLATED) **−4.915 ns** `uart_txd_in` → `uart_rx_iob_reg` ILOGIC_X0Y171, Input Delay **0.500 ns**, route 0.000 ns, DCD 6.503 ns. XDC still has `-min 0.500`. RESULTS marker still `WHS=-4.915`. Wrap SHA KEEP `4f97db83…` MATCH this bag KEEP. XDC KEEP `dad1dbf2…` MATCH. **Not overwritten.** |
| ASTRA-11-A09R3-UART-IODELAY-01 | `timing_route.rpt` **Sun Sep 6 22:39:44**, Design `a7ng_astra_11_a09r3_uart_iodelay_wrap`, **WNS=0.681 WHS=0.100**. Wrap SHA KEEP `34353bb7…` MATCH. **Not overwritten.** |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 22:12:21**, Design `a7ng_astra_11_a09r3_uart_impl_wrap`, **WNS=0.305**. Wrap SHA KEEP `1c3a95f4…` MATCH. **Not overwritten.** |
| ASTRA-11-A09R2-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 21:26:25**, Design `a7ng_astra_11_a09r2_impl_wrap`, **WNS=0.648**. Wrap SHA KEEP `1932ee4c…` MATCH. **Not overwritten.** |
| ASTRA-11-A09-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 19:48:09**, Design `a7ng_astra_11_a09_impl_wrap`, **WNS=1.041**. **Not overwritten.** |
| ASTRA-SOC-RTP-WRAP-ROUTE | `timing.rpt` **Sun Sep 6 02:11:52**, Design `arty_a7_astra_rtp_soc_top`, **WNS=5.733**. **Not overwritten.** |

This routed WNS=+0.115 WHS=+0.131 is **not** a rewrite of the −4.915 report. Different design name (`…hold_wrap`), different date (23:33:11 vs 23:06:09), Inter Clock hold blank vs −4.915, prior bag intact. Hunt 5: **MET. Prior IOBFF bag still WHS=−4.915 on disk.**

---

### 6. Overclaim BOARD_PASS / all-constraints-met including the excepted hold?

| Claim surface | What it says | Auditor |
|---------------|--------------|---------|
| Vivado DTS line 144 | `All user specified timing constraints are met.` | True **after** hold-only false paths. Not a physical UART-hold MET. |
| RESULTS RESULT | `PASS_NARROW` this bag only; UART I/O hold excepted; Intra clk50u hold MET +0.131; **Not BOARD_PASS**; not a retune of frozen min 0.500 | Honest grade language |
| RESULTS quotes DTS “constraints met” | Quoted, then immediately qualified with Inter Clock hold blank / excepted | Not a hide |
| `metrics.json` `timing_constraints_met: true` | Paired with `hold_policy_note` that UART I/O hold is excepted | Not a hide |
| CLOSEOUT `UART_IN_HOLD_SLACK = NA (FALSE_PATH_HOLD excepted)` | Explicit | Not a hide |
| ACK / PREREG / RESULTS / CLOSEOUT / log DONE | `PRODUCTION_TOP=UNKNOWN`, `PROGRAM=NO`, `BIT=NOT_BUILT` | No BOARD_PASS |
| LOOP_STATE (read-only) | `program=false`, `board_pass=false`, `astra13=BLOCKED` | Consistent |

**Not OVERCLAIM of BOARD_PASS.** **Not OVERCLAIM of hiding WHS** (they do not claim the −4.915 path now METs). **Borderline language:** quoting Vivado “all user specified timing constraints are met” as a fact of the DTS is accurate **and** must not be promoted as “UART IOB hold is met.” Implementer already says excepted. Auditor grades **PASS_NARROW**, not PASS.

Hunt 6: **No BOARD_PASS. No hide of the exception. Do not read DTS “constraints met” as physical IOB hold MET.**

---

### 7. Hash before impl? No `.bit`? PRODUCTION_TOP UNKNOWN? A09-R2 instantiated?

**Hash order:**

| Event | Stamp |
|-------|-------|
| `SHA256.txt` / `SOURCE_HASHES.txt` **BEFORE impl** | `2026-09-06T23:28:09.0098459+07:00` |
| Vivado start (`vivado.log`) | `Sun Sep 6 23:28:10 2026` (PID 49196) — **~1 s later** |
| Reports | `23:33:10` (util_hier) … `23:33:11` (timing_route) … `23:33:15` (io/clocks) … `23:33:16` (exceptions/check_timing/uart_in/out) |
| Vivado DONE / `SHA256_POST.txt` **AFTER impl** | DONE line then `2026-09-06T23:33:17.7901830+07:00` |

PRE vs POST compiled RTL+XDC+tcl + transitive `.svh`: **19/19 identical strings** (opened manifests; not re-hashed). `.svh` **is** in the pre-impl freeze. Hunt 7 hash: **MET.** Not hash-after-scores theatre.

R2 DUT `15a919f1…` **MATCH** IOBFF / I/O-delay / UART-impl-route freeze. Frozen leftover A09 `9fdbe0d6…` **MATCH** provenance (KEEP; **not compiled**). Frozen SGD `b66ef328…` MATCH. `uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH ASTRA-09-R3-UART-XSIM-01. Prior IOBFF wrap `4f97db83…` MATCH KEEP (not compiled as this top). Prior IOBFF XDC `dad1dbf2…` MATCH KEEP. Prior I/O-delay wrap `34353bb7…` MATCH KEEP. Prior UART impl wrap `1c3a95f4…` MATCH KEEP.

**No bitstream / PROGRAM=NO / PRODUCTION_TOP=UNKNOWN**

- Bag directory: no `.bit` / `.bin` / `.mcs`. `ckpt/` holds `synth.dcp` + `route.dcp` only.
- `vivado.log` DONE: `BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN`. No `write_bitstream` command.
- `vivado.jou`: no `write_bitstream`, no `.bit`.
- TCL: `write_bitstream` renamed to abort before synth. WHS≥0 path never calls it. WHS<0 path also never calls it.
- ACK / PREREG / RESULTS / CLOSEOUT / metrics: `PRODUCTION_TOP=UNKNOWN`, `PROGRAM=NO`.
- LOOP_STATE (read-only): `program=false`, `board_pass=false`, `astra13=BLOCKED`, `production_top=UNKNOWN`, `com12=USER_SAYS_PLUGGED_UNPROGRAMMED`.

Board plugged ≠ programmed.

**A09-R2 instantiated; frozen leftover A09 not compiled**

Bag contains new wrap + bag-local AXI plant only as RTL. Wrap instantiates `a7ng_astra_09_r2_cand_ovf u_a09r2` with `keep_hierarchy`. `load_v_i` tied 0. Frozen leftover A09 **not instantiated**. Plant header: bag-local behavioral AXI plant, not silicon BRAM, not `a7ng_axi_bram128`.

Raw log elaboration (not RESULTS):

```text
synthesizing module 'a7ng_astra_11_a09r3_uart_iobff_hold_wrap' [.../ASTRA-11-A09R3-UART-IOBFF-HOLD-01/a7ng_astra_11_a09r3_uart_iobff_hold_wrap.sv:8]
synthesizing module 'MMCME2_BASE'
synthesizing module 'BUFG'
synthesizing module 'uart_rx' [.../rtl/board/uart_rx.sv:2]
synthesizing module 'uart_tx' [.../rtl/board/uart_tx.sv:2]
synthesizing module 'a7ng_astra_09_r2_cand_ovf' [.../rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv:9]
synthesizing module 'a7ng_query_axi_sparse'
synthesizing module 'a7ng_shared_rank_sgd_q8_sym_f2r2'
synthesizing module 'a7ng_astra_11_a09r3_uart_iobff_hold_plant' [.../a7ng_astra_11_a09r3_uart_iobff_hold_plant.sv:6]
U_A09R2_CELLS=11064
U_RX_CELLS=76
U_TX_CELLS=56
UART_IOBFF_CELLS=2
```

**Not synthesized:** `a7ng_astra_09_integ_path` (zero log matches), `a7ng_astra09_pipe`, `arty_a7_astra_rtp_soc_top`, `a7ng_axi_bram128`, `a7ng_astra_11_a09r3_uart_impl_wrap`, `a7ng_astra_11_a09r3_uart_iodelay_wrap`, `a7ng_astra_11_a09r3_uart_iobff_wrap`. **Required instantiate-not-copy and frozen-A09-not-compiled: MET.**

**Clock-network real vs virtual (pipe vs I/O ref):**

`clocks_route.rpt` Design State **Routed** 23:33:15:

```text
Clock         Period(ns)  Waveform(ns)    Attributes  Sources
sys_clk_pin   10.000      {0.000 5.000}   P           {CLK100MHZ}
uart_io_vclk  20.000      {0.000 10.000}  V           {}
clk50u        20.000      {0.000 10.000}  P,G,A       {u_mmcm/CLKOUT0}
clkfb         10.000      {0.000 5.000}   P,G,A       {u_mmcm/CLKFBOUT}
```

`clock_util_route.rpt`: BUFGCTRL=1 at **BUFGCTRL_X0Y16**, clock loads **3502**, period 20.000, driver `u_bufg50/O` net `clk`, source `MMCME2_ADV/CLKOUT0` site **MMCME2_ADV_X1Y2**. Pipe clock is **not** virtual. Quoted internal WNS includes clock-network delay (SCD=6.417 ns).

Hunt 7: **MET.**

---

## Resources (raw; not the WNS quote)

Quoted **synth** `util_synth.rpt` (RESULTS/UTIL_EXTRACT_SYNTH): Slice LUTs **5682**, Slice Registers **5010**, BRAM **0**, DSP **2**.

Quoted **routed** `util_route.rpt` Design State Routed:

```text
| Slice LUTs              | 4802 |     0 |          0 |     63400 |  7.57 |
| Slice Registers         | 3500 |     0 |          0 |    126800 |  2.76 |
| Block RAM Tile          |    0 |
| DSPs                    |    2 |
| Bonded IOB              |   15 |
| IOB Flip Flops          |    2 |
| ILOGIC                  |    1 |
| OLOGIC                  |    1 |
```

Hierarchical routed (`util_hier_route.rpt`):

```text
| a7ng_astra_11_a09r3_uart_iobff_hold_wrap | (top)                                 | 4802 | 3500 | 0 | 2 |
|   u_a09r2                                  | a7ng_astra_09_r2_cand_ovf             | 4293 | 2692 | 0 | 2 |
|     u_sgd                                  | a7ng_shared_rank_sgd...               |  530 |  610 | 0 | 2 |
|     u_sp                                   | a7ng_query_axi_sparse                 | 3334 |  696 | 0 | 0 |
|       u_walk                               | a7ng_sparse_dir_axi                   | 1006 |  450 |
|       g_law.u_qse                          | a7ng_query_role_extract               | 2328 |  202 |
|   u_plant                                  | a7ng_astra_11_a09r3_uart_iobff_hold_plant | 170 | 73 | 0 | 0 |
```

Honest occupancy of a **live UART wrap**: QSE LUT=2328 is **not** the I/O-folded QSE=39 of A09R2 wrap. Plant is behavioral (LUT=170, BRAM=0), **not** wrap-route BRAM=2. SGD DSP×2 remains. Worst setup path still inside `u_a09r2`. **Not a stub DUT.** Also **not** whole-chip `axi_bram128` / DDR occupancy. Do not add 4802 to prior IOBFF 4802, I/O-delay 4803, UART wrap 4804, A09R2 wrap 1321, leftover A09 wrap 1305, or wrap-route 4244 as a chip sum.

Comparison (not identity):

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 4802 | 3500 | 0 | 2 | **Routed clk50u WNS=+0.115 WHS=+0.131 IOB FF YES HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART setup max 2.000 min NOT_APPLIED** |
| This bag synth | 5682 | 5010 | 0 | 2 | Synthesized (not the quote; extract +2.141 / WHS=+0.045) |
| ASTRA-11-A09R3-UART-IOBFF-01 routed | 4802 | 3500 | 0 | 2 | Routed IOB FF YES delays 2.000/0.500 **WNS=+0.115 WHS=−4.915** — **not overwritten** |
| ASTRA-11-A09R3-UART-IODELAY-01 routed | 4803 | 3500 | 0 | 2 | Routed delays 2.000/0.500 **no IOB FF +0.681** — not overwritten |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed | 4804 | 3500 | 0 | 2 | Routed UART IOB, **I/O unconstrained +0.305** — not overwritten |
| ASTRA-11-A09R2-IMPL-ROUTE-01 routed | 1321 | 1103 | 0 | 2 | Routed no-UART **+0.648** — not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed different DUT **+1.041** — not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |

---

## Overclaim / cheat / tautology

| Hunt | Finding |
|------|---------|
| `set_false_path -hold` hide-WHS cheat (min 0.500 applied then concealed) | **Not found.** Min NOT_APPLIED. Exception frozen in PREREG before impl. Hold-only (setup still 2.000). Disclosed. |
| False-path-hold honest async UART exception | **YES.** UART 115200 async; no related FTDI clock; IOB FF + `uart_rx` 2-FF is CDC. Allowed pick. Written before impl. |
| DTS WHS≥0 tautological given the exception | **YES as a fact.** The −4.915 path is excepted, not MET. Physical IBUF→IFF geometry unchanged. Grade PASS_NARROW, not PASS. |
| RESULTS vs raw rpt mismatch on WNS/TNS/WHS | **None.** +0.115 / 0.000 / +0.131 Design State Routed; Intra clk50u +0.115 / +0.131 |
| RESULTS claims UART IOB hold now MET +0.131 | **Not found.** Explicitly intra-clk50u `btn0_q`; UART hold excepted |
| BOARD_PASS / silicon UART | **Not claimed.** BIT=NOT_BUILT; PROGRAM=NO; `uart_io_vclk` is V |
| “All constraints met” including excepted hold as physical | **Vivado line is after exceptions.** Implementer qualifies. Auditor does not promote it as physical hold MET. Not OVERCLAIM of BOARD / Master |
| IOB=TRUE ignored | **Not found.** IFF_Register=1 OUTFF_Register=1; BEL ILOGICE2.IFF / OLOGICE2.OUTFF; timing Location ILOGIC_X0Y171 |
| Min 0.500 retuned / secretly applied | **Not found.** XDC has no `-min`; check_timing HIGH partial delay; SHA PRE=POST `046a3cb2…` |
| −4.915 bag overwritten or quoted as this WHS | **Not overwritten** (23:06:09 still −4.915, design `uart_iobff_wrap`, min 0.500 still in that XDC). **Not quoted as this result** |
| Wrap-route WNS=+5.733 claimed or overwritten | **Not claimed. Not overwritten** (02:11:52 still 5.733) |
| A09R2 wrap WNS=+0.648 claimed or overwritten | **Not claimed. Not overwritten** (21:26:25 still 0.648) |
| A09 wrap WNS=+1.041 overwritten | **Not overwritten** (19:48:09 still 1.041) |
| UART impl-route WNS=+0.305 overwritten | **Not overwritten** (22:12:21 still 0.305) |
| I/O-delay WNS=+0.681 overwritten | **Not overwritten** (22:39:44 still 0.681) |
| Pipe clock virtual / no SCD | **Not found.** P,G,A `clk50u`; E3 IBUF→MMCM→BUFG→`u_a09r2/clk` fo=3502 routed; SCD=6.417 ns. Only I/O ref is virtual (declared) |
| Copy-paste graph called instantiate | **Not found.** Thin UART FIFO wrap + pad FFs + live RTL path in synth log |
| Frozen leftover A09 compiled as DUT | **Not found.** Zero synth/log matches; tcl forbids; KEEP hash only |
| Stub / empty DUT | **Not found.** Hier `u_a09r2` LUT=4293; QSE=2328; SGD DSP48E1×2; U_A09R2_CELLS=11064; worst setup inside DUT walker |
| Bitstream / PROGRAM | **No bit in this bag.** ACK/RESULTS PROGRAM=NO |
| `PRODUCTION_TOP` frozen | **UNKNOWN** in ACK / log DONE / RESULTS / CLOSEOUT / LOOP_STATE |
| Hash freeze after looking at WNS / `.svh` omitted | **Not found.** PRE 23:28:09 < Vivado 23:28:10; 5 `.svh` in PRE; POST 19/19 MATCH |
| Fail r0 wipe | **N/A.** Single successful session; DTS WHS≥0; no fail_r0 artifact to wipe |
| Duplicate clock-to-clock exceptions (positions 9–14) | **Nit.** TCL re-applies the same PREREG policy three times. Same Hold=false. Not a second policy. |
| LUT used as whole-chip occupancy | **Not claimed.** Documented fixture plant / BRAM=0 vs wrap-route BRAM=2 |

qstack adversary: worst setup path is a real placed/routed A09-R2 walker (`pv_reg[0][0]` → `best_a_reg[0]`, 23 logic levels) under a **propagated generated** 20 ns clock with SCD=6.417 ns and 3502 routed clock loads. `set_false_path -hold` on UART pads / `uart_io_vclk`↔`clk50u` **does not** create that 0.115 ns slack. UART IOB FFs remain physically packed (ILOGIC/OLOGIC). The DTS WHS flip from −4.915 to +0.131 is **entirely** the hold exception removing the IBUF→IFF path from the timer; intra-clk50u hold was already MET +0.131 in the prior bag. That is an honest STA-envelope answer to the declared unknown, and a tautology if read as “IOB hold is now clean.” Virtual `uart_io_vclk` with DCD/SCD=0 on the I/O side is the same construction as T1830; this bag stops checking hold against it. WNS=+0.115 is the **same class of P&R** as the IOBFF bag (same worst path, same occupancy, same IOB sites), not a recycled report (different design name, different date, Inter Clock hold blank, prior bag intact). Delay/exception policy was hashed before Vivado started.

---

## Logic bugs

No route FAIL. No RESULTS/raw contradiction on the quoted DTS WNS/TNS/WHS or UART **setup** slacks. Route complete (0 failed nets). UART IOB FFs packed as required. UART setup still constrained (max 2.000). Min not applied. WHS ≥ 0 in DTS so the handoff WHS<0 bounded experiment was correctly **not** run. Frozen `uart_rx` / R2 DUT not patched.

The excepted hold path is **not** a DUT walker/SGD logic bug. It is the packed IOB input FF vs virtual 20 ns I/O clock + real MMCM/BUFG destination delay. Intra-`clk50u` hold remains MET.

Residuals (not this-bag FAIL of the STA-envelope unknown):

1. DTS WHS≥0 is **envelope-tautological**. Physical IBUF→IFF hold geometry is unchanged (prior bag still −4.915 under min 0.500). Do not promote this bag as UART IOB hold physically MET.
2. Vivado “All user specified timing constraints are met” is **after** hold-only false paths. Do not read it as all-constraints-met **including** the excepted hold as a physical check.
3. `uart_io_vclk` is **virtual**. I/O STA is an envelope at the pipe period (20 ns) with setup max 2.000, **not** FT2232H Tsu and **not** a 115200 baud clock. Excepting hold on that envelope ≠ silicon UART. PREREG already says this.
4. Clock-to-clock `set_false_path -hold` is applied three times (exceptions 9–14). Redundant, same policy. Not a second unknown.
5. LED outputs remain HIGH `no_output_delay` (`led[0:3]`). Out of this work order.
6. DRC DSP unpipelined (DPIP/DPOP) — expected; frozen F2R2 SGD. Do not patch from this bag.
7. Bag-local `a7ng_astra_11_a09r3_uart_iobff_hold_plant` is a **behavioral fixture** (BRAM=0). Master ASTRA-11 fullchip plant (`a7ng_axi_bram128` / DDR) remains open.
8. Occupancy LUT=4802 / QSE=2328 is **this UART IOB-FF HOLD wrap**, not additive with prior IOBFF 4802, I/O-delay 4803, UART wrap 4804, A09R2 wrap 1321, leftover A09 wrap 1305, or wrap-route 4244 BRAM=2. WNS=+0.115 matching prior IOBFF +0.115 is **STA-envelope on the same P&R class**, not a delta on the same DCP (different named wrap, prior bag intact).
9. No independent `Get-FileHash` this process. Overlapping R2/SGD/A09/uart/pkg hashes MATCH prior bags. Wrap/XDC/tcl/plant digests are first-recorded here; PRE=POST strings match.
10. Functional MAGIC A2 / OVF INCOMP on the byte stream remains **XSim** (T1700). This bag does not re-prove UART protocol on silicon or in XSim. Extra IOB sample stage vs the I/O-delay wrap is wrap-level and **not** re-proven here.
11. Named wrap is a **candidate** UART SoC path with STA I/O **setup** delays, packed IOB FFs, and a frozen hold exception — not a silent `PRODUCTION_TOP` freeze. T1830 residual 2 is **closed as STA-envelope evidence class** for *this named wrap* and **not closed as a physical IOB hold fix**, **not closed as production identity**, and **not closed as silicon UART**.
12. `UART_OUT_HOLD_SLACK` blank vs `NA` in `UART_IODELAY.txt` is extract noise, not a second hold path.

No DUT logic patch requested. Auditor does not fix.

---

## This bag vs Master ASTRA-11 / ASTRA-13

Work-order unknown **answered**: for wrapper `a7ng_astra_11_a09r3_uart_iobff_hold_wrap` / instance `u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf` on `xc7a100tcsg324-1`, with UART IOB FFs **packed** (`uart_rx_iob_reg` ILOGICE2.IFF ILOGIC_X0Y171; `uart_tx_iob_reg` OLOGICE2.OUTFF OLOGIC_X0Y161) plus HOLD_POLICY **`FALSE_PATH_HOLD_ASYNC_UART` frozen in PREREG before impl** (setup max **2.000**, min **NOT_APPLIED**, hold-only false path on UART pads + `uart_io_vclk`↔`clk50u`), post-route (Design State **Routed**) is **WNS=+0.115 ns TNS=0.000 ns WHS=+0.131 ns @ Design Timing Summary** (Intra **clk50u WNS=+0.115 WHS=+0.131 MET**, 20.000 ns / 50 MHz) with **real** E3 IBUF → MMCME2_ADV_X1Y2 → BUFGCTRL_X0Y16 → `u_a09r2/clk` (SCD=6.417 ns, fo=3502 routed), UART I/O setup **in +19.270 ns / out +7.313 ns**, UART I/O hold **excepted** (Inter Clock hold blank; `timing_uart_in/out` setup-only), UART ports **off** unconstrained lists (HIGH partial min-delay expected), UART IOB **A9 INPUT / D10 OUTPUT FIXED**, IOB FF **YES**, **BIT=NOT_BUILT**, **PROGRAM=NO**, **PRODUCTION_TOP=UNKNOWN**. Frozen leftover A09 **not compiled**. ASTRA-11-A09R3-UART-IOBFF-01 WNS=+0.115 WHS=−4.915 **not overwritten**. UART I/O-delay WNS=+0.681 **not overwritten**. UART impl-route WNS=+0.305 **not overwritten**. A09R2 wrap WNS=+0.648 **not overwritten**. Wrap-route WNS=+5.733 **not overwritten**.

T1830 residual 2 (**UART IOB input hold vs virtual `uart_io_vclk`**) is **closed as STA-envelope evidence class** for *this named wrap with packed ILOGIC/OLOGIC pad FFs, frozen false-path-hold, DTS WHS≥0, no bitstream*. It is **not** permission to mark Master ASTRA-11 or ASTRA-13 done, **not** permission to freeze `PRODUCTION_TOP`, **not** permission to say UART IOB hold is physically MET, and **not** permission to program.

| Master item | This bag |
|---|---|
| ASTRA-11 FULLCHIP-COFIT (UART + MMCM + I/O + AXI BRAM/DDR plant + production path as one frozen top) | Named UART wrap + MMCM/BUFG + D10/A9 IOB + packed IOB FFs + STA I/O **setup** + hold exception + fixture AXI plant. No `axi_bram128`. No DDR. `PRODUCTION_TOP=UNKNOWN`. UART I/O hold **excepted**, not physically MET |
| ASTRA-11-A09R3-UART-IOBFF-01 WNS=+0.115 WHS=−4.915 | Different wrap (`uart_iobff_wrap`); min 0.500; bag **not overwritten**; this WHS=+0.131 is **not** that −4.915 magically MET |
| ASTRA-11-A09R3-UART-IODELAY-01 WNS=+0.681 | Different wrap (`uart_iodelay_wrap`); ILOGIC=0; bag **not overwritten** |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 WNS=+0.305 | Different wrap (`uart_impl_wrap`); I/O unconstrained; bag **not overwritten** |
| ASTRA-11-A09R2-IMPL-ROUTE-01 WNS=+0.648 | Different wrap, no UART; bag not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041 | Different DUT `a7ng_astra_09_integ_path`; bag not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733 | Different top `arty_a7_astra_rtp_soc_top`; bag not overwritten |
| ASTRA-13 FINAL-BOARD-ACCEPTANCE | BIT=NOT_BUILT; PROGRAM=NO; no JTAG/COM12; `PRODUCTION_TOP=UNKNOWN` |
| LM06 language | Not opened |
| ASTRA-09-R3-UART-XSIM-01 MAGIC A2 | Prior XSim bag; not this impl/route result |

**No Master-gate overclaim found.**

Master **ASTRA-11 FULLCHIP-COFIT** remains **OPEN** (fixture plant, not frozen SoC top, not wrap-route identity, UART I/O hold excepted not physically proven).

Master **ASTRA-13 FINAL-BOARD-ACCEPTANCE** remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority.

Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-10 whole-chip remain **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-11-A09R3-UART-IOBFF-HOLD-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw routed reports: instantiate-not-copy of `a7ng_astra_09_r2_cand_ovf`, frozen leftover A09 not compiled, hash-before-impl including `.svh`, HOLD_POLICY **`FALSE_PATH_HOLD_ASYNC_UART` frozen in PREREG before impl** (honest async UART hold exception; **not** a min-0.500 hide-WHS cheat), setup max **2.000 still applied**, min **NOT_APPLIED and disclosed** (`check_timing` HIGH partial delay), real pipe clock-network (not virtual), virtual I/O ref only as declared, **IOB FFs packed YES** (ILOGIC IFF + OLOGIC OUTFF), WNS=+0.115 ≥ 0, DTS WHS=+0.131 ≥ 0 (intra clk50u; UART I/O hold **excepted**, Inter Clock hold blank), UART in setup +19.270 / out setup +7.313, UART IOB A9 INPUT / D10 OUTPUT FIXED, PROGRAM=NO, no bitstream, `PRODUCTION_TOP=UNKNOWN`, prior IOBFF WNS=+0.115 WHS=−4.915 bag **not overwritten**, no BOARD_PASS / ASTRA-13 / LM06 overclaim, no theft of +0.681 / +0.305 / +0.648 / +1.041 / +5.733.

Not PASS (Master ASTRA-11 fullchip, ASTRA-13 board, silicon UART, `axi_bram128` plant, physical IOB hold MET, `PRODUCTION_TOP` freeze, FT2232H Tsu, all-constraints-met including excepted hold as a physical check).  
Not FAIL (raw DTS WNS and WHS match claim and are ≥ 0; IOB FFs packed; policy frozen before impl; min not copy-pasted then hidden; route 0 error; frozen R2/SGD/leftover A09/uart/F2R/persist unpatched; leftover A09 not compiled; pipe clock path real; prior WNS bags intact including −4.915; exception disclosed).  
Not OVERCLAIM (ACK/RESULTS keep Master 11/13/BOARD/LM06/`PRODUCTION_TOP` open; do not steal prior IOBFF −4.915, I/O-delay +0.681, UART wrap +0.305, A09R2 wrap +0.648, leftover A09 wrap +1.041, wrap-route +5.733, or UART XSim MAGIC A2; do not claim BOARD_PASS; do not claim the −4.915 path now METs).

Classification of Hunt 1 in one line: **HONEST frozen async UART `set_false_path -hold` (not a hide-WHS cheat); DTS WHS≥0 is envelope-tautological; PASS_NARROW of the declared STA-envelope unknown.**

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared routed-WNS-and-DTS-WHS-at-50 MHz-with-packed-UART-IOB-FFs-and-frozen-FALSE_PATH_HOLD_ASYNC_UART claim.

**P2 / residuals (do not reopen this bag as FAIL of the STA-envelope unknown):**

1. Do **not** promote this WNS=+0.115 / WHS=+0.131 / IOB FF YES / HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART to BOARD_PASS, ASTRA-13, physical IOB hold MET, prior IOBFF WNS=+0.115 WHS=−4.915, prior I/O-delay WNS=+0.681, prior UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, wrap-route WNS=+5.733, leftover A09 wrap WNS=+1.041, UART XSim MAGIC A2, or `PRODUCTION_TOP=a7ng_astra_11_a09r3_uart_iobff_hold_wrap`.
2. Keep the prior IOBFF bag’s WHS=−4.915 on disk as the physical IBUF→IFF hold evidence under min 0.500. This bag excepts that check; it does not erase it.
3. Do **not** add this LUT/FF to prior IOBFF 4802/3500, I/O-delay 4803/3500, UART wrap 4804/3500, A09R2 wrap 1321/1103, leftover A09 wrap 1305/1075, or wrap-route 4244/3810 BRAM=2. Fixture plant BRAM=0 is honest. Whole-chip co-fit needs **one** current-source SoC top (Master ASTRA-11) plus an explicit `PRODUCTION_TOP` decision.
4. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
5. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv` and do **not** patch frozen R2 DUT / uart_rx / uart_tx from DRC DSP warnings or from this exception.
6. `uart_io_vclk` remains a virtual STA envelope. LED I/O delay remains a residual. Extra IOB sample stage vs T1700 XSim wrap is **not** re-proven functionally here.
7. Duplicate clock-to-clock hold false paths (exceptions 9–14) are redundant, not a second policy. Optional cleanup in a **new named bag** only.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated implement+route of a **new named UART wrap** instantiating frozen `a7ng_astra_09_r2_cand_ovf` at declared 50 MHz with **real routed clock-network**, HOLD_POLICY **`FALSE_PATH_HOLD_ASYNC_UART` frozen in PREREG before impl** (honest async UART hold exception, **not** a min-0.500 hide-WHS cheat), setup max **2.000** still applied, min **NOT_APPLIED** (disclosed), **IOB FFs packed YES** (ILOGIC IFF + OLOGIC OUTFF), WNS=+0.115 ≥ 0, DTS WHS=+0.131 ≥ 0 (intra clk50u; UART I/O hold excepted), UART IOB **A9 INPUT / D10 OUTPUT FIXED**, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`, prior IOBFF WNS=+0.115 WHS=−4.915 bag **not overwritten**.

`REJECT_PROMOTION` — Master **ASTRA-11** (fullchip co-fit / frozen SoC UART top / on-chip plant), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. Packed IOB FF UART wrap with STA setup + hold exception **≠** silicon UART and **≠** physical IOB hold MET. Do not claim all-constraints-met including the excepted hold as a physical check.

Not `FAIL_LOOP`: STA-envelope unknown answered with DTS WNS≥0 and WHS≥0; IOB FFs packed; policy frozen before impl; prior −4.915 bag intact; evidence internally consistent.

Master ASTRA-09: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-11-A09R3-UART-IOBFF-01 routed WNS=+0.115 WHS=−4.915: **untouched**.  
ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681: **untouched**.  
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305: **untouched**.  
ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648: **untouched**.  
ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041: **untouched, different DUT**.  
ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733: **untouched, different top**.  
ASTRA-09-R3-UART-XSIM-01: **untouched, still not BOARD**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1900Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-11-A09R3-UART-IOBFF-HOLD-01; Master ASTRA-11/13 OPEN; raw routed WNS=+0.115 TNS=0.000 WHS=+0.131 (Design State Routed; Intra clk50u WHS=+0.131 MET; UART I/O hold excepted); false-path-hold HONEST (not cheat); IOB FF yes; PROGRAM=NO; BOARD still blocked YES.
