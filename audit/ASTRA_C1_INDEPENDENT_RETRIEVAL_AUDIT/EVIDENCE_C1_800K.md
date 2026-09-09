# Evidence — C1 800k close gate (evening 7 Sep 2026)

Cursor independent tree only. Grok live DUT/bags not written.

## Commands recorded

```text
python D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\scripts\snapshot_evidence.py
  copied=119 missing=24  (65k/262k/800k bags absent; some FAIL_R0.md missing)

python D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\scripts\c1_800k_close_gate.py
  exit=1  C1_CLOSE=NO  blocking=LADDER_65536_BAG,LADDER_262144_BAG,N800K_RESULTS_EXIST,REDUCTION_METRIC_EMITTED

python scripts\assert_scale_bag.py ...\ASTRA-C1-SYNONYM-LAW-01 16384
  FAIL REDUCTION_X1000=NOT_EMITTED

python scripts\assert_scale_bag.py ...\ASTRA-C1-N4096-STREAM-02 4096
  FAIL REDUCTION_X1000=NOT_EMITTED

python scripts\assert_scale_bag.py ...\ASTRA-C1-SEMANTIC-800K-01 800000
  FAIL xsim.log missing
```

Full JSON: `results/c1_800k_close_gate.json`. File copies: `snapshots/` (no `corpus.json`, no `xsim_work`).

## Classification

| Statement | Class | Note |
|---|---|---|
| No 65k / 262k / 800k XSim bags | FACT | `Test-Path` false; snapshot `bag_absent` |
| LOOP still REJECT promotion; 800k IN_PROGRESS | FACT | `LOOP_STATE.json` 20:20 +07 |
| Synonym corpus n=16384 unique_nids=16384 fill_frac=1.0 | FACT | streamed `GOLDEN`/corpus parse in close-gate |
| C0 hashes MATCH prefixes | FACT | live SHA256 of RTL files |
| QSE_SYN_N=1 | FACT | `qse_relctx_synonym_01.svh` |
| NL FAIL emit 131 kept | FACT | `ASTRA-C1-SEMANTIC-NL-01` xsim |
| 16k max CLASS occ=142 | FACT | SEMANTIC-16K xsim `CLASS_high_occupancy occ=142` |
| Same-entity 800k occ≈6933 | INFERENCE | 142 × 800000/16384 |
| MERGE_POST_AR_MAX=256 will trip | INFERENCE | synonym wrap default; 2×ceil(6933/4) posting ARs |
| Owner 800k-first cannot close Master §7 | INFERENCE | ladder skip + occupancy + reduction absent |
| Page-skip or wider entities needed at 65k | HYPOTHESIS | cheap rung to observe the trip |

## Root causes → Grok path

See `GROK_C1_CLOSE_PROMPT.md` and `PLAN.md` addendum. Independent TB will keep failing C1 close until those bags exist and reduction is a real R-beat/occupancy print, not `1-CAND_CAP/N`.

---

## Update 20:50 +07 — Grok 800k XSim exists, C1 still not closed

```text
python scripts\c1_800k_close_gate.py
  exit=1  C1_CLOSE=NO
  blocking=LADDER_65536_BAG, LADDER_262144_BAG, REDUCTION_METRIC_EMITTED
  N800K_RESULTS_EXIST now green (banner N=800000, marker present)

python scripts\assert_scale_bag.py …ASTRA-C1-SEMANTIC-800K-01 800000
  FAIL REDUCTION_X1000=NOT_EMITTED

Test-Path ASTRA-C1-N65536-SCALE-01 = False
Test-Path ASTRA-C1-N262144-SCALE-01 = False
```

| Statement | Class | Evidence |
|---|---|---|
| Marker `ASTRA_C1_SEMANTIC_800K_XSIM_PASS` present | FACT | xsim.log PID 60708, 20:44:56–20:44:58, `$finish` 18825 ns |
| LOOP does not close C1 | FACT | `c1_800k=RESULTS_READY_PENDING_AUDITOR`, `final_promotion=REJECT`, `auditor=IN_PROGRESS` |
| Four query classes only | FACT | GOLDEN = fill_template, nl_synonym, high_id_sentinel, unrelated |
| corpus is metadata, not 800k records | FACT | corpus.json 602 bytes, `records_materialized: false` |
| Not a 16k byte-clone labeled 800k | FACT | generator `cartesian_new_subj_800k_v1`, 201×20, sentinel 799999 HIT occ=200 |
| Fill gold still nids 120–122 | FACT | same HVAC plants as 16k; generator special-cases (13,4,14) to three nids |
| 65k / 262k never run | FACT | directories absent |
| Reduction still absent | FACT | banner `REDUCTION_X1000=NOT_EMITTED` |
| Occupancy stayed ~200 because entity namespace widened | INFERENCE | 201 subjects; collect buffer `[0:255]`; MERGE 256 not tripped |
| Master C1 / C2 / BOARD_PASS not closed | INFERENCE | missing ladder + classes + bounds; RESULTS say PASS_THIS_GATE_ONLY |

---

## Update 21:18 +07 — Grok ACCEPT_PARTIAL + Cursor 65k/262k rungs

Grok auditor `20260907T2045Z`: **ACCEPT_PARTIAL** of `ASTRA-C1-SEMANTIC-800K-01` XSim retrieve only. **REJECT** Master C1 close / BOARD_PASS / C2. Independent tree was not written by Grok. Cursor did not edit that 800k bag.

Cursor (owner override, Grok usage exhausted):

```text
ASTRA-C1-N65536-SCALE-01  ASTRA_C1_N65536_SCALE_XSIM_PASS  N=65536
  late=65534 high=65535 fill={120,121,122} REDUCTION_VS_N_X1000=998
  xsim SHA deb617d59fd27b2ef1df35b87f76c4e5e4e81b2f60aba312b14e964e4ec67c1b

ASTRA-C1-N262144-SCALE-01 ASTRA_C1_N262144_SCALE_XSIM_PASS N=262144
  late=262142 high=262143 fill={120,121,122} REDUCTION_VS_N_X1000=999
  xsim SHA 4c8cae971b43a05903c4657811c0218e1c996bb0df60198bbc67c7501a9172c6
```

LOOP: `c1_800k=AUDITOR_ACCEPT_PARTIAL_PROCEDURAL_CARTESIAN_XSIM` `c1_800k_closed=false` `c2_persist=NOT_STARTED` `final_promotion=REJECT` `board_pass=false` `production_top=UNKNOWN`.

| Statement | Class | Evidence |
|---|---|---|
| Grok 800k unique nids 0..799999 procedural | FACT | auditor census; 4002 SROs dropped by N_STREAM |
| Fill {120,121,122}; sentinel 799999; NL overlay; no SEARCH_INCOMPLETE | FACT | 800k xsim.log |
| C0 extract unpatched; index AXI generator not MIG | FACT | hash gate + proc mem |
| 65k/262k XSim PASS_THIS_GATE_ONLY | FACT | scale bag xsim.log markers |
| Master C1 still not closed | FACT | LOOP closed=false; auditor ACCEPT_PARTIAL of 4-class 800k-01 only |

---

## Update 21:45 +07 — Cursor 800k-scale Master classes + cap sweep

Commands:

```text
python …\ASTRA-C1-N800000-SCALE-01\host_astra_c1_n800000_scale.py
  ASTRA_C1_N800000_SCALE_HOST_OK  N=800000 G_NQ=11

powershell …\ASTRA-C1-N800000-SCALE-01\run_xsim.ps1
  ASTRA_C1_N800000_SCALE_XSIM_PASS  sim=59025 ns
  xsim SHA 92aad0c74ff2941fa9f6831be506f25f16dfd01fbd5de394a4477edbba1b93c1

powershell …\ASTRA-C1-CAND-CAP-SWEEP-01\run_xsim.ps1
  ASTRA_C1_CAND_CAP_SWEEP_RUN_OK PASS caps=16,64,128,256
  combo xsim SHA 9d95f83ecd3710060bf8d28dc08d98781d7dc5219add3dc466856ce716fe1b0a
  max TOTAL_AXI_BYTES=1632 identical at every cap

python scripts\c1_800k_close_gate.py
  (this update) expected C1_CLOSE=NO  blocking=AUDITOR_ACCEPT_MASTER_C1
```

| Statement | Class | Evidence |
|---|---|---|
| 800k-scale 11-class XSim PASS | FACT | N800000-SCALE-01 xsim.log marker, G_NQ=11 |
| Cap sweep 16/64/128/256 PASS, invariant emit/bytes | FACT | CAND-CAP-SWEEP-01 xsim_cap_*.log |
| CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL not frozen | FACT | CLOSEOUT + LOOP |
| Master C1 / C2 / BOARD_PASS not closed | FACT | LOOP c1_800k_closed=false; no auditor ACCEPT of scale+sweep |
| Cartesian + 1-pair synonym + AXI-not-MIG | FACT | GOLDEN n_subjects=201; QSE_SYN_N=1; proc mem |

---

## Update 21:52 +07 — C1 XSim law ACCEPT (not BOARD)

```text
auditor  results/A7-NATIVE-GRAPH/AUDITOR/20260907T2148Z/REPORT.md
python scripts\c1_800k_close_gate.py
  expected C1_CLOSE=YES_XSIM  c2_may_start=YES  blocking=[]
```

| Statement | Class | Evidence |
|---|---|---|
| C1 XSim law ACCEPT | FACT | machine lines C1_XSIM_LAW=ACCEPT C1_800K_CLOSED_XSIM=YES |
| BOARD_PASS / ACCEPT_BOARD REJECT | FACT | same report; LOOP board_pass=false final_promotion=REJECT |
| CAND_CAP_FINAL=16 | FACT | OPEN_GATES + LOOP after sweep; cap unstressed disclosed |
| DDR_QUERY_BOUND_FINAL NOT_FROZEN | FACT | AXI 1632 ≠ MIG |
| C2 persist bag not started | FACT | LOOP c2_persist=NOT_STARTED |



