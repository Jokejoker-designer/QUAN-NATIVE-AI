# ASTRA-07-SCALE-NARROW-01

Parent dispatch 2026-09-06 after auditor 20260906T1500Z ACCEPT_PARTIAL on ASTRA-12-R2-TOP-CANDIDATES-01.
PRODUCTION_TOP stays UNKNOWN (parent will not silent-freeze). ASTRA-13 stays BLOCKED. Board is plugged; PROGRAM=NO.

Next Master residual that still fits XSim: **ASTRA-07 scale-narrow** — overflow/INCOMP on the A09 integrated path when candidate/posting volume exceeds the registered cap. Not 65536 overnight. Not 800k. Not BOARD.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-12*, ASTRA-11*, ASTRA-09, F2R-*, F3-*, ASTRA-06-* bags. Do not patch a7ng_astra_09_integ_path.sv. Instantiate it or a new named scale TB around it. Do not rerun prior impl/xsim wipe scripts. No bitstream.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-07-SCALE-NARROW-01/ACK.json

## One unknown

When posting-list / candidate count exceeds the DUT’s registered CAND_CAP (or MAX_PATH), does the FPGA declare overflow/INCOMP without a stale ANSWER — and does a legal two-proof smoke still pass on the same DUT?

## Required

1. PREREG: CAND_CAP, MAX_PATH, overflow plant size (must be > cap), expected status INCOMP/ovf, smoke still two legal hops.
2. Tests: overflow plant → no ANSWER 4 from truncated leftover; UNREL no stale; ISO +5 if SGD in path; smoke two-proof still works after overflow case (or after reset).
3. Instantiate frozen SGD + A09 integrator (or named wrap). New TB. SHA including .svh before xvlog.
4. Do not claim ASTRA-07 65536/800k, Master F3 10pp, BOARD, LM06.

PROGRAM=NO. No JTAG/xsdb/COM12/write_bitstream.
