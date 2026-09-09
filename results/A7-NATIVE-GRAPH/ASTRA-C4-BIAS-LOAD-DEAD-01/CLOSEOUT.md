# CLOSEOUT — ASTRA-C4-BIAS-LOAD-DEAD-01

PROGRAM=NO. Falsifier. Does **not** fix `grounded_gen`. Does **not** stamp C4_MASTER.

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C4-BIAS-LOAD-DEAD-01\run_xsim.ps1
exit=0
```

## Raw

- GOLDEN.json SHA256 pre-xvlog: `4d289f8095f027d54c0157508c062590d02bfab2a046b62e2e51f1c4ff19e679`
- DUT unedited `a7ng_astra_c4_lm06_grounded_gen.sv` SHA256 `1fbdc00a4e040b2ffd925dfc8477129f4c14247768ceb0c73cbf3a31d5f2503b`
- `$finish` 1815 ns
- Marker `ASTRA_C4_BIAS_LOAD_DEAD_XSIM_PASS`

## Classes

- `CLASS_v_slice_is_zero HIT V5_0=0`
- `CLASS_bias_idx1_rejected HIT tok0=0`
- `CLASS_bias_idx63_rejected HIT tok0=0`

FACT: `A7NG_C4G_V=64` truncated as `V[5:0]` is 0, so `load_idx_i < 0` rejects every bias write. Loading 200 at idx 1 and 63 with g_*=0 and evid_obj=10 still emits tok0=0 (not 1 or 63).

Limitation: does not separately print prefix/last_tok independence (WO-02 remaining). First divergence if this were a functional bag: tok0!=1 after LD_BIAS idx=1.
