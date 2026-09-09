# PREREG — ASTRA-C4-LM06-BYTE256-C3PROOF-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, live C3 wrap,
TinyGPT, `a7lm06_wmem.hex`, BYTE256 adapter, ctxcopy, or dict DUT.
Does not freeze `LM06_BYTE256`.

## One unknown

Can a new named BYTE256 head emit preregistered held-out name tokens at
>=90% / unsupported-safe >=95% / halluc <=5% when PROOF bytes are the
FPGA-visible dest-name image of **live C3 ANSWER IDs** (not TB-planted
ASCII, not `evid_obj` LUT)?

TB plants 2-hop graph facts only. Host next-token=0.

## HIT letter this bag may measure (XSim)

```text
CLASS_c3_reasoner_instantiated
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
