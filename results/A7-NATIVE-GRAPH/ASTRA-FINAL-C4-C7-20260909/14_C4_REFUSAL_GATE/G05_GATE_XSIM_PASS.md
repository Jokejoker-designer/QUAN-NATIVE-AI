# G05 gate XSim PASS (not C4_MASTER)

**PROGRAM=NO. C4_MASTER=OPEN. BOARD_PASS=OPEN.**

Marker: `ASTRA_C4_G05_GATE_XSIM_PASS`

Proven in this TB:

- `ANSWER` is `4'd0`, not `4'd1`
- `answer_allowed` requires `status==ANSWER` AND `npath!=0` AND `proof_ok`
- `proof_ok=0` with ANSWER+npath blocks the learned path
- UNKNOWN / CONFLICT / INCOMP / AMB / NEG → `answer_allowed=0` → D32 `n,o,EOS`

C3 `proof_ok_o` is exported from `S_PICK` only. Production C5 must wire that port; never `1'b1`.

This is not materializer PASS and not C4_MASTER.
