# E3p — pipeline `di`→DSP off `acc` (measured from E3o Case B)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3o Case B)

```text
WNS              -5.957 ns   (Δ −0.117 vs E3n; slight/flat)
TNS              -1884.503 ns (improved)
failing          620 (improved)
top-20           acc 20 / rq_snap 0
worst            di_reg[4]_rep/C → acc_reg[63]/D
levels           27
CARRY4 / DSP     17 / 1
```

`S_ACC_SNAP` cut `rq_snap` (path-cut PASS). Remaining cone is last-MAC flatten: `di` → DSP48E1 → 17×CARRY4 → `acc[63]`. Cut **one family**: register the product, add into `acc` next cycle. Do **not** SNAP S_F2. Do not drop `acc`/`hacc` keep in this gate. Do not overwrite `timing_n20_e3o.rpt`.

## Law

Same bit-exact MAC. Cycle A writes `prod_r`. Cycle B: `acc <= (di==0) ? prod_r : (acc + prod_r)`. Last `di` then existing `S_ACC_SNAP`. Extra cycles allowed; GOLDEN tokens must match.

```text
S_Q/K/V/DOT/F1/LOG:
  prod_r <= product(di)
  mac_next <= (di==D-1) ? S_ACC_SNAP : <same state>
  st <= S_ACC_MAC
S_ACC_MAC:
  acc <= (di==0) ? prod_r : acc + prod_r
  if mac_next==S_ACC_SNAP: st <= S_ACC_SNAP
  else: di++; st <= mac_next
```

S_F2 last-`fi` snapshot unchanged.

## Gate

1. GOLDEN.svh n=242 (`CLASS_ref_match` + `CLASS_host_tok0`)
2. New OOC `timing_n20_e3p.rpt` / `d32_ooc_e3p.dcp`
3. Classify vs E3o −5.957. If `acc` still 20/20 **and** source still `di_reg` through DSP → Case C (pipe collapsed). If dest still `acc` but source left `di` → MIXED, read cone.
4. Do not program. Do not stamp MASTER.

## Pause 2026-09-10 14:24 +07

User reboot. RTL `S_ACC_MAC` + `prod_r` is in tree (DUT SHA256 `88aa7634ef76435f5eeda8c9e9690d747f810f7a8f4381dc93c4fbf2f8002668`). GOLDEN and E3p OOC **not** run. Resume: BASIC free → GOLDEN n=242 → `run_e3p_ooc.ps1`.
