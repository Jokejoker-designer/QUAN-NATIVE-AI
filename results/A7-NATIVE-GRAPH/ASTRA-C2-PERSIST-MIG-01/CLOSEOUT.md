# CLOSEOUT — ASTRA-C2-PERSIST-MIG-01

```text
XSIM                 = ASTRA_C2_PERSIST_MIG_XSIM_PASS PRESENT
RESULT               = PASS_THIS_GATE_ONLY
PROGRAM              = NO
BOARD_PASS           = NOT_CLAIMED
MIG                  = XSIM_DIGILENT_AXI_MIG_SIM_PLUS_DDR3_MODEL
DDR_QUERY_BOUND_FINAL= NOT_FROZEN
PERSIST_SCHEMA_VERSION = NOT_FROZEN
C2_MASTER            = OPEN
CALIB_PS             = 122810625
SIM_PS               = 124094625
xsim SHA256          = 7db9647b91fd27a7708ceec6c18289b7c97aa2d6dde30b99bf4286fc42c3bc8e
DUT SHA256           = 17741214c066de125c7306cce47d1834531b2a7c8607febe3c9d91cc06a555b2
GOLDEN SHA256        = 9618d7acac2af5c4369cd67cfcc56fb19e92d474c6025184c2da83684ffc9c88
AWADDR               = 0x06000000 (not low16 of subject)
HEADLINE             = n_upd=1 n_schema=1 n_false=0 calib=1
FAIL_R0              = none (XSim PASS on first run)
```

Not compiled as DUT: leftover A09, STREAM-02, prior_store, synth `mig_7series_0_mig.v`.
Compiled: persist-mig wrap, persist-commit KEEP (submodule), `mig_native_wrap`,
`mig_7series_0_mig_sim`, ddr3_model, glbl.
Official Digilent `mig.prj` + KEEP persist hash-gate MATCH. Gold hashed before xvlog.
Does not edit mig.prj / ddr3_model / KEEP persist RTL.
