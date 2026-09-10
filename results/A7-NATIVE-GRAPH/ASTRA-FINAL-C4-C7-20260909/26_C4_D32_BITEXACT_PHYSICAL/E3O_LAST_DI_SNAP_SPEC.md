# E3o — last-`di` SNAP (measured from E3n MIXED)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3n MIXED)

```text
WNS              -5.840 ns   (Δ +0.158 vs E3m)
TNS              -2060.058 ns
failing          647
top-20           acc 10, rq_snap 10
worst            di_reg[4]_rep__14/C → acc_reg[63]/D
levels           27
CARRY4 / DSP     17 / 1
cells            acc1 / wgt813 (unnamed Q/K/V/F1/LOG)
```

Keep on shared `acc` survived. Last-`di` `acc + product` still flattens into `rq_val_r`. Cone does not name one of Q/K/V/DOT/F1/LOG. Cut **one family**: shared `S_ACC_SNAP` for last-`di` sites. Do **not** SNAP S_F2 (`fi`). Do not retry keep.

Do **not** overwrite `timing_n20_e3n.rpt` or earlier n20/dcp.

## Law

Same bit-exact last MAC. Last `di` only updates `acc`. Next cycle `rq_val_r <= acc` (NBA sees the full sum). Then existing `*_RQ`.

```text
S_Q/K/V/DOT/F1/LOG last di:
  acc <= acc + product     // or first product if di==0
  snap_next <= <that site's RQ>
  st <= S_ACC_SNAP
S_ACC_SNAP:
  rq_val_r <= acc
  st <= snap_next
```

S_F2 last-`fi` snapshot unchanged.

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3o.rpt` / `d32_ooc_e3o.dcp`
3. Do not program. Do not stamp MASTER.
