# RESULTS — ASTRA-10B OOC glued a7ng_astra09_pipe

```text
GATE     = ASTRA-10B-OOC-ASTRA09-PIPE
TOP      = a7ng_astra09_pipe
PART     = xc7a100tcsg324-1
SYNTH    = ASTRA10B_OOC_SYNTH_DONE
LAW_SEL  = 1 (qse-v2-role-00)
RESULT   = PASS_NARROW (OOC synth; not impl/route/fullchip)
BIT      = NO
PROGRAM  = NO
COM12    = UNTOUCHED
```

| Resource | 10B glued pipe | 10 pre-glue unified | Avail |
|----------|---------------:|--------------------:|------:|
| LUT | 3707 (5.85%) | 2966 | 63400 |
| FF | 2364 (1.86%) | 1386 | 126800 |
| BRAM | 0 | 0 | 135 |
| DSP | 2 | 2 | 240 |

Instance cells (synth): `u_sp` 4375 (role extract 3116 + walker 1217), `u_eng` 1417, `u_sgd` 1154, `u_cmp` 79.

WNS not claimed (HD.CLK_SRC unset, OOC). 0 errors, 0 critical warnings.

## Not claimed

Impl, route, bitstream, fullchip + LM06 + MIG, Gate14, board, NLU.
