# RESULTS — ASTRA-09-R2-CAND-OVF-01

PROGRAM=NO. No JTAG/COM12/bit. ASTRA-07-SCALE-NARROW-01 / ASTRA-09-INTEGRATED-PATH-01 /
ASTRA-12* / ASTRA-11* / F2R-* / F3-* / ASTRA-06-* bags not edited. Frozen
`a7ng_astra_09_integ_path.sv` / `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` /
`a7ng_astra_07_scale_narrow.sv` not patched. Those bags' `run_*.ps1` not rerun.
LM06 / BOARD / DDR / Master F3 not opened. PRODUCTION_TOP remains UNKNOWN.
Does **not** claim 65536 / 800k.

```text
XSIM_MARKER      = ASTRA_09_R2_CAND_OVF_XSIM_PASS
VERDICT_PROPOSED = PASS_NARROW (this bag only: new named A09 ntrunc→INCOMP ans=0; hierarchical peek not ans=4; smoke still two-proof)
SIM_TIME         = 9025 ns
FAIL             = 0
FIRST_DIVERGENCE = none
FAIL_R0          = xvlog_fail_r0.log (XSIM 43-4316 Can not find file: 0 from PROGRAM_FPGA=0); one xvlog-arg corrective; marker on next xvlog/xelab/xsim
BIT              = NOT_BUILT
PROGRAM          = false
PRODUCTION_TOP   = UNKNOWN
```

## Path (this bag)

New named integrator `a7ng_astra_09_r2_cand_ovf` (`15a919f1…`) instantiates
frozen `a7ng_shared_rank_sgd_q8_sym_f2r2` (`b66ef328…`). Frozen
`a7ng_astra_09_integ_path.sv` (`9fdbe0d6…`) is **not** instantiated and **not**
patched. TB instantiates the same frozen SGD for ISO. `CAND_CAP=16`,
`MAX_PATH=4`, overflow plant `N=20>16`. `load_from_tb_o=0`.

DUT law: on walk done, `r_ovf <= w_ovf || (w_trunc != 0)`; if set, `S_HOLD`
`ST_INCOMP` with `best_a/p0=0` `pend_acc=0` (does not score leftover `{17,34}`).
Plant leaves dir[48]=0 so `w_ovf=0`; refuse is **ntrunc**, not a wrap mux around
frozen A09 leftover `ans=4`.

## Raw XSim (`xsim.log`)

xsim v2026.1, session **Sun Sep 6 21:05:33–21:05:35 2026**, PID **22184**,
snapshot `a09r2`, `$finish` at **9025 ns**.

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| OVF_CAND_CAP | st=6 npath=0 ans=0 p0=0 acc=0 ntrunc=4 rov=1 wov=0 hier_st=6 hier_ans=0 hier_best=0 tbl=0 | PASS |
| OVF_CAND_NO_STALE_ANS4 | DUT ans≠4, st≠ANSWER, p0≠17 | PASS |
| OVF_HIER_NO_ANS4 | u_dut.ans_o=0 u_dut.best_a=0 u_dut.r_st=6 | PASS |
| OVF_DUT_NTRUNC | ntrunc=4 r_ovf=1 w_ovf=0 | PASS |
| SMOKE_AFTER_OVF | st=0 npath=2 ans=4 p0=17 acc=1 ntrunc=0 rov=0 tbl=0 | PASS |
| UNREL_NO_STALE | st=1 npath=0 ans=0 p0=0 tbl=0 | PASS |
| OVF_MAX_PATH | st=6 npath=5 ans=0 p0=0 ntrunc=0 rov=0 tbl=0 | PASS |
| SMOKE_AFTER_MAXPATH | st=0 npath=2 ans=4 p0=17 tbl=0 | PASS |

Marker present. Zero `FAIL` lines. DUT ans on overflow = **0**. Hierarchical
peek of this DUT `hier_ans=0 hier_best=0` (not 4). Not 65536. Not 800k.

## Hashes

SHA freeze BEFORE xvlog `2026-09-06T21:05:29.4884508+07:00`.
xsim session Sun Sep 6 21:05:33–21:05:35 2026 PID **22184**.
Compiled + `.svh` pre/post **14/14 MATCH** (includes `a7ng_astra_09_r2_cand_ovf.svh`
and frozen `a7ng_astra_09_integ_path.svh`).
xsim.log SHA256 `8e7482fab48e5fecf01205eb2e00bcd83fca65fc18f115c3edee3bca977529b1`.
Frozen A09 `9fdbe0d6…` **unchanged**. Frozen SGD `b66ef328…`. Frozen A07 wrap
`13c1ae1e…` **unchanged**. ASTRA-07 bag `xsim.log` still session **20:46:35**.

## Open (unchanged)

Master ASTRA-07 65536→262144→800000 / index image. Master ASTRA-09 production
path. Master F3 10pp / CI. Master ASTRA-06 (schemaV2 DDR / NVM). LM06.
BOARD_PASS. ASTRA-13. PRODUCTION_TOP identity.
Do **not** call this Master ASTRA-07, BOARD_PASS, or 800k closed.
Manager independently accepts. Do not autonomously open the next gate.
