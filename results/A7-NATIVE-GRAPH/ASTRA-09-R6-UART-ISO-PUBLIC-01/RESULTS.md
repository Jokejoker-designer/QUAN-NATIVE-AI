# RESULTS — ASTRA-09-R6-UART-ISO-PUBLIC-01

PROGRAM=NO. No JTAG/COM12/bit. ASTRA-09-R5-UART-ISO-INNER-01 /
ASTRA-09-R4-UART-ISO-01 / ASTRA-09-R3-UART-XSIM-01 /
ASTRA-12-R3-UART-WRAP-CANDIDATES-01 / ASTRA-11-A09R3-UART-* /
ASTRA-09-R2-CAND-OVF-01 / ASTRA-09-INTEGRATED-PATH-01 / ASTRA-12* /
ASTRA-11-A09-IMPL-ROUTE-01 / F2R-* / F3-* / ASTRA-06-* bags not edited.
Frozen `a7ng_astra_09_integ_path.sv` / `a7ng_astra_09_r2_cand_ovf.sv` /
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv` not patched. Those bags' `run_*.ps1`
not rerun. LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened.
PRODUCTION_TOP remains UNKNOWN. Does **not** claim ASTRA-09-R5
sim-override inner-port frames as this bag.

```text
XSIM_MARKER      = ASTRA_09_R6_UART_ISO_PUBLIC_PASS
VERDICT_PROPOSED = PASS_NARROW (this bag only: UART-facing PUBLIC ISO of new named DUT inner u_sgd via module ports + learn FSM; +3 x0=50 → inner w0=+5; -3 x0=64 → inner w0=-6; load_from_tb=0; no sibling SGD; no force/release/deposit)
SIM_TIME         = 3471735 ns
FAIL             = 0
FIRST_DIVERGENCE = none
FAIL_R0          = xelab_fail_r0.log (VRFC 10-3818 shared integer k; one DUT loop-index corrective; marker on second xvlog/xelab/xsim)
CORRECTIVE       = 1
MMCM             = UNISIM_MMCME2_BASE (xelab -L unisims_ver; NOT silicon MMCM)
MMCM_STUB        = on disk, NOT xvlog'd on pass run
BIT              = NOT_BUILT
PROGRAM          = false
PRODUCTION_TOP   = UNKNOWN
NO_SIBLING_SGD   = 1
FORCE_PRESENT    = NO
FROZEN_A09R2     = UNUSED
```

## Path (this bag)

New named DUT `a7ng_astra_09_r6_iso_pub` instantiates frozen
`a7ng_shared_rank_sgd_q8_sym_f2r2` (`b66ef328…`) as inner `u_sgd` **only**.
Public ports: `iso_req_i` / `iso_x0_i` / `iso_rew_i`. DUT learn FSM
(`L_IDLE`→`L_GO`→`L_WAIT`) drives inner `go_upd_i` / `x_i` / `reward_i`
from those ports. Wrap `a7ng_astra_09_r6_uart_iso_public_wrap` UART FSM
parses `A5 x0 rew 0A` and pulses `iso_req`. Wrap/TB/DUT contain **no**
`force` / `release` / `deposit` (script grep `FORCE_PRESENT=NO` before
xvlog). Frozen `a7ng_astra_09_r2_cand_ovf` (`15a919f1…`) is **unused**
(not compiled as DUT; no public iso/go_upd/x/rew). Frozen leftover
`a7ng_astra_09_integ_path.sv` (`9fdbe0d6…`) is **not** instantiated.
UART 115200 8N1 on pin `CLK100MHZ` (10 ns). Result MAGIC A2 is serialized
from DUT `w_o[0]` (= inner `u_sgd.w_o[0]`). `load_v_i=0` /
`load_from_tb_o=0`. Wrap is **not** PRODUCTION_TOP. TB bit-bangs
`uart_txd_in` only.

## Raw XSim (`xsim.log`)

xsim v2026.1, session **Mon Sep 7 00:55:33–00:55:55 2026**, PID **13656**,
snapshot `a09r6iso`, `$finish` at **3471735 ns**. `%t` is 1 ps.

Compiled (`xelab.log` / `xsim.dir/work`): `unisims_ver.MMCME2_BASE` /
`BUFG`, `uart_rx(CLK_HZ=50000000)`, `uart_tx(CLK_HZ=50000000)`,
**`a7ng_shared_rank_sgd_q8_sym_f2r2`** (module of inner child),
**`a7ng_astra_09_r6_iso_pub`**, **`a7ng_astra_09_r6_uart_iso_public_wrap`**,
`tb_astra_09_r6_uart_iso_public`, `glbl`. **No**
`a7ng_astra_09_r2_cand_ovf.sdb`, **no** `a7ng_astra_09_integ_path.sdb`,
**no** `a7ng_astra_09_r3_uart_wrap.sdb`, **no**
`a7ng_astra_09_r4_uart_iso_wrap.sdb`, **no**
`a7ng_astra_09_r5_uart_iso_inner_wrap.sdb`, **no** `mmcm_stub`.

| Case | UART frame | Result |
|------|------------|--------|
| ISO_P3 | `a2 40 05 00 00 00 32 03 00 00 00 00 00 00 00 0a` | MAGIC A2; w0=+5 v=0 w1=0 x0=50 rew=+3 tbl=0; hier `u_r6.u_sgd.w_o[0]`=+5; pub_w0=+5 |
| ISO_M3 | `a2 40 fa ff 00 00 40 fd 00 00 00 00 00 00 00 0a` | MAGIC A2; w0=-6 v=0 w1=0 x0=64 rew=-3 tbl=0; hier `u_r6.u_sgd.w_o[0]`=-6; pub_w0=-6 |

Raw quotes:

```text
INNER_GO x0=50 rew=3 t=349285000
INNER_DONE w0=5 v=0 w1=0 tbl=0 pub_w0=5 t=350685000
FRAME ISO_P3 a2 40 05 00 00 00 32 03 00 00 00 00 00 00 00 0a
ISO_P3 w0=5 v=0 w1=0 x0=50 rew=3 tbl=0 iso=1 inner_w0=5 hier_sgd_w0=5 pub_w0=5 hier_tbl=0
PASS ISO_P3_X50_DW5
PASS ISO_M3_PRE_W0
INNER_GO x0=64 rew=-3 t=2085225000
INNER_DONE w0=-6 v=0 w1=0 tbl=0 pub_w0=-6 t=2086625000
FRAME ISO_M3 a2 40 fa ff 00 00 40 fd 00 00 00 00 00 00 00 0a
ISO_M3 w0=-6 v=0 w1=0 x0=64 rew=-3 tbl=0 iso=1 inner_w0=-6 hier_sgd_w0=-6 pub_w0=-6 hier_tbl=0
PASS ISO_M3_X64_DW6
ASTRA_09_R6_UART_ISO_PUBLIC_PASS
```

HIER `load_from_tb_o=0` on both. Inner `u_sgd.w_o[0]` **is** the pass
number (`pub_w0` matches). Marker present. Zero `FAIL` lines.

Byte pack (this wrap): `[0]=MAGIC A2`, `[1]={tbl,iso,6'd0}`, `[2:3]=inner w0 LE`,
`[4:5]=inner v LE`, `[6]=x0`, `[7]=rew8`, `[8:9]=inner w1 LE`,
`[14]={7'd0,tbl}`, `[15]=EOL 0x0A`.

UART-real: ISO_P3 `CMD_SENT` t=6285000 → `INNER_GO` t=349285000 (Δ≈343 µs ≈
4×10×8680 ns 8N1). Byte spacing n=1→n=2: 86840000 ps = 86840 ns.

One `INNER_GO` per ISO (DUT FSM pulses `iso_req` once; inner `go_upd` once).

## Hashes

SHA freeze BEFORE xvlog `2026-09-07T00:55:25.9945858+07:00`.
xsim session Mon Sep 7 00:55:33–00:55:55 2026 PID **13656**.
Compiled + `.svh` pre/post **7/7 MATCH** (includes bag
`a7ng_astra_09_r6_iso_pub.svh`). Frozen A09 / A09-R2 `.svh` hashed KEEP
before xvlog. xsim.log SHA256
`6faf6f9862d634e9a6a985336ae8b822f9a4f46f2e1c1dbb09e8e0c7b3935be2`.
Frozen A09-R2 `15a919f1…` **unchanged** (unused). Frozen A09 `9fdbe0d6…`
**unchanged**. Frozen SGD `b66ef328…` **unchanged**. ASTRA-09-R5 bag
`xsim.log` still session **Mon Sep 7 00:34:46** PID **11336**. R5 wrap KEEP
hash `ee02935e…`. ASTRA-09-R4 bag `xsim.log` still session **Mon Sep 7
00:12:53** PID **47704**. R4 wrap KEEP hash `cc8ffdaa…`.

## Not claimed

Silicon MMCM (this is unisim behavioral `MMCME2_BASE`). BOARD_PASS.
ASTRA-13. COM12 program. wrap-route bit. PRODUCTION_TOP freeze.
ASTRA-09-R5 sim-override inner-port ISO close (different wrap, different
unknown). ASTRA-09-R4 sibling-ISO close. ASTRA-09-R3 OVF/SMOKE/UNREL close.
Frozen A09-R2 public token/reward ISO (A09-R2 unused this bag).
Master ASTRA-09 / F3 / ASTRA-06 / LM06.

## Open (unchanged)

Master ASTRA-09 production path. Master F3 10pp / CI. Master ASTRA-06
(schemaV2 DDR / NVM). LM06. BOARD_PASS. ASTRA-13. PRODUCTION_TOP identity.
Do **not** call this BOARD_PASS, ASTRA-13, or a frozen production top.
Manager independently accepts. Do not autonomously open the next gate.
