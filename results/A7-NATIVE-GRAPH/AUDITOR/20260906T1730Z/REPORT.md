# ASTRA auditor REPORT — 20260906T1730Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA11_A09R3_UART_IMPL_ROUTE_INDEPENDENT_AUDIT; astra11_a09r3=IMPLEMENTER_CLAIM_ROUTED_WNS_P0305_UART_IOB_PENDING_AUDITOR; astra09_r3=AUDITOR_PASS_NARROW_UART_8N1_XSIM; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-11 FULLCHIP-COFIT / ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-11-A09R3-UART-IMPL-ROUTE-01 + prior auditor 20260906T1700Z (UART XSim ACCEPT_PARTIAL; residual 5 = production UART path still needs a named SoC top — this bag is impl+route of a new named UART wrap, not a freeze) + auditor 20260906T1630Z (A09R2 wrap-route WNS=+0.648 PASS_NARROW; do not overwrite)
EVIDENCE   = raw timing_route.rpt / io.rpt / clocks_route.rpt / clock_util_route.rpt / util_route.rpt / util_hier_route.rpt / route_status.rpt / ram_route.rpt / drc.rpt / util_synth.rpt / timing_synth.rpt / vivado.log / vivado.jou / wrap SV / plant SV / tcl / XDC / UART_IOB.txt / SHA manifests / PREREG / ACK (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_impl.ps1` / `run_impl.tcl` (would overwrite `vivado.log` / routed reports).

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to overlapping hashes in `ASTRA-09-R2-CAND-OVF-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, and T1630/T1700 freeze strings.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R3-UART-IMPL-ROUTE-01/`

Top `a7ng_astra_11_a09r3_uart_impl_wrap` (bag-local) instance **`u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv`**. UART `u_rx` / `u_tx` from `rtl/board/uart_rx.sv` / `uart_tx.sv`. Pin clock `CLK100MHZ` E3 period 10.000 ns. Pipe clock MMCM 100→50 + BUFG, generated `clk50u` period 20.000 ns. UART pins **A9 INPUT `uart_txd_in` / D10 OUTPUT `uart_rxd_out`**. Part `xc7a100tcsg324-1`. Mode **in-context** `synth_design` (not `-mode out_of_context`) then `opt_design` / `place_design` / `route_design`. No bitstream.

Gate under review is **work-order ASTRA-11-A09R3-UART-IMPL-ROUTE-01 only** — one unknown: after implement+route of that named UART wrap instantiating frozen A09-R2 on `xc7a100tcsg324-1` at a declared 50 MHz constraint with `uart_rxd_out` D10 and `uart_txd_in` A9 constrained, is WNS ≥ 0 — **without a bitstream**, with UART IOB present in `io.rpt`. **Not** Master ASTRA-11 fullchip close. **Not** ASTRA-13 board acceptance. **Not** freeze of `PRODUCTION_TOP`.

Parent residual from auditor `20260906T1700Z`: UART 8N1 XSim CLOSED_NARROW. Residual 5: production UART path still needs a **named SoC top**. Parent does **not** freeze `PRODUCTION_TOP`. This bag is **impl+route** of a new named UART wrap, not a production freeze.

Hunt (parent / work order / this dispatch):

1. Quote WNS/TNS from **RAW** `timing_route.rpt` Design State=Routed. Claimed +0.305 @ clk50u 20 ns.
2. UART IOB: A9 INPUT / D10 OUTPUT FIXED in `io.rpt`? XDC matches?
3. Clock-network real vs virtual?
4. No `.bit`? PROGRAM=NO? `PRODUCTION_TOP=UNKNOWN`?
5. Not claiming wrap-route WNS=+5.733, A09R2 WNS=+0.648 as this result, BOARD_PASS?
6. Hash before impl including `.svh`?

Confirm: `a7ng_astra_09_r2_cand_ovf` instantiated; frozen A09 **not** compiled; prior WNS bags **not** overwritten.

Judged against:

1. Work order `.agents/handoff/ASTRA-11-A09R3-UART-IMPL-ROUTE-01.md` + PREREG: instantiate `a7ng_astra_09_r2_cand_ovf` (not copy-paste graph; not compile frozen leftover A09); XDC clk E3 + UART D10/A9; hash RTL+XDC+tcl before impl; impl+route at declared 50 MHz; quote routed Design State; IOB UART in `io.rpt`; if WNS<0 FAIL bag, keep report, one bounded experiment, still no bit; PROGRAM=NO; do not overwrite A09R2 wrap WNS=+0.648, A09 wrap WNS=+1.041, or wrap-route WNS=+5.733; do not close ASTRA-13, BOARD_PASS, LM06, Master F3; do not freeze `PRODUCTION_TOP`.
2. **Master ASTRA-11** (DAG: FULLCHIP-COFIT): whole-chip co-fit of the frozen SoC top (UART + MMCM + I/O + memory plant + production path together), not an isolated named UART wrap with a fixture plant.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.*
4. Auditor `20260906T1700Z`: ASTRA-09-R3-UART-XSIM-01 PASS_NARROW UART-real 8N1; residual = named SoC top, not this freeze. Auditor `20260906T1630Z`: A09R2 wrap PASS_NARROW WNS=+0.648; that bag must remain unoverwritten.

**Master ASTRA-11 as a whole is not this bag’s close**, even if this wrapper’s routed WNS is ≥ 0 and UART IOB is FIXED.

Out of this bag’s close: freeze of `PRODUCTION_TOP`, silicon UART / silicon MMCM / silicon BRAM, `a7ng_axi_bram128` plant, bitstream, JTAG/COM12, LM06 language, Master ASTRA-09 production path, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, ASTRA-13 BOARD_PASS, wrap-route `arty_a7_astra_rtp_soc_top` WNS=+5.733 identity, A09R2 wrap WNS=+0.648 identity, leftover A09 wrap WNS=+1.041 identity, UART XSim MAGIC A2 as this bag.

Frozen `a7ng_astra_09_r2_cand_ovf.sv` / `.svh`, leftover `a7ng_astra_09_integ_path.sv` / `.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `uart_rx.sv` / `uart_tx.sv`, F2R3/F2R4/F2R5, persist/R2/R3/R4 must remain **unpatched**. This wrap is a **new named** UART impl/route wrapper. It must **instantiate** A09-R2, not copy the graph. It must **not** compile leftover A09 / `astra09_pipe` / `axi_bram128` / RTP SoC / XSim wrap as this top.

Prior bags `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, `ASTRA-SOC-RTP-WRAP-ROUTE`, `ASTRA-09-R2-CAND-OVF-01` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`09704a3c…bbbb1bab38`). `write_scope` = new bag + distinctly named UART impl/route wrap that **instantiates** frozen `a7ng_astra_09_r2_cand_ovf` (no copy-paste graph; frozen `a7ng_astra_09_integ_path.sv` not compiled as DUT; A09-R2 DUT source not patched; prior bags not edited). `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, ASTRA-SOC-RTP-WRAP-UART-XSIM, ASTRA-09-R3-UART-XSIM-01, Master_ASTRA-10_whole_chip, production_top_identity, write_bitstream.

`run_impl.tcl` **renames** `write_bitstream` to abort (`astra_forbid_bit` → exit 1). Compile list forbids leftover A09 / `astra09_pipe` / RTP SoC / XSim wrap / `axi_bram128`. Post-synth cell checks abort if leftover A09 / pipe / BRAM cells exist, or if `u_a09r2` / `u_rx` / `u_tx` cells are missing. UART IOB extract requires A9=`uart_txd_in` and D10=`uart_rxd_out` in `io.rpt`.

Bag listing: **no** `.bit`, no `fail_r0/`, no `FIRST_DIVERGENCE.txt`, no `timing_route_exp.rpt`. Checkpoints are `ckpt/synth.dcp` and `ckpt/route.dcp` only. Grep of bag files for a generated bitstream path: none (ACK/RESULTS mention `.bit` only as **not built**).

`vivado.log` grep for `write_bitstream`, `a7ng_astra_09_integ_path`, `astra09_pipe`, `axi_bram128`, `arty_a7_astra`, `.bit`: **no matches**.

---

### 1. Raw routed WNS/TNS (authority)

`timing_route.rpt` header:

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Sun Sep  6 22:12:21 2026
Command      : report_timing_summary -file .../ASTRA-11-A09R3-UART-IMPL-ROUTE-01/timing_route.rpt
Design       : a7ng_astra_11_a09r3_uart_impl_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      0.305        0.000                      0                 8599        0.024        0.000                      0                 8599
All user specified timing constraints are met.
```

Clock Summary (same rpt):

```text
sys_clk_pin  {0.000 5.000}      10.000          100.000
  clk50u     {0.000 10.000}     20.000          50.000
  clkfb      {0.000 5.000}      10.000          100.000
```

Intra-clock table:

```text
  clk50u            0.305        0.000                      0                 7021        0.024        0.000                      0                 7021
```

clk50u group: Setup 0 failing, Worst Slack 0.305 ns, Total Violation 0.000 ns. Hold 0 failing, Worst Slack 0.024 ns.

Implementer claim **WNS=+0.305 @ clk50u 20.000 ns MATCHES raw routed timing**. TNS=0.000 WHS=0.024 THS=0.000. Failing endpoints = 0. `TIMING_EXTRACT.txt` / `metrics.json` / `vivado.log` DONE line match the raw summary. No RESULTS vs raw-rpt contradiction on WNS/TNS/WHS.

Worst setup path (same rpt): `Slack (MET) : 0.305ns`; source `u_a09r2/pv_reg[0][1]/C` → dest `u_a09r2/best_a_reg[13]/D`; **Requirement 20.000 ns**; Data Path Delay 19.328 ns (logic 6.867 / route 12.461); 23 logic levels (CARRY4=7 + LUT2/3/4/5/6); Path Group `clk50u`. Source Clock Delay **6.429 ns**, Destination Clock Delay **5.875 ns**. This is a real walker/proof path **inside instantiated A09-R2**, not a wrap-only tautology.

Worst hold path: `Slack (MET) : 0.024ns`; source `u_a09r2/best_a_reg[4]/C` → dest `tx_bytes_reg[2][4]/D` (DUT `ans` captured into UART TX frame). MET. Tight. Not a hold fail.

`check_timing`: `no_clock` 0, `unconstrained_internal_endpoints` 0, `no_input_delay` 4 (1 HIGH + 3 MEDIUM false-path), `no_output_delay` 5 HIGH. Quoted WNS is **internal register-to-register** under `clk50u`. HIGH unconstrained I/O is `uart_txd_in` (the one input without `create_clock` or `set_false_path`) plus `uart_rxd_out` + 4 LED outputs. That is a residual vs board I/O timing close, **not** a silent manufacture of the 0.305 ns internal slack.

`route_status.rpt`: logical nets 12279; fully routed 6005; **routing errors = 0**.

DRC: 9 checks, all Warning (DSP DPIP/DPOP pipeline on `u_a09r2/u_sgd` acc0). **0 Error / 0 Critical**. Unpipelined DSP is consistent with frozen F2R2 SGD.

Synth-only contrast (not the WNS quote): `TIMING_EXTRACT_SYNTH.txt` Design State **Synthesized** `WNS=2.141`. Implementer correctly quotes **routed** 0.305, not synth 2.141. `vivado.log`: `Synthesis finished with 0 errors, 0 critical warnings`; `synth_design -top a7ng_astra_11_a09r3_uart_impl_wrap -part xc7a100tcsg324-1` (no `-mode out_of_context`).

WNS ≥ 0. Bounded WNS<0 experiment **not run** (not applicable). Hunt 1: **MET.**

---

### 2. UART IOB: A9 INPUT / D10 OUTPUT FIXED? XDC matches?

Bag-local `clk50_uart_impl.xdc`:

```text
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports { CLK100MHZ }]
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]
```

Official `constraints/arty_a7_100.xdc` (cited, not edited from this bag):

```text
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]; #IO_L19N_T3_VREF_16 Sch=uart_rxd_out
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]; #IO_L14N_T2_SRCC_16 Sch=uart_txd_in
```

Raw `io.rpt` Design `a7ng_astra_11_a09r3_uart_impl_wrap`, Total User IO=15, Date 22:12:25:

```text
| A9         | uart_txd_in  | ... | INPUT  | LVCMOS33 | ... | FIXED |
| D10        | uart_rxd_out | ... | OUTPUT | LVCMOS33 | ... | FIXED |
| E3         | CLK100MHZ    | ... | INPUT  | LVCMOS33 | ... | FIXED |
```

Direction matches the hunt and Digilent names: **A9 = FPGA RX (`uart_txd_in`) INPUT FIXED**; **D10 = FPGA TX (`uart_rxd_out`) OUTPUT FIXED**. Pins are **not swapped**.

`UART_IOB.txt`: `UART_TXD_IN_A9=YES uart_txd_in` / `UART_RXD_OUT_D10=YES uart_rxd_out` / `UART_IOB=YES`.

`util_route.rpt` Bonded IOB **15 / 15 FIXED**; primitives **IBUF=10** (clk + uart_txd_in + 4 sw + 4 btn) **OBUF=5** (uart_rxd_out + 4 led). Wrap RTL: `u_rx.rx(uart_txd_in)`, `u_tx.tx(uart_rxd_out)`.

`vivado.log`: `UART_IOB A9=YES D10=YES`.

ILOGIC=0 / OLOGIC=0: UART is **pin-FIXED IBUF/OBUF**, not IOB-registered IFF/OFF. Hunt asked FIXED package pins, not IOB FFs. Residual vs a later I/O-register pack, **not** a miss of hunt 2.

Hunt 2: **MET. UART IOB = YES.**

---

### 3. Clock-network real vs virtual?

`clocks_route.rpt` Design State **Routed** 22:12:25:

```text
Clock        Period(ns)  Waveform(ns)    Attributes  Sources
sys_clk_pin  10.000      {0.000 5.000}   P           {CLK100MHZ}
clk50u       20.000      {0.000 10.000}  P,G,A       {u_mmcm/CLKOUT0}
clkfb        10.000      {0.000 5.000}   P,G,A       {u_mmcm/CLKFBOUT}
```

**No V (Virtual) attribute.** `clk50u` is Propagated + Generated + Auto-derived from `u_mmcm/CLKOUT0`, master `sys_clk_pin`.

Worst-path source clock (raw `timing_route.rpt`):

```text
E3  CLK100MHZ
E3  IBUF          CLK100MHZ_IBUF_inst/O
MMCME2_ADV_X1Y2   u_mmcm/CLKOUT0     net clk50u (fo=1, routed)
BUFGCTRL_X0Y16    u_bufg50/O
net (fo=3500, routed) u_a09r2/clk
SLICE ... FDRE    u_a09r2/pv_reg[0][1]/C
Source Clock Delay = 6.429 ns
```

`clock_util_route.rpt`: MMCM=1, BUFGCTRL=1 at **BUFGCTRL_X0Y16**, clock loads **3500**, period 20.000, driver `u_bufg50/O` net `clk`, source `MMCME2_ADV/CLKOUT0` site **MMCME2_ADV_X1Y2**. Wrap instantiates `MMCME2_BASE` (maps to `MMCME2_ADV`) + `BUFG`.

Not `create_clock -name virtual_*`. Clock-network delay is **included** in the quoted WNS. Hunt 3: **REAL.**

---

### 4. No `.bit`? PROGRAM=NO? PRODUCTION_TOP=UNKNOWN?

- Bag directory: no `.bit` / `.bin` / `.mcs`. `ckpt/` holds `synth.dcp` + `route.dcp` only.
- `vivado.log` DONE: `BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN`. Exit `Sun Sep 6 22:12:26 2026`. No `write_bitstream` command.
- TCL: `write_bitstream` renamed to abort before synth. WNS≥0 path never calls it. WNS<0 path also never calls it.
- ACK / PREREG / RESULTS / CLOSEOUT / metrics: `PRODUCTION_TOP=UNKNOWN`, `PROGRAM=NO`.
- LOOP_STATE (read-only): `program=false`, `board_pass=false`, `astra13=BLOCKED`, `production_top=UNKNOWN`, `com12=USER_SAYS_PLUGGED_UNPROGRAMMED`.

Hunt 4: **MET.** Board plugged ≠ programmed.

---

### 5. Overclaim of wrap-route +5.733 / A09R2 +0.648 / BOARD_PASS? Prior bags overwritten?

Implementer RESULTS/CLOSEOUT cite those numbers only as **not this result**. Marker is bag-local `ASTRA_11_A09R3_UART_IMPL_ROUTE_DONE WNS=0.305`. No `BOARD_PASS` vocabulary used as a pass.

Prior bags still on disk (headers opened this session):

| Bag | Raw identity still on disk |
|-----|----------------------------|
| ASTRA-11-A09R2-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 21:26:25**, Design `a7ng_astra_11_a09r2_impl_wrap`, extract **WNS=0.648**. Wrap SHA KEEP `1932ee4c…` MATCH this bag KEEP. **Not overwritten.** |
| ASTRA-11-A09-IMPL-ROUTE-01 | `timing_route.rpt` **Sun Sep 6 19:48:09**, Design `a7ng_astra_11_a09_impl_wrap`, extract **WNS=1.041**. **Not overwritten.** |
| ASTRA-SOC-RTP-WRAP-ROUTE | `timing.rpt` **Sun Sep 6 02:11:52**, Design `arty_a7_astra_rtp_soc_top`, raw **WNS(ns)=5.733**. **Not overwritten.** |
| ASTRA-09-R3-UART-XSIM-01 | `RESULTS.md` still `XSIM_MARKER = ASTRA_09_R3_UART_XSIM_PASS`. Wrap SHA `20cdeb8e…` MATCH this bag KEEP. **Not overwritten.** |

This routed WNS=+0.305 is **worse** than A09R2 wrap +0.648 (live UART+plant occupancy, QSE not constant-folded, hold path now DUT→`tx_bytes`) and is **not** recycled +5.733 / +0.648 / +1.041. Hunt 5: **MET. Not OVERCLAIM of those identities.**

---

### 6. Hash before impl including `.svh`? Instantiated not copied? Frozen A09 not compiled?

**Hash order**

- `SHA256.txt` / `SOURCE_HASHES.txt`: **BEFORE impl** `2026-09-06T22:07:20.3622740+07:00`
- Vivado start: `Sun Sep 6 22:07:21 2026` (PID 11320) — 1 s later
- Reports: `22:10:40` (synth util) … `22:12:20` (util_route) … `22:12:21` (timing_route) … `22:12:25` (io/clocks/drc) … `22:12:26` (exit)
- `SHA256_POST.txt`: **AFTER impl** `2026-09-06T22:12:27.4131682+07:00`

`run_impl.ps1` live-checks frozen leftover A09 / R2 DUT / SGD / uart_rx / uart_tx hashes, writes SHA256 of compiled + **`.svh`** + CONFIG + KEEP + provenance **then** calls Vivado. Not hash-after-scores theatre on compiled sources.

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
| bag `a7ng_astra_11_a09r3_axi_plant.sv` | `62ff1945322445a30ca5fe30d625c797343a9433f55d2fc278c6c20c06277754` |
| bag `a7ng_astra_11_a09r3_uart_impl_wrap.sv` | `1c3a95f4be584880fe32e34928f5c832cd2bae028f1f10ace864d99ee67f97ff` |
| bag `clk50_uart_impl.xdc` | `506a3e12bfd75d663fffbbc075c8504b8dced6c83f1d2b63b050fb1fd216856f` |
| bag `run_impl.tcl` | `83338d1050cc37b682310cee018e6c34da90b4e839d215d31712e2cd3fae378b` |
| `a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `a7ng_astra_09_integ_path.svh` | `ad2d66d4783bba33cfbd324fc0a9661fb2a46eeaffb5b4fb6989246fb4e94302` |
| `a7ng_astra_09_r2_cand_ovf.svh` | `feaed571ce02bec4218e2105986349a464d6c44bcf1a818260ee27a171afd329` |

`.svh` **is** in the pre-impl freeze (R2 contract + leftover A09 header + lexica + crc). Hunt 6: **MET.**

R2 DUT `15a919f1…` **MATCH** `ASTRA-09-R2-CAND-OVF-01/SHA256.txt` and T1630/T1700. Frozen leftover A09 `9fdbe0d6…` **MATCH** provenance (KEEP; **not compiled**). Frozen SGD `b66ef328…` MATCH. `uart_rx` `8e802d0b…` / `uart_tx` `b4b7d097…` MATCH `ASTRA-09-R3-UART-XSIM-01`. Prior A09R2 wrap `1932ee4c…` MATCH KEEP. Prior XSim UART wrap `20cdeb8e…` MATCH KEEP (not compiled as this top).

**Instantiate, not copy-paste; frozen A09 not compiled**

Bag contains new wrap + bag-local AXI plant only as RTL (no copied integrator `.sv` in the bag). Wrap:

```text
(* keep_hierarchy = "yes" *)
uart_rx ... u_rx ( .rx(uart_txd_in), ... );
uart_tx ... u_tx ( .tx(uart_rxd_out), ... );
(* keep_hierarchy = "yes" *)
a7ng_astra_09_r2_cand_ovf u_a09r2 ( ... );
(* keep_hierarchy = "yes" *)
a7ng_astra_11_a09r3_axi_plant u_plant ( ... );
load_v_i tied 0.
```

No QSE/sparse/2-hop/SGD duplicated in the wrap. Frozen leftover A09 **not instantiated**. Plant header: *Bag-local behavioral AXI plant. Not silicon BRAM. Not a7ng_axi_bram128.*

Raw log elaboration (not RESULTS):

```text
synthesizing module 'a7ng_astra_11_a09r3_uart_impl_wrap' [.../ASTRA-11-A09R3-UART-IMPL-ROUTE-01/a7ng_astra_11_a09r3_uart_impl_wrap.sv:8]
synthesizing module 'MMCME2_BASE'
synthesizing module 'BUFG'
synthesizing module 'uart_rx' [.../rtl/board/uart_rx.sv:2]
synthesizing module 'uart_tx' [.../rtl/board/uart_tx.sv:2]
synthesizing module 'a7ng_astra_09_r2_cand_ovf' [.../rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv:9]
synthesizing module 'a7ng_query_axi_sparse'
  N_BUCKETS = 4096
  CAND_CAP  = 16
  LAW_SEL   = 1
synthesizing module 'a7ng_query_role_extract'
synthesizing module 'a7ng_sparse_dir_axi'
synthesizing module 'a7ng_shared_rank_sgd_q8_sym_f2r2'
synthesizing module 'a7ng_astra_11_a09r3_axi_plant' [.../a7ng_astra_11_a09r3_axi_plant.sv:6]
U_A09R2_CELLS=11064
U_RX_CELLS=76
U_TX_CELLS=56
```

**Not synthesized:** `a7ng_astra_09_integ_path` (zero synthesizing-module lines; zero log matches), `a7ng_astra09_pipe`, `arty_a7_astra_rtp_soc_top`, `a7ng_axi_bram128`, `a7ng_astra_09_r3_uart_wrap`. **Required instantiate-not-copy and frozen-A09-not-compiled: MET.**

PREREG contains **no** WNS numbers (policy before impl). WNS appears only in RESULTS/CLOSEOUT/metrics after the run.

---

## Resources (raw; not the WNS quote)

Quoted **synth** `util_synth.rpt` Design State Synthesized 22:10:40:

```text
| Slice LUTs*             | 5682 |     0 |          0 |     63400 |  8.96 |
| Slice Registers         | 5008 |     0 |          0 |    126800 |  3.95 |
| Block RAM Tile          |    0 |
| DSPs                    |    2 |
```

Quoted **routed** `util_route.rpt` Design State Routed 22:12:20:

```text
| Slice LUTs              | 4804 |     0 |          0 |     63400 |  7.58 |
| Slice Registers         | 3500 |     0 |          0 |    126800 |  2.76 |
| Block RAM Tile          |    0 |
| DSPs                    |    2 | ...  DSP48E1 only
| Bonded IOB              |   15 |    15 |          0 |       210 |  7.14 |
| BUFGCTRL                |    1 |
| MMCME2_ADV              |    1 |
```

Hierarchical routed (`util_hier_route.rpt`):

```text
| a7ng_astra_11_a09r3_uart_impl_wrap | (top)                     | 4804 | 3500 | 0 | 2 |
|   u_a09r2                          | a7ng_astra_09_r2_cand_ovf | 4294 | 2692 | 0 | 2 |
|     u_sgd                          | a7ng_shared_rank_sgd...   |  529 |  610 | 0 | 2 |
|     u_sp                           | a7ng_query_axi_sparse     | 3336 |  696 | 0 | 0 |
|       u_walk                       | a7ng_sparse_dir_axi       | 1009 |  450 |
|       g_law.u_qse                  | a7ng_query_role_extract   | 2327 |  202 |
|   u_plant                          | a7ng_astra_11_a09r3_axi_plant | 171 | 73 | 0 | 0 |
```

Honest occupancy of a **live UART wrap**: QSE LUT=2327 is **not** the I/O-folded QSE=39 of A09R2 wrap (that wrap hung AXI `rvalid=0` and fed 4-bit switches). Plant is behavioral (LUT=171, BRAM=0), **not** wrap-route BRAM=2. SGD DSP×2 remains. Worst setup path still inside `u_a09r2`. **Not a stub DUT.** Also **not** whole-chip `axi_bram128` / DDR occupancy. Do not add 4804 to A09R2 wrap 1321, leftover A09 wrap 1305, or wrap-route 4244 as a chip sum.

Comparison (not identity):

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 4804 | 3500 | 0 | 2 | **Routed clk50u +0.305 UART IOB YES** |
| This bag synth | 5682 | 5008 | 0 | 2 | Synthesized (not the WNS quote; extract +2.141) |
| ASTRA-11-A09R2-IMPL-ROUTE-01 routed | 1321 | 1103 | 0 | 2 | Routed no-UART **+0.648** — not overwritten |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed different DUT **+1.041** — not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |

---

## Overclaim / cheat / tautology

| Hunt | Finding |
|------|---------|
| RESULTS vs raw rpt mismatch on WNS/TNS/WHS | **None.** +0.305 / 0.000 / 0.024 Design State Routed |
| UART IOB missing / swapped | **Not found.** A9 INPUT `uart_txd_in` FIXED; D10 OUTPUT `uart_rxd_out` FIXED; XDC = Digilent master |
| Wrap-route WNS=+5.733 claimed or overwritten | **Not claimed. Not overwritten** (02:11:52 still 5.733) |
| A09R2 wrap WNS=+0.648 claimed or overwritten | **Not claimed. Not overwritten** (21:26:25 still 0.648) |
| A09 wrap WNS=+1.041 overwritten | **Not overwritten** (19:48:09 still 1.041) |
| BOARD_PASS / silicon UART | **Not claimed.** BIT=NOT_BUILT; PROGRAM=NO |
| Virtual clock / no SCD | **Not found.** P,G,A `clk50u`; E3 IBUF→MMCM→BUFG→`u_a09r2/clk` fo=3500 routed; SCD=6.429 ns |
| Copy-paste graph called instantiate | **Not found.** Thin UART FIFO wrap + live RTL path in synth log |
| Frozen leftover A09 compiled as DUT | **Not found.** Zero synth/log matches; tcl forbids; KEEP hash only |
| Stub / empty DUT | **Not found.** Hier `u_a09r2` LUT=4294; QSE=2327; SGD DSP48E1×2; U_A09R2_CELLS=11064; worst path inside DUT |
| Bitstream / PROGRAM | **No bit in this bag.** ACK/RESULTS PROGRAM=NO |
| `PRODUCTION_TOP` frozen | **UNKNOWN** in ACK / log DONE / RESULTS / CLOSEOUT / LOOP_STATE |
| Hash freeze after looking at WNS / `.svh` omitted | **Not found.** PRE 22:07:20 < Vivado 22:07:21; 5 `.svh` in PRE; POST 19/19 MATCH |
| UART XSim MAGIC A2 claimed as this bag | **Not claimed.** ASTRA-09-R3-UART-XSIM-01 still its own PASS_NARROW |
| Fail r0 wipe | **N/A.** Single successful session; WNS≥0; no fail_r0 artifact to wipe |
| LUT used as whole-chip occupancy | **Not claimed.** Documented fixture plant / BRAM=0 vs wrap-route BRAM=2 |

qstack adversary: worst setup path is a real placed/routed A09-R2 walker (`pv_reg` → `best_a_reg`, 23 logic levels) under a **propagated generated** 20 ns clock with SCD=6.429 ns and 3500 routed clock loads. `set_false_path` on sw/btn and unconstrained UART/LED I/O **do not** create that 0.305 ns slack. UART IOB FIXED on A9/D10 is independent of the internal WNS number. `keep_hierarchy` preserves `u_a09r2` / `u_rx` / `u_tx` identity. QSE remaining large (2327) is consistent with a live UART token path + responding AXI plant — the opposite of the A09R2 wrap I/O-fold. WNS=+0.305 is **worse** than A09R2 wrap +0.648 and is **not** a recycled +5.733.

---

## Logic bugs

No route FAIL. No critical warnings. No RESULTS/raw contradiction on the quoted WNS/TNS/WHS. Route complete (0 failed nets). UART IOB FIXED as required. WNS ≥ 0 so the handoff WNS<0 bounded experiment was correctly **not** run.

Residuals (not this-bag FAIL):

1. `check_timing` HIGH: UART RX has **no `set_input_delay`**; UART TX + LEDs have **no `set_output_delay`**. IOB FIXED ≠ I/O timing closed. Quoted WNS remains internal R2R. 115200 UART bit-period is ~8.68 µs; this is still a gap vs production I/O timing, not a manufactured WNS.
2. ILOGIC=0 / OLOGIC=0: UART is IBUF/OBUF at A9/D10, **not** IOB-registered. Hunt 2 asked FIXED pins (met). IOB FF pack is a later residual if parent wants it.
3. WHS=+0.024 ns is DUT `ans` → wrap `tx_bytes`. MET, tight. Not a fail. Do not “fix” frozen A09-R2 from this bag.
4. DRC DSP unpipelined (DPIP/DPOP) — expected; frozen F2R2 SGD. Do not patch from this bag.
5. Bag-local `a7ng_astra_11_a09r3_axi_plant` is a **behavioral fixture** (BRAM=0). Master ASTRA-11 fullchip plant (`a7ng_axi_bram128` / DDR) remains open.
6. Occupancy LUT=4804 / QSE=2327 is **this UART wrap**, not additive with A09R2 wrap 1321, leftover A09 wrap 1305, or wrap-route 4244 BRAM=2.
7. No independent `Get-FileHash` this process. Overlapping R2/SGD/A09/uart/pkg hashes MATCH prior bags. Wrap/XDC/tcl/plant digests are first-recorded here.
8. Functional MAGIC A2 / OVF INCOMP on the byte stream remains **XSim** (T1700). This bag does not re-prove UART protocol on silicon or in XSim.
9. `ck_rst` C2 unused; reset is MMCM `locked` + `btn[0]` POR. Not required by this work order (clk E3 + UART D10/A9). Residual vs a later pinmap freeze, not a miss of hunt 2.
10. Named wrap is a **candidate** UART SoC path, not a silent `PRODUCTION_TOP` freeze. T1700 residual 5 is **physically evidenced** (routed named UART wrap, IOB YES, WNS≥0) and **not closed as production identity**.

No DUT logic patch requested. Auditor does not fix.

---

## This bag vs Master ASTRA-11 / ASTRA-13

Work-order unknown **answered**: for wrapper `a7ng_astra_11_a09r3_uart_impl_wrap` / instance `u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf` on `xc7a100tcsg324-1`, post-route (Design State **Routed**) is **WNS=+0.305 ns TNS=0.000 ns WHS=+0.024 ns @ clk50u 20.000 ns (50 MHz)** with **real** E3 IBUF → MMCME2_ADV_X1Y2 → BUFGCTRL_X0Y16 → `u_a09r2/clk` (SCD=6.429 ns, fo=3500 routed), UART IOB **A9 INPUT / D10 OUTPUT FIXED**, **BIT=NOT_BUILT**, **PROGRAM=NO**, **PRODUCTION_TOP=UNKNOWN**. Frozen leftover A09 **not compiled**. ASTRA-11-A09R2-IMPL-ROUTE-01 WNS=+0.648 **not overwritten**. Wrap-route WNS=+5.733 **not overwritten**.

T1700 residual 5 (**production UART path still needs a named SoC top**) is **closed as evidence class** for *impl+route of this named UART wrap with D10/A9 IOB and WNS≥0*. It is **not** permission to mark Master ASTRA-11 or ASTRA-13 done, and **not** permission to freeze `PRODUCTION_TOP`.

| Master item | This bag |
|---|---|
| ASTRA-11 FULLCHIP-COFIT (UART + MMCM + I/O + AXI BRAM/DDR plant + production path as one frozen top) | Named UART wrap + MMCM/BUFG + D10/A9 IOB + fixture AXI plant. No `axi_bram128`. No DDR. `PRODUCTION_TOP=UNKNOWN` |
| ASTRA-11-A09R2-IMPL-ROUTE-01 WNS=+0.648 | Different wrap, no UART; bag not overwritten; this WNS=+0.305 is **not** that number |
| ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041 | Different DUT `a7ng_astra_09_integ_path`; bag not overwritten |
| ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733 | Different top `arty_a7_astra_rtp_soc_top`; bag not overwritten |
| ASTRA-11-SOC-WRAP historical routed WNS=-4.765 | Different top; not this result |
| ASTRA-13 FINAL-BOARD-ACCEPTANCE | BIT=NOT_BUILT; PROGRAM=NO; no JTAG/COM12; `PRODUCTION_TOP=UNKNOWN` |
| LM06 language | Not opened |
| ASTRA-09-R3-UART-XSIM-01 MAGIC A2 | Prior XSim bag; not this impl/route result |

**No Master-gate overclaim found.**

Master **ASTRA-11 FULLCHIP-COFIT** remains **OPEN** (fixture plant, not frozen SoC top, not wrap-route identity).

Master **ASTRA-13 FINAL-BOARD-ACCEPTANCE** remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority.

Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-10 whole-chip remain **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-11-A09R3-UART-IMPL-ROUTE-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw routed reports: instantiate-not-copy of `a7ng_astra_09_r2_cand_ovf`, frozen leftover A09 not compiled, hash-before-impl including `.svh`, real clock-network (not virtual), WNS=+0.305 ≥ 0, TNS=0, UART IOB A9 INPUT / D10 OUTPUT FIXED matching XDC and Digilent master, PROGRAM=NO, no bitstream, `PRODUCTION_TOP=UNKNOWN`, prior A09R2 wrap / leftover A09 wrap / wrap-route / UART XSim bags not overwritten, no BOARD_PASS / ASTRA-13 / LM06 overclaim, no theft of wrap-route +5.733 or A09R2 +0.648.

Not PASS (Master ASTRA-11 fullchip, ASTRA-13 board, silicon UART, `axi_bram128` plant, UART I/O delay closure, `PRODUCTION_TOP` freeze).  
Not FAIL (raw WNS matches claim; UART IOB FIXED as required; route 0 error / 0 critical; frozen R2/SGD/leftover A09/uart/F2R/persist unpatched; leftover A09 not compiled; clock path real; prior WNS bags intact).  
Not OVERCLAIM (ACK/RESULTS keep Master 11/13/BOARD/LM06/`PRODUCTION_TOP` open; do not steal A09R2 wrap +0.648, leftover A09 wrap +1.041, wrap-route +5.733, or UART XSim MAGIC A2).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared routed-WNS-at-50 MHz-with-UART-IOB-D10/A9 claim.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this WNS=+0.305 / UART_IOB=YES to BOARD_PASS, ASTRA-13, A09R2 wrap WNS=+0.648, wrap-route WNS=+5.733, leftover A09 wrap WNS=+1.041, UART XSim MAGIC A2, or `PRODUCTION_TOP=a7ng_astra_11_a09r3_uart_impl_wrap`.
2. Do **not** add this LUT/FF to A09R2 wrap 1321/1103, leftover A09 wrap 1305/1075, or wrap-route 4244/3810 BRAM=2. Fixture plant BRAM=0 is honest, not a contradiction of wrap-route BRAM=2. Whole-chip co-fit needs **one** current-source SoC top (Master ASTRA-11) plus an explicit `PRODUCTION_TOP` decision.
3. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
4. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv` (leftover `ans=4` hole remains in that file) and do **not** patch frozen R2 DUT / uart_rx / uart_tx from DRC DSP warnings or WHS=+0.024.
5. UART I/O remains unconstrained (no input/output delay; no IOB FF). If parent wants production I/O timing, that is a **new** named bag — not a P1 on this one.
6. Functional UART 8N1 / MAGIC A2 remains T1700 XSim. This bag is physical route + IOB, not silicon UART.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated implement+route of a **new named UART wrap** instantiating frozen `a7ng_astra_09_r2_cand_ovf` at declared 50 MHz with **real routed clock-network**, WNS=+0.305 ≥ 0, UART IOB **A9 INPUT / D10 OUTPUT FIXED**, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`, leftover A09 not compiled, prior WNS bags not overwritten.

`REJECT_PROMOTION` — Master **ASTRA-11** (fullchip co-fit / frozen SoC UART top / on-chip plant), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. Routed UART wrap **≠** silicon UART.

Master ASTRA-09: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648: **untouched**.  
ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041: **untouched, different DUT**.  
ASTRA-SOC-RTP-WRAP-ROUTE WNS=+5.733: **untouched, different top**.  
ASTRA-09-R3-UART-XSIM-01: **untouched, still not BOARD**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1730Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-11-A09R3-UART-IMPL-ROUTE-01; Master ASTRA-11/13 OPEN; raw routed WNS=+0.305 TNS=0.000 WHS=+0.024 (Design State Routed, clk50u 20.000 ns, SCD=6.429 ns E3 IBUF→MMCM→BUFG→u_a09r2/clk routed fo=3500); UART IOB YES (A9 INPUT uart_txd_in FIXED / D10 OUTPUT uart_rxd_out FIXED); PROGRAM=NO; BOARD still blocked YES.
