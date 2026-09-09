# PREREG — ASTRA-C4-LM06-BYTE256-ARLANG-01

PROGRAM=NO. Frozen before xvlog. Does not edit KEEP C0/C1/C2, live prod_top,
live grounded_gen, qptext_gen, TinyGPT core / `a7lm06_wmem.hex`.

Does **not** freeze `LM06_BYTE256`. Does **not** self-stamp `C4_MASTER`.

## One unknown

Can a compact tied-embed autoregressive BYTE256 head emit ASCII
`yes` + dest-name tokens from loadable embeddings and PROOF dest-name bytes,
with host next-token = 0, on 20 held-out dest IDs 40..59?

## HIT this bag may measure

```text
normal: seq == [121,101,115,ch0,ch1,ch2,0] on >=18/20
zero embeddings: first token EOS
corrupt (negated dots): sequence != gold
evidence removed: first token EOS; halluc <= 5%
EOS/MAX = 100%
TinyGPT not DUT
```

## Not this bag

Letter §10 Master close. Dest-name still enters through obj ports gated by G[].
This is compact AR language-shaped output, not 802k LM06.

## FAIL if

- KEEP drift, GOLDEN edited after xvlog, PROGRAM=YES, TB chooses next token
- tiny_gpt803k_core or a7ng_evidence_compose as DUT
- overwrite a7lm06_wmem.hex
