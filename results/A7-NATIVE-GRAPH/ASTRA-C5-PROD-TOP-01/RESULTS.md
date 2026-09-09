# RESULTS — ASTRA-C5-PROD-TOP-01

```text
GATE            = ASTRA-C5-PROD-TOP-01
XSIM            = ASTRA_C5_PROD_TOP_XSIM_PASS
RESULT          = PASS_THIS_GATE_ONLY
C5_MASTER       = OPEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS      = REJECT
PROGRAM         = NO
MIG             = NO
A09             = NOT_TOP
DUT             = a7ng_astra_c5_prod_top (NEW hierarchy)
```

GOLDEN hashed before xvlog (`ceffb73fa2222a53f64e3e701c570bc9e8117f17bf769b332a81337d7686f2bb`). KEEP C0/C1/C2 hashes MATCH. GOLDEN was not regenerated after the first XSim FAIL.

## Raw measured (xsim.log)

```text
MEAS nurx=23 nutx=2 seen=3f dual=0 st=0 obj=0 res=1 pcmt=1 pvalid=1 pph=4 gdone=1 glast=0 ehas=1 nhw=0 nht=0 last_aw=6000000
CLASS_uart_ingress HIT n=23
CLASS_role_parser HIT
CLASS_sparse_index HIT
CLASS_desc_retrieval HIT
CLASS_shared_scorer HIT st=0
CLASS_typed_proof HIT
CLASS_pending_reward HIT
CLASS_persist HIT pvalid=1 pph=4
CLASS_evid_materializer HIT
CLASS_lm06_gen HIT glast=0
CLASS_uart_egress HIT n=2
CLASS_one_ddr_owner HIT nsw=15 dual=0
CLASS_six_clients HIT seen=3f
CLASS_no_qid_map HIT
CLASS_no_host_winner HIT
CLASS_no_a09_top HIT
CLASS_no_plant_in_dut HIT
CLASS_ckpt_addr_06000000 HIT awar=6000000
ASTRA_C5_PROD_TOP_XSIM_PASS
```

## Quality bound (do not promote)

Evidence class **XSIM**. Modeled AXI AR/AW through the C5 exclusive owner, not Digilent MIG PHY.
Compact C4 linear head (first UART token was EOS/0 because C3 `obj_o=0` on this packet). Not TinyGPT-802k. Not Master unified regression. Not BOARD.
Plant lives in the TB only.

## KEEP

No C0/C1/C2 KEEP edited. C3 held-out, C4 adapters, and C5 arbiter instantiated, not edited. `a7ng_lm_graph_arb.sv` not edited. A09 not compiled.
