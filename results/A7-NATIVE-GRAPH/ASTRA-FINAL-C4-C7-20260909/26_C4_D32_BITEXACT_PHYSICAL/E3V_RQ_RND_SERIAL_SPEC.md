# E3v — serial RQ `ST_RND` shift (measured from E3u Case B)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3u Case B)

```text
WNS              -2.753 ns   (Δ +0.013 vs E3t; slight/flat)
TNS              -307.046 ns
failing          183
top-20           rq_q 15, smres_div 5  (prod_r 0)
worst            u_rq/shr_r_reg[4]/C → u_rq/q_r_reg[63]/D
levels           38
CARRY4 / DSP     33 / 0
cells            combo >>shr_r plus round into q_r
```

`di`→`prod_r` left. Cut **one family**: RQ `ST_RND` only. Do **not** also pipe `u_smres_div` in this gate. PRODUCT WIDTH LAW unchanged: `prod = val * $signed(64'(mul))` in `ST_MUL`. No `sat_en`. Do not overwrite `timing_n20_e3u.rpt`.

## Law

Original (shr≠0), bit-exact:

```text
qmag = (mag >> shr) + mag[shr-1]
```

because `(mag & ((1<<shr)-1)) >= (1<<(shr-1))` iff `mag[shr-1]`.

```text
ST_RND:  mag_r <= abs(prod_r); n_r <= shr_r; st <= ST_SHF   // shr==0: q_r<=prod_r; ST_DONE
ST_SHF:  round_r <= mag_r[0]; mag_r <= mag_r>>1;  n_r==1 ? ST_ADD : n_r--
ST_ADD:  q_r <= neg ? -(mag_r+round_r) : (mag_r+round_r); ST_DONE
```

Extra cycles allowed (≤63 per RQ). Tokens must match GOLDEN n=242.

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3v.rpt` / `d32_ooc_e3v.dcp`
3. Classify vs E3u −2.753. If `q_r` left → A/B, cut the new named family only (`smres_div` if it remains). If `q_r` still from `shr_r` through combo `>>` → Case C.
4. Do not program. Do not stamp MASTER.
