# RESULTS — ASTRA-F2R-SHARED-RANK-PENDING-01

Grok Astra `99be8510-6587-4eb0-a06e-0f9796e19b1d`. PROGRAM=NO. No JTAG/COM12.

```text
XSIM_MARKER     = ASTRA_F2R_XSIM_PASS
VERDICT         = PASS_NARROW
SIM_TIME        = 61245 ns
FAIL            = 0
FIRST_DIVERGENCE= NONE
BIT             = NOT_BUILT
PROGRAM         = false
```

## What ran

Named candidate path (existing source not patched):

- `rtl/native_graph/integrate/a7ng_astra_f2r_rank.sv`
- `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_v1_f2r.sv` (named copy of sequential v1)
- bag TB `tb_astra_f2r.sv` + `run_f2r.ps1`

SGD provenance: original `a7ng_shared_rank_sgd_q8_v1.sv` SHA256
`01ef40079f1407c1067ed98a6e1b0a4b0e8d0b6911f21afb0542e43728a73c24`
(not DSP tfix). Copy SHA256 `d34f418b59e38f073f86c89b46b84e60367a154fc846c6725ccf2b3fd233486e`.

Features used (FPGA-derived, not IDs): `phi[0]=min(src_conf)>>2`, plus shared flags trans/pol/schema/rel. Not query/answer/entity ID, not proof index, not class-byte, not gold.

## Raw XSim (from xsim.log)

| Case | Log | Result |
|------|-----|--------|
| ISO_ONEHOT | w0=-6 w1=0 viso=0 | PASS |
| R0 two proofs | npath=2 p0=17 p1=34 ans=4 vbest=0 vsec=0 phi0=50 tbl=0 txn=1 | PASS |
| DW oracle | nupd=1 pend_cmt=1 w0=-5 | PASS |
| NEG switch | p0=18 vbest=-13 vsec=-14 | PASS |
| FREEZE | no switch | PASS |
| VALIDITY-ONLY | no switch | PASS |
| POS stay | stay 17 | PASS |
| TXN guards | nupd=1 ndup=1 nbad=1 w0=-5 | PASS |
| 5-world structural | TRANSFER 5/5; each world npath=3, p0=low-conf hop | PASS |
| RTP POST_DROP | npath=1 p0=17 st=0 | PASS |
| RTP DESC_SWAP | npath=2 ans=7 p0=17 | PASS |
| RTP HIGH_ID | PASS | PASS |
| RTP EID_MISMATCH | npath=0 st=6 | PASS |
| RTP AXI_BAD_RID / AR_STALL / LATE_R / OVF / NEG / AMB / UNREL_NO_STALE | PASS | PASS |

Marker: `ASTRA_F2R_XSIM_PASS`. `$finish` at 61245 ns.

## Integer law vs measured v

PREREG 1-feature oracle: after rew=-3, dw0=-5, then v_hi=-2 v_lo=-1.

Measured: dw0=-5 **exact**. After switch, vbest=-13 vsec=-14. Cause: pending copy also has phi[1:4]=64, so those weights update too. Shared flags do not change *which* proof wins; quality `phi[0]` still orders 18 above 17. Ranking claim holds. Do not treat -13/-14 as the 1-feature oracle.

## Transfer claim bound

5 planted ID-permuted worlds after one negative update: all selected the low-confidence first hop (0x1002, 0x1006, 0x100a, 0x100e, 0x1012). This is structural quality transfer on this corpus, **not** Master F3 / paraphrase / 32-φ / LM06.

Held-out npath=3 (not 2): world mids include 10, which equals query entity 10, so the engine also enumerates an extra legal 2-hop. Winner still the low-conf hop. Coverage/uncertainty not separately scored beyond 5/5 on this plant.

F2T class-one-hot remains a labeled control from the prior bag; this bag does not relabel it as complete features.

## Hashes

Pre-xvlog freeze: `SHA256.txt`. Post-xsim compiled files: `SHA256_POST.txt`. Compiled SHA match.

xsim.log SHA256 `a51bd80a9ceccae5d9a8d7fe6d316a6bc314f13ef7efc8b231ceadde9c2c8975`
xvlog.log SHA256 `4f98d85c3c4750df24349b00b403a69d9e8f23ef749724228cfedcc3d154090f`

## Open (unchanged)

LM06_NOT_INTEGRATED. F4/F5 open. BOARD_PASS open. No bitstream. Manager independently accepts.
