# E3i — S_F1-only multicycle `c4_rq` (measured from E3f_S_Q top-N)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 parser RTL.

## Trigger (FACT from E3f_S_Q Case B)

```text
WNS              -20.614 ns  (Δ +2.75 ns vs E3h; below Case A 3.0 ns)
top-20           val0 DSP 20/20  (classifier family f1_rq)
qv_wdata         0/20
worst            fi_reg[4]/C → val0/A[*]
path             relu.a / W1*yv MAC / CARRY4 into combo c4_rq DSP
```

Cut **S_F1 only**. Do not touch `S_Y` / `S_F2` / `S_EMB` / `S_DOT` in this gate.

Do **not** overwrite `timing_n20_e3f_sq.rpt` or earlier n20/dcp.

## Law

Reuse `a7ng_astra_c4_rq_mcycle` unchanged. Handshake matches S_V:

```text
last di: snapshot (acc + W1*yv), T mul/shr
→ S_F1_RQ
→ S_F1_FIN  tv[fi] <= relu(c4_sat(rq_q))
```

Sat/relu stay outside the unit.

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3i.rpt` / `d32_ooc_e3i.dcp`
3. Do not program. Do not stamp MASTER.
