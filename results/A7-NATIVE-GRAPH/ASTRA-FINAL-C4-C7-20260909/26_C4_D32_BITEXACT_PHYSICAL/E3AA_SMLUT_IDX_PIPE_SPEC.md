# E3aa — S_SMLUT_LUT snap Lut index then apply (named family `smres`)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

This file is the **new written plan** required by `E3_REVIEW_AFTER_E3Z.md`. It does not authorize E3ab, post-route C6, programming, or MASTER.

## Trigger (FACT from E3z Case B)

```text
WNS              -0.349 ns   (Δ +0.983 vs E3y; not STRONG 3.0)
TNS              -24.793 ns
failing          192
top-20           smres/elut 20
worst            delta_r_reg[0]/C → elut_reg[0][0]/D
levels           18
CARRY4 / DSP     8 / 0
cells            negate/compare CARRY then Lut MUXF7 into elut  (S_SMLUT_LUT)
LUT/FF/DSP/BRAM  27111 / 43285 / 11 / 0
n20 SHA          ce6fa367ae73c1e52c6f647c9a8bdcfce22d5bbe23fcc34648bef3716a9cc0f5
DUT SHA          e37e1917578a6fe594e1dbb257966e37be9c2847ba9606911dce2413e5b01796
```

E3t already registered `delta_r` then Lut in `S_SMLUT_LUT`. Remaining critical cone is still combo `-delta_r` / `>4096` / `Lut[]` into `elut` in that cycle. Cut **that** apply only. Do not re-pipe Q/K/V/DOT/H/F2. Do not overwrite `timing_n20_e3z.rpt`.

WO §12 allows pipeline without changing integer semantics. Forbidden: reduce D/F, change quant, drop F/R bank, replace decoder with dictionary.

## Law

```text
S_SMLUT:        KEEP  delta_r <= dots[ti] - dmax; ST S_SMLUT_LUT
S_SMLUT_LUT:    lut_zero_r <= (delta_r < -4096) || ((-delta_r) > 4096);
                lut_neg_r  <= ((-delta_r) > 0) ? (-delta_r) : 0;
                ST S_SMLUT_APPLY
S_SMLUT_APPLY:  elut[ti] <= lut_zero_r ? 0 : Lut[lut_neg_r];
                last ti → S_SMDIV else ti++; S_SMLUT
```

Same compare/Lut as current `S_SMLUT_LUT`. Extra cycle allowed. GOLDEN n=242 + both CLASS HITs. Tokens must match.

## After this gate

Classify vs E3z −0.349 / `delta_r`→`elut` 20/20.

- A/B: `smres`/`elut` left top-20 → record the new named family. Do **not** auto-start the next pipe in the same run.
- C: still `delta_r`→`elut` 20/20 and ΔWNS < ~0.15 and endpoints not materially better → STOP local E3.
- MIXED: read `timing_n20_e3aa.rpt`.

Do not program. Do not stamp MASTER. OOC WNS≥0 is still **not** WO §19 physical PASS.
