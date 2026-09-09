# WO — ASTRA-C5-FLUSH-RELOAD-MIG-01 r3→r4 (DDR Arbiter Deadlock Fix)

Status: **READY** — Antigravity deep audit complete, root cause confirmed
Issued: 2026-09-08T14:00Z by Antigravity (independent auditor)
Implementer: Cursor (live clone only)

## Root Cause (confirmed by two independent RTL auditors)

**Orphan R-beat deadlock** in the DDR arbiter → CKPT skid buffer interaction.

When the arbiter switches owner to CKPT (persist reload, owner=5), MIG may
still have in-flight R data from the **previous owner** (query path). The CKPT
skid buffer (`ckpt_hv`) blindly captures this orphan beat. Since C2 persist
has no outstanding read at this point (`p_rrdy=0`, `pph=0`), `m_rready_o`
is forced low permanently, deadlocking MIG's read channel.

This is why all three runs (r0/r1/r2) show:
- `MEAS POST_RELOAD_CMD owner=5 pph=0` — CKPT owns bus, C2 is idle
- `MEAS RELOAD_WAIT guard=200000` — C2 reload never completes
- `C5FRM_XSIM_CONTROL_FAIL` — timeout without `CLASS_c2_persist_reload`

## Three bugs to fix (all in C5 new files, NOT C0/C1/C2 KEEP)

### Bug 1 (P0): CKPT skid captures orphan R beats

**File:** `a7ng_astra_c5_prod_top.sv` lines 420-435
**Problem:** `ckpt_hv` captures ANY `m_rvalid_i` when owner=CKPT, even if C2
has not issued an AR (no outstanding read beats expected).

**Fix:** Track outstanding CKPT read beats. Only capture into skid when
`ckpt_rd_pend > 0`. When `ckpt_rd_pend == 0`, accept and DROP orphan beats
(assert `m_rready_o` to drain them, but don't latch into `ckpt_hd`).

```systemverilog
// Add outstanding read beat counter
logic [8:0] ckpt_rd_pend;
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) ckpt_rd_pend <= 9'd0;
  else begin
    logic ckpt_ar_fire = (owner == A7NG_C5_CKPT) && p_arv && p_arr;
    logic ckpt_r_fire  = (owner == A7NG_C5_CKPT) && m_rvalid_i && m_rready_o;
    unique case ({ckpt_ar_fire, ckpt_r_fire})
      2'b10: ckpt_rd_pend <= ckpt_rd_pend + 9'd1;  // AR fired, no R
      2'b01: ckpt_rd_pend <= (ckpt_rd_pend > 0) ? ckpt_rd_pend - 9'd1 : 9'd0;
      2'b11: ckpt_rd_pend <= ckpt_rd_pend;           // simultaneous
      default: ;
    endcase
  end
end

// Modify skid capture: guard on ckpt_rd_pend > 0
// Modify m_rready_o for CKPT: drain orphans when pend == 0
```

### Bug 2 (P1): Arbiter owner release while R in-flight

**File:** `a7ng_astra_c5_ddr_arb.sv` lines 84-90
**Problem:** `if (!req_i[own])` releases owner on the same cycle req drops.
MIG may still have R data in-flight → becomes orphan on next owner.

**Fix:** Guard release on `!m_rvalid_i` (no pending R data).

```systemverilog
// OLD:
if (!req_i[own]) begin
  own <= A7NG_C5_NONE;
  st <= S_IDLE;
end

// NEW:
if (!req_i[own] && !m_rvalid_i) begin
  own <= A7NG_C5_NONE;
  st <= S_IDLE;
end
```

### Bug 3 (P2): Arbiter can drop ARVALID before ARREADY handshake

**File:** `a7ng_astra_c5_ddr_arb.sv` lines 55, 84-90
**Problem:** If client drops `req_i` while its `s_arvalid_i` is high and
`m_arready_i` hasn't come, arbiter goes S_IDLE → drops `m_arvalid_o`.
This violates AXI protocol (VALID must not deassert before READY handshake).

**Fix:** Guard state transition on no pending AR handshake.

```systemverilog
if (!req_i[own] && !m_rvalid_i
    && !(s_arvalid_i[own] && !m_arready_i)) begin
  own <= A7NG_C5_NONE;
  st <= S_IDLE;
end
```

## FAIL if

- C0/C1/C2 KEEP files modified
- GOLDEN.json regenerated (hash must match existing `GOLD_HASH_PRE_XVLOG.txt`)
- PROGRAM=YES
- Fix touches `a7ng_astra_c2_persist_commit.sv` (KEEP; bug is in C5 arb)
- Fix touches `mig_native_wrap.sv` or official `mig.prj` (KEEP)
- RESULTS self-stamps C5 Master close or BOARD_PASS

## Must not edit (KEEP integrity)

All files in `KEEP_HASHES.json` — the bug is entirely in new C5 files:
- `a7ng_astra_c5_ddr_arb.sv` (edit OK — new C5 file)
- `a7ng_astra_c5_prod_top.sv` (edit OK — new C5 file)

## Expected outcome after fix

```text
C5_FLUSH_RELOAD_MIG PROGRAM=NO BOARD_PASS=REJECT MIG=YES
CLASS_mig_calib_complete HIT
CLASS_c2_persist_commit HIT
CLASS_c2_persist_flush HIT
CLASS_bram_clear HIT
CLASS_c2_persist_reload HIT identity_exact w0=<expected>
CLASS_false_success_zero HIT
RESULT=PASS_THIS_GATE_ONLY
```

## Evidence class

XSIM (not BOARD). Does not freeze DDR_QUERY_BOUND_FINAL or PERSIST_SCHEMA_VERSION.

## Verification

After Cursor applies fix, Antigravity will:
1. Re-run `c1_800k_close_gate.py` (must remain YES_XSIM)
2. Re-run `c2_persist_close_gate.py` (must remain YES_XSIM)
3. Verify KEEP hashes unchanged
4. Read raw `xsim.log` for `CLASS_c2_persist_reload HIT`
5. Write `AUDITOR/` report
