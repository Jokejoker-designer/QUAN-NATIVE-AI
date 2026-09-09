# CLOSEOUT — ASTRA-C1-N256-R3-DISTRACTOR-01

```text
RESULT               = FAIL
TASK                 = ASTRA-C1-N256-R3-DISTRACTOR-01
XSIM                 = ASTRA_C1_N256_R3_XSIM_PASS NOT emitted
                       ASTRA_C1_N256_R3_XSIM_NO_MARKER fail=1 dist_no_leak=0
FAIL_R0              = xsim_fail_r0.log (DISTRACTOR_LEAK; walker twin locked)
FAIL_COUNT_FINAL     = 1
LEAK_N               = 10
DISTRACTOR_GOLD_N    = 11 (EXCLUDED; query "pump supplies chiller")
DISTRACTOR_TP        = 0
DISTRACTOR_REC       = undef (not 1000)
N                    = 256
CAND_CAP             = 16
LAW_SEL              = 1
POKE_V               = 0
LEFTOVER_A09         = not compiled
PROGRAM              = NO
C1_800K              = OPEN
N_4096               = NOT STARTED
CAND_CAP_FINAL       = NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
REDUCTION_X1000      = NOT_EMITTED
UNRELATED            = UNRELATED_EMPTY_WALK (not 0/0 as 1000/1000)
WRONG_CONTEXT        = NOT_SELECTIVE (k0–k3 match direct; emit_match=1)
GOLD_AFTER_FAIL      = NO (gold hashed 09:24:14; xvlog 09:24:37; live MATCH PRE)
PRIOR_BAG_C1         = ASTRA-C1-N256-ROLE-RETRIEVAL-01 NOT edited
PRIOR_BAG_R2         = ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01 NOT edited
QUALITY_NOTE         = polarity is excluded (P1 scoring); frozen law leaked
                       10/11 overlapping EV1 nids; direct prec_ev1=187 unpatched
```

Authority: `xsim.log`, `xsim_fail_r0.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
Does not close C1 800k. Does not start N=4096. Never ACCEPT_BOARD.
Do not regenerate gold. Do not patch C0 RTL.
