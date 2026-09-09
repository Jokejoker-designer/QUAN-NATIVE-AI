# RESULTS — ASTRA-02-SCALE-SELECTIVITY-00

```text
GATE        = ASTRA-02-SCALE-SELECTIVITY-00
RESULT      = HOST_SCALE_PARTIAL
LADDER      = COMPLETE max_N=800000
R6_REGRESSION = PASS  water_chiller_emit=22/42
FULL_INDEX_COVERAGE = PASS (valid-key records, NOT_SEMANTIC)
SELECTED_PROFILE_FREEZE = NO
XSIM_800K   = NOT_RUN
BIT         = NO
PROGRAM     = NO
COM12       = UNTOUCHED
JTAG        = 210319BE776EA UNTOUCHED
RTL_EDIT    = NO (this worker). worktree walker already DIRTY vs HEAD; not XSim'd
U4_SEMANTIC = NO
OCCUPANCY_AS_SEMANTIC = NO
K2K3_FROM_NID = NO
GATE14_PASS = NO
SILICON     = NOT_RUN
V31_WRITES  = 0
```

## Primary unknown — answered at HOST_MODEL class

Independent gold (generator labels) + actual QSE keys/valid bits, with overflow pages storing every valid-key record. Not occupancy-from-nid. Not board. Not 800k XSim.

## Lineage

| Field | Value |
|--|--|
| HEAD | `5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1` |
| Query law | `qse-v1-lexicon-hdc-00` unchanged |
| Validity | U4A-R6 bind/hit; **not** `(key != 0)` |
| Geometry | U4-PRE0 P4_4k_h64 |
| Index | `astra02-ovf-page-v1` HOST; RTL walker still head-only |
| Gold | generator labels, before hash |
| Not used as authority | U4A-R3 `k2=nid&0xffff` scale path |

SHA256 of reused law sources:

```text
B8BB0CCAFF1E8733510888129104055F7F57354A3BA078AF20B7D1A5CBC8A379  twin.py
BC04FD43A224721034D390A452B3EA850C7BD8828DFB57BEEC19B365444E5A68  lexicon.py
EDE064F0C2A5C956EEBA5269F539690DBD63C0773B9DED11128BD9BE05496768  a7ng_query_struct_extract.sv
F449425A21516FDA9C9605C51B8073A6CE29DD31F8F5C4C1628D27E459CA3707  a7ng_sparse_dir_axi.sv  HEAD
09334E42C3913D4DE3A1B59147F48C810481CD634E63B37E64BC669A6C36BB24  a7ng_sparse_dir_axi.sv  worktree (DIRTY; not this gate)
AB9A2A2582F316B3E610072165A80DC183E3A7B1A71A857B5C7ACDD611E6A2C7  a7ng_sparse_dir_axi.sv  ASTRA-01 recorded
C60C78DB408A897660C40C0C2D7378CD1058BD6B7A433194F05A8C6CF8040F9F  host_astra02.py
5CE585E502EAD6315D944B52FA2131D5560076DE6F918E4106001F102B5A824E  _PREREG.md
```

Worktree walker already contains an uncommitted one-page overflow follow (`rdata[107:80]` next, `rdata[123:108]` count). This gate did not add it, did not revert it, and did not XSim it. Host `full_ovf_*` walks a **chain** of PAGE_CAP=64 pages until `BYTE_BUDGET`; that is the overflow-completeness model here.

## R6 freeze (42-title corpus)

Result **PASS**. `water chiller` emit=22 (AUDIT/HANDOFF: still 22/42 under this law).

| query | n_emit | match R6 |
|-------|-------:|:--------:|
| known_domain `chiller` | 4 | Y |
| paraphrase `water chiller` | 22 | Y |
| same_entity_diff_intent `leak chiller` | 4 | Y |
| unrelated_payroll `payroll tax form` | 0 | Y |
| unrelated_soccer `soccer match score` | 0 | Y |
| adversarial `ypypo tcpgx` | 0 | Y |

## Index integrity (FULL overflow pages, NOT_SEMANTIC occupancy)

| N | valid-key | indexed | coverage | ovf pages | post max | bucket max | empty frac | sentinel | low16 pair |
|--:|--:|--:|--:|--:|--:|--:|--:|:--:|:--:|
| 256 | 230 | 230 | 1.000000 | 0 | 52 | 52 | 0.9954 | False | False |
| 4096 | 3686 | 3686 | 1.000000 | 108 | 820 | 820 | 0.9896 | False | False |
| 16384 | 14745 | 14745 | 1.000000 | 501 | 3276 | 3276 | 0.9896 | False | False |
| 65536 | 58982 | 58982 | 1.000000 | 2250 | 13108 | 13108 | 0.9896 | False | False |
| 262144 | 235929 | 235929 | 1.000000 | 9288 | 52428 | 52428 | 0.9896 | False | True |
| 800000 | 720000 | 720000 | 1.000000 | 28545 | 160000 | 160000 | 0.9896 | True | True |

Coverage is “every record with a valid bit sits in a posting chain”, including overflow pages. It is **not** semantic recall.

At N=800000: 720000/720000 valid-key records indexed, 28545 overflow pages, fattest posting 160000 IDs (context T1 bucket). Sentinel nid=799999 is stored as a chiller entity (needle tail of the chiller posting, length 66682) and is **not** in cap=64 emit → SEARCH_INCOMPLETE, not missing from the index. `nid=0x10` vs `nid=0x10010` remain distinct 20-bit IDs (`low16_pair=true` at N≥262144). `emit_has_gt16bit=true` appears once overflow/budgeted walks pass 65535; RTL-head emit is an insertion prefix of low nids.

Bytes in the tables are directory + posting beats + overflow headers actually read, including IDs later dropped as dup/trunc/key-check. Example: N=800000 rtl_head `chiller` bytes=544 ≠ 16×64=1024.

## Ladder @ CAND_CAP=64 (selectivity only where cap < N)

### N=256

role_fwd vs role_rev emit-equal (rtl_head cap=64): **True**. audit supplies pair emit-equal: **True**.

| mode | class | n_gold | emit | prec | rec | red | bytes | status | ovf_unread |
|------|-------|-------:|-----:|-----:|----:|----:|------:|--------|------------|
| rtl_head_union | known_domain `known_domain_chiller` | 36 | 51 | 0.7059 | 1.0000 | 0.8008 | 320 | COMPLETE | False |
| full_ovf_union_keychk | known_domain `known_domain_chiller` | 36 | 51 | 0.7059 | 1.0000 | 0.8008 | 320 | COMPLETE | False |
| rtl_head_union | known_domain `known_domain_pump` | 17 | 14 | 1.0000 | 0.8235 | 0.9453 | 144 | COMPLETE | False |
| full_ovf_union_keychk | known_domain `known_domain_pump` | 17 | 14 | 1.0000 | 0.8235 | 0.9453 | 144 | COMPLETE | False |
| rtl_head_union | paraphrase `paraphrase_water_chiller` | 2 | 64 | 0.0312 | 1.0000 | 0.7500 | 544 | SEARCH_INCOMPLETE | False |
| full_ovf_union_keychk | paraphrase `paraphrase_water_chiller` | 2 | 64 | 0.0312 | 1.0000 | 0.7500 | 544 | SEARCH_INCOMPLETE | False |
| rtl_head_union | entity_context `entity_context_water_chiller` | 2 | 64 | 0.0312 | 1.0000 | 0.7500 | 544 | SEARCH_INCOMPLETE | False |
| full_ovf_union_keychk | entity_context `entity_context_water_chiller` | 2 | 64 | 0.0312 | 1.0000 | 0.7500 | 544 | SEARCH_INCOMPLETE | False |
| rtl_head_union | same_entity_diff_intent `intent_leak_chiller` | 1 | 32 | 0.0312 | 1.0000 | 0.8750 | 208 | COMPLETE | False |
| full_ovf_union_keychk | same_entity_diff_intent `intent_leak_chiller` | 1 | 32 | 0.0312 | 1.0000 | 0.8750 | 208 | COMPLETE | False |
| rtl_head_union | same_entity_diff_intent `intent_install_chiller` | 1 | 32 | 0.0312 | 1.0000 | 0.8750 | 208 | COMPLETE | False |
| full_ovf_union_keychk | same_entity_diff_intent `intent_install_chiller` | 1 | 32 | 0.0312 | 1.0000 | 0.8750 | 208 | COMPLETE | False |
| rtl_head_union | role_fwd `role_fwd` | 3 | 64 | 0.0469 | 1.0000 | 0.7500 | 480 | SEARCH_INCOMPLETE | False |
| full_ovf_union_keychk | role_fwd `role_fwd` | 3 | 64 | 0.0469 | 1.0000 | 0.7500 | 480 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_rev `role_rev` | 3 | 64 | 0.0469 | 1.0000 | 0.7500 | 480 | SEARCH_INCOMPLETE | False |
| full_ovf_union_keychk | role_rev `role_rev` | 3 | 64 | 0.0469 | 1.0000 | 0.7500 | 480 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_audit_fwd `role_audit_fwd` | 1 | 48 | 0.0208 | 1.0000 | 0.8125 | 240 | COMPLETE | False |
| full_ovf_union_keychk | role_audit_fwd `role_audit_fwd` | 1 | 48 | 0.0208 | 1.0000 | 0.8125 | 240 | COMPLETE | False |
| rtl_head_union | role_audit_rev `role_audit_rev` | 1 | 48 | 0.0208 | 1.0000 | 0.8125 | 240 | COMPLETE | False |
| full_ovf_union_keychk | role_audit_rev `role_audit_rev` | 1 | 48 | 0.0208 | 1.0000 | 0.8125 | 240 | COMPLETE | False |
| rtl_head_union | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |

Per-class means @ cap=64 `rtl_head_union`:

| class | mean prec | mean rec | mean red | mean emit | mean bytes | incomplete | no_ev |
|-------|----------:|---------:|---------:|----------:|-----------:|-----------:|------:|
| known_domain | 0.8529 | 0.9118 | 0.8730 | 32.50 | 232.0 | 0 | 0 |
| paraphrase | 0.0312 | 1.0000 | 0.7500 | 64.00 | 544.0 | 1 | 0 |
| entity_context | 0.0312 | 1.0000 | 0.7500 | 64.00 | 544.0 | 1 | 0 |
| same_entity_diff_intent | 0.0312 | 1.0000 | 0.8750 | 32.00 | 208.0 | 0 | 0 |
| role_fwd | 0.0469 | 1.0000 | 0.7500 | 64.00 | 480.0 | 1 | 0 |
| role_rev | 0.0469 | 1.0000 | 0.7500 | 64.00 | 480.0 | 1 | 0 |
| role_audit_fwd | 0.0208 | 1.0000 | 0.8125 | 48.00 | 240.0 | 0 | 0 |
| role_audit_rev | 0.0208 | 1.0000 | 0.8125 | 48.00 | 240.0 | 0 | 0 |
| unrelated | 1.0000 | n/a | 1.0000 | 0.00 | 0.0 | 0 | 3 |

Unrelated rejection (emit==0): 1.0000 (threshold 0.95).

### N=4096

role_fwd vs role_rev emit-equal (rtl_head cap=64): **True**. audit supplies pair emit-equal: **True**.

| mode | class | n_gold | emit | prec | rec | red | bytes | status | ovf_unread |
|------|-------|-------:|-----:|-----:|----:|----:|------:|--------|------------|
| rtl_head_union | known_domain `known_domain_chiller` | 316 | 64 | 0.7344 | 0.1487 | 0.9844 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | known_domain `known_domain_chiller` | 316 | 64 | 0.7344 | 0.1487 | 0.9844 | 2560 | SEARCH_INCOMPLETE | False |
| rtl_head_union | known_domain `known_domain_pump` | 309 | 64 | 0.9688 | 0.2006 | 0.9844 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | known_domain `known_domain_pump` | 309 | 64 | 0.9688 | 0.2006 | 0.9844 | 2016 | SEARCH_INCOMPLETE | False |
| rtl_head_union | paraphrase `paraphrase_water_chiller` | 14 | 64 | 0.0312 | 0.1429 | 0.9844 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | paraphrase `paraphrase_water_chiller` | 14 | 64 | 0.0312 | 0.1429 | 0.9844 | 6048 | SEARCH_INCOMPLETE | False |
| rtl_head_union | entity_context `entity_context_water_chiller` | 14 | 64 | 0.0312 | 0.1429 | 0.9844 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | entity_context `entity_context_water_chiller` | 14 | 64 | 0.0312 | 0.1429 | 0.9844 | 6048 | SEARCH_INCOMPLETE | False |
| rtl_head_union | same_entity_diff_intent `intent_leak_chiller` | 6 | 64 | 0.0938 | 1.0000 | 0.9844 | 592 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | same_entity_diff_intent `intent_leak_chiller` | 6 | 64 | 0.0938 | 1.0000 | 0.9844 | 1424 | SEARCH_INCOMPLETE | False |
| rtl_head_union | same_entity_diff_intent `intent_install_chiller` | 6 | 64 | 0.0938 | 1.0000 | 0.9844 | 592 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | same_entity_diff_intent `intent_install_chiller` | 6 | 64 | 0.0938 | 1.0000 | 0.9844 | 1424 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_fwd `role_fwd` | 3 | 64 | 0.0469 | 1.0000 | 0.9844 | 640 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_fwd `role_fwd` | 3 | 64 | 0.0469 | 1.0000 | 0.9844 | 3936 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_rev `role_rev` | 3 | 64 | 0.0469 | 1.0000 | 0.9844 | 640 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_rev `role_rev` | 3 | 64 | 0.0469 | 1.0000 | 0.9844 | 3936 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_audit_fwd `role_audit_fwd` | 1 | 64 | 0.0156 | 1.0000 | 0.9844 | 352 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_audit_fwd `role_audit_fwd` | 1 | 64 | 0.0156 | 1.0000 | 0.9844 | 1584 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_audit_rev `role_audit_rev` | 1 | 64 | 0.0156 | 1.0000 | 0.9844 | 352 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_audit_rev `role_audit_rev` | 1 | 64 | 0.0156 | 1.0000 | 0.9844 | 1584 | SEARCH_INCOMPLETE | False |
| rtl_head_union | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |

Per-class means @ cap=64 `rtl_head_union`:

| class | mean prec | mean rec | mean red | mean emit | mean bytes | incomplete | no_ev |
|-------|----------:|---------:|---------:|----------:|-----------:|-----------:|------:|
| known_domain | 0.8516 | 0.1747 | 0.9844 | 64.00 | 544.0 | 2 | 0 |
| paraphrase | 0.0312 | 0.1429 | 0.9844 | 64.00 | 816.0 | 1 | 0 |
| entity_context | 0.0312 | 0.1429 | 0.9844 | 64.00 | 816.0 | 1 | 0 |
| same_entity_diff_intent | 0.0938 | 1.0000 | 0.9844 | 64.00 | 592.0 | 2 | 0 |
| role_fwd | 0.0469 | 1.0000 | 0.9844 | 64.00 | 640.0 | 1 | 0 |
| role_rev | 0.0469 | 1.0000 | 0.9844 | 64.00 | 640.0 | 1 | 0 |
| role_audit_fwd | 0.0156 | 1.0000 | 0.9844 | 64.00 | 352.0 | 1 | 0 |
| role_audit_rev | 0.0156 | 1.0000 | 0.9844 | 64.00 | 352.0 | 1 | 0 |
| unrelated | 1.0000 | n/a | 1.0000 | 0.00 | 0.0 | 0 | 3 |

Unrelated rejection (emit==0): 1.0000 (threshold 0.95).

### N=16384

role_fwd vs role_rev emit-equal (rtl_head cap=64): **True**. audit supplies pair emit-equal: **True**.

| mode | class | n_gold | emit | prec | rec | red | bytes | status | ovf_unread |
|------|-------|-------:|-----:|-----:|----:|----:|------:|--------|------------|
| rtl_head_union | known_domain `known_domain_chiller` | 1240 | 64 | 0.7344 | 0.0379 | 0.9961 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | known_domain `known_domain_chiller` | 1240 | 64 | 0.7344 | 0.0379 | 0.9961 | 9968 | SEARCH_INCOMPLETE | False |
| rtl_head_union | known_domain `known_domain_pump` | 1221 | 64 | 0.9688 | 0.0508 | 0.9961 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | known_domain `known_domain_pump` | 1221 | 64 | 0.9688 | 0.0508 | 0.9961 | 8000 | SEARCH_INCOMPLETE | False |
| rtl_head_union | paraphrase `paraphrase_water_chiller` | 56 | 64 | 0.0312 | 0.0357 | 0.9961 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | paraphrase `paraphrase_water_chiller` | 56 | 64 | 0.0312 | 0.0357 | 0.9961 | 23904 | SEARCH_INCOMPLETE | False |
| rtl_head_union | entity_context `entity_context_water_chiller` | 56 | 64 | 0.0312 | 0.0357 | 0.9961 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | entity_context `entity_context_water_chiller` | 56 | 64 | 0.0312 | 0.0357 | 0.9961 | 23904 | SEARCH_INCOMPLETE | False |
| rtl_head_union | same_entity_diff_intent `intent_leak_chiller` | 23 | 64 | 0.3594 | 1.0000 | 0.9961 | 656 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | same_entity_diff_intent `intent_leak_chiller` | 23 | 64 | 0.3594 | 1.0000 | 0.9961 | 5376 | SEARCH_INCOMPLETE | False |
| rtl_head_union | same_entity_diff_intent `intent_install_chiller` | 23 | 64 | 0.3594 | 1.0000 | 0.9961 | 656 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | same_entity_diff_intent `intent_install_chiller` | 23 | 64 | 0.3594 | 1.0000 | 0.9961 | 5376 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_fwd `role_fwd` | 9 | 64 | 0.0469 | 0.3333 | 0.9961 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_fwd `role_fwd` | 9 | 64 | 0.0469 | 0.3333 | 0.9961 | 13184 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_rev `role_rev` | 9 | 64 | 0.0469 | 0.3333 | 0.9961 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_rev `role_rev` | 9 | 64 | 0.0469 | 0.3333 | 0.9961 | 13184 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_audit_fwd `role_audit_fwd` | 1 | 64 | 0.0156 | 1.0000 | 0.9961 | 480 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_audit_fwd `role_audit_fwd` | 1 | 64 | 0.0156 | 1.0000 | 0.9961 | 6096 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_audit_rev `role_audit_rev` | 1 | 64 | 0.0156 | 1.0000 | 0.9961 | 480 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_audit_rev `role_audit_rev` | 1 | 64 | 0.0156 | 1.0000 | 0.9961 | 6096 | SEARCH_INCOMPLETE | False |
| rtl_head_union | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |

Per-class means @ cap=64 `rtl_head_union`:

| class | mean prec | mean rec | mean red | mean emit | mean bytes | incomplete | no_ev |
|-------|----------:|---------:|---------:|----------:|-----------:|-----------:|------:|
| known_domain | 0.8516 | 0.0443 | 0.9961 | 64.00 | 544.0 | 2 | 0 |
| paraphrase | 0.0312 | 0.0357 | 0.9961 | 64.00 | 816.0 | 1 | 0 |
| entity_context | 0.0312 | 0.0357 | 0.9961 | 64.00 | 816.0 | 1 | 0 |
| same_entity_diff_intent | 0.3594 | 1.0000 | 0.9961 | 64.00 | 656.0 | 2 | 0 |
| role_fwd | 0.0469 | 0.3333 | 0.9961 | 64.00 | 816.0 | 1 | 0 |
| role_rev | 0.0469 | 0.3333 | 0.9961 | 64.00 | 816.0 | 1 | 0 |
| role_audit_fwd | 0.0156 | 1.0000 | 0.9961 | 64.00 | 480.0 | 1 | 0 |
| role_audit_rev | 0.0156 | 1.0000 | 0.9961 | 64.00 | 480.0 | 1 | 0 |
| unrelated | 1.0000 | n/a | 1.0000 | 0.00 | 0.0 | 0 | 3 |

Unrelated rejection (emit==0): 1.0000 (threshold 0.95).

### N=65536

role_fwd vs role_rev emit-equal (rtl_head cap=64): **True**. audit supplies pair emit-equal: **True**.

| mode | class | n_gold | emit | prec | rec | red | bytes | status | ovf_unread |
|------|-------|-------:|-----:|-----:|----:|----:|------:|--------|------------|
| rtl_head_union | known_domain `known_domain_chiller` | 4928 | 64 | 0.7344 | 0.0095 | 0.9990 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | known_domain `known_domain_chiller` | 4928 | 64 | 0.7344 | 0.0095 | 0.9990 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | known_domain `known_domain_pump` | 4909 | 64 | 0.9688 | 0.0126 | 0.9990 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | known_domain `known_domain_pump` | 4909 | 64 | 0.9688 | 0.0126 | 0.9990 | 32112 | SEARCH_INCOMPLETE | False |
| rtl_head_union | paraphrase `paraphrase_water_chiller` | 220 | 64 | 0.0312 | 0.0091 | 0.9990 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | paraphrase `paraphrase_water_chiller` | 220 | 64 | 0.0312 | 0.0091 | 0.9990 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | entity_context `entity_context_water_chiller` | 220 | 64 | 0.0312 | 0.0091 | 0.9990 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | entity_context `entity_context_water_chiller` | 220 | 64 | 0.0312 | 0.0091 | 0.9990 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | same_entity_diff_intent `intent_leak_chiller` | 91 | 64 | 1.0000 | 0.7033 | 0.9990 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | same_entity_diff_intent `intent_leak_chiller` | 91 | 64 | 1.0000 | 0.7033 | 0.9990 | 21344 | SEARCH_INCOMPLETE | False |
| rtl_head_union | same_entity_diff_intent `intent_install_chiller` | 92 | 64 | 1.0000 | 0.6957 | 0.9990 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | same_entity_diff_intent `intent_install_chiller` | 92 | 64 | 1.0000 | 0.6957 | 0.9990 | 21360 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_fwd `role_fwd` | 36 | 64 | 0.0469 | 0.0833 | 0.9990 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_fwd `role_fwd` | 36 | 64 | 0.0469 | 0.0833 | 0.9990 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | role_rev `role_rev` | 36 | 64 | 0.0469 | 0.0833 | 0.9990 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_rev `role_rev` | 36 | 64 | 0.0469 | 0.0833 | 0.9990 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | role_audit_fwd `role_audit_fwd` | 1 | 64 | 0.0156 | 1.0000 | 0.9990 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_audit_fwd `role_audit_fwd` | 1 | 64 | 0.0156 | 1.0000 | 0.9990 | 24080 | SEARCH_INCOMPLETE | False |
| rtl_head_union | role_audit_rev `role_audit_rev` | 1 | 64 | 0.0156 | 1.0000 | 0.9990 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_audit_rev `role_audit_rev` | 1 | 64 | 0.0156 | 1.0000 | 0.9990 | 24080 | SEARCH_INCOMPLETE | False |
| rtl_head_union | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |

Per-class means @ cap=64 `rtl_head_union`:

| class | mean prec | mean rec | mean red | mean emit | mean bytes | incomplete | no_ev |
|-------|----------:|---------:|---------:|----------:|-----------:|-----------:|------:|
| known_domain | 0.8516 | 0.0111 | 0.9990 | 64.00 | 544.0 | 2 | 0 |
| paraphrase | 0.0312 | 0.0091 | 0.9990 | 64.00 | 816.0 | 1 | 0 |
| entity_context | 0.0312 | 0.0091 | 0.9990 | 64.00 | 816.0 | 1 | 0 |
| same_entity_diff_intent | 1.0000 | 0.6995 | 0.9990 | 64.00 | 816.0 | 2 | 0 |
| role_fwd | 0.0469 | 0.0833 | 0.9990 | 64.00 | 816.0 | 1 | 0 |
| role_rev | 0.0469 | 0.0833 | 0.9990 | 64.00 | 816.0 | 1 | 0 |
| role_audit_fwd | 0.0156 | 1.0000 | 0.9990 | 64.00 | 544.0 | 1 | 0 |
| role_audit_rev | 0.0156 | 1.0000 | 0.9990 | 64.00 | 544.0 | 1 | 0 |
| unrelated | 1.0000 | n/a | 1.0000 | 0.00 | 0.0 | 0 | 3 |

Unrelated rejection (emit==0): 1.0000 (threshold 0.95).

### N=262144

role_fwd vs role_rev emit-equal (rtl_head cap=64): **True**. audit supplies pair emit-equal: **True**.

| mode | class | n_gold | emit | prec | rec | red | bytes | status | ovf_unread |
|------|-------|-------:|-----:|-----:|----:|----:|------:|--------|------------|
| rtl_head_union | known_domain `known_domain_chiller` | 19672 | 64 | 0.7344 | 0.0024 | 0.9998 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | known_domain `known_domain_chiller` | 19672 | 64 | 0.7344 | 0.0024 | 0.9998 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | known_domain `known_domain_pump` | 19658 | 64 | 0.9688 | 0.0032 | 0.9998 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | known_domain `known_domain_pump` | 19658 | 64 | 0.9688 | 0.0032 | 0.9998 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | paraphrase `paraphrase_water_chiller` | 874 | 64 | 0.0312 | 0.0023 | 0.9998 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | paraphrase `paraphrase_water_chiller` | 874 | 64 | 0.0312 | 0.0023 | 0.9998 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | entity_context `entity_context_water_chiller` | 874 | 64 | 0.0312 | 0.0023 | 0.9998 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | entity_context `entity_context_water_chiller` | 874 | 64 | 0.0312 | 0.0023 | 0.9998 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | same_entity_diff_intent `intent_leak_chiller` | 364 | 64 | 1.0000 | 0.1758 | 0.9998 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | same_entity_diff_intent `intent_leak_chiller` | 364 | 64 | 1.0000 | 0.1758 | 0.9998 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | same_entity_diff_intent `intent_install_chiller` | 365 | 64 | 1.0000 | 0.1753 | 0.9998 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | same_entity_diff_intent `intent_install_chiller` | 365 | 64 | 1.0000 | 0.1753 | 0.9998 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | role_fwd `role_fwd` | 138 | 64 | 0.0469 | 0.0217 | 0.9998 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_fwd `role_fwd` | 138 | 64 | 0.0469 | 0.0217 | 0.9998 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | role_rev `role_rev` | 138 | 64 | 0.0469 | 0.0217 | 0.9998 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_rev `role_rev` | 138 | 64 | 0.0469 | 0.0217 | 0.9998 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | role_audit_fwd `role_audit_fwd` | 1 | 64 | 0.0156 | 1.0000 | 0.9998 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_audit_fwd `role_audit_fwd` | 1 | 64 | 0.0156 | 1.0000 | 0.9998 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | role_audit_rev `role_audit_rev` | 1 | 64 | 0.0156 | 1.0000 | 0.9998 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_audit_rev `role_audit_rev` | 1 | 64 | 0.0156 | 1.0000 | 0.9998 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |

Per-class means @ cap=64 `rtl_head_union`:

| class | mean prec | mean rec | mean red | mean emit | mean bytes | incomplete | no_ev |
|-------|----------:|---------:|---------:|----------:|-----------:|-----------:|------:|
| known_domain | 0.8516 | 0.0028 | 0.9998 | 64.00 | 544.0 | 2 | 0 |
| paraphrase | 0.0312 | 0.0023 | 0.9998 | 64.00 | 816.0 | 1 | 0 |
| entity_context | 0.0312 | 0.0023 | 0.9998 | 64.00 | 816.0 | 1 | 0 |
| same_entity_diff_intent | 1.0000 | 0.1756 | 0.9998 | 64.00 | 816.0 | 2 | 0 |
| role_fwd | 0.0469 | 0.0217 | 0.9998 | 64.00 | 816.0 | 1 | 0 |
| role_rev | 0.0469 | 0.0217 | 0.9998 | 64.00 | 816.0 | 1 | 0 |
| role_audit_fwd | 0.0156 | 1.0000 | 0.9998 | 64.00 | 544.0 | 1 | 0 |
| role_audit_rev | 0.0156 | 1.0000 | 0.9998 | 64.00 | 544.0 | 1 | 0 |
| unrelated | 1.0000 | n/a | 1.0000 | 0.00 | 0.0 | 0 | 3 |

Unrelated rejection (emit==0): 1.0000 (threshold 0.95).

### N=800000

role_fwd vs role_rev emit-equal (rtl_head cap=64): **True**. audit supplies pair emit-equal: **True**.

| mode | class | n_gold | emit | prec | rec | red | bytes | status | ovf_unread |
|------|-------|-------:|-----:|-----:|----:|----:|------:|--------|------------|
| rtl_head_union | known_domain `known_domain_chiller` | 60010 | 64 | 0.7344 | 0.0008 | 0.9999 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | known_domain `known_domain_chiller` | 60010 | 64 | 0.7344 | 0.0008 | 0.9999 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | known_domain `known_domain_pump` | 59990 | 64 | 0.9688 | 0.0010 | 0.9999 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | known_domain `known_domain_pump` | 59990 | 64 | 0.9688 | 0.0010 | 0.9999 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | paraphrase `paraphrase_water_chiller` | 2668 | 64 | 0.0312 | 0.0007 | 0.9999 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | paraphrase `paraphrase_water_chiller` | 2668 | 64 | 0.0312 | 0.0007 | 0.9999 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | entity_context `entity_context_water_chiller` | 2668 | 64 | 0.0312 | 0.0007 | 0.9999 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | entity_context `entity_context_water_chiller` | 2668 | 64 | 0.0312 | 0.0007 | 0.9999 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | same_entity_diff_intent `intent_leak_chiller` | 1111 | 64 | 1.0000 | 0.0576 | 0.9999 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | same_entity_diff_intent `intent_leak_chiller` | 1111 | 64 | 1.0000 | 0.0576 | 0.9999 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | same_entity_diff_intent `intent_install_chiller` | 1112 | 64 | 1.0000 | 0.0576 | 0.9999 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | same_entity_diff_intent `intent_install_chiller` | 1112 | 64 | 1.0000 | 0.0576 | 0.9999 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | role_fwd `role_fwd` | 417 | 64 | 0.0469 | 0.0072 | 0.9999 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_fwd `role_fwd` | 417 | 64 | 0.0469 | 0.0072 | 0.9999 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | role_rev `role_rev` | 417 | 64 | 0.0469 | 0.0072 | 0.9999 | 816 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_rev `role_rev` | 417 | 64 | 0.0469 | 0.0072 | 0.9999 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | role_audit_fwd `role_audit_fwd` | 1 | 64 | 0.0156 | 1.0000 | 0.9999 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_audit_fwd `role_audit_fwd` | 1 | 64 | 0.0156 | 1.0000 | 0.9999 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | role_audit_rev `role_audit_rev` | 1 | 64 | 0.0156 | 1.0000 | 0.9999 | 544 | SEARCH_INCOMPLETE | True |
| full_ovf_union_keychk | role_audit_rev `role_audit_rev` | 1 | 64 | 0.0156 | 1.0000 | 0.9999 | 32768 | SEARCH_INCOMPLETE | True |
| rtl_head_union | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_payroll` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_soccer` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| rtl_head_union | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |
| full_ovf_union_keychk | unrelated `unrelated_adv` | 0 | 0 | 1.0000 | n/a | 1.0000 | 0 | NO_EVIDENCE | False |

Per-class means @ cap=64 `rtl_head_union`:

| class | mean prec | mean rec | mean red | mean emit | mean bytes | incomplete | no_ev |
|-------|----------:|---------:|---------:|----------:|-----------:|-----------:|------:|
| known_domain | 0.8516 | 0.0009 | 0.9999 | 64.00 | 544.0 | 2 | 0 |
| paraphrase | 0.0312 | 0.0007 | 0.9999 | 64.00 | 816.0 | 1 | 0 |
| entity_context | 0.0312 | 0.0007 | 0.9999 | 64.00 | 816.0 | 1 | 0 |
| same_entity_diff_intent | 1.0000 | 0.0576 | 0.9999 | 64.00 | 816.0 | 2 | 0 |
| role_fwd | 0.0469 | 0.0072 | 0.9999 | 64.00 | 816.0 | 1 | 0 |
| role_rev | 0.0469 | 0.0072 | 0.9999 | 64.00 | 816.0 | 1 | 0 |
| role_audit_fwd | 0.0156 | 1.0000 | 0.9999 | 64.00 | 544.0 | 1 | 0 |
| role_audit_rev | 0.0156 | 1.0000 | 0.9999 | 64.00 | 544.0 | 1 | 0 |
| unrelated | 1.0000 | n/a | 1.0000 | 0.00 | 0.0 | 0 | 3 |

Unrelated rejection (emit==0): 1.0000 (threshold 0.95).

## SEARCH_INCOMPLETE vs NO_EVIDENCE

- **NO_EVIDENCE**: all valid bits 0 (unrelated/adversarial) so n_dir=0, or every probed posting empty with no unread overflow.
- **SEARCH_INCOMPLETE**: overflow pages not walked (RTL head), byte budget 32768 exhausted, or CAND_CAP truncation. Gold may exist; abstain ≠ empty corpus.

Needle head/tail (known_domain_chiller, cap=64):

| N | mode | head_nid | head_hit | tail_nid | tail_hit | longest_posting |
|--:|------|---------:|:--------:|---------:|:--------:|----------------:|
| 256 | rtl_head_union | 1 | True | 249 | True | 48 |
| 256 | full_ovf_union | 1 | True | 249 | True | 48 |
| 4096 | rtl_head_union | 1 | True | 4089 | False | 352 |
| 4096 | full_ovf_union | 1 | True | 4089 | False | 352 |
| 16384 | rtl_head_union | 1 | True | 16329 | False | 1384 |
| 16384 | full_ovf_union | 1 | True | 16329 | False | 1384 |
| 65536 | rtl_head_union | 1 | True | 65529 | False | 5480 |
| 65536 | full_ovf_union | 1 | True | 65529 | False | 5480 |
| 262144 | rtl_head_union | 1 | True | 262142 | False | 21863 |
| 262144 | full_ovf_union | 1 | True | 262142 | False | 21863 |
| 800000 | rtl_head_union | 1 | True | 799999 | False | 66682 |
| 800000 | full_ovf_union | 1 | True | 799999 | False | 66682 |

## Cap sweep (known_domain_chiller only; skip selectivity if cap≥N)

| N | cap | cap<N | rtl emit/rec/bytes | full_keychk emit/rec/bytes | isect emit/rec/bytes |
|--:|----:|:-----:|--------------------|----------------------------|----------------------|
| 256 | 64 | True | 51/1.0000/320/COMP | 51/1.0000/320/COMP | 18/0.5000/128/COMP |
| 256 | 128 | True | 51/1.0000/320/COMP | 51/1.0000/320/COMP | 18/0.5000/128/COMP |
| 256 | 256 | False | 51/1.0000/320/COMP | 51/1.0000/320/COMP | 18/0.5000/128/COMP |
| 256 | 512 | False | 51/1.0000/320/COMP | 51/1.0000/320/COMP | 18/0.5000/128/COMP |
| 256 | 1024 | False | 51/1.0000/320/COMP | 51/1.0000/320/COMP | 18/0.5000/128/COMP |
| 4096 | 64 | True | 64/0.1487/544/SEAR | 64/0.1487/2560/SEAR | 64/0.2025/1072/SEAR |
| 4096 | 128 | True | 98/0.2563/544/SEAR | 128/0.3228/2560/SEAR | 128/0.4051/1072/SEAR |
| 4096 | 256 | True | 98/0.2563/544/SEAR | 256/0.6424/2560/SEAR | 210/0.6646/1072/COMP |
| 4096 | 512 | True | 98/0.2563/544/SEAR | 387/1.0000/2560/COMP | 210/0.6646/1072/COMP |
| 4096 | 1024 | True | 98/0.2563/544/SEAR | 387/1.0000/2560/COMP | 210/0.6646/1072/COMP |
| 16384 | 64 | True | 64/0.0379/544/SEAR | 64/0.0379/9968/SEAR | 64/0.0516/4096/SEAR |
| 16384 | 128 | True | 98/0.0653/544/SEAR | 128/0.0823/9968/SEAR | 128/0.1032/4096/SEAR |
| 16384 | 256 | True | 98/0.0653/544/SEAR | 256/0.1637/9968/SEAR | 256/0.2065/4096/SEAR |
| 16384 | 512 | True | 98/0.0653/544/SEAR | 512/0.3250/9968/SEAR | 512/0.4129/4096/SEAR |
| 16384 | 1024 | True | 98/0.0653/544/SEAR | 1024/0.6573/9968/SEAR | 822/0.6629/4096/COMP |
| 65536 | 64 | True | 64/0.0095/544/SEAR | 64/0.0095/32768/SEAR | 64/0.0130/16304/SEAR |
| 65536 | 128 | True | 98/0.0164/544/SEAR | 128/0.0207/32768/SEAR | 128/0.0260/16304/SEAR |
| 65536 | 256 | True | 98/0.0164/544/SEAR | 256/0.0412/32768/SEAR | 256/0.0519/16304/SEAR |
| 65536 | 512 | True | 98/0.0164/544/SEAR | 512/0.0818/32768/SEAR | 512/0.1039/16304/SEAR |
| 65536 | 1024 | True | 98/0.0164/544/SEAR | 1024/0.1654/32768/SEAR | 1024/0.2078/16304/SEAR |
| 262144 | 64 | True | 64/0.0024/544/SEAR | 64/0.0024/32768/SEAR | 64/0.0033/32768/SEAR |
| 262144 | 128 | True | 98/0.0041/544/SEAR | 128/0.0052/32768/SEAR | 128/0.0065/32768/SEAR |
| 262144 | 256 | True | 98/0.0041/544/SEAR | 256/0.0103/32768/SEAR | 256/0.0130/32768/SEAR |
| 262144 | 512 | True | 98/0.0041/544/SEAR | 512/0.0205/32768/SEAR | 512/0.0260/32768/SEAR |
| 262144 | 1024 | True | 98/0.0041/544/SEAR | 1024/0.0414/32768/SEAR | 1024/0.0521/32768/SEAR |
| 800000 | 64 | True | 64/0.0008/544/SEAR | 64/0.0008/32768/SEAR | 64/0.0011/32768/SEAR |
| 800000 | 128 | True | 98/0.0013/544/SEAR | 128/0.0017/32768/SEAR | 128/0.0021/32768/SEAR |
| 800000 | 256 | True | 98/0.0013/544/SEAR | 256/0.0034/32768/SEAR | 256/0.0043/32768/SEAR |
| 800000 | 512 | True | 98/0.0013/544/SEAR | 512/0.0067/32768/SEAR | 512/0.0085/32768/SEAR |
| 800000 | 1024 | True | 98/0.0013/544/SEAR | 1024/0.0136/32768/SEAR | 1024/0.0171/32768/SEAR |

Intersect bytes are HOST_SET membership plus rarest-list AXI walk; not an AXI claim.

## Profile freeze verdict

**SELECTED_PROFILE_FREEZE = NO.** P4_4k_h64 is measured, not promoted.

Reduction ≥0.90 at N≥4096 with cap=64 is **vacuous** (emit bounded by cap ≪ N) and is not used alone as sparse-selectivity proof. Cap≥N rows are marked inadmissible in `LADDER.tsv`. Binding failures:

Reasons (not retargeted):
- N=4096 rtl_head cap64 mean_recall=0.7937 < 0.95
- N=4096 ROLE_COLLAPSE role_fwd emit == role_rev emit
- N=16384 rtl_head cap64 mean_recall=0.4278 < 0.95
- N=16384 ROLE_COLLAPSE role_fwd emit == role_rev emit
- N=65536 rtl_head cap64 mean_recall=0.2193 < 0.95
- N=65536 ROLE_COLLAPSE role_fwd emit == role_rev emit
- N=262144 rtl_head cap64 mean_recall=0.0555 < 0.95
- N=262144 ROLE_COLLAPSE role_fwd emit == role_rev emit
- N=800000 rtl_head cap64 mean_recall=0.0182 < 0.95
- N=800000 ROLE_COLLAPSE role_fwd emit == role_rev emit
- entity-context `water chiller` precision ≈0.031 at every N (T1 xid=1 unions all context words)
- RTL head does not retrieve overflow tails; FULL walk hits BYTE_BUDGET=32768 by N=65536 on fat buckets

Unrelated rejection is 1.00 (payroll/soccer/adversarial → valid=0, NO_EVIDENCE, emit=0). That is not a quality freeze.

## Not claimed

U4 semantic PASS, occupancy semantic recall, board/MIG/BIT/PROGRAM, role-aware parse (ASTRA-03), 2-hop, reward learner, LM language, GATE14, production profile freeze, FPGA latency from host wall time, intersect AXI byte bound.

## Next

ASTRA-03 role-aware query: subject/object must not collapse. Do not program COM12. Do not call this occupancy semantic recall.

