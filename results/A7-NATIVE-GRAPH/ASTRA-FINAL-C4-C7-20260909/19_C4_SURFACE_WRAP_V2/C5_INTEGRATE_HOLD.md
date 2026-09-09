# C5 final_v1 status

Hand-built `a7ng_astra_c5_prod_top_final_v1` exists. Elaborate-only XSim **ASTRA_C5_FINAL_V1_ELAB_OK**.

**Not C5_MASTER.** Production ENTITY_ALIAS dictionary **OPEN** (Confirm V3 symbols are synthetic 4-char strings, not C3 IDs). Empty table → wrap `S_SAFE`.

**Not switched into C6.** Live `a7ng_astra_c6_wholechip` still instantiates `a7ng_astra_c5_prod_top`. C6 also does not yet forward MIG RRESP/RLAST/RID required by this top.

**PROGRAM=NO.** No frozen C6 bit. G14 BOARD_PASS remains BLOCKED.
