# E3h — S_H-only multicycle `c4_rq` (measured from E3f top-N)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 parser RTL.

## Trigger (FACT from E3f Case B)

```text
WNS              -22.550 ns
top-20           hv 20/20
kv_wdata         0/20
worst            vv_reg → hv_reg
```

Cut **S_H only**. Do not touch `S_Q` / `S_Y` / `S_F*` in this gate.

## Law

Reuse `a7ng_astra_c4_rq_mcycle` unchanged. Handshake matches E3e S_V:

```text
last ti: snapshot (acc + attn*vv), H mul/shr
→ S_H_RQ
→ S_H_FIN  hv[dj] <= c4_sat(rq_q)[15:0]
```

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3h.rpt` — do not overwrite E3a/E3d/E3e/E3g/E3f
3. Do not program. Do not stamp MASTER.
