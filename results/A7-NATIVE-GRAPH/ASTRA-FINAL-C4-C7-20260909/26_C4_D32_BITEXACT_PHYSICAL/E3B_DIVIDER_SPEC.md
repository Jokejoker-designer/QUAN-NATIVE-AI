# E3b divider spec

`PROGRAM=NO`. `E3B=BLOCKED` until `timing_n20.rpt` exists from the in-flight
OOC run (or authority accepts the single worst-path INFERENCE). Candidate RTL
exists but is **not** wired into D32. D32 SHA must remain `34d93493…`.

Integer law (keep bit-exact with D32 S_SMRES / `quantize_c4_parity.py` on
non-negative softmax):

```text
eden == 0  →  q = 0
else       →  q = (elut[ti] * 32767 + (eden / 2)) / eden   // 32-bit SV toward-zero
attn[ti]   ← q
psum       ← (ti==0 ? 0 : psum) + q     // same q, not a second divide
S_SMFIX    → attn[amax] += (32767 - psum)
```

Python IntegerModel: `(e*32767+den//2)//den` (floor). Equal to SV `/` when
`e>=0` and `den>0` (legal Lut path).

## Width FACT (2026-09-09)

`softmax_exp_q15.hex`: n=4097, min=0, max=32767. TMAX=24.
Legal `num = elut[ti]*32767 + eden/2` max = 1074069493 < 2^31.
`elut = TMAX*LutMax` is **not** a legal `elut[ti]`. 32-bit SV matches D32.
48-bit product is not required on this envelope.

## Microarchitecture (when E3a top-N unblocks)

Shared multicycle signed divider, one transaction:

1. Snapshot 32-bit `num = elut[ti]*32767 + (eden/2)`, `den = eden`, `idx = ti`.
2. `start` → `busy` → `done` (33 cycles if den!=0; 1 cycle if den==0).
3. Advance `ti` / leave `S_SMRES` only on `done`.
4. Reject overlapping start; do not reuse a stale quotient.
5. One quotient feeds both attn and psum.
6. No approximate reciprocal unless a later differential proves token parity.
7. No false-path / multicycle constraint to hide the old combo `/`.

Unit sim: `SMRES_DIV_IVERILOG_RESULT.json` PASS n=13, still NOT_INSTANTIATED.
XSim + frozen GOLDEN.svh replay (`13_C4_DIFFERENTIAL_V3`) still required after
integrate.

Do **not** change D/F, F/R weights, scales, context, or feedback.

## Related synth facts (E3c later)

`vivado_e3a_topn.log` already shows RAM in registers because of async reset
(`qv_reg`, `zv_reg`, `logits_reg`). That is a separate step after divider
PASS. BRAM=0 on prior OOC is consistent. RTL component stats: 2499×21-input
1-bit muxes and one 31x32 multiplier (combo `elut*32767` hypothesis).
