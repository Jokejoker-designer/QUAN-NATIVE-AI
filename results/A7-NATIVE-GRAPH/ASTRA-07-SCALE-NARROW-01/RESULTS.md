# RESULTS — ASTRA-07-SCALE-NARROW-01

PROGRAM=NO. No JTAG/COM12/bit. ASTRA-12* / ASTRA-11* / ASTRA-09 / F2R-* / F3-* /
ASTRA-06-* bags not edited. Frozen `a7ng_astra_09_integ_path.sv` /
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv` not patched. Those bags' `run_*.ps1` not
rerun. LM06 / BOARD / DDR / Master F3 not opened. PRODUCTION_TOP remains UNKNOWN.
Does **not** claim 65536 / 800k.

```text
XSIM_MARKER      = ASTRA_07_SCALE_NARROW_XSIM_PASS
VERDICT_PROPOSED = PASS_NARROW (this bag only: CAND_CAP/MAX_PATH overflow → INCOMP, no stale ANSWER 4; smoke still two-proof)
SIM_TIME         = 13155 ns
FAIL             = 0
FIRST_DIVERGENCE = none
FAIL_R0          = none (first xvlog/xelab/xsim produced the marker)
BIT              = NOT_BUILT
PROGRAM          = false
PRODUCTION_TOP   = UNKNOWN
```

## Path (this bag)

New named wrap `a7ng_astra_07_scale_narrow` instantiates frozen
`a7ng_astra_09_integ_path` (`9fdbe0d6…`) which instantiates frozen
`a7ng_shared_rank_sgd_q8_sym_f2r2` (`b66ef328…`). TB instantiates the same
frozen SGD for ISO. `CAND_CAP=16`, `MAX_PATH=4`, overflow plant `N=20>16`.
`load_from_tb_o=0`. Wrap fail-closes when directory `post_count > CAND_CAP`.

Frozen A09 without wrap would publish ANSWER 4 from truncated leftover
(`a09st=0 a09ans=4 a09p0=17 a09np=2` on the cap plant). Wrap published
`st=6 ans=0 p0=0 cap_ovf=1`. MAX_PATH `n_legal=5>4` is A09 `S_GUARD` INCOMP
passed through.

## Raw XSim (`xsim.log`)

xsim v2026.1, session **Sun Sep 6 20:46:35–20:46:37 2026**, PID **2904**,
snapshot `a07sn`, `$finish` at **13155 ns**.

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| OVF_CAND_CAP | st=6 npath=0 ans=0 p0=0 acc=0 cap_ovf=1 a09st=0 a09ans=4 a09p0=17 a09np=2 tbl=0 | PASS |
| OVF_CAND_NO_STALE_ANS4 | wrap ans≠4, st≠ANSWER | PASS |
| SMOKE_AFTER_OVF | st=0 npath=2 ans=4 p0=17 acc=1 cap_ovf=0 tbl=0 | PASS |
| UNREL_NO_STALE | st=1 npath=0 ans=0 p0=0 tbl=0 | PASS |
| OVF_MAX_PATH | st=6 npath=5 ans=0 p0=0 cap_ovf=0 a09st=6 a09np=5 tbl=0 | PASS |
| OVF_MAX_PATH_A09 | a09st=6 a09np=5>4 | PASS |
| SMOKE_AFTER_MAXPATH | st=0 npath=2 ans=4 p0=17 tbl=0 | PASS |

Marker present. Zero `FAIL` lines. Not 65536. Not 800k.

## Hashes

SHA freeze BEFORE xvlog `2026-09-06T20:46:31.0528609+07:00`.
xsim session Sun Sep 6 20:46:35–20:46:37 2026 PID **2904**.
Compiled + `.svh` pre/post **15/15 MATCH** (includes `a7ng_astra_07_scale_narrow.svh`
and `a7ng_astra_09_integ_path.svh`).
xsim.log SHA256 `91247e60d99380d69449fcb2ed6d188d8be3e9368d3d09293e1870dd6100ba77`.
Frozen A09 `9fdbe0d6…`. Frozen SGD `b66ef328…`.

## Open (unchanged)

Master ASTRA-07 65536→262144→800000 / index image. Master ASTRA-09 production
path. Master F3 10pp / CI. Master ASTRA-06 (schemaV2 DDR / NVM). LM06.
BOARD_PASS. ASTRA-13. PRODUCTION_TOP identity.
Do **not** call this Master ASTRA-07, BOARD_PASS, or 800k closed.
Manager independently accepts. Do not autonomously open the next gate.
