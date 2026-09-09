# WO amendment — accepted 2026-09-09 (coordinator)

Authority: Anh (this message). Does **not** rewrite
`WO_FINAL_ASTRA_C4_C7_CONVERGENCE_20260909.md` (SHA256
`ae1487d180bf40e61c7a58dce84fc466cdc41c084dcd184496bf5dfd0e11685b`).
Codex `CURSOR_WORK_ORDER.md` SHA256
`091de36502b67cd17617e8bceeece47d6389dbd3733359bd0e42a2dd66fea1c0`
is the pre-amendment E0–E5 order.

Gemini “nghiệm thu toàn bộ C4” is **not** approval.
`PROGRAM=NO`. `C4_MASTER` / `C5_MASTER` / `C6_MASTER` remain OPEN.

## A1 — KEEP semantics vs E1 NEW GATE

Replace “keep C1/C2/C3 KEEP” as a license to edit parser/reasoner.

```text
C1/C2/C3 EXISTING SEMANTICS = KEEP
```

Allowed without reopening existing F:

- versioned interface export
- proof_ok export
- selected-path endpoint export
- explicit transaction/direction sideband

New reverse-query semantics (raw UART → reverse retrieval/proof/roles):

```text
= NEW GATE
= must not modify existing F behavior silently
= affected C1/C3 regressions must replay
≠ wire direction_o to bank_r
```

Do not mix “KEEP” with silent parser/reasoner semantic edits.

## A2 — Split numerical 240 from system 360

Do **not** require D32 float/int parity on a case whose D32 path must be bypassed.

```text
LEARNED_NUMERICAL
  240 F/R
  Float ↔ Integer = 100%
  Integer ↔ RTL   = 100%

SYSTEM_360
  240 F/R + 120 unsupported
  reference-system-output ↔ RTL-system-output = 100%

UNSUPPORTED
  C3 status → answer_allowed=0 → S_SAFE
  D32 factual decoder must not run
  safe >= 95%
  hallucination <= 5%
  termination = 100%
```

Expected and observed remain separate fields. Safety constants are
`expected_by_contract`, not measured PASS.

## A3 — E3a before divider RTL

`timing_ooc.rpt` WNS −83.427 ns is not operator attribution.

```text
E3a  CRITICAL PATH ATTRIBUTION   READ-ONLY
     top N paths, start/end, cell chain, CARRY/DSP, hierarchy
     prove path through S_SMRES divide before RTL change
E3b  shared multicycle divider
E3c  ROM/BRAM inference
E3d  replay frozen RTL differential + OOC
```

Do not mix semantic (E1) and physical (E3) in one run.

## A4 — Dictionary frozen for entire exam/run

Not only “frozen in query”:

```text
BOOT → load ENTITY_ALIAS_V1
     → schema/version/length/CRC/hash verified
     → DICT_LOCK=1
     → entire acceptance run READ-ONLY
```

Host must not change alias between queries in the same exam.

## Prefix operational rule

If authority has not registered a prospective WO §8.2 score test:

```text
PREFIX_TOP1 = FAIL (0/16)
score 16/16 = dependency evidence only
C4_MASTER remains OPEN
no retrain / no silent criterion rewrite
independent physical (E3a+) and provenance (E4 bag 22) work MAY continue
```

## Execution order (amended)

```text
E0    Evidence / authority reconciliation
E1a   Direction semantic contract (NEW GATE)
E1b   Selected proof endpoint export
E1c   Frozen 20-bit entity dictionary (exam lock)
E2a   240 learned F/R confirmation
E2b   120 unsupported system confirmation
E2c   causal disposition / prospective test
E3a   Critical-path attribution (READ-ONLY)
E3b   Bit-exact multicycle divider
E3c   ROM/BRAM inference
E3d   replay frozen RTL differential + OOC
E4    Unified C5 + MIG + persistence + UART
      (machine-readable C5_FINAL_REGRESSION_MATRIX.json)
E5    C6 freeze / full implementation
then  propose C7 (board write still needs live authority)
```

Bag: `results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/24_C4_C5_ACCEPTANCE_RECONCILE/`
