# ASTRA-00 prereg — baseline authority freeze

No RTL edit. No board program. COM12 untouched.

## Lineage (measured this session)

```
REMOTE_HEAD (fpgg/grok-orch/v31-canonical-00) = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
WORKTREE_HEAD (source, at clone time)         = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
ASTRA_CLONE_HEAD                              = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BASE_COMMIT                                   = d166ca8edc8c01630efbcc648df8001f40dca572
BASELINE_ANCESTRY                             = PASS (merge-base --is-ancestor d166ca8 HEAD = 0)
SOURCE_TREE_DIRTY_STATE                       = DIRTY (~121 porcelain at clone source; clone is committed tree)
ASTRA_TREE_DIRTY_STATE                        = 13 MIG example files showed M after clone (line-ending/smudge); plus this freeze bag
```

Audit snapshot was d166ca8; live lineage HEAD is **5aa8285** (U5-MEM02), a clean descendant. Use latest descendant, not freeze at e54096f.

## Isolation

Independent clone at `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH` with own `.git`.
Not `git worktree add`. Source folder not written by this session after clone.
