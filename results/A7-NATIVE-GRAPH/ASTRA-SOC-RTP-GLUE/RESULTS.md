# RESULTS — SOC_RTP_GLUE

```text
FIX        = auditor 20260906T0120Z #7 SoC exam path
DUT_XSIM   = a7ng_astra_rtp_pipe_r1 + a7ng_axi_rtp_plant128 (NOT the SoC wrap)
WRAP_FILE  = arty_a7_astra_rtp_soc_top.sv exists (r2+bram128) but was NOT the XSim DUT — OVERCLAIM stripped
PIPE       = a7ng_astra_rtp_pipe_r1 SHA 35ad8a17 KEEP
MEM        = a7ng_axi_rtp_plant128 INIT dir+post+rtp-desc-v1
XSIM       = ASTRA_SOC_RTP_GLUE_XSIM_PASS
LOAD_V     = 0 (load_from_tb_o tbl=0)
PROGRAM    = NO
COM12      = UNTOUCHED
BOARD_PASS = NO
CLK_PIN    = CLK100MHZ E3 10 ns (XDC cite; MMCM 50 MHz not XSim'd here)
```

## Raw XSim (xsim.log)

| Case | fill | st | ans | p0 | p1 | nc | nload | nfar | nok | ndir | tbl | nhost |
|------|-----:|---:|----:|---:|---:|---:|------:|-----:|----:|-----:|----:|------:|
| BASE | 1 | 0 | 4 | 17 | 34 | 2 | 2 | 2 | 2 | 2 | 0 | 0 |
| EMPTY | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 |

AXI (BASE): dir `0500A020`/`05022FE0` → post `05040000` → facts `05800110`/`05800220` arid=2. EMPTY dir returns 0, no fact AR, ans is not 4.

Marker: `ASTRA_SOC_RTP_GLUE_XSIM_PASS`. Vivado xsim v2026.1.

## Not claimed

UART bit-bang / MMCM unisim of the new top. 100 MHz close. Filled 800k store. LM06 language. F2 reward-switch. ASTRA-13. BOARD_PASS. COM12 program. `a7ng_astra09_pipe` still load_v-only on the old wrap.

## Frozen / SHA256 this bag

SHA256.txt is **xvlog snapshot only** (pkg, QSE, role, gate, sparse_dir, plant128, query_axi_sparse, 2hop, r1, TB). Does **not** hash `arty_a7_astra_rtp_soc_top.sv` (not compiled). r1 `35ad8a17…` KEEP. 09 pipe / 09 wrap not in this snapshot.
