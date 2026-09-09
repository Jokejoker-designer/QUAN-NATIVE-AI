# ASTRA auditor REPORT — 20260906T1330Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA10_RESOURCE_BOUND_INDEPENDENT_AUDIT; astra10=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; astra09=AUDITOR_PASS_NARROW_XSIM_SMOKE; master_astra09=OPEN; master_f3=OPEN; program=false; board_pass=false
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-10 (§7 table + §6 preferred envelope) + work order ASTRA-10-RESOURCE-BOUND-01 + prior auditor 20260906T1300Z (A09 XSim CLOSED_NARROW)
EVIDENCE   = raw util_synth.rpt / timing_synth.rpt / util_opt.rpt / timing_opt.rpt / util_hier_synth.rpt / ram_synth.rpt / clocks_synth.rpt / vivado.log / vivado_fail_r0.log / wrap SV / tcl / XDC / SHA manifests / PREREG (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, place, route, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not rerun `run_synth.ps1` / `run_synth.tcl` (would overwrite `vivado.log` / reports).

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to ASTRA-09 / persist / F2R3–F2R5 / T1300Z overlapping hashes.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-10-RESOURCE-BOUND-01/`

Top `a7ng_astra_10_resource_wrap` (bag-local) instance **`u_a09` = frozen `rtl/native_graph/integrate/a7ng_astra_09_integ_path.sv`**. Clock bag-local `clk50_ooc.xdc` period 20.000 ns. Part `xc7a100tcsg324-1`. Mode `synth_design -mode out_of_context` then `opt_design`. No bitstream.

Gate under review is **work-order ASTRA-10-RESOURCE-BOUND-01 only** — one unknown: post-synth LUT/FF/BRAM/DSP and a WNS at a declared clock for a **named wrapper that instantiates** `a7ng_astra_09_integ_path` (not a copy-paste graph), without a bitstream. **Not** Master ASTRA-10 close.

Hunt (parent / work order / this dispatch):

1. Quote LUT/FF/BRAM/DSP/WNS from **raw** reports (Design State). Implementer claimed synth LUT=5178 FF=4155 BRAM=0 DSP=2 WNS=+2.283 @50 MHz.
2. Is WNS OOC (no clock-network delay) vs implemented wrap-route WNS? Must not be called BOARD_PASS or ASTRA-11 WNS.
3. BRAM=0 vs wrap-route BRAM=2 — honest incomparability?
4. Fail r0 preserved? Bitstream generated? PROGRAM=NO?
5. Hash before synth? `.svh` included?
6. Overclaim Master ASTRA-10/09/BOARD?

Judged against:

1. Work order `.agents/handoff/ASTRA-10-RESOURCE-BOUND-01.md` + PREREG: instantiate frozen A09 DUT; hash RTL+XDC+tcl before synth; synth-only (opt/place OK if PROGRAM=NO); no `write_bitstream`; compare to DESIGN_CANDIDATE / prior wrap-route BRAM=2 **if comparable**; do not claim BOARD_PASS or WNS of a different wrapper.
2. **Master ASTRA-10** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *“Current-source whole-chip resource reconciliation; early preflights may run earlier in isolated bags.”* Preferred envelope (§6 / DESIGN_CANDIDATE): LUT≤40k, FF≤50k, DSP≤32, BRAM36eq≤115 — **targets, not measured results, not this close.**
3. Auditor `20260906T1300Z`: ASTRA-09 XSim CLOSED_NARROW; Master ASTRA-09 OPEN; parent chose ASTRA-10 resources (no LM06, no 65536-scale, no BOARD).

**Master ASTRA-10 as a whole is not this bag’s close**, even if OOC numbers sit inside the preferred envelope.

Out of this bag’s close: whole-chip co-fit (UART + MMCM + I/O + AXI BRAM plant + A09 path together), post-route/implemented WNS, ASTRA-11 source/config freeze + full impl from frozen manifest, LM06, BOARD_PASS, ASTRA-13, Master ASTRA-09 production path, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, ASTRA-07 index image.

Frozen `a7ng_astra_09_integ_path.sv` / `.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, F2R3/F2R4/F2R5, persist/R2/R3/R4, `a7ng_astra09_pipe.sv`, `a7ng_axi_bram128.sv` must remain **unpatched**. This wrap is a **new named** synth wrapper. It must **instantiate** A09, not copy the graph. It must **not** compile `astra09_pipe` / `axi_bram128`.

Prior bags `ASTRA-SOC-RTP-WRAP-ROUTE`, `ASTRA-11-TIMING-FIX`, `ASTRA-10-OOC-RESOURCE`, `ASTRA-10B-OOC-ASTRA09-PIPE`, `ASTRA-09-INTEGRATED-PATH-01` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### 1. Raw synth util / timing (authority)

`util_synth.rpt` header:

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Sun Sep  6 19:18:49 2026
Design       : a7ng_astra_10_resource_wrap
Device       : xc7a100tcsg324-1
Design State : Synthesized
```

Quoted **Design State = Synthesized**:

```text
| Slice LUTs*             | 5178 |     0 |          0 |     63400 |  8.17 |
|   LUT as Logic          | 5178 | ...
|   LUT as Memory         |    0 | ...
| Slice Registers         | 4155 |     0 |          0 |    126800 |  3.28 |
|   Register as Flip Flop | 4155 | ...
| Block RAM Tile |    0 |     0 |          0 |       135 |  0.00 |
|   RAMB36/FIFO* |    0 | ...
|   RAMB18       |    0 | ...
| DSPs           |    2 |     0 |          0 |       240 |  0.83 |
|   DSP48E1 only |    2 | ...
| Bonded IOB                  |    0 |     0 |          0 |       210 |  0.00 |
```

Implementer claim **LUT=5178 FF=4155 BRAM=0 DSP=2 MATCHES raw synth util**. `LUT as Memory = 0` (no distributed-RAM substitute for BRAM). `Bonded IOB = 0` is OOC (no I/O placed).

`timing_synth.rpt` header:

```text
Date         : Sun Sep  6 19:18:50 2026
Design       : a7ng_astra_10_resource_wrap
Device       : 7a100t-csg324
Design State : Synthesized
```

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  ...      WHS(ns)      THS(ns)  ...
      2.283        0.000                      0                 6770        0.256        0.000                      0                 6770        9.500        0.000                       0                  4155
All user specified timing constraints are met.
clk50  {0.000 10.000}     20.000          50.000
Intra clk50               2.283        0.000  ...  WHS 0.256
```

Implementer claim **WNS=+2.283 @ 50 MHz MATCHES raw synth timing**. TNS=0.000 WHS=0.256 THS=0.000. Clock name `clk50` period 20.000 ns.

Worst setup path (same rpt): `Slack (MET) : 2.283ns`; source `u_a09/pc2_reg[2][1]/C` → dest `u_a09/u_sgd/w_reg[0][15]/D`; **Requirement 20.000 ns**; Data Path Delay 17.677 ns (logic 10.744 / route 6.933); 22 logic levels including **DSP48E1**; nets marked **`unplaced`**. Clock edges `<hidden>`. Source clk net: `net (fo=4154, unset) 0.973`. Destination clk net: `net (fo=4154, unset) 0.924`.

`clocks_synth.rpt`: `clk50  20.000  {0.000 10.000}  P  {clk}`. No generated/MMCM clock. Not wrap-route `clk50u`.

`ram_synth.rpt`: `BlockRAM 0 / 135`; `LUTMs as Distributed RAM 0 / 19000`.

`util_hier_synth.rpt` Design State Synthesized 19:18:49:

```text
| a7ng_astra_10_resource_wrap | (top)                    | 5178 | 5178 | 0 | 0 | 4155 | 0 | 0 | 2 |
|   u_a09                     | a7ng_astra_09_integ_path | 5178 | 5178 | 0 | 0 | 4155 | 0 | 0 | 2 |
|     (u_a09)                 | a7ng_astra_09_integ_path | 1658 | ...  |     |   | 2669 | 0 | 0 | 0 |
|     u_sgd                   | a7ng_shared_rank_sgd_q8_sym_f2r2 | 631 | ... |   |   |  615 | 0 | 0 | 2 |
|     u_sp                    | a7ng_query_axi_sparse    | 2889 | ...  |     |   |  871 | 0 | 0 | 0 |
|       u_walk                | a7ng_sparse_dir_axi      |  542 | ...
|       g_law.u_qse           | a7ng_query_role_extract  | 2347 | ...
```

Wrap LUT **equals** `u_a09` LUT (transparent wrapper). DSP=2 is entirely in frozen `u_sgd`. No `astra09_pipe`, no `axi_bram128`, no RAMB* in the hierarchy.

`opt_design` (`util_opt.rpt` / `timing_opt.rpt`, Design State = **Optimized**, 19:18:57 / 19:18:59): LUT **5174**, FF **4155**, BRAM **0**, DSP **2**, WNS **2.283**, WHS **0.256**. Primary quote remains **synth** (PREREG/CLOSEOUT). Opt is allowed; not a second unknown.

`UTIL_EXTRACT.txt` / `TIMING_EXTRACT.txt` / `metrics.json` match the raw synth numbers. No RESULTS vs raw-rpt contradiction on LUT/FF/BRAM/DSP/WNS.

### 2. WNS class: OOC post-synth, not implemented wrap-route, not BOARD, not ASTRA-11

Raw `vivado.log` (R1, kept reports):

```text
Command: synth_design -mode out_of_context -top a7ng_astra_10_resource_wrap -part xc7a100tcsg324-1
...
WARNING: [Timing 38-242] The property HD.CLK_SRC of clock port "clk" is not set. In out-of-context mode, this prevents timing estimation for clock delay/skew
```

Same warning after `opt_design`. Path group is bag-local `clk50` from `create_clock -period 20.000 -name clk50 [get_ports clk]` (`clk50_ooc.xdc`). No board pin, no MMCM, no `clk50u`.

Precision vs RESULTS wording: RESULTS quotes 38-242 as “clock delay/skew is not estimated.” The worst-path table still prints SCD=0.973 ns / DCD=0.924 ns on an **`unset` unplaced** clk net with `<hidden>` source. That is **not** a routed clock-network delay from a BUFG/MMCM location. It is **not** wrap-route WNS.

Implemented wrap-route (`ASTRA-SOC-RTP-WRAP-ROUTE/timing.rpt`, Design State **Routed**, date **Sun Sep 6 02:11:51** — **not overwritten** by this 19:18 session):

```text
Design       : arty_a7_astra_rtp_soc_top
clk50u intra WNS = 7.150   (period 20.000 ns)
summary WNS      = 5.733   (path group async_default clk50u→clk50u)
clock nets       = routed
```

Those numbers belong to a **different wrapper** (`arty_a7_astra_rtp_soc_top` + MMCM + UART + `a7ng_axi_bram128`). This bag’s WNS=+2.283 must **not** be called wrap-route WNS, ASTRA-11 WNS, or BOARD_PASS.

`check_timing` in `timing_synth.rpt`: `no_input_delay` 238 (HIGH), `no_output_delay` 425 (HIGH), `no_clock` 0, `unconstrained_internal_endpoints` 0. Quoted WNS is **internal register-to-register** under the OOC 20 ns clock, with unconstrained I/O. Expected for this mode; not a silent I/O timing close.

Implementer RESULTS/CLOSEOUT/ACK: “Not a routed board WNS. Not MMCM `clk50u`.” “Do not claim wrap-route WNS.” **Honest.**

### 3. BRAM=0 vs wrap-route BRAM=2 — honest incomparability

This instance: AXI master ports at wrap top; **no** `a7ng_axi_bram128`. Raw: Block RAM Tile **0**, RAMB36 **0**, RAMB18 **0**, LUTRAM **0**. Sparse index is an AXI master (`m_axi_*` on wrap). BRAM=0 is the expected measurement of **this** netlist.

Wrap-route raw `ASTRA-SOC-RTP-WRAP-ROUTE/util.rpt` Design State **Routed** 02:11:51:

```text
Design       : arty_a7_astra_rtp_soc_top
| Slice LUTs              | 4244 | ...
| Slice Registers         | 3810 | ...
| Block RAM Tile    |    2 |     0 |          0 |       135 |  1.48 |
DSP (RESULTS/UTIL_EXTRACT) = 0
```

BRAM_TILE=2 is `u_sram` / `a7ng_axi_bram128` 256×128 in that SoC, **not** this A09 resource wrap. LUT/FF/DSP also differ (4244/3810/0 vs 5178/4155/2). **Not comparable as the same instance.** Implementer table states this. **Not a cheat to report BRAM=0 here.**

Prior isolated OOC (raw, different DUTs; bags not overwritten):

| Bag | DUT | LUT | FF | BRAM | DSP |
|-----|-----|----:|---:|-----:|----:|
| This bag synth | `a7ng_astra_09_integ_path` via wrap `u_a09` | 5178 | 4155 | 0 | 2 |
| `ASTRA-10B-OOC-ASTRA09-PIPE/util_ooc.rpt` | `a7ng_astra09_pipe` | 3707 | 2364 | 0 | 2 |
| `ASTRA-10-OOC-RESOURCE/util_ooc.rpt` | `a7ng_unified_pipe` | 2966 | 1386 | 0 | 2 |
| Wrap-route routed | `arty_a7_astra_rtp_soc_top` | 4244 | 3810 | **2** | 0 |

Larger LUT than 10B is consistent with a **different** (A09 integ-path) DUT, not a copied 10B netlist. Envelope LUT 5178 ≤ 40000, FF 4155 ≤ 50000, DSP 2 ≤ 32, BRAM 0 ≤ 115 is a **preferred-target check**, not whole-chip reconciliation. Implementer: “not this close / not Master ASTRA-09 / not BOARD_PASS.”

### 4. Fail r0 preserved? Bitstream? PROGRAM=NO?

`vivado_fail_r0.log` **exists** and is a **complete successful** session, not a synth crash:

```text
Start of session at: Sun Sep  6 19:13:09 2026
Process ID         : 31004
-log .../vivado.log
synth_design completed successfully
Synth Design complete | Checksum: b3a00d7
ASTRA_10_RESOURCE_BOUND_SYNTH_DONE
U_A09_CELLS=10890
opt_design completed successfully
ASTRA_10_RESOURCE_BOUND_OPT_DONE
ASTRA_10_RESOURCE_BOUND_DONE PROGRAM=NO BIT=NOT_BUILT
Exiting Vivado at Sun Sep  6 19:16:06 2026
```

R1 `vivado.log` (copy of `vivado_r1.log`):

```text
Start of session at: Sun Sep  6 19:16:07 2026
Process ID         : 46400
-log .../vivado_r1.log
Synth Design complete | Checksum: b3a00d7   ← same as R0
U_A09_CELLS=10890
ASTRA_10_RESOURCE_BOUND_DONE PROGRAM=NO BIT=NOT_BUILT
Exiting Vivado at Sun Sep  6 19:18:59 2026
```

R0 was **not** a Vivado FAIL. RESULTS: PS1 captured Vivado stdout as `$exit` and treated it as FAIL; one bounded R1 rerun; `run_synth.ps1` patched **after** synth to return `cmd` LASTEXITCODE. Current `run_synth.ps1` uses `[int]$LASTEXITCODE` and still contains the R0/R1 copy logic — consistent with a **post-run CONFIG patch**. Compiled hashes (tcl/wrap/xdc/rtl) unchanged (PRE=POST).

R1 **overwrote** `util_*.rpt` / `timing_*.rpt` (kept-report timestamps 19:18:49–19:18:59 are R1). R0 log is preserved. Same synth checksum `b3a00d7` ⇒ same netlist class. Process smell, **not** golden-edit of WNS. Handoff “if FAIL: keep the log; one bounded re-run” was followed in form; the “FAIL” was a runner bug.

Bitstream: **not generated**. Bag listing has `ckpt/synth.dcp` (`write_checkpoint` after synth — allowed) and **no** `.bit`. Logs/jou: no `write_bitstream`, `place_design`, `route_design`, `program_hw`, `open_hw_manager`, `hw_server`, `xsdb`. TCL `astra_forbid_bit` / `exit 0` after opt. Marker `BIT=NOT_BUILT`. ACK `PROGRAM: false`, `write_bitstream: false`. LOOP_STATE `program=false`. **PROGRAM=NO holds.**

`vivado.jou` is the R1 session (19:16:07, PID 46400) sourcing `run_synth.tcl` only. Backup `vivado_31004.backup.jou` matches R0 PID.

### 5. Hash before synth? `.svh` included? Instantiated not copied? Frozen files unpatched?

**Hash order**

- `SHA256.txt` / `SOURCE_HASHES.txt`: **BEFORE synth** `2026-09-06T19:13:08.0982366+07:00`
- R0 Vivado start: `19:13:09` (1 s later)
- R1 reports: `19:18:49–19:18:59`
- `SHA256_POST.txt`: **AFTER synth** `2026-09-06T19:20:34.5953820+07:00`

`run_synth.ps1` writes SHA256 of compiled + `.svh` + CONFIG + provenance **then** calls Vivado. Not hash-after-scores theatre on compiled sources.

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
| bag `a7ng_astra_10_resource_wrap.sv` | `e6790804b38f51c2cd608ba94c75924daaa0add83e6998b639b44b523d2c7908` |
| bag `clk50_ooc.xdc` | `69b31bb3385cf40cafef4571c0a29a60e7830d2dc965a054c0040a6f249e14da` |
| bag `run_synth.tcl` | `7a31bac30ce22fb5698f16634c033249bc99a0d93a5e05cbe5877e43959e352e` |
| `a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `a7ng_astra_09_integ_path.svh` | `ad2d66d4783bba33cfbd324fc0a9661fb2a46eeaffb5b4fb6989246fb4e94302` |

Those eight RTL + four `.svh` strings **MATCH** `ASTRA-09-INTEGRATED-PATH-01/SHA256.txt` (freeze 18:53:00, before A09 xvlog). Frozen A09 DUT and F2R2 SGD were **not patched** between A09 XSim and this synth.

Provenance (hashed, **not compiled**); MATCH A09 bag + auditor T1300Z:

| File | SHA256 |
|------|--------|
| `a7ng_astra_06_warm_persist.sv` | `52ebde5250a8740032667eea2ccd2fccc25f96ff6317d85fd06795ee6aa317b1` |
| `a7ng_astra_06_r2_evict_highid.sv` | `c671f98b2518830d23a9a171bbf60386db2cbc628e9bbe30f7e970a3d83c037b` |
| `a7ng_astra_06_r3_multi_slot.sv` | `99ee5d93dd18b3f146b433d521ab706038141cb8648afab17d315bd1ce8c186f` |
| `a7ng_astra_06_r4_sess_reuse.sv` | `4bd94762c62c0d749ff85f35fb5523eab1c251c210daf9c42997802a25f696f4` |
| `a7ng_astra_f2r3_sem_guard.sv` | `9a7a5941b5ee2522c0491808d7cb23b5f7d58520ace19ac46bd3b9edfd324489` |
| `a7ng_astra_f2r4_axi_drain.sv` | `5cdb3da8c53d22333e2af847c839439f1a9e5ee05c4b307194c7236c70fe407b` |
| `a7ng_astra_f2r5_txn_wrap.sv` | `41c77e76fb5bc179b133bbdeba563f8484d3cc5e699438af3cfc521b2f75895b` |

TCL compile list is the A09 set + wrap; `foreach` aborts on `a7ng_astra09_pipe.sv` / `axi_bram128`. Those two are hashed under KEEP_NOT_THIS_WRAPPER and **not** in `read_verilog`.

`.svh`: PRE `TRANSITIVE_INCLUDES` before synth. DUT line 7: `` `include "a7ng_astra_09_integ_path.svh" ``. TCL `set_property include_dirs` query/control/integrate. Vivado log does not print `.svh` filenames (normal unless error). Elaboration succeeded with A09 parameters from that include path.

**Instantiate, not copy-paste**

Bag contains `a7ng_astra_10_resource_wrap.sv` only as RTL (no copied `a7ng_astra_09_integ_path.sv` in the bag). Wrap:

```text
(* keep_hierarchy = "yes" *)
a7ng_astra_09_integ_path u_a09 ( ... );
assign w0_o = w[0];
```

No QSE/sparse/2-hop/SGD duplicated in the wrap. Frozen A09 DUT still instantiates `a7ng_query_axi_sparse` + `a7ng_shared_rank_sgd_q8_sym_f2r2 u_sgd` (`a7ng_astra_09_integ_path.sv:257, :290`). `load_from_tb_o` still `assign = 1'b0` (`:144`).

Raw log elaboration (not RESULTS):

```text
synthesizing module 'a7ng_astra_10_resource_wrap' [.../ASTRA-10-RESOURCE-BOUND-01/a7ng_astra_10_resource_wrap.sv:6]
synthesizing module 'a7ng_astra_09_integ_path' [.../rtl/native_graph/integrate/a7ng_astra_09_integ_path.sv:9]
synthesizing module 'a7ng_query_axi_sparse' [...]
  N_BUCKETS = 4096 (32'h00001000)
  CAND_CAP  = 16
  ID_W      = 20
  LAW_SEL   = 1
synthesizing module 'a7ng_query_role_extract'
synthesizing module 'a7ng_sparse_dir_axi'
synthesizing module 'a7ng_shared_rank_sgd_q8_sym_f2r2'
DSP Final Report: a7ng_shared_rank_sgd_q8_sym_f2r2 ×2 (C+A*B, A*B)
U_A09_CELLS=10890
Synthesis finished with 0 errors, 0 critical warnings and 6 warnings.
synth_design: 0 Critical Warnings and 0 Errors
opt_design: 0 Critical Warnings and 0 Errors
```

No `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, `a7ng_axi_bram128`, F2R3/F2R4/F2R5, persist/R2/R3/R4 in the synthesize-module list. **Required instantiate-not-copy: MET.**

CONFIG hash of `run_synth.ps1` in `SHA256.txt` is the **pre-patch** file. Live ps1 was edited after synth (LASTEXITCODE). Documented in RESULTS. **Compiled** freeze intact. Stale CONFIG hash is a residual, not DUT theatre.

PREREG contains **no** LUT/WNS numbers (written as policy before synth). Resource numbers appear only in RESULTS/CLOSEOUT/metrics after the run.

Wrap-route `util.rpt` date remains **02:11:51**; ASTRA-11-TIMING-FIX RESULTS still the 50 MHz MMCM timing-fix text. Those bags were **not** overwritten.

### 6. Overclaim Master ASTRA-10 / 09 / BOARD?

Implementer language (RESULTS/CLOSEOUT/ACK/PREREG):

- `RESULT = PASS_NARROW (this bag only: post-synth resource + declared-clock WNS)` / `PASS_THIS_GATE_ONLY`
- `BIT = NOT_BUILT`, `PROGRAM = NO`
- Explicitly **does not close** Master ASTRA-09, Master F3, Master ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11 SoC UART wrap
- Explicitly **does not claim** wrap-route WNS or BRAM=2 for this instance

Master ASTRA-10 requirement vs this bag:

| Master ASTRA-10 | This bag |
|---|---|
| Current-source **whole-chip** resource reconciliation | Isolated OOC synth of A09 integ-path + thin wrap; no MMCM, UART, I/O, AXI BRAM plant, SoC top |
| Early preflights **may** run earlier in isolated bags | This **is** that allowed preflight |
| Preferred LUT≤40k / FF≤50k / DSP≤32 / BRAM≤115 | 5178 / 4155 / 2 / 0 sits inside envelope; **not** measured whole-chip |
| OOC ≠ POST_ROUTE ≠ BOARD (Master §10) | OOC synth WNS only |

No BOARD_PASS claim. No ASTRA-11 WNS claim. No Master ASTRA-09 close. No LM06 language. **No Master-gate overclaim found.**

---

## Overclaim / cheat / tautology

| Hunt | Finding |
|------|---------|
| RESULTS vs raw rpt mismatch | **None** on LUT/FF/BRAM/DSP/WNS |
| Copy-paste graph called instantiate | **Not found.** Thin wrap + live RTL path in synth log |
| Stub / empty DUT | **Not found.** Hier LUT 5178 in `u_a09`; QSE+walker+SGD+DSP48E1 |
| BRAM=0 used as wrap-route BRAM=2 | **Not claimed.** Honest incomparability |
| OOC WNS called BOARD / ASTRA-11 / wrap-route | **Not claimed.** 38-242 + unplaced/`unset` clk documented |
| Hash freeze after looking at WNS | **Not found** for compiled set (PRE 19:13:08 < synth 19:13:09) |
| Edit golden / expected to manufacture PASS | N/A (no numeric golden; quote from rpt) |
| Timing-fail bit called BOARD_PASS | No bit; PROGRAM=NO |
| R0 wipe | Log **kept**; reports replaced by R1 with **same checksum** |
| Frozen F2R/F3/persist patched | Manifest SHA MATCH A09 + T1300Z; not compiled here |
| `astra09_pipe` / `axi_bram128` slipped in | Forbidden in tcl; absent from synth module list |
| CONFIG ps1 patched after synth | **True**; documented; not compiled-hash cheat |
| Envelope ≤40k called Master ASTRA-10 close | **Not claimed** |

qstack adversary: worst path is a real unplaced SGD update (pc2 → `u_sgd` w_reg through DSP48E1), not a tautological false path. I/O unconstrained does **not** manufacture the internal 2.283 ns slack. `keep_hierarchy` prevents accidental wrap-only util.

---

## Logic bugs

No synth FAIL. No critical warnings. No RESULTS/raw contradiction on the quoted resources/WNS.

Residuals (not this-bag FAIL):

1. Quoted WNS is **OOC post-synth unplaced** with `HD.CLK_SRC` unset. Optimistic vs implemented clock-network + routing. Must not travel as ASTRA-11 / BOARD WNS.
2. R0 was a successful Vivado run misclassified by PS1; R1 overwrote reports. Same checksum. Runner patched after the fact.
3. CONFIG SHA of `run_synth.ps1` in `SHA256.txt` is stale vs live file.
4. `check_timing` HIGH on all I/O delays — expected OOC, still a gap vs whole-chip.
5. AXI master hanging (no on-chip BRAM) is **intentional** for this instance; whole-chip BRAM/DDR plant remains a **later** bag.
6. This number set is **not** additive with wrap-route 4244 LUT / BRAM=2 (Master: do not sum OOC counts as full-chip).

No DUT logic patch requested. Auditor does not fix.

---

## This bag vs Master ASTRA-10

Work-order unknown **answered**: for wrapper `a7ng_astra_10_resource_wrap` / instance `u_a09` = frozen `a7ng_astra_09_integ_path` on `xc7a100tcsg324-1`, post-synth (Design State Synthesized) is **LUT=5178 FF=4155 BRAM_TILE=0 DSP=2**, declared-clock **WNS=+2.283 ns @ clk50 20.000 ns (50 MHz)**, **BIT=NOT_BUILT**, **PROGRAM=NO**.

Master ASTRA-10 **whole-chip resource reconciliation** remains **OPEN**. Isolated preflight is what Master §7 explicitly allows; it is not permission to mark ASTRA-10 done.

Master ASTRA-09 / F3 / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-13 / ASTRA-11 SoC UART wrap remain **OPEN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-10-RESOURCE-BOUND-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw synth reports, instantiate-not-copy, hash-before-synth including `.svh`, PROGRAM=NO, no bitstream, honest BRAM/WNS incomparability vs wrap-route.

Not PASS (Master ASTRA-10 whole-chip, implemented WNS, I/O/MMCM/BRAM plant).  
Not FAIL (raw numbers match claim; synth 0 error / 0 critical; frozen A09/SGD/F2R/persist unpatched; r0 log kept).  
Not OVERCLAIM (ACK/RESULTS keep Master 10/09/BOARD/ASTRA-11 open; do not steal wrap-route WNS or BRAM=2).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared OOC resource+WNS claim.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this WNS=+2.283 to ASTRA-11, wrap-route, or BOARD_PASS. Next physical timing evidence must be **implemented/routed** on the wrapper that will actually be frozen (MMCM + I/O + clock-network).
2. Do **not** add this LUT/FF/DSP to wrap-route 4244/3810/0 or treat BRAM=0 as a contradiction of wrap-route BRAM=2. Whole-chip reconciliation needs **one** current-source top.
3. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`.
4. Optional: freeze a post-patch `run_synth.ps1` hash in a later bag; do not rewrite this SHA256.txt.
5. Parent next residual is **not** silent Master ASTRA-10 close. Remaining Master §7 items (whole-chip ASTRA-10/11, ASTRA-08 LM, ASTRA-07 scale, ASTRA-09 production path) stay open.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated OOC synth resource+declared-clock WNS for instantiated frozen `a7ng_astra_09_integ_path` only.

`REJECT_PROMOTION` — Master **ASTRA-10** (whole-chip resource reconciliation), **BOARD_PASS**, and **ASTRA-11** implemented WNS are **not** closed.

Master ASTRA-09: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.

PROGRAM=NO. COM12 UNTOUCHED.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1330Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-10-RESOURCE-BOUND-01; Master ASTRA-10 OPEN; raw synth LUT=5178 FF=4155 BRAM=0 DSP=2 WNS=+2.283 (Design State Synthesized, clk50 20.000 ns); PROGRAM=NO.
