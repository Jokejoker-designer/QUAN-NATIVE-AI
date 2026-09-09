# CLOSEOUT — ASTRA-C5-AXI-ERRORS-04B

PROGRAM=NO. Named `a7ng_astra_c5_prod_top_resp` SHA
`885bd05ea4f0cb4caf4c69af1a6cc93af2f941f30b7c7614631c6fb693e5c11f`.
Live `prod_top.sv` still `c4fcca30…`. C3 wrap still `cfb89632…`.
grounded_gen KEEP still `1fbdc00a…`. `ddr_arb` still `00f58cf5…`.
`prod_top_stream` still `0bd48fe1…`. Does **not** stamp C5_MASTER.

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C5-AXI-ERRORS-04B\run_xsim.ps1
exit=0
```

## Raw

- GOLDEN.json SHA256 `8d47ad26a82899eb687f680ab11a905b1383df426c57b781fd74a7ad80323962` (hashed before first xvlog, not regenerated)
- First xvlog/xelab/xsim PASS. No TB plant corrective.
- `$finish` 115455 ns
- Marker `ASTRA_C5_AXI_ERRORS_04B_XSIM_PASS`
- Sim override CLK_HZ=8000 BAUD=800 CPB=10. DUT file defaults remain 83333333/115200.
- C3 fact SLVERR latched `last_c3_rresp=2` (st=UNKNOWN). Persist BRESP SLVERR: `ckpt_fail=5` `persist_valid=0`. Reload RRESP SLVERR: `ckpt_fail=6` `restored=0` weights stay zero. Delayed AW/W/B still OKAY-completes persist (`wstrb=ffff`, last AW `0x06000050`). Flush then OKAY reload exact-32 (`crest=1` w0=10). Counts `n_ar=n_r=46` `n_aw=n_w=n_b=7`.

## Classes HIT

adp_not_okay, bresp_slverr, rresp_slverr, b_stall, no_drop, okay_persist_reload.

Limitation: modeled AXI through named adapters, not MIG PHY, not NVM, not board. Live prod_top still fabricates OKAY. 04A 115200 pin-decode is on the stream sibling, not this bag.

REVIEW_PENDING. self_accept=false.
