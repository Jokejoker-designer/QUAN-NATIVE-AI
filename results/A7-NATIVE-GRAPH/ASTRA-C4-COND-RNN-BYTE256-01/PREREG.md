# PREREG — ASTRA-C4-COND-RNN-BYTE256-01

PROGRAM=NO. Named DUT `a7ng_astra_c4_cond_rnn`.
Does not edit `a7ng_astra_c4_lm06_grounded_gen.sv` (`1fbdc00a…`).
Does not edit TinyGPT / `a7lm06_wmem.hex` / live prod_top.
Does not freeze `LM06_BYTE256`. Does not execute WO0550.

Unknown: a compact integer Elman over BYTE256 can consume both context bytes
and a prefix token in the same hidden state used by every next-token score.

Rival 1 of WO-02 (`compact_recurrent_byte256`). Local synthetic LCG checkpoint
seed=7, N_W=1384 int8, no cloud train. Resource formula (not synth):
params=1384 int8; cycles/token ≈ E + H*(E+H) + V*E = 4+96+1024 = 1124 MAC.

HIT if:
- same weights/context, different `seed_tok` → sequence changes
- same weights/prefix, different context bytes → sequence changes
- `evid_has=0` emits `n`,`o`,EOS from the status gate
- evid path emits >=3 tokens, host next-token count = 0
- zero weights change the evid-path sequence

MISS / OPEN:
- held-out language 90/95/5 is not this bag
- C4_MASTER stays OPEN
