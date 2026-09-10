# E3e — S_V-only multicycle `c4_rq` (smallest physical cut)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Do not mix E1 parser RTL.

Authority for this revision: Anh 2026-09-09 — do **not** implement the wider Q/K/V+`sat_en` draft.

## Why (FACT from E3d)

E3d OOC WNS **−24.357 ns**. Top-20 **0/20 SMRES**. All 20 paths:

```text
di_reg[4]/C → vv_wdata_reg[*]/S
48 levels, 33.716 ns
CARRY4=31 DSP48E1=4
```

RTL site is **`S_V` only**: `di` → dynamic index → multiply → add → combo `c4_rq` → combo `c4_sat` → `vv_wdata` in the same cycle.

## Scope (falsifier)

```text
E3e  = S_V ONLY
     snapshot final val
     → rq_mcycle  (replaces c4_rq only)
     → S_V_FIN
     → vv_wdata <= c4_sat(rq_q)[15:0]
     → GOLDEN.svh n=242
     → new OOC (do not overwrite E3a/E3d reports)
     → read new top-N

E3f  = only if that top-N is S_Q / S_K (or another named site)
```

Do **not** touch `S_Q` or `S_K` in E3e. If WNS improves, the cause is the proven `S_V` cone.

## PRODUCT WIDTH LAW

Current D32 function:

```systemverilog
logic signed [63:0] prod;
prod = val * $signed(64'(mul));
```

The sequential unit must reproduce **exactly** that 64-bit two's-complement `prod` **before** abs / round / shift.

- Use the same expression: `prod = val * $signed(64'(mul));` assigned to `logic signed [63:0]`.
- Do **not** keep a 128-bit mathematical product, round/shift in the wide domain, then truncate.
- Do not substitute `{32'd0, mul}` or other concatenations unless they are proven bitwise-identical to `$signed(64'(mul))` **and** the 64-bit assignment of `*`.

A 241/242 GOLDEN miss on one overflow corner is a PRODUCT WIDTH LAW fail.

## What the unit is / is not

```text
inputs:  val[63:0], mul, shr
output:  rq_q[63:0]   // exact c4_rq(val,mul,shr)
```

No `sat_en`. No `c4_sat` inside the unit. `S_V_FIN` applies the existing `c4_sat()` function.

## Gate

1. iverilog unit TB vs D32 `c4_rq` (including a 64-bit-truncate-vs-wide-product corner) — PASS marker required.
2. Instantiate **S_V / S_V_RQ / S_V_FIN only**; GOLDEN.svh n=242 — extra cycles OK; tokens must match.
3. New OOC `timing_n20_e3e.rpt` / `d32_ooc_e3e.dcp`. **Do not overwrite** E3a `timing_n20.rpt` or E3d `timing_n20_e3d.rpt`.
4. Do not program. Do not stamp MASTER.
