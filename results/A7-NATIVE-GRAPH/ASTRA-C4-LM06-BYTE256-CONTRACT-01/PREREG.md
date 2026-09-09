# PREREG — ASTRA-C4-LM06-BYTE256-CONTRACT-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, frozen LM-06
`tiny_gpt803k_core.sv` / `a7lm06_pkg.sv`, or official `mig.prj`.
Does not freeze `LM06_BYTE256`, `DDR_QUERY_BOUND_FINAL`, or `PERSIST_SCHEMA_VERSION`.
Does not overwrite the historical 653/689/237/60 oracle.

## One unknown

Can a **new named** BYTE256 compatibility adapter expose 8-bit input/output tokens,
keep a physical 10-bit head visible, and mask token IDs 256..1023, with a shared
byte vocabulary — without claiming grounded generation quality?

## HIT letter this bag may measure (XSim)

```text
in_tok width  = 8
out_tok width = 8, valid domain 0..255
physical head10 present (10-bit winner visible even when masked)
winner >= 256 => out_valid=0, masked_hi=1
historical 653 and 689 ( >=256 ) are masked
shared vocab: in_tok byte domain == out_tok byte domain
host next-token choice = 0
historical 653/689/237/60 is NOT this bag's gold
```

Grounded-gen 90%/ablations are **out of scope** (`ASTRA-C4-LM06-GROUNDED-GEN-01`).
This bag must not compile `tiny_gpt803k_core` as DUT (frozen LM-06, different unknown).

## Quality bound

Argmax is over four planted 10-bit candidate IDs, not the 802,816-parameter LM
forward. That is enough to prove the **contract/mask**, not language.
`LM06_BYTE256` stays NOT_FROZEN in FINAL_CONTRACT.
Do not self-stamp `C4_MASTER=CLOSED` or `BOARD_PASS`.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- Frozen LM-06 core edited
- GOLDEN edited after xvlog
- PROGRAM=YES
- Grounded-gen 90% claimed from this bag
- Historical 10-bit oracle used as BYTE256 gold
