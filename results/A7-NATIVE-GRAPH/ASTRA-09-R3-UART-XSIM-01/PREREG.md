# PREREG — ASTRA-09-R3-UART-XSIM-01

Frozen before xvlog. PROGRAM=NO. No board. No JTAG/xsdb/COM12/bitstream.
Does not edit ASTRA-11-A09R2-IMPL-ROUTE-01 / ASTRA-SOC-RTP-WRAP-UART-XSIM /
ASTRA-09-R2-CAND-OVF-01 / ASTRA-09-INTEGRATED-PATH-01 / ASTRA-12* /
ASTRA-11-A09-IMPL-ROUTE-01 / F2R-* / F3-* / ASTRA-06-* bags or frozen RTL
(`a7ng_astra_09_integ_path.sv/.svh`, `a7ng_astra_09_r2_cand_ovf.sv/.svh`,
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv`). Does not rerun those bags' `run_*.ps1`.
Does not open LM06 / BOARD / DDR / Master F3. Does not freeze PRODUCTION_TOP.
Does **not** claim ASTRA-SOC-RTP-WRAP-UART-XSIM MAGIC A2 results as this bag.

## Claim this bag may close

One named UART-side XSim (this bag only): a new wrap instantiates frozen
`a7ng_astra_09_r2_cand_ovf` (`15a919f1…`). Host UART 115200 8N1 drives tokens
(`load_from_tb=0`). Byte stream shows:

- smoke two-proof ANSWER `ans=4 p0=17 p1=34`
- CAND_CAP overflow INCOMP `ans=0 p0=0` (ntrunc visible)
- UNREL no stale `UNKNOWN ans=0 p0=0`

UNISIM MMCM or behavioral MMCM_STUB. Not silicon MMCM. Not BOARD_PASS.

## One unknown

Can a UART-side XSim (UNISIM or behavioral host) drive tokens into instantiated
A09-R2 and observe a smoke ANSWER / overflow INCOMP on the byte stream — with
`load_from_tb=0` — without claiming BOARD_PASS?

## Registered caps

```text
DUT_MODULE      = a7ng_astra_09_r2_cand_ovf (instantiated, not patched)
WRAP            = a7ng_astra_09_r3_uart_wrap (bag-local; not PRODUCTION_TOP)
CAND_CAP        = 16
MAX_PATH        = 4
OVF_PLANT_N     = 20   (must be > CAND_CAP)
UART            = 115200 8N1
CLK_PIN         = CLK100MHZ 10 ns → MMCM 50 MHz pipe
MAGIC           = A2
EOL             = 0x0A
SMOKE           = "pump requires indirect\n" → ANSWER ans=4 p0=17 p1=34
OVF             = same query on N=20 plant → ST_INCOMP=6 ans=0 p0=0
UNREL           = "payroll tax form\n" on smoke plant → UNKNOWN ans=0 p0=0
LOAD_FROM_TB    = 0
FROZEN_A09R2    = 15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23
FROZEN_A09      = 9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c
```

## Tests

| Tag | Setup | Expect on UART frame |
|-----|-------|----------------------|
| OVF_UART | sw plant=OVF; query smoke string | MAGIC A2; st=6 ans=0 p0=0 tbl=0; ntrunc!=0; not ANSWER 4 |
| SMOKE_UART | sw plant=SMOKE; same query after OVF retire | MAGIC A2; st=0 ans=4 p0=17 p1=34 tbl=0 npath>=2 |
| UNREL_UART | smoke plant; `payroll tax form\n` | MAGIC A2; st=1 ans=0 p0=0 tbl=0 |
| HIER_TBL0 | hierarchical `load_from_tb_o` | 0 on all three |

## Out of scope

Master ASTRA-09 production path. ASTRA-13. BOARD_PASS. LM06. wrap-route bit.
`PRODUCTION_TOP` freeze. ASTRA-SOC-RTP-WRAP-UART-XSIM promotion. DDR/MIG.
Patching frozen A09 leftover `ans=4`. Patching frozen A09-R2 DUT.
