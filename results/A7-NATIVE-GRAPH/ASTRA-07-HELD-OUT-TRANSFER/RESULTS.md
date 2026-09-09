# RESULTS — ASTRA-07 HELD-OUT-TRANSFER

```text
GATE            = ASTRA-07-HELD-OUT-TRANSFER
LAW             = native-rank-sgd-q8-v1
HOST            = GOLDEN.json result_host=PASS
XSIM            = ASTRA07_XSIM_PASS
RESULT          = PASS
SEEDS           = 0xA701,0xA702,0xA703,0xA704,0xA705
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
```

ASTRA-06 unit twin (constant x[i]=64) is a self-check only, not this gate's test:
frozen=0 enabled=688 shuffle=48 match=True.

W_train IDs `0x0100..0x2FFF`, W_hold IDs `0x4000..0x6FFF`, intersection empty.
Shared phi forbids query/answer/raw nid. Per-ID prior is a separate table.

| Seed | en hold | fr hold | sh hold | per-ID hold | en train | per-ID train | paired vs fr | paired vs sh | drop_pp | miss ANSWER |
|------|--------:|--------:|--------:|------------:|---------:|-------------:|-------------:|-------------:|--------:|------------:|
| 0xA701 | 24/24 | 0/24 | 0/24 | 0/24 | 24/24 | 24/24 | +24 | +24 | 0.00 | 0 |
| 0xA702 | 24/24 | 2/24 | 0/24 | 2/24 | 24/24 | 24/24 | +22 | +24 | 0.00 | 0 |
| 0xA703 | 24/24 | 5/24 | 0/24 | 5/24 | 24/24 | 24/24 | +19 | +24 | 0.00 | 0 |
| 0xA704 | 24/24 | 6/24 | 0/24 | 6/24 | 24/24 | 24/24 | +18 | +24 | 0.00 | 0 |
| 0xA705 | 24/24 | 6/24 | 0/24 | 6/24 | 24/24 | 24/24 | +18 | +24 | 0.00 | 0 |

Mean held-out gain vs frozen: **84.17 pp** (paired CI lo=17.848).
Mean held-out gain vs shuffle: **100.00 pp** (paired CI lo=24.000).
Per-ID hold mean 15.83 pp, identical to frozen (identity table memorizes W_train 24/24 and does not transfer; IDs disjoint).

## Narrow claim

On this frozen two-world generator, shared 32-feature SGD trained on W_train selects the held-out gold 2-hop path more often than zero-weight and shuffled-reward controls. Per-ID identity memory fits W_train and does not transfer. A missing hop-2 edge is not promoted to ANSWER.

## Not claimed

Open-world / open-domain learning, feature discovery, DDR 800k, LM, Gate14, board.
Weight change alone is not generalized learning; this is held-out classification on a preregistered feature family.

## XSim (seed 0xA701 compact fixture)

bit-exact hold v_q8: PASS
correct EN/FR/SH: {'FR': {'n': 24, 'c': 0}, 'EN': {'n': 24, 'c': 24}, 'SH': {'n': 24, 'c': 0}}
miss: {'ngold': 0, 'n_ans': 0, 'n_c': 7}
