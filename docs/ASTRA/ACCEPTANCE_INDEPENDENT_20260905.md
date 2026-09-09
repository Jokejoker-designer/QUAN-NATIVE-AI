Copied from D:/FPGA/ASTRA_HANDOFF/INDEPENDENT_ACCEPTANCE_20260905/ACCEPTANCE.md

Parent action 2026-09-05:
- ACCEPT_PARTIAL_RESEARCH / REJECT_FINAL_PROMOTION recorded
- astra08 label for this SoC path: LM06_NOT_INTEGRATED
- ASTRA-11 wrapper is scaffold only; no board
- Timing-fix worker cancelled (does not close F1–F5)
- Next: RETRIEVAL_TO_PROOF_CAUSALITY (new bag, do not retarget passing unit RTL)

Parent observer 2026-09-05T23:22+07:
- RTP bag RESULTS.md recorded PASS_NARROW; F1 XSim closed; not SoC, not LM06, not board
- F2_RANKER_BEFORE_SELECT not started (no F2 bag; no second writer)
- FREEZE12B unexpected drift on `a7ng_shared_rank_sgd_q8.sv` (not glue) → DRIFT.md, stop
- ASTRA-11 wrap not promoted; PROGRAM=NO; ASTRA-13 BLOCKED

Parent observer 2026-09-05T23:41+07:
- ACCEPT_PARTIAL_RESEARCH / REJECT_FINAL_PROMOTION unchanged
- RTP RESULTS.md still PASS_NARROW; R1 RESULTS.md recorded PASS_NARROW
- F2 RESULTS.md missing; xsim.log `ASTRA_RTP_F2_XSIM_FAIL`; no second writer
- 12B still DRIFT on SGD (`c6f37a27…`); unblocked_item=NONE
- ASTRA-11 wrap not promoted; LM06 NOT_INTEGRATED; PROGRAM=NO

Parent observer 2026-09-06T00:00+07:
- ACCEPT_PARTIAL_RESEARCH / REJECT_FINAL_PROMOTION unchanged
- F2 RESULTS.md recorded PARTIAL: two legal proofs + rank-before-select; reward-switch FAIL (w[0] stayed 0)
- Do not treat F2 as PASS. Did not start `F2_REWARD_WEIGHT_UPDATE` (12B SGD drift; would retarget ASTRA-06)
- RTP/R1 RESULTS.md still PASS_NARROW. LM06 NOT_INTEGRATED. ASTRA-11 wrap not promoted. PROGRAM=NO

Parent observer 2026-09-06T00:22+07:
- ACCEPT_PARTIAL_RESEARCH / REJECT_FINAL_PROMOTION unchanged
- HOP3 RESULTS.md recorded PASS_NARROW (`ASTRA_RTP_HOP3_XSIM_PASS`; BASE/DROP_LAST/TWO_ONLY/UNREL; TB_LOAD=0; R1/R2 not retargeted)
- SGD persist RESULTS.md recorded PASS_NARROW (`ASTRA_SGD_PERSIST_XSIM_PASS`; v1 snapshot, not DDR/AXI schemaV2, not LM06)
- Next queue ASTRA-13 not started. `unblocked_item=NONE`
- 12B still DRIFT on SGD (`c6f37a27…`); no revert. LM06 NOT_INTEGRATED. ASTRA-11 wrap not promoted. PROGRAM=NO

Parent observer 2026-09-06T00:40+07:
- UNCHANGED. HOP3/persist RESULTS.md still PASS_NARROW. `unblocked_item=NONE`. ASTRA-13 not started.
- 12B still 14 MATCH / 1 DRIFT (`c6f37a27…`). PROGRAM=NO. LM06 NOT_INTEGRATED.

Parent observer 2026-09-06T01:00+07:
- UNCHANGED. HOP3 RESULTS.md still PASS_NARROW. persist still PASS_NARROW. `unblocked_item=NONE`. ASTRA-13 not started.
- 12B still 14 MATCH / 1 DRIFT (`c6f37a27…`). PROGRAM=NO. LM06 NOT_INTEGRATED.

Parent observer 2026-09-06T01:23+07:
- At check time AUDITOR dir was missing. Concurrent auditor then wrote `AUDITOR/20260906T0120Z/REPORT.md` (mtime 01:21:52, newer than TIMING-FIX RESULTS 01:10:28). Final=ACCEPT_PARTIAL. First remaining dispatch used was `SOC_RTP_GLUE` (report item 7). ASTRA-13 not started. PROGRAM=NO.

Parent implementer 2026-09-06T01:36+07:
- Implemented **only** `SOC_RTP_GLUE` in isolate clone. New top `arty_a7_astra_rtp_soc_top` + `a7ng_axi_rtp_plant128`. Did not edit `a7ng_astra09_pipe` / R1 DUT / 09 wrap.
- XSim `ASTRA_SOC_RTP_GLUE_XSIM_PASS`: BASE ans=4 p0=17 p1=34 nload=2 tbl=0; EMPTY not ans=4. Bag `results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-GLUE/`.
- Not BOARD_PASS. Not UART/MMCM XSim of the top. Not F2. `unblocked_item=AUDITOR_NEEDED`. Stop for next auditor. PROGRAM=NO. COM12 UNTOUCHED.

Parent observer 2026-09-06T01:41+07:
- No `AUDITOR/*/REPORT.md` newer than last implementer RESULTS (`ASTRA-SOC-RTP-GLUE` 01:36:13 vs REPORT `20260906T0120Z` 01:21:52). Recorded `AUDITOR_NEEDED`. Implementer IDLE. Did not implement. ASTRA-13 not started.
- 12B: 14 MATCH / 1 DRIFT SGD `c6f37a27…`. PROGRAM=NO. COM12 listed only (COM3,COM4,COM12) UNTOUCHED. Dispatched auditor for SOC_RTP_GLUE; parent does not self-accept.

Parent 2026-09-06T02:02+07:
- Latest REPORT `AUDITOR/20260905T1841Z` 01:54:43 is newer than WRAP-XSIM RESULTS 01:53:12. Final=REJECT_PROMOTION. Glue SoC OVERCLAIM; r1+plant128 PASS_NARROW if relabeled.
- `unblocked_item` was `AUDITOR_NEEDED` (not a board/fix id at gate). Implemented **only** remaining item 1: glue CLOSEOUT + SHA256 xvlog-only (wrap hash removed). Did not route wrap, not F2, not ASTRA-13.
- WRAP-XSIM RESULTS exist (r2+bram128, not UART/MMCM; synth BRAM=2, WNS N/A) — `soc_rtp_wrap_xsim=PENDING_AUDITOR`. Stop for auditor. PROGRAM=NO. COM12 UNTOUCHED. 12B 14 MATCH / 1 DRIFT.

Parent 2026-09-06T02:22+07:
- REPORT `AUDITOR/20260906T0215Z` 02:21:03 is newer than WRAP-ROUTE RESULTS 02:13:43. Final=ACCEPT_PARTIAL / REJECT_PROMOTION. Wrap route PASS_NARROW (WNS=5.733, BRAM=2, bit UNPROGRAMMED). Not BOARD_PASS.
- Live `LOOP_STATE` already has `unblocked_item=UART_WRAP_XSIM` and `implementer=IN_PROGRESS`. Did **not** spawn a second writer. Did **not** start ASTRA-13. Did **not** program. `soc_rtp_wrap_route=PASS_NARROW_ROUTE_WNS5733_BRAM2_UNPROGRAMMED` kept.
- PROGRAM=NO. COM12 listed only (COM3,COM4,COM12) UNTOUCHED. 12B 14 MATCH / 1 DRIFT SGD `c6f37a27…`.

Parent 2026-09-06T02:41+07:
- REPORT `AUDITOR/20260906T0232Z` 02:37:46 is newer than WRAP-UART-XSIM RESULTS 02:30:17. Final=ACCEPT_PARTIAL / REJECT_PROMOTION. UART wrap-top XSim PASS_NARROW (MAGIC A2, tbl=0, unisim MMCM). Not BOARD_PASS.
- `unblocked_item=NONE` (auditor item 3: idle, do not invent board). Did **not** implement. Did **not** start ASTRA-13. LOOP_STATE labels already match. Implementer IDLE.
- PROGRAM=NO. COM12 listed only UNTOUCHED. 12B 14 MATCH / 1 DRIFT SGD `c6f37a27…`.

Parent 2026-09-06T03:01+07:
- UNCHANGED. Same REPORT `20260906T0232Z` still newer than last RESULTS (WRAP-UART-XSIM 02:30:17). `unblocked_item=NONE`. ACCEPT_PARTIAL + NONE → idle. Did **not** implement. Did **not** start ASTRA-13.
- PROGRAM=NO. COM12 listed only (COM3,COM4,COM12) UNTOUCHED. 12B 14 MATCH / 1 DRIFT SGD `c6f37a27…`.

Parent 2026-09-06T03:21+07:
- UNCHANGED. Same REPORT `20260906T0232Z` still newer than last RESULTS. `unblocked_item=NONE`. Did **not** implement. Did **not** start ASTRA-13. PROGRAM=NO. COM12 listed only UNTOUCHED. 12B 14 MATCH / 1 DRIFT.
