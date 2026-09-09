# PREREG — ASTRA-C1-IMAGE-CONTRACT-01

PROGRAM=NO. WO-03 prerequisite. Does **not** edit C1 KEEP extract, C2, live
prod_top, MIG, or old bags. Does **not** freeze `DDR_QUERY_BOUND_FINAL`.
Does **not** dump 800000 records.

One unknown: does an independent Python replica of `gen_800k.svh` `g_rdata_of`
match the unedited SystemVerilog law on a frozen sample of directory and
posting addresses?

HIT this bag if:

- GOLDEN hashed before first xvlog and not regenerated
- `tb_samples.svh` frozen before xvlog
- every sample beat matches `g_rdata_of`
- fill k0 occ=202 and first posting nids 120,121,122
- special dir key 3380 occ=1 nid=121
- high-ID k0 `0xD514` occ=1 nid=799999; k1 `0x0D14` occ=200
- overflow posting beat 50 of fill is nonzero
- tbl2 dir empty
- dictionary DDR image declared `NOT_PINNED`
- `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`

This bag does **not** stamp C1_MASTER, C3 transfer, or BOARD_PASS.
Query-level `G_OCC` is not always k0 directory occupancy.
