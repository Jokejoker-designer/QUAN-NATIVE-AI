# E3n OOC — HUNG (not a timing result)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. No `timing_n20_e3n.rpt`.

| Item | FACT |
|------|------|
| Start | 2026-09-10 06:33 +07 `run_e3n_ooc.ps1` |
| Scope | `(* keep = "true" *)` on shared `acc` only |
| GOLDEN n=242 | PASS before OOC (`CLASS_ref_match` / `CLASS_host_tok0`) |
| Last log line | `Start Cross Boundary and Area Optimization` |
| Wall clock | ~4.6 h still running |
| Vivado user CPU | ~16–18 min on parent + workers |
| Baseline closed | E3m WNS **−5.998 ns** |

**INFERENCE:** synth hung; keep-on-shared-`acc` is not a completed path-cut. Do not treat as Case A/B/C.

**Next measured gate (from E3m cone):** last-`di` `acc + product` → `rq_val_r` (`di_reg[4]` → `rq_val_r_reg[63]`). SNAP that family after license is free. Do not program.
