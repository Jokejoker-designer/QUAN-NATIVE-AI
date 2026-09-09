# CLOSEOUT — ASTRA-C2-PERSIST-DDR-STALL-01

```text
XSIM                 = ASTRA_C2_PERSIST_DDR_STALL_XSIM_PASS PRESENT
RESULT               = PASS_THIS_GATE_ONLY
PROGRAM              = NO
BOARD_PASS           = NOT_CLAIMED
MIG                  = NO
DDR_QUERY_BOUND_FINAL= NOT_FROZEN
PERSIST_SCHEMA_VERSION = NOT_FROZEN
C2_MASTER            = OPEN
STALL                = AW=8 W=5 B=6 AR=4 R=3
SIM_NS               = 1405
xsim SHA256          = c345d77ca54d6a7f38afd010b3062dbd5a16c32ac401d84964b6f95a7e023587
DUT SHA256           = 55f5ac0d4e9a5280d83951fb147fc85734417f7fff0ae22ed5d4422b65710862
GOLDEN SHA256        = ef498f9f861de383e61940bf21fe7bc1974efbe92814075ae545c76f0d530195
AWADDR               = 0x06000000 + axi_idx*16 (not low16 of subject)
HEADLINE             = n_upd=4 n_hit=1 n_wb=1 n_aw_stall=28 n_w_stall=15 n_b_stall=18 n_schema=1 n_false=0
FAIL_R0              = none (XSim PASS on first run)
```

Not compiled as DUT: leftover A09, C0 sparse FILE, STREAM-02, ASTRA-06, prior_store,
persist-commit KEEP, multi-slot KEEP.
C0 + KEEP hash gate MATCH. Gold hashed before first xvlog.
Journal/cache updates only on AXI B OKAY. Not MIG.
