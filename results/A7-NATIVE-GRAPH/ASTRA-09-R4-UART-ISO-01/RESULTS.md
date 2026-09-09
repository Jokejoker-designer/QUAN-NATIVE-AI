# RESULTS — ASTRA-09-R4-UART-ISO-01

PROGRAM=NO. No JTAG/COM12/bit. ASTRA-09-R3-UART-XSIM-01 /
ASTRA-12-R3-UART-WRAP-CANDIDATES-01 / ASTRA-11-A09R3-UART-* /
ASTRA-09-R2-CAND-OVF-01 / ASTRA-09-INTEGRATED-PATH-01 / ASTRA-12* /
ASTRA-11-A09-IMPL-ROUTE-01 / F2R-* / F3-* / ASTRA-06-* bags not edited.
Frozen `a7ng_astra_09_integ_path.sv` / `a7ng_astra_09_r2_cand_ovf.sv` /
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv` not patched. Those bags' `run_*.ps1`
not rerun. LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened.
PRODUCTION_TOP remains UNKNOWN. Does **not** claim ASTRA-09-R3 MAGIC A2
query frames as this bag.

```text
XSIM_MARKER      = ASTRA_09_R4_UART_ISO_PASS
VERDICT_PROPOSED = PASS_NARROW (this bag only: UART-facing ISO of frozen A09-R2 SGD law; +3 x0=50 → w0=+5; -3 x0=64 → w0=-6; load_from_tb=0)
SIM_TIME         = 3471575 ns
FAIL             = 0
FIRST_DIVERGENCE = none
FAIL_R0          = none (marker on first xvlog/xelab/xsim)
MMCM             = UNISIM_MMCME2_BASE (xelab -L unisims_ver; NOT silicon MMCM)
MMCM_STUB        = on disk, NOT xvlog'd
BIT              = NOT_BUILT
PROGRAM          = false
PRODUCTION_TOP   = UNKNOWN
```

## Path (this bag)

New named wrap `a7ng_astra_09_r4_uart_iso_wrap` instantiates frozen
`a7ng_astra_09_r2_cand_ovf` (`15a919f1…`) as `u_a09r2` and frozen
`a7ng_shared_rank_sgd_q8_sym_f2r2` (`b66ef328…`) as `u_iso`. Frozen leftover
`a7ng_astra_09_integ_path.sv` (`9fdbe0d6…`) is **not** instantiated and
**not** patched. UART 115200 8N1 on pin `CLK100MHZ` (10 ns) delivers ISO
command `A5 x0 rew 0A`. Result MAGIC A2 is serialized on `uart_rxd_out`.
`load_v_i=0` / `iso_load=0` / `load_from_tb_o=0`. Wrap is **not**
PRODUCTION_TOP. A09-R2 query path is idle this bag (ISO is isolated SGD).

## Raw XSim (`xsim.log`)

xsim v2026.1, session **Mon Sep 7 00:12:53–00:13:17 2026**, PID **47704**,
snapshot `a09r4iso`, `$finish` at **3471575 ns**. `%t` is 1 ps.

Compiled (`xelab.log` / `xsim.dir/work`): `unisims_ver.MMCME2_BASE` /
`BUFG`, `uart_rx(CLK_HZ=50000000)`, `uart_tx(CLK_HZ=50000000)`,
**`a7ng_astra_09_r2_cand_ovf_default`**, **`a7ng_shared_rank_sgd_q8_sym_f2r2`**,
**`a7ng_astra_09_r4_uart_iso_wrap`**, `tb_astra_09_r4_uart_iso`, `glbl`.
**No** `a7ng_astra_09_integ_path.sdb`, **no** `a7ng_astra_09_r3_uart_wrap.sdb`,
**no** `mmcm_stub`.

| Case | UART frame | Result |
|------|------------|--------|
| ISO_P3 | `a2 40 05 00 00 00 32 03 00 00 00 00 00 00 00 0a` | MAGIC A2; w0=+5 viso=0 w1=0 x0=50 rew=+3 tbl=0; hier wiso[0]=+5 |
| ISO_M3 | `a2 40 fa ff 00 00 40 fd 00 00 00 00 00 00 00 0a` | MAGIC A2; w0=-6 viso=0 w1=0 x0=64 rew=-3 tbl=0; hier wiso[0]=-6 |

Raw quotes:

```text
ISO_P3 w0=5 viso=0 w1=0 x0=50 rew=3 tbl=0 iso=1 hier_w0=5 hier_tbl=0 a09_w0=0
PASS ISO_P3_X50_DW5
ISO_M3 w0=-6 viso=0 w1=0 x0=64 rew=-3 tbl=0 iso=1 hier_w0=-6 hier_tbl=0 a09_w0=0
PASS ISO_M3_X64_DW6
ASTRA_09_R4_UART_ISO_PASS
```

HIER `load_from_tb_o=0` on both. A09-R2 `w_o[0]` stays 0 (ISO is `u_iso`, not
TB weight-load of A09-R2). Marker present. Zero `FAIL` lines.

Byte pack (this wrap): `[0]=MAGIC A2`, `[1]={tbl,iso,6'd0}`, `[2:3]=w0 LE`,
`[4:5]=viso LE`, `[6]=x0`, `[7]=rew8`, `[8:9]=w1 LE`, `[14]={7'd0,tbl}`,
`[15]=EOL 0x0A`.

UART-real: ISO_P3 `CMD_SENT` t=6285000 → `ISO_GO` t=349265000 (Δ≈343 µs ≈
4×10×8680 ns 8N1). Byte spacing n=1→n=2: 86840000 ps = 86840 ns.

## Hashes

SHA freeze BEFORE xvlog `2026-09-07T00:12:46.6497405+07:00`.
xsim session Mon Sep 7 00:12:53–00:13:17 2026 PID **47704**.
Compiled + `.svh` pre/post **17/17 MATCH** (includes
`a7ng_astra_09_r2_cand_ovf.svh` and frozen `a7ng_astra_09_integ_path.svh`).
xsim.log SHA256 `523cdf657f3f992ee8a4181d5408d8a8846a974390fd3265c6125cddc194eee0`.
Frozen A09-R2 `15a919f1…` **unchanged**. Frozen A09 `9fdbe0d6…` **unchanged**.
Frozen SGD `b66ef328…` **unchanged**. ASTRA-09-R3 bag `xsim.log` still session
**Sun Sep 6 21:45:37** PID **19596**.

## Not claimed

Silicon MMCM (this is unisim behavioral `MMCME2_BASE`). BOARD_PASS.
ASTRA-13. COM12 program. wrap-route bit. PRODUCTION_TOP freeze.
ASTRA-09-R3 OVF/SMOKE/UNREL close (different wrap, different unknown).
Master ASTRA-09 / F3 / ASTRA-06 / LM06.

## Open (unchanged)

Master ASTRA-09 production path. Master F3 10pp / CI. Master ASTRA-06
(schemaV2 DDR / NVM). LM06. BOARD_PASS. ASTRA-13. PRODUCTION_TOP identity.
Do **not** call this BOARD_PASS, ASTRA-13, or a frozen production top.
Manager independently accepts. Do not autonomously open the next gate.
