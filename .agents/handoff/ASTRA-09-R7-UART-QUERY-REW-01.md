# ASTRA-09-R7-UART-QUERY-REW-01

Parent dispatch 2026-09-07 after auditor 20260907T0100Z ACCEPT_PARTIAL on ASTRA-09-R6-UART-ISO-PUBLIC-01.
R6 CLOSED_NARROW public-port ISO on a **new ISO-opcode DUT**. Residual 5: UART **query tokens / reward** must hit inner `u_sgd` through **A09-R2 exported** `tok_*` / `rew_v_i` / fire/retire — not CMD_ISO on a separate iso_pub. Frozen A09-R2 not patched. New named wrap. No force/release/deposit.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-09-R6, frozen `a7ng_astra_09_r2_cand_ovf.sv`, frozen SGD. Instantiate A09-R2. New wrap/TB.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-09-R7-UART-QUERY-REW-01/ACK.json

## One unknown

Can UART 8N1 drive A09-R2 **query** (tokens+fire) then **pending reward** (`rew_v_i`/`rew_i`/`txn`/`gen` as exported) so a two-proof smoke ANSWER is followed by inner w0 matching the frozen symmetric-law oracle — with no force, load_from_tb=0?

## Required

1. Instantiate frozen A09-R2 only (hash 15a919f1…). Wrap maps UART bytes onto `tok_*`, `fire_i`, `retire_i`, `rew_*` ports. Grep: no force/release/deposit.
2. Tests: smoke two-proof ans=4 p0=17; then matching txn reward -3 → inner w0=-5 (or PREREG oracle for that phi); overflow INCOMP ans=0; UNREL no stale.
3. ISO opcode on a second DUT is **out of scope** (already R6). This bag is query-learn public path.
4. PRODUCTION_TOP=UNKNOWN. PROGRAM=NO.

SHA including .svh before xvlog. One corrective if FAIL. AXI plant for facts is allowed if labeled fixture (as R3).
