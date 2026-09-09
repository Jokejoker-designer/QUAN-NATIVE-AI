# 验收 tick 56 bag=ASTRA-C4-LM06-BYTE256-ARLANG-01
Checker model MUST be deepseek-v4-pro (not v4.1 — that id does not exist, not flash).
Reject tautology scorecards. This loop never stamps BOARD_PASS.
C3-C5 bags: MASTER_CLOSE=NO unless raw xsim CLASS HIT on real path.
C6 WHOLECHIP: judge RAW ROUTE_LETTERS.txt WNS>=0 TNS=0 WHS>=0 THS=0 UNROUTED=0 DRC_ERROR_FATAL=0.
Master DRC letter is ERROR/FATAL=0, not zero Warning. Documented REQP-1709 Warning does not fail this bag.
Do not treat a DeepSeek .sv draft as the routed DUT. Live wrap a7ng_astra_c6_wholechip.sv is authority.
MASTER_C6_BAG_HIT is not BOARD_PASS and not ASTRA_NATIVE_AI_BOARD_PASS.

## Prior drafts (newest first)
### 20260909T0002Z_checker__tick_checker.md
```
## Independent deepseek-v4-pro check — ASTRA-C4-LM06-GROUNDED-GEN-HELDOUT-20-01

Judged from the raw bag files, not Cursor prose and not any DeepSeek `.sv` draft. This is a C4 XSim gate-only copy — not a Master close, not `BOARD_PASS`, and not the C5/C6 live top.

The raw `xsim.log` is complete through `exit` and names the DUT `a7ng_astra_c4_lm06_grounded_gen`. The decisive evidence is per-query measured token emission, not a single aggregate: for held-out IDs 20..39 the DUT emits `TOK n=1 v=<evid_obj> eos=0 head10=<evid_obj> n_host=0 obj=<evid_obj> has=1` then `TOK n=2 v=0 eos=1`, and the TB observes `HOLD q=<q> gold=<20..39> tok0=<20..39> ntok=2 eos=1`. The zero-weight, corrupt, and evidence-removed arms all independently emit `v=0 eos=1`, so the aggregate `CLASS_grounded_acc_ge90 HIT acc=20/20` is computed from measured DUT outputs against planted TB metadata, not an `acc_a_pp in / HIT out` tautology scorecard. The log also shows `PASS NO_TIMEOUT`, `CLASS_host_next_token_zero HIT`, and `CLASS_eos_or_max HIT saw_eos=20`.

No overclaim is present: `PROGRAM=NO`, `BOARD_PASS=REJECT`, `C4_MASTER=OPEN`, `C4_MASTER_CLAIM=NO`, `LM06_BYTE256=NOT_FROZEN`, `TINYGPT_802K=RETIRED_PER_GROK_550`, and the tail explicitly bounds quality as `COMPACT_V64_CLASS_ID_NOT_LETTER_LANGUAGE`. The bag does not claim letter §10 language and does not self-stamp C4 Master. GOLDEN `56dc578d…` is frozen before xvlog in `GOLD_HASH_PRE_XVLOG.txt` and matched by `KEEP_VERIFY.txt`; DUT `grounded_gen` `1fbdc00a…` is stated unedited and matches `SHA256_POST.txt`.

KEEP: real KEEP names are present — `a7ng_query_role_relctx_synonym.sv`, `a7ng_query_axi_sparse_intersect_synonym.sv`, and `a7ng_astra_c2_persist_commit.sv` — with no invented `parser_keep.sv`/`retrieval_keep.sv`/`learner_keep.sv`. `KEEP_VERIFY.txt` reports `KEEP_MISMATCHES=0`. Caveat: the canonical independent-audit `KEEP_HASHES.json` content itself is not supplied, and the compact C4 `KEEP_VERIFY.txt` does not list the learner `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, so full canonical-set zero-drift cannot be independently re-derived from the JSON; this does not block the gate-only copy because this bag does not claim C4/C5 Master and does not use live prod_top.

ACCEPT is only for a new named XSim bag copy; it does not close `C4_MASTER`, `C5_MASTER`, or `BOARD`.

VERDICT=ACCEPT
TAUTOLOGY=NO
KEEP_SAFE=YES
MASTER_CLOSE=NO
NEXT_UNKNOWN=Whether the canonical KEEP_HASHES.json itself, including the learner hash, independently confirms zero drift across the full C0/C1/C2/live set before any C4 or C5 Master freeze.
```

### 20260908T2158Z_checker__tick_checker.md
```
## Independent deepseek-v4-pro check — ASTRA-C5-QPTEXT-HELDOUT-MIG-01

Judged from raw bag files, not Cursor prose and not any DeepSeek `.sv` draft. This is a C5 XSim gate-only copy — not a Master close, not `BOARD_PASS`, and not the C6 routed DUT.

The raw `xsim.log` tail is clean through `exit` and shows the named DUT `a7ng_astra_c5_prod_top_c4q` through the official Digilent AXI MIG model: `PROGRAM=NO`, `BOARD_PASS=REJECT`, `MIG=YES`, `TO_CYC_TB_DEFPARAM=65535`, `train_subj=10 hold_subj=6`, `DUT=c4q`, marker `ASTRA_C5_QPTEXT_HELDOUT_MIG_XSIM_PASS` before `$finish` at 229706625 ps. The decisive tail-measured tuple is printed before the semantic HITs:

`MEAS POST st=0 ans=112 p0=258 p1=259`

That measured quantity drives `CLASS_heldout_post HIT ans=112 p0=258`, `CLASS_heldout_changed HIT pre=144 post=112`, `CLASS_one_ddr_owner HIT nsw=23 dual=0`, plus `CLASS_no_qid_map HIT`, `CLASS_no_host_winner HIT`, `CLASS_no_a09_top HIT`, `CLASS_no_plant_in_dut HIT`. `CLASS_EXTRACT.txt`/`CLOSEOUT.md` supply the earlier raw-measured semantic lines omitted by the truncated middle of `xsim.log`: `CLASS_mig_calib_complete HIT t=122810625.0 ps`, `CLASS_entities_disjoint HIT train={10} hold={6}`, `CLASS_heldout_pre HIT ans=144 p0=256`, `CLASS_reward_update HIT w0=3 pre=x`. The extra `CLASS_gen_tok0_glue_from_weights MISS tok0=61 tok1=83` is explicitly not in the GOLDEN required substrings and is consistent with TRAIN dest=96 rather than the held-out dest 64. These are measured DUT outputs, not an `acc_a_pp in / HIT out` tautology scorecard.

No overclaim: `C5_MASTER=OPEN`, `C5_MASTER_CLAIM=NO`, `BOARD_PASS=REJECT`, `PROGRAM=NO`, `LM06_BYTE256=NOT_FROZEN`, `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`, quality bound `MIG_PHY_C4Q_HELDOUT_PRE_POST UART_SIM_BAUD GLUE_PLUS_OBJECT`. GOLDEN hash `dc8382bc…` is frozen consistently pre-xvlog, in `CLOSEOUT.md`, `KEEP_VERIFY.txt`, and `CLASS_EXTRACT.txt`; no post-FAIL regeneration appears.

KEEP: real KEEP names are present and matched — `a7ng_query_role_relctx_synonym.sv`, `a7ng_query_axi_sparse_intersect_synonym.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, and `a7ng_astra_c2_persist_*.sv` — with no invented `parser_keep.sv`/`retrieval_keep.sv`/`learner_keep.sv`. `KEEP_VERIFY.txt` reports `KEEP_HASHES_JSON_MISMATCHES=0` and `KEEP_MISMATCHES=0`; live C3 `cfb89632…`, live prod_top `c4fcca30…`, and DUT c4q `e8b5d8e4…` are stated unedited. Caveats: the supplied `xsim.log` is truncated so PRE/TRAIN/calib semantic lines are taken from `CLASS_EXTRACT.txt`/`CLOSEOUT.md`, and the canonical independent-audit `KEEP_HASHES.json` content itself is not supplied.

ACCEPT is only for a new named XSim bag copy; it does not close `C5_MASTER` or `BOARD`.

VERDICT=ACCEPT
TAUTOLOGY=NO
KEEP_SAFE=YES
MASTER_CLOSE=NO
NEXT_UNKNOWN=Whether the full untruncated raw xsim.log and the canonical independent-audit KEEP_HASHES.json itself, not only generated MATCH lines, independently confirm all PRE/TRAIN/calib MEAS semantic HITs before any C5_MASTER freeze.
```

### 20260908T2134Z_checker__tick_checker.md
```
## Independent deepseek-v4-pro check — ASTRA-C5-QPTEXT-UNIFIED-MIG-01

Judged from raw bag files, not Cursor prose and not any DeepSeek `.sv` draft. This is a C5 XSim gate-only copy, not a Master close, not `BOARD_PASS`, and not the C6 routed DUT.

The raw `xsim.log` tail is clean through `exit`: named DUT `a7ng_astra_c5_prod_top_c4q`, `PROGRAM=NO`, `BOARD_PASS=REJECT`, `MIG=YES`, `TO_CYC_TB_DEFPARAM=65535`, `CONFLICT=YES`, and marker `ASTRA_C5_QPTEXT_UNIFIED_MIG_XSIM_PASS` before `$finish` at 349142625 ps. The supplied log is truncated in the middle; the Q1 semantic lines are visible in `CLASS_EXTRACT.txt` and are consistent with the PREREG: two-hop answer `st=0 ans=64`, `tok0=61 glue=61`, `tok1=77 dest=64`, conflict `st=5`, no persist update, flush `w0=0`, C2 reload `w0=3`, plus demotion PASSes. This is not an `acc_a_pp in / HIT out` tautology scorecard: the semantic lines report observed DUT quantities (`ans`, `tok0`, `glue`, `tok1`, `st`, `w0`, `nsw`, `dual`) against TB metadata, and the tail itself independently shows `MEAS Q6 st=6 cap=6` → `CLASS_search_incomp HIT` and `CLASS_one_ddr_owner HIT nsw=53 dual=0`.

No overclaim: `C5_MASTER_CLAIM=NO`, `BOARD_PASS=REJECT`, `PROGRAM=NO`, `LM06_BYTE256=NOT_FROZEN`, `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`. Quality bound is `MIG_PHY_C4Q_UNIFIED_UART_PLUS_POLARITY_CONFLICT UART_SIM_BAUD GLUE_PLUS_OBJECT` — not TinyGPT, not silicon, not the C6-03 routed top.

GOLDEN integrity is clean: `GOLD_HASH_PRE_XVLOG.txt`, `KEEP_VERIFY.txt`, and `CLASS_EXTRACT.txt` all freeze `2612b18607d9164d2db73247b4096f94d4fcf4b6ba4bd2cbea6e7a7a7056ad1e`; no post-FAIL regeneration appears.

KEEP: real KEEP names are present and matched — `a7ng_query_role_relctx_synonym.sv`, `a7ng_query_axi_sparse_intersect_synonym.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, and C2 persist files (`commit`, `multi_slot`, `ddr_stall`, `mig`) — with no invented `parser_keep.sv`/`retrieval_keep.sv`/`learner_keep.sv`. `KEEP_VERIFY.txt` reports `KEEP_HASHES_JSON_MISMATCHES=0` and `KEEP_MISMATCHES=0`; live C3 wrap `cfb89632…`, live prod_top `c4fcca30…`, and DUT c4q `e8b5d8e4…` are stated unedited. Caveats: the canonical independent-audit `KEEP_HASHES.json` content itself is not supplied, and the supplied `xsim.log` is truncated, so Q1 semantic lines are taken from `CLASS_EXTRACT.txt` rather than independently re-derived from the full raw log.

ACCEPT is only for a new named XSim bag copy; it does not close `C5_MASTER` or `BOARD`.

VERDICT=ACCEPT
TAUTOLOGY=NO
KEEP_SAFE=YES
MASTER_CLOSE=NO
NEXT_UNKNOWN=Whether the full untruncated raw xsim.log and the canonical independent-audit KEEP_HASHES.json itself, not only generated MATCH lines, independently confirm all Q1 semantic CLASS hits before any C5_MASTER freeze.
```

### 20260908T2109Z_checker__tick_checker.md
```
## Independent deepseek-v4-pro check — ASTRA-C5-PROD-TOP-QPTEXT-MIG-01

Judged from the raw bag files, not Cursor prose and not any DeepSeek `.sv` draft. This is a C5 XSim gate-only copy — not a Master close, not `BOARD_PASS`, not the routed C6 DUT.

The raw `xsim.log` tail is clean through `exit` and shows the named DUT `a7ng_astra_c5_prod_top_c4q` under official Digilent AXI MIG simulation: `PROGRAM=NO`, `BOARD_PASS=REJECT`, `C5_MASTER=OPEN`, `MIG_XSIM=1`, `TO_CYC_TB_DEFPARAM=65535`. The decisive measured tuple is printed before the semantic HITs:

`MEAS nurx=23 nutx=2 seen=3f dual=0 st=0 obj=0 ans=64 tok0=61 tok1=77 glue=61 gold0=77 gdone=1 nht=0 last_aw=6000000 nsw=15 guard=785`

The key semantic lines are driven by that tuple rather than an `acc_a_pp in / HIT out` tautology: `CLASS_ans_matches_planted_dest HIT ans=64`, `CLASS_gen_tok0_glue_from_weights HIT tok0=61 glue=61`, `CLASS_gen_tok1_hop2_obj_name HIT tok1=77 dest=64`, `CLASS_tok0_not_ans_dict HIT tok0=61 gold0=77`, and `CLASS_host_next_token_zero HIT nht=0`. The pipeline checks follow the real UART→parser→sparse index→descriptor retrieval→shared scorer→persist→evidence materializer→LM06 gen→UART egress path, plus six clients (`seen=3f`), one DDR owner (`dual=0`), no host winner, no A09 top, no in-DUT plant, checkpoint `awar=6000000`. The DDR3 model shows extensive MIG read/write activity before the pass, consistent with the `CLASS_mig_calib_complete HIT t=122810625.0 ps` reported in `CLASS_EXTRACT.txt`/`CLOSEOUT.md` (which live in the omitted middle portion of the supplied `xsim.log`).

No overclaim is present: `quality=MIG_PHY_PLANTED_2HOP_GLUE_PLUS_OBJECT UART_SIM_BAUD COMPACT_LM_NOT_802K`, `C5_MASTER=OPEN`, `C5_MASTER_CLAIM=NO`, `BOARD_PASS=REJECT`, `PROGRAM=NO`, `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`, `LM06_BYTE256=NOT_FROZEN`. This is bounded as compact glue-plus-hop-2 object copy through the MIG PHY, not TinyGPT, not silicon, not the C6-03 routed top.

GOLDEN integrity is clean: `GOLD_HASH_PRE_XVLOG.txt`, `KEEP_VERIFY.txt`, `CLOSEOUT.md`, and `CLASS_EXTRACT.txt` all freeze `2ec86b4b1048e681991487ceec49095d6f4dbd3fe8bd3109c32194263bb1b590`; no post-FAIL regeneration appears.

KEEP: real KEEP names are present and matched — `a7ng_query_role_relctx_synonym.sv`, `a7ng_query_axi_sparse_intersect_synonym.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_c2_persist_*.sv` — with no invented `parser_keep.sv`/`retrieval_keep.sv`/`learner_keep.sv`. `KEEP_VERIFY.txt` reports `KEEP_HASHES_JSON_MISMATCHES=0` and `KEEP_MISMATCHES=0`; live C3 wrap `cfb89632…`, live prod_top `c4fcca30…`, and DUT c4q `e8b5d8e4…` are stated unedited/unedited-DUT. Caveat: the canonical independent-audit `KEEP_HASHES.json` content itself is not supplied, so zero-drift is consistent with the generated MATCH lines rather than independently re-derived from that JSON.

ACCEPT is for a new named XSim bag copy only; it does not close `C5_MASTER` or `BOARD`.

VERDICT=ACCEPT
TAUTOLOGY=NO
KEEP_SAFE=YES
MASTER_CLOSE=NO
NEXT_UNKNOWN=Whether the canonical independent-audit KEEP_HASHES.json content itself, not only the generated MATCH lines in KEEP_VERIFY.txt, independently confirms zero drift across the full C0/C1/C2/live-C3/live-prod_top/c4q set before any C5_MASTER freeze is considered.
```


## RAW live bag files (primary evidence, not Cursor prose)
### D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-BYTE256-ARLANG-01\CLOSEOUT.md
```
# CLOSEOUT — ASTRA-C4-LM06-BYTE256-ARLANG-01

PROGRAM=NO. Marker `ASTRA_C4_LM06_BYTE256_ARLANG_XSIM_PASS` on raw `xsim.log`.
`CLASS_grounded_acc_ge90 HIT acc=20/20` plus `CLASS_ar_yes_prefix HIT n=20/20`.

```text
TINYGPT_802K  = RETIRED_PER_GROK_550
LM06_BYTE256  = NOT_FROZEN
C4_MASTER     = OPEN
BOARD_PASS    = REJECT
```

Compact tied-embed AR emits ASCII `yes` + dest-name. Dest-name still enters
through gated obj ports, not TinyGPT. Not letter §10 Master close.

```

### D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-BYTE256-ARLANG-01\SHA256_POST.txt
```
# SHA verify AFTER xsim 2026-09-09T07:06:41.6742656+07:00
f63f35ad5d33210f9387eaba3456105adf222b6e0e9c5c62d78d9e2e2eb8c926  rtl/native_graph/integrate/a7ng_astra_c4_lm06_byte256.sv
e9686f9e784f6e180b8f1006a6d8097f3b88174c993104aedb280299a2a037c9  rtl/native_graph/integrate/a7ng_astra_c4_lm06_byte256_arlang_gen.sv
3916c5f622a87168b7c20f80f6cbbb4e71a7c342e50d7212a5af8b2c47842ec4  results/A7-NATIVE-GRAPH/ASTRA-C4-LM06-BYTE256-ARLANG-01/tb_astra_c4_lm06_byte256_arlang.sv
e369d1f7e9c680b314c8c2efe64f93af74ca4b151903b1992883d8ef405ee602  rtl/native_graph/integrate/a7ng_astra_c4_lm06_byte256_arlang.hex

```

### D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-BYTE256-ARLANG-01\KEEP_VERIFY.txt
```
# KEEP verify after ASTRA-C4-LM06-BYTE256-ARLANG-01 r0 PASS
# PROGRAM=NO. New named AR gen. Not TinyGPT. Not live prod_top.
MATCH rtl/native_graph/query/a7ng_query_role_extract.sv cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27
MATCH rtl/native_graph/query/qse_role_lexicon.svh 381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
MATCH rtl/native_graph/memory/a7ng_sparse_dir_axi.sv 09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24
MATCH rtl/native_graph/integrate/a7ng_query_axi_sparse.sv 5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa
MATCH rtl/native_graph/query/a7ng_route_valid_gate.sv 49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385
MATCH rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv e862208ce34d8835c34fef1b2f2e4d32a91938a26cf22bc3854593ff852ea922
MATCH rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv a84bbf7e9a2c0b9e3753b3cb2e1ae734c2afde59267d733aa0e52108e47d8ec8
MATCH rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv 86a7a0695712d9aa818bf95aac30b83289fb9af80ddd0bdc2455e935a14d8764
KEEP_MISMATCHES=0
GOLDEN frozen MATCH c6b5c0f4fcf80d0ea339f992a7ca2d1f332ca766f12e59b3d062111cc9e11090
DUT arlang_gen e9686f9e784f6e180b8f1006a6d8097f3b88174c993104aedb280299a2a037c9
HEX e369d1f7e9c680b314c8c2efe64f93af74ca4b151903b1992883d8ef405ee602
PROGRAM=NO C4_MASTER=OPEN BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN TINYGPT_802K=RETIRED_PER_GROK_550
NOTE ASCII yes+dest-name this-gate; dest-name still gated obj ports; not letter §10 close

```

### D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-BYTE256-ARLANG-01\xsim.log
```
#-----------------------------------------------------------
# xsim v2026.1 (64-bit)
# SW Build 6511674 on Tue Jun 16 11:02:23 MDT 2026
# IP Build 6504888 on Tue Jun 09 09:05:25 MDT 2026
# SharedData Build 6501428 on Mon Jun 08 17:34:18 MDT 2026
# Start of session at: Wed Sep  9 07:06:36 2026
# Process ID         : 57992
# Current directory  : D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/results/A7-NATIVE-GRAPH/ASTRA-C4-LM06-BYTE256-ARLANG-01/xsim_work
# Command line       : xsim.exe -log D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-BYTE256-ARLANG-01\xsim.log -mode tcl -source {xsim.dir/c4l/xsim_script.tcl}
# Log file           : D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/results/A7-NATIVE-GRAPH/ASTRA-C4-LM06-BYTE256-ARLANG-01/xsim.log
# Journal file       : D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/results/A7-NATIVE-GRAPH/ASTRA-C4-LM06-BYTE256-ARLANG-01/xsim_work\xsim.jou
# Running On         : laptop-Quan
# Platform           : Windows 11
# Operating System   : 22621
# Processor Detail   : AMD Ryzen 7 5800HS with Radeon Graphics         
# CPU Frequency      : 3194 MHz
# CPU Physical cores : 8
# CPU Logical cores  : 16
# Host memory        : 16541 MB
# Swap memory        : 33756 MB
# Total Virtual      : 50298 MB
# Available Virtual  : 11421 MB
#-----------------------------------------------------------
source xsim.dir/c4l/xsim_script.tcl
# xsim {c4l} -autoloadwcfg -runall
Time resolution is 1 ps
run -all
C4_ARLANG V=256 D=32 N=20 PROGRAM=NO BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN C4_MASTER=OPEN
CLASS_not_compose_renderer HIT dut=a7ng_astra_c4_lm06_byte256_arlang_gen
CLASS_not_tinygpt_802k HIT tinygpt=RETIRED_PER_GROK_550
TOK n=1 v=121 eos=0 dst=40 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=40 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=40 has=1 n_host=0
TOK n=4 v=79 eos=0 dst=40 has=1 n_host=0
TOK n=5 v=115 eos=0 dst=40 has=1 n_host=0
TOK n=6 v=48 eos=0 dst=40 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=40 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q0
HOLD q=0 dst=40 tok0=121 ntok=7 seq=121,101,115,79,115,48,0
TOK n=1 v=121 eos=0 dst=41 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=41 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=41 has=1 n_host=0
TOK n=4 v=80 eos=0 dst=41 has=1 n_host=0
TOK n=5 v=120 eos=0 dst=41 has=1 n_host=0
TOK n=6 v=49 eos=0 dst=41 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=41 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q1
HOLD q=1 dst=41 tok0=121 ntok=7 seq=121,101,115,80,120,49,0
TOK n=1 v=121 eos=0 dst=42 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=42 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=42 has=1 n_host=0
TOK n=4 v=81 eos=0 dst=42 has=1 n_host=0
TOK n=5 v=99 eos=0 dst=42 has=1 n_host=0
TOK n=6 v=50 eos=0 dst=42 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=42 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q2
HOLD q=2 dst=42 tok0=121 ntok=7 seq=121,101,115,81,99,50,0
TOK n=1 v=121 eos=0 dst=43 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=43 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=43 has=1 n_host=0
TOK n=4 v=82 eos=0 dst=43 has=1 n_host=0
TOK n=5 v=104 eos=0 dst=43 has=1 n_host=0
TOK n=6 v=51 eos=0 dst=43 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=43 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q3
HOLD q=3 dst=43 tok0=121 ntok=7 seq=121,101,115,82,104,51,0
TOK n=1 v=121 eos=0 dst=44 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=44 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=44 has=1 n_host=0
TOK n=4 v=83 eos=0 dst=44 has=1 n_host=0
TOK n=5 v=109 eos=0 dst=44 has=1 n_host=0
TOK n=6 v=52 eos=0 dst=44 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=44 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q4
HOLD q=4 dst=44 tok0=121 ntok=7 seq=121,101,115,83,109,52,0
TOK n=1 v=121 eos=0 dst=45 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=45 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=45 has=1 n_host=0
TOK n=4 v=84 eos=0 dst=45 has=1 n_host=0
TOK n=5 v=114 eos=0 dst=45 has=1 n_host=0
TOK n=6 v=53 eos=0 dst=45 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=45 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q5
HOLD q=5 dst=45 tok0=121 ntok=7 seq=121,101,115,84,114,53,0
TOK n=1 v=121 eos=0 dst=46 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=46 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=46 has=1 n_host=0
TOK n=4 v=85 eos=0 dst=46 has=1 n_host=0
TOK n=5 v=119 eos=0 dst=46 has=1 n_host=0
TOK n=6 v=54 eos=0 dst=46 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=46 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q6
HOLD q=6 dst=46 tok0=121 ntok=7 seq=121,101,115,85,119,54,0
TOK n=1 v=121 eos=0 dst=47 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=47 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=47 has=1 n_host=0
TOK n=4 v=86 eos=0 dst=47 has=1 n_host=0
TOK n=5 v=98 eos=0 dst=47 has=1 n_host=0
TOK n=6 v=55 eos=0 dst=47 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=47 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q7
HOLD q=7 dst=47 tok0=121 ntok=7 seq=121,101,115,86,98,55,0
TOK n=1 v=121 eos=0 dst=48 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=48 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=48 has=1 n_host=0
TOK n=4 v=87 eos=0 dst=48 has=1 n_host=0
TOK n=5 v=103 eos=0 dst=48 has=1 n_host=0
TOK n=6 v=56 eos=0 dst=48 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=48 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q8
HOLD q=8 dst=48 tok0=121 ntok=7 seq=121,101,115,87,103,56,0
TOK n=1 v=121 eos=0 dst=49 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=49 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=49 has=1 n_host=0
TOK n=4 v=88 eos=0 dst=49 has=1 n_host=0
TOK n=5 v=108 eos=0 dst=49 has=1 n_host=0
TOK n=6 v=57 eos=0 dst=49 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=49 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q9
HOLD q=9 dst=49 tok0=121 ntok=7 seq=121,101,115,88,108,57,0
TOK n=1 v=121 eos=0 dst=50 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=50 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=50 has=1 n_host=0
TOK n=4 v=89 eos=0 dst=50 has=1 n_host=0
TOK n=5 v=113 eos=0 dst=50 has=1 n_host=0
TOK n=6 v=48 eos=0 dst=50 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=50 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q10
HOLD q=10 dst=50 tok0=121 ntok=7 seq=121,101,115,89,113,48,0
TOK n=1 v=121 eos=0 dst=51 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=51 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=51 has=1 n_host=0
TOK n=4 v=90 eos=0 dst=51 has=1 n_host=0
TOK n=5 v=118 eos=0 dst=51 has=1 n_host=0
TOK n=6 v=49 eos=0 dst=51 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=51 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q11
HOLD q=11 dst=51 tok0=121 ntok=7 seq=121,101,115,90,118,49,0
TOK n=1 v=121 eos=0 dst=52 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=52 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=52 has=1 n_host=0
TOK n=4 v=65 eos=0 dst=52 has=1 n_host=0
TOK n=5 v=97 eos=0 dst=52 has=1 n_host=0
TOK n=6 v=50 eos=0 dst=52 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=52 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q12
HOLD q=12 dst=52 tok0=121 ntok=7 seq=121,101,115,65,97,50,0
TOK n=1 v=121 eos=0 dst=53 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=53 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=53 has=1 n_host=0
TOK n=4 v=66 eos=0 dst=53 has=1 n_host=0
TOK n=5 v=102 eos=0 dst=53 has=1 n_host=0
TOK n=6 v=51 eos=0 dst=53 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=53 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q13
HOLD q=13 dst=53 tok0=121 ntok=7 seq=121,101,115,66,102,51,0
TOK n=1 v=121 eos=0 dst=54 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=54 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=54 has=1 n_host=0
TOK n=4 v=67 eos=0 dst=54 has=1 n_host=0
TOK n=5 v=107 eos=0 dst=54 has=1 n_host=0
TOK n=6 v=52 eos=0 dst=54 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=54 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q14
HOLD q=14 dst=54 tok0=121 ntok=7 seq=121,101,115,67,107,52,0
TOK n=1 v=121 eos=0 dst=55 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=55 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=55 has=1 n_host=0
TOK n=4 v=68 eos=0 dst=55 has=1 n_host=0
TOK n=5 v=112 eos=0 dst=55 has=1 n_host=0
TOK n=6 v=53 eos=0 dst=55 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=55 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q15
HOLD q=15 dst=55 tok0=121 ntok=7 seq=121,101,115,68,112,53,0
TOK n=1 v=121 eos=0 dst=56 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=56 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=56 has=1 n_host=0
TOK n=4 v=69 eos=0 dst=56 has=1 n_host=0
TOK n=5 v=117 eos=0 dst=56 has=1 n_host=0
TOK n=6 v=54 eos=0 dst=56 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=56 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q16
HOLD q=16 dst=56 tok0=121 ntok=7 seq=121,101,115,69,117,54,0
TOK n=1 v=121 eos=0 dst=57 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=57 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=57 has=1 n_host=0
TOK n=4 v=70 eos=0 dst=57 has=1 n_host=0
TOK n=5 v=122 eos=0 dst=57 has=1 n_host=0
TOK n=6 v=55 eos=0 dst=57 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=57 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q17
HOLD q=17 dst=57 tok0=121 ntok=7 seq=121,101,115,70,122,55,0
TOK n=1 v=121 eos=0 dst=58 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=58 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=58 has=1 n_host=0
TOK n=4 v=71 eos=0 dst=58 has=1 n_host=0
TOK n=5 v=101 eos=0 dst=58 has=1 n_host=0
TOK n=6 v=56 eos=0 dst=58 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=58 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q18
HOLD q=18 dst=58 tok0=121 ntok=7 seq=121,101,115,71,101,56,0
TOK n=1 v=121 eos=0 dst=59 has=1 n_host=0
TOK n=2 v=101 eos=0 dst=59 has=1 n_host=0
TOK n=3 v=115 eos=0 dst=59 has=1 n_host=0
TOK n=4 v=72 eos=0 dst=59 has=1 n_host=0
TOK n=5 v=106 eos=0 dst=59 has=1 n_host=0
TOK n=6 v=57 eos=0 dst=59 has=1 n_host=0
TOK n=7 v=0 eos=1 dst=59 has=1 n_host=0
PASS NO_TIMEOUT
PASS HOLD_Q19
HOLD q=19 dst=59 tok0=121 ntok=7 seq=121,101,115,72,106,57,0
CLASS_grounded_acc_ge90 HIT acc=20/20
CLASS_ar_yes_prefix HIT n=20/20
PASS ACC_GE90
TOK n=1 v=0 eos=1 dst=40 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q0
TOK n=1 v=0 eos=1 dst=41 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q1
TOK n=1 v=0 eos=1 dst=42 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q2
TOK n=1 v=0 eos=1 dst=43 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q3
TOK n=1 v=0 eos=1 dst=44 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q4
TOK n=1 v=0 eos=1 dst=45 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q5
TOK n=1 v=0 eos=1 dst=46 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q6
TOK n=1 v=0 eos=1 dst=47 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q7
TOK n=1 v=0 eos=1 dst=48 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q8
TOK n=1 v=0 eos=1 dst=49 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q9
TOK n=1 v=0 eos=1 dst=50 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q10
TOK n=1 v=0 eos=1 dst=51 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q11
TOK n=1 v=0 eos=1 dst=52 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q12
TOK n=1 v=0 eos=1 dst=53 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q13
TOK n=1 v=0 eos=1 dst=54 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q14
TOK n=1 v=0 eos=1 dst=55 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q15
TOK n=1 v=0 eos=1 dst=56 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q16
TOK n=1 v=0 eos=1 dst=57 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q17
TOK n=1 v=0 eos=1 dst=58 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q18
TOK n=1 v=0 eos=1 dst=59 has=1 n_host=0
PASS NO_TIMEOUT
PASS ZERO_Q19
CLASS_w_zero_safe HIT n=20/20
PASS ZERO20
TOK n=1 v=243 eos=0 dst=40 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=40 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=40 has=1 n_host=0
TOK n=4 v=126 eos=0 dst=40 has=1 n_host=0
TOK n=5 v=238 eos=0 dst=40 has=1 n_host=0
TOK n=6 v=31 eos=0 dst=40 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=40 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=40 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q0
TOK n=1 v=243 eos=0 dst=41 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=41 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=41 has=1 n_host=0
TOK n=4 v=142 eos=0 dst=41 has=1 n_host=0
TOK n=5 v=178 eos=0 dst=41 has=1 n_host=0
TOK n=6 v=34 eos=0 dst=41 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=41 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=41 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q1
TOK n=1 v=243 eos=0 dst=42 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=42 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=42 has=1 n_host=0
TOK n=4 v=250 eos=0 dst=42 has=1 n_host=0
TOK n=5 v=124 eos=0 dst=42 has=1 n_host=0
TOK n=6 v=51 eos=0 dst=42 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=42 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=42 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q2
TOK n=1 v=243 eos=0 dst=43 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=43 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=43 has=1 n_host=0
TOK n=4 v=98 eos=0 dst=43 has=1 n_host=0
TOK n=5 v=10 eos=0 dst=43 has=1 n_host=0
TOK n=6 v=50 eos=0 dst=43 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=43 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=43 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q3
TOK n=1 v=243 eos=0 dst=44 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=44 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=44 has=1 n_host=0
TOK n=4 v=165 eos=0 dst=44 has=1 n_host=0
TOK n=5 v=227 eos=0 dst=44 has=1 n_host=0
TOK n=6 v=15 eos=0 dst=44 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=44 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=44 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q4
TOK n=1 v=243 eos=0 dst=45 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=45 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=45 has=1 n_host=0
TOK n=4 v=34 eos=0 dst=45 has=1 n_host=0
TOK n=5 v=133 eos=0 dst=45 has=1 n_host=0
TOK n=6 v=238 eos=0 dst=45 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=45 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=45 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q5
TOK n=1 v=243 eos=0 dst=46 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=46 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=46 has=1 n_host=0
TOK n=4 v=6 eos=0 dst=46 has=1 n_host=0
TOK n=5 v=233 eos=0 dst=46 has=1 n_host=0
TOK n=6 v=216 eos=0 dst=46 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=46 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=46 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q6
TOK n=1 v=243 eos=0 dst=47 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=47 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=47 has=1 n_host=0
TOK n=4 v=59 eos=0 dst=47 has=1 n_host=0
TOK n=5 v=86 eos=0 dst=47 has=1 n_host=0
TOK n=6 v=54 eos=0 dst=47 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=47 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=47 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q7
TOK n=1 v=243 eos=0 dst=48 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=48 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=48 has=1 n_host=0
TOK n=4 v=42 eos=0 dst=48 has=1 n_host=0
TOK n=5 v=255 eos=0 dst=48 has=1 n_host=0
TOK n=6 v=47 eos=0 dst=48 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=48 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=48 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q8
TOK n=1 v=243 eos=0 dst=49 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=49 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=49 has=1 n_host=0
TOK n=4 v=10 eos=0 dst=49 has=1 n_host=0
TOK n=5 v=120 eos=0 dst=49 has=1 n_host=0
TOK n=6 v=51 eos=0 dst=49 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=49 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=49 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q9
TOK n=1 v=243 eos=0 dst=50 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=50 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=50 has=1 n_host=0
TOK n=4 v=47 eos=0 dst=50 has=1 n_host=0
TOK n=5 v=81 eos=0 dst=50 has=1 n_host=0
TOK n=6 v=29 eos=0 dst=50 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=50 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=50 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q10
TOK n=1 v=243 eos=0 dst=51 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=51 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=51 has=1 n_host=0
TOK n=4 v=21 eos=0 dst=51 has=1 n_host=0
TOK n=5 v=18 eos=0 dst=51 has=1 n_host=0
TOK n=6 v=34 eos=0 dst=51 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=51 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=51 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q11
TOK n=1 v=243 eos=0 dst=52 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=52 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=52 has=1 n_host=0
TOK n=4 v=31 eos=0 dst=52 has=1 n_host=0
TOK n=5 v=131 eos=0 dst=52 has=1 n_host=0
TOK n=6 v=51 eos=0 dst=52 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=52 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=52 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q12
TOK n=1 v=243 eos=0 dst=53 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=53 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=53 has=1 n_host=0
TOK n=4 v=217 eos=0 dst=53 has=1 n_host=0
TOK n=5 v=221 eos=0 dst=53 has=1 n_host=0
TOK n=6 v=50 eos=0 dst=53 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=53 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=53 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q13
TOK n=1 v=243 eos=0 dst=54 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=54 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=54 has=1 n_host=0
TOK n=4 v=32 eos=0 dst=54 has=1 n_host=0
TOK n=5 v=67 eos=0 dst=54 has=1 n_host=0
TOK n=6 v=176 eos=0 dst=54 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=54 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=54 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q14
TOK n=1 v=243 eos=0 dst=55 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=55 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=55 has=1 n_host=0
TOK n=4 v=233 eos=0 dst=55 has=1 n_host=0
TOK n=5 v=184 eos=0 dst=55 has=1 n_host=0
TOK n=6 v=3 eos=0 dst=55 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=55 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=55 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q15
TOK n=1 v=243 eos=0 dst=56 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=56 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=56 has=1 n_host=0
TOK n=4 v=107 eos=0 dst=56 has=1 n_host=0
TOK n=5 v=144 eos=0 dst=56 has=1 n_host=0
TOK n=6 v=176 eos=0 dst=56 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=56 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=56 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q16
TOK n=1 v=243 eos=0 dst=57 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=57 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=57 has=1 n_host=0
TOK n=4 v=202 eos=0 dst=57 has=1 n_host=0
TOK n=5 v=99 eos=0 dst=57 has=1 n_host=0
TOK n=6 v=217 eos=0 dst=57 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=57 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=57 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q17
TOK n=1 v=243 eos=0 dst=58 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=58 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=58 has=1 n_host=0
TOK n=4 v=130 eos=0 dst=58 has=1 n_host=0
TOK n=5 v=53 eos=0 dst=58 has=1 n_host=0
TOK n=6 v=0 eos=1 dst=58 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q18
TOK n=1 v=243 eos=0 dst=59 has=1 n_host=0
TOK n=2 v=121 eos=0 dst=59 has=1 n_host=0
TOK n=3 v=181 eos=0 dst=59 has=1 n_host=0
TOK n=4 v=15 eos=0 dst=59 has=1 n_host=0
TOK n=5 v=90 eos=0 dst=59 has=1 n_host=0
TOK n=6 v=51 eos=0 dst=59 has=1 n_host=0
TOK n=7 v=202 eos=0 dst=59 has=1 n_host=0
TOK n=8 v=202 eos=0 dst=59 has=1 n_host=0
PASS NO_TIMEOUT
PASS CORRUPT_Q19
CLASS_w_corrupt_not_gold HIT n=20/20
PASS CORRUPT20
TOK n=1 v=0 eos=1 dst=40 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q0
TOK n=1 v=0 eos=1 dst=41 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q1
TOK n=1 v=0 eos=1 dst=42 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q2
TOK n=1 v=0 eos=1 dst=43 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q3
TOK n=1 v=0 eos=1 dst=44 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q4
TOK n=1 v=0 eos=1 dst=45 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q5
TOK n=1 v=0 eos=1 dst=46 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q6
TOK n=1 v=0 eos=1 dst=47 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q7
TOK n=1 v=0 eos=1 dst=48 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q8
TOK n=1 v=0 eos=1 dst=49 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q9
TOK n=1 v=0 eos=1 dst=50 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q10
TOK n=1 v=0 eos=1 dst=51 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q11
TOK n=1 v=0 eos=1 dst=52 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q12
TOK n=1 v=0 eos=1 dst=53 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q13
TOK n=1 v=0 eos=1 dst=54 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q14
TOK n=1 v=0 eos=1 dst=55 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q15
TOK n=1 v=0 eos=1 dst=56 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q16
TOK n=1 v=0 eos=1 dst=57 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q17
TOK n=1 v=0 eos=1 dst=58 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q18
TOK n=1 v=0 eos=1 dst=59 has=0 n_host=0
PASS NO_TIMEOUT
PASS REMOVED_Q19
CLASS_evid_removed_safe HIT n=20/20
CLASS_evid_removed_halluc_le5 HIT hall=0/20
PASS HALL_LE5
CLASS_host_next_token_zero HIT
CLASS_eos_or_max HIT saw_eos=20
PASS HOST0
ASTRA_C4_LM06_BYTE256_ARLANG_XSIM_PASS
C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO LM06_BYTE256=NOT_FROZEN TINYGPT_802K=RETIRED_PER_GROK_550
$finish called at time : 27820055 ns : File "D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/results/A7-NATIVE-GRAPH/ASTRA-C4-LM06-BYTE256-ARLANG-01/tb_astra_c4_lm06_byte256_arlang.sv" Line 150
exit
INFO: [Common 17-206] Exiting xsim at Wed Sep  9 07:06:41 2026...

```

### D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-BYTE256-ARLANG-01\CLASS_EXTRACT.txt
```
# CLASS_EXTRACT — ASTRA-C4-LM06-BYTE256-ARLANG-01

Source: raw `xsim.log` after `.\run_xsim.ps1` (2026-09-09T07:06:41+07:00).

```text
CLASS_not_compose_renderer HIT dut=a7ng_astra_c4_lm06_byte256_arlang_gen
CLASS_not_tinygpt_802k HIT tinygpt=RETIRED_PER_GROK_550
CLASS_grounded_acc_ge90 HIT acc=20/20
CLASS_ar_yes_prefix HIT n=20/20
CLASS_w_zero_safe HIT n=20/20
CLASS_w_corrupt_not_gold HIT n=20/20
CLASS_evid_removed_safe HIT n=20/20
CLASS_evid_removed_halluc_le5 HIT hall=0/20
CLASS_host_next_token_zero HIT
CLASS_eos_or_max HIT saw_eos=20
ASTRA_C4_LM06_BYTE256_ARLANG_XSIM_PASS
```

C4_MASTER not claimed. LM06_BYTE256 not frozen.

```

### D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-BYTE256-ARLANG-01\PREREG.md
```
# PREREG — ASTRA-C4-LM06-BYTE256-ARLANG-01

PROGRAM=NO. Frozen before xvlog. Does not edit KEEP C0/C1/C2, live prod_top,
live grounded_gen, qptext_gen, TinyGPT core / `a7lm06_wmem.hex`.

Does **not** freeze `LM06_BYTE256`. Does **not** self-stamp `C4_MASTER`.

## One unknown

Can a compact tied-embed autoregressive BYTE256 head emit ASCII
`yes` + dest-name tokens from loadable embeddings and PROOF dest-name bytes,
with host next-token = 0, on 20 held-out dest IDs 40..59?

## HIT this bag may measure

```text
normal: seq == [121,101,115,ch0,ch1,ch2,0] on >=18/20
zero embeddings: first token EOS
corrupt (negated dots): sequence != gold
evidence removed: first token EOS; halluc <= 5%
EOS/MAX = 100%
TinyGPT not DUT
```

## Not this bag

Letter §10 Master close. Dest-name still enters through obj ports gated by G[].
This is compact AR language-shaped output, not 802k LM06.

## FAIL if

- KEEP drift, GOLDEN edited after xvlog, PROGRAM=YES, TB chooses next token
- tiny_gpt803k_core or a7ng_evidence_compose as DUT
- overwrite a7lm06_wmem.hex

```

### D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-BYTE256-ARLANG-01\GOLD_HASH_PRE_XVLOG.txt
```
# GOLD hashed BEFORE xvlog 2026-09-09T07:06:07.7250990+07:00
# PROGRAM=NO C4_MASTER=OPEN BOARD_PASS=REJECT LM06_BYTE256=NOT_FROZEN TINYGPT_802K=RETIRED_PER_GROK_550
c6b5c0f4fcf80d0ea339f992a7ca2d1f332ca766f12e59b3d062111cc9e11090  GOLDEN.json

```

## Cursor prior 验收
# Cursor independent accept — ASTRA-C4-LM06-BYTE256-ARLANG-01

ACCEPT=PENDING_AUDITOR_HUNT
CURSOR_C4_ARLANG=PASS_THIS_GATE_ONLY
COPY_TO_LIVE=NO_NEW_NAMED_ARLANG_GEN_NOT_C6_03_PROD_TOP
checker_model=deepseek-v4-pro
VERDICT_FOR_MASTER=REJECT
BOARD_PASS=REJECT
C4_MASTER=OPEN
C5_MASTER=OPEN
DDR_QUERY_BOUND_FINAL=NOT_FROZEN
PERSIST_SCHEMA_VERSION=NOT_FROZEN
LM06_BYTE256=NOT_FROZEN
TINYGPT_802K=RETIRED_PER_GROK_550
PROGRAM=NO

Raw xsim.log r0:
CLASS_not_compose_renderer HIT dut=a7ng_astra_c4_lm06_byte256_arlang_gen
CLASS_not_tinygpt_802k HIT tinygpt=RETIRED_PER_GROK_550
CLASS_grounded_acc_ge90 HIT acc=20/20
CLASS_ar_yes_prefix HIT n=20/20
CLASS_w_zero_safe HIT n=20/20
CLASS_w_corrupt_not_gold HIT n=20/20
CLASS_evid_removed_safe HIT n=20/20
CLASS_evid_removed_halluc_le5 HIT hall=0/20
CLASS_host_next_token_zero HIT
CLASS_eos_or_max HIT saw_eos=20
marker ASTRA_C4_LM06_BYTE256_ARLANG_XSIM_PASS
$finish 27820055 ns
GOLDEN frozen MATCH c6b5c0f4fcf80d0ea339f992a7ca2d1f332ca766f12e59b3d062111cc9e11090
DUT arlang_gen e9686f9e… new named. Live prod_top / grounded_gen / qptext_gen unedited (not DUT). TinyGPT not DUT.
KEEP mismatches=0. Held-out dest 40..59. ASCII yes+dest-name. Gated obj ports remain. Not letter §10 Master close.

Print-only waiter ticks are NOT checker ticks. Do not re-ACCEPT bags 21–39.
Do not re-tick 47–55. This is checker tick 56 on bag index 40 only.
MASTER_CLOSE=NO.
