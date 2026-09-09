# RESULTS — ASTRA-SOC-RTP-WRAP-XSIM

```text
FIX          = auditor 20260906T0138Z wrap-vs-DUT (item 2)
DUT_XSIM     = a7ng_astra_rtp_pipe_r2 + a7ng_axi_bram128 (NOT arty_a7_astra_rtp_soc_top)
PIPE         = a7ng_astra_rtp_pipe_r2 SHA 3d27091d KEEP
MEM          = a7ng_axi_bram128 SHA 6e254828 PLANT_R2_BASE=1 (BASE) / 0 (EMPTY mux)
XSIM         = ASTRA_SOC_RTP_WRAP_XSIM_PASS
LOAD_V       = 0 (load_from_tb_o tbl=0)
TOP_SYNTH    = arty_a7_astra_rtp_soc_top SHA a1f7a063
BRAM_TILE    = 2 (synth util; Design State = Synthesized; not routed)
LUT/FF       = 4352 / 3867 (synth)
WNS          = N/A (impl not run)
PROGRAM      = NO
COM12        = UNTOUCHED
JTAG         = 210319BE776EA UNTOUCHED
BOARD_PASS   = NO
GLUE_BAG     = ASTRA-SOC-RTP-GLUE left stripped (r1+plant128); wrap not restored as that DUT
```

## Raw XSim (`xsim.log`, session Sun Sep 6 01:50:14 2026, xsim v2026.1)

xvlog compiled pkg, QSE, role, gate, sparse_dir, **`a7ng_axi_bram128`**, query_axi_sparse, rel_engine_2hop, **`a7ng_astra_rtp_pipe_r2`**, **`tb_astra_soc_rtp_wrap`**.

**Not compiled in xvlog:** `arty_a7_astra_rtp_soc_top`, `a7ng_astra_rtp_pipe_r1`, `a7ng_axi_rtp_plant128`, `uart_rx`/`uart_tx`, MMCM/BUFG.

SHA256.txt written **before** xvlog (stamp 01:50:09+07).

| Case | fill | st | ans | p0 | p1 | nc | nload | nfar | nok | narto | ndir | tbl | nhost |
|------|-----:|---:|----:|---:|---:|---:|------:|-----:|----:|------:|-----:|----:|------:|
| BASE | 1 | 0 | 4 | 17 | 34 | 2 | 2 | 2 | 2 | 0 | 2 | 0 | 0 |
| EMPTY | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 |

AXI (BASE): dir `0500A020`/`05022FE0` → post `05040000` (ids 17,34) → facts `05800110`/`05800220` arid=2, rtp-desc-v1. EMPTY dir returns all-zero, **no fact AR**, ans is not 4.

Marker: `ASTRA_SOC_RTP_WRAP_XSIM_PASS`. EMPTY uses a second `a7ng_axi_bram128` `PLANT_R2_BASE=0` (wrap has no `fill_i`).

## Synth (optional, cheap; this bag)

`run_synth.tcl` top `arty_a7_astra_rtp_soc_top`, part `xc7a100tcsg324-1`. SHA256_SYNTH.txt **before** synth (stamp 01:50:40+07).

`util_synth.rpt` 2026-09-06 01:52, Design State = Synthesized, **Block RAM Tile = 2** (`u_sram` `mem_reg` 256x128 → 2× RAMB36E1). LUT=4352 FF=3867 DSP=0. No bitstream. No xsdb. Impl not run → **WNS N/A**.

## KEEP (not xvlog'd)

| File | SHA256 | Note |
|------|--------|------|
| `a7ng_astra09_pipe.sv` | `48c9e480…` | MATCH 12B; not edited |
| `arty_a7_astra09_soc_top.sv` | `71f4ebe0…` | MATCH; empty default BRAM; not this close |
| `arty_a7_astra_rtp_soc_top.sv` | `a1f7a063…` | MATCH ASTRA-11-RTP-SOC; hashed in SHA256_SYNTH because synth compiled it, **not** in SHA256.txt |

## Not claimed

UART bit-bang / MMCM unisim XSim of the wrap. Routed WNS. 100 MHz close. Filled 800k store. LM06 language. F2 reward-switch. ASTRA-13. BOARD_PASS. COM12 program. 09 wrap fetch.
