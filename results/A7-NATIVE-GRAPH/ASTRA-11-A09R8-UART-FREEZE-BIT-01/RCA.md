# RCA — why candidate B could not freeze

Authority: raw reports in named bags, not RESULTS prose. B =
`a7ng_astra_11_a09r7_uart_impl_wrap` in `ASTRA-11-A09R7-UART-IMPL-ROUTE-01`.

## Confirmed facts

| ID | Fact | Evidence |
|----|------|----------|
| F1 | B routed DTS WNS=+0.336 TNS=0 WHS=+0.104 | `timing_route.rpt` Design State Routed Mon Sep 7 01:52:48 2026 |
| F2 | Inter-clock hold columns blank; exceptions Hold=`false` on `uart_txd_in` / `uart_rxd_out` | `timing_route.rpt` Inter Clock; `exceptions_route.rpt` positions 9–10 |
| F3 | B packed UART IOB FFs: RX `ILOGICE2.IFF` `ILOGIC_X0Y171`, TX `OLOGICE2.OUTFF` `OLOGIC_X0Y161` | `UART_IOBFF.txt` |
| F4 | Same IOB FF + delays 2.000/0.500 **without** false-path hold: WHS=**−4.915** (1 UART IOB input hold endpoint) | `ASTRA-11-A09R3-UART-IOBFF-01` `timing_route.rpt` |
| F5 | Same delays **without** IOB FF and **without** false-path: UART IN hold **+1.151** (A9 → `u_rx/rx_sync0_reg`), OUT hold **+4.517** | `ASTRA-11-A09R3-UART-IODELAY-01` |
| F6 | BTN IDELAY TAP31 closed a **related-clock** pad hold of −2.068 (IBUF 1.417 + IDELAY 2.707) | `ASTRA-11-A09R7-BTN-IDELAY-01`; cannot cover −4.915 |
| F7 | B `run_impl.tcl` renames `write_bitstream` to abort | bag tcl lines 43–47, 409–412; ACK `"bitstream": "NOT_BUILT"` |
| F8 | Frozen `uart_rx` 2-FF has `rst_n` SR; B wrap IOB FFs were coded with **no SR** so they pack | `rtl/board/uart_rx.sv`; B wrap comment “No SR on these FFs so Vivado can pack into IOB” |

## Root cause (not symptoms)

**RC-STA:** B forced an IOB input FF onto an asynchronous UART pad and then timed
that FF against a **virtual** 20 ns clock with **zero** source clock delay, while
the FF is clocked by **real** `clk50u` (MMCM+BUFG insertion ~5 ns). Hold slack
≈ IBUF(~1.4) − MMCM_insert(~5) − min_delay(0.5) ≈ **−4.9 ns**. That is a
constraint/topology defect, not an A09-R2 or SGD bug.

**RC-POLICY:** Instead of removing the IOB FF (the topology that already MET at
+1.151 in the IODELAY bag), B excepted hold (`FALSE_PATH_HOLD_ASYNC_UART`). DTS
WHS became intra-`clk50u` and is not evidence that UART pad hold MET.

**RC-BIT:** Freeze requires a unique official `.bit`. B forbade `write_bitstream`.

**Not RC:** leftover A09 `ans=4` on overflow (not instantiated). AXI plant
(needed for on-chip facts; DDR OPEN). R7 query-rew FSM (identity of B).

## Fix in this bag (one unknown)

New named wrap `a7ng_astra_11_a09r8_uart_freeze_wrap`:

- Keep B identity: frozen `a7ng_astra_09_r2_cand_ovf` + R7 query-rew UART FSM +
  bag-local AXI plant + D10/A9 + 50 MHz MMCM.
- Remove wrap IOB pad FFs. Connect `uart_txd_in` → `uart_rx.rx`, `uart_tx.tx` →
  `uart_rxd_out`.
- Keep delays 2.000/0.500 vs `uart_io_vclk`.
- Do **not** `set_false_path -hold` on UART.
- `IOB FALSE` on UART ports.
- `write_bitstream` only if DTS WNS≥0, WHS≥0, and UART hold slacks numeric ≥0.
- PROGRAM=NO.

Competing hypothesis (IDELAY+IOB FF + related `clk50u`) is **not** this bag:
IDELAY cannot cover −4.915 vs virtual clock; related-clock IDELAY is a different
unknown. Do not mix.
