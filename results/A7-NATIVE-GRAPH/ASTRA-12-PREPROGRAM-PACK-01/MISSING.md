# MISSING — ASTRA-12-PREPROGRAM-PACK-01

Explicit gaps. Absence here is the pack’s job. Do not treat a listed gap as
closed because a nearby bag has a related artifact.

PRODUCTION_TOP = **UNKNOWN** (not missing-as-in-forgot; missing-as-in-not-frozen).

---

## 1. UART

| Envelope | UART RTL compiled? | Pins | Evidence |
|----------|--------------------|------|----------|
| ASTRA-11-A09-IMPL-ROUTE-01 wrap | **NO** | none | wrap SV ports = CLK100MHZ/sw/btn/led only; `clk50_impl.xdc` comment “No UART”; auditor 1400Z: no `uart_rx`/`uart_tx` in synth list |
| ASTRA-11-SOC-WRAP `arty_a7_astra09_soc_top` | YES (historical) | `uart_rxd_out` D10, `uart_txd_in` A9 | RESULTS.md pin table; Bonded IOB=15 |
| ASTRA-SOC-RTP-WRAP-ROUTE `arty_a7_astra_rtp_soc_top` | YES (`uart_rx`/`uart_tx`) | same D10/A9 | `io.rpt` Total User IO=15; different DUT `a7ng_astra_rtp_pipe_r2` |

**Missing for program gate:** UART I/O on **the frozen production top** (identity
UNKNOWN). A09 wrap WNS=+1.041 has **no UART**. SoC UART wrap is a different bag
and is **not** this pack’s top. UART MAGIC / COM12 capture: **not present**.
`rtl/board/uart_rx.sv` / `uart_tx.sv` exist in tree; they were **not** compiled
into the A09 impl wrap.

---

## 2. Pinout vs wrap-route SoC top

A09 wrap (`io.rpt` Total User IO=**13**, SHA256
`af08de5ff7b806391b23d26e4b2063f9e7882e53e099456b64a4db5fc0f2f1e2`):

| Signal | Pin |
|--------|-----|
| CLK100MHZ | E3 |
| sw[3:0] | A8 C11 C10 A10 |
| led[3:0] | H5 J5 T9 T10 |
| btn[3:0] | D9 C9 B9 B8 |
| uart_* | **absent** |

Wrap-route SoC (`ASTRA-SOC-RTP-WRAP-ROUTE/io.rpt` Total User IO=**15**, SHA256
`b4cb6178db5e26e0300d83a191a850e7778bae29b54a23438625f5d0f02f2236`) and
ASTRA-11-SOC-WRAP (`io.rpt` Total User IO=**15**, SHA256
`18505a0ec132c318b2f87352d9a284740204b01e416628dd8799be57f88fd395`) add:

| Signal | Pin |
|--------|-----|
| uart_txd_in (FPGA RX) | A9 |
| uart_rxd_out (FPGA TX) | D10 |

Shared crystal/LED/SW/BTN sites are **not** identity of tops. DUT under those
SoC pins is **not** `a7ng_astra_09_integ_path` (wrap-route = RTP `pipe_r2` +
`a7ng_axi_bram128`; SOC-WRAP = `arty_a7_astra09_soc_top` / `a7ng_astra09_pipe`).

**Missing:** one reviewed pinmap into a **frozen production top**. ASTRA-11
FULLCHIP-COFIT remains OPEN (auditor 1400Z). `constraints/arty_a7_100.xdc` is
the board file; this pack did not freeze it as the production pinmap.

LED I/O timing: A09 wrap `timing_route.rpt` `check_timing` **no_output_delay 4
HIGH** (LED ports). That is a residual vs board I/O timing close, **not** a
silent manufacture of WNS=+1.041 (internal clk50u R-to-R).

---

## 3. Bitstream SHA

This bag: **BIT=NOT_BUILT**. No `.bit` generated. `write_bitstream` not called.

ASTRA-11-A09-IMPL-ROUTE-01: DCP only (`ckpt/synth.dcp`, `ckpt/route.dcp`). No `.bit`.

Historical bits in **other** bags (UNPROGRAMMED; **not** adopted here):

| File | SHA256 (this pack Get-FileHash) | Bag status |
|------|----------------------------------|------------|
| ASTRA-11-SOC-WRAP `arty_a7_astra09_soc_top.bit` | `c7442d16a685c91fdbb5e50f1b612b5a3a99dcf911587744887515e4155d1d99` | STATUS=UNPROGRAMMED; WNS=−4.765; matches that bag `SHA256.txt` |
| ASTRA-SOC-RTP-WRAP-ROUTE `arty_a7_astra_rtp_soc_top.bit` | `8116fa77dfd38253e04a03563f71e22ed628dccb30b77a8f03a315d022b0171b` | STATUS=UNPROGRAMMED; different top; matches `SHA256_BIT.txt` |
| ASTRA-11-TIMING-FIX `arty_a7_astra09_soc_top.bit` | `a5c3f2c4245ac185ed5e0e957d80e7e73c90fedb84ca69f1bc924b35b030e84a` | different session; not this pack |

**Missing:** bitstream SHA of **the frozen production top** after WNS≥0 on that
top. None of the rows above is that object. Gate14/LM06/01R/02M frozen bits
in `a7-fpga-gate` registry are **other programs**; not ASTRA production.

---

## 4. ASTRA-13

Master DAG: ASTRA-13 FINAL-BOARD-ACCEPTANCE.

`docs/ASTRA/LOOP_STATE.json`: `"astra13": "BLOCKED"`.
`docs/ASTRA/PROJECT_PATHS.md` §7: *ASTRA-13 BLOCKED. PROGRAM=NO.*
Auditor 20260906T1400Z: Master ASTRA-13 **OPEN**; BOARD still blocked **YES**.

No ASTRA-13 bag exists under `results/A7-NATIVE-GRAPH/` as a board-acceptance
close. This pack does **not** start ASTRA-13.

---

## 5. LM06

`ASTRA-08-LM06-VOCAB-CHECKPOINT-AUDIT/RESULTS.md`:
`CLASS = LM06_ACTIVE_BUT_LANGUAGE_UNPROVEN`. BIT=NO. PROGRAM=NO.

Auditor 1400Z: LM06 language **not opened**. A09 wrap did not compile LM06.
A09 XSim path is retrieve→proof→rank→pending→reward, **not** LM06 token out.

**Missing:** LM06 generation proven / language composer / NLU. Classification
remains `LM06_ACTIVE_BUT_LANGUAGE_UNPROVEN` / NOT_INTEGRATED.

---

## 6. Master F3 10 packed pages / CI

ASTRA-F3-R4-DISTINCT-HOLD-PHI-01 RESULTS:

```text
MASTER_F3 = OPEN (10pp/CI/retention not claimed; n=8 compact TB-AXI, not ASTRA-07 24×8)
```

Auditor 1400Z: Master F3 10pp/CI **OPEN**.
`docs/ASTRA/WORK_QUEUE.md` item 5: *Only then Master F3 transfer (multi-seed,
not 5 ID-permutations). Still PROGRAM=NO.*

**Missing:** 10 packed pages, paired CI, retention, multi-seed transfer at
Master F3. F3R2/R3/R4 bags are **narrow** XSim, not 10pp/CI.

---

## 7. Auditor ACCEPT_BOARD

Grep of `results/A7-NATIVE-GRAPH/AUDITOR/**/REPORT.md`: **zero** `ACCEPT_BOARD`.

Latest auditor `20260906T1400Z` Final = `ACCEPT_PARTIAL | REJECT_PROMOTION`.
SHA256 `f5b83053765a5c5292ba8a0714d524437c7bec0f868a0120575af99139d3597b`.

**Missing:** auditor ACCEPT_BOARD of a timed bit of the frozen production top.

---

## 8. Other open (not this pack’s close)

- Master ASTRA-09 production path (UART + LM06 + PHYS4 + silicon).
- Master ASTRA-11 FULLCHIP-COFIT (UART + MMCM + I/O + memory plant + production path as **one** top).
- Master ASTRA-06 schemaV2 DDR / DDR index N>1 / NVM-QSPI / power-loss journal.
- AXI BRAM/DDR plant on the A09 wrap (hanging AXI; BRAM=0 by construction).
- Owner program gate (board plugged ≠ authority).
