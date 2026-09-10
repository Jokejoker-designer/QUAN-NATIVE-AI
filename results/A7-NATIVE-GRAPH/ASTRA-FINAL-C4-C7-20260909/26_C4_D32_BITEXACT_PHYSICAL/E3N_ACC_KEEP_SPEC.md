# E3n — keep shared `acc` (measured from E3m top-N)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3m MIXED / Case-B-like)

```text
WNS              -5.998 ns   (Δ +0.545 vs E3l)
TNS              -2234.909 ns
failing          647
top-20           rq_snap 19, acc 1
worst            di_reg[4]/C → rq_val_r_reg[63]/D
levels           21
CARRY4 / DSP     9 / 1
cells            acc1__3_*, DSP rq_val_r1__2
```

S_H `hacc` left as worst. Named cone is last-`di` `acc + product` flattened into `rq_val_r`. Cut **`(* keep = "true" *)` on shared `acc` only**. Do not SNAP Q/K/V/F1/DOT/LOG in this gate.

Do **not** overwrite `timing_n20_e3m.rpt` or earlier n20/dcp.

## Law

Same bit-exact MAC. Force the shared accumulator register to survive synth so last-`di` snapshot is one MAC, not a flattened tree.

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3n.rpt` / `d32_ooc_e3n.dcp`
3. Do not program. Do not stamp MASTER.
