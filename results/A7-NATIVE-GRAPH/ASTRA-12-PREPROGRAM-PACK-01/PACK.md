# PACK — ASTRA-12-PREPROGRAM-PACK-01

Frozen evidence pack. **Not** a bitstream. **Not** BOARD_PASS. **Not** ASTRA-13.
**Not** Master ASTRA-12 FINAL-SOURCE-FREEZE (that is a different historical bag).

```text
GATE                 = ASTRA-12-PREPROGRAM-PACK-01
PACKED               = 2026-09-06T20:05:09+07:00
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH               = grok-orch/astra-native-v1-00
AUDITOR_PRIOR        = 20260906T1400Z ACCEPT_PARTIAL | REJECT_PROMOTION
A09_WRAP_WNS_ROUTED  = +1.041 ns (timing_route.rpt Design State=Routed; clk50u 20.000 ns)
PRODUCTION_TOP       = UNKNOWN
BIT                  = NOT_BUILT (this bag)
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
BOARD_PASS           = NOT_CLAIMED
write_bitstream      = not called
```

Cited prior-bag files were **hashed in place**. Those files were **not rewritten**.
Their run scripts were **not rerun**. Frozen RTL was **not patched**.

## Production-top identity

**UNKNOWN.** This pack does not freeze a production top. Do not silently pick
among the routed wrappers below. Policy (this bag `POLICY.md`): A09 wrap
WNS=+1.041 is **not** the frozen production top. SoC UART wrap remains a
**different** bag.

| Candidate (not chosen) | Evidence bag | Routed WNS class | UART | Bonded IOB | Bit in that bag |
|------------------------|--------------|------------------|------|-----------:|-----------------|
| `a7ng_astra_11_a09_impl_wrap` | ASTRA-11-A09-IMPL-ROUTE-01 | **+1.041** clk50u 20 ns | **NO** | 13 | **NOT_BUILT** |
| `arty_a7_astra09_soc_top` | ASTRA-11-SOC-WRAP | **−4.765** @ 100 MHz | YES D10/A9 | 15 | UNPROGRAMMED `c7442d16…` |
| `arty_a7_astra_rtp_soc_top` | ASTRA-SOC-RTP-WRAP-ROUTE | **+5.733** (RTP `pipe_r2`) | YES D10/A9 | 15 | UNPROGRAMMED `8116fa77…` |

Those three are **different DUTs**. Do not add LUT/FF across rows. Do not call
any of them the frozen production top from this pack.

---

## 1. Routed A09 wrap WNS (required)

File: `results/A7-NATIVE-GRAPH/ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt`

SHA256 `2a72f98a149a953f1ef0d386d679fbc68d60b92861a66a1ece1b01941ed48f72`

Header (raw):

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Sun Sep  6 19:48:09 2026
Command      : report_timing_summary -file .../ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt
Design       : a7ng_astra_11_a09_impl_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary (raw numeric line):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      1.041        0.000                      0                 3004        0.160        0.000                      0                 3004
All user specified timing constraints are met.
```

Clock Summary (same rpt): `sys_clk_pin` period 10.000 (100.000 MHz);
`clk50u` period 20.000 (50.000 MHz). Intra-clock `clk50u` WNS=1.041 WHS=0.160.

Auditor `20260906T1400Z` MATCHES this quote. This number is **not** ASTRA-10 OOC
WNS=+2.283, **not** wrap-route WNS=+5.733, **not** ASTRA-11-SOC-WRAP WNS=−4.765,
**not** BOARD_PASS.

Wrap `clk50_impl.xdc` SHA256 `9daf143e240660b98cd0d7092cd23710cb46e26614f799127255089e0cb195f8`
(copied from ASTRA-11-A09-IMPL-ROUTE-01 `SHA256.txt`; that file not rewritten).
Pins: CLK100MHZ E3, sw A8/C11/C10/A10, led H5/J5/T9/T10, btn D9/C9/B9/B8.
**No UART ports.** Bonded IOB=13 (`io.rpt` Total User IO).

DUT instance `u_a09` = frozen `a7ng_astra_09_integ_path`
SHA256 `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c`
(copied from ASTRA-11 / ASTRA-09 / ASTRA-10 freeze lists).

---

## 2. ASTRA-09 XSim marker (required)

File: `results/A7-NATIVE-GRAPH/ASTRA-09-INTEGRATED-PATH-01/xsim.log`

SHA256 `445199d247c3f8e47ad2ea5204d46127f9c5eda9207239d7f4a800664b15caa7`

Matches ASTRA-09 RESULTS.md recorded xsim.log hash (copied, not rewritten).

Raw marker (session Sun Sep 6 18:53:05–18:53:07 2026, PID 40928, `$finish` 12705 ns):

```text
PASS UNREL_NO_STALE
ASTRA_09_INTEGRATED_PATH_XSIM_PASS
$finish called at time : 12705 ns
```

This is XSim of named path `a7ng_astra_09_integ_path`. **Not** silicon.
**Not** Master ASTRA-09 production path (UART / LM06 / PHYS4 still open).

---

## 3. ASTRA-10 util_synth (required)

File: `results/A7-NATIVE-GRAPH/ASTRA-10-RESOURCE-BOUND-01/util_synth.rpt`

SHA256 `3933db007c1a1011a3e32fd0a10996d6b7e70cd9de708dfaf43548f3217217ac`

Header (raw): Design `a7ng_astra_10_resource_wrap`; Device `xc7a100tcsg324-1`;
Date Sun Sep 6 19:18:49 2026; **Design State : Synthesized** (OOC; not routed).

```text
| Slice LUTs*             | 5178 |     0 |          0 |     63400 |  8.17 |
| Slice Registers         | 4155 |     0 |          0 |    126800 |  3.28 |
| Block RAM Tile          |    0 |     0 |          0 |       135 |  0.00 |
| DSPs                    |    2 |     0 |          0 |       240 |  0.83 |
| Bonded IOB              |    0 |     0 |          0 |       210 |  0.00 |
```

OOC synth occupancy of instantiated A09. **Not** implemented timing.
Auditor 20260906T1330Z: OOC WNS=+2.283 is not implemented. Closed as evidence
class by ASTRA-11-A09-IMPL-ROUTE-01 routed WNS=+1.041; **not** Master ASTRA-10
whole-chip close. Do not add 5178 LUT to A09 wrap routed 1305 or wrap-route 4244.

---

## 4. ASTRA-06-R4 sess-reuse marker (required)

File: `results/A7-NATIVE-GRAPH/ASTRA-06-R4-SESS-REUSE-01/xsim.log`

SHA256 `cf7db5260f4f410d0c8e41fd5560b2fd5056e8ffd2555060df5697826670d64f`

Matches ASTRA-06-R4 RESULTS.md recorded xsim.log hash (copied, not rewritten).

Raw marker (session Sun Sep 6 18:35:14–18:35:16 2026, `$finish` 13555 ns):

```text
PASS UNREL_NO_STALE
ASTRA_06_R4_SESS_REUSE_XSIM_PASS
$finish called at time : 13555 ns
```

Sess-id reuse-without-restore closed **narrow** on-chip. Master ASTRA-06
(schemaV2 DDR / NVM / QSPI) remains **OPEN**.

---

## Persist / handshake bags (listed with hashes; not re-run)

xsim.log SHA256 computed this pack; DUT SHA copied from ASTRA-11-A09-IMPL-ROUTE-01
`SHA256.txt` provenance block (that file not rewritten). Markers from raw logs.

| Bag | Marker (raw xsim.log) | xsim.log SHA256 | Frozen DUT SHA256 (copied) |
|-----|------------------------|-----------------|----------------------------|
| ASTRA-06-WARM-PERSIST-01 | `ASTRA_06_WARM_PERSIST_XSIM_PASS` | `5f739df0778415567a16c80fdb7ccea6fca503600869cfc442fa5dafb7198804` | persist `52ebde5250a8740032667eea2ccd2fccc25f96ff6317d85fd06795ee6aa317b1` |
| ASTRA-06-R2-EVICT-HIGHID-01 | `ASTRA_06_R2_EVICT_HIGHID_XSIM_PASS` | `ff0770d36b2972c4fae126589920d3ba490e40c060cb5c4017927186887bf7d3` | R2 `c671f98b2518830d23a9a171bbf60386db2cbc628e9bbe30f7e970a3d83c037b` |
| ASTRA-06-R3-MULTI-SLOT-01 | `ASTRA_06_R3_MULTI_SLOT_XSIM_PASS` | `d6deb5ba22768fcd51c727ccd1df64413b9e3f2ac1b8cd3989735d9dba6536e6` | R3 `99ee5d93dd18b3f146b433d521ab706038141cb8648afab17d315bd1ce8c186f` |
| ASTRA-06-R4-SESS-REUSE-01 | `ASTRA_06_R4_SESS_REUSE_XSIM_PASS` | `cf7db5260f4f410d0c8e41fd5560b2fd5056e8ffd2555060df5697826670d64f` | R4 `4bd94762c62c0d749ff85f35fb5523eab1c251c210daf9c42997802a25f696f4` |
| ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW | `ASTRA_F2R2_HS_LAW_XSIM_PASS` | `337ca164ce48171c9b54c1f0d3d047c6ab871f445a84ef0791a73353d4bcf3db` | F2R2 law `5e2f23c311bfa1cbdbb9b10b8ceb26726df78dcff62c8dbd9071e219d4cbb638` |
| ASTRA-F2R-R3-SEMANTIC-GUARD-01 | (bag exists; not this close) | `806026f2772fd4a8d157473c48b60747966c61acb493089250618b921ebb56bc` | F2R3 `9a7a5941b5ee2522c0491808d7cb23b5f7d58520ace19ac46bd3b9edfd324489` |
| ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01 | (bag exists; not this close) | `98297afcbc9fe33053355b199cb29c3b3e90d66816ba45e7d08e7e63fd607f6b` | F2R4 `5cdb3da8c53d22333e2af847c839439f1a9e5ee05c4b307194c7236c70fe407b` |
| ASTRA-F2R-R5-TXN-WRAP-RESET-01 | `ASTRA_F2R5_TXN_WRAP_RESET_XSIM_PASS` | `a93aaedc559ae6bbb7bad36f088a5fa729ace77182d86bfc6c30bfe3cf0619b5` | F2R5 `41c77e76fb5bc179b133bbdeba563f8484d3cc5e699438af3cfc521b2f75895b` |

SGD instantiated across A09/A10/A11: `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`
SHA256 `b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac`
(copied from ASTRA-11 freeze).

These are **XSim / on-chip** persist+handshake. Not DDR. Not NVM. Not BOARD.

---

## Comparison hashes (not identity; files not rewritten)

| File | SHA256 | What it is **not** |
|------|--------|--------------------|
| ASTRA-11-SOC-WRAP `timing.rpt` | `870c0f1237944841ba98ce96e76b9c55d2ded4ecef786b66242cfc92d9dad92c` | not A09 wrap WNS=+1.041; WNS=−4.765 |
| ASTRA-SOC-RTP-WRAP-ROUTE `timing.rpt` | `71664fba4f5ec2d22d2d2a5d1223ac072b714330317bd8e2fb6c8a2e0a4a79ac` | not A09 wrap; WNS=+5.733 different top |
| Auditor `20260906T1400Z/REPORT.md` | `f5b83053765a5c5292ba8a0714d524437c7bec0f868a0120575af99139d3597b` | ACCEPT_PARTIAL; not ACCEPT_BOARD |
| ASTRA-11-A09-IMPL-ROUTE-01 `SHA256.txt` | `2d36af9c56ff4817492660c3baa05fb363dda898d95cac9c8f6817db4a4bf827` | freeze-before-impl; not a bit |
| ASTRA-09 `SHA256.txt` | `a304131e9f7e840d537a820c83321e2f5f5a7e5b9957d61001b32190e4a99799` | freeze-before-xvlog |
| ASTRA-10 `SHA256.txt` | `0a64c9fe4f4293070b1174b22dccf22f292de7e4cf62d29657d4044af790e2c2` | freeze-before-synth |
| ASTRA-06-R4 `SHA256.txt` | `06f92351b6b72217fdd8b4683bba3f8548d97c941f889f8ad4b17d1e64469ab0` | freeze-before-xvlog |

Historical bits **exist in other bags** (UNPROGRAMMED). This pack did not write
them and does not adopt them as the production bitstream. See `MISSING.md`.

---

## Not claimed

BOARD_PASS. ASTRA-13. ACCEPT_BOARD. write_bitstream. JTAG/COM12 program.
Production-top identity. Master ASTRA-09 / ASTRA-11 fullchip / ASTRA-06 DDR.
Master F3 10pp/CI. LM06 language. UART I/O close. LED output-delay close.
Wrap-route WNS=+5.733 as this bag. OOC WNS=+2.283 as implemented.
