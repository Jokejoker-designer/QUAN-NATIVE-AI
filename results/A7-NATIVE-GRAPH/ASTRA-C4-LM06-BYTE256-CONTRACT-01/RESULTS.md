# RESULTS — ASTRA-C4-LM06-BYTE256-CONTRACT-01

```text
GATE            = ASTRA-C4-LM06-BYTE256-CONTRACT-01
XSIM            = ASTRA_C4_LM06_BYTE256_CONTRACT_XSIM_PASS
RESULT          = PASS_THIS_GATE_ONLY
C4_MASTER       = OPEN
LM06_BYTE256    = NOT_FROZEN
BOARD_PASS      = REJECT
PROGRAM         = NO
BIT             = NOT_BUILT
DUT             = a7ng_astra_c4_lm06_byte256 (NEW named adapter)
FROZEN_LM06     = tiny_gpt803k_core / a7lm06_pkg NOT compiled, NOT edited
```

GOLDEN hashed before xvlog (`ca9a48a4b2fcaab9986ad720713eeabba61be0d7120a4e9f448fc02539dfa8f0`). KEEP C0/C1/C2 hashes MATCH.

## Raw measured (xsim.log)

```text
CLASS_in_tok_width_8 HIT in_w=8
CLASS_phys_head10_present HIT head_w=10
CLASS_hist_oracle_not_this_gold HIT ids=653,689,237,60 unused_as_gold
CLASS_out_domain_0_255 HIT tok=65
CLASS_shared_byte_vocab HIT tok=74
CLASS_mask_ge256 HIT head10=256
CLASS_hist_653_masked HIT head10=653
CLASS_hist_689_masked HIT head10=689
CLASS_host_next_token_zero HIT
ASTRA_C4_LM06_BYTE256_CONTRACT_XSIM_PASS
C4_MASTER_CLAIM=NO BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN
```

## Quality bound (do not promote)

Evidence class **XSIM**. Argmax is four planted 10-bit candidates, not the 802,816-parameter LM06 forward, not materialized reasoner evidence, not 90% grounded accuracy.
This is the **BYTE256 wire/mask contract** only. Historical 10-bit oracle 653/689/237/60 is not this gold.

## KEEP

No C0/C1/C2 KEEP edited. Frozen LM-06 core not edited.
