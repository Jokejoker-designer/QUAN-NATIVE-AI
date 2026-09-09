# C3 ANSWER → C4 gate invariant

PROGRAM=NO. Do not tie `c3_proof_ok_i` to `1'b1`.

## FACT from `a7ng_astra_c3_held_out.sv`

- `r_st <= A7NG_C3_ST_ANSWER` occurs only in `S_PICK` (line ~445).
- `S_PICK` is reached only from `S_SW` after scoring `np` paths.
- `S_SC` is entered only when `np != 0`, `!r_conf`, and `!path_ovf` (S_EI).
- Other terminals: UNKNOWN (`np==0`), CONFLICT, INCOMP, AMB, NEG. None of those assign ANSWER.

## INFERENCE

`status==ANSWER` already implies a non-empty accepted path set. The gate still requires `npath!=0` and an explicit `proof_ok` export so a future C3 edit cannot silently reintroduce ANSWER without proof.

Until `proof_ok_o` is added on C3, C5 must not fake it. Integration work (G08) must export a signal set in `S_PICK` and cleared on IDLE/non-ANSWER.

## Export (G05)

`a7ng_astra_c3_held_out` now has `proof_ok_o`:
- `1` only in `S_PICK` together with `r_st <= ANSWER`
- `0` on reset, `S_IDLE`, and every non-ANSWER terminal

Do not tie `c3_proof_ok_i` to `1'b1` in any production C5 top.
