# E3b S_SMRES integration — NOT APPLIED

`PROGRAM=NO`. Do not run `apply_e3b_smres.py --force-after-n20` until
`E3A_N20.json` has `e3b_unblocked: true`.

Handshake (one quotient for attn and psum):

```text
S_SMRES hold=0  → start=1, hold=1
        hold=1  → start=0; on done: attn=q, psum+=q, hold=0, ti++
```

`xvlog` after apply must compile `a7ng_astra_c4_smres_div_mcycle.sv` with D32.
Do not XSim while bag-26 OOC holds the BASIC license.
D32 SHA `34d93493…` must change only at that apply.
