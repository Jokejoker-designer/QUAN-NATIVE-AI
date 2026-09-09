# PREREG — ASTRA-C4-LM06-GROUNDED-GEN-HELDOUT-20-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, live
`a7ng_astra_c5_prod_top.sv`, `a7ng_astra_c4_lm06_grounded_gen.sv`,
BYTE256 adapter, frozen TinyGPT `tiny_gpt803k_core` / `a7lm06_wmem.hex`,
or bag `ASTRA-C4-LM06-GROUNDED-GEN-01` GOLDEN.

Does **not** freeze `LM06_BYTE256`. Does **not** self-stamp `C4_MASTER`.

## Why a new bag

Owner asked for 20 held-out questions on compact `grounded_gen`.
Existing bag `ASTRA-C4-LM06-GROUNDED-GEN-01` already hashed GOLDEN
`391ff970…` for the 8-query compact set. That GOLDEN is not rewritten.

## One unknown

On a 20-id held-out object set (IDs 20..39, disjoint from compact 10..17),
do first tokens of `a7ng_astra_c4_lm06_grounded_gen` still depend on
**both** loadable weights and `evid_has` / `evid_obj`, with host next-token = 0?

## HIT this bag may measure (XSim compact V=64)

```text
normal weights + evidence: first-token == evid_obj on >=18/20 (target 20/20)
zero weights: first-token == EOS/safe (0)
corrupt g_match: first-token != evid_obj
evidence removed: first-token == EOS; hallucinated non-EOS <= 5%
EOS/MAX = 100%
host next-token = 0
TinyGPT-802k not DUT
```

## Not this bag

Letter §10 BYTE256 QUERY/PROOF language. First token equals the 8-bit
object class ID (`evid_obj`). That is class-ID emission, not generated
language text. Compact 20/20 here cannot close `C4_MASTER`.

## FAIL if

- KEEP hashes drift
- `a7ng_evidence_compose` or `tiny_gpt803k_core` compiled as DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
- TB chooses next token
- live prod_top or grounded_gen RTL edited
- CLOSEOUT claims C4_MASTER or LM06_BYTE256 freeze
