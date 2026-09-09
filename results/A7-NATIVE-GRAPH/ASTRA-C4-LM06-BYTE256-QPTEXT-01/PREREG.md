# PREREG — ASTRA-C4-LM06-BYTE256-QPTEXT-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, live C3 wrap,
TinyGPT, `a7lm06_wmem.hex`, BYTE256 adapter, ctxcopy, dict DUT, or C3PROOF DUT.
Does not freeze `LM06_BYTE256`.

## One unknown

Can a new named BYTE256 head emit a weight-selected glue token then the
FPGA-visible hop-2 object name at >=90% / unsupported-safe >=95% / halluc <=5%
when QUERY/PROOF bytes are the FPGA dict of live C3 subject + proof0 eid +
hop-2 object (not TB-planted ASCII, not ans-only dest copy as tok0)?

TB plants 2-hop graph facts only. Host next-token=0.

## HIT letter this bag may measure (XSim)

```text
CLASS_c3_reasoner_instantiated
CLASS_query_proof_bytes
CLASS_glue_from_weights
CLASS_tok0_not_ans_dict
CLASS_ans_matches_planted_dest
CLASS_grounded_acc_ge90
CLASS_unsupported_safe_ge95
CLASS_halluc_le5
CLASS_w_zero_differs
CLASS_evid_replaced_changes
CLASS_host_next_token_zero
```

TinyGPT-802k retraining is out of scope. Silicon is out of scope.
This bag must not self-stamp `C4_MASTER=CLOSED`.

## FAIL if

- KEEP C0/C1/C2 or live C3 wrap hashes drift
- TinyGPT / compose / dict DUT compiled as DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
- `n_host_tok_o != 0`
