# CLOSEOUT — ASTRA-C4-LM06-BYTE256-CTXCOPY-01

PROGRAM=NO. Marker `ASTRA_C4_LM06_BYTE256_CTXCOPY_XSIM_PASS` start-of-line on raw `xsim.log`.
`C4_MASTER=OPEN`. `BOARD_PASS=REJECT`. `LM06_BYTE256=NOT_FROZEN`.

This-gate: BYTE256 head whose candidate IDs are PROOF context bytes
(`proof0/1/2`), not `a7ng_c4d_ch(obj)` and not an `evid_obj` port.
VOCAB_VER=2. Hold objs {20..39} disjoint from declared train {10..19}.
GOLDEN hashed before xvlog and unchanged
`d1000b0f51ae0402a6c501f546e2365709b4d0efb2a731e4cfdc06ad8f9bb08a`.
DUT hash `c1ba3e20…`. xvlog analyzed BYTE256 + ctxcopy + TB only.
`$finish` 10095 ns. Wrapper exit 0.

Measured on this compact set (not Master close, not TinyGPT-802k):
- `CLASS_no_obj_lut HIT dut_ports=proof0_1_2_not_evid_obj`
- `CLASS_query_proof_bytes HIT q0=81 p0=85`
- `CLASS_grounded_acc_ge90 HIT acc=20/20 acc_pp=100`
- `CLASS_unsupported_safe_ge95 HIT safe=20/20 pp=100`
- `CLASS_halluc_le5 HIT hall=0/20`
- zero weights → EOS; evid-replaced proof bytes change tok0
- host next-token = 0; KEEP C0/C1/C2 MATCH mismatches=0 including SGD `b66ef328…`

Quality bound: TB plants PROOF bytes (same name formula as dict TB `gold_ch`).
DUT copies those bytes; it does not contain an object LUT. This is still
extractive context-copy, not TinyGPT language. Independent auditor must hunt
TB-planted-PROOF tautology before any C4_MASTER stamp. TinyGPT-802k remains
acc=0/2. This bag does not freeze BYTE256 or program silicon.
