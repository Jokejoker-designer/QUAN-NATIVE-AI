# CLOSEOUT — ASTRA-C5-AUTO-REWARD-REGRESS-01

PROGRAM=NO. Falsifier. Does **not** fix live prod_top. Does **not** stamp C5_MASTER.

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C5-AUTO-REWARD-REGRESS-01\run_xsim.ps1
exit=0 (after one TB corrective: Q2 persist_w0==6 is not a gate)
```

## Raw

- GOLDEN.json SHA256 pre-xvlog: `1e12bfbd1153d8e34d16ba4a7fb81b2836b55049dd2fae9ad46359f2cae34d67` (not regenerated)
- DUT unedited `a7ng_astra_c5_prod_top.sv` SHA256 `c4fcca30c945a550f81f0870025c8d52875cd6097dfbfc459aeb1fe47a367922`
- `$finish` 59215 ns
- Marker `ASTRA_C5_AUTO_REWARD_REGRESS_XSIM_PASS`

## Classes

- `CLASS_no_uart_reward_frame HIT`
- `CLASS_auto_rew_pcmt HIT`
- `CLASS_auto_rew_w0 HIT pw0=3`
- `CLASS_auto_rew_w0_q2 MISS pw0=3`

FACT: one UART query `"pump requires indirect"` with no reward opcode still yields `pcmt=1` and C2 `persist_w0=3`.

INFERENCE: Q2 same (subj,rel,obj,ctx) with new gen hits C2 STALE_GEN/DUP, so persist_w0 stays 3. That is extra, not the F04 unknown.

First FAIL (pre-corrective): `W0_Q2` over-constrained vs GOLDEN. Corrective: Q2 is CLASS MISS only.
