# PREREG — ASTRA-07-SCALE-MID-01

Frozen before xvlog. PROGRAM=NO. No board. No JTAG/xsdb/COM12/bitstream.
Does not edit ASTRA-07-SCALE-NARROW-01 / ASTRA-09-R2-CAND-OVF-01 /
ASTRA-09-INTEGRATED-PATH-01 / ASTRA-12-R5-FREEZE-BRIEF-01 / ASTRA-12* /
ASTRA-11* / F2R-* / F3-* / ASTRA-06-* bags or frozen RTL
(`a7ng_astra_09_r2_cand_ovf.sv/.svh`, `a7ng_astra_09_integ_path.sv/.svh`,
`a7ng_astra_07_scale_narrow.sv/.svh`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`).
Does not rerun those bags' `run_*.ps1`. Does not open LM06 / BOARD / DDR /
Master F3. Does not freeze PRODUCTION_TOP.
Does **not** claim Master ASTRA-07 65536 / 262144 / 800000.

## Claim this revision may close

One named XSim path (this bag only): posting-list count `N=64` exceeds
registered `CAND_CAP=16` on **frozen `a7ng_astra_09_r2_cand_ovf` itself**
(not leftover A09, not a wrap around leftover A09). The DUT publishes
`ST_INCOMP` with `ans=0` `p0=0`. Hierarchical peek of this DUT must not show
`ans=4`. UNREL no stale. ISO +5 on instantiated frozen SGD without force.
Two-proof smoke still ANSWER 4 after **reset**.

Does **not** close Master ASTRA-07 index image / 800k ladder, Master ASTRA-09,
Master F3 10pp, LM06, BOARD, ASTRA-13.

## One unknown

With posting N=64 and CAND_CAP=16, does A09-R2 itself (not a wrap around
leftover A09) publish INCOMP ans=0, and does smoke two-proof still ANSWER 4
after reset?

## Registered caps

```text
CAND_CAP        = 16
MAX_PATH        = 4
OVF_PLANT_N     = 64   (must be > CAND_CAP; not 65536)
EXPECT_STATUS   = ST_INCOMP = 6
EXPECT_ANS      = 0
EXPECT_P0       = 0
SMOKE           = after reset; two legal 2-hops, ans=4, p0=17, npath=2
ISO             = +3, x0=50 → dw0=+5 (frozen SGD instance; no force)
FROZEN_A09R2    = 15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23
FROZEN_A09      = 9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c
                  (leftover; NOT the DUT; not compiled)
```

## Law (instantiated, not copied)

Frozen `a7ng_astra_09_r2_cand_ovf` instantiates frozen
`a7ng_shared_rank_sgd_q8_sym_f2r2`. On walk done,
`r_ovf <= w_ovf || (w_trunc != 0)`; if set, DUT goes `S_HOLD` `ST_INCOMP`
with `best_a/p0=0` `pend_acc=0` and does **not** score truncated leftover
`{17,34}`. Plant leaves dir[48]=0 so `w_ovf=0`; refuse is **ntrunc** from
`N=64>CAND_CAP=16`. Frozen leftover `a7ng_astra_09_integ_path.sv` is **not**
instantiated and **not** patched. A07-NARROW wrap is **not** the DUT.

ISO +3, x0=50 → dw0=+5 (not floor-shift +4). `load_from_tb_o=0`.

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | isolated SGD +3 x0=50 (no force) | dw0=+5 |
| OVF_CAND_CAP | dir count=64 > 16; leftover 17/34/18/35 first | st=6 ans=0 p0=0 acc=0 ntrunc!=0 rov=1 wov=0; not ANSWER 4 |
| OVF_HIER_NO_ANS4 | hierarchical peek u_dut.ans_o / best_a / r_st | ans=0 best=0 r_st=6; not 4 |
| OVF_DUT_NTRUNC | DUT identity | ntrunc!=0 r_ovf=1 w_ovf=0 (ntrunc, not dir[48]) |
| SMOKE_AFTER_RST | hard_rst then plant2 two-proof | ANSWER npath=2 p0=17 ans=4 tbl=0 r_ovf=0 |
| UNREL_NO_STALE | then `payroll tax form` | UNKNOWN npath=0 ans=0 p0=0 |

## Out of scope

Master ASTRA-07 65536→800000 / full index image. Master ASTRA-09 production path.
Master F3 10pp/CI. LM06. BOARD. ASTRA-13. PRODUCTION_TOP freeze. DDR/MIG. NVM.
`load_from_tb` retrieval. Patching frozen A09 leftover `ans=4`. Patching A09-R2.
NARROW wrap as DUT.
