# ASTRA × gstack / qstack — closed loop (post-silicon V1.1)

Authority: Master V1.1 POST_SILICON + DESIGN_CANDIDATE + HANDOFF_GROK + Master V1 architecture.
gstack: https://github.com/garrytan/gstack
- Parent ≈ /autoplan + /plan-eng-review (dispatch; do not code DUT)
- Auditor ≈ /review + /qa-only (report only; FPGA QA = raw logs/UART/JTAG/RTL)
- Implementer ≈ builder (one bag)
qstack: validation-adversary + code-review (tautology, leakage, overclaim)

```
┌─────────────┐     unblocked_item      ┌──────────────┐
│ PARENT      │ ──────────────────────► │ IMPLEMENTER  │
│ (eng mgr)   │                         │ (fix/build)  │
└──────▲──────┘                         └──────┬───────┘
       │  FAIL → new named bag                 │ RESULTS.md
       │  PASS_NARROW → next C-gate            ▼
       │                                ┌──────────────┐
       └────────────────────────────────│ AUDITOR      │
          ACCEPT / REJECT / OVERCLAIM   │ read-only DUT│
          + Required fixes              │ /review      │
                                        │ /qa-only     │
                                        │ adversary    │
                                        └──────────────┘
```

Think → Plan → Build → Review → (JTAG/UART/XSim/hash, not Playwright) → Parent maps fixes → Repeat.
Do not /ship a new bit. Checkpoint bit SHA `e51bdca2…` may be re-programmed only as a test vehicle.

## Roles

| Role | gstack analog | May write RTL? | Program new bit? |
|------|---------------|----------------|------------------|
| Parent | /autoplan + eng manager | LOOP_STATE, dispatch, work orders | NO |
| Implementer | builder | yes, isolate clone, new bag/named RTL only | NO unless work order names the pinned SHA |
| Auditor | /review + /qa-only + qstack-validation-adversary + qstack-code-review | **AUDITOR report bag only** | NO |

## Hard

- CWD: `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH`
- Never write V3.1 tree.
- Auditor never “fixes” the DUT. Parent assigns a **new** implementer bag.
- Conflict: EVIDENCE > AUDIT > DESIGN_CANDIDATE > Master prose.
- Do not ask which gate is next. Queue = Master V1.1 C0→C7 + auditor Required fixes.
- Do not repeat A09R8 smoke to accumulate PASS.

## Cycle

1. Parent reads LOOP_STATE.unblocked_item.
2. If implementer RESULTS exists without auditor REPORT for that bag, spawn auditor first.
3. Implementer writes bag + RESULTS.md. Does not self-grade promotion.
4. Auditor writes `results/A7-NATIVE-GRAPH/AUDITOR/<stamp>/REPORT.md`
5. Parent maps findings → unblocked_item. Spawn implementer. Repeat.
6. Never skip auditor after an implementer PASS claim.
7. Never spawn two implementers on the same bag.

## Cheat hunts (auditor)

- Plant LUT called production DDR retrieval
- w0 0→-5 called held-out transfer / C3
- Timing-fail 100 MHz SoC bit called BOARD_PASS
- LM06 composer called language
- cap ≥ dataset as selectivity
- Historical 800k before role-law called C1
- Hash freeze after looking at C1 scores
- Editing golden to manufacture PASS
- Identical-φ plants called independent seeds
- Checkpoint A09R8 called one complete production top
