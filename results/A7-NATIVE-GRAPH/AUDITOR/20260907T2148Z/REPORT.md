# ASTRA auditor REPORT — 20260907T2148Z

```text
ROLE       = independent auditor of C1 XSim close package
           DISCLOSURE: same Cursor session implemented N800000-SCALE-01 and
           CAND-CAP-SWEEP-01. This report hunts overclaim; it is not a second
           model. Grok 20260907T2045Z ACCEPT_PARTIAL of SEMANTIC-800K-01 stands.
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
RTL_EDIT   = NO
FIX        = NO
BAGS       = ASTRA-C1-N800000-SCALE-01
           + ASTRA-C1-CAND-CAP-SWEEP-01 (frozen gold copy; not regenerated)
PRIOR      = AUDITOR/20260907T2045Z ACCEPT_PARTIAL of ASTRA-C1-SEMANTIC-800K-01
           (4-class; REDUCTION_X1000=NOT_EMITTED; 65k/262k were then absent)
AUTHORITY  = Master V1.1 §7 C1 + FAIL routing; RAW xsim.log > CLOSEOUT
```

This audit did not program the board, did not edit `rtl/`, did not edit
`ASTRA-C1-SEMANTIC-800K-01`, did not edit KEEP SYNONYM-LAW / SEMANTIC-NL-01 /
UNSEEN-SRO / HELDOUT / SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02,
did not patch C0, did not start a C2 bag, did not write V3.1.

---

## Object

Master §7 primary unknown: can the frozen role-aware query law retrieve
selectively with bounded traffic through the **same index law** at
256 → 4k → 16k → 65k → 262k → 800k, on the required query classes, then
select a cap after a sweep.

This is an **XSim C1 law close**, not BOARD_PASS and not DDR persistence.

---

## Live hash hunt (this run)

C0 / KEEP prefixes MATCH `FINAL_CONTRACT` / 2045Z:

```text
extract     cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
C0 lex FILE 381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
syn table   551655a1cda97463841a681e34f8073e22b1b2c1beb2ae03847bdc9a5bb41dfd
ctx keys    124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1
ctx DUT     8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989  NOT DUT
stream-02   14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac  NOT DUT
page-skip   dab15d76da42b33a934d8c68c1108665a79b8544d44b4986b840972841135817  NOT DUT
syn wrap    a84bbf7e9a2c0b9e3753b3cb2e1ae734c2afde59267d733aa0e52108e47d8ec8  DUT
```

KEEP GOLDEN hashes MATCH 2045Z records:

```text
SYNONYM-LAW-01 GOLDEN  587e6ac3841105f1…  mtime 2026-09-07 19:49:47
SEMANTIC-NL-01 GOLDEN  6fa2a93f15a32b21…  (honest FAIL kept)
SEMANTIC-800K-01 GOLDEN acdbc3797ac7746c… mtime 2026-09-07 20:41:44 UNEDITED
```

Scale gold MATCH `GOLD_HASH_PRE_XVLOG.txt` (hashed before xvlog; not regenerated):

```text
GOLDEN.json     3b900979101d48fc20613615be84f2b98717bebea5544c5c0ae0e03c1a559397
query_gold.svh  dafe6c39e1eff95b9a8b60290ae886800ec4e9a5d1ef373b5c5ca90b402ab394
corpus.json     b1f7ae4fa63f3770e491e51a79504adf024a6a32f54e4415736bfa010e3d3270
```

Sweep GOLDEN.json / query_gold.svh SHA **byte-identical** to scale (frozen copy).

```text
scale xsim.log  92aad0c74ff2941fa9f6831be506f25f16dfd01fbd5de394a4477edbba1b93c1
sweep xsim.log  9d95f83ecd3710060bf8d28dc08d98781d7dc5219add3dc466856ce716fe1b0a
```

---

## xvlog DUT hunt (scale bag)

Analyzed: extract, synonym overlay, ctx **keys**, route gate, sparse dir,
bag `a7ng_axi_mem_proc_800k`, synonym wrap DUT, TB.

NOT analyzed as DUT: leftover A09, C0 sparse FILE, STREAM-02, PAGE-SKIP,
ctx DUT 8255a798, C0 dense `a7ng_axi_mem_model`. MATCH forbidden list.

---

## Raw XSim vs CLOSEOUT (scale)

Marker `ASTRA_C1_N800000_SCALE_XSIM_PASS` PRESENT. Banner `C1_N800000_SCALE_N=800000`.
`$finish` 59025 ns. `FIRST_DIVERGENCE` ABSENT. `SEARCH_INCOMPLETE` ABSENT.
`reduction_x1000=[0-9]` tautology ABSENT. `REDUCTION_VS_N_X1000=999` PRESENT.

| Class | gold_n | emit_n | rec_x1000 | incomp | MATCH CLOSEOUT |
|---|---:|---:|---:|---:|---|
| fill_template | 3 | 3 | 1000 | 0 | HIT {120,121,122} |
| paraphrase | 3 | 3 | 1000 | 0 | same keys as fill |
| nl_synonym | 3 | 3 | 1000 | 0 | frozen keys_match=0 syn=1; not 131 |
| role_reversal | 1 | 1 | 1000 | 0 | nid=4602 |
| wrong_relation | 1 | 1 | 1000 | 0 | nid=802 |
| wrong_context | 1 | 1 | 1000 | 0 | nid=121; generator special-case keys 3380/3636 |
| distractor | 1 | 1 | 1000 | 0 | nid=603 leak_fill=0 |
| high_occupancy | 1 | 1 | 1000 | 0 | nid=17206 list occ≥16; AND emit=1 |
| late_gold | 1 | 1 | 1000 | 0 | nid=799998 |
| high_id_sentinel | 1 | 1 | 1000 | 0 | nid=799999 |
| unrelated | 0 | 0 | — | — | empty walk |

Hunt “RESULTS overclaim vs raw”: **MISS.** RESULT remains `PASS_THIS_GATE_ONLY` on the bag.

Display `ev=0` on nids 120–122 is the known 20-bit diagnostic artifact (2045Z); scoring uses gold/relevant not that print.

---

## Cap sweep

Caps 16 / 64 / 128 / 256: each `ASTRA_C1_CAND_CAP_SWEEP_XSIM_PASS cap=N`.
Fill emit_n=3 and max `TOTAL_AXI_BYTES=1632` (late_gold) **identical** at every cap.

**FACT:** CAND_CAP is not the binding constraint on this cartesian AND image (emit 1 or 3).
**INFERENCE:** selecting 16 is the smallest tested cap that meets 100% recall on the required class set; it is not a stress-proof of cap policy under dense postings.

`DDR_QUERY_BOUND_FINAL` is **not** frozen: 1632 bytes is AXI procedural R-path, not MIG.

---

## Master §7 letter vs quality bound

**Letter HIT (XSim law):**

- Same parser/key/dir/overflow/cap policy on ladder bags including 65k, 262k, 800k-scale.
- Required class names all present at N=800000.
- Recall at cap 16 = 1000/1000 on that 11-query set (≥95% on the tested set).
- `REDUCTION_VS_N_X1000=999` ≥ 900 (occupancy vs N, not 1-CAND_CAP/N).
- Gold miss → would FAIL (incomp does not hide miss). Full scan hunt: AR outside dir/post ABSENT.
- Host semantic / poke_v=0.

**Quality bound still HIT (do not promote to board / mass):**

- Corpus is cartesian `{ent}{rel}{ent}` procedural (`records_materialized=false`). 16k C1 bags were also cartesian; this is the C1 index law, not a 16k clone labeled 800k.
- `QSE_SYN_N=1`. Paraphrase is supported-grammar surface, not general NL.
- Wrong-context postings are generator special-case, not 16k host dual-index of every SRO+ctx.
- Index is bag AXI slave, not MIG. Cube stream truncates 4002 cartesian slots; N=800000 nids remain the addressable set.
- Cap unstressed.

2045Z REJECT of Master close was for missing 65k/262k, 4 classes, no reduction, no sweep. Those gaps are **closed**. Cartesian/AXI/1-pair remain **BOARD / mass** rejects, not XSim-law fails.

---

## Verdict

```text
FINAL                  = ACCEPT C1 XSim law close
C1_XSIM_LAW            = ACCEPT
C1_800K_CLOSED_XSIM    = YES
PROMOTION              = REJECT
BOARD_PASS             = REJECT
ACCEPT_BOARD           = REJECT
MASTER_MASS_95         = REJECT
GENERAL_NL             = REJECT
CAND_CAP_FINAL         = 16
DDR_QUERY_BOUND_FINAL  = NOT_FROZEN
AXI_QUERY_BOUND_CANDIDATE_BYTES = 1632
C2_MAY_START           = YES
C2_PERSIST             = NOT_STARTED
PROGRAM                = NO
```

Owner asked to close C1. This ACCEPT is **STABLE-LAW-SPARSE-RETRIEVAL-800K as XSim**, with `CAND_CAP_FINAL=16` selected after sweep. It is **not** `ASTRA_NATIVE_AI_BOARD_PASS`.

C2 first bag when started: `ASTRA-C2-PERSIST-COMMIT-01`, PROGRAM=NO until persist XSim.

---

## Machine lines (close-gate)

```text
C1_XSIM_LAW=ACCEPT
C1_800K_CLOSED_XSIM=YES
BOARD_PASS=REJECT
ACCEPT_BOARD=REJECT
CAND_CAP_FINAL=16
DDR_QUERY_BOUND_FINAL=NOT_FROZEN
C2_MAY_START=YES
```
