# LADDER_PREREG — program-step silicon tests

Owner: run the **necessary UART ladder at PROGRAM**, same SHA-pinned bit.
SW0 already ON. Do not open DDR/LM. Do not claim BOARD_PASS.

```text
BIT_SHA256     = e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
JTAG           = 210319BE776EA
COM12          = 115200 8N1
SW0            = ON (PLANT_SMOKE)  — owner set
REPROGRAM      = YES (clean POR so first query txn is the XSim-known first txn)
```

## Steps (one session after program)

| # | Send | Expect |
|---|---|---|
| 1 | `"pump requires indirect\n"` | A2 ans=4 p0=17 p1=34 npath=2 acc=1 |
| 2 | `A6 FD 01 01 07 00 0A` rew=-3 txn=1 gen=1 ep=7 | A2 OBS tag 57 w0=-5 phi0=50 nupd=1 |
| 3 | `A7 0A` retire | (no required TX) |
| 4 | `"payroll tax form\n"` | A2 st=UNKNOWN ans=0 p0=0 npath=0 |

Txn/gen/epoch = **XSim first-smoke after POR** (R7 TB `dut.txn_id/gen/epoch` with live_epoch=7). Not on the answer frame. If silicon assigns a different first txn, record STALE — do not retune RTL.

OVF (SW1) is **not** this ladder (physical switch change = extra setup).
