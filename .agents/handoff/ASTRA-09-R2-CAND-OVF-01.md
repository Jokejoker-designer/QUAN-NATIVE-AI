# ASTRA-09-R2-CAND-OVF-01

Parent dispatch 2026-09-06 after auditor 20260906T1530Z ACCEPT_PARTIAL on ASTRA-07-SCALE-NARROW-01.
That wrap CLOSED_NARROW. Frozen A09 leftover still `ans=4` on CAND_CAP overflow (known hole). Residual 3: a **new named** A09 revision may close ntrunc→INCOMP. Do not patch frozen `a7ng_astra_09_integ_path.sv`.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-07-SCALE-NARROW-01, ASTRA-09-INTEGRATED-PATH-01, or `a7ng_astra_09_integ_path.sv`. Copy to a new module name if needed. Do not rerun prior scripts that wipe logs.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-09-R2-CAND-OVF-01/ACK.json

## One unknown

On the **new named** integrator (not the frozen A09 file), when walker truncates / `nc==CAND_CAP` with leftover legal 2-hops, does **the DUT itself** publish INCOMP `ans=0` (not a wrap around frozen A09 leftover `ans=4`)?

## Required

1. New named RTL. Frozen A09 hash `9fdbe0d6…` unchanged.
2. Plant N>CAND_CAP like ASTRA-07: DUT status INCOMP, ans=0, p0=0. Hierarchical peek of this DUT must not show ans=4.
3. MAX_PATH 5>4 still INCOMP. Smoke two-proof after overflow still ANSWER 4. UNREL no stale. ISO +5. load_from_tb=0.
4. Do not close Master ASTRA-07 65536/800k, BOARD, LM06, ASTRA-13.

SHA including .svh before xvlog. One corrective if FAIL. PROGRAM=NO.
