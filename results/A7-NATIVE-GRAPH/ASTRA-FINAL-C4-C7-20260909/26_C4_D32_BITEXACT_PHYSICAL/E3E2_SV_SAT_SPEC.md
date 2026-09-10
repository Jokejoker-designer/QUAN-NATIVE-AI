# E3e2 — S_V leftover `c4_sat` (only if E3e top-N says so)

**PROGRAM=NO.** Do not start until `timing_n20_e3e.rpt` is parsed.

## Trigger

`finish_e3e_ooc.py` / `parse_e3e_n20.py` `next_gate == E3e2_SV_SAT`:

- worst dest family still `vv_wdata`
- source is `rq_*` **or** logic levels dropped well below the E3d 48-level MAC+rq cone

If source is still `di_reg` at high depth (`E3e_SV_NOT_CUT`), this gate is **forbidden**. Fix the snapshot/handshake, do not add a sat pipeline on a still-combo MAC.

## Law

`S_V_FIN` today:

```text
vv_wdata <= c4_sat(rq_q)[15:0];
```

`c4_sat` stays the existing D32 function. Do not put sat inside `rq_mcycle`. Extra cycle OK; GOLDEN n=242 tokens must match.

## Gate

1. GOLDEN.svh n=242
2. New OOC `timing_n20_e3e2.rpt` — do not overwrite E3a/E3d/E3e
3. Do not program. Do not stamp MASTER.
