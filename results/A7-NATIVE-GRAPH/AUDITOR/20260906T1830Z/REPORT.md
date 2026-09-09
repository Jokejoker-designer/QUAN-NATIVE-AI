# ASTRA auditor REPORT — 20260906T1830Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA11_A09R3_UART_IOBFF_INDEPENDENT_AUDIT; astra11_iodelay=AUDITOR_PASS_NARROW_ROUTED_WNS_P0681_DELAYS_2P000_0P500; astra11_iobff=IMPLEMENTER_CLAIM_WNS_P0115_WHS_M4915_PENDING_AUDITOR; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-11 FULLCHIP-COFIT / ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-11-A09R3-UART-IOBFF-01 + prior auditor 20260906T1800Z (UART I/O-delay ACCEPT_PARTIAL PASS_NARROW WNS=+0.681 delays 2.000/0.500; residual 5 = IOB FF pack — this bag is additive IOB=TRUE / wrap pad FFs on a new named wrap, not a patch of the +0.681 bag) + auditor 20260906T1730Z (UART impl-route WNS=+0.305) + auditor 20260906T1700Z (UART XSim PASS_NARROW) + auditor 20260906T1630Z (A09R2 wrap-route WNS=+0.648; do not overwrite)
EVIDENCE   = raw timing_route.rpt / timing_uart_in.rpt / timing_uart_out.rpt / check_timing.rpt / io.rpt / clocks_route.rpt / clock_util_route.rpt / util_route.rpt / util_hier_route.rpt / route_status.rpt / ram_route.rpt / drc.rpt / util_synth.rpt / timing_synth.rpt / vivado.log / vivado.jou / wrap SV / plant SV / tcl / XDC / UART_IOB.txt / UART_IOBFF.txt / UART_IODELAY.txt / SHA manifests / PREREG / ACK (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_impl.ps1` / `run_impl.tcl` (would overwrite `vivado.log` / routed reports). Did not program the plugged board.

This process has **no independent `Get-FileHash`**. Freeze lists were compared to opened files and to overlapping hashes in `ASTRA-09-R2-CAND-OVF-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-11-A09R3-UART-IODELAY-01`, `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, and T1630/T1700/T1730/T1800 freeze strings.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R3-UART-IOBFF-01/`

Top `a7ng_astra_11_a09r3_uart_iobff_wrap` (bag-local, **new named**) instance **`u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv`**. UART `u_rx` / `u_tx` from `rtl/board/uart_rx.sv` / `uart_tx.sv`. Wrap-level pad FFs `uart_rx_iob` / `uart_tx_iob` with `(* IOB = "TRUE" *)` plus XDC `set_property IOB TRUE`. Pin clock `CLK100MHZ` E3 period 10.000 ns. Pipe clock MMCM 100→50 + BUFG, generated `clk50u` period 20.000 ns (**real**, attributes P,G,A). I/O timing reference `uart_io_vclk` period 20.000 ns (**virtual**, attribute V) with frozen `set_input_delay` / `set_output_delay` **max 2.000 / min 0.500** on `uart_txd_in` A9 and `uart_rxd_out` D10. Part `xc7a100tcsg324-1`. Mode **in-context** `synth_design` (not `-mode out_of_context`) then `opt_design` / `place_design` / `route_design`. No bitstream.

Gate under review is **work-order ASTRA-11-A09R3-UART-IOBFF-01 only** — one unknown: with UART IOB FFs packed (`IOB=TRUE` or equivalent on `uart_txd_in` A9 / `uart_rxd_out` D10) plus the same frozen delays 2.000/0.500, after implement+route of a **new named UART wrap** instantiating frozen A09-R2 on `xc7a100tcsg324-1` at a declared 50 MHz constraint with clock-network delay included, is routed WNS ≥ 0 — **without a bitstream**. Quote whether IOB FFs packed. **Not** a patch of `ASTRA-11-A09R3-UART-IODELAY-01` (that bag’s routed WNS=+0.681 must remain on disk). **Not** Master ASTRA-11 fullchip close. **Not** ASTRA-13 board acceptance. **Not** freeze of `PRODUCTION_TOP`.

Parent residual from auditor `20260906T1800Z`: UART I/O-delay CLOSED_NARROW WNS=+0.681 delays 2.000/0.500, UART ports constrained, ILOGIC=0 / OLOGIC=0. Residual 5: IOB FF pack (and optional LED I/O delay). Parent does **not** freeze `PRODUCTION_TOP`. This bag is **additive IOB-FF impl+route** of a new named UART wrap.

Hunt (parent / work order / this dispatch):

1. Quote Design Timing Summary WNS **and** WHS from RAW `timing_route.rpt`. Implementer claimed WNS=+0.115 and WHS=−4.915 on `uart_io_vclk` IOB input hold.
2. Work order asked WNS≥0. Is a negative WHS a FAIL of “all constraints met”, PASS_NARROW (WNS-only), or OVERCLAIM if RESULTS hides WHS?
3. IOB FFs actually packed (ILOGIC/OLOGIC) vs `IOB=TRUE` ignored?
4. Delays still 2.000/0.500 not retuned after seeing WHS?
5. No `.bit`? `PRODUCTION_TOP` UNKNOWN?
6. Hash before impl including `.svh`?

Confirm: `ASTRA-11-A09R3-UART-IODELAY-01` (WNS=+0.681) was **not overwritten**; `a7ng_astra_09_r2_cand_ovf` instantiated; frozen leftover A09 **not** compiled.

Judged against:

1. Work order `.agents/handoff/ASTRA-11-A09R3-UART-IOBFF-01.md` + PREREG: instantiate `a7ng_astra_09_r2_cand_ovf` (not copy-paste graph; not compile frozen leftover A09); do **not** edit `ASTRA-11-A09R3-UART-IODELAY-01`; keep delays 2.000/0.500; IOB FF policy frozen before impl; hash RTL+XDC+tcl before impl; impl+route at declared 50 MHz; quote routed Design State; io.rpt / util show IOB FF if packed; if WNS<0 FAIL bag, keep report, one bounded experiment, still no bit; PROGRAM=NO; do not overwrite I/O-delay wrap WNS=+0.681, UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, A09 wrap WNS=+1.041, or wrap-route WNS=+5.733; do not close ASTRA-13, BOARD_PASS, LM06, Master F3; do not freeze `PRODUCTION_TOP`.
2. **Master ASTRA-11** (DAG: FULLCHIP-COFIT): whole-chip co-fit of the frozen SoC top (UART + MMCM + I/O + memory plant + production path together), not an isolated named UART wrap with a fixture plant plus STA I/O delays plus pad FFs.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.* `docs/ASTRA/GSTACK_LOOP.md`: ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate.
4. Auditor `20260906T1800Z`: ASTRA-11-A09R3-UART-IODELAY-01 PASS_NARROW WNS=+0.681 delays 2.000/0.500; residual = IOB FF pack (this bag). That +0.681 bag must remain unoverwritten. a7-fpga-gate numeric: WNS ≥ 0; TNS = 0; **WHS/THS report; negative hold is a finding**.

**Master ASTRA-11 as a whole is not this bag’s close**, even if this wrapper’s routed WNS is ≥ 0 and UART IOB FFs packed.

Out of this bag’s close: freeze of `PRODUCTION_TOP`, silicon UART / silicon MMCM / silicon BRAM, `a7ng_axi_bram128` plant, bitstream, JTAG/COM12, LM06 language, Master ASTRA-09 production path, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, ASTRA-13 BOARD_PASS, wrap-route `arty_a7_astra_rtp_soc_top` WNS=+5.733 identity, A09R2 wrap WNS=+0.648 identity, leftover A09 wrap WNS=+1.041 identity, prior UART wrap WNS=+0.305 identity, prior I/O-delay wrap WNS=+0.681 identity, UART XSim MAGIC A2 as this bag, LED I/O delay, FT2232H silicon Tsu, claim that all user timing constraints are met.

Frozen `a7ng_astra_09_r2_cand_ovf.sv` / `.svh`, leftover `a7ng_astra_09_integ_path.sv` / `.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `uart_rx.sv` / `uart_tx.sv`, F2R3/F2R4/F2R5, persist/R2/R3/R4 must remain **unpatched**. This wrap is a **new named** UART IOB-FF wrapper. It must **instantiate** A09-R2, not copy the graph. It must **not** compile leftover A09 / `astra09_pipe` / `axi_bram128` / RTP SoC / XSim wrap / prior UART impl wrap / prior I/O-delay wrap as this top.

Prior bags `ASTRA-11-A09R3-UART-IODELAY-01`, `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, `ASTRA-SOC-RTP-WRAP-ROUTE`, `ASTRA-09-R2-CAND-OVF-01` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`fba5152e…7451bcec43`). `write_scope` = new bag + distinctly named UART IOB-FF wrap that **instantiates** frozen `a7ng_astra_09_r2_cand_ovf` with `IOB=TRUE` (or equivalent wrap IOB registers) on A9/D10 plus the same frozen `set_input_delay`/`set_output_delay` max 2.000 / min 0.500 (delay numbers and IOB FF policy frozen in PREREG before impl; no copy-paste graph; frozen leftover A09 not compiled as DUT; A09-R2 DUT source not patched; prior bags not edited **including ASTRA-11-A09R3-UART-IODELAY-01 WNS=+0.681**). `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, **ASTRA-11-A09R3-UART-IODELAY-01**, **ASTRA-11-A09R3-UART-IMPL-ROUTE-01**, ASTRA-SOC-RTP-WRAP-UART-XSIM, ASTRA-09-R3-UART-XSIM-01, Master_ASTRA-10_whole_chip, production_top_identity, write_bitstream, LED_IO_delay.

`run_impl.tcl` **renames** `write_bitstream` to abort (`astra_forbid_bit`). `vivado.jou`: **no** `write_bitstream` and **no** `.bit`. Compile list forbids leftover A09 / `astra09_pipe` / RTP SoC / XSim wrap / prior UART impl wrap / prior I/O-delay wrap / `axi_bram128`.

Bag listing: **no** `.bit` / `.bin` / `.mcs`, no `fail_r0/`, no `FIRST_DIVERGENCE.txt`, no `timing_route_exp.rpt`. Checkpoints are `ckpt/synth.dcp` and `ckpt/route.dcp` only.

`vivado.log` grep for `write_bitstream`, `a7ng_astra_09_integ_path`, `BOARD_PASS`: **no matches**. `PRODUCTION_TOP=UNKNOWN` at start and DONE.

---

### 1. Raw routed WNS **and** WHS (authority)

`timing_route.rpt` header:

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Sun Sep  6 23:06:09 2026
Command      : report_timing_summary -file .../ASTRA-11-A09R3-UART-IOBFF-01/timing_route.rpt
Design       : a7ng_astra_11_a09r3_uart_iobff_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Timer settings of record: **Ignore I/O Paths : No**. Enable Input Delay Default Clock : No. I/O paths are in the summary; UART delays are explicit, not a default-clock cheat.

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      0.115        0.000                      0                 8601       -4.915       -4.915                      1                 8601
Timing constraints are not met.
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

Inter-clock table (UART I/O, same rpt):

```text
uart_io_vclk  clk50u             19.270        0.000                      0                    1       -4.915       -4.915                      1                    1
clk50u        uart_io_vclk        7.313        0.000                      0                    1        3.662        0.000                      0                    1
```

clk50u group: Setup 0 failing, Worst Slack **0.115 ns**, Total Violation 0.000 ns. Hold 0 failing, Worst Slack **0.131 ns**.

`uart_io_vclk` → `clk50u`: Setup 0 failing, Worst Slack **19.270 ns**. Hold **1 failing**, Worst Slack **−4.915 ns**, Total Violation −4.915 ns.

Implementer claim **WNS=+0.115 and WHS=−4.915 MATCHES raw routed timing**. TNS=0.000 THS=−4.915. Setup failing endpoints = 0. Hold failing endpoints = 1. `metrics.json` `wns_ns=0.115` / `whs_ns=-4.915` / `timing_constraints_met=false` match. `TIMING_EXTRACT.txt`: `WNS=0.115 TNS=0.000 WHS=-4.915 THS=-4.915 CLOCK=clk50u PERIOD_NS=20.000 DESIGN_STATE=Routed`. `vivado.log` DONE line: `ASTRA_11_A09R3_UART_IOBFF_DONE WNS=0.115 TNS=0.000 WHS=-4.915 UART_IOB=YES UART_IOBFF=YES UART_IODELAY=2.000/0.500 BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN`.

**No RESULTS vs raw-rpt contradiction on WNS/TNS/WHS.** RESULTS does **not** hide WHS. CLOSEOUT quotes WHS=−4.915 and the 1-endpoint UART IOB input hold. `UART_IODELAY.txt` quotes `UART_IN_HOLD_SLACK=-4.915`.

Worst setup path (same rpt): `Slack (MET) : 0.115ns`; source `u_a09r2/pv_reg[0][0]/C` → dest `u_a09r2/best_a_reg[0]/D`; **Requirement 20.000 ns**; Data Path Delay 19.796 ns (logic 6.899 / route 12.897); 23 logic levels (CARRY4=7 + LUT2/3/4/5/6); Path Group `clk50u`. Source Clock Delay **6.417 ns**, Destination Clock Delay **6.058 ns**. This is a real walker/proof path **inside instantiated A09-R2**, not a wrap-only tautology and **not** an IOB-FF manufactured slack.

Clock path on that worst setup (same rpt):

```text
E3  CLK100MHZ
E3  IBUF          CLK100MHZ_IBUF_inst/O
MMCME2_ADV_X1Y2   u_mmcm/CLKOUT0     net clk50u (fo=1, routed)
BUFGCTRL_X0Y16    u_bufg50/O
net (fo=3502, routed) u_a09r2/clk
Source Clock Delay = 6.417 ns
```

Worst **intra-clk50u** hold path: `Slack (MET) : 0.131ns`; source `btn0_q_reg[0]/C` → dest `btn0_q_reg[1]/D`. MET. Not the Design Timing Summary WHS.

Worst **design** hold path (Inter Clock, same rpt): `Slack (VIOLATED) : -4.915ns`; source `uart_txd_in` (virtual `uart_io_vclk`) → dest `uart_rx_iob_reg/D` at **ILOGIC_X0Y171**. Path Type Hold (Min at Slow). Input Delay **0.500 ns**. Data Path Delay 1.455 ns (logic 100%, **route 0.000 ns**). Destination Clock Delay **6.503 ns** (E3 IBUF → MMCME2_ADV_X1Y2 → BUFGCTRL_X0Y16 → `clk` fo=3502 routed). Source Clock Delay **0.000 ns** (virtual / ideal). Arrival 1.955 ns vs required 6.870 ns → slack **−4.915 ns**. This is the one THS failing endpoint.

`route_status.rpt`: logical nets 12281; fully routed 6005; **routing errors = 0**.

DRC: 9 checks, all Warning (DSP DPIP/DPOP pipeline on `u_a09r2/u_sgd` acc0). **0 Error / 0 Critical**. Unpipelined DSP is consistent with frozen F2R2 SGD.

Synth-only contrast (not the WNS quote): `TIMING_EXTRACT_SYNTH.txt` Design State **Synthesized** `WNS=2.141` `WHS=-1.493`. Implementer correctly quotes **routed** 0.115 / −4.915, not synth. `vivado.log`: `synth_design -top a7ng_astra_11_a09r3_uart_iobff_wrap -part xc7a100tcsg324-1` (no `-mode out_of_context`).

WNS ≥ 0. Bounded WNS<0 experiment **not run** (not applicable; handoff WNS<0 path only). Hunt 1: **MET. Routed WNS=+0.115. Routed WHS=−4.915. Claim matches raw.**

---

### 2. Negative WHS vs work-order WNS≥0 — FAIL of all-constraints-met, PASS_NARROW (WNS-only), or OVERCLAIM?

Work-order / PREREG one unknown is **WNS ≥ 0**, not “all user specified timing constraints are met”:

> With UART IOB FFs packed … plus the same frozen delays 2.000/0.500, after implement+route at 50 MHz, is WNS ≥ 0 — without a bitstream?

Handoff if-WNS<0: FAIL this bag. a7-fpga-gate: WNS ≥ 0 is the numeric gate; **WHS/THS report; negative hold is a finding**.

| Question | Answer from raw |
|----------|-----------------|
| FAIL of “all constraints met”? | **YES as a fact.** Raw Design Timing Summary line 144: `Timing constraints are not met.` WHS=−4.915 THS=−4.915, 1 hold endpoint. Intra `clk50u` hold is MET +0.131. The fail is **inter-clock** `uart_io_vclk` → `clk50u` IOB input hold. |
| PASS_NARROW (WNS-only) vs this work order? | **YES.** Routed WNS=+0.115 ≥ 0. TNS=0. IOB FFs packed. Delays frozen. The WNS unknown is answered. Negative WHS is a **finding**, not a miss of the declared WNS unknown. |
| OVERCLAIM if RESULTS hides WHS? | **NO. RESULTS does not hide WHS.** RESULTS marker and RESULT line quote `WHS=-4.915`, `HOLD_FINDING`, and **“Do not claim all-constraints-met.”** `metrics.json` `"timing_constraints_met": false`. CLOSEOUT quotes UART_IN_HOLD_SLACK=−4.915. DONE line quotes WHS. TIMING_EXTRACT quotes WHS. |

CLOSEOUT `RESULT=PASS_THIS_GATE_ONLY` is slightly stronger wording than RESULTS `PASS_NARROW`, but the same CLOSEOUT block discloses the hold fail and does not claim all-constraints-met. **Not OVERCLAIM of hiding WHS.** Auditor grades the bag **PASS_NARROW**, not PASS, not FAIL of the WNS unknown.

Physical reading of the hold (not a DUT logic bug): packing the pad FF into ILOGIC puts **0.000 ns route** from IBUF to `uart_rx_iob_reg/D`. Prior I/O-delay bag (fabric `u_rx/rx_sync0_reg`) had UART input hold **+1.151 ns** from 2.975 ns fabric route. Virtual `uart_io_vclk` SCD=0 vs real MMCM+BUFG DCD=6.503 ns with min input delay 0.500 is an STA envelope collision, not a 115200 baud silicon hold fail. Implementer correctly forbids retuning 2.000/0.500 after seeing it (PREREG). Do **not** call this silicon UART.

Hunt 2: **PASS_NARROW (WNS-only) + HOLD finding. FAIL of all-constraints-met as a stronger claim (implementer did not make that claim). Not OVERCLAIM.**

---

### 3. IOB FFs actually packed (ILOGIC/OLOGIC) vs `IOB=TRUE` ignored?

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
```

XDC (opened): `set_property IOB TRUE [get_ports uart_txd_in]` and `uart_rxd_out`. Frozen `uart_rx.sv` / `uart_tx.sv` **not patched** (hashes MATCH T1700).

Raw `util_route.rpt` Design State Routed 23:06:08, contrast vs I/O-delay bag (ILOGIC=0 / OLOGIC=0, no IOB Flip Flops row):

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

Timing path locations independently show the same sites: input dest `ILOGIC_X0Y171 uart_rx_iob_reg/D`; output source `uart_tx_iob_reg` (OLOGIC). `io.rpt` pin table is pin-assignment only (A9 INPUT FIXED / D10 OUTPUT FIXED) and does **not** list BEL — packing proof is util IFF/OUTFF + BEL/LOC + timing Location, not the pin table.

Clock loads **3502** vs I/O-delay bag **3500** = +2, matching the two pad FFs.

`io.rpt` Design `a7ng_astra_11_a09r3_uart_iobff_wrap`, Total User IO=15, Date 23:06:13:

```text
| A9         | uart_txd_in  | ... | INPUT  | LVCMOS33 | ... | FIXED |
| D10        | uart_rxd_out | ... | OUTPUT | LVCMOS33 | ... | FIXED |
| E3         | CLK100MHZ    | ... | INPUT  | LVCMOS33 | ... | FIXED |
```

Direction matches Digilent names: **A9 = FPGA RX (`uart_txd_in`) INPUT FIXED**; **D10 = FPGA TX (`uart_rxd_out`) OUTPUT FIXED**. Pins are **not swapped**. `UART_IOB.txt`: `UART_IOB=YES`.

Hunt 3: **MET. IOB FFs packed YES (ILOGIC IFF + OLOGIC OUTFF). `IOB=TRUE` was not ignored.**

---

### 4. Delays still 2.000/0.500 not retuned after seeing WHS?

**PREREG (no WNS/WHS numbers — policy before impl):**

```text
UART_IN_MAX_NS  = 2.000
UART_IN_MIN_NS  = 0.500
UART_OUT_MAX_NS = 2.000
UART_OUT_MIN_NS = 0.500
```

“Do **not** retune 2.000/0.500 from the +0.681 bag.” “If WNS < 0 … **same frozen delay numbers**.”

**XDC `clk50_uart_iobff.xdc` (same numbers):**

```text
create_clock -name uart_io_vclk -period 20.000
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]
```

XDC digest **PRE = POST**:

`dad1dbf2ba79ff12380f1dc22d8c679ab38d922487423266aaa5f2b8d3ddeb1f  …/clk50_uart_iobff.xdc`

If delay numbers had been edited after seeing WHS, the XDC POST hash would differ. It does not.

Hash order:

| Event | Stamp |
|-------|-------|
| `SHA256.txt` / `SOURCE_HASHES.txt` **BEFORE impl** | `2026-09-06T23:01:09.4037414+07:00` |
| Vivado start (`vivado.log`) | `Sun Sep 6 23:01:10 2026` (PID 4472) — **~1 s later** |
| Reports | `23:06:08` (util_hier) … `23:06:09` (timing_route) … `23:06:12` (drc) … `23:06:13` (io/clocks/check_timing/uart_in/out) |
| Vivado DONE / `SHA256_POST.txt` **AFTER impl** | DONE line then `2026-09-06T23:06:14.5544930+07:00` |

`vivado.log` header (before synth) already prints the frozen numbers:

```text
UART_IO_VCLK=uart_io_vclk period=20.000ns
UART_IN_MAX_NS=2.000 UART_IN_MIN_NS=0.500
UART_OUT_MAX_NS=2.000 UART_OUT_MIN_NS=0.500
UART_IOBFF_POLICY=IOB=TRUE wrap uart_rx_iob/uart_tx_iob
PROGRAM=NO
BIT=NOT_BUILT
PRODUCTION_TOP=UNKNOWN
```

Raw routed paths quote the same delays: hold Input Delay **0.500 ns**; setup Input Delay **2.000 ns**; output setup/hold Output Delay **2.000 / 0.500 ns**. Prior I/O-delay XDC KEEP `7023fd8a…` MATCH (this bag did not edit that file).

Hunt 4: **MET. 2.000/0.500 not retuned after WHS.**

---

### 5. No `.bit`? PRODUCTION_TOP UNKNOWN? IODELAY WNS=+0.681 not overwritten? A09-R2 instantiated?

**No bitstream / PROGRAM=NO / PRODUCTION_TOP=UNKNOWN**

- Bag directory: no `.bit` / `.bin` / `.mcs`. `ckpt/` holds `synth.dcp` + `route.dcp` only.
- `vivado.log` DONE: `BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN`. No `write_bitstream` command.
- `vivado.jou`: no `write_bitstream`, no `.bit`.
- TCL: `write_bitstream` renamed to abort before synth. WNS≥0 path never calls it. WNS<0 path also never calls it.
- ACK / PREREG / RESULTS / CLOSEOUT / metrics: `PRODUCTION_TOP=UNKNOWN`, `PROGRAM=NO`.
- LOOP_STATE (read-only): `program=false`, `board_pass=false`, `astra13=BLOCKED`, `production_top=UNKNOWN`, `com12=USER_SAYS_PLUGGED_UNPROGRAMMED`.

Board plugged ≠ programmed.

**IODELAY bag WNS=+0.681 not overwritten** (headers opened this session):

| Bag | Raw identity still on disk |
|-----|----------------------------|
| **ASTRA-11-A09R3-UART-IODELAY-01** | `timing_route.rpt` **Sun Sep 6 22:39:44**, Design `a7ng_astra_11_a09r3_uart_iodelay_wrap`, Design Timing Summary **WNS=0.681 WHS=0.100**, “All user specified timing constraints are met.” SHA freeze **2026-09-06T22:34:41**. Wrap SHA KEEP `34353bb7…` MATCH this bag KEEP. Prior XDC `7023fd8a…` MATCH KEEP. **util ILOGIC=0 / OLOGIC=0.** **Not overwritten.** |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 22:12:21**, Design `a7ng_astra_11_a09r3_uart_impl_wrap`, **WNS=0.305**. Wrap SHA KEEP `1c3a95f4…` MATCH. **Not overwritten.** |
| ASTRA-11-A09R2-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 21:26:25**, Design `a7ng_astra_11_a09r2_impl_wrap`, **WNS=0.648**. Wrap SHA KEEP `1932ee4c…` MATCH. **Not overwritten.** |
| ASTRA-11-A09-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 19:48:09**, Design `a7ng_astra_11_a09_impl_wrap`, **WNS=1.041**. **Not overwritten.** |
| ASTRA-SOC-RTP-WRAP-ROUTE | `timing.rpt` **Sun Sep 6 02:11:52**, Design `arty_a7_astra_rtp_soc_top`, **WNS=5.733**. **Not overwritten.** |

This routed WNS=+0.115 is **not** recycled +0.681 / +0.305 / +0.648 / +1.041 / +5.733. Design name, date, worst path (`pv_reg[0][0]`→`best_a_reg[0]`), clock loads 3502, and ILOGIC/OLOGIC occupancy all differ from the +0.681 bag. Hunt 5: **MET.**

**A09-R2 instantiated; frozen leftover A09 not compiled**

Bag contains new wrap + bag-local AXI plant only as RTL (no copied integrator `.sv` in the bag). Wrap:

```text
(* keep_hierarchy = "yes" *)
uart_rx ... u_rx ( .rx(uart_rx_iob), ... );
uart_tx ... u_tx ( .tx(tx_int), ... );
(* keep_hierarchy = "yes" *)
a7ng_astra_09_r2_cand_ovf u_a09r2 ( ... );
(* keep_hierarchy = "yes" *)
a7ng_astra_11_a09r3_uart_iobff_plant u_plant ( ... );
load_v_i tied 0.
```

No QSE/sparse/2-hop/SGD duplicated in the wrap. Frozen leftover A09 **not instantiated**. Plant header: *Bag-local behavioral AXI plant. Not silicon BRAM. Not a7ng_axi_bram128.*

Raw log elaboration (not RESULTS):

```text
synthesizing module 'a7ng_astra_11_a09r3_uart_iobff_wrap' [.../ASTRA-11-A09R3-UART-IOBFF-01/a7ng_astra_11_a09r3_uart_iobff_wrap.sv:8]
synthesizing module 'MMCME2_BASE'
synthesizing module 'BUFG'
synthesizing module 'uart_rx' [.../rtl/board/uart_rx.sv:2]
synthesizing module 'uart_tx' [.../rtl/board/uart_tx.sv:2]
synthesizing module 'a7ng_astra_09_r2_cand_ovf' [.../rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv:9]
synthesizing module 'a7ng_query_axi_sparse'
synthesizing module 'a7ng_shared_rank_sgd_q8_sym_f2r2'
synthesizing module 'a7ng_astra_11_a09r3_uart_iobff_plant' [.../a7ng_astra_11_a09r3_uart_iobff_plant.sv:6]
U_A09R2_CELLS=11064
U_RX_CELLS=76
U_TX_CELLS=56
UART_IOBFF_CELLS=2
```

**Not synthesized:** `a7ng_astra_09_integ_path` (zero log matches), `a7ng_astra09_pipe`, `arty_a7_astra_rtp_soc_top`, `a7ng_axi_bram128`, `a7ng_astra_11_a09r3_uart_impl_wrap`, `a7ng_astra_11_a09r3_uart_iodelay_wrap`. **Required instantiate-not-copy and frozen-A09-not-compiled: MET.**

**`check_timing` UART ports still constrained** (standalone `check_timing.rpt` Design State Routed 23:06:13):

```text
5. checking no_input_delay (3)  — 0 HIGH; 3 MEDIUM false-path: btn[0] sw[0] sw[1]
6. checking no_output_delay (4) HIGH: led[0] led[1] led[2] led[3]
10/11. partial_input_delay (0) / partial_output_delay (0)
```

**`uart_txd_in` is not in `no_input_delay`.** **`uart_rxd_out` is not in `no_output_delay`.** Remaining HIGH unconstrained outputs are **LEDs only** (out of this work order).

UART I/O path slacks (`timing_uart_in.rpt` / `timing_uart_out.rpt`, Design State Routed 23:06:13):

| Path | Setup | Hold | Delay used |
|------|------:|-----:|------------|
| `uart_txd_in` A9 → `uart_rx_iob_reg` ILOGIC_X0Y171 | **+19.270 ns MET** | **−4.915 ns VIOLATED** | IN max 2.000 / min 0.500 |
| `uart_tx_iob_reg` OLOGIC → `uart_rxd_out` D10 | **+7.313 ns MET** | **+3.662 ns MET** | OUT max 2.000 / min 0.500 |

These MATCH Inter Clock Table / `UART_IODELAY.txt` / `metrics.json` / RESULTS.

**Clock-network real vs virtual (pipe vs I/O ref):**

`clocks_route.rpt` Design State **Routed** 23:06:13:

```text
Clock         Period(ns)  Waveform(ns)    Attributes  Sources
sys_clk_pin   10.000      {0.000 5.000}   P           {CLK100MHZ}
uart_io_vclk  20.000      {0.000 10.000}  V           {}
clk50u        20.000      {0.000 10.000}  P,G,A       {u_mmcm/CLKOUT0}
clkfb         10.000      {0.000 5.000}   P,G,A       {u_mmcm/CLKFBOUT}
```

`clock_util_route.rpt`: MMCM=1, BUFGCTRL=1 at **BUFGCTRL_X0Y16**, clock loads **3502**, period 20.000, driver `u_bufg50/O` net `clk`, source `MMCME2_ADV/CLKOUT0` site **MMCME2_ADV_X1Y2**. Pipe clock is **not** virtual. Quoted internal WNS includes clock-network delay (SCD=6.417 ns).

---

### 6. Hash before impl including `.svh`?

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
| bag `a7ng_astra_11_a09r3_uart_iobff_plant.sv` | `1de599857e173c46e7242c7a086dc1d4cfe3d292ca84c9f97019c6b2bbba76b7` |
| bag `a7ng_astra_11_a09r3_uart_iobff_wrap.sv` | `4f97db83a29b474605c286f318a65d3467bee95ebecfdf1581dfb598b40774aa` |
| bag `clk50_uart_iobff.xdc` | `dad1dbf2ba79ff12380f1dc22d8c679ab38d922487423266aaa5f2b8d3ddeb1f` |
| bag `run_impl.tcl` | `d8d96f693641f7a4c6cb87c76667d0aa8d1422a261604f95de6ffe0aca4db9cd` |
| `a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `a7ng_astra_09_integ_path.svh` | `ad2d66d4783bba33cfbd324fc0a9661fb2a46eeaffb5b4fb6989246fb4e94302` |
| `a7ng_astra_09_r2_cand_ovf.svh` | `feaed571ce02bec4218e2105986349a464d6c44bcf1a818260ee27a171afd329` |

`.svh` **is** in the pre-impl freeze (R2 contract + leftover A09 header + lexica + crc). Hunt 6: **MET.**

R2 DUT `15a919f1…` **MATCH** I/O-delay / UART-impl-route freeze and T1630/T1700/T1730/T1800. Frozen leftover A09 `9fdbe0d6…` **MATCH** provenance (KEEP; **not compiled**). Frozen SGD `b66ef328…` MATCH. `uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH ASTRA-09-R3-UART-XSIM-01. Prior I/O-delay wrap `34353bb7…` MATCH KEEP (not compiled as this top). Prior I/O-delay XDC `7023fd8a…` MATCH KEEP. Prior UART impl wrap `1c3a95f4…` MATCH KEEP. Prior A09R2 wrap `1932ee4c…` MATCH. Prior XSim UART wrap `20cdeb8e…` MATCH KEEP.

PRE 23:01:09 < Vivado 23:01:10. Not hash-after-scores theatre.

---

## Resources (raw; not the WNS quote)

Quoted **synth** `util_synth.rpt` (RESULTS/UTIL_EXTRACT_SYNTH): Slice LUTs **5682**, Slice Registers **5010**, BRAM **0**, DSP **2**.

Quoted **routed** `util_route.rpt` Design State Routed:

```text
| Slice LUTs              | 4802 |     0 |          0 |     63400 |  7.57 |
| Slice Registers         | 3500 |     0 |          0 |    126800 |  2.76 |
| Block RAM Tile          |    0 |
| DSPs                    |    2 | ...  DSP48E1 only
| Bonded IOB              |   15 |    15 |          0 |       210 |  7.14 |
| IOB Flip Flops          |    2 |
| ILOGIC                  |    1 |
| OLOGIC                  |    1 |
| BUFGCTRL                |    1 |
| MMCME2_ADV              |    1 |
```

Hierarchical routed (`util_hier_route.rpt`):

```text
| a7ng_astra_11_a09r3_uart_iobff_wrap | (top)                            | 4802 | 3500 | 0 | 2 |
|   u_a09r2                             | a7ng_astra_09_r2_cand_ovf        | 4293 | 2692 | 0 | 2 |
|     u_sgd                             | a7ng_shared_rank_sgd...          |  530 |  610 | 0 | 2 |
|     u_sp                              | a7ng_query_axi_sparse            | 3334 |  696 | 0 | 0 |
|       u_walk                          | a7ng_sparse_dir_axi              | 1006 |  450 |
|       g_law.u_qse                     | a7ng_query_role_extract          | 2328 |  202 |
|   u_plant                             | a7ng_astra_11_a09r3_uart_iobff_plant | 170 | 73 | 0 | 0 |
```

Honest occupancy of a **live UART wrap**: QSE LUT=2328 is **not** the I/O-folded QSE=39 of A09R2 wrap. Plant is behavioral (LUT=170, BRAM=0), **not** wrap-route BRAM=2. SGD DSP×2 remains. Worst setup path still inside `u_a09r2`. **Not a stub DUT.** Also **not** whole-chip `axi_bram128` / DDR occupancy. Do not add 4802 to prior I/O-delay 4803, UART wrap 4804, A09R2 wrap 1321, leftover A09 wrap 1305, or wrap-route 4244 as a chip sum.

Comparison (not identity):

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 4802 | 3500 | 0 | 2 | **Routed clk50u +0.115 IOB FF YES delays 2.000/0.500; WHS=−4.915 I/O hold** |
| This bag synth | 5682 | 5010 | 0 | 2 | Synthesized (not the WNS quote; extract +2.141 / WHS=−1.493) |
| ASTRA-11-A09R3-UART-IODELAY-01 routed | 4803 | 3500 | 0 | 2 | Routed delays 2.000/0.500 **no IOB FF +0.681 WHS=+0.100** — not overwritten |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed | 4804 | 3500 | 0 | 2 | Routed UART IOB, **I/O unconstrained +0.305** — not overwritten |
| ASTRA-11-A09R2-IMPL-ROUTE-01 routed | 1321 | 1103 | 0 | 2 | Routed no-UART **+0.648** — not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed different DUT **+1.041** — not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |

---

## Overclaim / cheat / tautology

| Hunt | Finding |
|------|---------|
| RESULTS hides WHS / claims all-constraints-met | **Not found.** Raw WHS=−4.915 quoted in RESULTS / CLOSEOUT / metrics (`timing_constraints_met=false`) / TIMING_EXTRACT / DONE / UART_IODELAY.txt. Raw line: constraints **not** met |
| RESULTS vs raw rpt mismatch on WNS/TNS/WHS | **None.** +0.115 / 0.000 / −4.915 Design State Routed; Intra clk50u +0.115 / +0.131 |
| IOB=TRUE ignored (no ILOGIC/OLOGIC) | **Not found.** IFF_Register=1 OUTFF_Register=1 IOB Flip Flops=2; BEL ILOGICE2.IFF / OLOGICE2.OUTFF; timing Location ILOGIC_X0Y171 |
| Delays retuned after WHS | **Not found.** PREREG 2.000/0.500; SHA PRE 23:01:09 < Vivado 23:01:10; XDC PRE=POST `dad1dbf2…`; paths still quote 2.000/0.500 |
| +0.681 bag overwritten or quoted as this WNS | **Not overwritten** (22:39:44 still 0.681, design `uart_iodelay_wrap`, ILOGIC=0). **Not quoted as this result** |
| Wrap-route WNS=+5.733 claimed or overwritten | **Not claimed. Not overwritten** (02:11:52 still 5.733) |
| A09R2 wrap WNS=+0.648 claimed or overwritten | **Not claimed. Not overwritten** (21:26:25 still 0.648) |
| A09 wrap WNS=+1.041 overwritten | **Not overwritten** (19:48:09 still 1.041) |
| UART impl-route WNS=+0.305 overwritten | **Not overwritten** (22:12:21 still 0.305) |
| BOARD_PASS / silicon UART | **Not claimed.** BIT=NOT_BUILT; PROGRAM=NO; `uart_io_vclk` is V |
| Pipe clock virtual / no SCD | **Not found.** P,G,A `clk50u`; E3 IBUF→MMCM→BUFG→`u_a09r2/clk` fo=3502 routed; SCD=6.417 ns. Only I/O ref is virtual (declared) |
| Copy-paste graph called instantiate | **Not found.** Thin UART FIFO wrap + pad FFs + live RTL path in synth log |
| Frozen leftover A09 compiled as DUT | **Not found.** Zero synth/log matches; tcl forbids; KEEP hash only |
| Stub / empty DUT | **Not found.** Hier `u_a09r2` LUT=4293; QSE=2328; SGD DSP48E1×2; U_A09R2_CELLS=11064; worst setup inside DUT walker |
| Bitstream / PROGRAM | **No bit in this bag.** ACK/RESULTS PROGRAM=NO |
| `PRODUCTION_TOP` frozen | **UNKNOWN** in ACK / log DONE / RESULTS / CLOSEOUT / LOOP_STATE |
| Hash freeze after looking at WNS / `.svh` omitted | **Not found.** PRE 23:01:09 < Vivado 23:01:10; 5 `.svh` in PRE; POST 19/19 MATCH |
| UART XSim MAGIC A2 claimed as this bag | **Not claimed.** ASTRA-09-R3-UART-XSIM-01 still its own PASS_NARROW |
| Fail r0 wipe | **N/A.** Single successful session; WNS≥0; no fail_r0 artifact to wipe |
| LUT used as whole-chip occupancy | **Not claimed.** Documented fixture plant / BRAM=0 vs wrap-route BRAM=2 |
| CLOSEOUT `PASS_THIS_GATE_ONLY` as Master close | **Wording slightly stronger than RESULTS PASS_NARROW**; same CLOSEOUT discloses hold and keeps Master 11/13/BOARD/`PRODUCTION_TOP` open. Auditor grades **PASS_NARROW**. Not OVERCLAIM of Master gates |

qstack adversary: worst setup path is a real placed/routed A09-R2 walker (`pv_reg[0][0]` → `best_a_reg[0]`, 23 logic levels) under a **propagated generated** 20 ns clock with SCD=6.417 ns and 3502 routed clock loads. `set_false_path` on sw/btn and remaining unconstrained LED I/O **do not** create that 0.115 ns slack. UART IOB FFs are physically packed (ILOGIC/OLOGIC), which is exactly what created the hold collision: 0.000 ns IBUF→IFF route vs 6.503 ns real clock delay against a virtual I/O clock with min delay 0.500. That hold is an STA envelope finding, not a tautology manufacturing the quoted WNS. Virtual `uart_io_vclk` with DCD/SCD=0 on the I/O side is the same construction as the +0.681 bag; packing the FF removed the fabric route that previously bought +1.151 ns input hold. WNS=+0.115 is a **new P&R** of a new named wrap, not a recycled +0.681 report (different design name, different date, different worst path, ILOGIC 0→1, prior bag intact). Delay numbers were hashed before Vivado started and were not edited after WHS.

---

## Logic bugs

No route FAIL. No critical warnings. No RESULTS/raw contradiction on the quoted WNS/TNS/WHS or UART in/out slacks. Route complete (0 failed nets). UART IOB FFs packed as required. UART ports still off the unconstrained lists. Delays not retuned. WNS ≥ 0 so the handoff WNS<0 bounded experiment was correctly **not** run.

The hold VIOLATED path is **not** a DUT walker/SGD logic bug. It is the packed IOB input FF vs virtual 20 ns I/O clock + min delay 0.500 + real MMCM/BUFG destination delay. Intra-`clk50u` hold remains MET.

Residuals (not this-bag FAIL of the WNS unknown):

1. Design Timing Summary: **timing constraints are not met** (1 UART IOB input hold endpoint, WHS=−4.915). Do not promote this bag as all-constraints-met. Implementer already says so.
2. `uart_io_vclk` is **virtual**. I/O STA is an envelope at the pipe period (20 ns) with 2.000/0.500 delays, **not** FT2232H Tsu and **not** a 115200 baud clock. Meeting setup / failing hold on that envelope ≠ silicon UART. PREREG already says this.
3. UART IOB input hold vs virtual clock is the **new residual** created by packing IFF. Fix belongs in a **new named bag** (async false-path / max-delay on UART pad vs `uart_io_vclk`, or a different I/O clocking method). Do **not** retune frozen 2.000/0.500 inside this bag. Do **not** patch frozen `uart_rx.sv`.
4. LED outputs remain HIGH `no_output_delay` (`led[0:3]`). Out of this work order.
5. DRC DSP unpipelined (DPIP/DPOP) — expected; frozen F2R2 SGD. Do not patch from this bag.
6. Bag-local `a7ng_astra_11_a09r3_uart_iobff_plant` is a **behavioral fixture** (BRAM=0). Master ASTRA-11 fullchip plant (`a7ng_axi_bram128` / DDR) remains open.
7. Occupancy LUT=4802 / QSE=2328 is **this UART IOB-FF wrap**, not additive with prior I/O-delay 4803, UART wrap 4804, A09R2 wrap 1321, leftover A09 wrap 1305, or wrap-route 4244 BRAM=2. WNS=+0.115 vs prior I/O-delay +0.681 is **separate P&R**, not a delta on the same DCP.
8. No independent `Get-FileHash` this process. Overlapping R2/SGD/A09/uart/pkg hashes MATCH prior bags. Wrap/XDC/tcl/plant digests are first-recorded here; PRE=POST strings match.
9. Functional MAGIC A2 / OVF INCOMP on the byte stream remains **XSim** (T1700). This bag does not re-prove UART protocol on silicon or in XSim. Extra IOB sample stage changes UART RX latency by one `clk50u` cycle vs the I/O-delay wrap; that is wrap-level, not a frozen-`uart_rx` patch, and is **not** re-proven here.
10. Named wrap is a **candidate** UART SoC path with STA I/O delays and packed IOB FFs, not a silent `PRODUCTION_TOP` freeze. T1800 residual 5 is **physically evidenced** (IFF/OUTFF packed, WNS≥0, no bitstream) and **not closed as production identity** and **not closed as all-constraints-met**.
11. CLOSEOUT `PASS_THIS_GATE_ONLY` should not be read as Master-gate PASS. Authority for bag grade is this report: **PASS_NARROW**.

No DUT logic patch requested. Auditor does not fix.

---

## This bag vs Master ASTRA-11 / ASTRA-13

Work-order unknown **answered**: for wrapper `a7ng_astra_11_a09r3_uart_iobff_wrap` / instance `u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf` on `xc7a100tcsg324-1`, with UART IOB FFs **packed** (`uart_rx_iob_reg` ILOGICE2.IFF ILOGIC_X0Y171; `uart_tx_iob_reg` OLOGICE2.OUTFF OLOGIC_X0Y161) plus frozen UART I/O delays **max 2.000 / min 0.500** on `uart_txd_in` A9 / `uart_rxd_out` D10, post-route (Design State **Routed**) is **WNS=+0.115 ns TNS=0.000 ns WHS=−4.915 ns @ Design Timing Summary** (Intra **clk50u WNS=+0.115 WHS=+0.131 MET**, 20.000 ns / 50 MHz) with **real** E3 IBUF → MMCME2_ADV_X1Y2 → BUFGCTRL_X0Y16 → `u_a09r2/clk` (SCD=6.417 ns, fo=3502 routed), UART I/O setup **in +19.270 ns / out +7.313 ns**, UART input hold **−4.915 ns VIOLATED** (1 endpoint), UART ports **off** unconstrained lists, UART IOB **A9 INPUT / D10 OUTPUT FIXED**, IOB FF **YES**, **BIT=NOT_BUILT**, **PROGRAM=NO**, **PRODUCTION_TOP=UNKNOWN**. Frozen leftover A09 **not compiled**. ASTRA-11-A09R3-UART-IODELAY-01 WNS=+0.681 **not overwritten**. UART impl-route WNS=+0.305 **not overwritten**. A09R2 wrap WNS=+0.648 **not overwritten**. Wrap-route WNS=+5.733 **not overwritten**.

T1800 residual 5 (**IOB FF pack**) is **closed as evidence class** for *this named wrap with packed ILOGIC/OLOGIC pad FFs, frozen 2.000/0.500 delays, WNS≥0, no bitstream*. It is **not** permission to mark Master ASTRA-11 or ASTRA-13 done, **not** permission to freeze `PRODUCTION_TOP`, and **not** permission to say all constraints are met.

| Master item | This bag |
|---|---|
| ASTRA-11 FULLCHIP-COFIT (UART + MMCM + I/O + AXI BRAM/DDR plant + production path as one frozen top) | Named UART wrap + MMCM/BUFG + D10/A9 IOB + packed IOB FFs + STA I/O delays + fixture AXI plant. No `axi_bram128`. No DDR. `PRODUCTION_TOP=UNKNOWN`. Hold not met on UART I/O envelope |
| ASTRA-11-A09R3-UART-IODELAY-01 WNS=+0.681 | Different wrap (`uart_iodelay_wrap`); ILOGIC=0; bag **not overwritten**; this WNS=+0.115 is **not** that number |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 WNS=+0.305 | Different wrap (`uart_impl_wrap`); I/O unconstrained; bag **not overwritten** |
| ASTRA-11-A09R2-IMPL-ROUTE-01 WNS=+0.648 | Different wrap, no UART; bag not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041 | Different DUT `a7ng_astra_09_integ_path`; bag not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733 | Different top `arty_a7_astra_rtp_soc_top`; bag not overwritten |
| ASTRA-11-SOC-WRAP historical routed WNS=-4.765 | Different top; not this result |
| ASTRA-13 FINAL-BOARD-ACCEPTANCE | BIT=NOT_BUILT; PROGRAM=NO; no JTAG/COM12; `PRODUCTION_TOP=UNKNOWN` |
| LM06 language | Not opened |
| ASTRA-09-R3-UART-XSIM-01 MAGIC A2 | Prior XSim bag; not this impl/route result |

**No Master-gate overclaim found.**

Master **ASTRA-11 FULLCHIP-COFIT** remains **OPEN** (fixture plant, not frozen SoC top, not wrap-route identity, UART I/O hold not met on the virtual envelope).

Master **ASTRA-13 FINAL-BOARD-ACCEPTANCE** remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority.

Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-10 whole-chip remain **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-11-A09R3-UART-IOBFF-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw routed reports: instantiate-not-copy of `a7ng_astra_09_r2_cand_ovf`, frozen leftover A09 not compiled, hash-before-impl including `.svh`, delay numbers **2.000/0.500 frozen in PREREG before impl and matching XDC (not retuned after WHS)**, real pipe clock-network (not virtual), virtual I/O ref only as declared, **IOB FFs packed YES** (ILOGIC IFF + OLOGIC OUTFF), WNS=+0.115 ≥ 0, TNS=0, UART in setup +19.270 / out setup +7.313, UART ports still constrained, UART IOB A9 INPUT / D10 OUTPUT FIXED, PROGRAM=NO, no bitstream, `PRODUCTION_TOP=UNKNOWN`, prior I/O-delay WNS=+0.681 / UART impl-route / A09R2 wrap / leftover A09 wrap / wrap-route / UART XSim bags not overwritten, no BOARD_PASS / ASTRA-13 / LM06 overclaim, no theft of +0.681 / +0.305 / +0.648 / +1.041 / +5.733, **WHS=−4.915 disclosed (not hidden)**.

Not PASS (Master ASTRA-11 fullchip, ASTRA-13 board, silicon UART, `axi_bram128` plant, all-constraints-met, `PRODUCTION_TOP` freeze, FT2232H Tsu).  
Not FAIL (raw WNS matches claim and is ≥ 0; IOB FFs packed; delays not retuned; route 0 error / 0 critical; frozen R2/SGD/leftover A09/uart/F2R/persist unpatched; leftover A09 not compiled; pipe clock path real; prior WNS bags intact including +0.681; WHS finding reported).  
Not OVERCLAIM (ACK/RESULTS keep Master 11/13/BOARD/LM06/`PRODUCTION_TOP` open; do not steal prior I/O-delay +0.681, UART wrap +0.305, A09R2 wrap +0.648, leftover A09 wrap +1.041, wrap-route +5.733, or UART XSim MAGIC A2; do not hide WHS; do not claim all-constraints-met).

Classification of hunt 2 in one line: **FAIL of “all constraints met”; PASS_NARROW of the WNS≥0 work-order unknown; not OVERCLAIM (WHS not hidden).**

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared routed-WNS-at-50 MHz-with-packed-UART-IOB-FFs-and-frozen-delays-2.000/0.500 claim.

**P2 / residuals (do not reopen this bag as FAIL of the WNS unknown):**

1. Do **not** promote this WNS=+0.115 / WHS=−4.915 / IOB FF YES to BOARD_PASS, ASTRA-13, all-constraints-met, prior I/O-delay WNS=+0.681, prior UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, wrap-route WNS=+5.733, leftover A09 wrap WNS=+1.041, UART XSim MAGIC A2, or `PRODUCTION_TOP=a7ng_astra_11_a09r3_uart_iobff_wrap`.
2. UART IOB input **hold** vs virtual `uart_io_vclk` (WHS=−4.915, 1 endpoint, IBUF→IFF route 0.000 ns, DCD=6.503 ns) is the new residual. If parent wants hold-clean IOB FF STA, that is a **new named bag** — not a retune of frozen 2.000/0.500 in this bag, and not a patch of frozen `uart_rx.sv`.
3. Do **not** add this LUT/FF to prior I/O-delay 4803/3500, UART wrap 4804/3500, A09R2 wrap 1321/1103, leftover A09 wrap 1305/1075, or wrap-route 4244/3810 BRAM=2. Fixture plant BRAM=0 is honest. Whole-chip co-fit needs **one** current-source SoC top (Master ASTRA-11) plus an explicit `PRODUCTION_TOP` decision.
4. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
5. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv` and do **not** patch frozen R2 DUT / uart_rx / uart_tx from DRC DSP warnings or from this hold finding.
6. `uart_io_vclk` remains a virtual STA envelope. LED I/O delay remains a residual. Extra IOB sample stage vs T1700 XSim wrap is **not** re-proven functionally here.
7. CLOSEOUT `PASS_THIS_GATE_ONLY` is not Master PASS. Use this report’s **PASS_NARROW**.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated implement+route of a **new named UART wrap** instantiating frozen `a7ng_astra_09_r2_cand_ovf` at declared 50 MHz with **real routed clock-network**, frozen UART I/O delays **max 2.000 / min 0.500** (PREREG before impl, XDC match, not retuned after WHS), **IOB FFs packed YES** (ILOGIC IFF + OLOGIC OUTFF), WNS=+0.115 ≥ 0, WHS=−4.915 disclosed (1 UART IOB input hold vs `uart_io_vclk`; intra clk50u hold MET +0.131), UART IOB **A9 INPUT / D10 OUTPUT FIXED**, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`, leftover A09 not compiled, prior I/O-delay WNS=+0.681 bag **not overwritten**.

`REJECT_PROMOTION` — Master **ASTRA-11** (fullchip co-fit / frozen SoC UART top / on-chip plant), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. Packed IOB FF UART wrap with STA I/O delays **≠** silicon UART. Do not claim all-constraints-met.

Not `FAIL_LOOP`: WNS unknown answered ≥ 0; IOB FFs packed; evidence internally consistent; WHS is a finding, not a missing bag.

Master ASTRA-09: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681: **untouched**.  
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305: **untouched**.  
ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648: **untouched**.  
ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041: **untouched, different DUT**.  
ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733: **untouched, different top**.  
ASTRA-09-R3-UART-XSIM-01: **untouched, still not BOARD**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1830Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-11-A09R3-UART-IOBFF-01; Master ASTRA-11/13 OPEN; raw routed WNS=+0.115 TNS=0.000 WHS=-4.915 (Design State Routed; Intra clk50u WHS=+0.131 MET; 1 uart_io_vclk IOB input hold fail); IOB FF yes; PROGRAM=NO; BOARD still blocked YES.
