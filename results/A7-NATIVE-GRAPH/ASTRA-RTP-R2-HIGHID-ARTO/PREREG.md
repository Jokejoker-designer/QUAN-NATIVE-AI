# PREREG — RTP-R2 (keep R1 PASS_NARROW)

```text
PROGRAM=NO
KEEP_R1=PASS_NARROW
```

R1 pipe frozen. This revision:

| Case | Setup | Expect |
|------|--------|--------|
| HIGH_ID | nids 20'hA0011, 20'hA0022 (not 8-bit) | ANSWER 4 proof those eids |
| EID_MISMATCH | posting {0xA0011}; desc at that addr has eid=0x00EE | not load; UNKNOWN; nferr>=1 |
| AR_STALL | fact ARREADY never | INCOMPLETE n_ar_to>=1 |
| LATE_R | fact RVALID after 20 cycles (<64) | ANSWER 4 (late but good beat) |

Also replay BASE 17/34 to prove r2 still does R1 causality.
