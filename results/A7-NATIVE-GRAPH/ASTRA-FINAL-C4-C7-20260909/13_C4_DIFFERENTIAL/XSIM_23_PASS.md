# G04 23-case XSim PASS (not C4_MASTER)

**PROGRAM=NO. C4_MASTER=OPEN. BOARD_PASS=OPEN.**

- Marker: `ASTRA_C4_D32_FR_V1_XSIM_PASS n=23`
- `CLASS_ref_match HIT`
- `CLASS_host_tok0 HIT`
- `C4_MASTER_CLAIM=NO`

Frozen GOLDEN.svh SHA256 (pre-xvlog, unchanged by the S_EMB fix):

```text
dac39a6b46f4d24188629b8dfefed181718455105a0cdc16ce9b3524d924524c
```

Post-fix probe case 0 matched IntegerModel `x`, `q`, `dots`, `attn[7]`, `logits[g,h,o]`, argmax `'h'`.

This is the WO targeted internal-trace subset (historic F/R + replaced + safe + zero_w). It is **not** RTL vs INT 360/360. Next: `13_C4_DIFFERENTIAL_WO360`.
