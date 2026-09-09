# PREREG — ASTRA-C5-AUTO-REWARD-REGRESS-01

PROGRAM=NO. Instantiates **unedited** `a7ng_astra_c5_prod_top` (hash c4fcca30…).
Does not patch the DUT. One unknown: does ANSWER pulse `c3_rew_v` with
hardwired +3 and persist `w0=3` with **no** UART reward frame?

HIT this bag if after query `"pump requires indirect"` and no 0x16/reward
bytes: `c3_pend_cmt_o=1` and `persist_w0_o==3`. Optional: second query
`persist_w0_o==6`.

This bag PASSES when auto-reward is **observed**. It does not fix the top.
Does not stamp C5_MASTER. Modeled AXI, not MIG.
