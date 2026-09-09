# Independent Astra audit (Antigravity)

**Open this first:** [ANTIGRAVITY_START_HERE.md](ANTIGRAVITY_START_HERE.md)

DeepSeek RTL/reasoner: [DEEPSEEK_PROTOCOL.md](DEEPSEEK_PROTOCOL.md)

Then:

1. [AGENTS.md](AGENTS.md) — isolation (do not write Grok/Cursor live trees)
2. [COORDINATION.md](COORDINATION.md) — roles
3. [GATES/README.md](GATES/README.md) — bug-catching gates
4. [KEEP_HASHES.json](KEEP_HASHES.json)
5. [EVIDENCE_C1_800K.md](EVIDENCE_C1_800K.md) — C1 evening notes (historical)
6. [PLAN.md](PLAN.md) — morning C1 plan (historical; C1 XSim is already closed)

```bat
python scripts\c1_800k_close_gate.py
python scripts\c2_persist_close_gate.py
python scripts\c3_heldout_prereg_gate.py
python scripts\snapshot_evidence.py
```
