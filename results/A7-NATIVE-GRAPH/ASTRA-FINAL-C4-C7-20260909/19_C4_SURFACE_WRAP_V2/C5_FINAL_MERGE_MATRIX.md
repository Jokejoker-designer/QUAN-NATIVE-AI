# C5_FINAL_MERGE_MATRIX

PROGRAM=NO. C5_MASTER=OPEN. C5 `final_v1` **not created this step**. Integrate the C4 wrap only after wrap XSim smoke.

Do not Copy-Item a sibling and search-replace. Each row is a **contribution** from a named source file. Live `a7ng_astra_c5_prod_top.sv` and C6 `a7ng_astra_c6_wholechip.sv` stay on the old top until a hand-built merge exists.

## Sibling → contribution

| Need | Contributing sibling / module | What to take | What not to take |
|---|---|---|---|
| **RESP** | `a7ng_astra_c5_prod_top_resp.sv` (`a7ng_astra_c5_axi1b_resp`) | AXI RRESP/BRESP/RID/BID/RLAST passthrough; `s_rresp = bufr` from MIG; `last_c3_rresp_o`. Does not fabricate OKAY. | D4 `grounded_gen`; no `proof_ok`; still `a7ng_astra_c5_sgd32_ckpt` (weights-only). |
| **STREAM** | `a7ng_astra_c5_prod_top_stream.sv` | UART TX drains `tfifo[0:7]` from `g_tok` / status byte, not `last_gen`-only. | Same D4 gen; live top still last-token TX. |
| **REWARD** | `a7ng_astra_c5_prod_top_rew.sv` | No auto `+3`. Host UART frame `CMD_REWARD=8'h16`, ver/session/txn/gen/scalar/CRC/len (`A7NG_C5P_REW_*`). `c3_rew` reset `0`. | Do not wire live C3 txn/gen as reward identity (rew header). resp/stream already inherited this parse. |
| **PENDING** | `a7ng_astra_c5_sgd32_ckpt_pend.sv` + `a7ng_astra_c3_held_out_pendld.sv` | Schema 2 snapshot: 32 weights + **20-bit** `p0/p1/ans` + 32 phi + txn/gen/pend flags. | **Not instantiated** in resp/stream/rew/live tops (they use `a7ng_astra_c5_sgd32_ckpt`, weights only). |
| **D32** | `a7ng_astra_c4_lm06_d32_fr_v2.sv` | F/R banks, W8/A12, `n_host_tok_o=0`, HEX from TRAIN-only PTQ. | Not `grounded_gen`, not BYTE256 qptext/ctxcopy, not D4 mem. No sibling C5 top instantiates this yet. |
| **MATERIALIZER** | `a7ng_astra_c4_materializer_v2.sv` | V2 16-byte OP/SRC/DST/PAD. No `answer_i` / `target_slot`. Slot IDs are local. | Do not pass truncated C3 IDs as `proof_src_id`. |
| **SAFETY** | `a7ng_astra_c4_answer_gate_v1.sv` + D32 `S_SAFE` | Gate: `ANSWER && npath!=0 && proof_ok` (real C3 pick). Alias miss/ovf → `answer_allowed=0` → hardware `n,o,EOS`. | Live/resp C5 never connect `proof_ok_o`. resp ST_WAITQ fires D4 gen on ANSWER without that gate. |

## Live top (do not merge from)

`a7ng_astra_c5_prod_top.sv`:

- `s_rresp = 2'b00` fabricated OKAY
- auto `c3_rew <= 4'sd3` on ANSWER
- UART last generated token
- `a7ng_astra_c4_lm06_grounded_gen`
- C6 still instantiates this module

## C4 wrap (this bag, after smoke)

`a7ng_astra_c4_prod_wrap_v2.sv`:

```text
c3_status / n_path / proof_ok
direction_i (observed; only 2'd0 known)
bank_r_i (explicit F/R; not decoded from qse_dir)
entity_src/dst [19:0]  → ENTITY_ALIAS_V1 exact CAM
                       → local slots 0/1 → materializer V2
                       → answer_allowed
                       → D32 V2  or  S_SAFE
```

## Integration order (locked)

1. Wrap 4-case XSim PASS (F / R / non-ANSWER / 20-bit alias miss).
2. Hand-build `final_v1` from this matrix (not Copy-Item of resp).
3. Do not point C6 at `final_v1` until that top has its own evidence.

`C5_INTEGRATE=NO` until step 1 is recorded in this bag’s `xsim.log`.
