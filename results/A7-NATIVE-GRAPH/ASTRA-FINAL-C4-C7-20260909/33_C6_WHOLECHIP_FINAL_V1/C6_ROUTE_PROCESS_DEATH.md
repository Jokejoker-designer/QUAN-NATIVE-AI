# C6 route process death (not TIMING_OR_FIT)

**PROGRAM=NO.** E3AB=DO_NOT_START. Do not modify D32.

## FACT

`run_impl.ps1` after `c3_sgd_w` GOLDEN: synth PASS, `c6_synth.dcp` written 2026-09-11 22:23 +07 (48 569 511 bytes), CLASS c5/d32/alias_boot HIT, place PASS, `phys_opt` PASS, `route_design` started.

Vivado **exited during Route Phase 5.1** (rip-up overlaps 22555 → 43) with **no ERROR/FATAL** in `vivado.log`. Journal never returned. PowerShell `$LASTEXITCODE = -1`. `C6F_IMPL_FAIL`. No `ROUTE_LETTERS` from this attempt (stub `STALE_NOT_THIS_RUN` correctly ignored by finish). No bitstream.

This is the same class of death as the earlier synth-stall (process gone, no ERROR), **not** a §19 timing miss.

Intermediate router print (not letters): `WNS=-3.239 TNS=-1068.825 WHS=-1.360 THS=-325.056`. Not WO §19. Hint only that `c3_sgd_w` moved WNS vs prior routed −9.462.

## Resume

Same impl gate. Open `c6_synth.dcp` (`C6F_RESUME_SYNTH_DCP=1`). Re-place, write `ckpt/place.dcp`, route, letters. Do not re-synth. Do not program. Do not auto-start a new pipe family.
