# E3m — S_H acc-only (measured from E3l top-N)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3l MIXED / strong WNS)

```text
WNS              -6.543 ns   (Δ +8.498 vs E3k)
TNS              -1971.193 ns
failing          583
top-20           acc 15, rq_snap 5
worst            vv_reg[23][24][15]/C → acc_reg[63]/D
levels           26
CARRY4 / DSP     12 / 2
cells            acc2_i_*
```

S_Y cone is no longer worst. The named cone is S_H MAC recurrence flattened into combo. Cut **S_H acc only**. Do not retouch S_Y.

Do **not** overwrite `timing_n20_e3l.rpt` or earlier n20/dcp.

## Law

Dedicated kept accumulator. Last `ti` does not combo-feed `rq_val_r`.

```text
S_H:      hacc <= (ti==0) ? attn[0]*vv[0][dj] : hacc + attn[ti]*vv[ti][dj]
          last ti → S_H_SNAP
S_H_SNAP: rq_val_r <= hacc   // hacc already includes last product (NBA)
        → S_H_RQ → S_H_FIN
```

`(* keep = "true" *)` on `hacc` only. Shared `acc` unchanged for other states.

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3m.rpt` / `d32_ooc_e3m.dcp`
3. Do not program. Do not stamp MASTER.
