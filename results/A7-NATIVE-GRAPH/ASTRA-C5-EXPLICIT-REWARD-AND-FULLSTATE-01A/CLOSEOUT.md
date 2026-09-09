# CLOSEOUT — ASTRA-C5-EXPLICIT-REWARD-AND-FULLSTATE-01A

PROGRAM=NO. Named `a7ng_astra_c5_prod_top_rew`. Live `prod_top.sv` hash still
`c4fcca30…`. Does **not** close 01B. Does **not** stamp C5_MASTER.

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C5-EXPLICIT-REWARD-AND-FULLSTATE-01A\run_xsim.ps1
exit=0
```

## Raw

- GOLDEN.json SHA256 `9d1e5747f5413732c51d82564d18674660de827ac004dc494668a5f49644599d`
- `$finish` 226235 ns
- Marker `ASTRA_C5_EXPLICIT_REWARD_01A_XSIM_PASS`

## Classes HIT

query_no_sgd, w32_delta0_two_infer, rew_plus3 (w0=5 after +3), rew_dup, rew_crc,
rew_stale, rew_zero, rew_minus3, rew_frz.

Reward identity is packet txn/gen, not a wire of live `c3_txn`.

REVIEW_PENDING for independent auditor. self_accept=false.
