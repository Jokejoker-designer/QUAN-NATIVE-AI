# RESULTS — ASTRA-11-A09-IMPL-ROUTE-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. ASTRA-10 / ASTRA-09 /
ASTRA-11-SOC-WRAP* / F2R-* / F3-* / ASTRA-06-* bags not edited. Frozen A09 DUT
instantiated, not copy-pasted. Wrap-route WNS=+5.733 bag not overwritten.
LM06 / BOARD / DDR / Master F3 not opened.

```text
GATE             = ASTRA-11-A09-IMPL-ROUTE-01
TOP              = a7ng_astra_11_a09_impl_wrap
DUT_MODULE       = a7ng_astra_09_integ_path
DUT_INSTANCE     = u_a09
PART             = xc7a100tcsg324-1
VIVADO           = 2026.1  Build 6511674
PIN_CLK          = CLK100MHZ E3  period 10.000 ns  (100.000 MHz site)
PIPE_CLK         = clk50u  period 20.000 ns  (50.000 MHz)  MMCM 100→50 + BUFG
MODE             = synth_design (in-context) ; opt_design ; place_design ; route_design
ROUTE            = COMPLETE  (route_status.rpt: failed nets = 0)
MARKER           = ASTRA_11_A09_IMPL_ROUTE_DONE WNS=1.041 TNS=0.000 WHS=0.160 BIT=NOT_BUILT PROGRAM=NO
RESULT           = PASS_NARROW (this bag only: routed WNS at declared 50 MHz with clock-network)
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
```

## One unknown (answered)

After implement+route of wrapper `a7ng_astra_11_a09_impl_wrap` instance
**`u_a09` = frozen `a7ng_astra_09_integ_path`** on `xc7a100tcsg324-1` at declared
50 MHz (MMCM-derived `clk50u`, clock-network delay included):

Quoted from raw `timing_route.rpt` (Design State = **Routed**, 19:48:09):

```text
WNS(ns)=1.041  TNS=0.000  WHS=0.160  THS=0.000
TNS Failing Endpoints=0  THS Failing Endpoints=0
Clock clk50u  Period=20.000 ns  Frequency=50.000 MHz
All user specified timing constraints are met.
Intra clk50u WNS=1.041  WHS=0.160  failing endpoints=0
```

WNS **≥ 0**. No bitstream. Bounded WNS<0 experiment **not run** (not applicable).

This is **not** ASTRA-10 OOC synth WNS=+2.283 (Design State Synthesized, unplaced
clk net, HD.CLK_SRC unset). Clock path on the routed worst setup path:

```text
E3 IBUF → MMCME2_ADV_X1Y2 u_mmcm/CLKOUT0 → BUFGCTRL_X0Y16 u_bufg50/O
→ net (fo=1075, routed) u_a09/clk
Source Clock Delay = 6.264 ns   Destination Clock Delay = 5.969 ns
Requirement = 20.000 ns
Source  u_a09/FSM_sequential_st_reg[3]/C
Dest    u_a09/u_sgd/w_reg[14][15]/D
Data Path Delay = 18.768 ns  (logic 10.268 / route 8.500)  DSP48E1 present
Slack (MET) = 1.041 ns
```

`clocks_route.rpt`: `clk50u` generated from `u_mmcm/CLKOUT0`, master `sys_clk_pin`
10.000 ns. `clock_util_route.rpt`: MMCM=1, BUFGCTRL=1 at BUFGCTRL_X0Y16, 1075
clock loads, period 20.000.

## DUT identity (raw `vivado.log`, not RESULTS)

`synth_design -top a7ng_astra_11_a09_impl_wrap -part xc7a100tcsg324-1`
(in-context, **not** `-mode out_of_context`).

Synthesized: wrap (MMCME2_BASE + BUFG) → **`u_a09` `a7ng_astra_09_integ_path`**
→ `u_sp` `a7ng_query_axi_sparse` (LAW_SEL=1, N_BUCKETS=4096, CAND_CAP=16) →
`g_law.u_qse` + `u_walk`; `u_sgd` `a7ng_shared_rank_sgd_q8_sym_f2r2`.
Marker `U_A09_CELLS=10894`.

**Not synthesized:** `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, UART,
`a7ng_axi_bram128`. File list forbids those.

## Resources (raw rpts)

Quoted **synth** `util_synth.rpt` Design State Synthesized 19:47:01:

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **5222** | 63400 | 8.24 |
| Slice Registers (FF) | **4170** | 126800 | 3.29 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |

Quoted **routed** `util_route.rpt` Design State Routed 19:48:09:

| Resource | Used | Avail | Util% |
|----------|-----:|------:|------:|
| Slice LUTs | **1305** | 63400 | 2.06 |
| Slice Registers (FF) | **1075** | 126800 | 0.85 |
| Block RAM Tile | **0** | 135 | 0.00 |
| DSPs | **2** | 240 | 0.83 |
| Bonded IOB | **13** | 210 | 6.19 |

Hierarchical routed (`util_hier_route.rpt`): wrap LUT=1305; **`u_a09` LUT=1265
FF=1061 DSP=2**; `u_sgd` LUT=542 FF=615 DSP=2; `u_sp` LUT=146. Synth-to-route LUT
drop is opt of I/O-folded constants (AXI slave tied idle; stim = sw/btn). SGD
DSP48E1 ×2 remains on the routed worst path. **Not** wrap-route BRAM=2 (no
`a7ng_axi_bram128` in this instance).

Do **not** add these LUT/FF to wrap-route 4244/3810 or to ASTRA-10 OOC 5178/4155
as a whole-chip sum.

## Comparison (not identity)

| Envelope | LUT | FF | BRAM | DSP | WNS class |
|----------|----:|---:|-----:|----:|-----------|
| This bag **routed** | 1305 | 1075 | 0 | 2 | **Routed clk50u +1.041** |
| This bag synth | 5222 | 4170 | 0 | 2 | Synthesized (not the quote) |
| ASTRA-10 OOC synth | 5178 | 4155 | 0 | 2 | OOC unplaced **+2.283** — not this result |
| ASTRA-SOC-RTP-WRAP-ROUTE | 4244 | 3810 | **2** | 0 | Routed different top **+5.733** — not overwritten |

## Hashes

SHA freeze BEFORE impl `2026-09-06T19:40:34.4407779+07:00`.
Vivado R0 start `19:40:35` (PID 47828). Frozen A09 DUT `9fdbe0d6…` MATCH ASTRA-10
and ASTRA-09. Compiled RTL+XDC+tcl + `.svh` PRE/POST **15/15 MATCH**.

PS1 captured Vivado stdout as `$exit` (same class as ASTRA-10 runner smell) and
launched R1 (PID 36036, `vivado_r1.log`, start 19:44:24). R0 log kept as
`vivado_fail_r0.log`. Kept reports timestamp 19:48:09. **Compiled hashes not
patched.** `run_impl.ps1` CONFIG hash in SHA256.txt is the pre-run file (not
edited after).

## Open (unchanged)

Master ASTRA-09 production path. Master F3 10pp/CI. Master ASTRA-06 DDR/NVM.
Master ASTRA-10 whole-chip. LM06. BOARD_PASS. ASTRA-13. ASTRA-11 SoC UART wrap.
Do **not** call this BOARD_PASS, wrap-route WNS=+5.733, or OOC WNS=+2.283.
Manager independently accepts. Do not autonomously open the next gate.
