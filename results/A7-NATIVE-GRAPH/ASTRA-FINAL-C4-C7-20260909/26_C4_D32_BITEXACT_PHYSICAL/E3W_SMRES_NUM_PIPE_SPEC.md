# E3w — SMRES `elut`→`un` num/abs pipe (measured from E3v Case B)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3v Case B)

```text
WNS              -2.598 ns   (Δ +0.155 vs E3u; slight/flat)
TNS              -192.428 ns
failing          96
top-20           smres_div 3, prod_r 17  (rq_q 0)
worst            elut_reg[23][0]/C → u_smres_div/un_reg[31]/D
levels           21
CARRY4 / DSP     10 / 0
cells            combo elut*32767 + eden/2 + abs into un
```

`rq_q` left. Cut **one family**: SMRES `un` capture only. Do **not** also pipe `prod_r` (vv mux→DSP, slack −2.431) in this gate. Do not overwrite `timing_n20_e3v.rpt`.

## Law

Bit-exact identity unchanged:

```text
eden==0 → q=0
else q = trunc_toward_zero( (elut*32767 + eden/2) / eden )
```

```text
ST_IDLE: snap elut_r/eden_r; eden==0 → done; else ST_NUM
ST_NUM:  num_r <= elut_r * 32767 + (eden_r/2); den_r <= eden_r; ST_ABS
ST_ABS:  un/ud <= abs(num_r/den_r); ST_DIV
ST_DIV:  restoring divide unchanged
```

Extra cycles allowed. Tokens must match GOLDEN n=242.

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3w.rpt` / `d32_ooc_e3w.dcp`
3. Classify vs E3v −2.598. If `un` left → A/B, cut the new named family only (`prod_r` if it remains). If `un` still from `elut` through combo mul/add → Case C.
4. Do not program. Do not stamp MASTER.
