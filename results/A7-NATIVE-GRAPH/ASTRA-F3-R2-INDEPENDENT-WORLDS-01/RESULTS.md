# RESULTS — ASTRA-F3-R2-INDEPENDENT-WORLDS-01

```text
GATE            = ASTRA-F3-R2-INDEPENDENT-WORLDS-01
XSIM            = ASTRA_F3R2_INDEPENDENT_WORLDS_XSIM_PASS
RESULT          = PASS_NARROW
MASTER_F3       = OPEN (10pp/CI/retention not claimed)
FAIL_COUNT      = 0
FIRST_DIV       = NONE
SIM_TIME_NS     = 148845
PID             = 47144
SESSION         = Sun Sep 6 14:51:59–14:52:01 2026
LAW             = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen)
DUT             = a7ng_astra_f3r2_ind_worlds
SGD             = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
PROGRAM         = NO
BIT             = NOT_BUILT
COM12 / JTAG    = UNTOUCHED
```

SHA freeze **before xvlog** `2026-09-06T14:51:53.2206373+07:00`.
POST `2026-09-06T14:52:01.7377123+07:00`. Compiled + `.svh` **14/14 MATCH**.
`.svh` in PRE: `a7ng_astra_f3r2_ind_worlds.svh`, `tb_oracles.svh`.

ISO isolated SGD: `ISO_P3 w0=5 viso=0` → `PASS ISO_P3_X50_DW5`.

First run PASS. No golden edits. No fail-r0.

## Per-seed hold picks (raw dumps)

| Seed | Structure | FR p0 (dist) | EN e1 p0 (gold) | SH p0 (not gold) |
|------|-----------|-------------:|----------------:|-----------------:|
| S0 quality hop 2→1 `pump requires` water | 273=0x111 v=0 | 529=0x211 v=26 | 273 v=15 |
| S1 ctx-match valve-supplies → chiller-requires | 785=0x311 | 1041=0x411 v=26 | 785 v=15 |
| S2 hop2-ctx pump/compressor → valve/evaporator | 1297=0x511 obj=3 | 1553=0x611 v=30 obj=3 | 1297 v=24 |
| S3 mixed-ctx ahu-connects → tower-requires + dead-ends | 1809=0x711 | 2065=0x811 v=27 | 1809 v=27 |
| S4 ctx_nz compressor-supplies → sensor-requires | 3072=0xC00 | 3088=0xC10 v=21 | 3072 v=15 |

All `tbl=0`. Shuffle train selected **dist** (S0 p0=16, S1 p0=39, S2 p0=48, S3 p0=58, S4 p0=68) then +3 on that action. `PHI_NEQ` on all 5 (hold gold φ ≠ train gold φ). Dest-keyed pid `pg=0 pd=0 pick_gold=0` on all 5.

Epoch-2 and reload hold still gold (`en_e2=5/5 en_rl=5/5`). Reload restored `w0` matching e2 (S0 w0=9, S1–S4 w0=10).

UNREL `payroll tax form`: `st=1 npath=0 ans=0 p0=0 tbl=0 w0=0`. `ISO_DUT_W0_CLEARED_LAST` is `wdut[0]===0`.

```text
METRICS en_e1=5/5 en_e2=5/5 en_rl=5/5 fr=0/5 sh=0/5 pid=0/5 phi_neq=5/5 n_rank=40 n_ans=40
ASTRA_F3R2_INDEPENDENT_WORLDS_XSIM_PASS
$finish ... 148845 ns
```

## Reported separately (plumbing)

| Metric | Value |
|--------|------:|
| selective accuracy enabled hold e1 | 5/5 |
| selective accuracy no-update hold | 0/5 |
| selective accuracy shuffled hold | 0/5 |
| coverage (rank queries ANSWER) | 40/40 |
| UNREL UNKNOWN | 1 |
| per-ID dest-keyed hold gold pick | 0/5 |
| train-gold φ ≠ hold-gold φ | 5/5 |
| hold gold after epoch-2 | 5/5 |
| hold gold after w reload | 5/5 |
| retention drop (e1 − reload) | 0 |

No Wilson / paired CI printed. n=5 designed plants are not Master confirmation.

## Not claimed

Master F3 closed. LM06. BOARD. ASTRA-13. Persistence/DDR. Power-loss journal.
Identical-φ ID-permutation transfer. Open-domain learning.

## Frozen bags

F3 plumbing `xsim.log` session still `Sun Sep 6 14:19:48 2026` PID **28280**.
F2R5 `xsim.log` still `Sun Sep 6 13:53:26 2026` PID **5776**.
Frozen SGD hash `b66ef328…`. F3 DUT `c3183e7a…` / F2R5 `41c77e76…` / F2R4 `5cdb3da8…` / F2R3 `9a7a5941…` / F2R2 `5e2f23c3…` unpatched.
This snapshot compiled `a7ng_astra_f3r2_ind_worlds` + frozen SGD; not F2R/F3 integrators.
