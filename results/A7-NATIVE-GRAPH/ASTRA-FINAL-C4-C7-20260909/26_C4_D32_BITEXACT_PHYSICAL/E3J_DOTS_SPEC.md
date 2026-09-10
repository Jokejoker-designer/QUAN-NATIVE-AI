# E3j — S_DOT-only multicycle `c4_rq` (measured from E3i_F2 top-N)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3i_F2 Case B)

```text
WNS              -17.556 ns
TNS              -23918.976 ns
failing          1949
top-20           dots 20/20
zv_wdata         0/20
worst            kv_reg[23][31][15]/C → dots_reg[0][27]/D
levels           39
CARRY4 / DSP     25 / 4
```

Cut **S_DOT only**. Do not touch `S_EMB` or `S_Y`.

Do **not** overwrite `timing_n20_e3i_f2.rpt` or earlier n20/dcp.

## Law

Single sequential use of the existing `rq_mcycle`. Combo took `[31:0]` of `c4_rq` — **no** `c4_sat`.

```text
last di: snapshot (acc + kv[ti][di]*qv[di]) with old acc, DOTS mul/shr
→ S_DOT_RQ
→ S_DOT_FIN  dots[ti] <= rq_q[31:0]
```

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3j.rpt` / `d32_ooc_e3j.dcp`
3. Do not program. Do not stamp MASTER.
