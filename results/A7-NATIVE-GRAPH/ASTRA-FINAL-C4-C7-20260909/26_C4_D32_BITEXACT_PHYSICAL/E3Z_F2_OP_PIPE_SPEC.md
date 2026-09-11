# E3z — S_F2 `W2`/`tv` operand snap then `prod_r` (new written plan)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 or Gemini.

This file **overrides** `E3_REVIEW.md` §3 for **one** additional local OOC gate. It does not authorize E3aa, post-route C6, programming, or MASTER.

## Trigger (FACT from E3y MIXED / cone read)

```text
WNS              -1.332 ns   (Δ +0.200 vs E3x; not the E3y stop_local kv cone)
TNS              -88.438 ns
failing          88
top-20           prod_r 20
worst            fi_reg[5]/C → prod_r_reg[31]/D
levels           8
CARRY4 / DSP     1 / 1
cells            fi → W2 mux * tv DSP into prod_r  (S_F2)
LUT/FF/DSP/BRAM  26799 / 43326 / 12 / 0
n20 SHA          7c59f524db4c3f4ccf905433e6b35597620008b35a55728924a4615361f075da
DUT SHA          a39c39c08b682dc8f1134105268e93e7528a3d17e8abce30485cd168bfad1879
```

E3r already registered F2 *product* into `acc` (`S_F2_MAC`). E3u explicitly did **not** pipe F2 operands. Remaining critical cone is still `prod_r <= wgt8(W2[dj*Ff+fi]) * tv[fi]` in the same cycle as `fi`. Cut **that** multiply only. Do not re-pipe Q/K/V/DOT/H. No new `keep`. Do not overwrite `timing_n20_e3y.rpt`.

WO §12 allows pipeline without changing integer semantics. Forbidden: reduce D/F, change quant, drop F/R bank, replace decoder with dictionary.

## Law

```text
prod = wgt8(W2[dj*Ff+fi]) * tv[fi]
S_F2:       w8_r <= wgt8(W2[dj*Ff+fi]); val_r <= tv[fi]; ST S_F2_PROD
S_F2_PROD:  prod_r <= w8_r * val_r; ST S_F2_MAC
S_F2_MAC:   KEEP  acc <= (fi==0) ? prod_r : acc+prod_r
```

Extra cycle allowed. GOLDEN n=242 + both CLASS HITs. Tokens must match.

## After this gate

Classify vs E3y −1.332 / `fi`→`prod_r` 20/20.

- A/B: `prod_r` left top-20 → record the new named family. Do **not** auto-start the next pipe in the same run.
- C: still `fi`→`prod_r` 20/20 and ΔWNS < ~0.15 and endpoints not materially better → STOP local E3.
- MIXED: read `timing_n20_e3z.rpt`.

Do not program. Do not stamp MASTER. OOC WNS≥0 is still **not** WO §19 physical PASS.
