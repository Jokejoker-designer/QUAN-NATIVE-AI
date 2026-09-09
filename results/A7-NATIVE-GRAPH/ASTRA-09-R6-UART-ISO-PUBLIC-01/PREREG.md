# PREREG — ASTRA-09-R6-UART-ISO-PUBLIC-01

Frozen before xvlog. PROGRAM=NO. No board. No JTAG/xsdb/COM12/bitstream.
Does not edit ASTRA-09-R5-UART-ISO-INNER-01 / ASTRA-09-R4-UART-ISO-01 /
ASTRA-09-R3-UART-XSIM-01 / ASTRA-12-R3-UART-WRAP-CANDIDATES-01 /
ASTRA-11-A09R3-UART-* / ASTRA-09-R2-CAND-OVF-01 /
ASTRA-09-INTEGRATED-PATH-01 / ASTRA-12* / ASTRA-11-A09-IMPL-ROUTE-01 /
F2R-* / F3-* / ASTRA-06-* bags or frozen RTL
(`a7ng_astra_09_integ_path.sv/.svh`, `a7ng_astra_09_r2_cand_ovf.sv/.svh`,
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv`). Does not rerun those bags' `run_*.ps1`.
Does not open LM06 / BOARD / DDR / Master F3. Does not freeze PRODUCTION_TOP.
Does **not** claim ASTRA-09-R5 inner-port sim-override numbers as this bag.
Does **not** patch frozen A09-R2.

## Claim this bag may close

One named UART-facing PUBLIC ISO XSim (this bag only): a new named DUT
`a7ng_astra_09_r6_iso_pub` instantiates frozen
`a7ng_shared_rank_sgd_q8_sym_f2r2` (`b66ef328…`) as inner `u_sgd` **only**.
Frozen `a7ng_astra_09_r2_cand_ovf` (`15a919f1…`) is **unused** (no public
iso/go_upd/x/rew ports; not patched). Wrap/TB/DUT must not contain
`force` / `release` / `deposit`. Wrap/TB must not instantiate a parallel
ISO SGD. Host UART 115200 8N1 delivers an isolated SGD command
(`load_from_tb=0`) into DUT public `iso_req_i` / `iso_x0_i` / `iso_rew_i`.
DUT learn FSM drives inner `u_sgd` ports. Byte stream / hierarchical
`u_r6.u_sgd.w_o[0]` shows:

- ISO_P3: x[0]=50 rew=+3 → inner w0=+5 (w1=0, v=0)
- ISO_M3: x[0]=64 rew=-3 → inner w0=-6 (w1=0, v=0)

UNISIM MMCM or behavioral MMCM_STUB. Not silicon MMCM. Not BOARD_PASS.

## One unknown

Can UART 8N1 drive the learner **without** `force`/`release`/`deposit` —
only module ports and FSM — so ISO_P3 inner w0=+5 and ISO_M3 w0=-6,
`load_from_tb=0`?

## Registered caps

```text
DUT_MODULE      = a7ng_astra_09_r6_iso_pub (new named; bag-local; not PRODUCTION_TOP)
INNER_SGD       = u_r6.u_sgd (a7ng_shared_rank_sgd_q8_sym_f2r2 child; not a wrap sibling)
WRAP            = a7ng_astra_09_r6_uart_iso_public_wrap (bag-local; not PRODUCTION_TOP)
FROZEN_A09R2    = UNUSED (15a919f1… unchanged; not compiled as DUT)
UART            = 115200 8N1
CLK_PIN         = CLK100MHZ 10 ns → MMCM 50 MHz pipe
CMD_ISO         = 0xA5
MAGIC           = A2
EOL             = 0x0A
ISO_P3          = cmd A5 32 03 0A  → inner w0=+5 v=0 w1=0
ISO_M3          = after wrap reset; cmd A5 40 FD 0A → inner w0=-6 v=0 w1=0
LOAD_FROM_TB    = 0
NO_SIBLING_SGD  = 1
NO_SIM_OVERRIDE = 1
FROZEN_A09R2_SHA= 15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23
FROZEN_A09      = 9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c
FROZEN_SGD      = b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac
```

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | UART ISO cmd x0=50 rew=+3 from w=0 | UART frame w0=+5 v=0 w1=0 tbl=0; hier `u_r6.u_sgd.w_o[0]`=+5 |
| ISO_M3_X64_DW6 | wrap reset (w=0); UART ISO cmd x0=64 rew=-3 | UART frame w0=-6 v=0 w1=0 tbl=0; hier `u_r6.u_sgd.w_o[0]`=-6 |
| HIER_TBL0 | hierarchical `load_from_tb_o` | 0 on both ISO frames |
| NO_SIBLING | wrap instantiates new DUT only | pass numbers from inner `u_sgd`, not a second SGD instance |
| PORT_ONLY | wrap/TB/DUT source | no `force` / `release` / `deposit` |

## Out of scope

Master ASTRA-09 production path. ASTRA-13. BOARD_PASS. LM06. wrap-route bit.
`PRODUCTION_TOP` freeze. ASTRA-09-R3 query OVF/SMOKE/UNREL promotion.
ASTRA-09-R4 sibling-ISO promotion. ASTRA-09-R5 sim-override inner-port ISO
promotion. Silicon UART. Patching frozen A09 leftover `ans=4`. Patching
frozen A09-R2 DUT. Patching frozen SGD.
