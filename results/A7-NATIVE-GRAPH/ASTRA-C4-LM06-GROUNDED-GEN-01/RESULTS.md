# RESULTS — ASTRA-C4-LM06-GROUNDED-GEN-01

```text
GATE            = ASTRA-C4-LM06-GROUNDED-GEN-01
XSIM            = ASTRA_C4_LM06_GROUNDED_GEN_XSIM_PASS
RESULT          = PASS_THIS_GATE_ONLY
C4_MASTER       = OPEN
LM06_BYTE256    = NOT_FROZEN
BOARD_PASS      = REJECT
PROGRAM         = NO
DUT             = a7ng_astra_c4_lm06_grounded_gen (NEW compact linear head)
BYTE256         = a7ng_astra_c4_lm06_byte256 (instantiate, not edited)
NOT_DUT         = tiny_gpt803k_core, a7ng_evidence_compose
```

GOLDEN hashed before xvlog (`391ff97005991ea27bdb9b0c8631ce132785cf6d1f694d4f624082116bca3306`). KEEP C0/C1/C2 hashes MATCH.

## Raw measured (xsim.log)

```text
CLASS_not_compose_renderer HIT
CLASS_w_normal_grounded HIT acc=8/8
CLASS_w_zero_safe HIT tok0=0
CLASS_w_corrupt_not_gold HIT tok0=0 gold=10
CLASS_evid_removed_safe HIT tok0=0
CLASS_evid_replaced_changes HIT tok0=30 not 10
CLASS_host_next_token_zero HIT
CLASS_eos_or_max HIT
CLASS_path_evid_lm_feedback_eos HIT n_supported=8 acc=8
ASTRA_C4_LM06_GROUNDED_GEN_XSIM_PASS
C4_MASTER_CLAIM=NO BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN
```

Ablations: tokens change when weights are zero/corrupted and when evidence is removed/replaced. Feedback to EOS is internal (`n_host=0`).

## Quality bound (do not promote)

Evidence class **XSIM**. Compact V=64 linear head (match / safe / step-EOS weights), not TinyGPT-802k, not teacher-off 90% language, not QUERY/PROOF text materializer.
`a7ng_evidence_compose` is a packer/renderer and was **not** compiled as DUT.

## KEEP

No C0/C1/C2 KEEP edited. Frozen LM-06 core not edited. BYTE256 adapter not edited.
