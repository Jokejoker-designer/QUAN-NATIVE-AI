# E3u — pipe `w8_r`/`val_r` then DSP into `prod_r` (measured from E3t Case B)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3t Case B)

```text
WNS              -2.766 ns   (Δ +0.989 vs E3s; slight/flat vs +3.0)
TNS              -369.748 ns
failing          351
top-20           prod_r 20  (smres/elut 0)
worst            di_reg[4]/C → prod_r_reg[23]/D
levels           11
CARRY4 / DSP     1 / 1
cells            di → wgt8 mux → DSP48E1 → prod_r
```

S_SMLUT pipe cut `dots`→`elut`. Remaining named dest is the **di-indexed wgt8 operand mux into the existing `prod_r` DSP**. Cut **one family**: register `w8_r` and `val_r` in S_Q/K/V/F1/LOG, multiply in `S_PROD`, then existing `S_ACC_MAC`. Do not pipe DOT/H/F2 in this gate. Do not overwrite `timing_n20_e3t.rpt`.

## Law

```text
S_Q/K/V/F1/LOG:
  w8_r  <= wgt8(...)
  val_r <= x|yv|zv[di]
  st    <= S_PROD
S_PROD:
  prod_r <= w8_r * val_r    // 8×16 into signed [63:0]
  st     <= S_ACC_MAC       // existing
```

Extra cycles allowed. Tokens must match GOLDEN n=242.

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3u.rpt` / `d32_ooc_e3u.dcp`
3. Classify vs E3t −2.766. If `prod_r` still 20/20 from `di` through DSP → Case C. If `prod_r` left → A/B, cut the new named family only.
4. Do not program. Do not stamp MASTER.
