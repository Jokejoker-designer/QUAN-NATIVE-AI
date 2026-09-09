# FIRST_DIVERGENCE — ASTRA-C6-WHOLECHIP-COFIT-02

PROGRAM=NO. GOLDEN not regenerated.
Hash `1d9edf3cd94306dcf7ef41ec057c312b9ead718320031c3a22cc330d8158869b`.

## r0

FACT from `vivado.log` / wrapper (exit 1, ~315 s):

- KEEP hashes MATCH. `C6WC_SHA_FROZEN`. `C6WC_START PROGRAM=NO`.
- `synth_design completed successfully` then `C6WC_SYNTH_DONE`.
- `UTIL_EXTRACT_SYNTH.txt`: LUT=9304 FF=7054 BRAM_TILE=0 DSP=0.
- `CLASS_cdc_reviewed` / `CLASS_c5_prod_inst` / `CLASS_mig_user_design` / `CLASS_no_a09_top` / `CLASS_no_program_hw` HIT.
- `opt_design` DRC 0 Errors, then Phase 3 Retarget: `Abnormal program termination (EXCEPTION_ACCESS_VIOLATION)`.
- `hs_err_pid73748.log`: no stack. Wrapper `C6WC_PS_MISS viv_exit=-1073741819`.

INFERENCE: Vivado 2026.1 tool crash in Retarget, not a WNS/KEEP miss. C6-01 Retarget completed on wrap `0b597f9d…`. Live wrap `64275ba0…`.

r1 TCL-only: resume `ckpt/synth.dcp`; `opt_design -propconst -sweep` (no Retarget); `maxThreads 4`. GOLDEN frozen. KEEP unedited.

## r1

FACT from raw `ROUTE_LETTERS.txt` / `vivado.log` (exit 1):

- `C6WC_OPT_DONE` `C6WC_PLACE_DONE` `route_design completed successfully`
- Signoff `WNS=-0.019 TNS=-0.019 WHS=0.012 THS=0.000 UNROUTED=0 DRC_ERROR_FATAL=0`
- `CLASS_wns_ge0 MISS` `CLASS_tns_0 MISS` marker `ASTRA_C6_WHOLECHIP_COFIT_02_MISS`
- Bit not written. PROGRAM=NO.

INFERENCE: skipping Retarget plus UART-loop netlist left 19 ps setup fail (C6-01 WNS=+0.074 on older wrap).

r2 TCL-only: resume `ckpt/route.dcp`; post-route `phys_opt_design` then `route_design -tns_cleanup`. GOLDEN frozen. KEEP unedited.

## r2 PASS (raw ROUTE_LETTERS.txt)

FACT: WNS=0.150 TNS=0 WHS=0.012 THS=0 UNROUTED=0 DRC_ERROR_FATAL=0 FIT_OK=1
marker `ASTRA_C6_WHOLECHIP_COFIT_02_PASS`. Bit written, PROGRAM=NO.
GOLDEN still `1d9edf3cd94306dcf7ef41ec057c312b9ead718320031c3a22cc330d8158869b`.
Not C6_MASTER. Not BOARD_PASS.
