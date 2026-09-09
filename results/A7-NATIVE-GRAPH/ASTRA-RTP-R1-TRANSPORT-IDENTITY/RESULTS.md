# RESULTS — RTP-R1

```text
GATE     = ASTRA-RTP-R1-TRANSPORT-IDENTITY
XSIM     = ASTRA_RTP_R1_XSIM_PASS
KEEP_RTP0= PASS_NARROW (original bag unchanged)
ASTRA09  = hash 48c9e480… UNCHANGED
SHA      = SHA256.txt frozen before xvlog; still match after run
PROGRAM  = NO
```

| Case | Result |
|------|--------|
| BASE | ANSWER 4 proof 17,34 nfar=2 nok=2 |
| POST_DROP_BC | UNKNOWN, desc 34 still in RAM |
| DESC_SWAP | ANSWER 7 |
| UNREL | UNKNOWN nc=nl=nfar=0 |
| AXI_BAD_RID | INCOMPLETE nerr=2 not ANSWER 4 |
| AXI_SLVERR | INCOMPLETE nerr=2 |
| AXI_NOLAST | INCOMPLETE nerr=2 |
| AXI_TIMEOUT | INCOMPLETE nto=2 |
| OVF | INCOMPLETE ovf=1 |
| NEG | status 8 NEGATED ans=0 nfar=0 |
| AMB | status 7 AMBIGUOUS ans=0 nfar=0 |

Schema rtp-desc-v1, ID_W=20, eid must match cand_id. Original `a7ng_astra_rtp_pipe.sv` not edited.
