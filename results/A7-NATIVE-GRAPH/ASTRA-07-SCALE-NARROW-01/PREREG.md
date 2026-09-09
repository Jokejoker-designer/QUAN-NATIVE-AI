# PREREG — ASTRA-07-SCALE-NARROW-01

Frozen before xvlog. PROGRAM=NO. No board. No JTAG/xsdb/COM12/bitstream.
Does not edit ASTRA-12* / ASTRA-11* / ASTRA-09 / F2R-* / F3-* / ASTRA-06-* bags
or frozen RTL (`a7ng_astra_09_integ_path.sv/.svh`,
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv`). Does not rerun those bags' `run_*.ps1`.
Does not open LM06 / BOARD / DDR / Master F3. Does not freeze PRODUCTION_TOP.
Does **not** claim Master ASTRA-07 65536 / 262144 / 800000.

## Claim this revision may close

One named XSim path (this bag only): when posting-list count exceeds registered
`CAND_CAP` (or legal 2-hops exceed `MAX_PATH`), the FPGA declares `ST_INCOMP`
with `ans=0` `p0=0` — no stale ANSWER 4 from truncated leftover. UNREL no stale.
ISO +5. Two-proof smoke still works after overflow (retire) or reset.

Does **not** close Master ASTRA-07 index image / 800k ladder, Master ASTRA-09,
Master F3 10pp, LM06, BOARD, ASTRA-13.

## One unknown

When posting-list / candidate count exceeds the DUT’s registered CAND_CAP
(or MAX_PATH), does the FPGA declare overflow/INCOMP without a stale ANSWER —
and does a legal two-proof smoke still pass on the same DUT?

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
```

## Law (instantiated, not copied)

Frozen `a7ng_astra_09_integ_path` (contains frozen
`a7ng_shared_rank_sgd_q8_sym_f2r2`). New named wrap
`a7ng_astra_07_scale_narrow` fail-closes when a directory beat has
`post_count > CAND_CAP` or ovf-ent bit[48]. Frozen A09 `q_overflow_o` follows
dir[48] only (ntrunc does not set r_ovf); wrap is the cap-count identity so
truncated leftover `{17,34}` cannot publish ANSWER 4. MAX_PATH INCOMP is A09
`S_GUARD` (`n_legal > MAX_PATH`) passed through.

ISO +3, x0=50 → dw0=+5 (not floor-shift +4). `load_from_tb_o=0`.

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | isolated SGD +3 x0=50 | dw0=+5 |
| OVF_CAND_CAP | dir count=20 > 16; leftover 17/34/18/35 first | st=6 ans=0 p0=0 acc=0 cap_ovf=1; not ANSWER 4 |
| SMOKE_AFTER_OVF | plant2 two-proof after OVF retire (no rst required) | ANSWER npath=2 p0=17 ans=4 tbl=0 |
| UNREL_NO_STALE | then `payroll tax form` | UNKNOWN npath=0 ans=0 p0=0 |
| OVF_MAX_PATH | 5 legal 2-hops, count=10 ≤ 16 | st=6 ans=0 p0=0; A09 raw also INCOMP |
| SMOKE_AFTER_MAXPATH | plant2 after MAX_PATH reset | ANSWER npath=2 p0=17 ans=4 tbl=0 |

## Out of scope

Master ASTRA-07 65536→800000 / full index image. Master ASTRA-09 production path.
Master F3 10pp/CI. LM06. BOARD. ASTRA-13. PRODUCTION_TOP freeze. DDR/MIG. NVM.
`load_from_tb` retrieval.
