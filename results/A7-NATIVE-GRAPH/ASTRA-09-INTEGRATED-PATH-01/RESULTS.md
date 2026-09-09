# RESULTS — ASTRA-09-INTEGRATED-PATH-01

PROGRAM=NO. No JTAG/COM12/bit. F2R-* / F3-* / ASTRA-06-* bags not edited.
Frozen `a7ng_astra_f2r5_txn_wrap.sv` / `a7ng_astra_f2r4_axi_drain.sv` /
`a7ng_astra_f2r3_sem_guard.sv` / `a7ng_astra_f2r2_hs_law.sv` /
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv` / ASTRA-06 persist/R2/R3/R4 DUTs not patched.
Those bags' `run_*.ps1` not rerun. LM06 / BOARD / DDR / Master F3 not opened.

```text
XSIM_MARKER      = ASTRA_09_INTEGRATED_PATH_XSIM_PASS
VERDICT_PROPOSED = PASS_NARROW (this bag only: one named retrieve→proof→rank→pending→reward path + semantic refuse + AXI SLVERR abort)
SIM_TIME         = 12705 ns
FAIL             = 0
FIRST_DIVERGENCE = none
FAIL_R0          = none (first xvlog/xelab/xsim produced the marker)
BIT              = NOT_BUILT
PROGRAM          = false
```

## Path (this bag)

New named DUT `a7ng_astra_09_integ_path` instantiates frozen
`a7ng_shared_rank_sgd_q8_sym_f2r2` (`b66ef328…`). QSE + sparse AXI retrieve +
2-hop enum + symmetric SGD rank + pending `{sess,gen,txn,phi}` + handshake latch.
`load_from_tb_o=0`. Queries are tokens. Does not compile frozen F2R5/F3/ASTRA-06
integrators.

## Raw XSim (`xsim.log`)

xsim v2026.1, session **Sun Sep 6 18:53:05–18:53:07 2026**, PID **40928**,
snapshot `a09ip`, `$finish` at **12705 ns**.

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| SMOKE_TWO_PROOFS | st=0 npath=2 ans=4 p0=17 acc=1 txn=1 gen=1 ep=7 phi0=50 tbl=0 | PASS |
| HS_LATCH_NUPD | nupd=1 cmt=1 w0=-5 (one-cycle rew=-3 then bus invert) | PASS |
| CONFLICT_DEST | st=5 npath=2 ans=0 p0=0 acc=0 tbl=0 | PASS |
| CONFLICT_NO_UPD | nupd=0 w0=-16 (preloaded; not ranked away) | PASS |
| WRONG_OBJ | st=1 npath=0 ans=0 p0=0 obj=11 ctx=2 acc=0 | PASS |
| SLVERR | st=6 nerr=1 abort=1 ans=0 p0=0 acc=0 ost=0 arvalid=0 tbl=0 | PASS |
| SMOKE_AFTER | st=0 npath=2 ans=4 p0=17 tbl=0 | PASS |
| UNREL_NO_STALE | st=1 npath=0 ans=0 p0=0 tbl=0 | PASS |

Marker present. Zero `FAIL` lines. Reward oracle: plant A phi0=50, rew=-3, w=0 → dw0=-5
(same ISO law +3,x0=50 → +5, not floor +4).

## Hashes

SHA freeze BEFORE xvlog `2026-09-06T18:53:00.9388250+07:00`.
xsim session Sun Sep 6 18:53:05–18:53:07 2026 PID **40928**.
Compiled + `.svh` pre/post **13/13 MATCH** (includes `a7ng_astra_09_integ_path.svh`).
xsim.log SHA256 `445199d247c3f8e47ad2ea5204d46127f9c5eda9207239d7f4a800664b15caa7`.
Frozen SGD `b66ef328…`. Frozen F2R5 DUT provenance `41c77e76…` (not compiled).
Frozen R4 DUT provenance `4bd94762…` (not compiled).
R4 bag `xsim.log` still session 18:35:14. F2R5 still 13:53:26. F2R4 still 13:24:12.
F3R4 still 15:48:29.

## Open (unchanged)

Master F3 10 packed pages / CI. Master ASTRA-06 (schemaV2 DDR / DDR index N>1 /
DDR warm persist / NVM). LM06. BOARD_PASS. ASTRA-13. Same-query post-timeout
recovery. Interconnect cancel. Power-loss journal.
Do **not** call this Master F3, BOARD_PASS, or persist-DDR closed.
Manager independently accepts. Do not autonomously open the next gate.
