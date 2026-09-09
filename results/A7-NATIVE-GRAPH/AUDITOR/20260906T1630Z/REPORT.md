# ASTRA auditor REPORT — 20260906T1630Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA11_A09R2_IMPL_ROUTE_INDEPENDENT_AUDIT; astra11_a09r2=IMPLEMENTER_CLAIM_ROUTED_WNS_P0648_PENDING_AUDITOR; astra09_r2=AUDITOR_PASS_NARROW_DUT_INCOMP_ANS0; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-11 FULLCHIP-COFIT / ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-11-A09R2-IMPL-ROUTE-01 + prior auditor 20260906T1600Z (A09-R2 XSim ACCEPT_PARTIAL; residual = implement+route of instantiated a7ng_astra_09_r2_cand_ovf at 50 MHz with clock-network, not OOC, not BOARD, not bitstream) + auditor 20260906T1400Z (A09 leftover wrap-route WNS=+1.041 PASS_NARROW; do not overwrite)
EVIDENCE   = raw timing_route.rpt / util_route.rpt / util_hier_route.rpt / clocks_route.rpt / clock_util_route.rpt / route_status.rpt / ram_route.rpt / io.rpt / drc.rpt / util_synth.rpt / timing_synth.rpt / vivado.log / vivado.jou / wrap SV / tcl / XDC / SHA manifests / PREREG / ACK (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_impl.ps1` / `run_impl.tcl` (would overwrite `vivado.log` / routed reports).

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to overlapping hashes in `ASTRA-09-R2-CAND-OVF-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, and `ASTRA-10` / T1400 / T1600 freeze strings.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R2-IMPL-ROUTE-01/`

Top `a7ng_astra_11_a09r2_impl_wrap` (bag-local) instance **`u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv`**. Pin clock `CLK100MHZ` E3 period 10.000 ns. Pipe clock MMCM 100→50 + BUFG, generated `clk50u` period 20.000 ns. Part `xc7a100tcsg324-1`. Mode **in-context** `synth_design` (not `-mode out_of_context`) then `opt_design` / `place_design` / `route_design`. No bitstream.

Gate under review is **work-order ASTRA-11-A09R2-IMPL-ROUTE-01 only** — one unknown: after implement+route of that instantiated A09-R2 path at a declared 50 MHz constraint **with clock-network delay included**, is WNS ≥ 0 — without a bitstream. **Not** Master ASTRA-11 fullchip close. **Not** ASTRA-13 board acceptance. **Not** freeze of `PRODUCTION_TOP`.

Parent residual from auditor `20260906T1600Z`: A09-R2 XSim ntrunc→INCOMP `ans=0` is **not** implemented timing. Next physical evidence must be **implemented/routed** of instantiated `a7ng_astra_09_r2_cand_ovf` (clock-network), not OOC, not BOARD, not bitstream. Frozen leftover A09 (`a7ng_astra_09_integ_path`, leftover `ans=4`) must **not** be compiled as DUT and must **not** be patched.

Hunt (parent / work order / this dispatch):

1. Quote WNS/TNS/WHS from **RAW** `timing_route.rpt` Design State=Routed. Implementer claimed WNS=+0.648 @ clk50u 20 ns.
2. Clock path: E3 IBUF → MMCM → BUFG → `u_a09r2/clk` with SCD — real network or virtual?
3. No `.bit` generated? PROGRAM=NO? `PRODUCTION_TOP=UNKNOWN`?
4. Not claiming A09 wrap WNS=+1.041, wrap-route WNS=+5.733, or BOARD_PASS? ASTRA-11-A09-IMPL-ROUTE-01 not overwritten?
5. Hash before impl including `.svh`?
6. Confirm `a7ng_astra_09_r2_cand_ovf` instantiated; frozen A09 **not** compiled.

Judged against:

1. Work order `.agents/handoff/ASTRA-11-A09R2-IMPL-ROUTE-01.md` + PREREG: instantiate `a7ng_astra_09_r2_cand_ovf` (not copy-paste graph; not compile frozen leftover A09); hash RTL+XDC+tcl before impl; impl+route at declared 50 MHz with clock-network; quote routed Design State; if WNS<0 FAIL bag, keep report, one bounded experiment, still no bit; PROGRAM=NO; do not overwrite A09 wrap WNS=+1.041 or wrap-route WNS=+5.733; do not close ASTRA-13, BOARD_PASS, SoC UART wrap, LM06, Master F3; do not freeze `PRODUCTION_TOP`.
2. **Master ASTRA-11** (DAG: FULLCHIP-COFIT): whole-chip co-fit of the frozen SoC top (UART + MMCM + I/O + memory plant + production path together), not an isolated A09-R2 I/O-fold wrap.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.*
4. Auditor `20260906T1600Z`: ASTRA-09-R2-CAND-OVF-01 PASS_NARROW XSim; residual = this impl/route. Auditor `20260906T1400Z`: leftover A09 wrap PASS_NARROW WNS=+1.041; that bag must remain unoverwritten.

**Master ASTRA-11 as a whole is not this bag’s close**, even if this wrapper’s routed WNS is ≥ 0.

Out of this bag’s close: UART SoC wrap, `a7ng_astra09_pipe`, `a7ng_axi_bram128` plant, ASTRA-11-SOC-WRAP WNS=-4.765 close or overwrite, wrap-route `arty_a7_astra_rtp_soc_top` WNS=+5.733 identity, leftover A09 wrap WNS=+1.041 identity, bitstream, JTAG/COM12, LM06 language, Master ASTRA-09 production path, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, ASTRA-13 BOARD_PASS, `PRODUCTION_TOP` freeze.

Frozen `a7ng_astra_09_r2_cand_ovf.sv` / `.svh`, leftover `a7ng_astra_09_integ_path.sv` / `.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, F2R3/F2R4/F2R5, persist/R2/R3/R4 must remain **unpatched**. This wrap is a **new named** impl/route wrapper. It must **instantiate** A09-R2, not copy the graph. It must **not** compile leftover A09 / `astra09_pipe` / `axi_bram128` / UART.

Prior bags `ASTRA-09-R2-CAND-OVF-01`, `ASTRA-11-A09-IMPL-ROUTE-01`, `ASTRA-10-RESOURCE-BOUND-01`, `ASTRA-09-INTEGRATED-PATH-01`, `ASTRA-SOC-RTP-WRAP-ROUTE`, `ASTRA-11-SOC-WRAP`, `ASTRA-11-TIMING-FIX` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### 1. Raw routed WNS/TNS/WHS (authority)

`timing_route.rpt` header:

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Sun Sep  6 21:26:25 2026
Command      : report_timing_summary -file .../ASTRA-11-A09R2-IMPL-ROUTE-01/timing_route.rpt
Design       : a7ng_astra_11_a09r2_impl_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      0.648        0.000                      0                 3089        0.126        0.000                      0                 3089
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
  clk50u            0.648        0.000                      0                 2120        0.126        0.000                      0                 2120
```

Implementer claim **WNS=+0.648 @ clk50u 20.000 ns MATCHES raw routed timing**. TNS=0.000 WHS=0.126 THS=0.000. Failing endpoints = 0. `TIMING_EXTRACT.txt` / `metrics.json` match the raw summary. No RESULTS vs raw-rpt contradiction on WNS/TNS/WHS.

Worst setup path (same rpt): `Slack (MET) : 0.648ns`; source `u_a09r2/FSM_sequential_st_reg[3]/C` → dest `u_a09r2/u_sgd/w_reg[10][3]/D`; **Requirement 20.000 ns**; Data Path Delay 19.117 ns (logic 10.083 / route 9.034); 21 logic levels including **DSP48E1** `u_a09r2/u_sgd/prod_ud`; Path Group `clk50u`. This is a real SGD update path inside instantiated A09-R2, not a wrap-only tautology.

Worst hold path: `Slack (MET) : 0.126ns`; source `u_a09r2/u_sp/u_walk/FSM_onehot_st_reg[4]/C` → dest `u_a09r2/u_sp/u_walk/FSM_onehot_st_reg[5]/D` (DUT walker FSM, not wrap synchronizer). MET. Tight. Not a hold fail.

`check_timing`: `no_clock` 0, `unconstrained_internal_endpoints` 0, `no_input_delay` 8 MEDIUM (sw/btn have `set_false_path`), `no_output_delay` 4 HIGH (LED ports). Quoted WNS is **internal register-to-register** under `clk50u`. LED I/O unconstrained is a residual vs board I/O timing close, **not** a silent manufacture of the 0.648 ns internal slack.

`route_status.rpt`: logical nets 3462; fully routed 2247; **routing errors = 0**.

DRC: 9 checks, all Warning (DSP DPIP/DPOP pipeline on `u_a09r2/u_sgd` acc0/prod_ud). **0 Error / 0 Critical**. Unpipelined DSP is consistent with the combinational DSP48E1 on the worst setup path.

Synth-only contrast (not the WNS quote): `timing_synth.rpt` Design State **Synthesized** 21:25:26; extract `WNS=2.141`. Implementer correctly quotes **routed** 0.648, not synth 2.141.

### 2. Clock path: real routed network, not virtual

`clocks_route.rpt` Design State **Routed** 21:26:28:

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
                         net (fo=1103, routed)        1.701     6.319    u_a09r2/clk
    SLICE_X5Y115         FDCE                                         r  u_a09r2/FSM_sequential_st_reg[3]/C
Source Clock Delay      (SCD):    6.319ns
Destination Clock Delay (DCD):    5.962ns
```

Capture side ends `net (fo=1103, routed) u_a09r2/u_sgd/clk` at `BUFGCTRL_X0Y16`. Nets marked **`routed`**, sites placed. Contrast ASTRA-10 OOC: `net (fo=4154, unset)` + `<hidden>` + Timing 38-242 HD.CLK_SRC unset. **This bag answers T1600 residual as implemented/routed evidence class for A09-R2.**

`clock_util_route.rpt`: MMCM=1 at `MMCME2_ADV_X1Y2`; BUFGCTRL=1 at `BUFGCTRL_X0Y16`; global g0 driver `u_bufg50/O` net `clk`; **1103 clock loads**; period 20.000; clock name `clk50u`.

`io.rpt`: pin **E3** = `CLK100MHZ`, High Range, `IO_L12P_T1_MRCC_35`, bank 35, LVCMOS33, FIXED. Matches `clk50_impl.xdc` and Arty A7-100T oscillator site. Wrap RTL: `MMCME2_BASE` CLKIN1_PERIOD=10.0, CLKFBOUT_MULT_F=10.0, CLKOUT0_DIVIDE_F=20.0 → 50 MHz. Vivado maps `MMCME2_BASE => MMCME2_ADV` (Unisim). Inferred **IBUF** into MMCM CLKIN (7-series normal); **not** a virtual `create_clock` on an internal net without a pin.

XDC also `create_clock -add -name sys_clk_pin -period 10.000` on port `CLK100MHZ`. Declared 50 MHz is the **generated** `clk50u`, not a lie that E3 is a 50 MHz oscillator. PREREG states this. Honest.

This WNS **must not** be called leftover A09 wrap WNS=+1.041, ASTRA-10 OOC WNS=+2.283, wrap-route WNS=+5.733, ASTRA-11-SOC-WRAP WNS=-4.765, or BOARD_PASS.

### 3. No bitstream? PROGRAM=NO? PRODUCTION_TOP UNKNOWN?

Bag listing: `ckpt/synth.dcp`, `ckpt/route.dcp`. **No `.bit`.** `write_checkpoint` after synth and after route is allowed. TCL `astra_forbid_bit` / `rename write_bitstream`; never invokes `write_bitstream`; exits 0 after route reports. `PRODUCTION_TOP=UNKNOWN` printed before synth and in the DONE marker.

`vivado.jou`: sources `run_impl.tcl` only. **No** `write_bitstream`, `open_hw_manager`, `program_hw`, `hw_server`, `xsdb`.

`vivado.log` (single session, PID 34108) markers:

```text
Start of session at: Sun Sep  6 21:22:39 2026
Process ID         : 34108
DUT_MODULE=a7ng_astra_09_r2_cand_ovf
DUT_INSTANCE=u_a09r2
MODE=in_context_impl_route
PROGRAM=NO
BIT=NOT_BUILT
PRODUCTION_TOP=UNKNOWN
Command: synth_design -top a7ng_astra_11_a09r2_impl_wrap -part xc7a100tcsg324-1
  (NOT -mode out_of_context)
U_A09R2_CELLS=11008
ASTRA_11_A09R2_IMPL_ROUTE_ROUTE_DONE WNS=0.648 TNS=0.000 WHS=0.126 THS=0.000 PROGRAM=NO BIT=NOT_BUILT
ASTRA_11_A09R2_IMPL_ROUTE_DONE WNS=0.648 TNS=0.000 WHS=0.126 BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN
Exiting Vivado at Sun Sep  6 21:26:29 2026
```

ACK `PROGRAM: false`, `write_bitstream: false`, `bitstream: NOT_BUILT`, `PRODUCTION_TOP: UNKNOWN`. **PROGRAM=NO holds. PRODUCTION_TOP not frozen.**

No `vivado_fail_r0.log` / `fail_r0/` in this bag. First (only) Vivado invocation succeeded; WNS≥0 so the handoff WNS<0 bounded experiment was **not** run. Not a wiped fail.

ASTRA-11-SOC-WRAP still contains historical `arty_a7_astra09_soc_top.bit` (UNPROGRAMMED; timing.rpt date **Sat Sep 5 22:59:22**). ASTRA-SOC-RTP-WRAP-ROUTE still contains historical `arty_a7_astra_rtp_soc_top.bit` (timing.rpt date **Sun Sep 6 02:11:52**). Those files were **not produced by this 21:22–21:26 session** and were **not overwritten** (see hunt 4). This bag did not program either bit.

### 4. Not claiming A09 wrap WNS=+1.041, wrap-route WNS=+5.733, or BOARD_PASS? Prior bags not overwritten?

Implementer RESULTS/CLOSEOUT/ACK/PREREG:

- `RESULT = PASS_NARROW (this bag only: routed WNS at declared 50 MHz with clock-network)`
- Explicit: do **not** call this BOARD_PASS, A09 wrap WNS=+1.041, wrap-route WNS=+5.733, or OOC WNS=+2.283
- `does_not_close`: Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-13 / ASTRA-11 SoC UART wrap / Master ASTRA-10 whole-chip / `production_top_identity` / `write_bitstream`
- `PRODUCTION_TOP=UNKNOWN`

Leftover A09 wrap raw `ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt` still **Sun Sep 6 19:48:09**, Design `a7ng_astra_11_a09_impl_wrap`, Design State Routed:

```text
WNS(ns)=1.041  TNS=0.000  WHS=0.160
```

That bag’s `RESULTS.md` still `MARKER ... WNS=1.041`. Wrap SV SHA still `399aa22a…` in that bag’s `SHA256.txt` **and** in this bag’s KEEP_NOT_THIS_WRAPPER. **Not overwritten** by this 21:26 session.

Wrap-route raw `ASTRA-SOC-RTP-WRAP-ROUTE/timing.rpt` still **Sun Sep 6 02:11:52**, Design `arty_a7_astra_rtp_soc_top`, Design State Routed:

```text
WNS(ns)=5.733  TNS=0.000  WHS=0.029
```

**Not overwritten.**

ASTRA-11-SOC-WRAP `timing.rpt` still **Sat Sep 5 22:59:22**, Design `arty_a7_astra09_soc_top`, extract WNS=**-4.765**. **Not overwritten.**

ASTRA-09-R2-CAND-OVF-01 `xsim.log` still session **Sun Sep 6 21:05:33** PID **22184** snapshot `a09r2`. **Not overwritten.**

ASTRA-12-PREPROGRAM-PACK-01 still `PRODUCTION_TOP = UNKNOWN`. This bag did not freeze a top.

**No BOARD_PASS claim found. No A09 wrap +1.041 identity theft. No wrap-route +5.733 identity theft. ASTRA-11-A09-IMPL-ROUTE-01 not overwritten.**

### 5. Hash before impl including `.svh`? Instantiated not copied? Frozen A09 not compiled?

**Hash order**

- `SHA256.txt` / `SOURCE_HASHES.txt`: **BEFORE impl** `2026-09-06T21:22:38.8813461+07:00`
- Vivado start: `21:22:39` (PID 34108) — 1 s later
- Reports: `21:25:19` (synth util) … `21:26:25` (timing_route) … `21:26:29` (clocks/ram/exit)
- `SHA256_POST.txt`: **AFTER impl** `2026-09-06T21:26:29.8059890+07:00`

`run_impl.ps1` live-checks frozen leftover A09 / R2 DUT / SGD hashes, writes SHA256 of compiled + `.svh` + CONFIG + KEEP + provenance **then** calls Vivado. Not hash-after-scores theatre on compiled sources.

PRE vs POST compiled + transitive includes: **16/16 identical strings** (opened manifests; not re-hashed):

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
| bag `a7ng_astra_11_a09r2_impl_wrap.sv` | `1932ee4c1efc418dedd32c958768ee9e970469026ea0c994b8f33bd702d2615d` |
| bag `clk50_impl.xdc` | `b1a372fd52d1c06c885e3e65ef65708b4207fa56b2beaa3b2e321f58c098ac5a` |
| bag `run_impl.tcl` | `fe119090ff5d92bafcc5e67edae4a50fcaa5a023c48f45b7b5c462cdb5e4c7e0` |
| `a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `a7ng_astra_09_integ_path.svh` | `ad2d66d4783bba33cfbd324fc0a9661fb2a46eeaffb5b4fb6989246fb4e94302` |
| `a7ng_astra_09_r2_cand_ovf.svh` | `feaed571ce02bec4218e2105986349a464d6c44bcf1a818260ee27a171afd329` |

`.svh` **is** in the pre-impl freeze (R2 contract + leftover A09 header + lexica + crc). Hunt 5: **MET.**

R2 DUT `15a919f1…` **MATCH** `ASTRA-09-R2-CAND-OVF-01/SHA256.txt` and auditor T1600. Frozen leftover A09 `9fdbe0d6…` **MATCH** ASTRA-09 / ASTRA-07 / T1600 / T1400 (KEEP/provenance only; **not compiled**). Frozen SGD `b66ef328…` MATCH. Leftover A09 wrap `399aa22a…` MATCH ASTRA-11-A09-IMPL-ROUTE-01 (KEEP; not compiled here).

Provenance persist/R2/R3/R4 and F2R3/F2R4/F2R5 SHAs unchanged vs T1400 (`52ebde52…` / `c671f98b…` / `99ee5d93…` / `4bd94762…` / `9a7a5941…` / `5cdb3da8…` / `41c77e76…`).

TCL compile list is the R2 set + wrap; `foreach` aborts on leftover `a7ng_astra_09_integ_path.sv` / `a7ng_astra09_pipe.sv` / UART / `axi_bram128`. Post-synth cell checks abort if leftover A09 / pipe / BRAM cells exist. Those keep-files are hashed under KEEP_NOT_THIS_WRAPPER and **not** in `read_verilog`.

**Instantiate, not copy-paste; frozen A09 not compiled**

Bag contains `a7ng_astra_11_a09r2_impl_wrap.sv` only as RTL (no copied integrator `.sv` in the bag). Wrap:

```text
(* keep_hierarchy = "yes" *)
a7ng_astra_09_r2_cand_ovf u_a09r2 ( ... );
assign w0 = w[0];
```

AXI hanging by construction: `m_axi_arready(1'b1)`, `m_axi_rvalid(1'b0)`, `m_axi_rdata(128'd0)`. `load_v_i` tied 0. Stim = `sw`/`btn`. Extra R2 ports `n_trunc_o` / `r_ovf_o` / `w_ovf_o` XOR-folded into LED probe (keep-sink, not a copied graph). No QSE/sparse/2-hop/SGD duplicated in the wrap. Frozen leftover A09 **not instantiated**.

Raw log elaboration (not RESULTS):

```text
synthesizing module 'a7ng_astra_11_a09r2_impl_wrap' [.../ASTRA-11-A09R2-IMPL-ROUTE-01/a7ng_astra_11_a09r2_impl_wrap.sv:7]
synthesizing module 'MMCME2_BASE' [...]
synthesizing module 'BUFG' [...]
synthesizing module 'a7ng_astra_09_r2_cand_ovf' [.../rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv:9]
synthesizing module 'a7ng_query_axi_sparse' [...]
  N_BUCKETS = 4096
  CAND_CAP  = 16
  LAW_SEL   = 1
synthesizing module 'a7ng_query_role_extract'
synthesizing module 'a7ng_sparse_dir_axi'
synthesizing module 'a7ng_shared_rank_sgd_q8_sym_f2r2'
DSP Final Report: a7ng_shared_rank_sgd_q8_sym_f2r2 ×2 (C+A*B, A*B)
U_A09R2_CELLS=11008
Synthesis finished with 0 errors, 0 critical warnings
synth_design: 0 Critical Warnings and 0 Errors
```

Grep of `vivado.log` for `a7ng_astra_09_integ_path` / `astra09_pipe` / `uart_rx` / `uart_tx` / `axi_bram128` / `arty_a7_astra`: **no matches**. **Required instantiate-not-copy and frozen-A09-not-compiled: MET.**

PREREG contains **no** WNS numbers (policy before impl). WNS appears only in RESULTS/CLOSEOUT/metrics after the run.

Synth warnings exist (unused `nfar_reg`/`nfok_reg`; Synth 8-7137 set+reset same priority on R2 DUT regs; RAM-as-registers). **0 Error / 0 Critical**. Do not patch frozen R2 DUT from this bag.

### 6. Overclaim ASTRA-13 / SoC UART / LM06 / PRODUCTION_TOP / A09 wrap +1.041?

Implementer language does **not** close ASTRA-13, BOARD_PASS, SoC UART wrap, LM06, or `PRODUCTION_TOP`. ACK list is explicit. No UART in the compile list or synth module list. No LM06 / language / BOARD_PASS vocabulary used as a pass. A09 wrap +1.041 and wrap-route +5.733 are cited only as **not this result**.

Master ASTRA-11 / ASTRA-13 vs this bag:

| Master item | This bag |
|---|---|
| ASTRA-11 FULLCHIP-COFIT (UART + MMCM + I/O + AXI BRAM/DDR plant + production path as one top) | Isolated A09-R2 + MMCM/BUFG + 13 board pins (clk/sw/btn/led). Hanging AXI. No UART. No `axi_bram128`. No SoC top |
| ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041 | Different DUT `a7ng_astra_09_integ_path`; bag not overwritten; this WNS=+0.648 is **not** that number |
| ASTRA-11-SOC-WRAP historical routed WNS=-4.765 on `arty_a7_astra09_soc_top` | Different top; bag not overwritten; this WNS=+0.648 is **not** that close |
| ASTRA-13 FINAL-BOARD-ACCEPTANCE | BIT=NOT_BUILT; PROGRAM=NO; no JTAG/COM12; `PRODUCTION_TOP=UNKNOWN` |
| LM06 language | Not opened |

**No Master-gate overclaim found.**

---

## Resources (raw; not the WNS quote)

Quoted **synth** `util_synth.rpt` Design State Synthesized 21:25:19:

```text
| Slice LUTs*             | 5251 |     0 |          0 |     63400 |  8.28 |
| Slice Registers         | 4198 |     0 |          0 |    126800 |  3.31 |
| Block RAM Tile          |    0 | ...
| DSPs                    |    2 | ...
```

Quoted **routed** `util_route.rpt` Design State Routed 21:26:25:

```text
| Slice LUTs              | 1321 |     0 |          0 |     63400 |  2.08 |
| Slice Registers         | 1103 |     0 |          0 |    126800 |  0.87 |
| Block RAM Tile          |    0 | ...
| DSPs                    |    2 | ...  DSP48E1 only
| Bonded IOB              |   13 |    13 |          0 |       210 |  6.19 |
| BUFGCTRL                |    1 |
| MMCME2_ADV              |    1 |
```

Hierarchical routed (`util_hier_route.rpt`):

```text
| a7ng_astra_11_a09r2_impl_wrap | (top)                     | 1321 | 1103 | 0 | 0 | 2 |
|   u_a09r2                     | a7ng_astra_09_r2_cand_ovf | 1278 | 1089 | 0 | 0 | 2 |
|     u_sgd                     | a7ng_shared_rank_sgd...   |  533 |  615 | 0 | 0 | 2 |
|     u_sp                      | a7ng_query_axi_sparse     |  489 |  142 | 0 | 0 | 0 |
|       u_walk                  | a7ng_sparse_dir_axi       |  450 |   84 |
|       g_law.u_qse             | a7ng_query_role_extract   |   39 |   50 |
```

`ram_route.rpt`: BlockRAM **0** / 135; LUTRAM **0**. Honest: no `a7ng_axi_bram128` in this instance. **Not** wrap-route BRAM=2.

Synth-to-route LUT 5251→1321 / QSE 39 (folded) is **opt of I/O-folded constants** (4-bit `sw` tokens, AXI `rvalid=0`). SGD DSP×2 and 533 LUT **remain**; worst path still through `u_sgd` DSP48E1. Walker LUT=450 is **larger** than leftover A09 wrap walker (104) because R2 overflow ports `n_trunc`/`r_ovf`/`w_ovf` are XOR-probed and cannot fully constant-fold. Implementer table states the I/O-fold. **Not a stub DUT.** Also **not** whole-chip A09-R2+UART+BRAM plant occupancy. Do not add 1321 to wrap-route 4244 or to leftover A09 wrap 1305.

Comparison (not identity):

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 1321 | 1103 | 0 | 2 | **Routed clk50u +0.648** (clock-network; A09-R2) |
| This bag synth | 5251 | 4198 | 0 | 2 | Synthesized (not the WNS quote; extract +2.141) |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed **different DUT leftover A09 +1.041** — not overwritten |
| ASTRA-10 OOC synth | 5178 | 4155 | 0 | 2 | OOC unplaced **+2.283** — not this result |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |
| ASTRA-11-SOC-WRAP | 2956 | 1550 | 0 | 2 | Routed SoC UART wrap **−4.765** — not overwritten |

---

## Overclaim / cheat / tautology

| Hunt | Finding |
|------|---------|
| RESULTS vs raw rpt mismatch on WNS/TNS/WHS | **None.** +0.648 / 0.000 / 0.126 Design State Routed |
| Leftover A09 wrap WNS=+1.041 quoted as this result | **Not claimed.** Different DUT; that bag still 19:48:09 / 1.041 |
| OOC WNS=+2.283 quoted as this result | **Not claimed.** Different Design State; SCD now 6.319 ns routed |
| Wrap-route WNS=+5.733 claimed or overwritten | **Not claimed. Not overwritten** (02:11:52 still 5.733) |
| ASTRA-11-SOC-WRAP overwritten | **Not overwritten** (22:59:22 still WNS=-4.765) |
| Virtual clock / no SCD | **Not found.** P,G,A `clk50u`; E3 IBUF→MMCM→BUFG→`u_a09r2/clk` fo=1103 routed |
| Copy-paste graph called instantiate | **Not found.** Thin wrap + live RTL path in synth log |
| Frozen leftover A09 compiled as DUT | **Not found.** Zero synth/log matches; tcl forbids; KEEP hash only |
| Stub / empty DUT | **Not found.** Hier `u_a09r2` LUT=1278; SGD DSP48E1 on worst path; U_A09R2_CELLS=11008 |
| Bitstream / BOARD_PASS / PROGRAM | **No bit in this bag.** ACK/RESULTS PROGRAM=NO |
| `PRODUCTION_TOP` frozen | **UNKNOWN** in ACK / log DONE / RESULTS / CLOSEOUT / LOOP_STATE |
| Hash freeze after looking at WNS / `.svh` omitted | **Not found.** PRE 21:22:38 < Vivado 21:22:39; 5 `.svh` in PRE; POST 16/16 MATCH |
| Edit golden / expected to manufacture PASS | N/A (no numeric golden; quote from rpt) |
| Frozen F2R/F3/persist / R2 DUT patched | Manifest SHA MATCH T1600/T1400; leftover A09 KEEP only |
| `astra09_pipe` / UART / `axi_bram128` slipped in | Forbidden in tcl; absent from synth module list |
| ASTRA-13 / LM06 / SoC UART close | **Not claimed** |
| Fail r0 wipe | **N/A.** Single successful session; WNS≥0; no fail_r0 artifact to wipe |
| LUT drop used as whole-chip occupancy | **Not claimed.** Documented I/O-fold / hanging AXI |

qstack adversary: worst path is a real placed/routed SGD update (A09-R2 FSM → `u_sgd` w_reg through DSP48E1) under a **propagated generated** 20 ns clock with SCD=6.319 ns. `set_false_path` on sw/btn and unconstrained LED **do not** create that 0.648 ns slack. `keep_hierarchy` preserves `u_a09r2` identity. QSE constant-fold is a **narrowing of occupancy**; walker remaining larger than leftover A09 wrap is consistent with R2 overflow ports being observed. WNS=+0.648 is **worse** than leftover A09 wrap +1.041 (different DUT, longer data path 19.117 vs 18.768) and is **not** a recycled +1.041.

---

## Logic bugs

No route FAIL. No critical warnings. No RESULTS/raw contradiction on the quoted WNS/TNS/WHS. Route complete (0 failed nets). WNS ≥ 0 so the handoff WNS<0 bounded experiment was correctly **not** run.

Residuals (not this-bag FAIL):

1. Routed occupancy (LUT=1321, QSE=39) is **not** whole-chip A09-R2+UART+BRAM. Hanging AXI + 4-bit switch tokens constant-fold QSE. Walker stays larger than leftover A09 wrap because overflow probes keep `ntrunc`/`ovf`. WNS still measures a live SGD datapath with clock-network. Do not promote 1321 LUT as fullchip occupancy.
2. `check_timing` HIGH on 4 LED output delays — expected for this wrap; still a gap vs board I/O timing close.
3. WHS=+0.126 ns is on the DUT walker one-hot FSM, not the wrap. MET, tight. Not a fail. Do not “fix” frozen walker from this bag.
4. DRC DSP unpipelined (DPIP/DPOP) — expected; SGD combinational DSP is the critical path. Do not “fix” frozen F2R2 from this bag.
5. Synth 8-7137 set+reset same priority on R2 DUT registers — sim-mismatch warning, 0 critical. Frozen R2 hash `15a919f1…` unchanged. Do not patch R2 DUT from this bag.
6. AXI master hanging (no on-chip BRAM) is **intentional** for this instance; whole-chip BRAM/DDR/UART plant remains a **later / different** bag (Master ASTRA-11).
7. This number set is **not** additive with leftover A09 wrap 1305/1075, wrap-route 4244/3810 BRAM=2, or A10 OOC 5178/4155.
8. No independent `Get-FileHash` this process. Overlapping R2/SGD/A09/pkg hashes MATCH prior bags. Wrap/XDC/tcl digests are first-recorded here.
9. Functional ntrunc→INCOMP identity remains **XSim** (T1600). This bag does not re-prove overflow refuse on silicon.

No DUT logic patch requested. Auditor does not fix.

---

## This bag vs Master ASTRA-11 / ASTRA-13

Work-order unknown **answered**: for wrapper `a7ng_astra_11_a09r2_impl_wrap` / instance `u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf` on `xc7a100tcsg324-1`, post-route (Design State **Routed**) is **WNS=+0.648 ns TNS=0.000 ns WHS=+0.126 ns @ clk50u 20.000 ns (50 MHz)** with **real** E3 IBUF → MMCME2_ADV_X1Y2 → BUFGCTRL_X0Y16 → `u_a09r2/clk` (SCD=6.319 ns, fo=1103 routed), **BIT=NOT_BUILT**, **PROGRAM=NO**, **PRODUCTION_TOP=UNKNOWN**. Frozen leftover A09 **not compiled**. ASTRA-11-A09-IMPL-ROUTE-01 WNS=+1.041 **not overwritten**.

T1600 residual (**A09-R2 XSim is not implemented timing**) is **closed as evidence class** for *this named wrap*. It is **not** permission to mark Master ASTRA-11 or ASTRA-13 done, and **not** permission to freeze `PRODUCTION_TOP`.

Master **ASTRA-11 FULLCHIP-COFIT** remains **OPEN** (no UART, no `axi_bram128`, not `arty_a7_astra09_soc_top`, not the wrap-route SoC). Historical ASTRA-11-SOC-WRAP WNS=-4.765 remains on disk, unoverwritten, still not BOARD. Leftover A09 wrap WNS=+1.041 remains a **different DUT**.

Master **ASTRA-13 FINAL-BOARD-ACCEPTANCE** remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority.

Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-10 whole-chip remain **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-11-A09R2-IMPL-ROUTE-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw routed reports, instantiate-not-copy of `a7ng_astra_09_r2_cand_ovf`, frozen leftover A09 not compiled, hash-before-impl including `.svh`, real clock-network (not virtual), WNS=+0.648 ≥ 0, TNS=0, PROGRAM=NO, no bitstream, `PRODUCTION_TOP=UNKNOWN`, prior leftover A09 wrap / wrap-route / SOC-WRAP bags not overwritten, no BOARD_PASS / ASTRA-13 / LM06 / UART overclaim, no theft of A09 wrap WNS=+1.041 or wrap-route +5.733.

Not PASS (Master ASTRA-11 fullchip, ASTRA-13 board, UART/BRAM plant, LED I/O timing, un-folded QSE occupancy, `PRODUCTION_TOP` freeze).  
Not FAIL (raw WNS matches claim; route 0 error / 0 critical; frozen R2/SGD/leftover A09/F2R/persist unpatched; leftover A09 not compiled; clock path real; A09 wrap bag intact).  
Not OVERCLAIM (ACK/RESULTS keep Master 11/13/BOARD/UART/LM06/`PRODUCTION_TOP` open; do not steal leftover A09 wrap +1.041, wrap-route +5.733, or OOC +2.283).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared routed-WNS-at-50 MHz-with-clock-network claim.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this WNS=+0.648 to BOARD_PASS, ASTRA-13, leftover A09 wrap WNS=+1.041, wrap-route WNS=+5.733, ASTRA-11-SOC-WRAP close, OOC WNS=+2.283, or `PRODUCTION_TOP=a7ng_astra_09_r2_cand_ovf`.
2. Do **not** add this LUT/FF to leftover A09 wrap 1305/1075 or wrap-route 4244/3810, or treat BRAM=0 as a contradiction of wrap-route BRAM=2. Whole-chip co-fit needs **one** current-source SoC top (Master ASTRA-11).
3. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
4. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv` (leftover `ans=4` hole remains in that file) and do **not** patch frozen R2 DUT from synth 8-7137 / DRC DSP warnings.
5. Parent next residual is **not** silent Master ASTRA-11 / ASTRA-13 close. Remaining: SoC UART wrap as a frozen top (if that is still the production path), whole-chip plant, bitstream policy, board, and an explicit `PRODUCTION_TOP` decision. Not this wrap’s job.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated implement+route of instantiated frozen `a7ng_astra_09_r2_cand_ovf` at declared 50 MHz with **real routed clock-network**, WNS=+0.648 ≥ 0, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`, leftover A09 not compiled, ASTRA-11-A09-IMPL-ROUTE-01 not overwritten.

`REJECT_PROMOTION` — Master **ASTRA-11** (fullchip co-fit / SoC UART wrap), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`.

Master ASTRA-09: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-11-SOC-WRAP historical WNS=-4.765: **untouched, still not BOARD**.  
ASTRA-11-A09-IMPL-ROUTE-01 leftover A09 wrap WNS=+1.041: **untouched, different DUT**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1630Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-11-A09R2-IMPL-ROUTE-01; Master ASTRA-11/13 OPEN; raw routed WNS=+0.648 TNS=0.000 WHS=+0.126 (Design State Routed, clk50u 20.000 ns, SCD=6.319 ns E3 IBUF→MMCM→BUFG→u_a09r2/clk routed fo=1103); PROGRAM=NO; BOARD still blocked YES.
