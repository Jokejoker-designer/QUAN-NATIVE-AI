# PREREG — ASTRA-C4-LM06-802K-GROUNDED-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, frozen LM-06
`tiny_gpt803k_core.sv` / `a7lm06_pkg.sv` / weight tiles, or
`a7ng_astra_c4_lm06_byte256.sv`. Does not compile `a7ng_evidence_compose`.
Does not freeze `LM06_BYTE256` in FINAL_CONTRACT.

## One unknown

Can frozen TinyGPT-802k (`tiny_gpt803k_core`, SIM_FULL, checkpoint
`tests/xsim/a7lm06_wmem.hex`) consume FPGA-materialized QUERY/PROOF bytes,
run start_fwd → pred → BYTE256 mask → token feedback → EOS/MAX, with host
next-token = 0, and do the measured weight/evidence ablations?

## HIT letter this bag may measure (XSim 802k path)

```text
tiny_gpt803k_core compiled as DUT (this named bag only)
path: evid bytes → TinyGPT start_fwd → BYTE256 → token → feedback → EOS/MAX
host next-token = 0
a7ng_evidence_compose not compiled
CLASS_acc_reported with n/hits/acc_pp
CLASS_grounded_acc_ge90 is measured, not tautology-forced
```

Master bounded-domain 90%/95%/hallucinate<=5% is **not** this-gate PASS
criterion. Frozen LM-06 weights are the historical 653/689/237/60 language
law, not an Astra QUERY/PROOF grounded checkpoint. This bag must not
self-stamp `C4_MASTER=CLOSED`.

## Quality bound

N_supported=2 (obj 10,11). MAX_TOKENS=2. UART/silicon/C6 fit out of scope.
TinyGPT+wt BRAM additive LIMIT on xc7a100t is already measured (260>135);
this bag is XSim path only. Offline grounded-language retraining is a
different named bag.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- `tiny_gpt803k_core` / `a7lm06_pkg` edited
- `a7ng_evidence_compose` compiled
- GOLDEN edited after xvlog
- PROGRAM=YES
- TB chooses next token (`n_host_tok_o != 0`)
- BYTE256 adapter edited
