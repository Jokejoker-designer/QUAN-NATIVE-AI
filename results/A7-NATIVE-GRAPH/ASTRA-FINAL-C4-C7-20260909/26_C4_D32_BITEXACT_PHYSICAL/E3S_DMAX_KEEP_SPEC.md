# E3s — keep `dmax` (measured from E3r Case B)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3r Case B)

```text
WNS              -3.669 ns   (Δ +0.420 vs E3q; slight/flat)
TNS              -1427.389 ns
failing          879
top-20           smres/elut 20  (acc 0)
worst            dots_reg[23][1]/C → elut_reg[0][0]/D
levels           22
CARRY4 / DSP     9 / 0
cells            dmax mux then elut subtract/Lut
```

S_F2 `acc` left. Remaining cone flattens `dots` through a `dmax` mux into `elut`. Cut **one family**: `(* keep = "true" *)` on `dmax` so S_SMMAX register survives into S_SMLUT. Do not also pipeline S_SMLUT in this gate. Do not overwrite `timing_n20_e3r.rpt`.

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3s.rpt` / `d32_ooc_e3s.dcp`
3. Classify vs E3r −3.669. If `elut` still 20/20 from `dots` through `dmax` mux → Case C. If `elut` left → A/B, cut the new named family only.
4. Do not program. Do not stamp MASTER.
