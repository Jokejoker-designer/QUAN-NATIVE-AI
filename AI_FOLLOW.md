# AI_FOLLOW.md — how another model should audit QUAN NATIVE AI

You are reading a **public evidence export** of Astra Native AI (QUAN NATIVE AI) for Digilent Arty A7-100T.

Your job is to **follow the contracts and hunt remaining FAIL / OPEN letters**, not to declare victory from file names.

---

## 1. Authority order (do not invert)

```text
1. Raw evidence in bag CLOSEOUT.md (command + marker + DUT SHA)
2. Frozen contracts: docs/native_graph/CONTRACT_FREEZE.md, docs/contracts/**
3. results/A7-NATIVE-GRAPH/STATUS/LOOP_STATE.json
4. HARD_BLOCK_MASTER_C3_C6.md and audited CLOSEOUT / AUDIT_* files
5. docs/NATIVE_AI_ARTY_A7_BLUEPRINT/**
6. handoff close plans (proposals until RTL+XSim match)
7. Chat summaries — never authority
```

If a work order disagrees with a CLOSEOUT marker, the CLOSEOUT wins until a new command is run and recorded.

---

## 2. First files to open

1. `README.md`
2. `docs/ASTRA/PROGRESS_20260909.md` (live C4–C7; E3d OOC)
3. `docs/ASTRA/authority/WO_FINAL_ASTRA_C4_C7_CONVERGENCE_20260909.md`
4. `results/A7-NATIVE-GRAPH/STATUS/ASTRA_C4_C7_LIVE.json`
5. `AGENTS.md`
6. `docs/NATIVE_AI_ARTY_A7_BLUEPRINT/00_CURRENT_AUTHORITY.md`
7. `docs/NATIVE_AI_ARTY_A7_BLUEPRINT/04_HARDSTOPS.md`
8. `docs/authority-root/ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md`
9. `results/A7-NATIVE-GRAPH/STATUS/HARD_BLOCK_MASTER_C3_C6.md`
10. `handoff/ASTRA_HANDOFF/C1_C6_CLOSE_PLAN_20260909/MASTER_CLOSURE_PLAN.md`

Do **not** stamp `C4_MASTER` from E3d WNS improvement (−83.427 → −24.357 ns). BRAM inference is **false** on this OOC (`ram_e3d.rpt` BlockRAM = 0).

Hard stops that repeatedly burn time:

- Do **not** add TinyGPT-802k (Grok §550; BRAM 260>135; bag acc=0/2). Canonical C4 = `a7ng_astra_c4_lm06_grounded_gen.sv`.
- Do **not** stamp `BOARD_PASS` from XSim.
- Do **not** overwrite frozen LM-00…06 / A0.3 bits (not shipped here anyway).
- Host must not compute gradient / ΔW / winner / next-token on the EVAL path.

---

## 3. How to find a bug

Typical path:

```text
STATUS/HARD_BLOCK_MASTER_C3_C6.md
  → named bag directory results/A7-NATIVE-GRAPH/ASTRA-C*-*/
      → CLOSEOUT.md (PASS/FAIL, marker, SHA)
      → tb_*.sv (stimulus, illegal shortcuts)
      → rtl/native_graph/integrate/<dut>.sv (source of SHA)
```

C5 flush-reload MIG example (grant dropped while UART waits for EOL):

- RTL: `rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv` (`req[CKPT]`)
- Arbiter: `rtl/native_graph/integrate/a7ng_astra_c5_ddr_arb.sv`
- Persist: `rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv`
- Audit write-up: `audit/ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT/WORK_ORDER/20260908T2115Z_C5_DEFINITIVE_ROOT_CAUSE_AND_RESOLUTION.md`
- Bag: `results/A7-NATIVE-GRAPH/ASTRA-C5-FLUSH-RELOAD-MIG-01/`

C4 bias-load dead:

- Falsifier bag `ASTRA-C4-BIAS-LOAD-DEAD-01`
- Compare `V` vs `V[5:0]` in the grounded-gen / byte256 load path

Treat playbook patches as **proposals**. They are not PASS until `run_xsim.ps1` is re-run and CLOSEOUT is updated.

---

## 4. What this export cannot prove by itself

| Missing locally | Effect |
|---|---|
| `xsim.dir` / compiled sim | You must re-run XSim; do not invent log text |
| `.bit` / `.dcp` | You can check SHA strings in markdown, not re-hash a missing file |
| Generated MIG RTL | MIG PHY bags need Vivado IP regenerate |
| Board UART capture | Silicon claims stay OPEN unless a CLOSEOUT already recorded them |

A test is not complete until **command and result** are in CLOSEOUT.

---

## 5. Vocabulary (do not mix)

| Claim | Means |
|---|---|
| this-gate PASS | That bag’s marker HIT under the recorded TB |
| C*_MASTER CLOSED | Master V1.1 letter HIT — **not** true yet |
| BOARD_PASS | Programmed Arty A7 + UART evidence — AI must not self-stamp |
| KEEP hash | Frozen module SHA; 18/18 KEEP is not C3–C6 close |

---

## 6. Suggested investigation order

1. Contract / letter freeze (stop C3 waiting on C7 circularly).
2. C5 explicit UART reward + SGD32 full-bank persist (not C2 `w0` only).
3. C4 feasibility with ownership separate from TinyGPT; do not rename a renderer to PASS.
4. C1 real-image / C3 transfer+reload on the canonical prod_top path.
5. UART token stream, AXI error propagation, unified C5 MIG regression.
6. C6 freeze/rebuild last.

That order matches `handoff/ASTRA_HANDOFF/C1_C6_CLOSE_PLAN_20260909/START_CURSOR_AUTONOMOUS.md`.
