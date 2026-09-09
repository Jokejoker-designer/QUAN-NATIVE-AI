# First failure (preserved)

```text
FIRST_DIVERGENCE = ISO_M3_X64_DW6
MARKER           = ASTRA_F2R2_HS_LAW_XSIM_FAIL n=11
RAW              = xsim_fail_r0.log
SHA256           = bed425f60c614423d4b98d99251a8bdfe45629367f3d30e57d1b56a23bab19f3
```

Observed: ISO +3 x0=50 produced dw0=+5 (symmetric law OK vs floor +4).
ISO -3 and all negative-reward 32-weight compares sat16 to +32767.

Cause (RTL_FACT): `32'(dw40[15:0])` / `32'(w)` zero-extend of part-selects treated negative deltas as large unsigned adds.

Corrective (same bag, one revision): explicit sign-extend `w_se`/`dw_se`/`rew_se` in `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. TB oracles not edited.
