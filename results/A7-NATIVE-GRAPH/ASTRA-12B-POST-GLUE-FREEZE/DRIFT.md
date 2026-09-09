# ASTRA-12B freeze vs live — unexpected SGD drift

```text
EXPECTED_GLUE_ONLY = NO
FIX_RTL            = NO (observer stop; no revert this tick)
PROGRAM            = NO
COM12              = PLUGGED_UNPROGRAMMED
JTAG               = 210319BE776EA UNTOUCHED
BOARD_PROMOTE      = NO
F2_STARTED         = NO
XSDB_FPGA          = NO
LM06               = NOT_INTEGRATED
```

Observer tick `01a0723a2dd4` at 2026-09-05T23:22+07 hashed `SHA256.txt` (15 paths).

| Check | Count |
|-------|------:|
| MATCH | 14 |
| DRIFT | 1 |
| MISSING | 0 |

Documented post-glue files (allowed vs ASTRA-12, authority = this 12B bag): **MATCH**.

| File | 12B SHA256 | live |
|------|------------|------|
| `rtl/native_graph/integrate/a7ng_query_axi_sparse.sv` | `5a4ad04d…` | MATCH |
| `rtl/native_graph/integrate/a7ng_astra09_pipe.sv` | `48c9e480…` | MATCH |
| `rtl/native_graph/integrate/a7ng_unified_pipe.sv` | `5c82ad95…` | MATCH |
| `rtl/native_graph/query/a7ng_query_struct_extract.sv` | `ede064f0…546768` | MATCH |

Unexpected (not one of the three glue files):

| File | 12B / ASTRA-06 SHA256 | live SHA256 | mtime |
|------|------------------------|-------------|-------|
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8.sv` | `1786bd82f36a0872b93215dadf471b5db84e68ee8c86ba686e7ea7051f38767b` | `c6f37a273960a3187934b1439c74915a913bf5b12e44114a907e714036061a1f` | 2026-09-05 23:09:57 +07 |

Live header claims DSP `AREG`/`MREG`/`PREG` pipelining. That is the cancelled ASTRA-11 timing-fix target, not F2. No `ASTRA-11-TIMING-FIX` bag. No F2 bag. Do not treat this as F2 ranker-before-select.

## Recorded, not started

- `results/A7-NATIVE-GRAPH/ASTRA-RTP-RETRIEVAL-TO-PROOF/RESULTS.md` exists: **PASS_NARROW** (`ASTRA_RTP_XSIM_PASS`). F1 closed on XSim causality. TB_LOAD=0. PROGRAM=NO.
- `unblocked_item` was `F2_RANKER_BEFORE_SELECT`. **No second writer.** No F2 `RESULTS.md`. F2 not opened this tick.
- ASTRA-11 wrap remains **PASS_NARROW_SCAFFOLD**, WNS=-4.765 ns, bit **UNPROGRAMMED**. Not promoted to board.
- ASTRA-13 **BLOCKED**. PROGRAM=NO.

## Independent acceptance (unchanged)

`ACCEPT_PARTIAL_RESEARCH` / `REJECT_FINAL_PROMOTION`

LM06 on this SoC path = **NOT_INTEGRATED**. Unit 00–07 RTL not reopened this tick. `a7ng_astra09_pipe` hash still 12B.

## Stop

Tick law: unexpected drift → `DRIFT.md`, stop. Do not revert SGD here. Do not start F2 until 12B hashes match or a new freeze bag is authorized.

## Recheck 2026-09-05T23:41+07

Same 14 MATCH / 1 DRIFT. SGD live still `c6f37a27…`, mtime unchanged 23:09:57. Glue + v1 QSE still MATCH. No revert this tick. PROGRAM=NO.

## Recheck 2026-09-06T00:00+07

Still 14 MATCH / 1 DRIFT. SGD live `c6f37a273960a3187934b1439c74915a913bf5b12e44114a907e714036061a1f`, mtime 2026-09-05 23:09:57. Glue + v1 QSE MATCH. `unblocked_item` was `F2_REWARD_WEIGHT_UPDATE` — not started (would retarget drifted ASTRA-06 SGD). PROGRAM=NO.

## Recheck 2026-09-06T00:22+07

Still 14 MATCH / 1 DRIFT. SGD live `c6f37a273960a3187934b1439c74915a913bf5b12e44114a907e714036061a1f`, mtime unchanged 2026-09-05 23:09:57. Glue + v1 QSE MATCH. No revert this tick.

HOP3 `results/A7-NATIVE-GRAPH/ASTRA-RTP-HOP3/RESULTS.md` exists: **PASS_NARROW** (`ASTRA_RTP_HOP3_XSIM_PASS`, TB_LOAD=0). Persist `ASTRA-SGD-PERSIST/RESULTS.md` exists: **PASS_NARROW** (`ASTRA_SGD_PERSIST_XSIM_PASS`, v1 file only). Next queue would be ASTRA-13 — **not started**. `unblocked_item=NONE`. PROGRAM=NO. COM12 plugged unprogrammed.

## Recheck 2026-09-06T00:40+07

UNCHANGED. 14 MATCH / 1 DRIFT. SGD live `c6f37a27…`, mtime 2026-09-05 23:09:57. Glue + v1 QSE MATCH. HOP3 and persist RESULTS.md still present. `unblocked_item=NONE`. ASTRA-13 not started. PROGRAM=NO.

## Recheck 2026-09-06T01:00+07

UNCHANGED. 14 MATCH / 1 DRIFT. SGD live `c6f37a273960a3187934b1439c74915a913bf5b12e44114a907e714036061a1f`, mtime 2026-09-05 23:09:57. Glue + v1 QSE MATCH. HOP3/persist RESULTS.md still present. `unblocked_item=NONE`. ASTRA-13 not started. PROGRAM=NO.

## Recheck 2026-09-06T01:23+07

UNCHANGED hashes. 14 MATCH / 1 DRIFT. SGD live `c6f37a273960a3187934b1439c74915a913bf5b12e44114a907e714036061a1f`, mtime 2026-09-05 23:09:57. Glue + v1 QSE MATCH. No revert this tick.

No `AUDITOR/*/REPORT.md` at the start of this check. Concurrent auditor later wrote `20260906T0120Z/REPORT.md`. ASTRA-13 not started. PROGRAM=NO.

## Recheck 2026-09-06T01:36+07

12B 15-file list unchanged: 14 MATCH / 1 DRIFT SGD `c6f37a27…`. New files `a7ng_axi_rtp_plant128.sv` and `arty_a7_astra_rtp_soc_top.sv` are outside the 12B freeze set. `a7ng_astra09_pipe.sv` still MATCH. SOC_RTP_GLUE XSim recorded. `unblocked_item=AUDITOR_NEEDED`. PROGRAM=NO.

## Recheck 2026-09-06T01:41+07

UNCHANGED. 14 MATCH / 1 DRIFT. SGD live `c6f37a273960a3187934b1439c74915a913bf5b12e44114a907e714036061a1f`. Glue + v1 QSE MATCH. Last RESULTS.md is SOC_RTP_GLUE 01:36:13; latest REPORT still `20260906T0120Z` 01:21:52. `unblocked_item=AUDITOR_NEEDED`. Implementer IDLE. ASTRA-13 not started. PROGRAM=NO. COM12 UNTOUCHED.

## Recheck 2026-09-06T02:02+07

UNCHANGED. 14 MATCH / 1 DRIFT SGD `c6f37a27…`. Glue + v1 QSE MATCH. REPORT `20260905T1841Z` 01:54:43. Glue CLOSEOUT/SHA rewritten xvlog-only. WRAP-XSIM RESULTS pending auditor. `unblocked_item=AUDITOR_NEEDED`. ASTRA-13 not started. PROGRAM=NO. COM12 UNTOUCHED.

## Recheck 2026-09-06T02:22+07

UNCHANGED. 14 MATCH / 1 DRIFT SGD `c6f37a273960a3187934b1439c74915a913bf5b12e44114a907e714036061a1f`. Glue + v1 QSE MATCH. REPORT `20260906T0215Z` wrap-route PASS_NARROW, not BOARD_PASS. Live `unblocked_item=UART_WRAP_XSIM` implementer IN_PROGRESS — no second writer this tick. ASTRA-13 not started. PROGRAM=NO. COM12 UNTOUCHED.

## Recheck 2026-09-06T02:41+07

UNCHANGED. 14 MATCH / 1 DRIFT SGD `c6f37a273960a3187934b1439c74915a913bf5b12e44114a907e714036061a1f`. Glue + v1 QSE MATCH. REPORT `20260906T0232Z` UART wrap-top PASS_NARROW, not BOARD_PASS. `unblocked_item=NONE`. Implementer IDLE. ASTRA-13 not started. PROGRAM=NO. COM12 UNTOUCHED.

## Recheck 2026-09-06T03:01+07

UNCHANGED. 14 MATCH / 1 DRIFT SGD `c6f37a273960a3187934b1439c74915a913bf5b12e44114a907e714036061a1f`. Glue + v1 QSE MATCH. Same REPORT `20260906T0232Z`. `unblocked_item=NONE`. Implementer IDLE. ASTRA-13 not started. PROGRAM=NO. COM12 UNTOUCHED.

## Recheck 2026-09-06T03:21+07

UNCHANGED. 14 MATCH / 1 DRIFT SGD `c6f37a273960a3187934b1439c74915a913bf5b12e44114a907e714036061a1f`. Glue + v1 QSE MATCH. Same REPORT `20260906T0232Z`. `unblocked_item=NONE`. Implementer IDLE. ASTRA-13 not started. PROGRAM=NO. COM12 UNTOUCHED.
