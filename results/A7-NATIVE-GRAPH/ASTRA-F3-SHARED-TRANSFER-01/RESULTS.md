# RESULTS — ASTRA-F3-SHARED-TRANSFER-01

```text
GATE            = ASTRA-F3-SHARED-TRANSFER-01
XSIM            = ASTRA_F3_SHARED_TRANSFER_XSIM_PASS
RESULT          = PASS_NARROW
MASTER_F3       = OPEN (10pp/CI/retention not claimed)
FAIL_COUNT      = 0
FIRST_DIV       = NONE
SIM_TIME_NS     = 103615
PID             = 28280
SESSION         = Sun Sep 6 14:19:48–14:19:50 2026
LAW             = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen)
DUT             = a7ng_astra_f3_shared_xfer
SGD             = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
PROGRAM         = NO
BIT             = NOT_BUILT
COM12 / JTAG    = UNTOUCHED
```

SHA freeze **before xvlog** `2026-09-06T14:19:42.0688048+07:00`.
POST `2026-09-06T14:19:50.4532859+07:00`. Compiled + `.svh` **14/14 MATCH**.
`.svh` in PRE: `a7ng_astra_f3_shared_xfer.svh`, `tb_oracles.svh`.

ISO isolated SGD: `ISO_P3 w0=5 viso=0` → `PASS ISO_P3_X50_DW5`.

## Per-seed hold picks (raw dumps)

| Seed | Structure | FR p0 (expect dist) | EN p0 (expect gold) | SH p0 (not gold) |
|------|-----------|---------------------|---------------------|------------------|
| S0 quality 2-hop dest=4 | 273=0x111 dist | 529=0x211 gold v=27 | 273 dist v=-18 |
| S1 ctx-match 2-hop | 785=0x311 dist | 1041=0x411 gold v=38 | 785 dist v=-33 |
| S2 object-bound compressor | 1297=0x511 dist | 1553=0x611 gold v=30 | 1297 dist v=-24 |
| S3 dest=11 + dead-end | 1809=0x711 dist | 2065=0x811 gold v=27 | 1809 dist v=-18 |
| S4 1-hop water ctx | 3072=0xC00 dist | 3088=0xC10 gold v=29 | 3072 dist v=-18 |

All `tbl=0`. S2 `obj=4 ctx=2`. S4 `ctx=1` 1-hop `p1=0`. Train gold selected before +3 on every enabled/shuffled arm. `nupd=1` after each FPGA update. Train re-query still gold (`ret=5/5`).

UNREL `payroll tax form`: `st=1 npath=0 ans=0 p0=0 tbl=0`.

```text
METRICS en_hold=5/5 fr_hold=0/5 sh_hold=0/5 pid_hold=0/4 ret=5/5 n_rank=30 n_ans=30
ASTRA_F3_SHARED_TRANSFER_XSIM_PASS
$finish ... 103615 ns
```

## Reported separately (plumbing)

| Metric | Value |
|--------|------:|
| selective accuracy enabled hold | 5/5 |
| selective accuracy no-update hold | 0/5 |
| selective accuracy shuffled hold | 0/5 |
| coverage (rank queries ANSWER) | 30/30 |
| UNREL UNKNOWN | 1 |
| per-ID hold (S0/S1/S3/S4) | 0/4 |
| retention smoke still gold | 5/5 |

Descriptive ( **not** Master F3 ): gain vs no-update 100pp; vs shuffle 100pp; paired (en-fr) all +1, SEM=0, CI lo=1; retention drop 0pp. PREREG forbade claiming Master 10pp/CI on these 5 designed plants / one-update XSim TB-AXI protocol.

## Not claimed

Master F3 closed. LM06. BOARD. ASTRA-13. Persistence/DDR. Power-loss journal.
ID-permutation transfer. Open-domain learning.

## Frozen bags

F2R5 `xsim.log` session still `Sun Sep 6 13:53:26 2026`. F2R4 `13:24:12`. F2R3 `12:57:56`. F2R2 `12:15:23`. Frozen SGD hash `b66ef328…`. F2R5 DUT `41c77e76…` / F2R4 `5cdb3da8…` / F2R3 `9a7a5941…` / F2R2 `5e2f23c3…` unpatched.
