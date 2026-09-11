# Overlay checkpoint (source lock, not a board verdict)

```text
NO BOARD PASS
NO C6 FREEZE
PROGRAM=NO
C4_MASTER=OPEN
C5_MASTER=OPEN
C6_MASTER=OPEN
ASTRA_NATIVE_AI_BOARD_PASS=NOT_EVIDENCED
E3AB=DO_NOT_START
```

This branch locks the in-tree source used for C6 `a7ng_astra_c6_wholechip_final_v1`:

- E3aa D32 Lut-index snap (OOC WNS +1.052 ns is **not** WO §19)
- E1c alias boot wiring (`IMAGE_IN_TREE_BOOT_WIRED`, `exam_locked=false`)
- C6 wholechip scripts/spec (`write_bitstream` only if post-route letters hold)
- `c3_sgd_w` SGD update pipe (XSim GOLDEN, not MASTER)

## C6 physical state at overlay time

```text
C6_SYNTH     = PASS          (c6_synth.dcp exists; not committed)
C6_PLACE     = IN_PROGRESS or later local (place.dcp not committed)
C6_ROUTE     = INCOMPLETE_TOOL_EXIT   (Vivado exit -1 in Route Phase 5.1; not a timing fail)
C6_POSTROUTE = NOT_EVIDENCED
```

In-route print `WNS=-3.239` is a **hint only**. It is not a §19 letter and must not be used as `C6_POST_ROUTE_PHYSICAL`.

Prior completed post-route of this top (pre-`c3_sgd_w`): WNS −9.462 ns on `u_c3/u_sgd/w_reg` 20/20. Archived as `ROUTE_LETTERS.pre_c3_sgd_w.txt`.

## Not in this overlay

- MIG generated `vivado/ip/**`
- `.dcp` / `.bit` / Vivado logs
- Force-push of `grok-orch` onto `main`

## After this SHA

Resume C6 from `c6_place.dcp` (or `ckpt/place.dcp`) with `C6F_OVERLAY_SHA` set to this commit. Do not re-synth unless the DCP is missing or RTL hashes diverge.
