# WO — ASTRA-C3-HELD-OUT-01

Status: **READY** (Antigravity second-model hunt of C1/C2 complete; C3 gate red)
Issued: 2026-09-07T17:20Z by Antigravity (independent auditor)
Implementer: Cursor (live clone only)

## Unknown (one)

Does the shared 32-feature learner, operating through the frozen C1 query law
(role-aware parser → sparse directory → AXI index → intersect → rank) and
using the frozen C2 persist identity (20-bit canonical, AXI journal at
0x06000000+slot×16, schema=1), improve held-out queries whose **entities are
disjoint from training**, versus frozen / shuffled / per-ID controls?

This is the Master V1.1 §9 primary unknown.

## HIT letter (Master V1.1 §9 — verbatim)

```text
seeds                              >= 5 (archived, not identical-φ plants)
arms                               A (shared 32-feature learner)
                                   B (frozen/no-update)
                                   C (shuffled reward)
                                   D (per-ID prior / identity-only baseline)
same frozen train/held-out worlds  ALL arms on same worlds
entity disjointness                train entity set ∩ held-out entity set = ∅
gain(A over B)                     >= 10 percentage points
paired CI lower bound              > 0
A > shuffled reward arm C
A > or meaningfully complements per-ID baseline D
host winner/address/weight update  = 0
Always-UNKNOWN                     = FAIL
retention drop after reload        <= 5 pp (may be later named bag)
```

Also report per Master §9:
- answer coverage
- selective accuracy
- UNKNOWN rate
- CONFLICT rate
- SEARCH_INCOMPLETE rate

## FAIL if (hard stops — gate scripts will catch)

1. **A09R8 `w0 0→-5`** is the transfer evidence (Master §9: "It does NOT by
   itself prove transferable learning").
2. **ASTRA-07 / F3 historical bags** are relabeled as this bag.
3. **Held-out entities appear in train** (entity disjointness violated).
4. **Only arm A is run** (missing B/C/D controls).
5. **Identical-φ plants as seeds** (must be different random initializations).
6. **Gold edited after xvlog** (hash must match GOLD_HASH_PRE_XVLOG.txt).
7. **C1 KEEP retrieve RTL edited** after C1 close.
8. **C2 KEEP persist RTL / mig.prj edited** after C2 close.
9. **PROGRAM=YES** (this is XSim evidence, not board).
10. **RESULTS self-stamps C3 Master close** or BOARD_PASS (auditor stamps,
    not implementer).
11. **Host winner / host address / host weight update ≠ 0** (Master §9:
    "No answer/winner labels may be supplied to the FPGA at reward time").
12. **Answer is always UNKNOWN** (trivial classifier, Master §9:
    "Always-UNKNOWN cannot PASS").
13. **Corpus is a different image from the C1 frozen 800k cartesian**
    (unless a new C1 rung is opened and closed first).
14. **Learner drives host-side computation** (teacher path, host
    next-token, host route — all must be 0).
15. **gain(A over B) < 10 pp** or CI lower ≤ 0 (threshold is frozen,
    cannot be lowered after FAIL).

## Forbidden edits (KEEP integrity)

```text
DO NOT EDIT:
  - Any file in KEEP_HASHES.json (C0 + C1 + C2)
  - C1 KEEP retrieve RTL: synonym_01, ctx_keys, intersect_*, page_skip, stream_intersect
  - C2 KEEP persist RTL: persist_commit, persist_multi_slot, persist_ddr_stall, persist_mig, mig_native_wrap
  - Official mig.prj / ddr3_model
  - C0 frozen: extract, lexicon, sparse_dir, query_axi_sparse, route_valid_gate
  - GOLDEN.json after xvlog (must seal GOLD_HASH_PRE_XVLOG.txt before first compile)
```

## Retention after reload

`retention drop <= 5 pp` may be a **later named bag** (`ASTRA-C3-HELD-OUT-RELOAD-01`)
that uses C2 persist KEEP as submodule. Do not mix "does learning transfer?" and
"does persist preserve transfer?" in one unknown if the TB cannot separate them.

If this bag does include persist reload, the persist path must use the frozen
C2 KEEP DUT (`a7ng_astra_c2_persist_commit.sv` SHA `86a7a069...`) and
schema=1.

## Silicon microexam

Not this bag. C7 phase 6 is the silicon microexam for held-out transfer.
The statistical 5-seed evidence may be XSim/reference-controlled per Master §9.

## Scope freezes

```text
PROGRAM                = NO
PERSIST_SCHEMA_VERSION = NOT_FROZEN (this bag does not freeze it)
DDR_QUERY_BOUND_FINAL  = NOT_FROZEN (this bag does not freeze it)
LM06_BYTE256           = NOT_FROZEN (C4, not C3)
Evidence class         = XSIM (not BOARD)
```

## Gate scripts that will verify (in audit tree)

```text
scripts/c3_heldout_prereg_gate.py  — must turn green after bag completes
scripts/c1_800k_close_gate.py      — must remain YES_XSIM
scripts/c2_persist_close_gate.py   — must remain YES_XSIM
```

Additional gates to build: G-C3-W0, G-C3-DISJOINT, G-C3-ARMS, G-C3-HOST
(see GATES/README.md).

## What Cursor implements

On the live clone (`D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH`):

1. New bag directory: `results/A7-NATIVE-GRAPH/ASTRA-C3-HELD-OUT-01/`
2. New C3 DUT RTL (not modifying KEEP C1/C2 files)
3. TB with 5 seeds, 4 arms, disjoint entity sets, scalar reward
4. `GOLDEN.json` frozen before xvlog (record `GOLD_HASH_PRE_XVLOG.txt`)
5. `xsim.log` with CLASS markers for each arm and metric
6. `RESULTS.md` and `CLOSEOUT.md` (does not self-stamp Master close)
7. Update `LOOP_STATE.json` implementer field after completion

Cursor does **not** write to `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`.
