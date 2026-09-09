# RESULTS — ASTRA-F3-R4-DISTINCT-HOLD-PHI-01

```text
GATE            = ASTRA-F3-R4-DISTINCT-HOLD-PHI-01
XSIM            = ASTRA_F3R4_DISTINCT_HOLD_PHI_XSIM_PASS
RESULT          = PASS_NARROW
MASTER_F3       = OPEN (10pp/CI/retention not claimed; n=8 compact TB-AXI, not ASTRA-07 24×8)
FAIL_COUNT      = 0
FIRST_DIV       = NONE
SIM_TIME_NS     = 328365
PID             = 20428
SESSION         = Sun Sep 6 15:48:29–15:48:31 2026
LAW             = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen)
DUT             = a7ng_astra_f3r4_distinct_hold_phi
SGD             = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
PROGRAM         = NO
BIT             = NOT_BUILT
COM12 / JTAG    = UNTOUCHED
```

SHA freeze **before xvlog** `2026-09-06T15:48:23.4426738+07:00`.
POST `2026-09-06T15:48:31.3979716+07:00`. Compiled + `.svh` **14/14 MATCH**.
`.svh` in PRE: `a7ng_astra_f3r4_distinct_hold_phi.svh`, `tb_oracles.svh`.
PREREG / ACK / `metrics_prereg.json` / `expected_vectors.json` hashed before xvlog.
`master_f3_claimed: false` frozen before xvlog.

ISO isolated SGD: `ISO_P3 w0=5 viso=0` → `PASS ISO_P3_X50_DW5`.

First run PASS. No golden edits. No fail-r0.

## Generator (raw log)

```text
GEN seed=a5f34001 N_WORLDS=5 N_SHARED_2HOP=1 N_PRIVATE_2HOP=1 N_TRAIN=8 N_HOLD=8 N_EPOCH=2 NPATH_RANK=4 MAX_PATH=4
```

Five distinct subject-relation worlds (all `ctx=indirect` 2-hop). Train HASH is unique per world. Hold HASH is unique per query (conf/ctx in φ, not dest remaps).

| W | Train HASH | Query |
|---|------------|-------|
| 0 | `42d34000` | `pump requires indirect` |
| 1 | `c2e34000` | `valve requires indirect` |
| 2 | `42734003` | `chiller requires indirect` |
| 3 | `c2434003` | `ahu connects indirect` |
| 4 | `42134002` | `tower requires indirect` |

Paired `TR_W[i] != HO_W[i]`. Shared dest `0x40` on all train gold and hold q6/q7. Hold q0–q5 dests `112–117` disjoint.

## Distinct hold HASH (raw `EN_HO_E1_*_PHI32`)

```text
HOLD_HASH_SET c2234001 43334006 c3034006 43534007 c3634007 43f34007 c3c34007 43934005
PASS UNIQUE_HOLD_HASH_8
```

Eight pairwise-distinct values. Not `HASH=42d33003` × 8.

## npath (shared+private legal hops)

Ranking dumps `npath=4` (gold + dist + shared complete 2-hop dest `0x60` + private complete 2-hop). `npath4=64/64`. Not stuck at 2.

```text
INCOMP5 st=6 npath=4 ans=0 p0=0 ... tbl=0 obj=0 ctx=2
PASS INCOMP_FIFTH
```

Fifth legal 2-hop → `ST_INCOMP` at cap 4.

## Per-query hold picks (raw dumps)

| q | Hold world | FR p0 (dist) | EN e1 p0 (gold) | SH p0 (dist, mixed_ctx) | hold HASH |
|---|------------|-------------:|----------------:|------------------------:|-----------|
| 0 | tower | 256 ans=144 | 258 ans=112 v=196 | 386 ans=144 | `c2234001` |
| 1 | ahu | 260 ans=145 | 262 ans=113 | 390 | `43334006` |
| 2 | pump | 264 ans=146 | 266 ans=114 | 394 | `c3034006` |
| 3 | valve | 268 ans=147 | 270 ans=115 | 398 | `43534007` |
| 4 | chiller | 272 ans=148 | 274 ans=116 | 402 | `c3634007` |
| 5 | tower | 276 ans=149 | 278 ans=117 | 406 | `43f34007` |
| 6 | ahu overlap dest=64 | 280 ans=150 | 282 ans=64 | 410 | `c3c34007` |
| 7 | valve overlap dest=64 | 284 ans=151 | 286 ans=64 | 414 | `43934005` |

All `tbl=0`. `npath=4`. Shuffle train selected **dist with mixed_ctx** then +3 on that action. Shuffle hold gold lacks mixed_ctx and has min p0; trained mixed_ctx still picks dist (`SH_HO_Q*_DIST`).

`PHI_NEQ` 8/8 on the log:

```text
EN_TR_Q0_PHI32 50 64 64 0 0 0 64 64 64 0 50 50 64 0 0 64 ... HASH=42d34000
EN_HO_E1_Q0_PHI32 55 64 64 0 64 64 64 64 64 0 55 55 64 0 0 64 ... HASH=c2234001
PHI_NEQ_Q0 train_hash=42d34000 hold_hash=c2234001 neq=1
```

Dest-keyed pid: disjoint q0–q5 `pg=0 pd=0 pick_gold=0`; overlap q6/q7 `pg=24 pd=0 pick_gold=1` dest=64.

Epoch-2 and reload hold still gold (`en_e2=8/8 en_rl=8/8`). Reload restored `w0=60` matching e2, `nupd=0`.

UNREL `payroll tax form`: `st=1 npath=0 ans=0 p0=0 tbl=0 w0=0`. `ISO_DUT_W0_CLEARED_LAST` is `wdut[0]===0`.

```text
METRICS en_e1=8/8 en_e2=8/8 en_rl=8/8 fr=0/8 sh=0/8 pid_ov=2/2 pid_dj=0/6 phi_neq=8/8 npath4=64/64 uniq_ho=1 uniq_trw=1 incomp=1 n_rank=64 n_ans=64
ASTRA_F3R4_DISTINCT_HOLD_PHI_XSIM_PASS
$finish ... 328365 ns
```

## Reported separately (plumbing)

| Metric | Value |
|--------|------:|
| selective accuracy enabled hold e1 | 8/8 |
| selective accuracy no-update hold | 0/8 |
| selective accuracy shuffled hold | 0/8 |
| coverage (rank queries ANSWER) | 64/64 |
| UNREL UNKNOWN | 1 |
| per-ID overlap dest pick gold | 2/2 |
| per-ID disjoint dest pick gold | 0/6 |
| train-gold φ ≠ hold-gold φ | 8/8 |
| unique hold HASH | 8/8 |
| unique train-world HASH | 5/5 |
| ranking npath==4 | 64/64 |
| fifth-path INCOMP | 1 |
| hold gold after epoch-2 | 8/8 |
| hold gold after w reload | 8/8 |
| retention drop (e1 − reload) | 0 |

No Wilson / paired CI printed. n=8 compact TB-AXI hold queries are not Master confirmation. ASTRA-07 24×8 was not run.

## Not claimed

Master F3 closed. LM06. BOARD. ASTRA-13. Persistence/DDR. Power-loss journal.
ASTRA-07 scale. Open-domain learning.

## Frozen bags

F3R3 `xsim.log` session still `Sun Sep 6 15:22:22 2026` PID **27400**.
F3R2 / F3 plumbing / F2R bags not rerun.
Frozen SGD hash `b66ef328…`. F3R3 DUT `beaa4bc1…` / F3R2 `16519bf0…` / F3 `c3183e7a…` unpatched.
This snapshot compiled `a7ng_astra_f3r4_distinct_hold_phi` + frozen SGD; not F2R/F3/F3R2/F3R3 integrators.
