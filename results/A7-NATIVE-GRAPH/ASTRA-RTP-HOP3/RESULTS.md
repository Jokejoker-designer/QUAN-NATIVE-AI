# RESULTS — 3-hop (HANDOFF §6)

```text
XSIM=ASTRA_RTP_HOP3_XSIM_PASS
PROGRAM=NO
TB_LOAD=0
```

| Case | Result |
|------|--------|
| BASE 10-1-4-7 eids 17,34,51 | ANSWER 7 proof 17,34,51 |
| DROP_LAST posting drops 51, desc remains | UNKNOWN not keep 7 |
| TWO_ONLY 2-edge chain | UNKNOWN (does not report 2-hop ans=4 as 3-hop) |
| UNREL | UNKNOWN nfar=0 |

R1/R2 pipes not retargeted. SHA256.txt frozen before xvlog.
