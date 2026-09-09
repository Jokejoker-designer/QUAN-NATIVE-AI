# PREREG — ASTRA-C5-EXPLICIT-REWARD-AND-FULLSTATE-01B

PROGRAM=NO. Named DUT `a7ng_astra_c5_prod_top_ckpt` (copy of 01A rew top).
Does not edit live `a7ng_astra_c5_prod_top.sv` hash c4fcca30….
Does not edit C2 KEEP. Does not instantiate C2 on `0x06000000`.
Does not edit C3 wrap. Does not freeze PERSIST_SCHEMA_VERSION.

Unknown: after a real UART reward SGD update, AXI snapshot then on-chip
clear then AXI reload restores the same 32-weight C3 bank.

HIT if:
- query without reward does not SGD
- valid +3 updates the bank and DUT persist_valid is from SGD32 ckpt
- UART 0x0C zeros all 32 on-chip weights without TB force
- UART 0x12 reloads exact 32 weights via AXI into the same C3 bank

MISS / OPEN:
- pending proof/phi restore is not in the ckpt image
- modeled AXI, not MIG; not NVM; not board
- C5_MASTER stays OPEN
