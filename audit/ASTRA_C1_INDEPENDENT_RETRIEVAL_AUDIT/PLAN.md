# Plan — root-cause C1 retrieval without overwriting Grok

**Authority for execution still Grok parent.** This file is a recommended work-order sequence after `ASTRA-C1-N4096-INTERSECT-01` closeout exists. Do not dispatch implementers into the live N=4096 bag.

C0 hashes stay frozen: `cd7baf49` extract / `38189974` lexicon / `09334e42` dir / `5a4ad04d` sparse / `49a66da2` gate.

---

## Decision now (parent)

1. **Do not edit** N=4096 DUT, gold, or TB while Grok finishes.
2. **Do not freeze C1 / 800k / `DDR_QUERY_BOUND_FINAL` / `CAND_CAP_FINAL`** from N=4096 even if `ASTRA_C1_N4096_INTERSECT_XSIM_PASS` is present.
3. Treat live sentinel miss as **P0-1 already exhibited**: gold 4095 ∈ full(k0)∩full(k1), ∉ first16∩first16. TB PASS does not require that class.
4. Next unknown after Grok auditor: **not N=16384 on the same law**.

If Grok auditor ACCEPT_PARTIAL on “same-law scale, marker present”, parent maps **REJECT promotion of C1 scale** and opens the bags below.

---

## Chosen design (best of the proposals)

### Keep

- `qse-v2-intersect-01` as the **N=256 conjunction proof** (union is gone). Archive; do not silent-patch.
- Parser / 2-hop / SGD / UART / A09R8 checkpoint untouched.
- `CAND_CAP` as **emit budget after intersection**, not per-table walk budget.
- `SEARCH_INCOMPLETE` when the byte/page budget exhausts before AND finishes — never empty-as-UNKNOWN.

### Reject for V1 (or defer)

- Patching `a7ng_sparse_dir_axi` in place (C0).
- Loading full postings into BRAM.
- Mixing context keys + stream intersect + 65k directory in one bag.
- Freezing bounds from `n_post_ar * 16`.
- Using `prec_ev1` as Master C1 headline.

### P0-1 root fix — new law `qse-v2-stream-intersect-02`

FPGA-shaped, user’s two-pointer:

```text
directory k0, k1 → posting_count
rare list first (smaller count drives)
sorted-by-nid merge:
  A==B emit
  A<B  advance A
  A>B  advance B
CAND_CAP applies only to emit
page buffer = 1 beat (4 IDs), not the whole posting
```

Requires **postings stored sorted by nid** (host builder + RTL contract). Current corpus order is already nid-increasing within a key for the synthetic clones; freeze it as law.

Rare-list-first belongs in **this same scheduler unknown** (it does not change the mathematical AND). Skip/min-max page metadata is a **later** bandwidth bag.

New RTL: `a7ng_query_axi_sparse_stream_intersect.sv` instantiating frozen extract + relbind + **new** merge walker. Do not edit C0 dir/sparse files. If the walker must change AXI geometry, that is a **new named module**, new hash, new bag.

### P0-2 measurement — bag before or in parallel with stream law

**Preferred first slice (zero candidate-law change):**

`ASTRA-C1-AXI-BEAT-ACCOUNTING-01`

- AXI probe on existing intersect wrapper ports: `rvalid && rready` → `DIR_R_BEATS`, `POST_R_BEATS`, `TOTAL_AXI_BYTES`.
- Replay **frozen N=256 KEY-INTERSECT** queries.
- PASS iff emit IDs **bit-identical** to KEY-INTERSECT gold **and** `TOTAL_AXI_BYTES >= reported AR*16` with documented ratio.
- Still `PROGRAM=NO`. Does not freeze `DDR_QUERY_BOUND_FINAL`.

Do not put counters only in the host twin.

### P1 metric — contract only (no RTL)

Master C1 headline: `precision_all = TP / emit_n`, posting-selectivity bytes from R-beats, `SEARCH_INCOMPLETE` rate. Keep `prec_ev1` as diagnostic.

N=4096 TB PASS must add: **no SEARCH_INCOMPLETE on retrieve classes that declare gold_n>=1**, or those classes FAIL the scale unknown. Current hole allowed sentinel miss.

### P1 context — later law `qse-v2-intersect-context-02`

Only after stream-intersect 256 replay + one scale rung.

```text
ctx_valid independent of ctx_id==0
if ctx_valid: emit = k0 ∩ k1 ∩ k_ctx
k_ctx = {subj, rel, ctx}  (preferred over {rel, ctx})
```

One unknown: context selectivity. Do not fake keys in the stream bag.

### P2 directory — bag after stream correctness

Option A (full 16-bit, 4×65536×16 B ≈ 4 MiB DDR) is the V1 default **if** keys stay 16-bit. Cheaper conceptually than hash+tag.

Option B (4096 buckets + full-key tag) if keys grow past 16-bit.

Do not do this in the same bag as merge scheduler.

### Dataset split — before 16384

- **Stress:** late gold (high nid), adversarial prefix fillers, overflow chains, occupancy >> cap.
- **Semantic:** real entity/relation/context mass, held-out combinations, independent gold not cloned text.

N=4096 today is stress-on-12-entities. Do not call it 800k-representative.

---

## Ordered bags (one unknown each)

| # | Bag | Unknown | Must not |
|---|-----|---------|----------|
| 0 | Grok finishes N4096 + auditor | identity vs host twin | We write their bag |
| 1 | `ASTRA-C1-AXI-BEAT-ACCOUNTING-01` | AR×16 vs accepted R-beats on frozen N256 emit | New intersect law |
| 2 | `ASTRA-C1-STREAM-INTERSECT-02` at **N=256** | CAP_AFTER + sorted merge + rare-first; gold late-id **must hit**; emit of early-gold classes stay exact vs control | Context keys; 65k dir; N=800k |
| 3 | Same law N=4096 **late-gold stress** | Scale of merge, not prefix luck; sentinel/late nid in gold | Marker-only PASS |
| 4 | Optional `ASTRA-C1-DIR-FULL16-01` | 16-bit exact bucket | Scheduler change |
| 5 | Optional `ASTRA-C1-PAGE-SKIP-01` | min/max page skip bytes | Key law |
| 6 | `qse-v2-intersect-context-02` | wrong_context emit ≠ direct | Scheduler |
| 7 | Semantic corpus ladder 16k→800k | Master recall/reduction | Synthetic-only clones |

Restart 256→4096→16384→… only from **one frozen stream law** after bag 2 PASS.

---

## Why this order

P0-2 first because it is **measurement authority** and can wrap existing RTL without claiming a new retrieval law. P0-1 next because N=4096 already **missed a gold that AND-then-cap would keep** — further upscale on `qse-v2-intersect-01` farms prefix-luck PASSes and undercounted bytes.

Context and 65k directory are real but they did **not** cause the sentinel miss (12 entities, same keys as direct). Fixing them first would hide the scheduler bug behind a new law.

---

## Hard stops

- No C0 silent patch.
- No nid-derived keys.
- No `relevant=router_union`.
- No `CAND_CAP` drop to hide trunc.
- No BOARD_PASS / C1 800k from these bags.
- No writes into Grok’s live N=4096 folder from this audit tree.

---

## Addendum 2026-09-07 evening — close C1 at 800k then start C2

Morning PLAN bags 0–6 **executed by Grok** through STREAM-02 N4096, DIR-FULL16 (parameter), PAGE-SKIP, CONTEXT-02, SEMANTIC-16K, HELDOUT, unseen-SRO, NL FAIL, 1-alias synonym. That does **not** close C1.

Independent close-gate `python scripts/c1_800k_close_gate.py` (2026-09-07 20:35 +07):

```text
C1_CLOSE=NO
C2_MAY_START=NO
blocking: LADDER_65536_BAG, LADDER_262144_BAG, N800K_RESULTS_EXIST, REDUCTION_METRIC_EMITTED
WARN: occ_16k_max=142 → same-entity 800k proj≈6933 vs MERGE_POST_AR_MAX=256
```

Owner 800k-first WO and LOOP `unblocked_item=ASTRA-C1-SEMANTIC-800K-01` are **rejected** as the next implementer bag. Paste: `GROK_C1_CLOSE_PROMPT.md`.

### Remaining ordered bags (one unknown each)

| # | Bag | Unknown | Must not |
|---|-----|---------|----------|
| 8 | `ASTRA-C1-N65536-SCALE-01` | N=65536 records on synonym wrap `a84bbf7e` + ctx keys; late 65534 / sentinel 65535 HIT; reduction printed | 16k clone; drop N; start 262k/800k; silent MERGE bump |
| 8b | occupancy fork (only if 65k `SEARCH_INCOMPLETE`) | A widen entities / B PAGE-SKIP instantiate `dab15d76` / C named wrap + documented `MERGE_POST_AR_MAX` | Edit KEEP stream-02 `14f75db7` |
| 9 | `ASTRA-C1-N262144-SCALE-01` | Same law as the 65k that passed; N=262144; late 262142 / sentinel 262143 | Chain 800k in same XSim |
| 10 | `ASTRA-C1-SEMANTIC-800K-01` | 800000 distinct nids + Master §7 query classes | KEEP corpus `6991adc7` printed as 800k; U5 plant; tautology `1-CAND_CAP/N` |
| 11 | `ASTRA-C1-CAND-CAP-SWEEP-01` | Freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from R-beats | Freeze from AR×16 or from CAND_CAP=16 habit |
| 12 | auditor ACCEPT C1 | Independent gate green + Master measurements | Implementer self-ACCEPT |
| 13 | `ASTRA-C2-PERSIST-COMMIT-01` | UPDATE_RECEIVED…PERSISTED; warm DDR restore | Retrieval; PROGRAM until persist XSim |

Reduction print from bag 8 onward:

```text
REDUCTION_VS_N_X1000   = 1000 * (1 - occ/N)     // Master ≥90% for N≥4096
REDUCTION_VS_OCC_X1000 = 1000 * (1 - emit_n/max(occ,1))
TOTAL_AXI_BYTES        = (rvalid && rready) * 16
```

Never `1-CAND_CAP/N`. Independent `scripts/assert_scale_bag.py` FAILs `REDUCTION_X1000=NOT_EMITTED`.
