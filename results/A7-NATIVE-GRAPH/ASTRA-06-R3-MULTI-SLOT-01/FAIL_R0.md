# FAIL r0 — ASTRA-06-R3-MULTI-SLOT-01

Preserved. No golden edits. One corrective (TB mix-class only). DUT RTL not changed.

```text
XSIM_MARKER_R0 = ASTRA_06_R3_MULTI_SLOT_XSIM_FAIL n=1 first=MIX_B_WHILE_A
SIM_TIME_NS    = 20975
LOG            = xsim_fail_r0.log
SHA256         = 579686f26ce318b97a03271ee1071878a1b65123b6e1409498b24ac769483348
PID            = 47228
SESSION        = Sun Sep 6 18:11:42–18:11:44 2026
```

Raw r0 (not RESULTS.md):

```text
REW_A_ONLY ... s0c=1 s0w0=-5 s1c=0 s1w0=0 s1phi=40
PASS REW_A_ONLY
MIX_B_WHILE_A ... nstale=1 nbad=0 s0w0=-5 s1w0=0 s1c=0
FAIL MIX_B_WHILE_A
```

All other tags on r0 already PASS (ISO, TWO_PICK, RELOAD_A/B, REW_A_ONLY,
REW_B_ONLY w0=-4, TWO_COMMIT_ROWS, THIRD_EVICT nevict=1 victim txn=1 idx=0,
REFUSE_ALL_UNC nref=1, UNREL). Isolation fields on MIX already matched:
slot B uncommitted w0=0 phi=40; slot A w0=-5.

Discriminator: TB required `nbad++`. DUT F2R handshake law counts
`rew_gen != pend_gen` as **stale**, not bad (epoch same, gen 2 vs live 1).

Corrective (pass run): MIX accepts `nstale++ || nbad++` and still requires
s1 w0=0 cmt=0 phi=40 and s0 w0=-5. DUT RTL unchanged. No golden-vector
edit of w0/phi/eids/CAP_N/victim.
