# RESULTS — ASTRA-C4-LM06-BYTE256-ARLANG-01

```text
GATE            = ASTRA-C4-LM06-BYTE256-ARLANG-01
XSIM            = ASTRA_C4_LM06_BYTE256_ARLANG_XSIM_PASS
RESULT          = PASS_THIS_GATE_ONLY
C4_MASTER       = OPEN
LM06_BYTE256    = NOT_FROZEN
TINYGPT_802K    = RETIRED_PER_GROK_550
BOARD_PASS      = REJECT
PROGRAM         = NO
DUT             = a7ng_astra_c4_lm06_byte256_arlang_gen
$finish         = 27820055 ns
GOLDEN_PRE      = c6b5c0f4fcf80d0ea339f992a7ca2d1f332ca766f12e59b3d062111cc9e11090
```

Python HOLD 20/20 before hex export. GOLDEN hashed before xvlog. KEEP MATCH.

## Raw measured

```text
CLASS_grounded_acc_ge90 HIT acc=20/20
CLASS_ar_yes_prefix HIT n=20/20
CLASS_w_zero_safe HIT n=20/20
CLASS_w_corrupt_not_gold HIT n=20/20
CLASS_evid_removed_safe HIT n=20/20
CLASS_evid_removed_halluc_le5 HIT hall=0/20
CLASS_host_next_token_zero HIT
CLASS_eos_or_max HIT saw_eos=20
ASTRA_C4_LM06_BYTE256_ARLANG_XSIM_PASS
```

Held-out dest IDs 40..59. Sequence `yes` + dest-name + EOS. Not 802k. Not C4_MASTER.
