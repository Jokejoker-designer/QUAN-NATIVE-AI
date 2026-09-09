# CLOSEOUT — ASTRA-C5-UART-STREAM-04A

PROGRAM=NO. Named `a7ng_astra_c5_prod_top_stream` SHA
`0bd48fe1228065bf0c8e12fee7cc3244784bed861f781ed9bbbc4c51b755989c`.
Live `prod_top.sv` still `c4fcca30…` (still 8000/800). grounded_gen KEEP still
`1fbdc00a…`. Does **not** stamp C5_MASTER. 04B AXI RESP remains OPEN.

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C5-UART-STREAM-04A\run_xsim.ps1
exit=0
```

## Raw

- GOLDEN.json SHA256 `c9d35cc27fc844c1d55df91b0353848e00d512e23ed59ec68c4874e17a360fc0` (hashed before first xvlog, not regenerated)
- First FAIL `Q1_GE3` at dest=64 / token0=EOS: gen n_out=1 so last_gen-only was indistinguishable. r0 log kept. One TB plant corrective: 1-hop dest=11 (`pump requires valve`).
- `$finish` 4331418 ns
- Marker `ASTRA_C5_UART_STREAM_04A_XSIM_PASS`
- Defaults CLK_HZ=83333333 BAUD=115200 CPB=723. SIM_OVERRIDE_8000_800=NO. TB clock 12 ns.
- Pin decode: 4 bytes `{11,11,11,11}` then EOL. n_stream=4 gnout=4 nutx=5. Consecutive Q2 same. ovf=0.

## Classes HIT

stream_ge3, not_last_only, pin_decode, n_eq_gen, fifo_ovf0, consec_stream.

Limitation: tokens are four copies of object class ID 11, not QUERY/PROOF language. Transport this-gate only.

REVIEW_PENDING. self_accept=false.
