# E3_REVIEW after E3aa — named family `rq_snap`; do not auto-start E3ab

**PROGRAM=NO.** `C4_MASTER` OPEN. `C5_MASTER` OPEN. `C6_MASTER` OPEN.  
`ASTRA_NATIVE_AI_BOARD_PASS` NOT_EVIDENCED. G14 **BLOCKED_PRE_BOARD**. Do not program.

Authority: `E3AA_SMLUT_IDX_PIPE_SPEC.md`. This note **does not** authorize E3ab RTL, post-route C6, programming, or MASTER.

## Decision

| Question | Decision | Class |
|----------|----------|--------|
| Did E3aa cut `delta_r`→`elut` (`smres`)? | **YES** — `smres`/`elut` left top-20. Worst is now `toks`→`rq_val_r` (`rq_snap`). | FACT `E3AA_N20.json` |
| Case | **B** `path_cut_new_family` | FACT classifier (`STRONG_WNS` threshold 3.0 ns; ΔWNS **+1.401** not ≥ 3.0) |
| OOC setup/hold at 10 ns? | **MET** on this synthesized D32 OOC: WNS **+1.052**, TNS **0**, WHS **+0.172**, THS **0**, failing **0** | FACT `timing_summary_e3aa.rpt` |
| Is that WO §19 physical PASS? | **NO** — OOC synthesized D32, not routed C6 wholechip | FACT WO §19 |
| Auto-start E3ab in this run? | **NO** — spec: record the named family; new written plan required | FACT spec |
| Stamp MASTER / freeze / program? | **NO** — no unique C6 bit; `alias_wr=0`; E1c dict OPEN | FACT WO §18–21 |

Classifier text “WNS slight/flat” is the Case-B branch (Δ < 3.0 ns). It does **not** mean WNS is still negative.

## E3aa six numbers (FACT)

OOC synth `a7ng_astra_c4_lm06_d32_fr_v2` + RQ + SMRES, Vivado 2026.1, `xc7a100tcsg324-1`, 10 ns, `maxThreads 4`. Marker `E3AA_OOC_DONE PROGRAM=NO`.  
DUT SHA256 `0a4e0e051f7f400f3853cf91098eb03617efa8eb888c7ca1c65a3287bcca5fb5`.  
GOLDEN n=242 PASS on this SHA. Log SHA256 `e9168b7439c8dbb0b92880e7df9829ba27fd1c3ab7206c0afb72e37c304971c4`.

| Item | E3z | E3aa |
|------|-----|------|
| WNS | −0.349 ns | **+1.052 ns** (Δ **+1.401**) |
| TNS | −24.793 ns | **0.000 ns** |
| Failing endpoints | 192 | **0** |
| Top-20 dest | smres 20 (`elut`, `delta_r`) | **rq_snap 20** (`rq_val_r`) |
| Worst source | `delta_r_reg[0]/C` | `toks_reg[23][0]/C` |
| Worst dest | `elut_reg[0][0]/D` | `rq_val_r_reg[10]/D` |
| Logic levels | 18 | 11 |
| CARRY4 / DSP48E1 | 8 / 0 | 1 / 0 |
| LUT / FF / DSP / BRAM | 27111 / 43285 / 11 / 0 | 26762 / 43365 / 11 / 0 |
| WHS / THS | 0.172 / 0.000 | **0.172 / 0.000** |

n20 SHA256 `c0f4ca866e871b40aeaef097b2239916e3540e27ecdaab091580825233bb8417`.  
E3z n20 SHA256 `ce6fa367ae73c1e52c6f647c9a8bdcfce22d5bbe23fcc34648bef3716a9cc0f5` **intact**.  
Design state: **Synthesized** (not placed/routed). Cone: token We/Pe address into `rq_val_r` (RQ operand snap), 11 levels, CARRY4=1, MUXF7=2.

## Named family (do not pipe in this run)

```text
family     rq_snap
cone       toks → rq_val_r  (RQ operand mux/index)
next_name  E3ab_rq_snap
status     RECORDED_NOT_STARTED
```

Do not start E3ab until a **new written plan** names the exact snap, GOLDEN replay, and Case A/B/C vs this **+1.052** / `rq_snap` 20/20 baseline.

Local E3ab is **optional**. G14 still needs **post-route C6** of `a7ng_astra_c6_wholechip_final_v1` (not COFIT `a7ng_astra_c6_wholechip`, not this OOC DCP as a bitstream). That C6 build also needs its own written plan. `alias_wr=0` still makes production F/R S_SAFE on silicon.

Do not program. Do not stamp MASTER. Do not treat OOC WNS≥0 as `BOARD_PASS`.
