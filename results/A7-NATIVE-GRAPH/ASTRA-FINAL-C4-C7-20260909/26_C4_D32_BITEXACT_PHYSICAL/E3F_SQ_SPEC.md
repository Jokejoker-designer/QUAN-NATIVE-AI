# E3f_S_Q — S_Q-only multicycle `c4_rq` (measured from E3h top-N)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 parser RTL.

## Trigger (FACT from E3h Case B)

```text
WNS              -23.364 ns  (Δ −0.814 ns vs E3f; TNS/failing improved)
top-20           qv_wdata 20/20
hv               0/20
worst            di_reg → qv_wdata_reg
```

Cut **S_Q only**. Do not touch remaining combo `c4_rq` (`S_EMB` / `S_DOT` / `S_Y` / `S_F1` / `S_F2`).

Do **not** overwrite `timing_n20_e3f.rpt` / `d32_ooc_e3f.dcp` (those are S_K).

## Law

Reuse `a7ng_astra_c4_rq_mcycle` unchanged. Handshake matches E3f S_K:

```text
last di: snapshot (acc + w8*x[tlen-1]), Q or QR mul/shr
→ S_Q_RQ
→ S_Q_FIN  qv_wdata <= c4_sat(rq_q)[15:0]
```

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3f_sq.rpt` / `d32_ooc_e3f_sq.dcp`
3. Do not program. Do not stamp MASTER.
