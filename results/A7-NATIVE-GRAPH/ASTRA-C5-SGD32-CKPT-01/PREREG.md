# PREREG — ASTRA-C5-SGD32-CKPT-01

PROGRAM=NO. Unit bag for WO-01B. Instantiates new `a7ng_astra_c5_sgd32_ckpt`
and SGD KEEP. Does not edit C2 KEEP. TB may load weights only as independent
baseline before the exam.

Unknown: AXI snapshot/reload restores the same 32-weight bank used for score/update.

HIT: exact 32-weight match after persist→clear→reload; CRC fail does not install;
BRESP error does not set PERSISTED.

Does not stamp C5_MASTER. Does not freeze PERSIST_SCHEMA_VERSION.
