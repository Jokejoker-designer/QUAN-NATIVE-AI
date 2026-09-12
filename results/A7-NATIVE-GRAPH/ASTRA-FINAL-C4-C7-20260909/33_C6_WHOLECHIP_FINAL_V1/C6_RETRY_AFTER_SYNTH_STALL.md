# C6 retry after synth stall (same gate, WO §24)

**PROGRAM=NO.** Not a freeze. Not E3ab. Not BOARD_PASS.

## First divergence (this impl)

`a7ng_astra_c6_wholechip_final_v1` `synth_design` wrote "Synthesis finished with 0 errors" (elapsed 00:53:46, 0 critical warnings, 273 warnings). Journal never returned from `source run_impl.tcl`. No `synth.dcp`, no `C6F_SYNTH_DONE`, no `.bit`. Last live log line was a **second** parse of official `mig_7series_0.xdc` after `arty_a7_100.xdc` / `a7ng03_cdc.xdc`. Process PID 55248 is gone. `FIRST_DIVERGENCE.txt` was **not** written.

Cause of death: **UNKNOWN** (no ERROR line). Competing hypotheses: duplicate MIG RTL/XDC apply (`filemgmt 20-1440` CRITICAL), long Windows path (ProjectBase 1-489), or host kill/OOM after 17:30 with no flush.

## Smallest bounded correction

1. Do **not** `add_files` MIG `user_design` RTL — already owned by `mig_7series_0.xci` after `generate_target`.
2. Do **not** add MIG XDC a second time — IP constraints stay official and unmodified.
3. Project directory `D:/FPGA/_c6f_proj` (short path). Reports/bit remain in this bag.
4. Write `c6_synth.dcp` immediately after `synth_design` returns. `C6_PHASE.txt` names PRE_SYNTH / SYNTH_RETURNED / SYNTH_DCP / LINK / OPT / PLACE / ROUTE.
5. Board/MIG XDC `used_in_synthesis false` so a hang inside synth vs later read_xdc/place is separable.
6. Archive `vivado.log` from the stall; retry from a clean project.
7. `run_impl.ps1` still waits until no foreign Vivado/XSim/`hw_server` holds BASIC. Do not kill Gemini.
8. E1c alias boot is wired on C6 wrap (not D32). Diagnose netlist includes `u_alias_boot`.

If this retry still dies inside `synth_design`, `C6_PHASE.txt` stays `PRE_SYNTH` or becomes `SYNTH_FAIL`.

**2026-09-11 20:05 SYNTH_FAIL:** `mig_7series_0` not found after dropping glob-add of IP RTL while XCI stayed OOC. Next: `generate_synth_checkpoint false` (in-context), still no second MIG XDC add, still write `c6_synth.dcp` immediately on synth return.
