# G04 WO360 XSim PASS (not C4_MASTER)

**PROGRAM=NO. C4_MASTER=OPEN. BOARD_PASS=OPEN.**

- Confirm lock SHA: `f876633e6daf4ca79317bec55ef9888e12ff726e26d316ad87193eaba74b3e6a`
- GOLDEN.svh hashed before xvlog: `136423ccbe5aa3b46660c6a5c3d0b289cb8fb51424af8018a728bcd237fb8d84`
- Marker: `ASTRA_C4_D32_FR_V1_WO360_XSIM_PASS n=360`
- `CLASS_ref_match HIT`
- `CLASS_host_tok0 HIT`
- `C4_MASTER_CLAIM=NO`

This is learned-path RTL vs IntegerModel on the frozen WO360 set (`answer_allowed=1` for all 360 rows). Unsupported rows are still decoded by the LM (hallucination proxy); system refusal is G05/G06, not this file.

`C4_MASTER_PASS` still requires WO §13: gate/refusal integration, materializer, causal, OOC synth, no host token authority.
