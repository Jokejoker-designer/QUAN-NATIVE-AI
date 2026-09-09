# G06-A PASS

**PROGRAM=NO. C4_MASTER=OPEN. BOARD_PASS=OPEN.**

Marker: `ASTRA_C4_G06A_MATERIALIZER_V2_XSIM_PASS`

Independent Python golden hashed before xvlog. RTL `a7ng_astra_c4_materializer_v2` matches:

- same `(src_id,dst_id)` ⇒ F/R identical except opcode
- SRC once, DST once, PAD `----`
- overflow missing id ⇒ `????`, `valid=0`
- ports: direction, `proof_src_id`, `proof_dst_id`, dictionary only

Not C4_MASTER. Not Confirm V2.
