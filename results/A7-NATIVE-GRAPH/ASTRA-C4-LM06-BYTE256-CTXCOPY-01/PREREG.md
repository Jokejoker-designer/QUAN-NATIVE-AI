# PREREG — ASTRA-C4-LM06-BYTE256-CTXCOPY-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, TinyGPT,
`a7lm06_wmem.hex`, BYTE256 adapter, or dict DUT. Does not freeze `LM06_BYTE256`.

## One unknown

Can a new named BYTE256 head emit preregistered held-out name tokens at
>=90% / unsupported-safe >=95% / halluc <=5% when candidate IDs come only
from FPGA-visible **PROOF context bytes** (not `a7ng_c4d_ch(obj)` and not
`evid_obj`)?

TB materializes QUERY/PROOF. DUT has proof0/1/2 ports only. Host next-token=0.

## HIT letter this bag may measure (XSim)

```text
CLASS_no_obj_lut
CLASS_query_proof_bytes
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

- KEEP C0/C1/C2 hashes drift
- DUT source contains `a7ng_c4d_ch` or `evid_obj`
- TinyGPT / compose compiled as DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
- `n_host_tok_o != 0`
