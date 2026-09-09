# RESULTS — ASTRA-C4-LM06-GROUNDED-GEN-HELDOUT-20-01

```text
GATE            = ASTRA-C4-LM06-GROUNDED-GEN-HELDOUT-20-01
XSIM            = ASTRA_C4_LM06_GROUNDED_GEN_HELDOUT20_XSIM_PASS
RESULT          = PASS_THIS_GATE_ONLY
C4_MASTER       = OPEN
LM06_BYTE256    = NOT_FROZEN
TINYGPT_802K    = RETIRED_PER_GROK_550
BOARD_PASS      = REJECT
PROGRAM         = NO
DUT             = a7ng_astra_c4_lm06_grounded_gen (unedited compact linear head)
BYTE256         = a7ng_astra_c4_lm06_byte256 (instantiate, not edited)
NOT_DUT         = tiny_gpt803k_core, a7ng_evidence_compose, live prod_top
$finish         = 76175 ns
GOLDEN_PRE      = 56dc578db9f2908220b2c37265a18c27a543ecb20444f2180f52dd461722516e
DUT_SHA         = 1fbdc00a4e040b2ffd925dfc8477129f4c14247768ceb0c73cbf3a31d5f2503b
```

GOLDEN hashed before xvlog. KEEP C0/C1/C2 hashes MATCH.

## Raw measured (xsim.log)

```text
CLASS_not_compose_renderer HIT dut=a7ng_astra_c4_lm06_grounded_gen
CLASS_not_tinygpt_802k HIT tinygpt=RETIRED_PER_GROK_550
CLASS_w_normal_grounded HIT acc=20/20
CLASS_grounded_acc_ge90 HIT acc=20/20
CLASS_w_zero_safe HIT n=20/20
CLASS_w_corrupt_not_gold HIT n=20/20
CLASS_evid_removed_safe HIT n=20/20
CLASS_evid_removed_halluc_le5 HIT hall=0/20
CLASS_host_next_token_zero HIT
CLASS_eos_or_max HIT saw_eos=20
ASTRA_C4_LM06_GROUNDED_GEN_HELDOUT20_XSIM_PASS
C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO LM06_BYTE256=NOT_FROZEN
```

Held-out IDs 20..39 (disjoint from compact bag 10..17).
Normal path copies `evid_obj` into tok0. That is class-ID emission, not QUERY/PROOF language.

## KEEP

No C0/C1/C2 KEEP edited. Live prod_top unedited. Frozen LM-06 core not DUT.
BYTE256 adapter not edited. Frozen GROUNDED-GEN-01 GOLDEN not rewritten.
