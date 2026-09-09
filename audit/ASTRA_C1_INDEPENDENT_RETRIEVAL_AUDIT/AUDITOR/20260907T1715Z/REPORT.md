# ASTRA auditor REPORT — 20260907T1715Z (Antigravity second-model)

```text
ROLE       = independent second-model auditor of C1 + C2 XSim close
           Antigravity (Claude Opus 4.6 Thinking)
           Second-model hunt of 2148Z (C1) and 1652Z (C2), both same-Cursor.
CWD        = D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
PROGRAM    = NO
RTL_EDIT   = NO
FIX        = NO
BAGS_C1    = ASTRA-C1-N800000-SCALE-01 + ASTRA-C1-CAND-CAP-SWEEP-01
BAGS_C2    = ASTRA-C2-PERSIST-COMMIT-01 + MULTI-SLOT-01 + DDR-STALL-01 + MIG-01
PRIOR      = 2148Z ACCEPT C1 (same-session); 1652Z ACCEPT C2 (same-session)
AUTHORITY  = Master V1.1 §7 C1 + §8 C2; RAW xsim.log > CLOSEOUT
```

This audit did not program the board, did not edit `rtl/`, did not edit KEEP C1 or
C2 bags, did not patch C0 hashes, did not freeze `PERSIST_SCHEMA_VERSION` or
`DDR_QUERY_BOUND_FINAL`, did not start any C3 bag.

---

## Motivation

Cursor auditor reports 2148Z (C1) and 1652Z (C2) both disclose same-session
implementation. This second-model hunt provides the architecturally required
independent confirmation by reading raw `xsim.log` files, comparing to CLOSEOUT
claims, and running close-gates from the independent audit tree.

---

## C1 second-model findings

### C1.1 — Cartesian corpus confirmed procedural + unmaterialized

`corpus.json` in SCALE-01: `"generator": "cartesian_n800000_v1"`,
`"procedural": true`, `"records_materialized": false`. Memory backed by
behavioral AXI model `a7ng_axi_mem_proc_800k.sv` + `gen_800k.svh`. This is
the existing C1 index law (same as 16k bags) at N=800000 — not a cheat, but
a quality bound. 2148Z correctly noted this.

### C1.2 — Cap sweep non-binding (FACT)

All four cap points (16/64/128/256) produce identical `TOTAL_AXI_BYTES=1632`
and identical sim time `59025 ns`. Max intersection size ≤ 3 across all
cartesian queries. `CAND_CAP_FINAL=16` is selected but never exercised.
The CLOSEOUT admits: "Cap is not the binding constraint on this cartesian image."

Classification: **FACT** — cap sweep passes but does not stress the cap mechanism.
Not a failure: 2148Z correctly noted as quality bound.

### C1.3 — DDR_QUERY_BOUND_FINAL = NOT_FROZEN (FACT)

Both bags explicitly print `DDR_QUERY_BOUND_FINAL=NOT_FROZEN` in banner and
NOT_CLAIMED lines. No unauthorized freeze found. `TOTAL_AXI_BYTES=1632` is
AXI procedural R-path, not MIG.

### C1.4 — REDUCTION_VS_N_X1000 is real but degenerate (FACT)

Formula: `(1000 * (N - OCC)) / N`. Not the crude `1-CAND_CAP/N` tautology.
But because max OCC=202 ≪ 800,000, it truncates to 999 for all non-empty
classes. Correct per definition; degenerate per stress.

### C1.5 — All 11 CLASS markers present and HIT (FACT)

Verified in raw SCALE-01/xsim.log: fill_template, paraphrase, nl_synonym,
role_reversal, wrong_relation, wrong_context, distractor, high_occupancy,
late_gold, high_id_sentinel, unrelated. All `rec_x1000=1000 incomp=0`.
No FIRST_DIVERGENCE, no SEARCH_INCOMPLETE.

### C1.6 — Wrong-context special-case (INFERENCE)

`gen_800k.svh` hard-codes keys 3380/3636 → `occ=1, nid=121` to satisfy
wrong_context without general context dimension across the cube. This is
a generator limitation, not a cheat — but it means wrong_context coverage
is synthesized, not emergent.

### C1.7 — Gold integrity confirmed (FACT)

GOLDEN.json SHA `3b900979...` matches GOLD_HASH_PRE_XVLOG.txt in both bags.
Sweep GOLDEN byte-identical to scale (frozen copy). No post-xvlog regeneration.

### C1.8 — Host leakage zero (FACT)

`POKE_V=0`, `fp_ev1=0`, `fp_fill0=0` throughout. No host semantic leak.

### C1 verdict

**ACCEPT C1 XSim law close** — confirms 2148Z. Same quality bounds apply:
cartesian, AXI-only, cap unstressed, 1-pair synonym, generator ctx special-case.
These are BOARD / mass rejects, not XSim-law fails.

---

## C2 second-model findings

### C2.1 — F_BAD_TXN is dead code (RTL_FACT)

In `a7ng_astra_c2_persist_commit.sv`, DUP branch (identity+gen match) fires
before BAD_TXN (same identity+gen + different txn). Since DUP matches whenever
all five fields match, regardless of txn, BAD_TXN is mathematically unreachable.
Multi-slot RTL eliminates the code entirely. DDR-STALL does not define it.

Classification: **RTL_FACT** — declared fail code that never fires. Not a
functional test failure but an RTL coverage gap. Should be tracked for C5
production-top hygiene (either exercise or remove).

### C2.2 — MIG posted-write ordering (FACT)

In MIG xsim.log:
- L1043: `CLASS_persist_through_mig HIT` (on AXI BVALID)
- L1046: `CLASS_bram_clear HIT`
- L1048: ddr3_model Write command at t=123768466 ps
- L1050-1057: ddr3_model WRITE @ DQS data bursts
- L1062-1069: ddr3_model READ @ DQS data bursts (byte-identical)
- L1071: `CLASS_reload_from_mig HIT identity_exact w0=2`

PERSISTED declared at AXI B handshake, BEFORE DRAM physical write. This is
standard Xilinx MIG AXI posted-write semantics. Mitigated by read-after-write
proof. 1652Z correctly noted: "Do not promote B-OKAY to DRAM row already written at B."

Classification: **FACT** — MIG_XSIM evidence, not BOARD.

### C2.3 — DUP vs cache-hit semantic shift (INFERENCE)

COMMIT-01: same-identity replay → `CLASS_duplicate_reward`, w0 unchanged.
MULTI-SLOT-01: same-identity replay → `CLASS_cache_hit`, w0 mutated in-place.
The two DUTs handle identity re-presentation differently. Not a test failure;
reflects design evolution. C5 production-top must reconcile.

### C2.4 — AWADDR = 0x06000000+slot*16, not low16 (FACT)

All four bags: `CLASS_journal_addr_not_low16 HIT`.
- COMMIT: awaddr=0x06000000
- MULTI: last_aw=0x06000020
- STALL: last_aw=0x06000010
- MIG: awaddr=0x06000000

Not deprecated prior_store / ASTRA-06 low16 address scheme.

### C2.5 — n_false=0 in all four bags (FACT)

All four HEADLINE lines: `n_false=0`. All four: `CLASS_false_success_zero HIT`.
No false success where packed beat ≠ intended state.

### C2.6 — Canonical 20-bit identity (FACT)

High-ID subjects: `subj=0xC34FF, obj=799998, ctx=0xABCDE` in all four bags.
`CLASS_alias_attempt HIT lk_hit=0 low16=034ff stored=c34ff` — full 20-bit
lookup, not low16/low8. `CLASS_alias_full20_hit HIT` in COMMIT.

### C2.7 — Gold integrity confirmed (FACT)

All four GOLDEN.json hashes match GOLD_HASH_PRE_XVLOG.txt:
- COMMIT: `d24339...`
- MULTI: `e452f6...`
- STALL: `ef498f...`
- MIG: `9618d7...`

No post-xvlog regeneration. COMMIT bag preserves `xsim_fail_r0.log` documenting
a pre-golden compile issue — honest disclosure.

### C2.8 — Scope confinement (FACT)

All four bags: `RESULT=PASS_THIS_GATE_ONLY`.
All four: `NOT_CLAIMED=BOARD_PASS,ACCEPT_BOARD,DDR_QUERY_BOUND_FINAL,...,C2_MASTER_CLOSED`.
PERSIST_SCHEMA_VERSION and DDR_QUERY_BOUND_FINAL remain NOT_FROZEN.
Held-out query after reload is NOT_THIS_GATE (C3 / C7 phase 6-7).

### C2 verdict

**ACCEPT C2 XSim law close** — confirms 1652Z. Quality bounds: modeled-AXI
capacity/stall (not MIG PHY), single-slot MIG (not multi-slot through MIG),
F_BAD_TXN dead code, posted-write semantics. These are BOARD / production-top
rejects, not XSim-law fails.

---

## Combined verdict

```text
FINAL                  = ACCEPT C1 + C2 XSim law close (second-model confirmation)
C1_XSIM_LAW            = ACCEPT
C2_XSIM_LAW            = ACCEPT
PROMOTION              = REJECT
BOARD_PASS             = REJECT
ACCEPT_BOARD           = REJECT
CAND_CAP_FINAL         = 16
DDR_QUERY_BOUND_FINAL  = NOT_FROZEN
PERSIST_SCHEMA_VERSION = NOT_FROZEN
C3_MAY_START           = YES
C3_HELD_OUT            = OPEN
PROGRAM                = NO
F_BAD_TXN_STATUS       = DEAD_CODE_TRACK_FOR_C5
```

This second-model review provides the missing independent confirmation.
Both XSim law closes are honest within their declared scope. Neither is
BOARD_PASS and neither should be promoted to production close.

---

## Machine lines (close-gate)

```text
C1_XSIM_LAW=ACCEPT
C2_XSIM_LAW=ACCEPT
C1_800K_CLOSED_XSIM=YES
C2_PERSIST_CLOSED_XSIM=YES
BOARD_PASS=REJECT
ACCEPT_BOARD=REJECT
CAND_CAP_FINAL=16
DDR_QUERY_BOUND_FINAL=NOT_FROZEN
PERSIST_SCHEMA_VERSION=NOT_FROZEN
C3_MAY_START=YES
SECOND_MODEL=ANTIGRAVITY
```
