# RESULTS — ASTRA-06-R4-SESS-REUSE-01

PROGRAM=NO. No JTAG/COM12/bit. ASTRA-06-WARM-PERSIST-01 / ASTRA-06-R2-EVICT-HIGHID-01
/ ASTRA-06-R3-MULTI-SLOT-01 / F2R-* / F3* bags not edited. Frozen persist DUT /
R2 DUT / R3 DUT / F2R2 SGD / F2R2–F2R5 / F3* integrators not patched. Those
bags' run scripts not rerun.

```text
XSIM_MARKER      = ASTRA_06_R4_SESS_REUSE_XSIM_PASS
VERDICT_PROPOSED = PASS_NARROW (this gate only: host sess_id reuse without restore)
SIM_TIME         = 13555 ns
FAIL             = 0 (pass run; first xvlog/xelab/xsim)
FIRST_DIVERGENCE = none
FAIL_R0          = none (no corrective)
BIT              = NOT_BUILT
PROGRAM          = false
SESS_POLICY      = persist-owned sess refuses PICK after rst until matching restore
```

## Sess lifetime (written; fail-closed)

`sess_id` is part of pending/persist key `{sess,gen,txn}`. Live identity dies
on `rst_n`. Persist rows keep the sess. Restore (`reload_i` or auto `need_rl`
with `restore_en`) requires **matching** `sess_id_i == persist sess`. Mismatch
does not pull weights (`n_sess_rej++`). Same-sess PICK after rst without
restore is refused (`n_sess_reuse++`) and does not mint a new `{sess,txn=1}`.
New sess after rst without restore may PICK; live SGD stays 0; old persist
row unchanged. Delayed rew against empty post-rst pending is `n_stale`.

## Raw XSim (`xsim.log`)

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| PICK_A | acc=1 txn=1 gen=1 ep=7 phi=50 p0=0xa0011 ans=0xa00b4 psess=7 bound=1 | PASS |
| RST_LIVE_CLEAR | live w0=0 acc=0 bound=0; persist sess=7 txn=1 20-bit; nrlcmd=0 nrlauto=0 | PASS |
| REUSE_REW_STALE | nstale=1 nupd=0 acc=0 persist w0=0 cmt=0 | PASS |
| REUSE_PICK_REFUSE | nreuse=1 acc=0 txn=0 (not minted); persist txn=1 sess=7 w0=0 | PASS |
| RELOAD_MISMATCH | sess=9 reload; nrej=1 nrlcmd=0 acc=0 live w0=0 persist sess=7 | PASS |
| MATCH_RELOAD | nrlcmd=1 acc=1 txn=1 gen=1 ep=7 phi=50 eids A bound=1 | PASS |
| MATCH_REW | nupd=1 cmt=1 w0=-5 persist s0w0=-5 sess=7 | PASS |
| NEW_SESS_NO_PULL | live ep=9 w0=0; s0 still sess=7 w0=-5; s1 sess=9 w0=0 | PASS |
| NEW_SESS_OLD_REW | nstale=1 nupd=0 persist s0 still -5; live w0=0 ep=9 | PASS |
| UNREL_NO_STALE | payroll tax form st=1 npath=0 ans=0 p0=0 tbl=0 | PASS |

Marker present. `$finish` at 13555 ns. No FAIL lines on the pass run.

## Fail r0

None. First compile+sim produced the marker. No golden edits.

## Hashes

SHA freeze BEFORE xvlog `2026-09-06T18:35:09.2021301+07:00`.
xsim session Sun Sep 6 18:35:14–18:35:16 2026.
Compiled + `.svh` pre/post **13/13 MATCH** (includes `a7ng_astra_06_r4_sess_reuse.svh`).
xsim.log SHA256 `cf7db5260f4f410d0c8e41fd5560b2fd5056e8ffd2555060df5697826670d64f`.
Frozen SGD `b66ef328…`. Frozen persist DUT provenance `52ebde52…` (not compiled, not patched).
Frozen R2 DUT provenance `c671f98b…` (not compiled, not patched).
Frozen R3 DUT provenance `99ee5d93…` (not compiled, not patched).
Persist bag `xsim.log` still `5f739df0…`. R2 bag `ff0770d3…`. R3 bag `d6deb5ba…`.
F2R5 `a93aaedc…`. F3R4 `27d60953…`.

## Open (unchanged / not this close)

Master ASTRA-06 as a whole (schemaV2 DDR store, DDR index N>1 eviction,
DDR-across-BRAM-loss, NVM/QSPI). Master F3 10pp/CI. LM06. BOARD_PASS.
ASTRA-13. Power-loss NVM journal. Do **not** claim DDR durability or
BOARD_PASS. Manager independently accepts. Do not autonomously open the
next gate.
