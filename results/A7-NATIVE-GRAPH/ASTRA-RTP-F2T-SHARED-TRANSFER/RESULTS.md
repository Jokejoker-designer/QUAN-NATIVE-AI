# RESULTS — F2-T shared-feature transfer

```text
XSIM=ASTRA_RTP_F2T_XSIM_PASS
SGD=a7ng_shared_rank_sgd_q8_v1 (NOT DSP timing-fix)
FEATURE=hop1 object CLASS [83:76], not mid==1/8
PROGRAM=NO
```

TRAIN: two proofs class1 (17,34) vs class2 (18,35). R0 pick class1 (tie-break). Reward -3 → w0=-6 w1=0.

HOLD world **new IDs** 0x11111/0x22222 class1 vs 0x33333/0x44444 class2. Pick class2 p0=0x33333.

Auditor: 2-class one-hot of planted CLASS byte `[83:76]` on new eids — not 32-φ / paraphrase / LM06. F4/F5 still open.
