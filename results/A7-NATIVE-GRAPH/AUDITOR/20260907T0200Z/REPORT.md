# ASTRA auditor REPORT — 20260907T0200Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA11_A09R7_UART_IMPL_ROUTE_INDEPENDENT_AUDIT; astra11_a09r7=IMPLEMENTER_CLAIM_WNS_P0336_WHS_P0104_PENDING_AUDITOR; astra09_r7=AUDITOR_PASS_NARROW_UART_QUERY_REW_A09R2; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-11 FULLCHIP-COFIT / ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-11-A09R7-UART-IMPL-ROUTE-01 + prior auditor 20260907T0130Z (R7 UART query-learn XSim PASS_NARROW ACCEPT_PARTIAL; residual 5: not a silent production UART freeze — this bag is impl+route of a new named UART wrap, not a freeze) + T1900 (HOLD bag PASS_NARROW WNS=+0.115 WHS=+0.131 FALSE_PATH_HOLD) + T1830 (IOBFF WNS=+0.115 WHS=−4.915) + T1800 / T1730 / T1700 / T1630
EVIDENCE   = raw timing_route.rpt / exceptions_route.rpt / timing_uart_in.rpt / timing_uart_out.rpt / check_timing.rpt / io.rpt / clocks_route.rpt / clock_util_route.rpt / util_route.rpt / util_hier_route.rpt / route_status.rpt / ram_route.rpt / drc.rpt / util_synth.rpt / timing_synth.rpt / vivado.log / vivado.jou / wrap SV / plant SV / svh / tcl / XDC / UART_IOB.txt / UART_IOBFF.txt / UART_IODELAY.txt / SHA manifests / PREREG / ACK (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_impl.ps1` / `run_impl.tcl` (would overwrite `vivado.log` / routed reports). Did not program the plugged board.

This process has **no independent `Get-FileHash`**. Freeze lists were compared to opened files and to overlapping hashes in `ASTRA-09-R7-UART-QUERY-REW-01`, `ASTRA-11-A09R3-UART-IOBFF-HOLD-01`, `ASTRA-11-A09R3-UART-IOBFF-01`, `ASTRA-11-A09R3-UART-IODELAY-01`, `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, `ASTRA-09-R2-CAND-OVF-01`, `ASTRA-09-R3-UART-XSIM-01`, and T1630/T1700/T1730/T1800/T1830/T1900/T0130 freeze strings.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R7-UART-IMPL-ROUTE-01/`

Top `a7ng_astra_11_a09r7_uart_impl_wrap` (bag-local, **new named**) instance **`u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv`**. UART `u_rx` / `u_tx` from `rtl/board/uart_rx.sv` / `uart_tx.sv`. Wrap-level pad FFs `uart_rx_iob` / `uart_tx_iob` with `(* IOB = "TRUE" *)` plus XDC `set_property IOB TRUE`. Pin clock `CLK100MHZ` E3 period 10.000 ns. Pipe clock MMCM 100→50 + BUFG, generated `clk50u` period 20.000 ns (**real**, attributes P,G,A). I/O timing reference `uart_io_vclk` period 20.000 ns (**virtual**, attribute V) with frozen `set_input_delay` / `set_output_delay` **max 2.000 min 0.500**. HOLD_POLICY frozen in PREREG before impl: **`FALSE_PATH_HOLD_ASYNC_UART`**. Part `xc7a100tcsg324-1`. Mode **in-context** `synth_design` (not `-mode out_of_context`) then `opt_design` / `place_design` / `route_design`. No bitstream.

Gate under review is **work-order ASTRA-11-A09R7-UART-IMPL-ROUTE-01 only** — one unknown (handoff):

> After implement+route of that named R7 UART wrap on xc7a100tcsg324-1 at 50 MHz with D10/A9 and the frozen delay/hold envelope, is WNS ≥ 0 and WHS ≥ 0 on Design Timing Summary — without a bitstream?

Parent after auditor **20260907T0130Z**: R7 UART query-learn XSim CLOSED_NARROW (ans=4 then w0=−5, no force). Residual 5: not a silent production UART freeze. Parent does **not** freeze `PRODUCTION_TOP`. Next is **impl+route** of a new named wrap instantiating frozen A09-R2 with UART pins D10/A9 — same STA envelope as IOdelay/HOLD (delays 2.000/0.500, FALSE_PATH_HOLD_ASYNC_UART, IOB FF if it still packs). No bitstream. Board plugged. **PROGRAM=NO.**

**Not** Master ASTRA-11 fullchip close. **Not** ASTRA-13 board acceptance. **Not** freeze of `PRODUCTION_TOP`. **Not** R7 XSim as this routed result. **Not** prior HOLD wrap WNS=+0.115 WHS=+0.131 as this result.

Hunt (parent / work order / this dispatch):

1. Quote WNS and WHS from RAW `timing_route.rpt` Design State=Routed. Claimed WNS=+0.336 WHS=+0.104.
2. UART IOB A9/D10 FIXED? IOB FFs packed?
3. STA envelope 2.000/0.500 + FALSE_PATH_HOLD frozen in PREREG before impl? Hold exception honest?
4. No `.bit`? `PRODUCTION_TOP` UNKNOWN?
5. Not claiming wrap-route WNS=+5.733 or BOARD_PASS?
6. Hash before impl including `.svh`?

Confirm: frozen A09-R2 instantiated; ASTRA-09-R7 XSim bag **not** overwritten; prior UART WNS bags **not** overwritten.

Judged against:

1. Work order `.agents/handoff/ASTRA-11-A09R7-UART-IMPL-ROUTE-01.md` + PREREG: instantiate `a7ng_astra_09_r2_cand_ovf`; do **not** edit ASTRA-09-R7 / ASTRA-11 UART IOdelay/IOBFF/HOLD bags / frozen A09-R2; freeze STA envelope **before** impl (copy 2.000/0.500 + FALSE_PATH_HOLD; do not invent after WNS); hash RTL+XDC+tcl before impl; impl+route at declared 50 MHz; quote routed Design State WNS **and** WHS; UART IOB in `io.rpt`; IOB FF if it still packs; FAIL if WNS<0 or WHS<0; PROGRAM=NO; do not overwrite R7 XSim, HOLD WNS=+0.115 WHS=+0.131, IOBFF WNS=+0.115 WHS=−4.915, I/O-delay WNS=+0.681, UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, A09 wrap WNS=+1.041, or wrap-route WNS=+5.733; do not close ASTRA-13, BOARD_PASS, LM06, Master F3; do not freeze `PRODUCTION_TOP`.
2. **Master ASTRA-11** (DAG: FULLCHIP-COFIT): whole-chip co-fit of the frozen SoC top (UART + MMCM + I/O + memory plant + production path together), not an isolated named UART wrap with a fixture plant plus an STA hold exception.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/LOOP_STATE.json`: *astra13=BLOCKED; program=false; production_top=UNKNOWN.* ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate.
4. Auditor `20260907T0130Z`: ASTRA-09-R7-UART-QUERY-REW-01 PASS_NARROW UART query-learn XSim; residual = not a silent production UART freeze. Auditor `20260906T1900Z`: HOLD bag PASS_NARROW WNS=+0.115 WHS=+0.131; UART I/O hold excepted (not physically MET); min 0.500 NOT_APPLIED on that bag. Auditor `20260906T1830Z`: IOBFF WHS=−4.915 with min 0.500 and no hold exception. a7-fpga-gate numeric: WNS ≥ 0; TNS = 0; **WHS/THS report; negative hold is a finding**.

**Master ASTRA-11 as a whole is not this bag’s close**, even if this wrapper’s routed WNS and DTS WHS are ≥ 0 and UART IOB FFs packed.

Out of this bag’s close: freeze of `PRODUCTION_TOP`, silicon UART / silicon MMCM / silicon BRAM, `a7ng_axi_bram128` plant, bitstream, JTAG/COM12, LM06 language, Master ASTRA-09 production path, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, ASTRA-13 BOARD_PASS, wrap-route `arty_a7_astra_rtp_soc_top` WNS=+5.733 identity, A09R2 wrap WNS=+0.648 identity, leftover A09 wrap WNS=+1.041 identity, prior UART wrap WNS=+0.305 identity, prior I/O-delay wrap WNS=+0.681 identity, prior IOBFF wrap WNS=+0.115 WHS=−4.915 identity, prior HOLD wrap WNS=+0.115 WHS=+0.131 identity, R7 XSim ans=4/w0=−5 as this bag, LED I/O delay, FT2232H silicon Tsu, claim that UART IOB hold is now **physically MET**.

Frozen `a7ng_astra_09_r2_cand_ovf.sv` / `.svh`, leftover `a7ng_astra_09_integ_path.sv` / `.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `uart_rx.sv` / `uart_tx.sv`, F2R3/F2R4/F2R5, persist/R2/R3/R4 must remain **unpatched**. This wrap is a **new named** R7 UART impl/route wrapper. It must **instantiate** A09-R2, not copy the graph. It must **not** compile leftover A09 / `astra09_pipe` / `axi_bram128` / RTP SoC / R7 XSim wrap / prior UART impl wrap / prior I/O-delay wrap / prior IOBFF wrap / prior HOLD wrap as this top.

Prior bags `ASTRA-09-R7-UART-QUERY-REW-01`, `ASTRA-11-A09R3-UART-IOBFF-HOLD-01`, `ASTRA-11-A09R3-UART-IOBFF-01`, `ASTRA-11-A09R3-UART-IODELAY-01`, `ASTRA-11-A09R3-UART-IMPL-ROUTE-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, `ASTRA-SOC-RTP-WRAP-ROUTE`, `ASTRA-09-R2-CAND-OVF-01` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`e1313f5e…90493567`). `write_scope` = new bag + distinctly named UART impl-route wrap that **instantiates** frozen `a7ng_astra_09_r2_cand_ovf` as `u_a09r2` with R7 query-rew UART FSM, wrap pad FFs IOB=TRUE on `uart_txd_in` A9 and `uart_rxd_out` D10, and STA envelope frozen in PREREG **before** impl (I/O delays IN/OUT max 2.000 min 0.500 plus FALSE_PATH_HOLD_ASYNC_UART). R7 wrap `a7ng_astra_09_r7_uart_query_rew_wrap` is synthesizable UART+A09-R2 but is **KEEP_NOT_COMPILED** (new named wrap required for this bag STA/IOB; do not copy-paste the graph; do not edit R7 bag). Frozen leftover A09 not compiled as DUT. A09-R2 DUT source not patched. `uart_rx`/`uart_tx` not patched. Prior bags not edited **including ASTRA-09-R7-UART-QUERY-REW-01 XSim and ASTRA-11-A09R3-UART-IOBFF-HOLD-01 WNS=+0.115 WHS=+0.131**. `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, **ASTRA-09-R7-UART-QUERY-REW-01**, **ASTRA-11-A09R3-UART-IOBFF-HOLD-01**, **ASTRA-11-A09R3-UART-IOBFF-01**, **ASTRA-11-A09R3-UART-IODELAY-01**, **ASTRA-11-A09R3-UART-IMPL-ROUTE-01**, ASTRA-SOC-RTP-WRAP-UART-XSIM, ASTRA-09-R3-UART-XSIM-01, Master_ASTRA-10_whole_chip, production_top_identity, write_bitstream, LED_IO_delay, silicon_UART.

`run_impl.tcl` **renames** `write_bitstream` to abort (`astra_forbid_bit` → exit 1). `vivado.jou`: **no** `write_bitstream` and **no** `.bit`. Compile list is pkg/query/sparse/SGD/**A09-R2**/uart_rx/uart_tx/bag plant/bag wrap only. Tcl forbids leftover A09 / `astra09_pipe` / RTP SoC / R7 XSim wrap / prior UART impl/IOdelay/IOBFF/HOLD wraps / `axi_bram128`. Post-synth cell checks abort if leftover A09 / pipe / BRAM cells exist, or if `u_a09r2` / `u_rx` / `u_tx` cells are missing. UART IOB extract requires A9=`uart_txd_in` and D10=`uart_rxd_out` in `io.rpt`.

Bag listing: **no** `.bit` / `.bin` / `.mcs`, no `fail_r0/`, no `FIRST_DIVERGENCE.txt`, no `timing_route_exp.rpt`. Checkpoints are `ckpt/synth.dcp` and `ckpt/route.dcp` only. Bounded WNS<0/WHS<0 experiment **not run** (DTS WNS ≥ 0 and WHS ≥ 0). IDELAYE2=0 IDELAYCTRL=0 (this bag packs IOB FFs; it is **not** an IDELAY primitive bag).

`vivado.log` grep for `write_bitstream`, `a7ng_astra_09_integ_path`, `BOARD_PASS`, `IDELAY`: **no matches**. `PRODUCTION_TOP=UNKNOWN` at start and DONE.

---

### 1. Raw routed WNS and WHS (authority)

`timing_route.rpt` header:

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Mon Sep  7 01:52:48 2026
Command      : report_timing_summary -file .../ASTRA-11-A09R7-UART-IMPL-ROUTE-01/timing_route.rpt
Design       : a7ng_astra_11_a09r7_uart_impl_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      0.336        0.000                      0                 8940        0.104        0.000                      0                 8938
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
  clk50u            0.336        0.000                      0                 7245        0.104        0.000                      0                 7245
```

Inter-clock table (hold columns **blank**):

```text
uart_io_vclk  clk50u             19.270        0.000                      0                    1
clk50u        uart_io_vclk        7.313        0.000                      0                    1
```

clk50u group: Setup 0 failing, Worst Slack **0.336 ns**. Hold 0 failing, Worst Slack **0.104 ns**.

Implementer claim **WNS=+0.336 WHS=+0.104 @ clk50u 20.000 ns MATCHES raw routed timing**. TNS=0.000 THS=0.000. Failing endpoints = 0. `TIMING_EXTRACT.txt` / `metrics.json` / `vivado.log` DONE line match the raw summary. No RESULTS vs raw-rpt contradiction on WNS/TNS/WHS.

Worst setup path (same rpt): `Slack (MET) : 0.336ns`; source `u_a09r2/pc2_reg[2][3]/C` → dest `u_a09r2/u_sgd/w_reg[0][5]/D`; **Requirement 20.000 ns**; Data Path Delay 19.440 ns (logic 10.452 / route 8.988); 23 logic levels (CARRY4=14 + DSP48E1=1 + LUT1/2/4/5/6); Path Group `clk50u`. Source Clock Delay **6.427 ns**, Destination Clock Delay **6.066 ns**. This is a real SGD path **inside instantiated A09-R2**, not a wrap-only tautology.

Worst hold path: `Slack (MET) : 0.104ns`; source `u_a09r2/best_p0_reg[15]/C` → dest `tx_bytes_reg[6][7]/D` (DUT `p0` captured into UART TX frame). Intra-`clk50u`. MET. **Not** a UART IOB hold vs `uart_io_vclk`.

Clock path on that routed worst setup (same rpt):

```text
E3  CLK100MHZ
E3  IBUF          CLK100MHZ_IBUF_inst/O
MMCME2_ADV_X1Y2   u_mmcm/CLKOUT0     net clk50u (fo=1, routed)
BUFGCTRL_X0Y16    u_bufg50/O
net (fo=3617, routed) u_a09r2/clk
Source Clock Delay = 6.427 ns
```

`clocks_route.rpt` Design State **Routed** 01:52:52:

```text
Clock        Period(ns)  Waveform(ns)    Attributes  Sources
sys_clk_pin  10.000      {0.000 5.000}   P           {CLK100MHZ}
uart_io_vclk 20.000      {0.000 10.000}  V           {}
clk50u       20.000      {0.000 10.000}  P,G,A       {u_mmcm/CLKOUT0}
clkfb        10.000      {0.000 5.000}   P,G,A       {u_mmcm/CLKFBOUT}
```

**Pipe clock is not virtual.** `uart_io_vclk` is the declared I/O reference (V). `clock_util_route.rpt`: MMCM=1, BUFGCTRL=1 at **BUFGCTRL_X0Y16**, clock loads **3617**, period 20.000, driver `u_bufg50/O` net `clk`, source `MMCME2_ADV/CLKOUT0` site **MMCME2_ADV_X1Y2**.

`check_timing` (also embedded in `timing_route.rpt`): `no_clock` 0, `unconstrained_internal_endpoints` 0, `partial_input_delay` 0, `partial_output_delay` 0, `no_input_delay` 3 MEDIUM false-path (`btn[0]`, `sw[0]`, `sw[1]`), `no_output_delay` 4 HIGH (`led[0:3]`). Quoted WNS is **internal register-to-register** under `clk50u`. UART ports are **not** in `no_input_delay` / `no_output_delay`. LED unconstrained I/O is a residual vs board I/O timing close, **not** a silent manufacture of the 0.336 ns internal slack.

`route_status.rpt`: **nets with routing errors = 0**.

DRC: 9 checks, all Warning (DSP DPIP/DPOP pipeline on `u_a09r2/u_sgd`). **0 Error / 0 Critical**. Unpipelined DSP is consistent with frozen F2R2 SGD.

Synth-only contrast (not the WNS quote): `TIMING_EXTRACT_SYNTH.txt` Design State **Synthesized** `WNS=2.141` `WHS=0.045`. Implementer correctly quotes **routed** 0.336 / 0.104, not synth 2.141. `vivado.log`: `synth_design -top a7ng_astra_11_a09r7_uart_impl_wrap -part xc7a100tcsg324-1` (no `-mode out_of_context`).

WNS ≥ 0 and WHS ≥ 0. Bounded WNS<0/WHS<0 experiment **not run** (not applicable). Hunt 1: **MET.**

---

### 2. UART IOB A9/D10 FIXED? IOB FFs packed?

Bag-local `clk50_uart_impl.xdc` (PRE=POST SHA `72004235…286c3e57`):

```text
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]
set_property IOB TRUE [get_ports uart_txd_in]
set_property IOB TRUE [get_ports uart_rxd_out]
```

Official `constraints/arty_a7_100.xdc` (cited, not edited from this bag): D10 = `uart_rxd_out` (FPGA TX); A9 = `uart_txd_in` (FPGA RX).

Raw `io.rpt` Design `a7ng_astra_11_a09r7_uart_impl_wrap`, Total User IO=15, Date 01:52:52:

```text
| A9         | uart_txd_in  | ... | INPUT  | LVCMOS33 | ... | FIXED |
| D10        | uart_rxd_out | ... | OUTPUT | LVCMOS33 | ... | FIXED |
| E3         | CLK100MHZ    | ... | INPUT  | LVCMOS33 | ... | FIXED |
```

Direction matches the hunt and Digilent names: **A9 = FPGA RX (`uart_txd_in`) INPUT FIXED**; **D10 = FPGA TX (`uart_rxd_out`) OUTPUT FIXED**. Pins are **not swapped**.

`UART_IOB.txt`: `UART_TXD_IN_A9=YES uart_txd_in` / `UART_RXD_OUT_D10=YES uart_rxd_out` / `UART_IOB=YES`.

`UART_IOBFF.txt`:

```text
UART_RX_IOB_CELL=uart_rx_iob_reg
UART_RX_IOB_BEL=ILOGICE2.IFF
UART_RX_IOB_LOC=ILOGIC_X0Y171
UART_RX_IOB_PACKED=YES
UART_TX_IOB_CELL=uart_tx_iob_reg
UART_TX_IOB_BEL=OLOGICE2.OUTFF
UART_TX_IOB_LOC=OLOGIC_X0Y161
UART_TX_IOB_PACKED=YES
UTIL_IOB_FLIP_FLOPS=2
UTIL_ILOGIC=1
UTIL_OLOGIC=1
UART_IOBFF=YES
```

`util_route.rpt` Bonded IOB **15 / 15 FIXED**; **IOB Flip Flops=2 (Fixed=2)**; **ILOGIC=1 (IFF_Register=1)**; **OLOGIC=1 (OUTFF_Register=1)**; IDELAYE2=0; IDELAYCTRL=0.

Wrap RTL: `(* IOB = "TRUE" *)` `uart_rx_iob` samples `uart_txd_in`; `uart_tx_iob` registered `uart_tx.tx` drives `uart_rxd_out`. Frozen `uart_rx` / `uart_tx` **not patched**. `timing_uart_in.rpt` dest **ILOGIC_X0Y171 `uart_rx_iob_reg/D`**. `timing_uart_out.rpt` source **OLOGIC_X0Y161 `uart_tx_iob_reg/C`**.

`vivado.log`: `UART_IOB A9=YES D10=YES` / `UART_IOBFF=YES RX=YES TX=YES RX_BEL=ILOGICE2.IFF RX_LOC=ILOGIC_X0Y171 TX_BEL=OLOGICE2.OUTFF TX_LOC=OLOGIC_X0Y161` / `UART_IOBFF_CELLS=2`.

Handoff: “IOB FF if it still packs” — **it packed**. Hunt 2: **MET. UART IOB = YES. UART IOB FF = YES.**

---

### 3. STA envelope 2.000/0.500 + FALSE_PATH_HOLD frozen in PREREG before impl? Hold exception honest?

**PREREG (opened; no this-bag routed WNS/WHS numbers — policy before impl):**

```text
STA_ENVELOPE    = UART_IO_DELAY_2P000_0P500 + FALSE_PATH_HOLD_ASYNC_UART
UART_IN_MAX_NS  = 2.000
UART_IN_MIN_NS  = 0.500
UART_OUT_MAX_NS = 2.000
UART_OUT_MIN_NS = 0.500
HOLD_POLICY     = FALSE_PATH_HOLD_ASYNC_UART
```

XDC (hashed **before** impl; same numbers):

```tcl
create_clock -name uart_io_vclk -period 20.000
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]
set_false_path -hold -from [get_ports uart_txd_in]
set_false_path -hold -to   [get_ports uart_rxd_out]
```

Post-synth clock-to-clock (same PREREG; applied by `astra_apply_hold_policy` after synth/opt/place when `clk50u` exists):

```tcl
set_false_path -hold -from [get_clocks uart_io_vclk] -to [get_clocks clk50u]
set_false_path -hold -from [get_clocks clk50u] -to [get_clocks uart_io_vclk]
```

`vivado.log` header **before** `synth_design` already prints `UART_IN_MAX_NS=2.000 UART_IN_MIN_NS=0.500` / `HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART`. `HOLD_POLICY_CLK_FALSE_PATH_HOLD_APPLIED=2` after synth, after opt, and after place (three applications). Redundant, same policy, not a post-WHS invention.

**Raw `exceptions_route.rpt` Design State=Routed 01:52:53, Design `a7ng_astra_11_a09r7_uart_impl_wrap`:**

```text
Position  From                     To                        Setup           Hold
2         [get_ports {sw[*]}]      *                         false           false
3         [get_ports {btn[*]}]     *                         false           false
9         [get_ports uart_txd_in]  *                         -               false
10        *                        [get_ports uart_rxd_out]  -               false
```

Hold column **`false`**. Setup column **`-`** (setup **not** excepted) on UART pad rows. sw/btn remain full false-path (both setup and hold) — same as prior UART bags, not this hold policy.

Clock-to-clock false-path-hold rows are **not listed** as separate exceptions (HOLD bag T1900 listed them at positions 9–14). Log still printed `HOLD_POLICY_CLK_FALSE_PATH_HOLD_APPLIED=2` three times. `uart_io_vclk` has no sources and only times these two UART pads, so pad-level `-hold` already covers the inter-clock UART I/O hold; Vivado’s merged exceptions report keeps the port rows. Inter Clock hold columns are **blank**. Residual vs T1900’s fuller exceptions listing — **not** evidence that hold was secretly re-enabled.

Setup still checked:

- `timing_uart_in.rpt`: setup Input Delay **2.000 ns**, Slack MET **19.270 ns**, dest `uart_rx_iob_reg` at ILOGIC_X0Y171, IBUF→IFF route **0.000 ns**. Command was `-delay_type min_max`; report contains **setup only** (no hold path).
- `timing_uart_out.rpt`: setup Output Delay **2.000 ns**, Slack MET **7.313 ns**, source `uart_tx_iob_reg` at OLOGIC_X0Y161.
- `UART_IODELAY.txt`: `UART_IN_HOLD_SLACK=` / `UART_OUT_HOLD_SLACK=` blank; `HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART`.
- `check_timing`: `partial_input_delay=0` / `partial_output_delay=0` — min 0.500 **was applied** (unlike HOLD bag, where min was NOT_APPLIED and `partial_*` was HIGH).

**Adversary classification of Hunt 3:**

| Test | Result |
|------|--------|
| Frozen in PREREG **before** impl? | **YES.** ACK + PREREG + XDC hashed `2026-09-07T01:47:46.1996747+07:00`. Vivado start `Mon Sep 7 01:47:47 2026` (~1 s later). Header already prints the envelope **before** `synth_design`. PREREG contains **no** this-bag WNS=+0.336 / WHS=+0.104. |
| Handoff-required envelope? | **YES.** Handoff: copy 2.000/0.500 + FALSE_PATH_HOLD. XDC has both. |
| Forbidden T1900 cheat “copy-paste 2.000/0.500 min delay then hide WHS”? | **Combination is present; disclosure is present.** T1900 HOLD bag **did not** apply `-min 0.500` (that bag’s work order forbade hiding WHS that way). **This** handoff explicitly asked for both numbers **and** the hold exception. Implementer applied both, froze them before impl, and discloses that UART I/O hold vs `uart_io_vclk` is **excepted**, DTS WHS is **intra-clk50u +0.104**, and `UART_*_HOLD_SLACK` is blank. Not a silent hide. |
| Setup still checked? | **YES.** UART pad exceptions are hold-only. Inter-clock setup WNS 19.270 / 7.313. Input/Output Delay 2.000 on the setup paths. |
| Hold physically “fixed”? | **NO.** IBUF→IFF route remains **0.000 ns** (same ILOGIC_X0Y171 class as T1830/T1900). Prior IOBFF bag with min 0.500 and **no** hold exception still shows Slack (VIOLATED) **−4.915 ns** on that path class. This bag’s UART in/out timing reports contain **setup only**. Inter Clock hold columns are **blank**. |
| DTS WHS tautological? | **UART I/O hold: yes, excepted.** **Intra-clk50u WHS=+0.104: no** — that is a real `clk50u` hold MET on `u_a09r2/best_p0_reg[15]` → `tx_bytes_reg[6][7]`. |
| Delay numbers invented after WNS? | **NO.** 2.000/0.500 are the repo UART I/O class already frozen in IOdelay/IOBFF. Copied into PREREG/XDC before impl. Not fitted to +0.336 / +0.104. |

**Technical honesty of the exception (not a silicon claim):** UART 115200 on Arty A7 has **no related FTDI launch clock** on the FPGA. Bit period ~8.68 µs. Packed ILOGIC IFF + frozen `uart_rx` 2-FF is the CDC. Hold vs a 20 ns **virtual** `uart_io_vclk` with SCD=0 against real MMCM+BUFG DCD is an STA envelope collision, not a 115200 silicon hold requirement. T1830/T1900 already said that. Applying the frozen 2.000/0.500 **setup** envelope and excepting hold vs that virtual clock, **keeping setup max 2.000**, is a legitimate async-I/O STA envelope **for this work order** — **provided** it is frozen before impl and not sold as “the −4.915 path now METs.”

**Not a clean PASS:** Design Timing Summary WHS ≥ 0 does **not** mean UART IOB hold is physically MET. It means (1) intra-`clk50u` hold is MET +0.104 and (2) the UART I/O hold class is excepted. Envelope-tautological UART-hold WHS answers the **declared** unknown (handoff asked for this envelope). It does **not** make UART IOB hold physically MET.

Hunt 3: **MET as frozen-before-impl honest async UART exception. Not a hide-WHS cheat of the undisclosed-min type. UART I/O hold is excepted, not physically MET.**

---

### 4. No `.bit`? PROGRAM=NO? PRODUCTION_TOP=UNKNOWN?

- Bag directory: no `.bit` / `.bin` / `.mcs`. `ckpt/` holds `synth.dcp` + `route.dcp` only.
- `vivado.log` DONE: `BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN`. Exit `Mon Sep 7 01:52:53 2026`. No `write_bitstream` command.
- `vivado.jou`: **no** `write_bitstream` / `.bit`.
- TCL: `write_bitstream` renamed to abort before synth. WNS≥0 path never calls it. WNS<0 path also never calls it.
- ACK / PREREG / RESULTS / CLOSEOUT / metrics: `PRODUCTION_TOP=UNKNOWN`, `PROGRAM=NO`.
- LOOP_STATE (read-only): `program=false`, `board_pass=false`, `astra13=BLOCKED`, `production_top=UNKNOWN`, `com12=USER_SAYS_PLUGGED_UNPROGRAMMED`.

Hunt 4: **MET.** Board plugged ≠ programmed.

---

### 5. Overclaim of wrap-route +5.733 / BOARD_PASS? Prior bags overwritten?

Implementer RESULTS/CLOSEOUT cite prior WNS numbers only as **not this result**. Marker is bag-local `ASTRA_11_A09R7_UART_IMPL_ROUTE_DONE WNS=0.336 TNS=0.000 WHS=0.104 UART_IOB=YES UART_IOBFF=YES HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN`. No `BOARD_PASS` vocabulary used as a pass.

Prior bags still on disk (headers opened this session):

| Bag | Raw identity still on disk |
|-----|----------------------------|
| `ASTRA-09-R7-UART-QUERY-REW-01/xsim.log` | session **Mon Sep 7 01:24:47 2026** PID **46472** snapshot `a09r7qr`; still prints `ASTRA_09_R7_UART_QUERY_REW_PASS`; `$finish` / exit **01:26:05**. Wrap SHA KEEP `aeb7e194…fc2c608c` **MATCH** R7 `SHA256.txt`. `xsim_fail_r0.log` still present. **Not overwritten.** |
| ASTRA-11-A09R3-UART-IOBFF-HOLD-01 | `timing_route.rpt` **Sun Sep 6 23:33:11**, Design `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`, raw **WNS=0.115 WHS=0.131**. Wrap SHA KEEP `76c4cf1d…8d27f6ae` **MATCH** HOLD `SHA256.txt`. **Not overwritten.** |
| ASTRA-11-A09R3-UART-IOBFF-01 | `timing_route.rpt` **Sun Sep 6 23:06:09**, Design `a7ng_astra_11_a09r3_uart_iobff_wrap`, raw **WNS=0.115 WHS=−4.915**. XDC KEEP `dad1dbf2…`. **Not overwritten.** |
| ASTRA-11-A09R3-UART-IODELAY-01 | `timing_route.rpt` **Sun Sep 6 22:39:44**, Design `a7ng_astra_11_a09r3_uart_iodelay_wrap`, raw **WNS=0.681**. Wrap SHA KEEP `34353bb7…`. **Not overwritten.** |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 22:12:21**, Design `a7ng_astra_11_a09r3_uart_impl_wrap`, raw **WNS=0.305**. Wrap SHA KEEP `1c3a95f4…`. **Not overwritten.** |
| ASTRA-11-A09R2-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 21:26:25**, Design `a7ng_astra_11_a09r2_impl_wrap`, raw **WNS=0.648**. Wrap SHA KEEP `1932ee4c…`. **Not overwritten.** |
| ASTRA-11-A09-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 19:48:09**, Design `a7ng_astra_11_a09_impl_wrap`, raw **WNS=1.041**. **Not overwritten.** |
| ASTRA-SOC-RTP-WRAP-ROUTE | `timing.rpt` **Sun Sep 6 02:11:52**, Design `arty_a7_astra_rtp_soc_top`, raw **WNS=5.733**. **Not overwritten.** |

This routed WNS=+0.336 / WHS=+0.104 is **not** recycled +5.733 / +0.115 / +0.305 / +0.648 / +1.041 / +0.681. Occupancy LUT=4945 FF=3615 is **larger** than HOLD/IOBFF 4802/3500 (R7 FSM + OBS/REW states). Worst setup path is SGD `pc2_reg`→`w_reg`, not the HOLD-bag walker `pv_reg`→`best_a_reg`. This is a **new P&R** of a larger named wrap, not an STA-envelope delta on the same netlist. Hunt 5: **MET. Not OVERCLAIM of those identities.**

---

### 6. Hash before impl including `.svh`? Instantiated not copied? Frozen A09 not compiled? R7 XSim intact?

**Hash order**

- `SHA256.txt` / `SOURCE_HASHES.txt`: **BEFORE impl** `2026-09-07T01:47:46.1996747+07:00`
- Vivado start: `Mon Sep 7 01:47:47 2026` (PID 17968) — 1 s later
- Reports: `01:52:47` (util_hier) … `01:52:48` (timing_route) … `01:52:52` (io/clocks/check_timing) … `01:52:53` (exceptions / uart in/out / exit)
- `SHA256_POST.txt`: **AFTER impl** `2026-09-07T01:52:54.4676831+07:00`

`run_impl.ps1` live-checks frozen leftover A09 / R2 DUT / SGD / uart_rx / uart_tx hashes, writes SHA256 of compiled + **`.svh`** + CONFIG + KEEP + provenance **then** calls Vivado. Not hash-after-scores theatre on compiled sources.

PRE vs POST compiled RTL+XDC+tcl + transitive `.svh`: **20/20 identical strings** (opened manifests; not re-hashed):

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
| bag `a7ng_astra_11_a09r7_uart_impl_plant.sv` | `2f5db739999e9dd21d76c0ebd54136bed4dd08f42de8d0e45f7c0ce8fc79ebda` |
| bag `a7ng_astra_11_a09r7_uart_impl_wrap.sv` | `d1f66a542f02c4932b821e5355c645e941b6beb057cb6bbb06dca56208644bde` |
| bag `clk50_uart_impl.xdc` | `720042357815a5e7cd80a8475eedef6dd3e7826d59d4e58e6412b1d7286c3e57` |
| bag `run_impl.tcl` | `33d5fcfe50f0905c8ee3d7eb60187529464cd5270b8d585abbaea36d2f51267f` |
| `a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `a7ng_astra_09_integ_path.svh` | `ad2d66d4783bba33cfbd324fc0a9661fb2a46eeaffb5b4fb6989246fb4e94302` |
| `a7ng_astra_09_r2_cand_ovf.svh` | `feaed571ce02bec4218e2105986349a464d6c44bcf1a818260ee27a171afd329` |
| bag `a7ng_astra_11_a09r7_uart_impl.svh` | `2c72fda110723a61c2852148873523e99f6fa5166c9cc2ad00644a28a961434b` |

`.svh` **is** in the pre-impl freeze (R2 contract + leftover A09 header + lexica + crc + **bag protocol SVH**). Hunt 6 hash-including-`.svh`: **MET.**

R2 DUT `15a919f1…` **MATCH** `ASTRA-09-R2-CAND-OVF-01` / R7 XSim / T1630/T1700/T0130. Frozen leftover A09 `9fdbe0d6…` **MATCH** provenance (KEEP; **not compiled**). Frozen SGD `b66ef328…` MATCH. `uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH R3/R7. R7 wrap KEEP `aeb7e194…` MATCH R7 compiled wrap (**not this top**). HOLD wrap KEEP `76c4cf1d…` MATCH HOLD compiled wrap. Prior UART impl wrap `1c3a95f4…` MATCH.

**Instantiate, not copy-paste; frozen A09 not compiled; R7 wrap not this top**

Bag contains new wrap + bag-local AXI plant only as RTL (no copied integrator `.sv` in the bag). Wrap:

```text
(* IOB = "TRUE" *) uart_rx_iob / uart_tx_iob
(* keep_hierarchy = "yes" *) uart_rx ... u_rx ( .rx(uart_rx_iob), ... );
(* keep_hierarchy = "yes" *) uart_tx ... u_tx ( .tx(tx_int), ... );
(* keep_hierarchy = "yes" *)
a7ng_astra_09_r2_cand_ovf u_a09r2 ( ... rew_v_i/rew_i/tok_*/fire_i/retire_i ... load_v_i=0 );
(* keep_hierarchy = "yes" *)
a7ng_astra_11_a09r7_uart_impl_plant u_plant ( ... );
```

No QSE/sparse/2-hop/SGD duplicated in the wrap. Frozen leftover A09 **not instantiated**. R7 XSim wrap **not instantiated as this top** (tcl forbids `a7ng_astra_09_r7_uart_query_rew_wrap.sv` in the compile list). The wrap carries the R7 query-rew UART FSM (CMD_REW=0xA6 / CMD_RET=0xA7 / MAGIC A2) in a **new named** module required for the STA/IOB envelope — that is allowed; copying the **graph** is forbidden and was not done. Plant header: *Bag-local behavioral AXI plant. Not silicon BRAM. Not a7ng_axi_bram128 edit. Not an edit of ASTRA-09-R7 plant source.*

Raw log elaboration (not RESULTS):

```text
synthesizing module 'a7ng_astra_11_a09r7_uart_impl_wrap' [.../ASTRA-11-A09R7-UART-IMPL-ROUTE-01/a7ng_astra_11_a09r7_uart_impl_wrap.sv:10]
synthesizing module 'MMCME2_BASE'
synthesizing module 'BUFG'
synthesizing module 'uart_rx' [.../rtl/board/uart_rx.sv:2]
synthesizing module 'uart_tx' [.../rtl/board/uart_tx.sv:2]
synthesizing module 'a7ng_astra_09_r2_cand_ovf' [.../rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv:9]
synthesizing module 'a7ng_query_axi_sparse'
synthesizing module 'a7ng_query_role_extract'
synthesizing module 'a7ng_sparse_dir_axi'
synthesizing module 'a7ng_shared_rank_sgd_q8_sym_f2r2'
synthesizing module 'a7ng_astra_11_a09r7_uart_impl_plant' [.../a7ng_astra_11_a09r7_uart_impl_plant.sv:6]
U_A09R2_CELLS=11063
U_RX_CELLS=76
U_TX_CELLS=56
UART_IOBFF_CELLS=2
```

**Not synthesized:** `a7ng_astra_09_integ_path` (zero synthesizing-module lines; zero log matches), `a7ng_astra09_pipe`, `arty_a7_astra_rtp_soc_top`, `a7ng_axi_bram128`, `a7ng_astra_09_r7_uart_query_rew_wrap`, `a7ng_astra_11_a09r3_uart_impl_wrap`, `a7ng_astra_11_a09r3_uart_iodelay_wrap`, `a7ng_astra_11_a09r3_uart_iobff_wrap`, `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`. **Required instantiate-not-copy, frozen-A09-not-compiled, R7-XSim-not-this-top: MET.**

---

## Resources (raw; not the WNS quote)

Quoted **synth** `util_synth.rpt` / `UTIL_EXTRACT_SYNTH.txt` Design State Synthesized:

```text
Slice LUTs        5793 / 63400  (9.14%)
Slice Registers   5085 / 126800 (4.01%)
Block RAM Tile       0
DSPs                 2
```

Quoted **routed** `util_route.rpt` Design State Routed:

```text
| Slice LUTs              | 4945 |     0 |          0 |     63400 |  7.80 |
| Slice Registers         | 3615 |     0 |          0 |    126800 |  2.85 |
| Block RAM Tile          |    0 |
| DSPs                    |    2 | ...  DSP48E1 only
| Bonded IOB              |   15 |    15 |          0 |       210 |  7.14 |
| IOB Flip Flops          |    2 |     2 |
| ILOGIC                  |    1 |     1 |  IFF_Register=1
| OLOGIC                  |    1 |     1 |  OUTFF_Register=1
| BUFGCTRL                |    1 |
| MMCME2_ADV              |    1 |
| IDELAYE2                |    0 |
| IDELAYCTRL              |    0 |
```

Hierarchical routed (`util_hier_route.rpt`):

```text
| a7ng_astra_11_a09r7_uart_impl_wrap | (top)                           | 4945 | 3615 | 0 | 2 |
|   (top remainder)                  |                                 |  398 |  748 | 0 | 0 |
|   u_a09r2                          | a7ng_astra_09_r2_cand_ovf       | 4325 | 2738 | 0 | 2 |
|     u_sgd                          | a7ng_shared_rank_sgd_q8_sym... |  554 |  615 | 0 | 2 |
|     u_sp                           | a7ng_query_axi_sparse           | 3334 |  696 | 0 | 0 |
|       u_walk                       | a7ng_sparse_dir_axi             | 1006 |  450 |
|       g_law.u_qse                  | a7ng_query_role_extract         | 2328 |  202 |
|   u_plant                          | a7ng_astra_11_a09r7_uart_impl_plant | 170 | 73 | 0 | 0 |
```

Honest occupancy of a **live R7 UART wrap**: QSE LUT=2328 is **not** the I/O-folded QSE=39 of A09R2 wrap. Top remainder LUT=398 / FF=748 is the R7 FSM + IOB FFs (HOLD bag top remainder was smaller). Plant is behavioral (LUT=170, BRAM=0), **not** wrap-route BRAM=2. SGD DSP×2 remains. Worst setup path still inside `u_a09r2.u_sgd`. **Not a stub DUT.** Also **not** whole-chip `axi_bram128` / DDR occupancy. Do not add 4945 to HOLD 4802, IOBFF 4802, I/O-delay 4803, UART wrap 4804, A09R2 wrap 1321, leftover A09 wrap 1305, or wrap-route 4244 as a chip sum.

Comparison (not identity):

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 4945 | 3615 | 0 | 2 | **Routed clk50u WNS=+0.336 WHS=+0.104 IOB FF YES delays 2.000/0.500 FALSE_PATH_HOLD** |
| This bag synth | 5793 | 5085 | 0 | 2 | Synthesized (not the quote; extract +2.141 / WHS=+0.045) |
| ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed | 4802 | 3500 | 0 | 2 | Routed IOB FF YES HOLD **WNS=+0.115 WHS=+0.131** — not overwritten |
| ASTRA-11-A09R3-UART-IOBFF-01 routed | 4802 | 3500 | 0 | 2 | Routed IOB FF YES delays 2.000/0.500 **WNS=+0.115 WHS=−4.915** — not overwritten |
| ASTRA-11-A09R3-UART-IODELAY-01 routed | 4803 | 3500 | 0 | 2 | Routed delays 2.000/0.500 **no IOB FF +0.681** — not overwritten |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed | 4804 | 3500 | 0 | 2 | Routed UART IOB, **I/O unconstrained +0.305** — not overwritten |
| ASTRA-11-A09R2-IMPL-ROUTE-01 routed | 1321 | 1103 | 0 | 2 | Routed no-UART **+0.648** — not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed different DUT **+1.041** — not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |
| ASTRA-09-R7-UART-QUERY-REW-01 | — | — | — | — | XSim only (ans=4 then w0=−5) — not this routed result |

---

## Overclaim / cheat / tautology

| Hunt | Finding |
|------|---------|
| RESULTS vs raw rpt mismatch on WNS/TNS/WHS | **None.** +0.336 / 0.000 / +0.104 Design State Routed; Intra clk50u +0.336 / +0.104 |
| UART IOB missing / swapped | **Not found.** A9 INPUT `uart_txd_in` FIXED; D10 OUTPUT `uart_rxd_out` FIXED; XDC = Digilent master |
| IOB=TRUE ignored / unpack | **Not found.** IFF_Register=1 OUTFF_Register=1; BEL ILOGICE2.IFF / OLOGICE2.OUTFF; timing Location ILOGIC_X0Y171 / OLOGIC_X0Y161 |
| `set_false_path -hold` hide-WHS cheat (min 0.500 applied then concealed) | **Combination present; not concealed.** Frozen in PREREG before impl. Hold-only (setup still 2.000). Disclosed: Inter Clock hold blank; `UART_*_HOLD_SLACK` empty; metrics `hold_policy_note` says DTS WHS is intra-clk50u. T1900 HOLD bag chose min NOT_APPLIED; **this** handoff ordered 2.000/0.500 **and** FALSE_PATH_HOLD. |
| False-path-hold honest async UART exception | **YES** for this work order. UART 115200 async; no related FTDI clock; IOB FF + `uart_rx` 2-FF is CDC. Written before impl. |
| DTS WHS≥0 tautological given the exception | **UART I/O hold: yes, excepted (not MET).** **Intra-clk50u +0.104: real** DUT `best_p0` → wrap `tx_bytes`. Grade PASS_NARROW, not PASS. |
| RESULTS claims UART IOB hold now MET +0.104 | **Not found.** Explicitly intra-clk50u; UART hold excepted |
| BOARD_PASS / silicon UART | **Not claimed.** BIT=NOT_BUILT; PROGRAM=NO; `uart_io_vclk` is V |
| “All constraints met” including excepted hold as physical | **Vivado line is after exceptions.** Implementer qualifies. Auditor does not promote it as physical hold MET. Not OVERCLAIM of BOARD / Master |
| Wrap-route WNS=+5.733 claimed or overwritten | **Not claimed. Not overwritten** (02:11:52 still 5.733) |
| HOLD wrap WNS=+0.115 WHS=+0.131 claimed or overwritten | **Not claimed. Not overwritten** (23:33:11 still 0.115 / 0.131) |
| IOBFF wrap WNS=+0.115 WHS=−4.915 overwritten | **Not overwritten** (23:06:09 still −4.915) |
| I/O-delay WNS=+0.681 overwritten | **Not overwritten** (22:39:44 still 0.681) |
| UART impl-route WNS=+0.305 overwritten | **Not overwritten** (22:12:21 still 0.305) |
| A09R2 wrap WNS=+0.648 claimed or overwritten | **Not claimed. Not overwritten** (21:26:25 still 0.648) |
| A09 wrap WNS=+1.041 overwritten | **Not overwritten** (19:48:09 still 1.041) |
| R7 XSim ans=4 / w0=−5 claimed as this routed result | **Not claimed. Not overwritten** (01:24:47 PID 46472 still `ASTRA_09_R7_UART_QUERY_REW_PASS`) |
| Pipe clock virtual / no SCD | **Not found.** P,G,A `clk50u`; E3 IBUF→MMCM→BUFG→`u_a09r2/clk` fo=3617 routed; SCD=6.427 ns. Only I/O ref is virtual (declared) |
| Copy-paste graph called instantiate | **Not found.** Named UART FSM wrap + pad FFs + live RTL path in synth log; A09-R2 instantiated |
| R7 wrap compiled as this top | **Not found.** KEEP hash only; tcl forbids; zero synthesizing-module lines |
| Frozen leftover A09 compiled as DUT | **Not found.** Zero synth/log matches; tcl forbids; KEEP hash only |
| Stub / empty DUT | **Not found.** Hier `u_a09r2` LUT=4325; QSE=2328; SGD DSP48E1×2; U_A09R2_CELLS=11063; worst setup inside DUT SGD |
| IDELAY primitive claimed as this envelope | **Not found.** IDELAYE2=0 IDELAYCTRL=0. This bag is IOB FF + delay/hold XDC. |
| Bitstream / PROGRAM | **No bit in this bag.** ACK/RESULTS PROGRAM=NO |
| `PRODUCTION_TOP` frozen | **UNKNOWN** in ACK / log DONE / RESULTS / CLOSEOUT / LOOP_STATE |
| Hash freeze after looking at WNS / `.svh` omitted | **Not found.** PRE 01:47:46 < Vivado 01:47:47; 6 `.svh` in PRE; POST 20/20 MATCH |
| Fail r0 wipe | **N/A.** Single successful session; DTS WNS≥0 and WHS≥0; no fail_r0 artifact to wipe |
| LUT used as whole-chip occupancy | **Not claimed.** Documented fixture plant / BRAM=0 vs wrap-route BRAM=2 |

qstack adversary: worst setup path is a real placed/routed A09-R2 SGD (`pc2_reg` → `u_sgd/w_reg`, 23 logic levels, DSP48E1) under a **propagated generated** 20 ns clock with SCD=6.427 ns and 3617 routed clock loads. `set_false_path -hold` on UART pads and unconstrained LED I/O **do not** create that 0.336 ns slack. UART IOB FIXED on A9/D10 and IOB FF pack are independent of the internal WNS number. `keep_hierarchy` preserves `u_a09r2` / `u_rx` / `u_tx` identity. QSE remaining large (2328) plus top remainder LUT=398 is consistent with a live R7 UART token/reward FSM + responding AXI plant. WNS=+0.336 is **a new P&R**, not a recycled +5.733 / +0.115 / +0.305.

---

## Logic bugs

No route FAIL. No critical warnings. No RESULTS/raw contradiction on the quoted WNS/TNS/WHS. Route complete (0 failed nets). UART IOB FIXED and IOB FFs packed as required. WNS ≥ 0 and WHS ≥ 0 so the handoff WNS<0/WHS<0 bounded experiment was correctly **not** run.

Residuals (not this-bag FAIL):

1. UART I/O **hold** vs virtual `uart_io_vclk` is **excepted**, not physically MET. IBUF→IFF route is still 0.000 ns. Do not read DTS WHS=+0.104 as “the T1830 −4.915 path now METs.” Prior IOBFF bag must stay −4.915 on disk.
2. Min 0.500 **is applied** (`partial_input_delay=0`) **and** hold is excepted, so the min number is recorded but unused for hold. T1900 HOLD bag avoided that cosmetic by leaving min NOT_APPLIED. This handoff ordered both. Residual vs T1900’s cleaner `partial_*` HIGH disclosure — **not** a P1, because this bag discloses hold slack blank.
3. `exceptions_route.rpt` lists pad-level hold false paths only; clock-to-clock rows that HOLD bag listed are absent even though `HOLD_POLICY_CLK_FALSE_PATH_HOLD_APPLIED=2` printed three times. Pad-level already covers the only `uart_io_vclk` endpoints. Nit, not a second policy.
4. `check_timing` HIGH: LEDs have **no `set_output_delay`**. Out of this bag (PREREG). Quoted WNS remains internal R2R.
5. DRC DSP unpipelined (DPIP/DPOP) — expected; frozen F2R2 SGD. Do not patch from this bag.
6. Bag-local `a7ng_astra_11_a09r7_uart_impl_plant` is a **behavioral fixture** (BRAM=0). Master ASTRA-11 fullchip plant (`a7ng_axi_bram128` / DDR) remains open.
7. Occupancy LUT=4945 / QSE=2328 / top remainder 398 is **this R7 UART wrap**, not additive with HOLD 4802, IOBFF 4802, I/O-delay 4803, UART wrap 4804, A09R2 wrap 1321, leftover A09 wrap 1305, or wrap-route 4244 BRAM=2.
8. No independent `Get-FileHash` this process. Overlapping R2/SGD/A09/uart/pkg/R7-wrap hashes MATCH prior bags. Wrap/XDC/tcl/plant/svh digests are first-recorded here.
9. Functional MAGIC A2 / OVF INCOMP / inner w0=−5 remains **XSim** (T0130). This bag does not re-prove UART protocol on silicon or in XSim.
10. Named wrap is a **candidate** UART SoC path, not a silent `PRODUCTION_TOP` freeze. T0130 residual 5 is **physically evidenced** (routed named R7 UART wrap, IOB YES, IOB FF YES, WNS≥0, WHS≥0 under the frozen envelope) and **not closed as production identity**.
11. Wrap copies the R7 UART FSM into a new module rather than instantiating `a7ng_astra_09_r7_uart_query_rew_wrap` as a child. Handoff allowed either a new named wrap or instantiating the R7 wrap if synthesizable; ACK froze KEEP_NOT_COMPILED for the R7 wrap. Graph not copy-pasted. Not a cheat. Host parsers must not mix this wrap’s pin/STA envelope with the XSim wrap as one frozen top.

No DUT logic patch requested. Auditor does not fix.

---

## This bag vs Master ASTRA-11 / ASTRA-13

Work-order unknown **answered**: for wrapper `a7ng_astra_11_a09r7_uart_impl_wrap` / instance `u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf` on `xc7a100tcsg324-1`, post-route (Design State **Routed**) is **WNS=+0.336 ns TNS=0.000 ns WHS=+0.104 ns @ clk50u 20.000 ns (50 MHz)** with **real** E3 IBUF → MMCME2_ADV_X1Y2 → BUFGCTRL_X0Y16 → `u_a09r2/clk` (SCD=6.427 ns, fo=3617 routed), UART IOB **A9 INPUT / D10 OUTPUT FIXED**, UART IOB FFs **packed** (ILOGIC_X0Y171 IFF / OLOGIC_X0Y161 OUTFF), STA envelope **2.000/0.500 + FALSE_PATH_HOLD_ASYNC_UART frozen before impl**, **BIT=NOT_BUILT**, **PROGRAM=NO**, **PRODUCTION_TOP=UNKNOWN**. Frozen leftover A09 **not compiled**. R7 XSim bag **not overwritten**. HOLD / IOBFF / IOdelay / UART-impl / A09R2 / leftover A09 / wrap-route WNS bags **not overwritten**.

T0130 residual 5 (**not a silent production UART freeze**) is **closed as evidence class** for *impl+route of this named R7 UART wrap with D10/A9 IOB, IOB FFs packed, delays 2.000/0.500 + FALSE_PATH_HOLD, WNS≥0 and WHS≥0*. It is **not** permission to mark Master ASTRA-11 or ASTRA-13 done, and **not** permission to freeze `PRODUCTION_TOP`.

| Master item | This bag |
|---|---|
| ASTRA-11 FULLCHIP-COFIT (UART + MMCM + I/O + AXI BRAM/DDR plant + production path as one frozen top) | Named R7 UART wrap + MMCM/BUFG + D10/A9 IOB + IOB FFs + fixture AXI plant + STA hold exception. No `axi_bram128`. No DDR. `PRODUCTION_TOP=UNKNOWN` |
| ASTRA-11-A09R3-UART-IOBFF-HOLD-01 WNS=+0.115 WHS=+0.131 | Different wrap (no R7 FSM); bag not overwritten; this WNS=+0.336 WHS=+0.104 is **not** that number |
| ASTRA-11-A09R3-UART-IOBFF-01 WNS=+0.115 WHS=−4.915 | Different wrap; bag not overwritten; UART I/O hold still VIOLATED on that bag |
| ASTRA-11-A09R3-UART-IODELAY-01 WNS=+0.681 | Different wrap, no IOB FF; bag not overwritten |
| ASTRA-11-A09R3-UART-IMPL-ROUTE-01 WNS=+0.305 | Different wrap, I/O unconstrained; bag not overwritten |
| ASTRA-11-A09R2-IMPL-ROUTE-01 WNS=+0.648 | Different wrap, no UART; bag not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041 | Different DUT `a7ng_astra_09_integ_path`; bag not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733 | Different top `arty_a7_astra_rtp_soc_top`; bag not overwritten |
| ASTRA-09-R7-UART-QUERY-REW-01 XSim | Prior XSim bag; not this impl/route result; log still 01:24:47 PID 46472 |
| ASTRA-13 FINAL-BOARD-ACCEPTANCE | BIT=NOT_BUILT; PROGRAM=NO; no JTAG/COM12; `PRODUCTION_TOP=UNKNOWN` |
| LM06 language | Not opened |

**No Master-gate overclaim found.**

Master **ASTRA-11 FULLCHIP-COFIT** remains **OPEN** (fixture plant, not frozen SoC top, not wrap-route identity, UART I/O hold excepted not physically MET).

Master **ASTRA-13 FINAL-BOARD-ACCEPTANCE** remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority.

Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-10 whole-chip remain **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-11-A09R7-UART-IMPL-ROUTE-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw routed reports: instantiate-not-copy of `a7ng_astra_09_r2_cand_ovf`, frozen leftover A09 not compiled, R7 XSim wrap KEEP not this top, hash-before-impl including `.svh`, real clock-network (not virtual), WNS=+0.336 ≥ 0, WHS=+0.104 ≥ 0 (intra-clk50u; UART I/O hold excepted), UART IOB A9 INPUT / D10 OUTPUT FIXED matching XDC and Digilent master, UART IOB FFs packed, STA envelope 2.000/0.500 + FALSE_PATH_HOLD frozen in PREREG before impl (honest async UART exception, not an undisclosed hide-WHS), PROGRAM=NO, no bitstream, `PRODUCTION_TOP=UNKNOWN`, prior R7 XSim / HOLD / IOBFF / IOdelay / UART-impl / A09R2 wrap / leftover A09 wrap / wrap-route bags not overwritten, no BOARD_PASS / ASTRA-13 / LM06 overclaim, no theft of wrap-route +5.733 or HOLD +0.115/+0.131.

Not PASS (Master ASTRA-11 fullchip, ASTRA-13 board, silicon UART, `axi_bram128` plant, UART I/O hold physically MET, `PRODUCTION_TOP` freeze).  
Not FAIL (raw WNS/WHS match claim; UART IOB FIXED and IOB FFs packed; route 0 error / 0 critical; frozen R2/SGD/leftover A09/uart unpatched; leftover A09 not compiled; clock path real; STA envelope frozen before impl; prior WNS/XSim bags intact).  
Not OVERCLAIM (ACK/RESULTS keep Master 11/13/BOARD/LM06/`PRODUCTION_TOP` open; disclose UART I/O hold excepted; do not steal HOLD +0.115/+0.131, IOBFF −4.915, I/O-delay +0.681, UART wrap +0.305, A09R2 wrap +0.648, leftover A09 wrap +1.041, wrap-route +5.733, or R7 XSim ans=4/w0=−5).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared routed-WNS-and-WHS-at-50 MHz-with-UART-IOB-D10/A9-and-frozen-delay/hold-envelope claim.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this WNS=+0.336 / WHS=+0.104 / UART_IOB=YES / UART_IOBFF=YES to BOARD_PASS, ASTRA-13, HOLD wrap WNS=+0.115 WHS=+0.131, IOBFF WHS=−4.915, I/O-delay WNS=+0.681, UART wrap WNS=+0.305, A09R2 wrap WNS=+0.648, wrap-route WNS=+5.733, R7 XSim ans=4/w0=−5, or `PRODUCTION_TOP=a7ng_astra_11_a09r7_uart_impl_wrap`.
2. Do **not** claim UART IOB hold is physically MET. DTS WHS=+0.104 is intra-clk50u. UART I/O hold vs `uart_io_vclk` is excepted. The −4.915 IOBFF bag must remain on disk.
3. Do **not** add this LUT/FF to HOLD 4802/3500, IOBFF 4802/3500, I/O-delay 4803/3500, UART wrap 4804/3500, A09R2 wrap 1321/1103, leftover A09 wrap 1305/1075, or wrap-route 4244/3810 BRAM=2. Fixture plant BRAM=0 is honest. Whole-chip co-fit needs **one** current-source SoC top (Master ASTRA-11) plus an explicit `PRODUCTION_TOP` decision.
4. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
5. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv`, frozen A09-R2 (`15a919f1…`), frozen SGD (`b66ef328…`), or frozen `uart_rx` / `uart_tx` from DRC DSP warnings or WHS=+0.104.
6. Do **not** edit ASTRA-09-R7-UART-QUERY-REW-01. That `xsim.log` must stay 01:24:47 PID 46472 with `ASTRA_09_R7_UART_QUERY_REW_PASS`. `xsim_fail_r0.log` must stay.
7. Functional UART 8N1 / MAGIC A2 / inner w0=−5 remains T0130 XSim. This bag is physical route + IOB + STA envelope, not silicon UART.
8. Host parsers must not mix this wrap’s STA/IOB envelope with the R7 XSim wrap, HOLD wrap, IOBFF wrap, or RTP SoC wrap as one frozen production top.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated implement+route of a **new named R7 UART wrap** instantiating frozen `a7ng_astra_09_r2_cand_ovf` at declared 50 MHz with **real routed clock-network**, WNS=+0.336 ≥ 0, WHS=+0.104 ≥ 0 (intra-clk50u; UART I/O hold excepted by FALSE_PATH_HOLD_ASYNC_UART frozen before impl), UART IOB **A9 INPUT / D10 OUTPUT FIXED**, UART IOB FFs **packed**, delays 2.000/0.500 copied not invented, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`, leftover A09 not compiled, R7 XSim bag not overwritten, prior UART WNS bags not overwritten.

`REJECT_PROMOTION` — Master **ASTRA-11** (fullchip co-fit / frozen SoC UART top / on-chip plant), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. Routed UART wrap **≠** silicon UART. UART I/O hold excepted **≠** physically MET.

Master ASTRA-09: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-09-R7-UART-QUERY-REW-01: **untouched, still PASS_NARROW XSim, not this routed result**.  
ASTRA-11-A09R3-UART-IOBFF-HOLD-01 routed WNS=+0.115 WHS=+0.131: **untouched**.  
ASTRA-11-A09R3-UART-IOBFF-01 routed WNS=+0.115 WHS=−4.915: **untouched**.  
ASTRA-11-A09R3-UART-IODELAY-01 routed WNS=+0.681: **untouched**.  
ASTRA-11-A09R3-UART-IMPL-ROUTE-01 routed WNS=+0.305: **untouched**.  
ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648: **untouched**.  
ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041: **untouched, different DUT**.  
ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733: **untouched, different top**.  
PRODUCTION_TOP: **UNKNOWN**.  
T0130 residual 5 (named R7 UART wrap impl+route, not a silent freeze): **CLOSED_NARROW this bag as evidence class**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**. UART IOB: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0200Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-11-A09R7-UART-IMPL-ROUTE-01; Master ASTRA-11/13 OPEN; raw routed WNS=+0.336 TNS=0.000 WHS=+0.104 (Design State Routed, clk50u 20.000 ns, SCD=6.427 ns E3 IBUF→MMCM→BUFG→u_a09r2/clk routed fo=3617); UART IOB YES (A9 INPUT uart_txd_in FIXED / D10 OUTPUT uart_rxd_out FIXED; IOB FF packed ILOGIC_X0Y171 IFF / OLOGIC_X0Y161 OUTFF); HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART frozen before impl (UART I/O hold excepted, not physically MET); PROGRAM=NO; BOARD still blocked YES.
