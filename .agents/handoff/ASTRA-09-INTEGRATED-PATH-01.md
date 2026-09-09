# ASTRA-09-INTEGRATED-PATH-01

Parent dispatch 2026-09-06 after auditor 20260906T1235Z ACCEPT_PARTIAL on ASTRA-06-R4-SESS-REUSE-01.
On-chip persist leftovers that fit XSim are CLOSED_NARROW (journal, high-id, N=1, CAP_N=2, sess reuse). Master ASTRA-06 DDR/NVM remains OPEN. Parent does **not** open DDR, LM06, or BOARD (board is plugged; PROGRAM=NO).

Next Master residual that still fits XSim: **ASTRA-09 integrated path** — one named DUT, one TB, query → retrieve → legal 2-hop proofs → shared rank → pending txn → scalar reward, plus at least one semantic refuse and one AXI abort/drain smoke.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit F2R-*, F3-*, ASTRA-06-* bags or frozen RTL. Instantiate frozen SGD `a7ng_shared_rank_sgd_q8_sym_f2r2`. New named integrator only. Do not rerun prior run scripts.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-09-INTEGRATED-PATH-01/ACK.json

## One unknown

Can a single FPGA path run retrieval→proof→rank→pending→reward **and** refuse a conflict/wrong-object **and** abort/drain one AXI fault — without load_from_tb and without claiming BOARD/LM06?

## Required

1. One DUT: QSE+sparse retrieve+2-hop enum+symmetric SGD rank+pending {sess,gen,txn,phi}+handshake latch.
2. Tests (raw log): smoke two legal 2-hops + reward dw matches oracle; CONFLICT or wrong-object does not rank away contradiction; one AXI timeout/SLVERR drain without stale proof; UNREL no stale; ISO +5.
3. Do not close Master F3 10pp, persist DDR, LM06, BOARD, ASTRA-13.
4. PROGRAM=NO. No JTAG/xsdb/COM12/bitstream even though the board is plugged.

SHA including .svh before xvlog. Raw XSim. One corrective if FAIL. No golden edits.
