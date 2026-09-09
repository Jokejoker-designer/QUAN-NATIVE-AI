# Owner prompt — close C1 at real 800k, then start C2

Paste the **PASTE BLOCK** into the Grok TUI (Windows Terminal `grok.exe`).
Do not paste into Orca. Cursor does not inject except on FAIL / this owner paste.

Independent audit (Cursor, 2026-09-07 20:35 +07) copied evidence into
`D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\snapshots\` and ran
`python scripts\c1_800k_close_gate.py`. Result: **C1_CLOSE=NO**, **C2_MAY_START=NO**.

Blocking FAILs: `LADDER_65536_BAG`, `LADDER_262144_BAG`, `N800K_RESULTS_EXIST`,
`REDUCTION_METRIC_EMITTED`. WARN: same 120-entity cartesian at 800k projects
occ≈6933 vs synonym wrap `MERGE_POST_AR_MAX=256` (~1024 posting IDs) →
`SEARCH_INCOMPLETE`.

LOOP `unblocked_item=ASTRA-C1-SEMANTIC-800K-01` is **superseded** by this owner
prompt. Next bag is **N=65536**, not 800k.

---

## PASTE BLOCK — start here

```text
OWNER ANH / CURSOR INDEPENDENT AUDIT 2026-09-07. SUPERSEDES LOOP unblocked_item ASTRA-C1-SEMANTIC-800K-01 and the 800k-first WO.

You are the Grok implementer in D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
branch grok-orch/astra-native-v1-00. Master = docs\ASTRA\authority\ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md §7 C1 then §8 C2.

STOP. Do not continue ASTRA-C1-SEMANTIC-800K-01 until N=65536 and N=262144 XSim bags exist on the SAME frozen law stack with FAIL=0. If 800k work already started: preserve logs; if corpus is the 16k KEEP copy 6991adc7 with banner N=800000, RESULT=FAIL OVERCLAIM; do not write a PASS CLOSEOUT.

NEVER WRITE D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT (Cursor owns it). NEVER write V3.1 / basys junction. NEVER silent-patch C0 files. NEVER ACCEPT_BOARD / BOARD_PASS / ASTRA_NATIVE_AI_BOARD_PASS from XSim. PROGRAM=NO. leftover A09 off. poke_v=0. Historical U5 ASTRA-02-U5-SCALE-SELECTIVITY-800K cannot close C1.

FACT NOW (independent close-gate, command recorded):
- C1_CLOSE=NO C2_MAY_START=NO
- Bags missing: ASTRA-C1-N65536-SCALE-01, ASTRA-C1-N262144-SCALE-01, ASTRA-C1-SEMANTIC-800K-01 (no xsim.log)
- Latest closed: ASTRA-C1-SYNONYM-LAW-01 N=16384 ACCEPT_PARTIAL 1-alias only (auditor 1955Z). QSE_SYN_N=1. Not general NL.
- SEMANTIC-NL-01 KEEP FAIL emit 131 gold {120,121,122}. Do not relabel gold.
- Index still cartesian 16384 unique nids, fill_frac=1.0, corpus SHA 6991adc7, N_SUBJECTS=127 N_RELS=8, occ fill=121 high_occ=142, REDUCTION_X1000=NOT_EMITTED, CAND_CAP=16 NOT FINAL, axi_mem_model.
- C0 MATCH live: extract cd7baf49 lexicon FILE 38189974 dir 09334e42 sparse FILE 5a4ad04d gate 49a66da2. KEEP: stream-02 14f75db7 ctx keys 124be808 ctx DUT 8255a798 page-skip dab15d76. Synonym NEW: svh 551655a1 QSE_SYN_N=1 overlay e862208c wrap DUT a84bbf7e (AND-then-cap copy of stream-02; MERGE_POST_AR_MAX default 256). Named lex runtime df0e8833 copied; C0 FILE not runtime.

ROOT CAUSES (fix these, do not hide):
RC-LADDER-SKIP: Master §7 requires 256→4096→16384→65536→262144→800000 SAME parser/key/dir/overflow/CAND_CAP policy. 65k and 262k never run. Jumping 16k→800k is a promotion hole.
RC-CARTESIAN-16K: 16k KEEP corpus 6991adc7 + 8 plants is not 800k. Banner N=800000 on that clone = OVERCLAIM.
RC-REDUCTION-ABSENT: REDUCTION_X1000=NOT_EMITTED. Cannot freeze CAND_CAP_FINAL or prove Master ≥90%.
RC-INCOMP-POLICY: qse-v2-intersect-01 N4096 missed gold 4095 (cap-then-AND). STREAM-02 N4096 HIT late 4094 + sentinel 4095. Scale bags: SEARCH_INCOMPLETE on gold_n>=1 retrieve = FAIL the bag. Do not PASS with incomp=1.
RC-NL-ONE-ALIAS: 1-pair overlay is not general NL / Master ≥95% role accuracy. Extra aliases = NEW named law + new bag, not silent QSE_SYN_N++ / not C0 extract patch.
RC-OCCUPANCY-BLOWUP + RC-MERGE-BUDGET-256: 16k max occ=142; same 120 entities ×800k/16k ⇒ occ≈6933. Two-list walk ≈ 2*ceil(6933/4) ≈ 3468 posting ARs >> MERGE_POST_AR_MAX=256. 800k-on-same-entities will SEARCH_INCOMPLETE. Do not silent-edit KEEP 14f75db7. Fork (one unknown per bag): (A) widen entity namespace so typical occ stays within budget; (B) named PAGE-SKIP instantiate bag (dab15d76, do not edit file) proving AR drop then replay; (C) NEW named wrap with documented MERGE_POST_AR_MAX and late-gold HIT. Run the fork at N=65536 BEFORE 800k.
RC-AXI-MEM-NOT-DDR: C1 XSim axi_mem_model is allowed if 800k nids are addressable. C2 is persist/commit/warm DDR restore. C1 PASS ≠ C2 start until auditor ACCEPT of real 800k + frozen bounds.

FROZEN LAW STACK FOR ALL REMAINING C1 SCALE BAGS (instantiate, do not edit):
- extract qse-v2-role-00 cd7baf49
- named lex qse-v2-lex-semantic-16k-01 df0e8833 (xvlog -i $bag FIRST; do not silent-shadow C0 FILE 38189974)
- synonym overlay qse-v2-relctx-synonym-01 QSE_SYN_N=1 (svh 551655a1, mod e862208c) — keep 1 pair
- ctx keys 124be808
- DUT wrap a7ng_query_axi_sparse_intersect_synonym a84bbf7e (AND-then-cap; CAND_CAP after emit)
- dir FILE 09334e42 with parameter N_BUCKETS=65536 (DIR-FULL16 already proved parameter; this is not N=65536 records)
- stream-02 file 14f75db7 and page-skip dab15d76 UNEDITED (instantiate page-skip only in its own named bag if fork B)
- CAND_CAP=16 after emit until cap-sweep bag. Not CAND_CAP_FINAL.

REDUCTION PRINT (required from the first new scale bag onward; independent TB FAILs NOT_EMITTED):
Print BOTH, never 1-CAND_CAP/N:
  REDUCTION_VS_N_X1000   = 1000 * (1 - occ/N)           // sparse vs full scan; Master ≥90% for N>=4096 maps here
  REDUCTION_VS_OCC_X1000 = 1000 * (1 - emit_n/max(occ,1))
  DIR_R_BEATS POST_R_BEATS TOTAL_AXI_BYTES (rvalid&&rready)*16  // AXI-BEAT showed AR×16 undercount; freeze DDR_QUERY_BOUND from R-beats after cap sweep
Independent scripts that will FAIL a clone (you do not run them; Cursor does):
  python D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\scripts\c1_800k_close_gate.py
  python D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\scripts\assert_scale_bag.py <BAG> <N>

ORDER — ONE UNKNOWN PER BAG. Never chain 65k+262k+800k in one XSim. Gold hashed BEFORE first xvlog. Marker only if FAIL=0 AND hosted N matches.

BAG 1  ASTRA-C1-N65536-SCALE-01
Unknown = N=65536 RECORDS hosted (contiguous distinct nids), same law stack, late gold 65534 HIT, sentinel 65535 HIT, fill-template control HIT, leak_n=0, incomp=0 on gold_n>=1 retrieve, REDUCTION_* printed.
Not “N_BUCKETS already 65536”. Silent drop to 16384/4096/256 = FAIL. 12-entity clone = FAIL.
Cartesian/grid stress ALLOWED at this rung if RESULTS say it does not close Master ≥95% / 800k / BOARD_PASS.
Occupancy fork: if SEARCH_INCOMPLETE or MERGE_POST_AR_MAX trips, FAIL honestly FIRST_DIVERGENCE MERGE_BUDGET. Then ONE of A/B/C above as the NEXT bag, then replay 65k. Do not raise MERGE in KEEP files. Do not start 262k/800k.
If xelab/host RAM cannot host 65536: FAIL FIRST_DIVERGENCE MEM. Do not shrink N.
Marker ASTRA_C1_N65536_SCALE_XSIM_PASS. PROGRAM=NO. Do not freeze bounds. Do not edit KEEP bags.

BAG 2  ASTRA-C1-N262144-SCALE-01
Same law as the 65k bag that actually PASSED (including any named MERGE/page-skip/corpus-widening law from the occupancy fork). N=262144 distinct nids. Late 262142 HIT. Sentinel 262143 HIT. Same incomp/reduction rules. Marker ASTRA_C1_N262144_SCALE_XSIM_PASS. Do not start 800k in this bag.

BAG 3  ASTRA-C1-SEMANTIC-800K-01
Unknown = N=800000 addressable distinct nids + Master §7 query classes on the SAME law:
  direct relevant
  supported paraphrase  (only aliases in frozen QSE_SYN_N=1 table; extra pairs = new law first)
  role reversal
  same entity / wrong relation
  same relation / wrong context
  entity-context distractor  leak_n=0
  unrelated  empty walk, not 0/0 sold as 1000/1000
  adversarial high-occupancy bucket
  relevant item in overflow page
  high-ID sentinel near 799999
  late gold 799998 (or independently proven k0_idx>=16 AND k1_idx>=16)
Procedural generation OK. 16k clone 6991adc7 with N printed 800k = OVERCLAIM FAIL.
Fill_frac=1.0 120-entity grid is NOT Master semantic mass; if you still use a grid, occupancy must complete within MERGE budget and RESULTS must not claim ≥95% role accuracy.
Recall at cap ≥95% on retrieve classes with gold_n>=1. No full scan. Gold miss → SEARCH_INCOMPLETE not false UNKNOWN — and that class FAILS this bag (do not marker).
Marker ASTRA_C1_SEMANTIC_800K_XSIM_PASS only if FAIL=0 AND N=800000 hosted AND reduction printed AND independent-style checks would pass (unique_nids=800000, banner N=800000, GOLDEN n=800000).
Do not freeze CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL in this bag.

BAG 4  ASTRA-C1-CAND-CAP-SWEEP-01
Unknown = cap sweep 16 / 64 / 128 / … on the FROZEN 800k image (do not rebuild a friendlier corpus). Replay the same gold. Pick CAND_CAP_FINAL only after this bag. DDR_QUERY_BOUND_FINAL from live R-beats*16, not AR×16. Independent will FAIL tautology 1-CAND_CAP/N.

THEN auditor ACCEPT of BAG 3 + BAG 4. Only then:
  LOOP c1_800k=CLOSED (auditor, not implementer)
  CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL frozen in OPEN_GATES
  C2 may start

C2 FIRST BAG (do not open until C1 auditor ACCEPT):
ASTRA-C2-PERSIST-COMMIT-01
Unknown = production txn identity Master §8: UPDATE_RECEIVED / ACCEPTED / COMMITTED / PERSISTED / FAILED. Canonical {subject_id, relation_id, object_id, context, generation}. No low8/low16 identity. False success = 0. Warm persist: learned state survives explicit on-chip-state loss and restores from versioned DDR. PROGRAM=NO until persist XSim PASS. Not a retrieval bag. Do not mix 800k corpus regen into C2.

HARD STOPS
- No C0 silent patch (cd7baf49 / 38189974 / 09334e42 / 5a4ad04d / 49a66da2)
- No nid-derived keys, no relevant=router_union, no threshold drop, no gold rewrite after FAIL
- No QSE_SYN_N growth in place
- No BOARD_PASS / ACCEPT_BOARD / ASTRA-13 / new bitstream
- program_scope remains PINNED_SHA_e51bdca2_ONLY; this C1 walker is not that bit
- Do not claim Master ≥95%/≥90% from 16k synonym or from a 65k cartesian stress rung
- Do not edit ASTRA-C1-SYNONYM-LAW-01 / SEMANTIC-NL-01 / UNSEEN-SRO* / HELDOUT / SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02 / N4096-* / KEY-INTERSECT / AXI-BEAT

After BAG 1 CLOSEOUT exists, STOP for auditor. Do not auto-start BAG 2 until auditor ACCEPT_PARTIAL + P1 none on 65k. Same for 262k→800k.

Implementer: IN_PROGRESS on ASTRA-C1-N65536-SCALE-01 only. Update LOOP_STATE unblocked_item to that bag, c1_800k=BLOCKED_UNTIL_LADDER, c2_persist=BLOCKED_UNTIL_C1_800K, final_promotion=REJECT, board_pass=false, independent_audit_write=false.
```

---

## Why this path (independent, not Grok RESULTS prose)

| Claim | Class | Evidence |
|---|---|---|
| C1 800k not closed | FACT | No `ASTRA-C1-SEMANTIC-800K-01` directory; LOOP `c1_800k=IN_PROGRESS_OWNER_AUTHORIZED`; close-gate blocking FAILs |
| 65k / 262k never run | FACT | `Test-Path` both bags false; only WOs under `.agents/handoff/` |
| Synonym is 1-alias N=16384 | FACT | Auditor 1955Z; `QSE_SYN_N=1`; xsim fill `{120,121,122}` occ=121 |
| Occupancy will trip 256 AR budget at 800k-same-entities | INFERENCE | 16k max occ=142 × (800000/16384) ≈ 6933; wrap default `MERGE_POST_AR_MAX=256` |
| Reduction tautology would fake Master ≥90% | HYPOTHESIS | `1-CAND_CAP/N` = 1-16/800000; independent TB FAILs that string |
| Page-skip or wider entities needed before 800k | HYPOTHESIS | 65k/262k rungs are the cheap place to observe the trip |

Authority: Master §7–§8, live hashes, independent `results/c1_800k_close_gate.json`.
AI cannot declare `BOARD_PASS`.
