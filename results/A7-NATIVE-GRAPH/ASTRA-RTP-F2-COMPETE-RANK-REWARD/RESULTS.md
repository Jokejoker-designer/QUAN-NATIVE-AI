# RESULTS — F2/F3 (partial)

```text
XSIM     = ASTRA_RTP_F2_XSIM_FAIL (reward-switch)
N_PATH   = 2 both legal (chiller 17,34 and valve 18,35)
R0       = tie-break lower proof0 → chiller PASS
R1       = still chiller after scalar -3; SGD do_upd=1 but w[0] stayed 0
CONTROL  = CHEAT (TB set ctrl0=ctrl1=17; not a real validity-only world). STRIPPED.
PROGRAM  = NO
```

Closed: two admissible proofs on FPGA; rank-before-select (score then pick); TB_LOAD=0.
Not closed: scalar reward changing the next selection (F2 remainder). Do not treat as F2 PASS.

Original RTP-0 and RTP-R1 bags kept. F4/F5 open.
