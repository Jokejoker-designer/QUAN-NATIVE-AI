# E3a / G14 — physical attribution, no program

`PROGRAM=NO`. No RTL edit. No E3b divider. No bitstream.

## Why G14 cannot run

WO §21: program **only** the frozen C6 bit. Search of
`D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH` found **0** `.bit` and **0** `.dcp`.
C4/C5/C6_MASTER are OPEN. `ASTRA_NATIVE_AI_BOARD_PASS` stays OPEN.
Never PARTIAL PASS.

## E3a from existing OOC (no re-synth)

`14_C4_OOC_V2/run_ooc.tcl` used `report_timing_summary` and **did not**
`write_checkpoint`. Re-synth last elapsed **54 min**. This bag parses the
saved report instead of monopolizing the BASIC license for another hour.

Worst setup path (FACT):

```text
WNS -83.427 ns @ 10 ns
62840 failing endpoints
Source:      elut_reg[11][5]/C
Destination: acc1__0__0/B[14]   (DSP48E1 B)
Delay:       92.893 ns, 319 levels, CARRY4=305
Net families: attn 283, psum 33, eden 2, elut 2
We/Wq/Wk/Wv names on this path: 0
BRAM: 0   LUT-as-memory: 0
DIVIDE unisim: none (Artix-7)
```

INFERENCE: this is the combinational signed `/ eden` of `S_SMRES` plus
`psum` feeding the `S_H` DSP. RTL `a7ng_astra_c4_lm06_d32_fr_v2.sv:265-277`.

FACT that weakens “giant We mux is the worst path”: this path is not named
as a weight array. Residual UNKNOWN: the other 62839 endpoints (top-N missing).

Synth FACT: `unique case` → `parallel_case`; `ti`/`acc` mixed blocking/NBA.

## E3b

BLOCKED until top-N `report_timing -max_paths 20` on a written DCP, or
explicit authority that worst-path INFERENCE is enough.

TCL for that re-synth (not launched): `run_e3a_topn.tcl`.
