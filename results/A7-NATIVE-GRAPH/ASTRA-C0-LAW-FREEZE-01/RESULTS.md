# RESULTS — ASTRA-C0-LAW-FREEZE-01

PROGRAM=NO. COM12/JTAG 210319BE776EA untouched this bag. No Vivado. No XSim.
No 800k inspect or generate. Frozen RTL not patched. Silicon bags not
overwritten. V3.1 tree not written.

```text
GATE             = ASTRA-C0-LAW-FREEZE-01
MASTER           = ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL §6
CWD              = D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
BRANCH           = grok-orch/astra-native-v1-00
HEAD             = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
HASH_TOOL        = PowerShell Get-FileHash -Algorithm SHA256
HASH_AT_UTC      = 2026-09-07T01:02:20Z
C1_800K_INSPECT  = NO
BIT              = NOT_BUILT (this bag)
PROGRAM          = NO
PRODUCTION_TOP   = UNKNOWN
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = NOT_CLOSED
LM06_BYTE256     = NOT_FROZEN
DDR_INDEX        = NOT_FROZEN
RESULT           = PASS_THIS_GATE_ONLY
```

## Live hashes vs expected prefixes

| Object | Expected | Live SHA256 | Match |
|---|---|---|---|
| SGD `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef328…` | `b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac` | YES |
| A09-R2 `a7ng_astra_09_r2_cand_ovf.sv` | `15a919f1…` | `15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23` | YES |
| leftover A09 `a7ng_astra_09_integ_path.sv` | `9fdbe0d6…` | `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` | YES |
| checkpoint bit | `e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb` | same | YES |

No expected-prefix mismatch. No invented hash.

## Also recorded (live)

```text
ROLE_PARSER  a7ng_query_role_extract.sv   cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
QSE lexicon  qse_role_lexicon.svh         381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
uart_rx      rtl/board/uart_rx.sv         8e802d0b4f7466d7683c9b0109d6666ba5b5d77cf67e45f5ab7c0564bcd5369a
uart_tx      rtl/board/uart_tx.sv         b4b7d09758cc95bb52a382bf5c11b5861ddcf0f74055d478824386531b36367b
```

Checkpoint wrap instantiates `a7ng_astra_09_r2_cand_ovf u_a09r2` with **no**
parameter overrides → `CAND_CAP=16`, `MAX_PATH=4`. `MAX_HOPS=2` is the Master
freeze and the A09-R2 two-edge compose (silicon smoke `npath=2`). Leftover
A09 is **not** instantiated.

## Deliverables written

```text
docs/ASTRA/authority/FINAL_CONTRACT.json
docs/ASTRA/authority/CURRENT_EVIDENCE_LEDGER.md
docs/ASTRA/authority/OPEN_GATES.md
results/A7-NATIVE-GRAPH/ASTRA-C0-LAW-FREEZE-01/{ACK.json,PREREG.md,RESULTS.md,CLOSEOUT.md,SHA256.txt}
```

## Not claimed

C1–C7. Historical ASTRA-02-U5 as C1. w0 0→-5 as C3. Plant as DDR.
A09R8 as production top. LM06 language. BOARD_PASS. ASTRA-13. Programming
this bag.
