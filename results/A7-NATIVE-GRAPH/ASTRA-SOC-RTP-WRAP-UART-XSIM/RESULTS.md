# RESULTS — ASTRA-SOC-RTP-WRAP-UART-XSIM

```text
FIX          = auditor 20260906T0215Z item 3 / 0152Z item 3
DUT_XSIM     = arty_a7_astra_rtp_soc_top
PIPE         = a7ng_astra_rtp_pipe_r2 SHA 3d27091d KEEP
MEM          = a7ng_axi_bram128 SHA 6e254828 PLANT_R2_BASE=1
WRAP         = arty_a7_astra_rtp_soc_top SHA a1f7a063 KEEP
UART         = uart_rx/uart_tx CLK_HZ=50e6 BAUD=115200
MMCM         = UNISIM_MMCME2_BASE (xelab -L unisims_ver; NOT silicon MMCM)
MMCM_STUB    = on disk, NOT xvlog'd (unisim xelab succeeded)
XSIM         = ASTRA_SOC_RTP_WRAP_UART_XSIM_PASS
LOAD_V       = 0 (hier tbl=0; MAGIC byte[1][7]=0)
EMPTY        = not run (wrap has no fill_i)
PROGRAM      = NO
COM12        = UNTOUCHED
JTAG         = 210319BE776EA UNTOUCHED
BOARD_PASS   = NO
NOT_DUT      = a7ng_astra09_pipe / arty_a7_astra09_soc_top / r1 / plant128
```

SHA256.txt written **before** xvlog (stamp 2026-09-06T02:28:37.8265117+07). xsim session Sun Sep 6 02:28:45–02:29:02 2026, xsim v2026.1, laptop-Quan. `$finish` at 3385615 ns.

## DUT identity (raw `xelab.log` / `xsim.dir/work`, not RESULTS)

`xelab tb_astra_soc_rtp_wrap_uart glbl -s wrapuart -timescale 1ns/1ps -L unisims_ver --debug typical`.

Compiled: `unisims_ver.MMCME2_BASE` / `MMCME2_ADV` / `BUFG`, `uart_rx(CLK_HZ=50000000)`, `uart_tx(CLK_HZ=50000000)`, **`a7ng_astra_rtp_pipe_r2_default`**, **`a7ng_axi_bram128(PLANT_R2_BASE=1`**, **`arty_a7_astra_rtp_soc_top`**, `tb_astra_soc_rtp_wrap_uart`, `glbl`.

`xsim.dir/work` sdb: wrap top, r2, bram128, uart_rx, uart_tx. **No** `a7ng_astra09_pipe.sdb`, **no** `arty_a7_astra09_soc_top.sdb`, **no** `a7ng_astra_rtp_pipe_r1.sdb`, **no** `a7ng_axi_rtp_plant128.sdb`, **no** `mmcm_stub`.

`Compile_Options.txt`: `-L unisims_ver`. `MMCM_MODE.txt`: `UNISIM_MMCME2_BASE` / `NOT_SILICON_MMCM=1`.

## Raw XSim (`xsim.log`)

Pin `CLK100MHZ` 10 ns. UART bit-bang 115200 8N1, `CPB_PIN100=868`, `BIT_NS=8680` (matches DUT 434×20 ns at 50 MHz pipe).

Query: `pump requires indirect\n`.

| Event | t (`%t`, 1 ps res) | Note |
|-------|--------------------|------|
| `RST_N=1 locked=1` | 5645000 | unisim lock + wrap POR `por_cnt==0xFF` |
| `FIRE` | 1998465000 | wrap EOL `0x0A` |
| `HIER result_v` | 2000505000 | ans=4 p0=17 p1=34 st=0 **tbl=0** nload=2 ncand=2 nfok=2 ndir=2 nfar=2 |
| MAGIC frame 16 B | 2083005000–3385605000 | UART TX of wrap `tx_bytes` |

```text
FRAME a2 00 04 00 00 11 00 00 22 00 00 02 02 02 02 0a
DECODE magic=a2 tbl=0 st=0 ans=4 p0=17 p1=34 nload=2 nfok=2 ndir=2 ncand=2 eol=0a
PASS BASE UART ans=4 p0=17 p1=34 tbl=0
ASTRA_SOC_RTP_WRAP_UART_XSIM_PASS
```

Byte pack (wrap RTL): `[0]=MAGIC A2`, `[1]={tbl,ovf,neg,amb,status}=0x00`, ans LE 20-bit `04 00 00`, p0 `11 00 00` (17), p1 `22 00 00` (34), nload=2, nfok=2, ndir=2, ncand=2, `[15]=0x0A`.

## KEEP (hashed, not compiled)

| File | SHA256 | Note |
|------|--------|------|
| `a7ng_astra09_pipe.sv` | `48c9e480…` | MATCH 12B / WRAP-XSIM; not edited; not DUT |
| `arty_a7_astra09_soc_top.sv` | `71f4ebe0…` | MATCH TIMING-FIX; empty default BRAM; not this close |
| `mmcm_stub.sv` | `55707db0…` | hashed; **not** xvlog'd |

Compiled DUT hashes MATCH WRAP-XSIM `SHA256_SYNTH.txt` / WRAP-ROUTE: r2 `3d27091d`, bram128 `6e254828`, wrap `a1f7a063`, uart_rx `8e802d0b`, uart_tx `b4b7d097`.

## Not claimed

Silicon MMCM (this is unisim behavioral `MMCME2_BASE`). Routed WNS (see WRAP-ROUTE). BOARD_PASS. ASTRA-13. COM12 program. EMPTY wrap. 100 MHz close. 09-wrap fetch. LM06 language. F2. Glue r1+plant128.
