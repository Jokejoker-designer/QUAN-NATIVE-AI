# E3x — S_H `vv`/`attn` operand snap then `prod_r` (measured from E3w Case B)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3w Case B)

```text
WNS              -2.457 ns   (Δ +0.141 vs E3v; cone changed, not STOP)
TNS              -147.021 ns
failing          88
top-20           prod_r 20  (smres_div 0)
worst            vv_reg[23][30][15]/C → prod_r_reg[32]/D
levels           10
CARRY4 / DSP     0 / 2
cells            vv mux + attn * DSP into prod_r
LUT/FF/DSP/BRAM  27217 / 43255 / 12 / 0
n20 SHA          7160ef64b8a46aedea8a042b4718017c6055fc49345c407a5ea6c2687e35bd83
```

`smres_div` left. Cut **one family**: S_H `attn[ti]*vv[ti][dj]` only. Do **not** also pipe S_DOT (`kv*qv`) or S_F2 (`W2*tv`) in this gate. No `keep`/`dont_touch` as the timing boundary. Do not overwrite `timing_n20_e3w.rpt`.

## Law

Bit-exact:

```text
prod = attn[ti] * vv[ti][dj]   // 32×16 into prod_r[63:0]
```

```text
S_H:      attn_r <= attn[ti]; val_r <= vv[ti][dj]; ST S_H_PROD
S_H_PROD: prod_r <= attn_r * val_r; ST S_H_MAC
S_H_MAC:  hacc accumulate unchanged
```

Extra cycle allowed. Tokens must match GOLDEN n=242.

## Gate

1. GOLDEN.svh n=242 + CLASS_host_tok0 + CLASS_ref_match
2. New OOC `timing_n20_e3x.rpt` / `d32_ooc_e3x.dcp`
3. Classify vs E3w −2.457. If `prod_r` left → A/B; at most one E3y on the new named family. If `prod_r` still 20/20 from `vv` and ΔWNS < ~0.15 ns and failing not materially better → STOP local E3, run E3_REVIEW. No keep.
4. Do not program. Do not stamp MASTER.
