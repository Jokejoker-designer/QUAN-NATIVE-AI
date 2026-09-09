# RESULTS — RTP-R2

```text
XSIM=ASTRA_RTP_R2_XSIM_PASS
KEEP_R1=PASS_NARROW
PROGRAM=NO
```

| Case | Result |
|------|--------|
| BASE 17/34 | ANSWER 4 |
| HIGH_ID 0xA0011/0xA0022 | ANSWER 4 proof those eids |
| EID_MISMATCH eid 0xEE vs cand | INCOMPLETE nferr=1 not ANSWER 4 |
| AR_STALL | INCOMPLETE narto=2 |
| LATE_R (20 cycles) | ANSWER 4 |

R1 pipe file not edited. SHA256.txt frozen before xvlog.
