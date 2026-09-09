# PREREG — ASTRA-C4-LM06-BYTE256-DICT-HELDOUT-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, frozen LM-06
`tiny_gpt803k_core.sv` / `a7lm06_pkg.sv`, `a7ng_evidence_compose.sv`, or
`a7ng_astra_c4_lm06_byte256.sv`.
Does not freeze `LM06_BYTE256` in FINAL_CONTRACT.

## One unknown

On a preregistered held-out set, does compact BYTE256 consume FPGA-visible
QUERY/PROOF dictionary bytes (not a host-written sentence) and emit grounded
object-name tokens with letter thresholds, with output depending on loadable
weights and evidence, host next-token = 0?

## HIT letter this bag may measure (XSim compact dict)

```text
path: dictionary QUERY/PROOF → compact LM start → name tokens → feedback → EOS
host next-token = 0
held-out n=20 objs {20..39} disjoint from declared train {10..19}
grounded acc >= 90%
unsupported/unrelated safe >= 95%
hallucinated unsupported fact <= 5%
EOS/MAX = 100% on scored queries
zero weights: first-token == EOS (not gold name)
evidence replaced (obj 20→50): name bytes change
a7ng_evidence_compose / tiny_gpt803k_core not compiled as DUT
```

TinyGPT-802k, silicon LM06, and C6 co-fit of this DUT are **out of scope**.
This bag must not self-stamp `C4_MASTER=CLOSED` or `BOARD_PASS`.
Quality bound: compact copy-from-PROOF-span head, VOCAB_VER=1 ASCII dict.

Offline weight construction is declared (g_copy/g_safe/g_eos load). Not online
FPGA reward training.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- `a7ng_evidence_compose` or `tiny_gpt803k_core` compiled as DUT
- BYTE256 adapter source edited
- GOLDEN edited after xvlog
- PROGRAM=YES
- TB chooses next token
