# E1c — production alias boot (written plan)

**PROGRAM=NO.** Do not freeze. Do not program. Do not modify D32. E3AB=DO_NOT_START.

## Why

C6 `alias_wr_*` tied 0 → CAM `aval=0` → wrap `answer_allowed=0` → silicon F/R is S_SAFE. P5/P6 cannot pass on that wrap.

## Image law

- Keys: full 20-bit C3 endpoint IDs (plant graph `ans` wires). Never QSE 8-bit, never `id[7:0]`, never Confirm-V3 4-char packing as the key.
- Values: V2 4-char little-endian symbols measured from D32/C5 E1a UART (`tifh` valve, `vmgh` pump). Not English `valve`/`pump` strings.
- N=8 CAM. Unused rows `valid=0`.
- Boot: after `c5_rst_n`, C6 writes the image once, then holds `dict_lock=1` and `alias_wr_v=0`. No host rewrite between queries.
- Truncation trap recorded in JSON (`20'hA000B` must not collide with `11`) — not installed as a valid row.

## This close vs TB

`tb_oracles.svh` is labeled test-only. The C3 IDs `10` (pump) and `11` (valve) are the same endpoint numbers C3 emits as `c3_ans` on the KEEP plant queries. The image cites that C3 wire identity, not the TB file as corpus.

## Status after this patch

`production_dictionary` = `IMAGE_IN_TREE_BOOT_WIRED`. Not exam-locked until C6 post-route + C4/C5 acceptance. XSim of boot waits for BASIC (do not steal Gemini/C6).
