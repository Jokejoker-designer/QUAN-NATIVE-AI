# CLOSEOUT — ASTRA-C2-PERSIST-MULTI-SLOT-01

```text
XSIM                 = ASTRA_C2_PERSIST_MULTI_SLOT_XSIM_PASS PRESENT
RESULT               = PASS_THIS_GATE_ONLY
PROGRAM              = NO
BOARD_PASS           = NOT_CLAIMED
MIG                  = NO
DDR_QUERY_BOUND_FINAL= NOT_FROZEN
PERSIST_SCHEMA_VERSION = NOT_FROZEN
C2_MASTER            = OPEN
CAP_N                = 2
N_AXI                = 4
SIM_NS               = 895
xsim SHA256          = c185b07bb527ab9c05861081e90356b88dc94c00a0373560c4554adaf98312c7
DUT SHA256           = bc8b8993edbba8bc048bc03ebc6398744cf80da01d346801c3683a15881682fd
GOLDEN SHA256        = e452f698ff7b0b556183fe8a259f69e26803f234233e4c03b187c80e6f3fe308
AWADDR               = 0x06000000 + axi_idx*16 (not low16 of subject)
HEADLINE             = n_upd=4 n_hit=1 n_miss=3 n_evict=1 n_wb=1 n_stale=1 n_schema=1 n_false=0
FAIL_R0              = none (XSim PASS on first run; harness Select-String parse was not a DUT/TB fail)
```

Not compiled as DUT: leftover A09, C0 sparse FILE, STREAM-02, ASTRA-06, a7ng_learned_prior_store, persist-commit KEEP.
C0 + persist-commit hash gate MATCH. Gold hashed before first xvlog.
Same-tuple in-place dirty is law `astra-c2-persist-ms-01`. DUP remains identity KEEP bag.
