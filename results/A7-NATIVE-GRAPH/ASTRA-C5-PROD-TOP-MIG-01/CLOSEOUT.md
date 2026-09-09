# CLOSEOUT — ASTRA-C5-PROD-TOP-MIG-01

PROGRAM=NO. Marker `ASTRA_C5_PROD_TOP_MIG_XSIM_PASS` on raw `xsim.log`.
`C5_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

This-gate: one `a7ng_astra_c5_prod_top` hierarchy through official `mig_sim` +
`ddr3_model` after `CLASS_mig_calib_complete HIT t=122810625.0 ps`.
UART→parser→index (`AR 0x0500A220`)→desc (`AR 0x05802010`)→scorer→proof→
pending→C2 persist `AW 0x06000000`→compact LM06→UART egress. `seen=3f`
`dual=0` `nsw=15` `guard=826`. GOLDEN hash unchanged
`94b0836a82c9f43fbc67bbce83ad3fdcfef98580e8e97ca15fc13a031fea4c8c`.

Quality bounds (not Master close): planted 2-hop through MIG AW; UART sim
baud 8000/800; compact LM not 802k; TB `defparam TO_CYC=65535`.
`a7ng_astra_c5_axi1b` inside prod_top was edited for MIG AR/R + orphan-R drain
(not KEEP). C6 routed bit is stale vs this prod_top SHA
`d8a9878e44fc2e11e2a5efa7a68ce9342faa4c731c2ed69e74addb5927bbf720`.
Do not program. Do not copy DeepSeek wrap over live C6.

Independent auditor must hunt leftover-R / planted-gold tautology before any
Master stamp. This bag does not close silicon C5 or UART 115200.
