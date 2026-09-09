# CLOSEOUT — ASTRA-C4-LM06-BYTE256-C3PROOF-01

PROGRAM=NO. Marker `ASTRA_C4_LM06_BYTE256_C3PROOF_XSIM_PASS` start-of-line on raw `xsim.log`.
`C4_MASTER=OPEN`. `BOARD_PASS=REJECT`. `LM06_BYTE256=NOT_FROZEN`.

This-gate: live C3 wrap (`cfb89632…` unedited) retrieves planted 2-hop dest IDs;
FPGA dest-name image `a7ng_c4p_ch(ans[7:0])` materializes PROOF bytes; existing
BYTE256 ctxcopy emits them. TB plants graph facts only (no PROOF ASCII ports).
Hold dests {40..59} disjoint from declared train dests {20..39}.
GOLDEN hashed before xvlog and unchanged
`20aac2f884da6a9d0852c0e501b40b7272ecd082502028be250011257ac50758`.
DUT hash `031c20cc…`. `$finish` 49905 ns. Wrapper exit 0.

Measured (not Master close, not TinyGPT-802k):
- `CLASS_c3_reasoner_instantiated HIT wrap=a7ng_astra_c3_held_out`
- `CLASS_ans_matches_planted_dest HIT n=20`
- `CLASS_grounded_acc_ge90 HIT acc=20/20 acc_pp=100`
- `CLASS_unsupported_safe_ge95 HIT safe=20/20 pp=100`
- `CLASS_halluc_le5 HIT hall=0/20`
- zero copy-weight → EOS; dest 40 vs 50 changes tok0
- host next-token = 0; KEEP mismatches=0 including SGD `b66ef328…`

Quality bound: compact modeled AXI, unique gold 2-hop, extractive dict-of-dest
then copy-head. Not TinyGPT language. Not silicon. Does not freeze BYTE256.
