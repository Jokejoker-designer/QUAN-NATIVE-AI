# CLOSEOUT — ASTRA-C1-C3-CANONICAL-IMAGE-TRANSFER-01

PROGRAM=NO. BOARD_PASS not claimed. C1_MASTER and C3_MASTER remain OPEN.
`DDR_QUERY_BOUND_FINAL` remains **NOT_FROZEN**.

## Command

`results\A7-NATIVE-GRAPH\ASTRA-C1-C3-CANONICAL-IMAGE-TRANSFER-01\run_xsim.ps1` exit 0.

Marker `ASTRA_C1_C3_CANONICAL_IMAGE_TRANSFER_01_XSIM_PASS` at **3008185 ns**.
GOLDEN SHA `b54179d8c9c8f426a127f0e92380c075b0315b139e96b773a5e4cce5046a23e1` hashed before xvlog; not regenerated.

## DUT

- Named C3 `a7ng_astra_c3_held_out_nb64k` (old bag, unedited) `e4c85aab…`
- Named ckpt `a7ng_astra_c5_sgd32_ckpt` `e419caef…`
- Image law `gen_800k.svh` `cd327310…` (same pin as `ASTRA-C1-IMAGE-CONTRACT-01`)
- C1 extract KEEP still `cd7baf49…`. C3 wrap KEEP still `cfb89632…` (not compiled as DUT). Live prod_top still `c4fcca30…`. C2 KEEP still `86a7a069…` (not on `0x06000000`).

Load port is **ckpt only**. TB never writes w[1:31].

## Measured (this-gate, modeled AXI)

| Class | Result |
|---|---|
| 5-seed A/B/C/D | A=40/40 B=0 C=0 D=40, gain 100pp, pair 5/5 |
| snap | 9 nonzero, w0=30 |
| flush after persist | all 32 weights 0 |
| exact32 AXI reload | nmiss=0 all 5 seeds |
| reload hold | pre=40 post=40 drop_pp=0 |
| host winner/addr | 0 |

## Limitations

- Cartesian 1-hop `"feeds"` + C3 fact_pack; same conf-rank tautology as `ASTRA-C3-HELD-OUT-800K-01`.
- Modeled AXI, not MIG/NVM/board. Pending proof/phi restore still OPEN.
- Dictionary DDR text image still NOT_PINNED. CAND_CAP 16 not frozen from bus traffic.
- Does not close Master C1/C3 or C7 silicon.
