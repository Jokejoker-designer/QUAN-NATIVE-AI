# FAIL r0 — ASTRA-06-R2-EVICT-HIGHID-01

Preserved. No golden edits. One corrective (TB handshake only).

```text
XSIM_MARKER_R0 = ASTRA_06_R2_EVICT_HIGHID_XSIM_FAIL n=2 first=RELOAD_I_PATH
SIM_TIME_NS    = 31715
LOG            = xsim_fail_r0.log
SHA256         = a93c0313ee5f809c10f2cf1f259e8d18027dff533bbcf9e35e0cbfdc2c8ca0b7
```

Raw r0 (not RESULTS.md):

```text
RELOAD_I_PATH st=1 ... acc=0 ... nrlcmd=1 ... pans=0xa00b4 pp0=0xa0011
FAIL RELOAD_I_PATH
RELOAD_I_DELAYED_UPD ... acc=1 cmt=0 ... nupd=0 w0=0 ... nrlcmd=1
FAIL RELOAD_I_DELAYED_UPD
```

`n_rl_cmd=1` and persist eids already 20'hA0011: DUT took the explicit `reload_i` path.
TB `wait(!rl_busy)` returned immediately because `restore_en=0` so
`reload_busy_o` is 0 in IDLE; the check sampled mid `S_RELOAD` (32-cycle
weight walk). Delayed reward was issued during reload and missed.

Corrective (pass run): `pulse_reload` waits `rl_busy` high then low before
checking pending / issuing reward. DUT RTL unchanged on the corrective.
No golden vector edits.
