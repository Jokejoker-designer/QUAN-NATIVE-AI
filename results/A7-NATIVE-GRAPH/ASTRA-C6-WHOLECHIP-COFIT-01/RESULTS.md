# RESULTS — ASTRA-C6-WHOLECHIP-COFIT-01

```text
GATE            = ASTRA-C6-WHOLECHIP-COFIT-01
MARKER          = ASTRA_C6_WHOLECHIP_COFIT_PASS
RESULT          = PASS_THIS_GATE_ONLY
C6_MASTER       = OPEN
BOARD_PASS      = REJECT
PROGRAM         = NO
A09             = NOT_TOP
PART            = xc7a100tcsg324-1
TOP             = a7ng_astra_c6_wholechip
DUT             = u_c5 a7ng_astra_c5_prod_top
MIG             = u_mig mig_native_wrap official user_design
VIVADO          = 2026.1
MODE            = in_context synth/place/route
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
PERSIST_SCHEMA_VERSION = NOT_FROZEN
```

GOLDEN hashed before first Vivado (`5f20c4d0f3572ae6df695e6c89d62d00f5461f17bb13a1551d48cd59bc7e9e9a`). KEEP C0/C1/C2 hashes MATCH. GOLDEN was not regenerated after Vivado.

## Raw post-route letters (`ROUTE_LETTERS.txt` / `TIMING_EXTRACT.txt` / `UTIL_EXTRACT.txt`)

```text
WNS=0.074 TNS=0.000 WHS=0.033 THS=0.000
UNROUTED=0 FAILED_ROUTE=0 DRC_ERROR_FATAL=0 CRITICAL_UNCONSTRAINED=0
LUT=8877 FF=6840 BRAM_TILE=0 DSP=0 DESIGN_STATE=Routed
CLASS_device_fit HIT
CLASS_wns_ge0 HIT
CLASS_tns_0 HIT
CLASS_whs_ge0 HIT
CLASS_ths_0 HIT
CLASS_unrouted_0 HIT
CLASS_drc_clean HIT
CLASS_mig_user_design HIT
CLASS_c5_prod_inst HIT
CLASS_no_a09_top HIT
CLASS_no_program_hw HIT
CLASS_cdc_reviewed HIT
```

Preferred envelope vs routed util: LUT 8877 <= 40000, FF 6840 <= 50000, BRAM 0 <= 115, DSP 0 <= 32.

Unique bit SHA256 `3bfa1a899851e668be751f6577dbcdb698e983ba4dd9b9f7ec4b2555e9ca03d6`.
`program_scope=PINNED_SHA_e51bdca2_ONLY` — this bit was not programmed.

## Quality bound (do not promote)

Evidence class **POST_ROUTE**. Not BOARD. C5 UART baud remains the C5 sim localparam (8000/800), not silicon 115200. C4 head is compact V=64, not Master 90% LM. AXI from C5 is 1-beat modeled into official MIG. Independent auditor must hunt tautology before any Master stamp.
