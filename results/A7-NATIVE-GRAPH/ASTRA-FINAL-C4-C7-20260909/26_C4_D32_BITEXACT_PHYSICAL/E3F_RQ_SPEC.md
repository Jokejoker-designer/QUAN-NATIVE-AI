# E3f — S_K-only multicycle `c4_rq` (measured from E3g top-N)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 parser RTL.

## Trigger (FACT from E3g)

E3g Case **B**. Top-20 **20/20 `kv_wdata`**. `logits_wdata` left top-20. WNS −22.718 ns (Δ +0.721 ns vs E3e).

```text
E3f_S_K  = this gate (worst dest kv_wdata)
E3f_S_Q  = only if a later top-N is qv_wdata
```

Do **not** touch `S_Q` / `S_V` / `S_LOG` in this cut.

## Law (same as E3e S_V)

Reuse `a7ng_astra_c4_rq_mcycle` unchanged.

1. PRODUCT WIDTH LAW.
2. No `sat_en`. `S_K_FIN` applies `c4_sat(rq_q)[15:0]`.
3. Handshake: last `di` snapshot → `S_K_RQ` → `S_K_FIN`.

## Gate

1. GOLDEN.svh n=242.
2. New OOC `timing_n20_e3f.rpt`. Do **not** overwrite E3a/E3d/E3e/E3g.
3. Do not program. Do not stamp MASTER.
