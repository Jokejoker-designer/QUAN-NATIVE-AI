# PREREG — ASTRA-09-R2-CAND-OVF-01

Frozen before xvlog. PROGRAM=NO. No board. No JTAG/xsdb/COM12/bitstream.
Does not edit ASTRA-07-SCALE-NARROW-01 / ASTRA-09-INTEGRATED-PATH-01 /
ASTRA-12* / ASTRA-11* / F2R-* / F3-* / ASTRA-06-* bags or frozen RTL
(`a7ng_astra_09_integ_path.sv/.svh`, `a7ng_astra_07_scale_narrow.sv/.svh`,
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv`). Does not rerun those bags' `run_*.ps1`.
Does not open LM06 / BOARD / DDR / Master F3. Does not freeze PRODUCTION_TOP.
Does **not** claim Master ASTRA-07 65536 / 262144 / 800000.

## Claim this revision may close

One named XSim A09 revision (this bag only): when the walker truncates
(`n_trunc_o != 0`, plant `N > CAND_CAP`) with leftover legal 2-hops, **the DUT
itself** publishes `ST_INCOMP` with `ans=0` `p0=0`. Hierarchical peek of this
DUT must not show `ans=4`. Not a wrap around frozen A09 leftover `ans=4`.
MAX_PATH `5>4` still INCOMP. UNREL no stale. ISO +5. Two-proof smoke still
works after overflow (retire). `load_from_tb_o=0`.

Does **not** close Master ASTRA-07 index image / 800k ladder, Master ASTRA-09,
Master F3 10pp, LM06, BOARD, ASTRA-13.

## One unknown

On the new named integrator (not the frozen A09 file), when walker truncates /
`nc==CAND_CAP` with leftover legal 2-hops, does the DUT itself publish INCOMP
`ans=0` (not a wrap around frozen A09 leftover `ans=4`)?

## Registered caps

```text
CAND_CAP        = 16
MAX_PATH        = 4
OVF_PLANT_N     = 20   (must be > CAND_CAP)
OVF_MAXPATH_N   = 5    (must be > MAX_PATH)
EXPECT_STATUS   = ST_INCOMP = 6
EXPECT_ANS      = 0
EXPECT_P0       = 0
SMOKE           = two legal 2-hops, ans=4, p0=17, npath=2
ISO             = +3, x0=50 → dw0=+5
FROZEN_A09      = 9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c
```

## Law (new named DUT, not wrap)

New named `a7ng_astra_09_r2_cand_ovf` copies the A09 integrator **under a new
module name** and closes ntrunc→INCOMP: on walk done,
`r_ovf <= w_ovf || (w_trunc != 0)`; if set, DUT goes `S_HOLD` `ST_INCOMP` with
`best_a/p0=0` `pend_acc=0` and does **not** score truncated leftover `{17,34}`.
Frozen A09 `q_overflow_o` still follows dir[48] only (`w_ovf=0` on this plant);
this DUT honors `n_trunc_o`. Frozen `a7ng_astra_09_integ_path.sv` is **not**
instantiated and **not** patched.

MAX_PATH INCOMP remains `S_GUARD` (`n_legal > MAX_PATH`) with `r_ovf=0`.

ISO +3, x0=50 → dw0=+5 (not floor-shift +4). `load_from_tb_o=0`.

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | isolated SGD +3 x0=50 | dw0=+5 |
| OVF_CAND_CAP | dir count=20 > 16; leftover 17/34/18/35 first | st=6 ans=0 p0=0 acc=0 ntrunc!=0 rov=1 wov=0; not ANSWER 4 |
| OVF_HIER_NO_ANS4 | hierarchical peek u_dut.ans_o / best_a / r_st | ans=0 best=0 r_st=6; not 4 |
| OVF_DUT_NTRUNC | DUT identity | ntrunc!=0 r_ovf=1 w_ovf=0 (ntrunc, not dir[48]) |
| SMOKE_AFTER_OVF | plant2 two-proof after OVF retire (no rst required) | ANSWER npath=2 p0=17 ans=4 tbl=0 r_ovf=0 |
| UNREL_NO_STALE | then `payroll tax form` | UNKNOWN npath=0 ans=0 p0=0 |
| OVF_MAX_PATH | 5 legal 2-hops, count=10 ≤ 16 | st=6 ans=0 p0=0 npath=5 r_ovf=0 |
| SMOKE_AFTER_MAXPATH | plant2 after MAX_PATH retire | ANSWER npath=2 p0=17 ans=4 tbl=0 |

## Out of scope

Master ASTRA-07 65536→800000 / full index image. Master ASTRA-09 production path.
Master F3 10pp/CI. LM06. BOARD. ASTRA-13. PRODUCTION_TOP freeze. DDR/MIG. NVM.
`load_from_tb` retrieval. Patching frozen A09 leftover `ans=4`.
