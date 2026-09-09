# CLOSEOUT — ASTRA-C1-IMAGE-CONTRACT-01

PROGRAM=NO. BOARD_PASS not claimed. C1_MASTER remains OPEN.
`DDR_QUERY_BOUND_FINAL` remains **NOT_FROZEN**. Dictionary DDR image remains **NOT_PINNED**.

## Command

`results\A7-NATIVE-GRAPH\ASTRA-C1-IMAGE-CONTRACT-01\run_xsim.ps1` exit 0.

Marker `ASTRA_C1_IMAGE_CONTRACT_01_XSIM_PASS` at **0 fs** (function-only TB).
GOLDEN SHA `9601f95ee60f3719173dc06366cf6153f017ec70266d799963b4885c722377c1` hashed before xvlog; not regenerated.

## What matched

Independent Python `image_law.py` vs unedited `gen_800k.svh` / `query_gold.svh` (old bag, read-only):

| Class | Result |
|---|---|
| sample bytes | 23/23 HIT |
| below-dir `0x10` | zero |
| fill k0 `0x0D04` | occ=202; nids 120,121,122 |
| special 3380 | occ=1 nid=121 |
| high-ID k0 `0xD514` | occ=**1** nid=799999 |
| high-ID k1 `0x0D14` | occ=200 |
| fill overflow beat 50 | nonzero |
| tbl2 dir | empty |

Law SHA: `gen_800k.svh` `cd327310…`, `query_gold.svh` `dafe6c39…`.
C1 extract KEEP still `cd7baf49…`. Live prod_top still `c4fcca30…`. C3 wrap still `cfb89632…`. None compiled as DUT.

## Limitations (do not over-claim)

- Sample/range contract, **not** a dump of 800000 records.
- Query-level `G_OCC` is **not** always k0 directory occupancy (high-ID k0 occ=1 vs `G_OCC[9]=200` from k1).
- Query-role lexicon RTL is pinned; FPGA-visible dictionary **text image** is unpinned.
- No C1 per-class recall/selectivity rerun, no C3 transfer, no MIG, no board.

## Next

WO-03 `ASTRA-C1-C3-CANONICAL-IMAGE-TRANSFER-01` may use this law pin. Do not freeze `DDR_QUERY_BOUND_FINAL` from these 23 beats.
