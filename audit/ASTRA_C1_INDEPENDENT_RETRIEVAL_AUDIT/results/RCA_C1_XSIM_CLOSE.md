# RCA — Why C1 XSim closed (and why BOARD did not)

Stamp: 2026-09-07 22:08 +07. Independent tree only.

Inquiry depth: Level 3 (high-stakes close decision; competing auditor reports).

Authority order: Master V1.1 §7 > raw `xsim.log` > `GOLD_HASH_PRE_XVLOG.txt` > auditor 2045Z / 2148Z > LOOP_STATE.

Claim under review: `c1_close=YES_XSIM` / `c1_800k_closed=true`.

Intent anchor: find the root cause that licenses closing C1 as XSim so C2 persist may start; never stamp `BOARD_PASS`; do not silent-patch C0.

---

## Conclusion (operational)

Keep `YES_XSIM`. Keep `BOARD_PASS=REJECT`. Do not reopen C1 XSim because the corpus is cartesian. Do not treat this RCA as a second-model ACCEPT if Anh requires a different model to countersign 2148Z.

The close is licensed because the **20:45 Master-close FAILs were evidence gaps**, not a DUT retrieve bug. Those gaps are now HIT on the frozen law stack.

---

## Hypotheses

| ID | Hypothesis | Status | Why |
|---|---|---|---|
| H1 | Evening 800k XSim failed retrieve, so C1 could not close | REJECTED | SEMANTIC-800K-01 marker PASS; 2045Z ACCEPT_PARTIAL of that unknown |
| H2 | C1 stayed OPEN because ladder / 11 classes / reduction / sweep were missing | CONFIRMED | 2045Z items 12, 497, 516, 543–547 |
| H3 | Cursor bags filled those four gaps on the same law stack | CONFIRMED | live xsim.log + SHA this run |
| H4 | Cartesian / AXI / 1-pair synonym are XSim-law fails | REJECTED | 16k KEEP is cartesian fill_frac=1.0; 2045Z classed those as promotion bounds |
| H5 | YES_XSIM is process-invalid because implementer=auditor | SUPPORTED as process hazard | 2148Z discloses same session; does not falsify CLASS_* lines |
| H6 | `CAND_CAP_FINAL=16` overclaims cap policy | CONFIRMED as latent | sweep emit identical; 16k high_occupancy already filled cap with 15 FP |
| H7 | 65k/262k missing required classes voids the ladder | WEAKENED | 2045Z FAIL was bag **existence**; Master “Same:” is laws, not “11 classes at every N”. 256/4k/16k/800k-scale carry the class set |
| H8 | valid-record coverage ≠ 100% voids Master frozen acceptance | SUPPORTED as BOARD/mass reject | N=800000 addressable HIT; complete 804000 cube MISS |

---

## CONFIRMED_ROOT_CAUSE (why C1 could not close at 20:45)

Grok `ASTRA-C1-SEMANTIC-800K-01` HIT the registered 800k-addressable XSim retrieve unknown. Auditor `20260907T2045Z` ACCEPT_PARTIAL that unknown and REJECT_PROMOTION of Master C1 CLOSED.

Root cause of the REJECT was **missing Master §7 evidence classes**, not a DUT emit bug:

1. Ladder skip: no N=65536 / N=262144 bags (2045Z item 12).
2. Four query classes only (fill, nl, sentinel, unrelated).
3. `REDUCTION_X1000=NOT_EMITTED`.
4. No cap sweep — cannot freeze `CAND_CAP_FINAL`.

Cartesian formulaic corpus, 1-pair synonym, AXI-not-MIG, truncated cube were **quality / promotion bounds** in that same report (item 16), not “this XSim retrieve unknown missed.”

---

## CONFIRMED_ROOT_CAUSE (why YES_XSIM is now licensed)

Owner asked to close C1. Cursor added bags that remove the four 2045Z Master-close FAILs.

| 2045Z FAIL-as-Master-close | Evidence now | Class |
|---|---|---|
| 65k / 262k absent | `ASTRA-C1-N65536-SCALE-01` / `N262144-SCALE-01` markers PRESENT | FACT |
| 4 classes only | `N800000-SCALE-01` 11 CLASS_* prints, all rec_x1000=1000, incomp=0 | FACT |
| reduction absent | `REDUCTION_VS_N_X1000=999` (800k-scale); 998 at 65k; 999 at 262k | FACT |
| no cap sweep | `CAND-CAP-SWEEP-01` PASS caps 16/64/128/256; fill emit_n=3 and max TOTAL_AXI_BYTES=1632 identical | FACT |

Close-gate re-run this RCA (command below): `c1_close=YES_XSIM`, `blocking_fail_ids=[]`, exit 0.

---

## Primary evidence this run (not auditor prose)

### SHA (Get-FileHash SHA256, 2026-09-07 22:05 +07)

```text
scale xsim.log     92aad0c74ff2941fa9f6831be506f25f16dfd01fbd5de394a4477edbba1b93c1
sweep xsim.log     9d95f83ecd3710060bf8d28dc08d98781d7dc5219add3dc466856ce716fe1b0a
scale GOLDEN.json  3b900979101d48fc20613615be84f2b98717bebea5544c5c0ae0e03c1a559397
sweep GOLDEN.json  3b900979…  (byte-identical to scale)
```

MATCH 2148Z recorded hashes. MATCH `GOLD_HASH_PRE_XVLOG.txt` GOLDEN line.

SEARCH_INCOMPLETE and FIRST_DIVERGENCE: **string absent** in scale xsim.log (rg no matches). Marker `ASTRA_C1_N800000_SCALE_XSIM_PASS` PRESENT.

### Fill host vs DUT (CONFIRMED_DEFECT, accounting)

GOLDEN fill `n_post=102`. xsim fill `postB=832` = 52 beats. Late_gold GOLDEN `n_post=100` MATCH DUT `postB=1600`. Do not freeze `DDR_QUERY_BOUND_FINAL` from host fill beats. AXI candidate max remains DUT late_gold 1632 bytes.

HYPOTHESIS (not proven): DUT AND-then-cap / rare-first stops posting walk after emit; host counts full occupancy beats. Early-exit would be bounded-traffic-good, not a retrieve fail.

### Ladder class coverage (FACT)

| N | Bag | Classes in xsim.log |
|---|---|---|
| 256 | STREAM-INTERSECT-02 | 10 named retrieve classes (high_occupancy emit_n=16) |
| 4096 | N4096-STREAM-02 | same shape (high_occupancy emit_n=16) |
| 16384 | SEMANTIC-16K-01 | wrong_context occ=1; high_occupancy emit_n=16 prec_all_x1000=62 |
| 65536 | N65536-SCALE-01 | fill, nl, late, sentinel, unrelated only |
| 262144 | N262144-SCALE-01 | fill, nl, late, sentinel, unrelated only |
| 800000 | N800000-SCALE-01 | 11 classes; high_occupancy emit_n=1 prec_all_x1000=1000 |

Master §7 “Same:” lists parser/key/dir/overflow/cap **laws**. Required query classes are listed once for C1. 2045Z demanded 65k/262k **bags exist**. They exist as scale-addressability rungs, not as a second 11-class copy.

### Cap policy (CONFIRMED latent)

16k KEEP `CLASS_high_occupancy emit_n=16 tp=1 fp_fill0=15 prec_all_x1000=62` — cap **binds**, precision collapses, recall still 1000.

800k-scale `CLASS_high_occupancy emit_n=1` — AND is unique; cap **does not bind**. Sweep 16/64/128/256 identical. Selecting `CAND_CAP_FINAL=16` is smallest tested cap with 100% recall on **this** image. It is not a dense-posting stress proof.

2045Z: do not freeze CAND_CAP_FINAL. Master: freeze only after sweep. LOOP froze 16 after sweep. Bag banners still print `CAND_CAP_FINAL=NOT_FROZEN`. Classification split is disclosed, not hidden.

### Cube truncation (FACT + UNKNOWN delta)

Host constants: `N_ENT=201`, `N_REL=20`, `OBJS_PER=200`, `N_STREAM=799996`, `N=800000`.

`201*20*200=804000` cartesian SROs. Addressable nids = 800000.

2045Z census: dropped SROs = 4002. Arithmetic `804000-799996=4004`. The 2-count reconciliation was **not re-run** this RCA. Either way the cube is truncated. Illegal as “valid-record representation coverage = 100%” if valid-record means the full cartesian product. Legal as N=800000 addressable retrieve (registered unknown).

### Occupancy WARN still live (not blocking)

Close-gate `OCCUPANCY_PROJECTION_800K` ok=false, blocking=false: 16k max occ=142 naive×800k ≈6933 vs MERGE 256. This scale bag widened entities (`n_subjects=201`, fill occ=202), so the 16k 120-entity projection is **not** this bag’s occupancy. WARN remains as a KEEP-corpus lesson, not a scale-bag FAIL.

---

## Letter of Master §7 vs frozen acceptance

Primary unknown: same role-aware law, selective retrieve, bounded traffic, real index law, N=800000.

**HIT as XSim letter:** ladder N exists; instantiate stack frozen; 11/11 class prints at 800k-scale; recall/precision 1000/1000 on that set; reduction vs N ≥90%; cap sweep run; gold miss would FAIL (incomp not used to hide miss); SEARCH_INCOMPLETE token absent; no FIRST_DIVERGENCE.

**NOT HIT as frozen mass / board:** ≥95% grammar mass; cap unstressed at 800k; DDR bound; bucket-skew histogram; per-query latency; descB=0; wrong-context plant keys 3380/3636; QSE_SYN_N=1; AXI not MIG; coverage 100% of 804k cube.

---

## Strongest counter-argument (devil-advocate)

Steelman of YES_XSIM: 2045Z listed the missing evidence; that evidence now exists; cartesian was already the C1 index law.

Challenge: (1) same Cursor session implemented and ACCEPTed; (2) `CAND_CAP_FINAL=16` on an image designed so high-occupancy AND emit is 1, while the KEEP 16k bag already showed cap=16 emits 15 extra; (3) 65k/262k are 4-class; (4) Master frozen “coverage=100%” vs truncated cube.

If “auditor ACCEPT” must be a **different model**, treat 2148Z as a nominated close and keep the XSim facts. Do not reopen by deleting bags. Do not stamp BOARD to paper over the process defect.

---

## Finding classes

| Id | Class | Statement |
|---|---|---|
| RC-2045-EVIDENCE-GAP | CONFIRMED_ROOT_CAUSE | C1 stayed OPEN at 20:45 because ladder/classes/reduction/sweep were missing. |
| RC-CURSOR-FILLED-GAP | CONFIRMED_ROOT_CAUSE | YES_XSIM is licensed by filling those four gaps. |
| RC-CARTESIAN-IS-C1-LAW | CONFIRMED | 16k KEEP fill_frac=1.0. Scale n=800000, not a 16k clone. |
| RC-AXI-NOT-DDR | CONFIRMED | Illegal as BOARD / DDR_QUERY_BOUND_FINAL. Legal as C1 XSim index law. |
| RC-SELF-AUDIT | HIGH_RISK process | Same session implemented and ACCEPTed. |
| RC-CAP-UNSTRESSED | LATENT_DEFECT | CAND_CAP_FINAL=16 unstressed at 800k; 16k already bound the cap. |
| RC-HOST-DUT-POST | CONFIRMED_DEFECT (accounting) | Fill host 102 vs DUT 52 beats. Late_gold MATCH. |
| RC-CTX-PLANT | EVIDENCE_GAP | Wrong-context occ=1 planted keys 3380/3636. |
| RC-CUBE-TRUNC | FACT | Cube 804000 vs N=800000. 4002 vs 4004 census delta UNKNOWN. |
| RC-65K-FOUR-CLASS | FACT | 65k/262k are scale rungs, not 11-class copies. |

---

## Commands actually run

```text
command     = python D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\scripts\c1_800k_close_gate.py
cwd         = (tool default)
exit        = 0
output      = c1_close=YES_XSIM c2_may_start=YES blocking=[]
wrote       = results/c1_800k_close_gate.json (overwrite)

command     = Get-FileHash SHA256 scale/sweep xsim.log + GOLDEN.json
exit        = 0
result      = hashes MATCH 2148Z / GOLD_HASH_PRE_XVLOG GOLDEN
```

Not run: Vivado xsim re-sim, MIG, board, second-model auditor, cube census re-count.

---

## Verdict

```text
claim              = C1 XSim law closed
final_verdict      = ACCEPT_WITH_BOUNDS
c1_close           = YES_XSIM  (keep)
BOARD_PASS         = REJECT    (keep)
C2_MAY_START       = YES       (persist bag only, PROGRAM=NO)
do_not_reopen_xsim = true unless a KEEP hash drifts or gold is regenerated
```

Next honest work is C2 persist identity, not another 800k retrieve bag, and not silicon.
