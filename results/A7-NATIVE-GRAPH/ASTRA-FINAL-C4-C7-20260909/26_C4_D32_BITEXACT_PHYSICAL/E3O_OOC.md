# E3o OOC — CRASH (not a timing result)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. No `timing_n20_e3o.rpt`.

| Item | FACT |
|------|------|
| Start | 2026-09-10 11:59:41 +07 `run_e3o_ooc.ps1` |
| Scope | last-`di` `S_ACC_SNAP` (GOLDEN n=242 PASS) |
| Last log line | `Start Cross Boundary and Area Optimization` + constant-0 port warnings |
| Wall | ~44.4 min (`elapsed_ms` 2662626) |
| Vivado exit | **-1** (`E3O_OOC_FAIL exit=-1`) |
| n20 / dcp | **absent** |
| Prior n20 | E3n `timing_n20_e3n.rpt` still present |

No `ERROR:` line in `vivado_e3o_ooc.log`. Journal ends at `source run_e3o_ooc.tcl`.

**INFERENCE:** process crash during synth (OOM or internal abort). Not Case A/B/C. Last closed OOC remains E3n WNS **−5.840 ns**.

Retry: same RTL; `maxThreads` 4; blocked until Gemini `build_real.tcl` releases BASIC. Crash log archived as `vivado_e3o_ooc_crash1.log`.

Do not program. Do not stamp MASTER.
