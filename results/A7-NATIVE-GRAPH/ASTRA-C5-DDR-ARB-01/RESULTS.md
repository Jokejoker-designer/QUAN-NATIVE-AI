# RESULTS — ASTRA-C5-DDR-ARB-01

```text
GATE            = ASTRA-C5-DDR-ARB-01
XSIM            = ASTRA_C5_DDR_ARB_XSIM_PASS
RESULT          = PASS_THIS_GATE_ONLY
C5_MASTER       = OPEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS      = REJECT
PROGRAM         = NO
MIG             = NO
DUT             = a7ng_astra_c5_ddr_arb (NEW 6-client exclusive owner)
NOT_EDITED      = a7ng_lm_graph_arb
```

GOLDEN hashed before xvlog (`4bfc6f7a0a986889375fc59af3d8cef65682e3eab85bb1ff888b636f13eb4a8f`). KEEP C0/C1/C2 hashes MATCH.

## Raw measured (xsim.log)

```text
CLASS_six_clients HIT idx,qdir,desc,learn,lmdma,ckpt
CLASS_ckpt_addr_06000000 HIT awar=6000000
CLASS_no_midflight_switch HIT n_blk=10
CLASS_axi_only_grant HIT
CLASS_dual_owner_zero HIT n_sw=8
CLASS_one_owner HIT n_sw=8 gnt_onehot=1
ASTRA_C5_DDR_ARB_XSIM_PASS
C5_MASTER_CLAIM=NO BOARD_PASS=REJECT DDR_QUERY_BOUND_FINAL=NOT_FROZEN
```

## Quality bound (do not promote)

Evidence class **XSIM** modeled 1-beat AXI AR, not Digilent MIG PHY, not production top, not BOARD.
A09R8 is not this bag.

## KEEP

No C0/C1/C2 KEEP edited. `a7ng_lm_graph_arb.sv` not edited and not compiled as DUT.
