# E3r — pipeline S_F2 `fi`→DSP off `acc` (measured from E3q Case B)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3q Case B)

```text
WNS              -4.089 ns   (Δ +1.131 vs E3p; slight/flat)
TNS              -1556.346 ns (improved)
failing          627 (improved)
top-20           acc 13, smres/elut 7; hacc 0
worst            fi_reg[5]/C → acc_reg[63]/D
levels           24
CARRY4 / DSP     17 / 1
```

E3q cut `vv`→`hacc`. Remaining named dest is S_F2 last-`fi` flatten into shared `acc` (deferred until now). Cut **one family**: register the F2 product, add into `acc` next cycle, last `fi` uses existing `S_ACC_SNAP`. Do not re-pipe Q/K/V/DOT. Do not overwrite `timing_n20_e3q.rpt`.

## Law

```text
S_F2:
  prod_r <= wgt8(W2[dj*Ff+fi]) * tv[fi]
  mac_next <= (fi==Ff-1) ? S_ACC_SNAP : S_F2
  st <= S_F2_MAC
S_F2_MAC:
  acc <= (fi==0) ? prod_r : acc + prod_r
  if mac_next==S_ACC_SNAP: st <= S_ACC_SNAP
  else: fi++; st <= S_F2
S_ACC_SNAP:
  rq_val_r <= acc   // existing
```

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3r.rpt` / `d32_ooc_e3r.dcp`
3. Classify vs E3q −4.089. Next named family only (likely `elut`/smres if `acc` leaves).
4. Do not program. Do not stamp MASTER.
