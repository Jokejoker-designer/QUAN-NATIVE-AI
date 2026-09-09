# RESULTS — ASTRA-07-SCALE-MID-01

PROGRAM=NO. No JTAG/COM12/bit. ASTRA-07-SCALE-NARROW-01 / ASTRA-09-R2-CAND-OVF-01 /
ASTRA-09-INTEGRATED-PATH-01 / ASTRA-12-R5-FREEZE-BRIEF-01 / ASTRA-12* /
ASTRA-11* / F2R-* / F3-* / ASTRA-06-* bags not edited. Frozen
`a7ng_astra_09_r2_cand_ovf.sv` / `a7ng_astra_09_integ_path.sv` /
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv` / `a7ng_astra_07_scale_narrow.sv`
not patched. Those bags' `run_*.ps1` not rerun. LM06 / BOARD / DDR /
Master F3 not opened. PRODUCTION_TOP remains UNKNOWN.
Does **not** claim 65536 / 800k.

```text
XSIM_MARKER      = ASTRA_07_SCALE_MID_XSIM_PASS
VERDICT_PROPOSED = PASS_NARROW (this bag only: N=64>CAND_CAP=16 on frozen A09-R2 itself → INCOMP ans=0 ntrunc=48; smoke after reset still two-proof ans=4)
SIM_TIME         = 5035 ns
FAIL             = 0
FIRST_DIVERGENCE = none
FAIL_R0          = none (first xvlog/xelab/xsim produced the marker)
BIT              = NOT_BUILT
PROGRAM          = false
PRODUCTION_TOP   = UNKNOWN
```

## Path (this bag)

Bag-local TB instantiates frozen `a7ng_astra_09_r2_cand_ovf` (`15a919f1…`)
which instantiates frozen `a7ng_shared_rank_sgd_q8_sym_f2r2` (`b66ef328…`).
Frozen leftover `a7ng_astra_09_integ_path.sv` (`9fdbe0d6…`) is **not**
instantiated and **not** compiled as DUT. A07-NARROW wrap is **not** the DUT.
TB instantiates the same frozen SGD for ISO (no force). `CAND_CAP=16`,
`MAX_PATH=4`, overflow plant `N=64>16`. `load_from_tb_o=0`.

DUT law (already in frozen A09-R2): on walk done,
`r_ovf <= w_ovf || (w_trunc != 0)`; if set, `S_HOLD` `ST_INCOMP` with
`best_a/p0=0` `pend_acc=0` (does not score leftover `{17,34}`). Plant leaves
dir[48]=0 so `w_ovf=0`; refuse is **ntrunc=48** (`64-16`), not a wrap mux
around leftover A09 `ans=4`.

xvlog analyzed A09-R2 + frozen SGD + bag TB only. xelab snapshot `a07sm`
compiled `a7ng_astra_09_r2_cand_ovf_defaul…`. work sdb has
`a7ng_astra_09_r2_cand_ovf.sdb` and **no** `a7ng_astra_09_integ_path.sdb`.

## Raw XSim (`xsim.log`)

xsim v2026.1, session **Mon Sep 7 02:47:58–02:48:00 2026**, PID **21092**,
snapshot `a07sm`, `$finish` at **5035 ns**.

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| OVF_CAND_CAP | st=6 npath=0 ans=0 p0=0 acc=0 ntrunc=48 rov=1 wov=0 hier_st=6 hier_ans=0 hier_best=0 tbl=0 | PASS |
| OVF_CAND_NO_STALE_ANS4 | DUT ans≠4, st≠ANSWER, p0≠17 | PASS |
| OVF_HIER_NO_ANS4 | u_dut.ans_o=0 u_dut.best_a=0 u_dut.r_st=6 | PASS |
| OVF_DUT_NTRUNC | ntrunc=48 r_ovf=1 w_ovf=0 | PASS |
| SMOKE_AFTER_RST | st=0 npath=2 ans=4 p0=17 acc=1 ntrunc=0 rov=0 tbl=0 | PASS |
| UNREL_NO_STALE | st=1 npath=0 ans=0 p0=0 tbl=0 | PASS |

Marker present. Zero `FAIL` lines. DUT ans on overflow = **0**. Hierarchical
peek of this DUT `hier_ans=0 hier_best=0` (not 4). Not 65536. Not 800k.

## Hashes

SHA freeze BEFORE xvlog `2026-09-07T02:47:54.2246151+07:00`.
xsim session Mon Sep 7 02:47:58–02:48:00 2026 PID **21092**.
Compiled + `.svh` pre/post **14/14 MATCH** (includes `a7ng_astra_09_r2_cand_ovf.svh`
and frozen `a7ng_astra_09_integ_path.svh`).
xsim.log SHA256 `41d014e67d6a35b0e8fa6cb66d1ff5ebf352795c3712f65d79c756ec21e58305`.
Frozen A09-R2 `15a919f1…` **unchanged**. Frozen leftover A09 `9fdbe0d6…`
**unchanged**. Frozen SGD `b66ef328…`. Frozen A07 wrap `13c1ae1e…` **unchanged**.

## Open (unchanged)

Master ASTRA-07 65536→262144→800000 / index image. Master ASTRA-09 production
path. Master F3 10pp / CI. Master ASTRA-06 (schemaV2 DDR / NVM). LM06.
BOARD_PASS. ASTRA-13. PRODUCTION_TOP identity.
Do **not** call this Master ASTRA-07, BOARD_PASS, or 800k closed.
Manager independently accepts. Do not autonomously open the next gate.
