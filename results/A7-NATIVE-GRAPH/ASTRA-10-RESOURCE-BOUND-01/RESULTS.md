# RESULTS — ASTRA-10-RESOURCE-BOUND-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream. F2R-* / F3-* / ASTRA-06-* /
ASTRA-09-INTEGRATED-PATH-01 bags not edited. Frozen A09 DUT instantiated, not
copy-pasted. ASTRA-11 wrap-route timing bag not overwritten. LM06 / BOARD /
DDR / Master F3 not opened.

```text
GATE             = ASTRA-10-RESOURCE-BOUND-01
TOP              = a7ng_astra_10_resource_wrap
DUT_MODULE       = a7ng_astra_09_integ_path
DUT_INSTANCE     = u_a09
PART             = xc7a100tcsg324-1
VIVADO           = 2026.1  Build 6511674
CLOCK            = clk50  period 20.000 ns  (50.000 MHz)
MODE             = synth_design -mode out_of_context ; opt_design
SYNTH            = completed successfully  (0 errors, 0 critical warnings)
MARKER           = ASTRA_10_RESOURCE_BOUND_DONE PROGRAM=NO BIT=NOT_BUILT
RESULT           = PASS_NARROW (this bag only: post-synth resource + declared-clock WNS)
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
```

## One unknown (answered)

Post-synth on `xc7a100tcsg324-1` for wrapper `a7ng_astra_10_resource_wrap`
instance **`u_a09` = `a7ng_astra_09_integ_path`** (not a copy-paste graph):

Quoted from raw `util_synth.rpt` (Design State = Synthesized, 19:18:49):

| Resource | Used | Avail | Util% | Raw line |
|----------|-----:|------:|------:|----------|
| Slice LUTs | **5178** | 63400 | 8.17 | `\| Slice LUTs*             \| 5178 \|` |
| Slice Registers (FF) | **4155** | 126800 | 3.28 | `\| Slice Registers         \| 4155 \|` |
| Block RAM Tile | **0** | 135 | 0.00 | `\| Block RAM Tile \|    0 \|` |
| DSPs | **2** | 240 | 0.83 | `\| DSPs           \|    2 \|` |

Quoted from raw `timing_synth.rpt` Design Timing Summary (same session):

```text
WNS(ns)=2.283  TNS=0.000  WHS=0.256  THS=0.000
Clock clk50  Period=20.000 ns  Frequency=50.000 MHz
All user specified timing constraints are met.
Intra clk50 WNS=2.283  WHS=0.256  failing endpoints=0
```

`opt_design` (Design State = Optimized, `util_opt.rpt` 19:18:57): LUT **5174**,
FF **4155**, BRAM **0**, DSP **2**. Timing summary WNS **2.283** / WHS **0.256**
unchanged (`timing_opt.rpt`).

## DUT identity (raw `vivado.log`, not RESULTS)

`synth_design -mode out_of_context -top a7ng_astra_10_resource_wrap -part xc7a100tcsg324-1`.

Synthesized: wrap → **`u_a09` `a7ng_astra_09_integ_path`** → `u_sp`
`a7ng_query_axi_sparse` (LAW_SEL=1, N_BUCKETS=4096, CAND_CAP=16) →
`g_law.u_qse` `a7ng_query_role_extract` + `u_walk` `a7ng_sparse_dir_axi`;
`u_sgd` `a7ng_shared_rank_sgd_q8_sym_f2r2` (DSP48E1 ×2). Marker
`U_A09_CELLS=10890`. Hierarchical util (`util_hier_synth.rpt`): wrap LUT=5178
equals `u_a09` LUT=5178.

**Not synthesized:** `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`,
`a7ng_axi_bram128`, F2R3/F2R4/F2R5, persist/R2/R3/R4. File list forbids those.

## Comparison (not identity)

| Envelope | LUT | FF | BRAM | DSP | Note |
|----------|----:|---:|-----:|----:|------|
| This bag (synth) | 5178 | 4155 | **0** | 2 | `u_a09` OOC |
| DESIGN_CANDIDATE preferred | ≤40000 | ≤50000 | ≤115 | ≤32 | envelope only; not this close |
| ASTRA-SOC-RTP-WRAP-ROUTE post-route | 4244 | 3810 | **2** | 0 | **different wrapper** (`arty_a7_astra_rtp_soc_top` + `a7ng_axi_bram128`) |
| ASTRA-10B OOC `a7ng_astra09_pipe` | 3707 | 2364 | 0 | 2 | **different DUT** |
| ASTRA-10 OOC `a7ng_unified_pipe` | 2966 | 1386 | 0 | 2 | **different DUT** |

Do **not** claim wrap-route WNS (clk50u 7.150 / summary 5.733) or BRAM=2 for this
instance. This wrap has no on-chip AXI BRAM; sparse index is an AXI master.
BRAM=0 is expected and **not comparable** to wrap-route BRAM_TILE=2.

This instance is inside the DESIGN_CANDIDATE preferred LUT/FF/DSP/BRAM envelope.
That is not Master ASTRA-09 close and not BOARD_PASS.

## Clock / WNS caveats (EVIDENCE)

Declared clock is bag-local `clk50_ooc.xdc` `create_clock -period 20.000 -name clk50 [get_ports clk]`.
Vivado warning `Timing 38-242`: `HD.CLK_SRC` of port `clk` unset, so OOC **clock
delay/skew is not estimated**. Reported WNS is cell/net delay vs 20 ns requirement
(`Slack (MET) 2.283ns`, requirement 20.000 ns). Not a routed board WNS. Not
MMCM `clk50u`.

## Hashes

SHA freeze BEFORE synth `2026-09-06T19:13:08.0982366+07:00`.
Vivado session (kept reports) **Sun Sep 6 19:18:49–19:18:59 2026** (`vivado_r1.log`
copied to `vivado.log`). Compiled RTL+XDC+tcl + `.svh` pre/post **15/15 MATCH**.
Frozen A09 DUT `9fdbe0d6…` MATCH ASTRA-09 bag. Frozen SGD `b66ef328…` MATCH.

R0 also printed `ASTRA_10_RESOURCE_BOUND_DONE` (19:13:09–19:16:06); PS1 captured
Vivado stdout as `$exit` and treated it as FAIL. Bounded R1 rerun succeeded with
the same marker. `run_synth.ps1` was patched after synth to return `cmd` LASTEXITCODE
(CONFIG only; compiled hashes unchanged).

## Open (unchanged)

Master ASTRA-09 production path (LM06 generation, UART, PHYS4). Master F3 10pp/CI.
Master ASTRA-06 DDR/NVM. LM06. BOARD_PASS. ASTRA-13. ASTRA-11 SoC UART wrap.
Do **not** call this BOARD_PASS, wrap-route WNS, or Master ASTRA-09 closed.
Manager independently accepts. Do not autonomously open the next gate.
