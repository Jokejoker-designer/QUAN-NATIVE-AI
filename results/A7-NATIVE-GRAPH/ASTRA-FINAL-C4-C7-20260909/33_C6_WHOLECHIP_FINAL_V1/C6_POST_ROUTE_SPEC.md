# C6 post-route — `a7ng_astra_c6_wholechip_final_v1` (written plan after E3aa)

**PROGRAM=NO.** `C4_MASTER` OPEN. `C5_MASTER` OPEN. `C6_MASTER` OPEN.  
`ASTRA_NATIVE_AI_BOARD_PASS` NOT_EVIDENCED. G14 **BLOCKED_PRE_BOARD**.

This is the **new written plan** required after `E3_REVIEW_AFTER_E3AA.md`. It does **not** authorize E3ab, programming, freeze, or MASTER.

## Why this gate (not E3ab)

E3aa OOC of D32 is **setup/hold MET** at 10 ns (WNS +1.052, TNS 0, WHS +0.172, THS 0). Named family `rq_snap` is recorded and **not** started.

WO §19 physical PASS is **post-route C6 wholechip**, not D32 OOC. COFIT-03 `a7ng_astra_c6_wholechip` + old `prod_top` + `grounded_gen` is **not** this artifact (LUT~9k, DSP 0, no D32).

C5/D32 on silicon clock `ui_clk` **12.000 ns** (83.333 MHz). OOC was 10 ns. Extra period is not a substitute for place/route.

## DUT

```text
top     a7ng_astra_c6_wholechip_final_v1
c5      a7ng_astra_c5_prod_top_final_v1
c4      a7ng_astra_c4_prod_wrap_v2 → a7ng_astra_c4_lm06_d32_fr_v2
d32     SHA256 0a4e0e051f7f400f3853cf91098eb03617efa8eb888c7ca1c65a3287bcca5fb5
mig     official Digilent AXI MIG via mig_native_wrap (do not hand-edit mig.prj)
part    xc7a100tcsg324-1
vivado  2026.1
```

Forbidden in this netlist: live `a7ng_astra_c5_prod_top`, live `a7ng_astra_c6_wholechip`, `grounded_gen`, TinyGPT, A09, Gemini `top_decoder`.

## Physical letters (WO §19)

After ROUTE (not synth):

```text
device fit PASS
WNS >= 0
TNS = 0
WHS >= 0
THS = 0
unrouted nets = 0
DRC errors = 0
critical unconstrained = 0
```

`write_bitstream` **only if** those hold. `open_hw` / `program_hw*` renamed abort. A written `.bit` is **not** a freeze: `freeze_allowed` stays false until §18 (git clean, unique manifest, C4/C5 acceptance, dict lock). `alias_wr=0` still makes production F/R S_SAFE.

Retry after synth stall (no DCP): `C6_RETRY_AFTER_SYNTH_STALL.md`. Do not glob-add MIG RTL/XDC. Project `D:/FPGA/_c6f_proj`.

Route Phase 5.1 process death is **not** a timing fail:

```text
C6_SYNTH     = PASS
C6_PLACE     = PASS only after C6F_PLACE_DONE + valid c6_place.dcp
C6_ROUTE     = INCOMPLETE_TOOL_EXIT until route_design returns
C6_POSTROUTE = NOT_EVIDENCED
```

In-route `WNS=-3.239` is a hint that `c3_sgd_w` may have moved the cone vs archived −9.462 ns. It is **not** `C6_POST_ROUTE_PHYSICAL`.

Preferred resume after overlay SHA exists:

```text
open_checkpoint c6_place.dcp
route_design
write_checkpoint c6_route.dcp
report_timing_summary
report_route_status
report_drc
```

`C6_POST_ROUTE_PHYSICAL = PASS` only if all of: WNS≥0, TNS=0, WHS≥0, THS=0, unrouted=0, DRC errors=0. Then still `PROGRAM=NO` until §18 freeze. E3ab is **DO_NOT_START**.

## Not this run

- E3ab_rq_snap
- C6_MASTER / BOARD_PASS
- Programming Arty / Gemini
- Hand-edit MIG
- Treat COFIT +0.233 ns as this C6
