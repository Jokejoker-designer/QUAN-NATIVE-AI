# E3g — S_LOG-only multicycle `c4_rq` (measured from E3e top-N)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 parser RTL.

## Why (FACT from E3e)

E3e OOC WNS **−23.439 ns** (E3d was −24.357 ns). Top-20 **20/20 `logits_wdata`**. Worst:

```text
vi_reg[0]_rep__0/C → logits_wdata_reg[11]/S
53 levels, 32.798 ns
CARRY4=35 DSP48E1=4
```

`vv_wdata` is **not** in the top-20. E3e cut S_V. E3f (Q/K) is **not** this gate.

RTL site is **`S_LOG` only**: last `di` MAC + combo `c4_rq(logits)` + combo `c4_rq(bias)` + `c4_sat(sum)` into `logits_wdata` in one cycle.

## Scope (falsifier)

```text
E3g  = S_LOG ONLY
     snapshot MAC val → rq_mcycle (logits mul/shr)
     → S_LOG_CAP latch q_logits, snapshot bias val
     → rq_mcycle (bias mul/shr)
     → S_LOG_FIN  logits_wdata <= c4_sat(q_logits + q_bias)
     → GOLDEN.svh n=242
     → new OOC timing_n20_e3g.rpt (do not overwrite E3a/E3d/E3e)
     → read new top-N
```

Reuse existing `a7ng_astra_c4_rq_mcycle`. Do **not** change the unit. Do not touch `S_Q` / `S_K` / `S_V`. Sum-then-sat stays outside the unit.

Capture `rq_q` on the cycle **after** `rq_done` (`S_LOG_CAP` / `S_LOG_FIN`), same as `S_V_FIN`.

## Gate

1. GOLDEN.svh n=242 — extra cycles OK; tokens must match.
2. New OOC `timing_n20_e3g.rpt` / `d32_ooc_e3g.dcp`. **Do not overwrite** E3a / E3d / E3e.
3. Do not program. Do not stamp MASTER.
