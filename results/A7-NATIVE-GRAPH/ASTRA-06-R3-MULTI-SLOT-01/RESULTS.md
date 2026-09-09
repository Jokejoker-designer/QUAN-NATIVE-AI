# RESULTS — ASTRA-06-R3-MULTI-SLOT-01

PROGRAM=NO. No JTAG/COM12/bit. ASTRA-06-WARM-PERSIST-01 / ASTRA-06-R2-EVICT-HIGHID-01
/ F2R-* / F3* bags not edited. Frozen persist DUT / R2 DUT / F2R2 SGD /
F2R2–F2R5 / F3* integrators not patched. Those bags' run scripts not rerun.

```text
XSIM_MARKER      = ASTRA_06_R3_MULTI_SLOT_XSIM_PASS
VERDICT_PROPOSED = PASS_NARROW (this gate only: on-chip persist CAP_N=2)
SIM_TIME         = 20975 ns
FAIL             = 0 (pass run)
FIRST_DIVERGENCE = MIX_B_WHILE_A (fail r0 only)
FAIL_R0          = xsim_fail_r0.log (n=1); one TB mix-class corrective; no golden edits
BIT              = NOT_BUILT
PROGRAM          = false
CAP_N            = 2
EVICT_VICTIM     = oldest committed / lowest txn (txn=1, idx=0)
```

## Policy (written; N=2)

`REFUSE_ALL_UNCOMMITTED` / `EVICT_OLDEST_COMMITTED_LOWEST_TXN`.
Two on-chip persist rows. Free slot → install. occ==N and ≥1 committed →
evict lowest-txn committed then install. occ==N all uncommitted → refuse.
Delayed reward writeback hits only `live_slot`. Independent restore via
`reload_i` + `slot_sel_i`.

## Raw XSim (`xsim.log`)

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| TWO_PICK_A | occ=1 s0 txn=1 phi=50 p0=0xa0011 ans=0xa00b4 capn=2 | PASS |
| TWO_PICK_B | occ=2 s1 txn=2 phi=40 p0=0xa0111 ans=0xa0c55 ; s0 unchanged capf=1 | PASS |
| RST_LIVE_CLEAR | live w0=0 acc=0 ; both rows still valid 20-bit | PASS |
| RELOAD_A | nrlcmd=1 nrlauto=0 live txn=1 phi=50 ans=0xa00b4 | PASS |
| REW_A_ONLY | s0_w0=-5 s0_cmt=1 ; s1_w0=0 s1_cmt=0 s1_phi=40 | PASS |
| MIX_B_WHILE_A | nstale=1 s1 still w0=0 cmt=0 ; s0 still -5 | PASS |
| RELOAD_B | live txn=2 phi=40 ans=0xa0c55 ; s0 still w0=-5 | PASS |
| REW_B_ONLY | s1_w0=-4 s1_cmt=1 ; s0_w0=-5 s0_phi=50 | PASS |
| TWO_COMMIT_ROWS | occ=2 both cmt distinct tuples ; victim txn=1 idx=0 | PASS |
| THIRD_EVICT | nevict=1 s0 txn=3 p0=0xa0311 w0=0 ; s1 still B w0=-4 | PASS |
| REFUSE_ALL_UNC | nref=1 live acc=0 rows unchanged txn 1/2 | PASS |
| UNREL_NO_STALE | payroll tax form st=1 npath=0 ans=0 p0=0 tbl=0 | PASS |

Marker present. `$finish` at 20975 ns. No FAIL lines on the pass run.

## Fail r0

`xsim_fail_r0.log` SHA256 `579686f26ce318b97a03271ee1071878a1b65123b6e1409498b24ac769483348`.
First divergence `MIX_B_WHILE_A`: TB required `nbad++`; DUT F2R law counts
`rew_gen != pend_gen` as `nstale`. Isolation fields already matched.
Corrective: MIX accepts `nstale++ || nbad++` and still requires s1 w0=0 cmt=0
and s0 w0=-5. DUT RTL not changed on the corrective. No golden edits of
w0/phi/eids/CAP_N/victim.

## Hashes

SHA freeze BEFORE xvlog `2026-09-06T18:12:31.7047290+07:00`.
xsim session Sun Sep 6 18:12:36–18:12:38 2026 PID 14668.
Compiled + `.svh` pre/post **13/13 MATCH** (includes `a7ng_astra_06_r3_multi_slot.svh`).
xsim.log SHA256 `d6deb5ba22768fcd51c727ccd1df64413b9e3f2ac1b8cd3989735d9dba6536e6`.
Frozen SGD `b66ef328…`. Frozen persist DUT provenance `52ebde52…` (not compiled, not patched).
Frozen R2 DUT provenance `c671f98b…` (not compiled, not patched).
Persist bag `xsim.log` still `5f739df0…`. R2 bag `ff0770d3…`. F2R5 `a93aaedc…`. F3R4 `27d60953…`.

## Open (unchanged / not this close)

Master ASTRA-06 as a whole (schemaV2 DDR store, DDR index N>1 eviction,
DDR-across-BRAM-loss, NVM/QSPI). Master F3 10pp/CI. LM06. BOARD_PASS.
ASTRA-13. Host `sess_id` reuse after `rst_n` without restore.
Do **not** claim DDR durability or BOARD_PASS. Manager independently
accepts. Do not autonomously open the next gate.
