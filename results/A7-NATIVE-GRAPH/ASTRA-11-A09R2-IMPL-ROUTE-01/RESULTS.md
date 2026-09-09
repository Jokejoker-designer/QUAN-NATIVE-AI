# RESULTS — ASTRA-11-A09R2-IMPL-ROUTE-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. ASTRA-09-R2-CAND-OVF-01 /
ASTRA-11-A09-IMPL-ROUTE-01 / ASTRA-10 / ASTRA-09 / ASTRA-11-SOC-WRAP* / F2R-* /
F3-* / ASTRA-06-* bags not edited. Frozen A09-R2 DUT instantiated, not
copy-pasted. Frozen `a7ng_astra_09_integ_path.sv` not compiled as DUT.
A09 wrap WNS=+1.041 bag not overwritten. Wrap-route WNS=+5.733 bag not overwritten.
LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened. PRODUCTION_TOP=UNKNOWN.

```text
GATE             = ASTRA-11-A09R2-IMPL-ROUTE-01
TOP              = a7ng_astra_11_a09r2_impl_wrap
DUT_MODULE       = a7ng_astra_09_r2_cand_ovf
DUT_INSTANCE     = u_a09r2
PART             = xc7a100tcsg324-1
VIVADO           = 2026.1  Build 6511674
PIN_CLK          = CLK100MHZ E3  period 10.000 ns  (100.000 MHz site)
PIPE_CLK         = clk50u  period 20.000 ns  (50.000 MHz)  MMCM 100→50 + BUFG
MODE             = synth_design (in-context) ; opt_design ; place_design ; route_design
ROUTE            = COMPLETE  (route_status.rpt: nets with routing errors = 0)
MARKER           = ASTRA_11_A09R2_IMPL_ROUTE_DONE WNS=0.648 TNS=0.000 WHS=0.126 BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN
RESULT           = PASS_NARROW (this bag only: routed WNS at declared 50 MHz with clock-network)
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
PRODUCTION_TOP   = UNKNOWN
```

## One unknown (answered)

After implement+route of wrapper `a7ng_astra_11_a09r2_impl_wrap` instance
**`u_a09r2` = frozen `a7ng_astra_09_r2_cand_ovf`** on `xc7a100tcsg324-1` at declared
50 MHz (MMCM-derived `clk50u`, clock-network delay included):

Quoted from raw `timing_route.rpt` (Design State = **Routed**, 21:26:25):

```text
WNS(ns)=0.648  TNS=0.000  WHS=0.126  THS=0.000
TNS Failing Endpoints=0  THS Failing Endpoints=0
Clock clk50u  Period=20.000 ns  Frequency=50.000 MHz
All user specified timing constraints are met.
Intra clk50u WNS=0.648  WHS=0.126  failing endpoints=0
```

WNS **≥ 0**. No bitstream. Bounded WNS<0 experiment **not run** (not applicable).

This is **not** ASTRA-11-A09-IMPL-ROUTE-01 routed WNS=+1.041 (different DUT
`a7ng_astra_09_integ_path`). This is **not** ASTRA-10 OOC synth WNS=+2.283
(Design State Synthesized). Clock path on the routed worst setup path:

```text
E3 IBUF → MMCME2_ADV_X1Y2 u_mmcm/CLKOUT0 → BUFGCTRL_X0Y16 u_bufg50/O
→ net (fo=1103, routed) u_a09r2/clk
Source Clock Delay = 6.319 ns   Destination Clock Delay = 5.962 ns
Requirement = 20.000 ns
Source  u_a09r2/FSM_sequential_st_reg[3]/C
Dest    u_a09r2/u_sgd/w_reg[10][3]/D
Data Path Delay = 19.117 ns  (logic 10.083 / route 9.034)  DSP48E1 present
Slack (MET) = 0.648 ns
```

`clocks_route.rpt`: `clk50u` generated from `u_mmcm/CLKOUT0`, master `sys_clk_pin`
10.000 ns. `clock_util_route.rpt`: MMCM=1, BUFGCTRL=1 at BUFGCTRL_X0Y16, 1103
clock loads, period 20.000. Not a virtual clock.

## DUT identity (raw `vivado.log`, not RESULTS)

`synth_design -top a7ng_astra_11_a09r2_impl_wrap -part xc7a100tcsg324-1`
(in-context, **not** `-mode out_of_context`).

Synthesized: wrap (MMCME2_BASE + BUFG) → **`u_a09r2` `a7ng_astra_09_r2_cand_ovf`**
→ `u_sp` `a7ng_query_axi_sparse` (LAW_SEL=1, N_BUCKETS=4096, CAND_CAP=16) →
`g_law.u_qse` + `u_walk`; `u_sgd` `a7ng_shared_rank_sgd_q8_sym_f2r2`.
Marker `U_A09R2_CELLS=11008`.

**Not synthesized:** `a7ng_astra_09_integ_path` (zero `synthesizing module
'a7ng_astra_09_integ_path'` lines), `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`,
UART, `a7ng_axi_bram128`. File list forbids those.

## Resources (raw rpts)

Quoted **synth** `util_synth.rpt` Design State Synthesized:

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **5251** | 63400 | 8.28 |
| Slice Registers (FF) | **4198** | 126800 | 3.31 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |

Quoted **routed** `util_route.rpt` Design State Routed 21:26:25:

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **1321** | 63400 | 2.08 |
| Slice Registers (FF) | **1103** | 126800 | 0.87 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |
| Bonded IOB | **13** | 210 | 6.19 |

Hierarchical routed (`util_hier_route.rpt`): wrap LUT=1321; **`u_a09r2` LUT=1278
FF=1089 DSP=2**; `u_sgd` LUT=533 FF=615 DSP=2; `u_sp` LUT=489. Synth-to-route LUT
drop is opt of I/O-folded constants (AXI slave tied idle; stim = sw/btn). SGD
DSP48E1 ×2 remains on the routed worst path. **Not** wrap-route BRAM=2 (no
`a7ng_axi_bram128` in this instance).

Do **not** add these LUT/FF to wrap-route 4244/3810, to A09 wrap 1305/1075, or to
ASTRA-10 OOC 5178/4155 as a whole-chip sum.

## Comparison (not identity)

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 1321 | 1103 | 0 | 2 | **Routed clk50u +0.648** |
| This bag synth | 5251 | 4198 | 0 | 2 | Synthesized (not the quote) |
| ASTRA-11-A09-IMPL-ROUTE-01 routed | 1305 | 1075 | 0 | 2 | Routed different DUT **+1.041** — not overwritten |
| ASTRA-10 OOC synth | 5178 | 4155 | 0 | 2 | OOC unplaced **+2.283** — not this result |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |

## Hashes

SHA freeze BEFORE impl `2026-09-06T21:22:38.8813461+07:00`.
Vivado start `Sun Sep 6 21:22:39 2026`. Frozen A09-R2 DUT `15a919f1…` MATCH
ASTRA-09-R2-CAND-OVF-01. Frozen A09 leftover `9fdbe0d6…` MATCH provenance
(not compiled). Frozen SGD `b66ef328…` MATCH. Prior A09 wrap
`399aa22a…` MATCH (not edited). Compiled RTL+XDC+tcl + `.svh` PRE/POST
**16/16 MATCH**. `write_bitstream` renamed to abort; never invoked. No `.bit`
in bag.

## Open (unchanged)

Master ASTRA-09 production path. Master F3 10pp/CI. Master ASTRA-06 DDR/NVM.
Master ASTRA-10 whole-chip. LM06. BOARD_PASS. ASTRA-13. ASTRA-11 SoC UART wrap.
PRODUCTION_TOP identity. Do **not** call this BOARD_PASS, A09 wrap WNS=+1.041,
wrap-route WNS=+5.733, or OOC WNS=+2.283. Manager independently accepts. Do not
autonomously open the next gate. Do not freeze PRODUCTION_TOP.
