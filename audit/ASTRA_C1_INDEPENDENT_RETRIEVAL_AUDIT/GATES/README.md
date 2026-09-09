# Independent test gates (Antigravity builds and runs these)

Gates live **only** in this tree. They read the live clone. They never edit it.

## Run now

From `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`:

```bat
python scripts\c1_800k_close_gate.py
python scripts\c2_persist_close_gate.py
python scripts\c3_heldout_prereg_gate.py
```

Expected tonight:

```text
c1_close = YES_XSIM          (BOARD still REJECT)
c2_close = YES_XSIM          (BOARD still REJECT)
c3_close = NO                (bag not started; A09R8 w0 must not close)
```

## Gates to build next (Antigravity)

| ID | Script / hunt | Catches |
|---|---|---|
| G-HASH | live SHA vs `KEEP_HASHES.json` | silent KEEP / C0 patch |
| G-LOG-RESULTS | CLASS_* in xsim.log vs RESULTS.md | overclaim |
| G-GOLD | GOLDEN.json vs GOLD_HASH_PRE_XVLOG.txt | gold regenerated after fail |
| G-DUT-XVLOG | compiled files vs forbidden DUT | leftover A09 / STREAM-02 / prior_store / synth mig.v as DUT |
| G-C1-TAUTOLOGY | `1-CAND_CAP/N` | fake reduction |
| G-C1-CARTESIAN | fill_frac / unique_nids vs banner N | 16k clone labeled 800k |
| G-C2-LOW16 | AWADDR vs subj[15:0] | prior_store identity |
| G-C2-FALSE | n_false=0 + PERSISTED implies packed beat | false success |
| G-C2-DEAD-TXN | F_BAD_TXN after DUP | dead required-test |
| G-C2-MIG-POSTED | CLASS persist before ddr3 WRITE | B-OKAY ≠ DRAM row |
| G-C3-W0 | `w0 0→-5` called transfer | A09R8 reachability as C3 |
| G-C3-DISJOINT | train entities ∩ held-out | leakage |
| G-C3-ARMS | missing B/C/D controls | one-arm “transfer” |
| G-C3-HOST | host winner/address/weight | CPU learning |
| G-C4-CLASSID | LM emits class ID / host sentence | not language |
| G-C4-TEACHER | teacher-on in claimed exam | cheat |
| G-C5-PLANT | plant LUT as corpus authority | fake DDR |
| G-C5-SHADOW | unused path drives result | shortcut |
| G-C6-A09R8 | A09R8 bit as C6 | missing DDR+LM |
| G-C7-BLIND | host route/winner on board exam | not blind |
| G-PROMO | BOARD_PASS without C7 unique bit | promotion cheat |

Each new gate writes JSON under `results/` with `ok`, `blocking`, `evidence_path`, `classification` in {FACT, INFERENCE, HYPOTHESIS, UNKNOWN, CONTRADICTED}.

## C3 first implementer bag (WORK_ORDER only — Cursor builds)

Do **not** implement in this tree. Spec the bag so Cursor cannot cheat:

```text
Bag: ASTRA-C3-HELD-OUT-01
Unknown: gain of shared 32-feature learner vs frozen/no-update on disjoint held-out
Must HIT: 5 seeds, arms A/B/C/D, entity disjoint, scalar reward only, host winner=0
Must NOT: A09R8 w0 0→-5 as transfer; identical-φ plants as seeds; edit C1 KEEP; PROGRAM
Retention after persist reload is C2∩C3 (drop <=5 pp) — may be a later named bag
Silicon microexam is C7 phase 6, not this XSim bag
```

See Master V1.1 §9.
