# RESULTS — ASTRA-09-R3-UART-XSIM-01

PROGRAM=NO. No JTAG/COM12/bit. ASTRA-11-A09R2-IMPL-ROUTE-01 /
ASTRA-SOC-RTP-WRAP-UART-XSIM / ASTRA-09-R2-CAND-OVF-01 /
ASTRA-09-INTEGRATED-PATH-01 / ASTRA-12* / ASTRA-11-A09-IMPL-ROUTE-01 /
F2R-* / F3-* / ASTRA-06-* bags not edited. Frozen
`a7ng_astra_09_integ_path.sv` / `a7ng_astra_09_r2_cand_ovf.sv` /
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv` not patched. Those bags' `run_*.ps1`
not rerun. LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened.
PRODUCTION_TOP remains UNKNOWN. Does **not** claim
ASTRA-SOC-RTP-WRAP-UART-XSIM MAGIC A2 results as this bag.

```text
XSIM_MARKER      = ASTRA_09_R3_UART_XSIM_PASS
VERDICT_PROPOSED = PASS_NARROW (this bag only: UART XSim glue around instantiated A09-R2; smoke ANSWER + overflow INCOMP on byte stream; load_from_tb=0)
SIM_TIME         = 9631755 ns
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

New named wrap `a7ng_astra_09_r3_uart_wrap` instantiates frozen
`a7ng_astra_09_r2_cand_ovf` (`15a919f1…`) as `u_a09r2`. Frozen leftover
`a7ng_astra_09_integ_path.sv` (`9fdbe0d6…`) is **not** instantiated and
**not** patched. Frozen SGD (`b66ef328…`) is instantiated inside A09-R2
only. Bag-local behavioral AXI plant (`a7ng_astra_09_r3_axi_plant`) is
**not** silicon BRAM and is **not** an edit of `a7ng_axi_bram128`.
`CAND_CAP=16`, overflow plant `N=20>16`. UART 115200 8N1 on pin
`CLK100MHZ` (10 ns). `load_from_tb_o=0`. Wrap is **not** PRODUCTION_TOP.

## Raw XSim (`xsim.log`)

xsim v2026.1, session **Sun Sep 6 21:45:37–21:46:37 2026**, PID **19596**,
snapshot `a09r3uart`, `$finish` at **9631755 ns**. `%t` is 1 ps.

Compiled (`xelab.log` / `xsim.dir/work`): `unisims_ver.MMCME2_BASE` /
`BUFG`, `uart_rx(CLK_HZ=50000000)`, `uart_tx(CLK_HZ=50000000)`,
**`a7ng_astra_09_r2_cand_ovf_default`**, **`a7ng_astra_09_r3_uart_wrap`**,
`a7ng_astra_09_r3_axi_plant`, `tb_astra_09_r3_uart_xsim`, `glbl`.
**No** `a7ng_astra_09_integ_path.sdb`, **no** `arty_a7_astra_rtp_soc_top.sdb`,
**no** `mmcm_stub`.

| Case | UART frame | Result |
|------|------------|--------|
| OVF_UART | `a2 46 00 00 00 00 00 00 00 00 00 00 04 00 00 0a` | MAGIC A2; st=6 ans=0 p0=0 p1=0 tbl=0 ntrunc=4 rov=1 wov=0; not ANSWER 4 |
| SMOKE_UART | `a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a` | MAGIC A2; st=0 ans=4 p0=17 p1=34 npath=2 tbl=0 ntrunc=0 |
| UNREL_UART | `a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a` | MAGIC A2; st=1 ans=0 p0=0 npath=0 tbl=0 |

HIER `load_from_tb_o=0` on all three. Marker present. Zero `FAIL` lines.

Byte pack (this wrap, not the RTP SoC wrap): `[0]=MAGIC A2`,
`[1]={tbl,r_ovf,w_ovf,pend_acc,status}`, ans/p0/p1 LE 20-bit,
`[11]=npath`, `[12:13]=ntrunc`, `[14]={7'd0,tbl}`, `[15]=EOL 0x0A`.

## Hashes

SHA freeze BEFORE xvlog `2026-09-06T21:45:31.3436033+07:00`.
xsim session Sun Sep 6 21:45:37–21:46:37 2026 PID **19596**.
Compiled + `.svh` pre/post **18/18 MATCH** (includes
`a7ng_astra_09_r2_cand_ovf.svh` and frozen `a7ng_astra_09_integ_path.svh`).
xsim.log SHA256 `e9b7f433b7bab28d9c92b359fdcfc075449f8b8dcf1e42c6bf2eb4a5f0110040`.
Frozen A09-R2 `15a919f1…` **unchanged**. Frozen A09 `9fdbe0d6…` **unchanged**.
Frozen SGD `b66ef328…`. ASTRA-09-R2 bag `xsim.log` still session **21:05:33**.
ASTRA-SOC-RTP-WRAP-UART-XSIM `xsim.log` still session **02:28:45**.
ASTRA-11-A09R2-IMPL-ROUTE-01 WNS=+0.648 **not overwritten**.

## Not claimed

Silicon MMCM (this is unisim behavioral `MMCME2_BASE`). BOARD_PASS.
ASTRA-13. COM12 program. wrap-route bit. PRODUCTION_TOP freeze.
ASTRA-SOC-RTP-WRAP-UART-XSIM MAGIC A2 close (different DUT: RTP pipe r2 +
`a7ng_axi_bram128`, not this A09-R2 UART glue). Master ASTRA-09 / F3 /
ASTRA-06 / LM06.

## Open (unchanged)

Master ASTRA-09 production path. Master F3 10pp / CI. Master ASTRA-06
(schemaV2 DDR / NVM). LM06. BOARD_PASS. ASTRA-13. PRODUCTION_TOP identity.
Do **not** call this BOARD_PASS, ASTRA-13, or a frozen production top.
Manager independently accepts. Do not autonomously open the next gate.
