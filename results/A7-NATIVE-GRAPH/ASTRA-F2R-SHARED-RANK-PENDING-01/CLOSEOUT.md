# CLOSEOUT — ASTRA-F2R-SHARED-RANK-PENDING-01

```text
RESULT               = PASS_NARROW
TASK                 = ASTRA-F2R-SHARED-RANK-PENDING-01
GROK_ASTRA           = 99be8510-6587-4eb0-a06e-0f9796e19b1d
ROLE                 = implementer_not_v31_manager
XSIM                 = ASTRA_F2R_XSIM_PASS
SIM_TIME_NS          = 61245
FAIL                 = 0
FIRST_DIVERGENCE     = NONE
SGD                  = a7ng_shared_rank_sgd_q8_v1_f2r (named copy of sequential v1)
SGD_V1_SHA           = 01ef40079f1407c1067ed98a6e1b0a4b0e8d0b6911f21afb0542e43728a73c24
F2R_SGD_SHA          = d34f418b59e38f073f86c89b46b84e60367a154fc846c6725ccf2b3fd233486e
DUT                  = a7ng_astra_f2r_rank
FEATURE              = min(src_conf)>>2 + shared trans/pol/schema/rel flags; not IDs
PENDING_TXN          = txn_id + copied phi + scalar rew[-3,+3]; dup/wrong-txn guards observed
TRANSFER             = 5/5 structural on planted worlds; Master F3 remains OPEN
F2T_CLASS_ONEHOT     = prior labeled control only; not this claim
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
LM06                 = NOT_INTEGRATED
F4 / F5 / BOARD_PASS = OPEN
```

## Evidence

- Raw XSim: `xsim.log` (SHA256 a51bd80a9ceccae5d9a8d7fe6d316a6bc314f13ef7efc8b231ceadde9c2c8975)
- xvlog: `xvlog.log` / `xvlog_dut.log`
- SHA freeze before xvlog: `SHA256.txt`; post-run compiled match: `SHA256_POST.txt`
- PREREG frozen before run: `PREREG.md`
- ACK: `ACK.json`

## Limitations (do not promote)

1. PASS_NARROW plumbing + integer dw + preference switch + 5-world structural plant. Not language, not 800k semantic, not Gate14, not BOARD_PASS.
2. Measured v after -3 is -13/-14, not PREREG 1-feature -2/-1, because pending phi[1:4] also train. Order still switches 17→18.
3. Held-out npath=3 from mid==entity 10 collision; still selected low-conf hop.
4. No DDR persistence. No implementation/route/bit.
5. Existing frozen bags, LOOP_STATE, V3.1 tree, and original SGD file were not edited.

## Next dependency

Independent manager acceptance of this bag. Do not autonomously open F4/F5/LM06/BOARD. Do not program Arty A7-100T from this result.
