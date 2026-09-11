# E3q — pipeline S_H `vv`→DSP off `hacc` (measured from E3p Case B)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3p Case B)

```text
WNS              -5.220 ns   (Δ +0.737 vs E3o; slight/flat)
TNS              -1900.469 ns
failing          1024
top-20           hacc 20 / acc 0
worst            vv_reg[23][30][15]/C → hacc_reg[63]/D
levels           23
CARRY4 / DSP     12 / 2
```

E3p cut `di`→`acc`. Remaining cone is S_H last-MAC flatten: `vv` → 2×DSP48E1 → 12×CARRY4 → `hacc[63]`. Cut **one family**: register the S_H product, add into `hacc` next cycle. Do **not** SNAP S_F2. Do not drop keep. Do not overwrite `timing_n20_e3p.rpt`.

## Law

Same bit-exact S_H MAC. Cycle A: `prod_r <= attn[ti] * vv[ti][dj]`. Cycle B: `hacc <= (ti==0) ? prod_r : (hacc + prod_r)`. Last `ti` then existing `S_H_SNAP`. Extra cycles allowed; GOLDEN tokens must match.

```text
S_H:
  prod_r <= attn[ti] * vv[ti][dj]
  st <= S_H_MAC
S_H_MAC:
  hacc <= (ti==0) ? prod_r : hacc + prod_r
  if last ti: st <= S_H_SNAP
  else: ti++; st <= S_H
```

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3q.rpt` / `d32_ooc_e3q.dcp`
3. Classify vs E3p −5.220. If `hacc` still 20/20 **and** source still `vv_reg` through DSP → Case C. If dest still `hacc` but source left `vv` → MIXED, read cone.
4. Do not program. Do not stamp MASTER.
