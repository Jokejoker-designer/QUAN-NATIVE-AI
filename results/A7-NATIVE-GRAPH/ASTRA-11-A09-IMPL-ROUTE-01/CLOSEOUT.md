# CLOSEOUT — ASTRA-11-A09-IMPL-ROUTE-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-11-A09-IMPL-ROUTE-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
TOP                  = a7ng_astra_11_a09_impl_wrap
DUT                  = a7ng_astra_09_integ_path
INSTANCE             = u_a09
PART                 = xc7a100tcsg324-1
PIN_CLK              = CLK100MHZ E3 10.000 ns
PIPE_CLK             = clk50u 20.000 ns (50.000 MHz) MMCM+BUFG
SYNTH                = PASS (0 errors / 0 critical warnings)
ROUTE                = COMPLETE (failed nets = 0)
WNS                  = 1.041 ns  (timing_route.rpt Design Timing Summary; Design State=Routed; clk50u)
TNS                  = 0.000 ns
WHS                  = 0.160 ns
THS                  = 0.000 ns
ROUTE_LUT            = 1305   (util_route.rpt Slice LUTs; Design State=Routed)
ROUTE_FF             = 1075
BRAM_TILE            = 0
DSP                  = 2      (DSP48E1 in u_sgd; on routed worst path)
SYNTH_LUT            = 5222   (util_synth.rpt; not the WNS quote)
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
write_bitstream      = not called
WNS_LT_0_EXPERIMENT  = not run (routed WNS >= 0)
Master_ASTRA-09 / Master_F3 / Master_ASTRA-06 / Master_ASTRA-10 / LM06 / BOARD_PASS / ASTRA-13 / ASTRA-11_SoC_UART = OPEN
```

## Evidence

- Raw routed timing: `timing_route.rpt` (authority for WNS)
- Raw routed util: `util_route.rpt` / `util_hier_route.rpt`
- Clocks / clock network: `clocks_route.rpt` / `clock_util_route.rpt`
- Route status: `route_status.rpt`
- Synth (not the WNS quote): `util_synth.rpt` / `timing_synth.rpt`
- Extracts: `TIMING_EXTRACT.txt` / `UTIL_EXTRACT.txt`
- SHA freeze before impl: `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Vivado log: `vivado.log` (R1 copy); R0 kept as `vivado_fail_r0.log`
- Contract: `PREREG.md`

## Next dependency

Independent auditor of this impl/route bag. Do not open LM06, BOARD, DDR,
ASTRA-13, or Master F3 from this bag. PROGRAM=NO.
