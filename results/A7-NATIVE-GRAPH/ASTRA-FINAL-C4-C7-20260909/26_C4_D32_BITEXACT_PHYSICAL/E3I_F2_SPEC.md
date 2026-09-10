# E3i_F2 — S_F2-only multicycle `c4_rq` (measured from E3i top-N)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3i Case B)

```text
WNS              -19.828 ns
top-20           zv_wdata 16, dots 4
f1_rq            0/20
worst            dj_reg → zv_wdata_reg
```

Cut **S_F2 only**. Do not touch `S_DOT` in this gate.

Do **not** overwrite `timing_n20_e3i.rpt` or earlier n20/dcp.

## Law

Two sequential uses of the existing `rq_mcycle`, then sat outside the unit:

```text
last fi: snapshot (acc + W2*tv) with old acc, ZT mul/shr
→ S_F2_RQ1
→ S_F2_CAP  save q; snapshot sign-extended yv, ZY mul/shr
→ S_F2_RQ2
→ S_F2_FIN  zv_wdata <= c4_sat(rq_q_saved + rq_q)[15:0]
```

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3i_f2.rpt` / `d32_ooc_e3i_f2.dcp`
3. Do not program. Do not stamp MASTER.
