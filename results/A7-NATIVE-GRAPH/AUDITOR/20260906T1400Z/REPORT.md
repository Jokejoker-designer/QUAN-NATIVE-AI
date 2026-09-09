# ASTRA auditor REPORT — 20260906T1400Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA11_A09_IMPL_ROUTE_INDEPENDENT_AUDIT; astra11_a09=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; astra10=AUDITOR_PASS_NARROW_OOC_SYNTH; residual1_ooc_wns_not_implemented=THIS_BAG; master_astra11=OPEN; master_astra13=OPEN; master_astra09=OPEN; master_f3=OPEN; program=false; board_pass=false
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-11 FULLCHIP-COFIT / ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-11-A09-IMPL-ROUTE-01 + prior auditor 20260906T1330Z (A10 OOC ACCEPT_PARTIAL; residual 1 = implemented/routed clock-network, not OOC, not BOARD, not bitstream)
EVIDENCE   = raw timing_route.rpt / util_route.rpt / util_hier_route.rpt / clocks_route.rpt / clock_util_route.rpt / route_status.rpt / ram_route.rpt / io.rpt / drc.rpt / util_synth.rpt / timing_synth.rpt / vivado.log / vivado_fail_r0.log / vivado.jou / wrap SV / tcl / XDC / SHA manifests / PREREG (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not rerun `run_impl.ps1` / `run_impl.tcl` (would overwrite `vivado.log` / routed reports).

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to ASTRA-10 / ASTRA-09 overlapping hashes.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-11-A09-IMPL-ROUTE-01/`

Top `a7ng_astra_11_a09_impl_wrap` (bag-local) instance **`u_a09` = frozen `rtl/native_graph/integrate/a7ng_astra_09_integ_path.sv`**. Pin clock `CLK100MHZ` E3 period 10.000 ns. Pipe clock MMCM 100→50 + BUFG, generated `clk50u` period 20.000 ns. Part `xc7a100tcsg324-1`. Mode **in-context** `synth_design` (not `-mode out_of_context`) then `opt_design` / `place_design` / `route_design`. No bitstream.

Gate under review is **work-order ASTRA-11-A09-IMPL-ROUTE-01 only** — one unknown: after implement+route of that instantiated A09 path at a declared 50 MHz constraint **with clock-network delay included**, is WNS ≥ 0 — without a bitstream. **Not** Master ASTRA-11 fullchip close. **Not** ASTRA-13 board acceptance.

Parent residual from auditor `20260906T1330Z`: ASTRA-10 OOC synth WNS=+2.283 (Design State Synthesized, unplaced/`unset` clk net, HD.CLK_SRC unset) is **not** implemented timing. Next physical evidence must be **implemented/routed** (clock-network), not OOC, not BOARD, not bitstream.

Hunt (parent / work order / this dispatch):

1. Quote WNS/TNS/WHS from **RAW** `timing_route.rpt` Design State=Routed. Implementer claimed WNS=+1.041 @ clk50u 20 ns.
2. Clock path: E3 IBUF → MMCM → BUFG → `u_a09/clk` with SCD — real network or virtual?
3. No `.bit` generated? PROGRAM=NO?
4. Not claiming wrap-route WNS=+5.733 or BOARD_PASS?
5. Hash before impl? Fail r0 preserved?
6. Overclaim ASTRA-13 / SoC UART / LM06?

Judged against:

1. Work order `.agents/handoff/ASTRA-11-A09-IMPL-ROUTE-01.md` + PREREG: instantiate frozen A09 DUT (not copy-paste graph); hash RTL+XDC+tcl before impl; impl+route at declared 50 MHz with clock-network; quote routed Design State; if WNS<0 FAIL bag, keep report, one bounded experiment, still no bit; PROGRAM=NO; do not overwrite wrap-route WNS=+5.733; do not close ASTRA-13, BOARD_PASS, SoC UART wrap, LM06, Master F3.
2. **Master ASTRA-11** (DAG: FULLCHIP-COFIT): whole-chip co-fit of the frozen SoC top (UART + MMCM + I/O + memory plant + production path together), not an isolated A09 I/O-fold wrap.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md` §7: *ASTRA-13 BLOCKED. PROGRAM=NO.*
4. Auditor `20260906T1330Z`: ASTRA-10 PASS_NARROW OOC; residual 1 = implemented/routed WNS; BOARD still blocked.

**Master ASTRA-11 as a whole is not this bag’s close**, even if this wrapper’s routed WNS is ≥ 0.

Out of this bag’s close: UART SoC wrap, `a7ng_astra09_pipe`, `a7ng_axi_bram128` plant, ASTRA-11-SOC-WRAP WNS=-4.765 close or overwrite, wrap-route `arty_a7_astra_rtp_soc_top` WNS=+5.733 identity, bitstream, JTAG/COM12, LM06 language, Master ASTRA-09 production path, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, ASTRA-13 BOARD_PASS.

Frozen `a7ng_astra_09_integ_path.sv` / `.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, F2R3/F2R4/F2R5, persist/R2/R3/R4 must remain **unpatched**. This wrap is a **new named** impl/route wrapper. It must **instantiate** A09, not copy the graph. It must **not** compile `astra09_pipe` / `axi_bram128` / UART.

Prior bags `ASTRA-10-RESOURCE-BOUND-01`, `ASTRA-09-INTEGRATED-PATH-01`, `ASTRA-SOC-RTP-WRAP-ROUTE`, `ASTRA-11-SOC-WRAP`, `ASTRA-11-TIMING-FIX` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### 1. Raw routed WNS/TNS/WHS (authority)

`timing_route.rpt` header:

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Sun Sep  6 19:48:09 2026
Command      : report_timing_summary -file .../ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt
Design       : a7ng_astra_11_a09_impl_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      1.041        0.000                      0                 3004        0.160        0.000                      0                 3004
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
  clk50u            1.041        0.000                      0                 2063        0.160        0.000                      0                 2063
```

Implementer claim **WNS=+1.041 @ clk50u 20.000 ns MATCHES raw routed timing**. TNS=0.000 WHS=0.160 THS=0.000. Failing endpoints = 0. `TIMING_EXTRACT.txt` / `metrics.json` match the raw summary. No RESULTS vs raw-rpt contradiction on WNS/TNS/WHS.

Worst setup path (same rpt): `Slack (MET) : 1.041ns`; source `u_a09/FSM_sequential_st_reg[3]/C` → dest `u_a09/u_sgd/w_reg[14][15]/D`; **Requirement 20.000 ns**; Data Path Delay 18.768 ns (logic 10.268 / route 8.500); 20 logic levels including **DSP48E1** `u_a09/u_sgd/prod_ud`; Path Group `clk50u`. This is a real SGD update path inside frozen A09, not a wrap-only tautology.

Worst hold path: `Slack (MET) : 0.160ns`; `btn0_q_reg[0]/C` → `btn0_q_reg[1]/D` (wrap ASYNC_REG synchronizer). MET. Not a DUT hold fail.

`check_timing`: `no_clock` 0, `unconstrained_internal_endpoints` 0, `no_input_delay` 8 MEDIUM (sw/btn have `set_false_path`), `no_output_delay` 4 HIGH (LED ports). Quoted WNS is **internal register-to-register** under `clk50u`. LED I/O unconstrained is a residual vs board I/O timing close, **not** a silent manufacture of the 1.041 ns internal slack.

`route_status.rpt`: logical nets 3334; fully routed 2159; **routing errors = 0**.

DRC: 9 checks, all Warning (DSP DPIP/DPOP pipeline on `u_sgd` acc0/prod_ud). **0 Error / 0 Critical**. Unpipelined DSP is consistent with the combinational DSP48E1 on the worst setup path.

### 2. Clock path: real routed network, not virtual

`clocks_route.rpt` Design State **Routed** 19:48:12:

```text
Clock        Period(ns)  Waveform(ns)    Attributes  Sources
sys_clk_pin  10.000      {0.000 5.000}   P           {CLK100MHZ}
clk50u       20.000      {0.000 10.000}  P,G,A       {u_mmcm/CLKOUT0}
clkfb        10.000      {0.000 5.000}   P,G,A       {u_mmcm/CLKFBOUT}

Generated Clock     : clk50u
Master Source       : u_mmcm/CLKIN1
Master Clock        : sys_clk_pin
Generated Sources   : {u_mmcm/CLKOUT0}
```

Attributes **P,G,A** = Propagated, Generated, Auto-derived. **No `V` (Virtual).** Hunt item 2 answer: **real clock network**.

Worst-setup clock tree (raw `timing_route.rpt`, source launch):

```text
    E3                                                0.000     0.000 r  CLK100MHZ
    E3                   IBUF (Prop_ibuf_I_O)         1.482     1.482 r  CLK100MHZ_IBUF_inst/O
                         net (fo=1, routed)           1.233     2.715    CLK100MHZ_IBUF
    MMCME2_ADV_X1Y2      MMCME2_ADV (Prop_mmcme2_adv_CLKIN1_CLKOUT0)
                                                      0.088     2.803 r  u_mmcm/CLKOUT0
                         net (fo=1, routed)           1.719     4.522    clk50u
    BUFGCTRL_X0Y16       BUFG (Prop_bufg_I_O)         0.096     4.618 r  u_bufg50/O
                         net (fo=1075, routed)        1.645     6.264    u_a09/clk
    SLICE_X11Y89         FDCE                                         r  u_a09/FSM_sequential_st_reg[3]/C
Source Clock Delay      (SCD):    6.264ns
Destination Clock Delay (DCD):    5.969ns
```

Capture side ends `net (fo=1075, routed) u_a09/u_sgd/clk` at `BUFGCTRL_X0Y16`. Nets marked **`routed`**, sites placed. Contrast ASTRA-10 OOC: `net (fo=4154, unset)` + `<hidden>` + Timing 38-242 HD.CLK_SRC unset. **This bag answers residual 1 of T1330Z.**

`clock_util_route.rpt`: MMCM=1 at `MMCME2_ADV_X1Y2`; BUFGCTRL=1 at `BUFGCTRL_X0Y16`; global g0 driver `u_bufg50/O` net `clk`; **1075 clock loads**; period 20.000; clock name `clk50u`.

`io.rpt`: pin **E3** = `CLK100MHZ`, High Range, `IO_L12P_T1_MRCC_35`, bank 35, LVCMOS33, FIXED. Matches `clk50_impl.xdc` and Arty A7-100T oscillator site. Wrap RTL: `MMCME2_BASE` CLKIN1_PERIOD=10.0, CLKFBOUT_MULT_F=10.0, CLKOUT0_DIVIDE_F=20.0 → 50 MHz. Vivado maps `MMCME2_BASE => MMCME2_ADV` (log Unisim Transformation). Inferred **IBUF** into MMCM CLKIN (7-series normal); **not** a virtual `create_clock` on an internal net without a pin.

XDC also `create_clock -add -name sys_clk_pin -period 10.000` on port `CLK100MHZ`. Declared 50 MHz is the **generated** `clk50u`, not a lie that E3 is a 50 MHz oscillator. PREREG states this. Honest.

This WNS **must not** be called ASTRA-10 OOC WNS=+2.283, wrap-route WNS=+5.733, ASTRA-11-SOC-WRAP WNS=-4.765, or BOARD_PASS.

### 3. No bitstream? PROGRAM=NO?

Bag listing: `ckpt/synth.dcp`, `ckpt/route.dcp`. **No `.bit`.** `write_checkpoint` after synth and after route is allowed. TCL `astra_forbid_bit` / never invokes `write_bitstream`; exits 0 after route reports.

`vivado.jou` (R1, 19:44:24, PID 36036): sources `run_impl.tcl` only. **No** `write_bitstream`, `open_hw_manager`, `program_hw`, `hw_server`, `xsdb`.

`vivado.log` (R1 copy) markers:

```text
MODE=in_context_impl_route
PROGRAM=NO
BIT=NOT_BUILT
Command: synth_design -top a7ng_astra_11_a09_impl_wrap -part xc7a100tcsg324-1
  (NOT -mode out_of_context)
ASTRA_11_A09_IMPL_ROUTE_ROUTE_DONE WNS=1.041 TNS=0.000 WHS=0.160 THS=0.000 PROGRAM=NO BIT=NOT_BUILT
ASTRA_11_A09_IMPL_ROUTE_DONE WNS=1.041 TNS=0.000 WHS=0.160 BIT=NOT_BUILT PROGRAM=NO
Exiting Vivado at Sun Sep  6 19:48:12 2026
```

ACK `PROGRAM: false`, `write_bitstream: false`, `bitstream: NOT_BUILT`. **PROGRAM=NO holds for this bag.**

ASTRA-11-SOC-WRAP still contains historical `arty_a7_astra09_soc_top.bit` (UNPROGRAMMED; timing.rpt date **Sat Sep 5 22:59:22**). ASTRA-SOC-RTP-WRAP-ROUTE still contains historical `arty_a7_astra_rtp_soc_top.bit` (timing.rpt date **Sun Sep 6 02:11:52**). Those files were **not produced by this 19:40–19:48 session** and were **not overwritten** (see hunt 4). This bag did not program either bit.

### 4. Not claiming wrap-route WNS=+5.733 or BOARD_PASS? Prior bags not overwritten?

Implementer RESULTS/CLOSEOUT/ACK/PREREG:

- `RESULT = PASS_NARROW (this bag only: routed WNS at declared 50 MHz with clock-network)`
- Explicit: do **not** call this BOARD_PASS, wrap-route WNS=+5.733, or OOC WNS=+2.283
- `does_not_close`: Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-13 / ASTRA-11 SoC UART wrap / Master ASTRA-10 whole-chip

Wrap-route raw `ASTRA-SOC-RTP-WRAP-ROUTE/timing.rpt` still **Sun Sep 6 02:11:52**, Design `arty_a7_astra_rtp_soc_top`, Design State Routed:

```text
WNS(ns)=5.733  TNS=0.000  WHS=0.029
```

`util.rpt` date still **02:11:51**. **Not overwritten** by this 19:48 session.

ASTRA-11-SOC-WRAP `timing.rpt` still **Sat Sep 5 22:59:22**, Design `arty_a7_astra09_soc_top`, extract WNS=**-4.765**. **Not overwritten.**

ASTRA-11-TIMING-FIX `timing.rpt` still **Sun Sep 6 01:09:37**, Design `arty_a7_astra09_soc_top`. **Not overwritten.**

ASTRA-10-RESOURCE-BOUND-01 reports remain the 19:18 OOC session (T1330Z). This bag did not rerun A10 scripts.

**No BOARD_PASS claim found. No wrap-route WNS identity theft. ASTRA-11-SOC-WRAP route bag not overwritten.**

### 5. Hash before impl? Fail r0 preserved? Instantiated not copied? Frozen files unpatched?

**Hash order**

- `SHA256.txt` / `SOURCE_HASHES.txt`: **BEFORE impl** `2026-09-06T19:40:34.4407779+07:00`
- R0 Vivado start: `19:40:35` (PID 47828) — 1 s later
- R1 reports: `19:47:01–19:48:12`
- `SHA256_POST.txt`: **AFTER impl** `2026-09-06T19:51:48.0528691+07:00`

`run_impl.ps1` writes SHA256 of compiled + `.svh` + CONFIG + provenance **then** calls Vivado. Not hash-after-scores theatre on compiled sources.

PRE vs POST compiled + transitive includes: **15/15 identical strings** (opened manifests; not re-hashed):

| Path | SHA256 |
|------|--------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6` |
| `.../a7ng_query_struct_extract.sv` | `ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768` |
| `.../a7ng_query_role_extract.sv` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` |
| `.../a7ng_route_valid_gate.sv` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` |
| `.../a7ng_sparse_dir_axi.sv` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` |
| `.../a7ng_query_axi_sparse.sv` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` |
| `.../a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac` |
| `.../a7ng_astra_09_integ_path.sv` | `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` |
| bag `a7ng_astra_11_a09_impl_wrap.sv` | `399aa22a358af5a9593b581a0ac65666ff57a63c848c76eade6f3ce4bb2a5f42` |
| bag `clk50_impl.xdc` | `9daf143e240660b98cd0d7092cd23710cb46e26614f799127255089e0cb195f8` |
| bag `run_impl.tcl` | `8034db83b57fab4c192d22125b81a97f28e396c6a8ea660044c23e65c7aaa5f6` |
| `a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `a7ng_astra_09_integ_path.svh` | `ad2d66d4783bba33cfbd324fc0a9661fb2a46eeaffb5b4fb6989246fb4e94302` |

Those eight RTL + four `.svh` strings **MATCH** ASTRA-10-RESOURCE-BOUND-01 `SHA256.txt` and ASTRA-09 freeze. Frozen A09 DUT / F2R2 SGD **not patched** between A10 OOC and this impl.

Provenance (hashed, **not compiled**); MATCH A10 + T1330Z: persist/R2/R3/R4 and F2R3/F2R4/F2R5 SHAs unchanged (`52ebde52…` / `c671f98b…` / `99ee5d93…` / `4bd94762…` / `9a7a5941…` / `5cdb3da8…` / `41c77e76…`).

TCL compile list is the A09 set + wrap; `foreach` aborts on `a7ng_astra09_pipe.sv` / UART / `axi_bram128`. Those two keep-files are hashed under KEEP_NOT_THIS_WRAPPER and **not** in `read_verilog`.

**Fail r0**

`vivado_fail_r0.log` **exists** and is a **complete successful** impl+route, not a timing crash:

```text
Start of session at: Sun Sep  6 19:40:35 2026
Process ID         : 47828
Synth Design complete | Checksum: 81d4081f
U_A09_CELLS=10894
ASTRA_11_A09_IMPL_ROUTE_ROUTE_DONE WNS=1.041 TNS=0.000 WHS=0.160 THS=0.000 PROGRAM=NO BIT=NOT_BUILT
ASTRA_11_A09_IMPL_ROUTE_DONE WNS=1.041 TNS=0.000 WHS=0.160 BIT=NOT_BUILT PROGRAM=NO
Exiting Vivado at Sun Sep  6 19:44:22 2026
```

R1 `vivado.log` (copy of `vivado_r1.log`):

```text
Start of session at: Sun Sep  6 19:44:24 2026
Process ID         : 36036
Synth Design complete | Checksum: 81d4081f   ← same as R0
U_A09_CELLS=10894
ASTRA_11_A09_IMPL_ROUTE_DONE WNS=1.041 ... BIT=NOT_BUILT PROGRAM=NO
Exiting Vivado at Sun Sep  6 19:48:12 2026
```

R0 was **not** a Vivado FAIL and **not** WNS<0. RESULTS: PS1 treated the first invocation as FAIL (same class as ASTRA-10 `cmd` / `$exit` runner smell) and launched R1. Current `run_impl.ps1` already returns `[int]$LASTEXITCODE`; RESULTS says CONFIG hash in SHA256.txt is the **pre-run** file (not edited after). Kept reports timestamp 19:48:09 are **R1**. R0 log is preserved. Same synth checksum `81d4081f` and same quoted WNS=1.041 ⇒ same netlist/timing class. Process smell, **not** golden-edit of WNS. Handoff “if WNS<0: keep the report; one bounded experiment” was **not applicable** (WNS≥0); the extra rerun is runner hygiene, not a bounded clock experiment.

**Instantiate, not copy-paste**

Bag contains `a7ng_astra_11_a09_impl_wrap.sv` only as RTL (no copied `a7ng_astra_09_integ_path.sv` in the bag). Wrap:

```text
(* keep_hierarchy = "yes" *)
a7ng_astra_09_integ_path u_a09 ( ... );
assign w0 = w[0];
```

AXI hanging by construction: `m_axi_arready(1'b1)`, `m_axi_rvalid(1'b0)`, `m_axi_rdata(128'd0)`. `load_v_i` tied 0. Stim = `sw`/`btn`. No QSE/sparse/2-hop/SGD duplicated in the wrap. Probe XOR-fold to 4 LEDs is a keep-sink, not a copied graph.

Raw log elaboration (not RESULTS):

```text
synthesizing module 'a7ng_astra_11_a09_impl_wrap' [.../ASTRA-11-A09-IMPL-ROUTE-01/a7ng_astra_11_a09_impl_wrap.sv:6]
synthesizing module 'MMCME2_BASE' [...]
synthesizing module 'BUFG' [...]
synthesizing module 'a7ng_astra_09_integ_path' [.../rtl/native_graph/integrate/a7ng_astra_09_integ_path.sv:9]
synthesizing module 'a7ng_query_axi_sparse' [...]
  N_BUCKETS = 4096
  CAND_CAP  = 16
  ID_W      = 20
  LAW_SEL   = 1
synthesizing module 'a7ng_query_role_extract'
synthesizing module 'a7ng_sparse_dir_axi'
synthesizing module 'a7ng_shared_rank_sgd_q8_sym_f2r2'
DSP Final Report: a7ng_shared_rank_sgd_q8_sym_f2r2 ×2 (C+A*B, A*B)
U_A09_CELLS=10894
Synthesis finished with 0 errors, 0 critical warnings
synth_design: 0 Critical Warnings and 0 Errors
```

Grep of `vivado.log` for `astra09_pipe` / `uart_rx` / `uart_tx` / `axi_bram128` / `arty_a7_astra`: **no matches**. **Required instantiate-not-copy: MET.**

PREREG contains **no** WNS numbers (policy before impl). WNS appears only in RESULTS/CLOSEOUT/metrics after the run.

### 6. Overclaim ASTRA-13 / SoC UART / LM06?

Implementer language does **not** close ASTRA-13, BOARD_PASS, SoC UART wrap, or LM06. ACK list is explicit. No UART in the compile list or synth module list. No LM06 / language / BOARD_PASS vocabulary used as a pass.

Master ASTRA-11 / ASTRA-13 vs this bag:

| Master item | This bag |
|---|---|
| ASTRA-11 FULLCHIP-COFIT (UART + MMCM + I/O + AXI BRAM/DDR plant + production path as one top) | Isolated A09 integ-path + MMCM/BUFG + 13 board pins (clk/sw/btn/led). Hanging AXI. No UART. No `axi_bram128`. No SoC top |
| ASTRA-11-SOC-WRAP historical routed WNS=-4.765 on `arty_a7_astra09_soc_top` | Different top; bag not overwritten; this WNS=+1.041 is **not** that close |
| ASTRA-13 FINAL-BOARD-ACCEPTANCE | BIT=NOT_BUILT; PROGRAM=NO; no JTAG/COM12 |
| LM06 language | Not opened |

**No Master-gate overclaim found.**

---

## Resources (raw; not the WNS quote)

Quoted **synth** `util_synth.rpt` Design State Synthesized 19:47:01:

```text
| Slice LUTs*             | 5222 |     0 |          0 |     63400 |  8.24 |
| Slice Registers         | 4170 |     0 |          0 |    126800 |  3.29 |
| Block RAM Tile          |    0 | ...
| DSPs                    |    2 | ...
```

Quoted **routed** `util_route.rpt` Design State Routed 19:48:09:

```text
| Slice LUTs              | 1305 |     0 |          0 |     63400 |  2.06 |
| Slice Registers         | 1075 |     0 |          0 |    126800 |  0.85 |
| Block RAM Tile          |    0 | ...
| DSPs                    |    2 | ...  DSP48E1 only
| Bonded IOB              |   13 |    13 |          0 |       210 |  6.19 |
| BUFGCTRL                |    1 |
| MMCME2_ADV              |    1 |
```

Hierarchical routed (`util_hier_route.rpt` Design State Routed 19:48:09):

```text
| a7ng_astra_11_a09_impl_wrap | (top)                    | 1305 | 1075 | 0 | 0 | 2 |
|   u_a09                     | a7ng_astra_09_integ_path | 1265 | 1061 | 0 | 0 | 2 |
|     u_sgd                   | a7ng_shared_rank_sgd...  |  542 |  615 | 0 | 0 | 2 |
|     u_sp                    | a7ng_query_axi_sparse    |  146 |  110 | 0 | 0 | 0 |
|       u_walk                | a7ng_sparse_dir_axi      |  104 |   52 |
|       g_law.u_qse           | a7ng_query_role_extract  |   43 |   50 |
```

`ram_route.rpt`: BlockRAM **0** / 135; LUTRAM **0**. Honest: no `a7ng_axi_bram128` in this instance. **Not** wrap-route BRAM=2.

Synth-to-route LUT 5222→1305 / QSE 2347 (A10 OOC hier)→43 is **opt of I/O-folded constants** (4-bit `sw` tokens, AXI `rvalid=0`, `keep_hierarchy` does not freeze interior constants). SGD DSP×2 and 542 LUT **remain**; worst path still through `u_sgd` DSP48E1. Implementer table states this. **Not a stub DUT.** Also **not** whole-chip A09+UART+BRAM plant occupancy. Do not add 1305 to wrap-route 4244 or to A10 OOC 5178.

Comparison (not identity):

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 1305 | 1075 | 0 | 2 | **Routed clk50u +1.041** (clock-network) |
| This bag synth | 5222 | 4170 | 0 | 2 | Synthesized (not the WNS quote) |
| ASTRA-10 OOC synth | 5178 | 4155 | 0 | 2 | OOC unplaced **+2.283** — not this result |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |
| ASTRA-11-SOC-WRAP | 2956 | 1550 | 0 | 2 | Routed SoC UART wrap **−4.765** — not overwritten |

---

## Overclaim / cheat / tautology

| Hunt | Finding |
|------|---------|
| RESULTS vs raw rpt mismatch on WNS/TNS/WHS | **None.** +1.041 / 0.000 / 0.160 Design State Routed |
| OOC WNS=+2.283 quoted as this result | **Not claimed.** Different Design State; SCD now 6.264 ns routed |
| Wrap-route WNS=+5.733 claimed or overwritten | **Not claimed. Not overwritten** (02:11:52 still 5.733) |
| ASTRA-11-SOC-WRAP overwritten | **Not overwritten** (22:59:22 still WNS=-4.765) |
| Virtual clock / no SCD | **Not found.** P,G,A `clk50u`; E3 IBUF→MMCM→BUFG→`u_a09/clk` fo=1075 routed |
| Copy-paste graph called instantiate | **Not found.** Thin wrap + live RTL path in synth log |
| Stub / empty DUT | **Not found.** Hier `u_a09` LUT=1265; SGD DSP48E1 on worst path |
| Bitstream / BOARD_PASS / PROGRAM | **No bit in this bag.** ACK/RESULTS PROGRAM=NO |
| Hash freeze after looking at WNS | **Not found** for compiled set (PRE 19:40:34 < R0 19:40:35) |
| Edit golden / expected to manufacture PASS | N/A (no numeric golden; quote from rpt) |
| Frozen F2R/F3/persist patched | Manifest SHA MATCH A10 + T1330Z; not compiled here |
| `astra09_pipe` / UART / `axi_bram128` slipped in | Forbidden in tcl; absent from synth module list |
| ASTRA-13 / LM06 / SoC UART close | **Not claimed** |
| R0 wipe | Log **kept**; reports replaced by R1 with **same checksum and same WNS** |
| LUT drop used as whole-chip A09 occupancy | **Not claimed.** Documented I/O-fold / hanging AXI |

qstack adversary: worst path is a real placed/routed SGD update (A09 FSM → `u_sgd` w_reg through DSP48E1) under a **propagated generated** 20 ns clock with SCD=6.264 ns. `set_false_path` on sw/btn and unconstrained LED **do not** create that 1.041 ns slack. `keep_hierarchy` preserves `u_a09` identity. QSE/sparse constant-fold is a **narrowing of occupancy**, not a fake WNS.

---

## Logic bugs

No route FAIL. No critical warnings. No RESULTS/raw contradiction on the quoted WNS/TNS/WHS. Route complete (0 failed nets). WNS ≥ 0 so the handoff WNS<0 bounded experiment was correctly **not** run.

Residuals (not this-bag FAIL):

1. Routed occupancy (LUT=1305, QSE=43) is **not** the A10 OOC 5178-LUT A09. Hanging AXI + 4-bit switch tokens constant-fold sparse/QSE. WNS still measures a live SGD datapath with clock-network. Do not promote 1305 LUT as whole-chip A09+UART+BRAM.
2. R0 was a successful Vivado impl+route misclassified by the runner; R1 overwrote reports. Same checksum `81d4081f`, same WNS=1.041. Log kept.
3. `check_timing` HIGH on 4 LED output delays — expected for this wrap; still a gap vs board I/O timing close.
4. WHS=+0.160 ns is on the wrap `btn0_q` synchronizer, not the DUT. MET, tight. Not a fail.
5. DRC DSP unpipelined (DPIP/DPOP) — expected; SGD combinational DSP is the critical path. Do not “fix” frozen F2R2 from this bag.
6. AXI master hanging (no on-chip BRAM) is **intentional** for this instance; whole-chip BRAM/DDR/UART plant remains a **later / different** bag (Master ASTRA-11).
7. This number set is **not** additive with wrap-route 4244 LUT / BRAM=2 or with A10 OOC 5178/4155.

No DUT logic patch requested. Auditor does not fix.

---

## This bag vs Master ASTRA-11 / ASTRA-13

Work-order unknown **answered**: for wrapper `a7ng_astra_11_a09_impl_wrap` / instance `u_a09` = frozen `a7ng_astra_09_integ_path` on `xc7a100tcsg324-1`, post-route (Design State **Routed**) is **WNS=+1.041 ns TNS=0.000 ns WHS=+0.160 ns @ clk50u 20.000 ns (50 MHz)** with **real** E3 IBUF → MMCME2_ADV_X1Y2 → BUFGCTRL_X0Y16 → `u_a09/clk` (SCD=6.264 ns, fo=1075 routed), **BIT=NOT_BUILT**, **PROGRAM=NO**.

T1330Z residual 1 (**OOC WNS is not implemented**) is **closed as evidence class** for *this named wrap*. It is **not** permission to mark Master ASTRA-11 or ASTRA-13 done.

Master **ASTRA-11 FULLCHIP-COFIT** remains **OPEN** (no UART, no `axi_bram128`, not `arty_a7_astra09_soc_top`, not the wrap-route SoC). Historical ASTRA-11-SOC-WRAP WNS=-4.765 remains on disk, unoverwritten, still not BOARD.

Master **ASTRA-13 FINAL-BOARD-ACCEPTANCE** remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority.

Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-10 whole-chip remain **OPEN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-11-A09-IMPL-ROUTE-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw routed reports, instantiate-not-copy, hash-before-impl including `.svh`, real clock-network (not virtual), WNS=+1.041 ≥ 0, TNS=0, PROGRAM=NO, no bitstream, prior wrap-route / SOC-WRAP bags not overwritten, no BOARD_PASS / ASTRA-13 / LM06 / UART overclaim.

Not PASS (Master ASTRA-11 fullchip, ASTRA-13 board, UART/BRAM plant, LED I/O timing, un-folded QSE occupancy).  
Not FAIL (raw WNS matches claim; route 0 error / 0 critical; frozen A09/SGD/F2R/persist unpatched; r0 log kept; clock path real).  
Not OVERCLAIM (ACK/RESULTS keep Master 11/13/BOARD/UART/LM06 open; do not steal wrap-route +5.733 or OOC +2.283).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared routed-WNS-at-50 MHz-with-clock-network claim.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this WNS=+1.041 to BOARD_PASS, ASTRA-13, wrap-route WNS=+5.733, ASTRA-11-SOC-WRAP close, or ASTRA-10 OOC WNS=+2.283.
2. Do **not** add this LUT/FF to wrap-route 4244/3810 or treat BRAM=0 as a contradiction of wrap-route BRAM=2. Whole-chip co-fit needs **one** current-source SoC top (Master ASTRA-11).
3. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED.
4. Optional: stop treating successful Vivado `DONE` as FAIL_R0 (`cmd`/`$exit` smell). Do not rewrite this bag’s SHA256.txt.
5. Parent next residual is **not** silent Master ASTRA-11 / ASTRA-13 close. Remaining: SoC UART wrap as the frozen top (if that is still the production path), whole-chip plant, bitstream policy, board. Not this wrap’s job.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated implement+route of instantiated frozen `a7ng_astra_09_integ_path` at declared 50 MHz with **real routed clock-network**, WNS=+1.041 ≥ 0, BIT=NOT_BUILT, PROGRAM=NO.

`REJECT_PROMOTION` — Master **ASTRA-11** (fullchip co-fit / SoC UART wrap), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed.

Master ASTRA-09: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-11-SOC-WRAP historical WNS=-4.765: **untouched, still not BOARD**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1400Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-11-A09-IMPL-ROUTE-01; Master ASTRA-11/13 OPEN; raw routed WNS=+1.041 TNS=0.000 WHS=+0.160 (Design State Routed, clk50u 20.000 ns, SCD=6.264 ns E3 IBUF→MMCM→BUFG→u_a09/clk routed fo=1075); PROGRAM=NO; BOARD still blocked YES.
