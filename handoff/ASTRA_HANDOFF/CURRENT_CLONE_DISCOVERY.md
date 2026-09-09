# Astra clone discovery — 2026-09-05

This is a read-only discovery recorded after the handoff package was first drafted. It supersedes any phrase in the handoff saying the intended clone does not yet exist.

Observed path:

`D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH`

Observed Git state:

```text
branch = grok-orch/astra-native-v1-00
HEAD   = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
fpgg   = https://github.com/Jokejoker-designer/FPGG_ART_Y.git
origin = D:/Jetking_sem4/SEM_4/arty-a7-online-lm-g14-preboard-00
```

The clone has its own `.git`, so it is not a linked Git worktree. `origin` is a local source checkout. This is sufficient for isolation of Git metadata but not proof that all generated cache/build paths are isolated; those paths require ASTRA-00A audit.

The clone is dirty. It contains modified MIG/generated files and untracked Astra RTL/results including parser, sparse integration, relation engine, learner and later gate folders. Do not run `git clean`, `git reset --hard`, checkout overwrite, reclone over this directory, or send a second implementation prompt until the manager has determined whether a Grok session is active and who owns each untracked file.

`results/A7-NATIVE-GRAPH/ASTRA-00-BASELINE-AUTHORITY-FREEZE/RESULTS.md` exists and declares ASTRA-00 PASS, but that declaration has not been independently accepted by the new manager. It is evidence to inspect, not authority to auto-advance.

The inherited root `AGENTS.md` still names V3.1 documents and old workflow. New manager must install/activate a nearest Astra authority override or equivalent current pointer in this clone after read-only inspection and according to applicable repository policy. Do not delete inherited instructions or frozen assets.

Therefore the first manager gate is:

```text
ASTRA-00A-TAKEOVER-INTEGRITY-AUDIT
```

Required output:

```text
clone identity and independent .git proof
remote/branch/ancestry refresh
new/old Grok session binding or active-writer evidence
dirty-file ownership/quarantine manifest
authority-copy hash verification
absolute build/cache/output path scan
ASTRA-00 evidence acceptance or correction
one current next gate
```

No board, COM12, bitstream or destructive Git operation is part of ASTRA-00A.
