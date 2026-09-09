# RESULTS — ASTRA-09-R7-UART-QUERY-REW-01

PROGRAM=NO. No JTAG/COM12/bit. ASTRA-09-R6-UART-ISO-PUBLIC-01 /
ASTRA-09-R5-UART-ISO-INNER-01 / ASTRA-09-R4-UART-ISO-01 /
ASTRA-09-R3-UART-XSIM-01 / ASTRA-12-R3-UART-WRAP-CANDIDATES-01 /
ASTRA-11-A09R3-UART-* / ASTRA-09-R2-CAND-OVF-01 /
ASTRA-09-INTEGRATED-PATH-01 / ASTRA-12* / ASTRA-11-A09-IMPL-ROUTE-01 /
F2R-* / F3-* / ASTRA-06-* bags not edited. Frozen
`a7ng_astra_09_integ_path.sv` / `a7ng_astra_09_r2_cand_ovf.sv` /
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv` not patched. Those bags' `run_*.ps1`
not rerun. LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened.
PRODUCTION_TOP remains UNKNOWN. Does **not** claim ASTRA-09-R6 ISO-opcode
results as this bag.

```text
XSIM_MARKER      = ASTRA_09_R7_UART_QUERY_REW_PASS
VERDICT_PROPOSED = PASS_NARROW (this bag only: UART 8N1 query tokens+fire then matching-txn rew=-3 through frozen A09-R2 exported ports; smoke ans=4 p0=17 then inner w0=-5; OVF INCOMP ans=0; UNREL no stale; load_from_tb=0; FORCE_PRESENT=NO)
SIM_TIME         = 11975335 ns
FAIL             = 0
FIRST_DIVERGENCE = none
FAIL_R0          = xsim_fail_r0.log (IDLE_TIMEOUT / wrap re-TX after retire cleared sent while result_v still 1; one wrap corrective: keep sent until !result_v)
CORRECTIVE_PASSES= 1
MMCM             = UNISIM_MMCME2_BASE (xelab -L unisims_ver; NOT silicon MMCM)
MMCM_STUB        = on disk, NOT xvlog'd
BIT              = NOT_BUILT
PROGRAM          = false
PRODUCTION_TOP   = UNKNOWN
FORCE_PRESENT    = NO
```

## Path (this bag)

New named wrap `a7ng_astra_09_r7_uart_query_rew_wrap` instantiates frozen
`a7ng_astra_09_r2_cand_ovf` (`15a919f1…`) as `u_a09r2`. Frozen leftover
`a7ng_astra_09_integ_path.sv` (`9fdbe0d6…`) is **not** instantiated and
**not** patched. Frozen SGD (`b66ef328…`) is instantiated **inside A09-R2
only** (`u_a09r2.u_sgd`). No second ISO-opcode DUT. Bag-local labeled AXI
plant (`a7ng_astra_09_r7_axi_plant`) is **not** silicon BRAM. UART 115200
8N1 on pin `CLK100MHZ` (10 ns). Wrap maps query bytes onto `tok_*`/`fire_i`
and command `A6 rew txn gen epoch 0A` onto exported `rew_v_i`/`rew_i`/
`rew_txn_i`/`rew_gen_i`/`rew_epoch_i`. Host `A7 0A` pulses `retire_i`.
Wrap/TB/plant/svh contain no `force`/`release`/`deposit`. Wrap is **not**
PRODUCTION_TOP. `load_from_tb_o=0`.

PREREG oracle: smoke facts conf=200/200 → `qphi0=200>>2=50`. From-zero
`v=0`, rew=`-3`, `err=-768`, `dw0=rsh40(-768*50,13)=-5`.

## Raw XSim (`xsim.log`)

xsim v2026.1, session **Mon Sep 7 01:24:47–01:26:05 2026**, PID **46472**,
snapshot `a09r7qr`, `$finish` at **11975335 ns**. `%t` is 1 ps.

Compiled (`xelab.log` / `xsim.dir/work`): `unisims_ver.MMCME2_BASE` /
`BUFG`, `uart_rx(CLK_HZ=50000000)`, `uart_tx(CLK_HZ=50000000)`,
**`a7ng_astra_09_r2_cand_ovf_default`**, **`a7ng_shared_rank_sgd_q8_sym_f2r2`**
(once), `a7ng_astra_09_r7_uart_query_rew_wrap`, `a7ng_astra_09_r7_axi_plant`,
`tb_astra_09_r7_uart_query_rew`, `glbl`. **No** `a7ng_astra_09_integ_path.sdb`,
**no** `a7ng_astra_09_r6_iso_pub.sdb`, **no** `mmcm_stub`.

| Case | UART frame / log | Result |
|------|------------------|--------|
| SMOKE_UART | `a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a` | MAGIC A2; st=0 ans=4 p0=17 p1=34 npath=2 tbl=0; phi0=50; inner w0=0; pend_acc=1 txn=1 gen=1 ep=7 |
| REW_M3_W0 | `a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a` | OBS tag 57; UART w0=-5 (`fb ff`); phi0=50 (`32`); nupd=1 nbad=0 nstale=0; hier `u_a09r2.u_sgd.w_o[0]`=-5; pub w0=-5; tbl=0 |
| OVF_UART | `a2 46 00 00 00 00 00 00 00 00 00 00 04 00 00 0a` | MAGIC A2; st=6 ans=0 p0=0 tbl=0 ntrunc=4 rov=1 wov=0; not ANSWER 4 |
| UNREL_UART | `a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a` | MAGIC A2; st=1 ans=0 p0=0 npath=0 tbl=0 |

`REW_PULSE rew=-3 txn=1 gen=1 ep=7 acc=1` then `INNER_UPD rew=-3 phi0=50`.
HIER `load_from_tb_o=0` on all frames. Marker present. Zero `FAIL` lines.

Query pack (this wrap): `[0]=MAGIC A2`, `[1]={tbl,r_ovf,w_ovf,pend_acc,status}`,
ans/p0/p1 LE 20-bit, `[11]=npath`, `[12:13]=ntrunc`, `[14]={7'd0,tbl}`,
`[15]=EOL 0x0A`. OBS pack: `[2:3]=w0 LE`, `[4]=phi0`, `[5]=nupd`, `[14]=0x57`.

## Hashes

SHA freeze BEFORE xvlog `2026-09-07T01:24:40.2260107+07:00`.
xsim session Mon Sep 7 01:24:47–01:26:05 2026 PID **46472**.
Compiled + `.svh` pre/post **19/19 MATCH** (includes bag
`a7ng_astra_09_r7_uart_query_rew.svh`, frozen A09-R2 `.svh`, frozen A09 `.svh`).
xsim.log SHA256 `7cdffce10f07ff20cf2e1866f6275f6c5f4738f01aee0741bf4895d989b256d5`.
Frozen A09-R2 `15a919f1…` **unchanged** (compiled). Frozen A09 `9fdbe0d6…`
**unchanged** (not compiled). Frozen SGD `b66ef328…`. ASTRA-09-R6 bag
`xsim.log` still session **00:55:33**. ASTRA-09-R3 bag `xsim.log` still
session **21:45:37**.

## Not claimed

Silicon MMCM (this is unisim behavioral `MMCME2_BASE`). BOARD_PASS.
ASTRA-13. COM12 program. wrap-route bit. PRODUCTION_TOP freeze.
ASTRA-09-R6 ISO-opcode DUT close. ASTRA-09-R5 sim-override inner ISO.
ASTRA-09-R4 sibling-ISO. Master ASTRA-09 / F3 / ASTRA-06 / LM06.

## Open (unchanged)

Master ASTRA-09 production path / SoC UART. Master F3 10pp / CI.
Master ASTRA-06 (schemaV2 DDR / NVM). LM06. BOARD_PASS. ASTRA-13.
PRODUCTION_TOP identity. Do **not** call this BOARD_PASS, ASTRA-13, or a
frozen production top. Manager independently accepts. Do not autonomously
open the next gate.
