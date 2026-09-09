# Full handoff — new Codex manager / new Grok Astra

## Read first

You are a NEW Codex manager, not the old V3.1 manager continuing in place. Human requested a separate Astra line in D:/FPGA with a new Grok session. You must carry this project forward autonomously within its declared scope, using the new master, and preserve the independently active old line.

Read in order:

1. D:/AGENTS.md and applicable override chain; use curiosity-engine where required.
2. D:/FPGA/ASTRA_HANDOFF/ASTRA_NATIVE_AI_MASTER_V1.md — active new-branch authority.
3. D:/FPGA/ASTRA_HANDOFF/references/DESIGN_CANDIDATE.md — detailed algorithms/budgets.
4. D:/FPGA/ASTRA_HANDOFF/references/AUDIT.md — dated audit; especially live-update section2.
5. D:/FPGA/ASTRA_HANDOFF/STATE.json and MANIFEST.json.
6. D:/FPGA/GROK_ASTRA_NEW_SESSION_MASTER_PROMPT_ISOLATED_V1.md — prior handoff context, subordinate to new master.

## Verified state when this handoff was prepared

D:/FPGA already existed. It contained a user-written isolated Grok prompt and a junction:

D:/FPGA/basys3-four-agent-snn-ready
→ D:/Jetking_sem4/SEM_4/basys3-four-agent-snn-ready.

This junction is NOT the Astra worktree and NOT the Arty target. Do not recurse through it, clean it or reuse its constraints. Existing prompt/junction are preserved.

The intended independent clone now exists and is dirty. Read `CURRENT_CLONE_DISCOVERY.md` before any clone, clean, checkout, reset or Grok dispatch. This handoff package itself did not create the clone/session/build/board result; it only discovered the clone after the package draft.

Container: D:/FPGA
New clone path: D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
New branch: grok-orch/astra-native-v1-00
Manager session ID: UNBOUND
New Grok session ID: UNBOUND
Board token: NONE

Old line (do not mutate/redirect):
D:/Jetking_sem4/SEM_4/arty-a7-online-lm-g14-preboard-00
branch grok-orch/v31-canonical-00
remote https://github.com/Jokejoker-designer/FPGG_ART_Y.git

Last directly checked commit before this handoff:4677ad26762d3ccc81e3fe204a236c43d7c90b55 (05-09-2026 17:15+07). It is a historical pointer, not an instruction to always use latest branch HEAD. Refresh read-only ancestry/remotes and select exact reviewed source. Do not push the old lane merely to make it cloneable.

Historical assets: bit F24150BDE6F69080B3C5865386C49F6F02300782FFB4037FAF044BB2099840F7; binary UART FAC30E79FD9E1802C4A4505920A96724CA03CE3709B70FAA7E3A8772D5F486D2; output653/689/237/60. They support a bounded older board chain, not new Astra capability.

## Latest known implementation progress, not Astra inherited PASS

- R6 route validity RTL+98-vector XSim; prevents universal null-key bucket behavior.
- Persistence full32 identity two-beat schemaV2 unit XSim; migration/full-capacity success still requires audit.
- U4-PRE0 geometry and U4-MEM02 qse→AXI directory/posting XSim at4677ad2; full production SoC/quality not implied.
- Old U5 prereg was starting at last read. SPREAD/COLLIDE/SENTINEL alone do not prove semantic scale800k.
- Historical U2R:36,911LUT;45,656FF;106.5BRAM36eq;19DSP;313 free slices. Latest new features are not all covered by that route report.

Known architecture gaps to test: fixture numeric query mapping; fixed lexicon versus learned representation; role reversal collapse; retrieval skew; shared reward transfer unproven; LM active versus language ability; full-ID context and versioned persistence; ACK versus actual commit; one production path.

## Your first assignment: ASTRA-00A takeover integrity audit

1. Inspect D:/FPGA without traversing junctions. Preserve existing files.
2. Read CURRENT_CLONE_DISCOVERY.md. Inspect the existing clone read-only: remote/ref/ancestry, independent `.git`, dirty changes, active processes and the intended new Grok session.
3. Do not overwrite/reclone/reset/clean the existing target. Write a per-file ownership or quarantine manifest for its dirty files and determine whether a writer is active.
4. Verify copied authority files byte-for-byte against this handoff package. Install an Astra current-authority override/pointer inside the clone only after preserving inherited policy and recording the change.
5. Audit scripts/IP/XDC for absolute paths, old output folders, shared Vivado caches and board-program auto-actions. Fix paths only in new clone before running them. This includes TMP/output/project generated directories.
6. Bind one new Grok session. If user already started one, confirm exact session/workspace. Otherwise prepare/start one fresh session using observed supported CLI/UI, without reusing the old ID. Do not invent CLI flags. Never create an old-session fork by accident.
7. Populate session IDs and run ownership in new-clone manager state. Initial role boundaries: Codex manager, Grok implementer, user board/final-claim owner.
8. Accept/correct the existing ASTRA-00 result only after checking source evidence. Produce ASTRA-00A evidence: clone lineage, isolation paths, authority hashes, dirty ownership, module reuse/retire matrix, inherited defects, resource baseline and one current work order. Then proceed to ASTRA-01 if criteria actually pass.

No new FPGA build is required to claim ASTRA-00. Do not spend a day rerunning proven old infrastructure just to make a new bag.

## How to dispatch and audit

Create manager-owned current work order under .agents/handoff/ in NEW clone with task ID, base SHA, objective, files/write ownership, allowed test scope, expected evidence and next condition. Implementer acknowledges exact ID. Do not submit a second prompt while the first is active or pending in its input box.

For UI dispatch target the NEW Grok CLI session in Terminal and verify post-send acknowledgement. Terminal title/PID focus plus successful synthetic keystroke is not sufficient proof that prompt arrived. Do not send into Orca chat. If native computer-use is unavailable, provide the prepared prompt/path honestly; do not report “sent” without observation.

Use compact raw-log/code audit, not report-only approval. On completion reconcile work order, source diff, tests, provenance, metrics and remaining uncertainty. Keep a current task pointer and archive completed work orders; don't repeatedly notify an unchanged WAITING state.

Existing theo-d-i-grok-v-cursor automation belongs to old session/lane. Do not change it to Astra. A new monitor, if subsequently requested, must bind the new root and exact new session and use new master.

## Board coordination

No initial board/program authorization. Old V3.1 remains active and may be using Arty/COM12. Do not close its serial handle, stop hw_server, reprogram or assume its token applies here.

Before final use identify exact Arty/JTAG/COM, current physical owner, unique current-source bit hash, UART listener, lease/release record and authorization for THIS new artifact. Local PROGRAM=NO is a guard, not proof other lane is idle. Make board readiness concrete before requesting the necessary board decision.

## Deliverables and finish condition

Manager should maintain: current-state record; authority/provenance manifest; gate ledger; one active work order; independent acceptance; next dependency; board-token status. Use FACT/INFERENCE/HYPOTHESIS/UNKNOWN and BOARD/POST_ROUTE/XSIM/HOST_MODEL labels precisely.

Proceed with safe local work already within scope. Escalate only actual ambiguity affecting claim/authority, missing required access, destructive migration or resource infeasibility. Final is not “many PASS reports”; final is a single artifact with measured parsing, selective retrieval, novel proof-backed reasoning, reward transfer, persistence, uncertainty and FPGA language output under the new master.
