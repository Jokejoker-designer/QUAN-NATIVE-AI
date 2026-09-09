# RESULTS — ASTRA-F3-R3-SAMPLED-WORLDS-01

```text
GATE            = ASTRA-F3-R3-SAMPLED-WORLDS-01
XSIM            = ASTRA_F3R3_SAMPLED_WORLDS_XSIM_PASS
RESULT          = PASS_NARROW
MASTER_F3       = OPEN (10pp/CI/retention not claimed; n=8 compact TB-AXI, not ASTRA-07 24×8)
FAIL_COUNT      = 0
FIRST_DIV       = NONE
SIM_TIME_NS     = 278245
PID             = 27400
SESSION         = Sun Sep 6 15:22:22–15:22:24 2026
LAW             = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen)
DUT             = a7ng_astra_f3r3_sampled_worlds
SGD             = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
PROGRAM         = NO
BIT             = NOT_BUILT
COM12 / JTAG    = UNTOUCHED
```

SHA freeze **before xvlog** `2026-09-06T15:22:16.3866102+07:00`.
POST `2026-09-06T15:22:24.3788427+07:00`. Compiled + `.svh` **14/14 MATCH**.
`.svh` in PRE: `a7ng_astra_f3r3_sampled_worlds.svh`, `tb_oracles.svh`.
PREREG / ACK / `metrics_prereg.json` / `expected_vectors.json` hashed before xvlog.
`master_f3_claimed: false` frozen before xvlog.

ISO isolated SGD: `ISO_P3 w0=5 viso=0` → `PASS ISO_P3_X50_DW5`.

First run PASS. No golden edits. No fail-r0.

## Generator (raw log)

```text
GEN seed=a5f33001 N_WORLDS=5 N_SHARED=3 N_PRIVATE=2 N_TRAIN=8 N_HOLD=8 N_EPOCH=2
```

Five distinct subject-relation worlds (all `ctx=indirect` 2-hop), not hop/ctx tweaks of one query:

| W | Train/hold queries | Query |
|---|--------------------|-------|
| 0 | TR 0,5 / HO 2 | `pump requires indirect` |
| 1 | TR 1,6 / HO 3,7 | `valve requires indirect` |
| 2 | TR 2,7 / HO 4 | `chiller requires indirect` |
| 3 | TR 3 / HO 1,6 | `ahu connects indirect` |
| 4 | TR 4 / HO 0,5 | `tower requires indirect` |

Paired `TR_W[i] != HO_W[i]`. Shared dest `0x40` on all train gold and hold q6/q7. Hold q0–q5 dests `112–117` disjoint.

## Per-query hold picks (raw dumps)

| q | Hold world | FR p0 (dist) | EN e1 p0 (gold) | SH p0 (dist, mixed_ctx) |
|---|------------|-------------:|----------------:|------------------------:|
| 0 | tower | 256 ans=144 v=0 | 258 ans=112 v=190 | 386 ans=144 v=190 |
| 1 | ahu | 260 ans=145 | 262 ans=113 v=190 | 390 |
| 2 | pump | 264 ans=146 | 266 ans=114 v=190 | 394 |
| 3 | valve | 268 ans=147 | 270 ans=115 v=190 | 398 |
| 4 | chiller | 272 ans=148 | 274 ans=116 v=190 | 402 |
| 5 | tower | 276 ans=149 | 278 ans=117 v=190 | 406 |
| 6 | ahu overlap dest=64 | 280 ans=150 | 282 ans=64 v=190 | 410 |
| 7 | valve overlap dest=64 | 284 ans=151 | 286 ans=64 v=190 | 414 |

All `tbl=0`. `npath=2`. Shuffle train selected **dist with mixed_ctx** (q0 p0=128 φ HASH=`42d33000`) then +3 on that action. Shuffle hold gold lacks mixed_ctx and has **min p0**; trained mixed_ctx still picks dist (`SH_HO_Q*_DIST`).

`PHI_NEQ` 8/8 on the log (not TB-internal only):

```text
EN_TR_Q0_PHI32 50 64 64 0 0 0 64 64 64 0 50 50 64 0 0 64 ... HASH=42d33000
EN_HO_E1_Q0_PHI32 50 64 64 0 64 64 64 64 64 0 50 50 64 0 0 64 ... HASH=42d33003
PHI_NEQ_Q0 train_hash=42d33000 hold_hash=42d33003 neq=1
```

Train gold mixed_ctx cx=1/0 (`phi[4]=0` ctx_nz, `phi[5]=0` obj_ctx). Hold gold mixed_ctx cx=3/1 (`phi[4]=64`, `phi[5]=64`). Shared transferable `phi[12]=64` mixed_ctx.

Dest-keyed pid: disjoint q0–q5 `pg=0 pd=0 pick_gold=0`; overlap q6/q7 `pg=24 pd=0 pick_gold=1` dest=64.

Epoch-2 and reload hold still gold (`en_e2=8/8 en_rl=8/8`). Reload restored `w0=59` matching e2, `nupd=0`.

UNREL `payroll tax form`: `st=1 npath=0 ans=0 p0=0 tbl=0 w0=0`. `ISO_DUT_W0_CLEARED_LAST` is `wdut[0]===0`.

```text
METRICS en_e1=8/8 en_e2=8/8 en_rl=8/8 fr=0/8 sh=0/8 pid_ov=2/2 pid_dj=0/6 phi_neq=8/8 n_rank=64 n_ans=64
ASTRA_F3R3_SAMPLED_WORLDS_XSIM_PASS
$finish ... 278245 ns
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
| hold gold after epoch-2 | 8/8 |
| hold gold after w reload | 8/8 |
| retention drop (e1 − reload) | 0 |

No Wilson / paired CI printed. n=8 compact TB-AXI hold queries are not Master confirmation. ASTRA-07 24×8 was not run.

## Not claimed

Master F3 closed. LM06. BOARD. ASTRA-13. Persistence/DDR. Power-loss journal.
ASTRA-07 scale. Open-domain learning.

## Frozen bags

F3R2 `xsim.log` session still `Sun Sep 6 14:51:59 2026` PID **47144**.
F3 plumbing `xsim.log` session still `Sun Sep 6 14:19:48 2026` PID **28280**.
Frozen SGD hash `b66ef328…`. F3R2 DUT `16519bf0…` / F3 DUT `c3183e7a…` / F2R5 `41c77e76…` / F2R4 `5cdb3da8…` / F2R3 `9a7a5941…` / F2R2 `5e2f23c3…` unpatched.
This snapshot compiled `a7ng_astra_f3r3_sampled_worlds` + frozen SGD; not F2R/F3/F3R2 integrators.
