# ASTRA forward architecture manifest (freeze, not proof)

Target claim (narrow):

FPGA-native, memory-augmented **domain** reasoning: FPGA-owned structured query parse,
sparse evidence retrieval, bounded relational inference, reward-adaptive ranking,
persistent learned state, FPGA-generated output tokens.

Host may: keyboard, deterministic tokenize, UART, DDR load, log, scalar reward.
Host must not: subject/object/relation/intent/cue/bucket/candidates/winner/proof/next token/answer.

## DAG (do not skip)

ASTRA-00 freeze (this bag)
→ ASTRA-01 U4 real AXI sparse integration
→ ASTRA-02 U5 scale/selectivity 800k
→ ASTRA-03 role-aware query representation
→ ASTRA-04 relation engine 2-hop
→ ASTRA-05 causal proof perturbation
→ ASTRA-06 shared reward learner
→ ASTRA-07 held-out transfer
→ ASTRA-08 LM06 vocab/checkpoint audit
→ ASTRA-09 unified pipeline
→ ASTRA-10 OOC resource reconciliation
→ ASTRA-11 fullchip co-fit
→ ASTRA-12 final source freeze
→ ASTRA-13 final board acceptance

## Reuse (do not rebuild for fashion)

Arty A7-100T bring-up, MIG/DDR, AXI, UART, DDR ping-pong, PHYS scoring, Top-K,
fixed-point/sat arithmetic, persistence framework, LM06 datapath if still valid,
evidence methodology, U4A-R6 query validity, U4-PRE0 4×4096 sparse geometry,
board observability, frozen board evidence.

## Retire / do not claim

Bag-of-keywords as "relational understanding".
Host class-ID → handwritten sentence as FPGA language.
800k semantic retrieval without new gates.
Role-collapsed queries (`pump supplies chiller` == `chiller supplies pump`).
C7_ADDR low-16 as canonical identity.
Old+new duplicate retrieval architectures in one chip.

## Resource baseline (historical U2R candidate only)

LUT 36911, FF 45656, BRAM36eq 106.5, DSP 19, free slices 313,
WNS +1.126 ns, WHS +0.014 ns.
Not proof of current HEAD fit. REMOVE/REUSE before ADD.
