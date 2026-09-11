# E3y — S_DOT `kv`/`qv` operand snap then `prod_r` (last extra E3 gate)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

## Trigger (FACT from E3x MIXED / cone read)

```text
WNS              -1.532 ns   (Δ +0.925 vs E3w; material)
TNS              -101.238 ns
failing          88
top-20           prod_r 20
worst            kv_reg[23][30][15]/C → prod_r_reg[31]/D
levels           10
CARRY4 / DSP     0 / 1
cells            kv mux * qv DSP into prod_r  (S_DOT)
LUT/FF/DSP/BRAM  26915 / 43308 / 12 / 0
n20 SHA          778e6a55838d379afcdf63d394fe621b499e391d7d06def8ed80d986285519b0
```

S_H `vv` cone left. New coherent cone = S_DOT. This is the **one** allowed extra gate (plan §3/§7). Do **not** also pipe S_F2. No `keep`. Do not overwrite `timing_n20_e3x.rpt`.

## Law

```text
prod = kv[ti][di] * qv[di]
S_DOT:      val_r <= kv[ti][di]; qv_r <= qv[di]; ST S_DOT_PROD
S_DOT_PROD: prod_r <= val_r * qv_r; ST S_ACC_MAC
```

Extra cycle allowed. GOLDEN n=242 + both CLASS HITs.

## After this gate

E3_REVIEW. No E3z. STOP if same `kv`→`prod_r` cone, ΔWNS < ~0.15 ns, endpoints not materially better. Do not program. Do not stamp MASTER.
