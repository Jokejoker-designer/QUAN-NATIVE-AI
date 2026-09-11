# E3t — pipeline S_SMLUT `delta_r` then Lut (measured from E3s Case C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3s Case C)

```text
WNS              -3.755 ns   (Δ −0.086 vs E3r; keep did not help)
TNS              -1501.355 ns
failing          519
top-20           smres/elut 20
worst            dots_reg[23][1]/C → elut_reg[0][0]/D
levels           23
CARRY4 / DSP     9 / 0
cells            dmax mux then subtract CARRY then Lut mux into elut
```

`(* keep = "true" *)` on `dmax` did **not** cut `dots`→`elut`. Keep remains. Cut **one family**: register `delta_r <= dots[ti] - dmax` in `S_SMLUT`, apply Lut/`elut` next cycle in `S_SMLUT_LUT`. Do not revert keep. Do not overwrite `timing_n20_e3s.rpt`.

## Law

```text
S_SMLUT:
  delta_r <= dots[ti] - dmax
  st <= S_SMLUT_LUT
S_SMLUT_LUT:
  if delta_r < -4096: elut[ti] <= 0
  else if (-delta_r) > 4096: elut[ti] <= 0
  else: elut[ti] <= Lut[(-delta_r)>0 ? (-delta_r) : 0]
  last ti → S_SMDIV else ti++; S_SMLUT
```

Same compare/Lut as the collapsed `S_SMLUT`. Extra cycles allowed. Tokens must match GOLDEN n=242.

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3t.rpt` / `d32_ooc_e3t.dcp`
3. Classify vs E3s −3.755. If `elut` still 20/20 from `dots` → Case C (pipe collapsed). If `elut` left → A/B, cut the new named family only.
4. Do not program. Do not stamp MASTER.
