# CLOSEOUT — ASTRA-C4-LM06-BYTE256-DICT-HELDOUT-01

PROGRAM=NO. Marker `ASTRA_C4_LM06_BYTE256_DICT_HELDOUT_XSIM_PASS` on raw `xsim.log`.
`C4_MASTER=OPEN`. `BOARD_PASS=REJECT`. `LM06_BYTE256=NOT_FROZEN`.

This-gate: FPGA-visible ASCII dictionary VOCAB_VER=1, QUERY/PROOF bytes,
compact BYTE256 copy-head, preregistered hold objs {20..39} disjoint from
declared train {10..19}. GOLDEN hash unchanged
`b0bb252e6975bbb642f7f55f11feb2cb637633322950c6b982e0702ad2d37f62`.

Measured on this compact set (not Master close, not TinyGPT-802k):
- `CLASS_grounded_acc_ge90 HIT acc=20/20 acc_pp=100`
- `CLASS_unsupported_safe_ge95 HIT safe=20/20 pp=100`
- `CLASS_halluc_le5 HIT hall=0/20`
- zero weights → EOS; evid obj 20→50 changes name bytes
- host next-token = 0

Quality bound: compact copy-from-PROOF-span head. Independent auditor must
hunt dictionary tautology before any C4_MASTER stamp. TinyGPT-802k remains
acc=0/2. This bag does not freeze BYTE256 or program silicon.
