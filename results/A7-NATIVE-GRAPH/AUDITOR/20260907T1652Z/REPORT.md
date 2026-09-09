# ASTRA auditor REPORT — 20260907T1652Z

```text
ROLE       = independent auditor of C2 XSim close package
           DISCLOSURE: same Cursor session implemented
           PERSIST-COMMIT/MULTI-SLOT/DDR-STALL/MIG-01.
           This report hunts overclaim; it is not a second model.
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
RTL_EDIT   = NO
FIX        = NO
BAGS       = ASTRA-C2-PERSIST-COMMIT-01
           + ASTRA-C2-PERSIST-MULTI-SLOT-01
           + ASTRA-C2-PERSIST-DDR-STALL-01
           + ASTRA-C2-PERSIST-MIG-01
PRIOR      = AUDITOR/20260907T2148Z ACCEPT C1 XSim law
AUTHORITY  = Master V1.1 §8 C2; RAW xsim.log > CLOSEOUT
LIVE_HASH  = 2026-09-07T23:52:52+07:00 Get-FileHash SHA256
```

This audit did not program the board, did not edit `rtl/`, did not edit KEEP
C2 persist DUTs, did not edit official `mig.prj` / `ddr3_model` /
`mig_native_wrap`, did not freeze `PERSIST_SCHEMA_VERSION` or
`DDR_QUERY_BOUND_FINAL`, did not start a C3 bag, did not write V3.1.

---

## Object

Master §8 primary unknown: does a successful reward update mean the intended
architectural state was actually committed and recoverable through the
declared production persistence path?

This is an **XSim C2 law close**, not BOARD_PASS, not silicon MIG, not C3
held-out transfer, and not a production-top persist block.

---

## Live hash hunt (this run)

C0 prefixes MATCH `FINAL_CONTRACT`:

```text
extract     cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
C0 lex FILE 381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
```

KEEP / bag DUT and gold MATCH CLOSEOUT (live Get-FileHash = recorded SHA):

```text
commit DUT     86a7a0695712d9aa818bf95aac30b83289fb9af80ddd0bdc2455e935a14d8764
multi DUT      bc8b8993edbba8bc048bc03ebc6398744cf80da01d346801c3683a15881682fd
stall DUT      55f5ac0d4e9a5280d83951fb147fc85734417f7fff0ae22ed5d4422b65710862
mig wrap DUT   17741214c066de125c7306cce47d1834531b2a7c8607febe3c9d91cc06a555b2
mig_native     97c078b18015e0c6a47ca4d41b659e483f2e983d37f8bb6e579efa4d19e523b5
official prj   914a9e4bb1b3002837592944cdf49f8dfbaf4d112552dd8b5be48602ff1ac329
commit xsim    a32521e99ddf8df99d32737013fe45afd4146d07daab9e12ba0ea292566f7226
multi xsim     c185b07bb527ab9c05861081e90356b88dc94c00a0373560c4554adaf98312c7
stall xsim     c345d77ca54d6a7f38afd010b3062dbd5a16c32ac401d84964b6f95a7e023587
mig xsim       7db9647b91fd27a7708ceec6c18289b7c97aa2d6dde30b99bf4286fc42c3bc8e
commit GOLDEN  d24339078e62fc03976a45c3b7c0a14a802f2f7b4c46ae1723c43ddcc46d7963
multi GOLDEN   e452f698ff7b0b556183fe8a259f69e26803f234233e4c03b187c80e6f3fe308
stall GOLDEN   ef498f9f861de383e61940bf21fe7bc1974efbe92814075ae545c76f0d530195
mig GOLDEN     9618d7acac2af5c4369cd67cfcc56fb19e92d474c6025184c2da83684ffc9c88
```

GOLDEN.json SHA byte-identical to each bag `GOLD_HASH_PRE_XVLOG.txt`
(hashed before first xvlog; not regenerated). `FIRST_DIVERGENCE` ABSENT in
all four `xsim.log`. Markers PRESENT.

---

## Master §8 required tests vs raw CLASS HIT

| Required test | Raw HIT | Bag | Path class |
|---|---|---|---|
| cache hit | `CLASS_cache_hit` | MULTI-SLOT | XSIM (modeled AXI) |
| miss allocate | `CLASS_miss_allocate` | MULTI-SLOT | XSIM (modeled AXI) |
| multi-slot | `CLASS_multi_slot` | MULTI-SLOT | XSIM (modeled AXI) |
| full capacity | `CLASS_full_capacity` | MULTI-SLOT | XSIM (modeled AXI) |
| dirty eviction | `CLASS_dirty_eviction` | MULTI-SLOT | XSIM (modeled AXI) |
| DDR stall | `CLASS_aw_stall` / `w_stall` / `b_stall` minima 8/5/6 | DDR-STALL | XSIM (modeled ready) |
| write-back completion | `CLASS_writeback_completion` + `CLASS_writeback_after_stall` | MULTI + STALL | XSIM (modeled AXI) |
| duplicate reward | `CLASS_duplicate_reward` n_dup=1 w0 unchanged | COMMIT | XSIM |
| stale txn | SATISFIED_AS_DUP (see hunt) | COMMIT | XSIM |
| wrong generation | `CLASS_wrong_generation` n_stale=1 | COMMIT + MULTI | XSIM |
| reset before update | `CLASS_reset_before_update` | all four | XSIM |
| reset during update | `CLASS_reset_during_update` / `CLASS_reset_during_stall` | COMMIT + STALL | XSIM |
| reset after commit | `CLASS_reset_after_commit_reload` identity+w0=3 | COMMIT | XSIM |
| schema-version mismatch | `CLASS_schema_mismatch` fail_code=1 | all four | XSIM |
| high-ID subject/object | `0xC34FF` / 799998 / `0xABCDE` | COMMIT + MULTI + STALL + MIG | MIG_XSIM on MIG bag |
| alias attempt | low16 `0x034FF` miss | all four | MIG_XSIM on MIG bag |
| BRAM clear | `CLASS_bram_clear` + persist_clr in other bags | MIG | MIG_XSIM (on-chip clr, not BRAM primitive) |
| DDR reload | `CLASS_reload_from_mig` identity+w0=2 | MIG | MIG_XSIM |

False success: `CLASS_false_success_zero` HIT on all four; headlines `n_false=0`.

Canonical identity is 20-bit `{subj,rel,obj,ctx}+gen`. Journal `AWADDR` is
`0x06000000` (+ slot×16), not low16 of subject. Five phases named in COMMIT
GOLDEN and exercised (RECEIVED/ACCEPTED/COMMITTED/PERSISTED/FAILED).

---

## Overclaim / cheat / tautology hunt

**Hunt “RESULTS overclaim vs raw”:** MISS on all four bags. Each bag RESULT
remains `PASS_THIS_GATE_ONLY`. None self-stamped Master C2 close.

**stale txn vs duplicate (RTL_FACT):** persist-commit `S_DECIDE` takes DUP
when identity+generation match, **before** `F_BAD_TXN`. Same-identity same-gen
different txn is therefore **NOT_REACHABLE** as `fail_code=F_BAD_TXN`.
Replay of a committed identity is HIT as `CLASS_duplicate_reward` (w0
unchanged). This close maps Master “stale txn” to that DUP HIT. It does
**not** claim a distinct `CLASS_stale_txn` line.

**MIG posted write:** MIG `xsim.log` prints `CLASS_persist_through_mig` before
ddr3_model `WRITE` of the packed beat; later `READ` returns the same payload
and `CLASS_reload_from_mig` HIT. Do not promote B-OKAY to “DRAM row already
written at B”. Reload after on-chip clear still restored exact identity+w0.

**Not production persist IP:** four named DUTs. MIG bag instantiates
persist-commit KEEP only (single journal slot), not multi-slot / stall DUT.
Modeled-AXI capacity/stall HITs are **not** MIG PHY HITs.

**Not ASTRA-06 / prior_store:** ASTRA-06 is on-chip registers. prior_store
low16 address is not this path. Neither compiled as DUT.

**Held-out query after reload:** no parser→retrieval→rank score was measured
after persist reload. That is C3 / C7 phase 6–7, not this close.
C2 PASS “held-out behavior preserved within declared tolerance” is taken as
**exact semantic identity + exact w0** after on-chip clear + reload
(COMMIT w0=3 AXI; MIG w0=2 through `mig_sim`+ddr3_model). Declared tolerance
= exact. Query-score invariance remains **NOT_THIS_GATE**.

**PERSIST_SCHEMA_VERSION:** bag-local `8'd1` in KEEP svh. `FINAL_CONTRACT`
stays `NOT_FROZEN`. Do not freeze production schema from these bags.

**DDR_QUERY_BOUND_FINAL:** stays `NOT_FROZEN`. Persist AWADDR is not a query
R-path bound.

---

## Master §8 letter vs quality bound

**Letter HIT (XSim law):**

- Canonical 20-bit identity, not low8/low16.
- Phases RECEIVED / ACCEPTED / COMMITTED / PERSISTED / FAILED.
- `SUCCESSFUL_COMMIT <=> INTENDED_STATE_TRANSITION_COMMITTED` with
  `n_false=0` on the four bags.
- Warm persist V1: learned w0 survives explicit on-chip clear and restores
  from versioned journal (`schema=1` byte in the packed beat) through
  modeled AXI and through official Digilent AXI MIG sim + ddr3_model after
  `init_calib_complete`.
- Required test names covered as the table above (stale txn as DUP).

**Quality bound still HIT (do not promote to board / production top):**

- Capacity, dirty eviction, write-back, stall = modeled AXI slave, not MIG.
- MIG reload = single-slot persist-commit KEEP, not CAP_N=2.
- Stall = TB `*ready` backpressure, not MIG calibration stall.
- `persist_clr` is on-chip journal valid-clear, not a BRAM primitive wipe.
- Four isolated DUTs, not one C5 production hierarchy persist block.
- Schema `8'd1` is bag law, not frozen `PERSIST_SCHEMA_VERSION`.
- Not BOARD. Not QSPI/power-loss (V1 does not require it).

---

## Verdict

```text
FINAL                  = ACCEPT C2 XSim law close
C2_XSIM_LAW            = ACCEPT
C2_PERSIST_CLOSED_XSIM = YES
PROMOTION              = REJECT
BOARD_PASS             = REJECT
ACCEPT_BOARD           = REJECT
PERSIST_SCHEMA_VERSION = NOT_FROZEN
DDR_QUERY_BOUND_FINAL  = NOT_FROZEN
HELD_OUT_QUERY_AFTER_RELOAD = NOT_THIS_GATE
C3_MAY_START           = YES
C3_HELD_OUT            = NOT_STARTED
PROGRAM                = NO
```

Owner asked to close Master C2. This ACCEPT is
**PRODUCTION-TRANSACTION-PERSISTENCE as XSim**, with warm persist through
official MIG sim + ddr3_model. It is **not** `ASTRA_NATIVE_AI_BOARD_PASS`.

---

## Machine lines (close-gate)

```text
C2_XSIM_LAW=ACCEPT
C2_PERSIST_CLOSED_XSIM=YES
BOARD_PASS=REJECT
ACCEPT_BOARD=REJECT
PERSIST_SCHEMA_VERSION=NOT_FROZEN
DDR_QUERY_BOUND_FINAL=NOT_FROZEN
C3_MAY_START=YES
```
