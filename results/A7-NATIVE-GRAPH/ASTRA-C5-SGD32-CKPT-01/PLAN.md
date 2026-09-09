# ACK / PLAN — WO-01B ASTRA-C5-SGD32-CKPT-01

```text
TASK     = WO-01B unit first, then named C5 top
SESSION  = 2026-09-09 Cursor live clone
ROOT     = D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM  = NO
OWNER    = this session; does not edit C2 KEEP 86a7a069, live prod_top c4fcca30,
           C3 wrap cfb89632, or prod_top_rew (01A DUT)
```

## Observed failure

Live C2 persist stores `live_w0 += reward` at `0x06000000`. C5 `load_v_i=1'b0`.
Flush/reload of w0 is not a 32-weight SGD restore (Codex F05).

## Causal chain

Reward SGD writes `a7ng_shared_rank_sgd_q8_sym_f2r2` `w[0:31]`. C2 journal is a
different accumulator. Restore must AXI-read a full image and `load_v` that same
bank while C3/SGD is IDLE.

## Hypotheses (max 2)

H1: A new named backend that snapshots `w_i[0:31]`, writes header+4 payload+commit
marker, then reload/CRC/load-before-score restores exact 32 weights.
H2: Reusing C2 KEEP as the image would still be one w0 beat — rejected.

## Distinguisher

Unit XSim: TB loads 32 distinct weights (documented baseline), persist, zero the
bank, AXI reload, exact match. CRC corruption must FAIL with no install.
BRESP!=OKAY must FAIL without PERSISTED.

## Minimal change

New `a7ng_astra_c5_sgd32_ckpt.sv` only. C2 KEEP instantiated nowhere in this unit
bag. Schema `A7NG_C5K_SCHEMA=1` is bag-local; `PERSIST_SCHEMA_VERSION` not frozen.

## Limits

Modeled AXI, not MIG. Not power-loss NVM. Not C5_MASTER. 01A pass does not close
this bag. Playbook A/B slots: this unit uses one slot; A/B dual-slot is a later
revision if this path PASSes.
