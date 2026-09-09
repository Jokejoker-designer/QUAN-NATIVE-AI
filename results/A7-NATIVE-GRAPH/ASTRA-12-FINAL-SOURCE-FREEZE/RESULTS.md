# RESULTS — ASTRA-12 FINAL-SOURCE-FREEZE

```text
GATE            = ASTRA-12-FINAL-SOURCE-FREEZE
RESULT          = PASS_NARROW (source hash freeze of ASTRA pipe; not Gate14; not board)
HEAD            = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
V31_WRITES      = 0
NEXT            = ASTRA-13 BLOCKED until pinmap + language policy + owner program gate
```

## DAG freeze table

| Gate | Result | Evidence |
|------|--------|----------|
| ASTRA-00 | PASS | authority freeze bag |
| ASTRA-01 | PASS | QSE→4×4096 AXI, n_host=0 |
| ASTRA-02 | PASS_NARROW | recall@cap=1.0 N=256..800k; overflow XSim; precision 11% not claimed |
| ASTRA-03 | PASS | qse-v2-role-00 reverse pairs differ; v1 SHA unchanged EDE064F0… |
| ASTRA-04 | PASS_NARROW | 2-hop join on loaded edges, not DDR |
| ASTRA-05 | PASS_NARROW | delete/replace/conflict/cap change answer; A→C not stored |
| ASTRA-06 | PASS_NARROW | unit SGD 0 / 688 / 48 on constant x |
| ASTRA-07 | PASS | 5-seed held-out 24/24 vs frozen/shuffle; per-ID fails transfer |
| ASTRA-08 | LM06_ACTIVE_BUT_LANGUAGE_UNPROVEN | datapath exists; NLU not proven |
| ASTRA-09 | PASS_NARROW | unified XSim path, host does not poke winner |
| ASTRA-10 | PASS_NARROW | OOC synth a7ng_unified_pipe LUT 2966 FF 1386 DSP 2 BRAM 0 |
| ASTRA-11 | BLOCKED_NO_PINMAP | no reviewed I/O into frozen SoC |
| ASTRA-12 | PASS_NARROW | this bag |
| ASTRA-13 | NOT STARTED | PROGRAM=NO |

v1 extractor SHA frozen: `ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768`
v1 lexicon SHA frozen: `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7`

## Not claimed

Gate14, board, NLU, 800k unique-key semantic precision, fullchip co-fit, bitstream uniqueness.
