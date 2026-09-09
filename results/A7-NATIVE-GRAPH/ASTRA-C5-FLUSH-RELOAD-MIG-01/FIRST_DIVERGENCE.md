# FIRST_DIVERGENCE — ASTRA-C5-FLUSH-RELOAD-MIG-01

PROGRAM=NO. GOLDEN not regenerated.
Hash `dd16753ee8eb37eeafa5fbea1ea20e73e39c9565110a0348b99371a589d68c1b`.

## r0

- Q1 ANSWER dest=64 w0=3; flush HIT; no MEAS RELOAD
- xsim exit=-1 ~4080 ms sim / ~137 min wall; persist-row DRAM READ `000a`
- Archive: `xsim_fail_r0.log`

## r1 (CKPT rready = arb && p_rrdy only)

- Same Q1/flush; `MEAS POST_RELOAD_CMD owner=5 pph=0`; `MEAS RELOAD_WAIT guard=200000` once
- Killed at ~4100 ms sim / ~156 min; still no CLASS_c2_persist_reload
- Archive: `xsim_fail_r1.log`

## r2 (orphan-R drain while C2 S_AR && !arready)

FACT from stdout (UTF-16), not live `xsim.log`:

- Same Q1/flush PASS; `MEAS POST_RELOAD_CMD owner=5 pph=0 pvalid=0`
- `MEAS RELOAD_WAIT guard=200000 owner=5 pph=0 pvalid=0 nsw=17 nblk=2` (only once)
- last DRAM stamp 4290999466.0 ps (~4291 ms), wall ~156 min, past r0 crash sim time
- Wrapper: `C5FRM_XSIM_CONTROL_FAIL exit=-1` missing CLASS_c2_persist_reload HIT
- Archive: `xsim_fail_r2.log`
- GOLDEN unchanged

INFERENCE: r2 drain did not complete reload. Same hang class as r1 (ui wait frozen at 200000 while DRAM time advanced).

HYPOTHESIS (r2 falsified as sufficient): draining R in S_AR either drops the reload beat or never sees an orphan; MIG then retries the same persist READ. Need to **hold** the beat for C2 S_R.

## r3 change

C5 prod_top only (not C0/C1/C2 KEEP): 1-beat CKPT R skid.

- `m_rready_o` when CKPT = `arb_rready && (!ckpt_hv || p_rrdy)`
- `p_rv`/`p_rd` from registered `ckpt_hv`/`ckpt_hd`
- Do not regenerate GOLDEN
- Archive: `xsim_fail_r3.log` (same hang class: Q1+flush PASS, no CLASS_c2_persist_reload)

## r4 (grant hold — UART 0x12→EOL)

FACT from RTL (not another model): on `0x12`, `p_rel`/`reload_pend` fire while `pst` stays `ST_UART` until EOL. C2 `S_AR` then `S_R` drops `p_arv`; old `req[CKPT]` omitted `reload_pend`/`p_busy`, so owner went NONE and `m_rready_o=m_rvalid_i` ate the persist beat.

r4: `req[CKPT]` includes `reload_pend || p_busy`; arbiter holds `S_OWN` while `pend!=0`; `m_wstrb_o=p_wstrb`; `ST_WAITQ` uses `c3_res || rew_sent`. GOLDEN frozen. KEEP C2 untouched.

## r4 result (raw xsim.log)

FACT: `ASTRA_C5_FLUSH_RELOAD_MIG_XSIM_PASS`. `CLASS_c2_persist_reload HIT w0=3`. `$finish` 168626625 ps. Wrapper `ASTRA_C5_FLUSH_RELOAD_MIG_RUN_OK` exit=0. GOLDEN unchanged. C5_MASTER remains OPEN.
