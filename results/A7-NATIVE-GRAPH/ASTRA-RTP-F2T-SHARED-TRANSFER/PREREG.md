# PREREG — F2-T shared-feature transfer

```text
SGD = a7ng_shared_rank_sgd_q8_v1 (NOT timing-fix DSP)
FEATURE = object CLASS of hop-1 (desc[83:76]), never raw mid ID
PROGRAM = NO
```

World TRAIN: class1 path eids 17,34; class2 path 18,35. Same query.
R0 w=0 pick min proof0 (class1). Reward -3 on selected class feature.
World HOLD: NEW ids 0x11111/0x22222 class1 and 0x33333/0x44444 class2.
Expect pick class2 (0x33333). Control ID-table would still prefer 17-like min-id and fail.

If R1 still class1: FAIL transfer.
