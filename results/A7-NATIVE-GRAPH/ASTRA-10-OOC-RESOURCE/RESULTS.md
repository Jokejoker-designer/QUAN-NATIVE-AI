# RESULTS — ASTRA-10 OOC-RESOURCE

```text
GATE     = ASTRA-10-OOC-RESOURCE-RECONCILIATION
TOP      = a7ng_unified_pipe
PART     = xc7a100tcsg324-1
SYNTH    = ASTRA10_OOC_SYNTH_DONE
RESULT   = PASS_NARROW (OOC synth; not impl/route/fullchip)
BIT      = NO
PROGRAM  = NO
COM12    = UNTOUCHED
```

| Resource | Used | Avail | % |
|----------|-----:|------:|--:|
| LUT | 2966 | 63400 | 4.68 |
| FF | 1386 | 126800 | 1.09 |
| BRAM | 0 | 135 | 0 |
| DSP | 2 | 240 | 0.83 |

Instances: parse 2847, hop 1260, rank 1123 cells (synth instance report).
DSP=2 is sequential SGD MAC, not LM06 encoder. Not comparable as a drop-in vs U2R 36911 LUT / DSP=19 candidate.

Not claimed: WNS (no HD.CLK_SRC), impl, route, fullchip co-fit, bitstream.
