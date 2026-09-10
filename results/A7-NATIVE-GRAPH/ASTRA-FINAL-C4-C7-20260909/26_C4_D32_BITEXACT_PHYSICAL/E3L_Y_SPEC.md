# E3l — S_Y-only multicycle `c4_rq` (measured from E3k top-N cone)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3k Case B)

```text
WNS              -15.041 ns
TNS              -9485.734 ns
failing          1125
top-20 dest pin  rq_val_r 20/20
x_wdata          0/20
worst            x_reg[6][18][15]/C → rq_val_r1__1/A[0]
cone cells       yv_reg[31][*]_i_* CARRY4
levels           38
CARRY4 / DSP     23 / 5
```

Dest pin is `rq_val_r` (parser family `rq_snap`). The **cone** is remaining combo `S_Y` pulled into the S_F1 snapshot. Cut **S_Y only**. Do not pipeline `rq_val_r` as a separate site. Do not touch S_F1.

Do **not** overwrite `timing_n20_e3k.rpt` or earlier n20/dcp.

## Law

Two sequential uses of the existing `rq_mcycle`, then sat outside the unit. Combo was `c4_sat(rq_YX(x[tlen-1][di]) + rq_YH(hv[di]))[15:0]`.

```text
S_Y:     snapshot sign-ext16 x[tlen-1][di], YX mul/shr
→ S_Y_RQ1
→ S_Y_CAP  save q; snapshot sign-ext16 hv[di], YH mul/shr
→ S_Y_RQ2
→ S_Y_FIN  yv[di] <= c4_sat(rq_q_saved + rq_q)[15:0]
```

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3l.rpt` / `d32_ooc_e3l.dcp`
3. Do not program. Do not stamp MASTER.
