# C3 ID / proof identity (source-backed)

PROGRAM=NO. C4_MASTER=OPEN. C5_MASTER=OPEN. BOARD_PASS=OPEN.

Inquiry depth: Level 2. Primary source = live C3 wrap RTL, not prior agent prose.

## 1. `proof0_o` / `proof1_o` semantic identity

**FACT.** `a7ng_astra_c3_held_out.sv` parameter `ID_W = 20`. Ports `ans_o`, `proof0_o`, `proof1_o` are `[ID_W-1:0]`.

**FACT.** Assignments:

```text
ans_o     = best_a
proof0_o  = best_p0
proof1_o  = best_p1
proof_ok_o = proof_ok
```

**FACT.** On 1-hop (`S_ED`):

```text
pp0 <= fe[ei]          // m_axi_rdata[67:48]
pp1 <= 20'd0
pans <= fo[ei]         // m_axi_rdata[39:20]
```

**FACT.** On 2-hop (`S_EJ`):

```text
pp0 <= fe[ei]
pp1 <= fe[ej]
pans <= fo[ej]
```

**FACT.** `fe` is loaded from `m_axi_rdata[67:48]` and is also the field matched to sparse-walk `cbuf` / `cand_id`. Address is `FACT_BASE + {cand_id, 4'd0}`.

**FACT.** `fs` = `[19:0]`, `fo` = `[39:20]`. Matching law:

```text
fs == {{12{1'b0}}, r_subj}
fo == {{12{1'b0}}, r_obj}   // when obj valid
```

**INFERENCE.** `proof0_o` / `proof1_o` are **fact-record IDs** (`fe`), not SRC/DST entity endpoints. `ans_o` is the concluding-hop **object entity** (`fo`).

**CONTRADICTED** as a production map: V2 contract names `proof_src_id` / `proof_dst_id` as “C3 proof source/dest endpoint id”. Those names are **not** the same net as C3 `proof0_o` / `proof1_o`.

**CONTRADICTED** as V2 production: historical `a7ng_astra_c4_lm06_byte256_c3proof.sv` slices `lat_ans[7:0]` into a dest-name image. That is the truncation class this wrap must not repeat.

## 2. Actual entity ID width

| Space | Width | Source |
|---|---|---|
| QSE `subj_id_o` / `obj_id_o` / `rel_id_o` / `ctx_id_o` | 8 | `a7ng_query_role_extract.sv`; C3 `subj_o`/`obj_o` |
| QSE lexicon | 8-bit IDs, words up to 12 chars, N=59 | `qse_role_lexicon.svh` (`QSE2_ID`, `QSE2_MAX_WORD=12`) |
| Fact payload `fs`/`fo`/`ans_o` | 20-bit wires | C3 `S_R` load; match uses zero-extend 8 |
| Sparse / fact record `cand_id` / `fe` / `proof0` / `proof1` | 20 | C3 + `a7ng_query_axi_sparse_intersect_synonym.sv` `ID_W=20` |
| Materializer V2 `proof_*_id` | 8 | **local dictionary slot**, not C3 ID |

**UNKNOWN.** Whether any live DDR fact stores nonzero `fs`/`fo` high 12 bits. This wrap’s matching law would ignore those facts.

**FACT.** QSE words are not the V2 4-char endpoints (`chiller` is 7 chars). Truncating a QSE word to 4 bytes is not a verified vocalization map.

## 3. `qse_dir` encoding

**FACT.** Live extract: `assign direction_o = 2'd0;` (`a7ng_query_role_extract.sv`).

**FACT.** Draft parser comment: `assign direction_o = 2'd0; // as-written SVO; reverse voice is a later grammar`.

**FACT.** Synonym walker forwards `dir_w` to `direction_o`. C3 captures `qse_dir` and **does not use or export it**.

**FACT.** `a7ng_astra09_pipe.sv` latches `r_dir <= qse_dir` (different module; not the live C3 wrap).

**OPEN.** Encoding of any value other than `2'd0`. Do not map `2'd1` to C4 R bank from parser output.

**INFERENCE.** Reverse C4 bank cannot come from live C3 direction until extract emits a proven reverse code. Wrap `bank_r_i` is an **explicit** pin. TB R case keeps `direction_i=2'd0` and sets `bank_r_i=1`.

## 4. Real `proof_ok` source

**FACT.** `proof_ok` is a C3 flop. Reset/IDLE/AMB/NEG/INCOMP/CONFLICT/UNKNOWN/path overflow all write `1'b0`.

**FACT.** The only `proof_ok <= 1'b1` is `S_PICK` together with `r_st <= A7NG_C3_ST_ANSWER`.

**FACT.** G05 gate: `status==ANSWER && npath!=0 && proof_ok`. Never tie to `1'b1`.

**FACT.** Live `a7ng_astra_c5_prod_top.sv` and sibling `prod_top_resp.sv` do **not** connect `proof_ok_o` (no `proof_ok` identifier in those files).

## Production wiring (OPEN)

Until a source-backed map exists, C5 must **not**:

- feed `proof0_o`/`proof1_o` into ENTITY_ALIAS_V1
- slice any 20-bit ID to 8 bits because a ROM is 256-deep
- derive `bank_r` from `qse_dir`

Candidate endpoint wires (not frozen):

- SRC: selected-path `fs`, or `{12'b0, subj_o}` — **not proven equivalent to V2 proof_src**
- DST: `ans_o` (`fo` of concluding hop)

`ENTITY_ALIAS_V1` keys remain 20-bit exact match. TB dictionary is synthetic. Production dictionary **OPEN**.
