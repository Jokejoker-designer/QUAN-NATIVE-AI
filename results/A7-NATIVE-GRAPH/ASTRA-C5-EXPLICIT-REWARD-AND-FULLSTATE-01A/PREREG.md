# PREREG — ASTRA-C5-EXPLICIT-REWARD-AND-FULLSTATE-01A

PROGRAM=NO. Named DUT `a7ng_astra_c5_prod_top_rew` (copy of live prod_top).
Does not edit live `a7ng_astra_c5_prod_top.sv` hash c4fcca30….
Does not edit C3 wrap. Does not close 01B.

Unknown: only a valid host reward packet updates the C3 SGD32 bank.

HIT if:
- two UART queries, no reward: n_upd=0 and 32-weight delta=0
- valid scalar +3 then 0 then -3 increment n_upd
- duplicate / stale gen / CRC / freeze / range do not increment n_upd
- DUT does not wire live txn/gen as reward identity (packet fields only)

Does not stamp C5_MASTER. Modeled AXI, not MIG.
