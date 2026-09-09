# RESULTS — ASTRA-06-R2-EVICT-HIGHID-01

PROGRAM=NO. No JTAG/COM12/bit. ASTRA-06-WARM-PERSIST-01 / F2R-* / F3*
bags not edited. Frozen persist DUT / F2R2 SGD / F2R2–F2R5 / F3*
integrators not patched. Those bags' run scripts not rerun.

```text
XSIM_MARKER      = ASTRA_06_R2_EVICT_HIGHID_XSIM_PASS
VERDICT_PROPOSED = PASS_NARROW (this gate only: high-bit eids + reload_i + persist capacity N=1)
SIM_TIME         = 32035 ns
FAIL             = 0 (pass run)
FIRST_DIVERGENCE = RELOAD_I_PATH (fail r0 only)
FAIL_R0          = xsim_fail_r0.log (n=2); one TB handshake corrective; no golden edits
BIT              = NOT_BUILT
PROGRAM          = false
```

## Policy (written; N=1)

`REFUSE_UNCOMMITTED_EVICT_COMMITTED`. Single persist slot. Persist never
holds two snapshots. Occupied uncommitted → refuse new pending
(`n_cap_ref`). Occupied committed → evict then install (`n_cap_evict`).

`reload_i` is distinct from auto `need_rl` (`n_rl_cmd` vs `n_rl_auto`).
Foreign schema byte does not restore into live weights.

## Raw XSim (`xsim.log`)

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| SMOKE_HIGHID | npath=2 ans=0xa00b4 p0=0xa0011 acc=1 tbl=0 phi0=50 | PASS |
| HIGHID_EID20 | pans=0xa00b4 pp0=0xa0011 pp1=0xa0022 bits19_8_p0=a00 | PASS |
| PERSIST_SNAP | pval=1 pver=1 capf=1 pw0=0 | PASS |
| EN_RST_LIVE_CLEAR | live w0=0 nupd=0 ost=0; persist valid 20-bit | PASS |
| AXI_OST_CLEARED | ost=0 | PASS |
| EN_RELOAD_AUTO | nrlauto=1 nrlcmd=0; pend {7,1,1} ans=0xa00b4 p0=0xa0011 | PASS |
| EN_DELAYED_UPD | nupd=1 cmt=1 w0=-5 | PASS |
| RELOAD_I_NO_AUTO | restore_en=0 after rst: nrlauto=0 live acc=0 persist 20-bit | PASS |
| RELOAD_I_PATH | nrlcmd=1 nrlauto=0; live acc=1 ans=0xa00b4 p0=0xa0011 | PASS |
| RELOAD_I_DELAYED_UPD | nupd=1 cmt=1 w0=-5 | PASS |
| CAP_REFUSE_SECOND | nref=1 live acc=0 persist txn=1 pans=0xa00b4 | PASS |
| CAP_EVICT_COMMITTED | nevict=1 persist txn=2 cmt=0 (one snapshot) | PASS |
| SCHEMA_FOREIGN_NO_RESTORE | nsch=1 live w0=0 acc=0 persist_w0=-5 pver=165 | PASS |
| DIS_RST_STALE | persist_en=0; nstale=1 nupd=0 w0=0 | PASS |
| UNREL_NO_STALE | payroll tax form st=1 npath=0 ans=0 p0=0 tbl=0 | PASS |

Marker present. `$finish` at 32035 ns. No FAIL lines on the pass run.

## Fail r0

`xsim_fail_r0.log` SHA256 `a93c0313ee5f809c10f2cf1f259e8d18027dff533bbcf9e35e0cbfdc2c8ca0b7`.
First divergence `RELOAD_I_PATH`: TB sampled before 32-cycle `S_RELOAD`
finished (`nrlcmd=1` already). Corrective: `pulse_reload` waits busy
high then low. DUT RTL not changed on the corrective. No golden edits.

## Hashes

SHA freeze BEFORE xvlog `2026-09-06T17:43:19.3021271+07:00`.
xsim session Sun Sep 6 17:43:24–17:43:26 2026.
Compiled + `.svh` pre/post **13/13 MATCH** (includes `a7ng_astra_06_r2_evict_highid.svh`).
xsim.log SHA256 `ff0770d36b2972c4fae126589920d3ba490e40c060cb5c4017927186887bf7d3`.
Frozen SGD `b66ef328…`. Frozen persist DUT provenance `52ebde52…` (not compiled, not patched).
Persist bag `xsim.log` still `5f739df0…`. F2R5 `a93aaedc…`. F3R4 `27d60953…`.

## Open (unchanged / not this close)

Master ASTRA-06 as a whole (schemaV2 DDR store, N>1 index eviction,
DDR-across-BRAM-loss, NVM/QSPI). Master F3 10pp/CI. LM06. BOARD_PASS.
ASTRA-13. Host `sess_id` reuse after `rst_n` without restore.
Do **not** claim DDR durability or BOARD_PASS. Manager independently
accepts. Do not autonomously open the next gate.
