# CLOSEOUT — ASTRA-10-RESOURCE-BOUND-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-10-RESOURCE-BOUND-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
TOP                  = a7ng_astra_10_resource_wrap
DUT                  = a7ng_astra_09_integ_path
INSTANCE             = u_a09
PART                 = xc7a100tcsg324-1
CLOCK                = clk50 20.000 ns (50.000 MHz)
SYNTH                = PASS (0 errors / 0 critical warnings)
LUT                  = 5178   (util_synth.rpt Slice LUTs*; Design State=Synthesized)
FF                   = 4155   (util_synth.rpt Slice Registers)
BRAM_TILE            = 0      (util_synth.rpt Block RAM Tile; ram_synth.rpt BlockRAM=0)
DSP                  = 2      (util_synth.rpt DSPs / DSP48E1 in u_sgd)
WNS                  = 2.283 ns  (timing_synth.rpt Design Timing Summary; clk50)
TNS                  = 0.000 ns
WHS                  = 0.256 ns
THS                  = 0.000 ns
OPT_LUT              = 5174   (util_opt.rpt; not the primary quote)
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
write_bitstream      = not called
Master_ASTRA-09 / Master_F3 / Master_ASTRA-06 / LM06 / BOARD_PASS / ASTRA-13 / ASTRA-11_SoC = OPEN
```

## Evidence

- Raw synth util: `util_synth.rpt`
- Raw synth timing: `timing_synth.rpt`
- Hierarchical instance: `util_hier_synth.rpt` (`u_a09` LUT=5178)
- Opt reports: `util_opt.rpt` / `timing_opt.rpt`
- Extracts: `UTIL_EXTRACT.txt` / `TIMING_EXTRACT.txt`
- SHA freeze (compiled + .svh + xdc + tcl): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Vivado log: `vivado.log` (R1); R0 kept as `vivado_fail_r0.log`
- Contract: `PREREG.md`

## Next dependency

Independent auditor of this resource-bound bag. Do not open LM06, BOARD, DDR,
or Master F3 from this bag. PROGRAM=NO.
