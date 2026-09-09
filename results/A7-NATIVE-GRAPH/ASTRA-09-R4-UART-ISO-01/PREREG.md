# PREREG — ASTRA-09-R4-UART-ISO-01

Frozen before xvlog. PROGRAM=NO. No board. No JTAG/xsdb/COM12/bitstream.
Does not edit ASTRA-09-R3-UART-XSIM-01 / ASTRA-12-R3-UART-WRAP-CANDIDATES-01 /
ASTRA-11-A09R3-UART-* / ASTRA-09-R2-CAND-OVF-01 / ASTRA-09-INTEGRATED-PATH-01 /
ASTRA-12* / ASTRA-11-A09-IMPL-ROUTE-01 / F2R-* / F3-* / ASTRA-06-* bags or
frozen RTL (`a7ng_astra_09_integ_path.sv/.svh`, `a7ng_astra_09_r2_cand_ovf.sv/.svh`,
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv`). Does not rerun those bags' `run_*.ps1`.
Does not open LM06 / BOARD / DDR / Master F3. Does not freeze PRODUCTION_TOP.
Does **not** claim ASTRA-09-R3 MAGIC A2 query frames as this bag.

## Claim this bag may close

One named UART-facing ISO XSim (this bag only): a new wrap instantiates frozen
`a7ng_astra_09_r2_cand_ovf` (`15a919f1…`) and frozen
`a7ng_shared_rank_sgd_q8_sym_f2r2` (`b66ef328…`). Host UART 115200 8N1 delivers
an isolated SGD command (`load_from_tb=0`). Byte stream / hierarchical `w_o`
shows:

- ISO_P3: x[0]=50 rew=+3 → dw0=+5 (w0=+5, w1=0, viso=0)
- ISO_M3: x[0]=64 rew=-3 → dw0=-6 (w0=-6, w1=0, viso=0)

UNISIM MMCM or behavioral MMCM_STUB. Not silicon MMCM. Not BOARD_PASS.

## One unknown

Can UART 8N1 (or the existing UART wrap path) deliver an isolated SGD update
x[0]=50 rew=+3 and show w0=+5 (and x[0]=64 rew=-3 → w0=-6) on the result stream
or hierarchical w_o — with load_from_tb=0 — without claiming BOARD_PASS?

## Registered caps

```text
DUT_MODULE      = a7ng_astra_09_r2_cand_ovf (instantiated, not patched)
ISO_SGD         = a7ng_shared_rank_sgd_q8_sym_f2r2 (instantiated, not patched)
WRAP            = a7ng_astra_09_r4_uart_iso_wrap (bag-local; not PRODUCTION_TOP)
UART            = 115200 8N1
CLK_PIN         = CLK100MHZ 10 ns → MMCM 50 MHz pipe
CMD_ISO         = 0xA5
MAGIC           = A2
EOL             = 0x0A
ISO_P3          = cmd A5 32 03 0A  → w0=+5 viso=0 w1=0
ISO_M3          = after wrap reset; cmd A5 40 FD 0A → w0=-6 viso=0 w1=0
LOAD_FROM_TB    = 0
FROZEN_A09R2    = 15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23
FROZEN_A09      = 9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c
FROZEN_SGD      = b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac
```

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | UART ISO cmd x0=50 rew=+3 from w=0 | UART frame w0=+5 viso=0 w1=0 tbl=0; hier wiso[0]=+5 |
| ISO_M3_X64_DW6 | wrap reset (w=0); UART ISO cmd x0=64 rew=-3 | UART frame w0=-6 viso=0 w1=0 tbl=0; hier wiso[0]=-6 |
| HIER_TBL0 | hierarchical `load_from_tb_o` | 0 on both ISO frames |

## Out of scope

Master ASTRA-09 production path. ASTRA-13. BOARD_PASS. LM06. wrap-route bit.
`PRODUCTION_TOP` freeze. ASTRA-09-R3 query OVF/SMOKE/UNREL promotion.
Silicon UART. Patching frozen A09 leftover `ans=4`. Patching frozen A09-R2 DUT.
Patching frozen SGD.
