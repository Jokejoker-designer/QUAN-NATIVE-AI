# PREREG — ASTRA-C0-LAW-FREEZE-01

Frozen before any C1 800k inspect. PROGRAM=NO (no JTAG / xsdb / COM12 /
`write_bitstream` / hw_server / Vivado this bag). Does not patch frozen RTL.
Does not overwrite silicon bags (`ASTRA-11-A09R8-SILICON-UART-01`,
`ASTRA-11-A09R8-UART-FREEZE-BIT-01`) or any prior evidence bag. Does not write
the V3.1 tree. Does not freeze `PRODUCTION_TOP`. Does not claim `BOARD_PASS`.

## Primary unknown (Master V1.1 §6)

Can all remaining work use one stable representation and one final acceptance
contract?

## Claim this bag may close

Record live SHA256 of the checkpoint laws **before** C1 confirmation data is
inspected:

```text
ROLE_PARSER_LAW / QSE   a7ng_query_role_extract.sv + qse_role_lexicon.svh
LEARNER_LAW / SGD       a7ng_shared_rank_sgd_q8_sym_f2r2.sv  expected b66ef328…
A09-R2 DUT              a7ng_astra_09_r2_cand_ovf.sv         expected 15a919f1…
leftover A09            a7ng_astra_09_integ_path.sv          expected 9fdbe0d6…
                        NOT instantiated in checkpoint wrap
uart_rx / uart_tx       live hashes
checkpoint bit          e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
CAND_CAP                16  (currently instantiated default)
MAX_HOPS                2   (Master freeze; 2-edge compose in A09-R2)
MAX_PATH                4   (currently instantiated default)
LM06_BYTE256            NOT_FROZEN
DDR_INDEX               NOT_FROZEN
```

Deliverables: `docs/ASTRA/authority/FINAL_CONTRACT.json`,
`CURRENT_EVIDENCE_LEDGER.md`, `OPEN_GATES.md`, plus this bag.

## PASS / FAIL (this gate only)

```text
PASS_THIS_GATE_ONLY  live hashes recorded; every expected prefix MATCH
FAIL                 any expected hash mismatch (do not invent a substitute)
```

C1–C7 remain OPEN after PASS. Historical `ASTRA-02-U5-SCALE-SELECTIVITY-800K`
is pre-role-law evidence and **cannot** close C1.

## Not this bag

Vivado. XSim. 800k inspect/generate. Programming. New bitstream. Auditor
report. C1 scores. Production top identity. ASTRA-13. BOARD_PASS.
