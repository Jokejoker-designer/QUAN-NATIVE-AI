# E3k — S_EMB-only multicycle `c4_rq` (measured from E3j top-N)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3j Case B)

```text
WNS              -16.734 ns
TNS              -19812.107 ns
failing          1735
top-20           x_wdata 20/20
dots             0/20
worst            toks_reg[23][0]/C → x_wdata_reg[11]/D
levels           41
CARRY4 / DSP     24 / 2
```

Cut **S_EMB only**. Do not touch `S_Y`.

Do **not** overwrite `timing_n20_e3j.rpt` or earlier n20/dcp.

## Law

Two sequential uses of the existing `rq_mcycle`, then sat outside the unit. Combo was `c4_sat(rq_We + rq_Pe)[15:0]`. Sign-extend i8 with 56 copies of the sign bit.

```text
S_EMB:     posi = (ti > 23) ? 23 : ti; snapshot sign-ext We, WE mul/shr
→ S_EMB_RQ1
→ S_EMB_CAP  save q; snapshot sign-ext Pe[posi], PE mul/shr
→ S_EMB_RQ2
→ S_EMB_FIN  x_wdata <= c4_sat(rq_q_saved + rq_q)[15:0]
```

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3k.rpt` / `d32_ooc_e3k.dcp`
3. Do not program. Do not stamp MASTER.
