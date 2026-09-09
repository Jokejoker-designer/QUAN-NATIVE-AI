# RESULTS — ASTRA-C6-OOC-PREFLIGHT-01

```text
GATE            = ASTRA-C6-OOC-PREFLIGHT-01
OOC             = ASTRA_C6_OOC_PREFLIGHT_PASS
RESULT          = PASS_THIS_GATE_ONLY
C6_MASTER       = OPEN
WHOLECHIP_WNS   = NOT_THIS_BAG
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS      = REJECT
PROGRAM         = NO
MIG             = NO
A09             = NOT_TOP
PART            = xc7a100tcsg324-1
MODE            = synth_design -mode out_of_context
```

GOLDEN hashed before Vivado (`91e563e3b95b4004409386b8804178f164e76b626286cad38476118600817faf`). KEEP C0/C1/C2 hashes MATCH. GOLDEN was not regenerated. Tcl `fail` was unset at the end of the first Vivado run; all six `C6OOC_SYNTH_OK` lines were already in `vivado.log` before the marker was appended.

## Raw measured Slice LUT / FF (util reports, not CELL_FF filter)

```text
CLASS_ooc_parser HIT         extract     SLICE_LUT=2506  SLICE_FF=343   BRAM=0 DSP=0
CLASS_ooc_index HIT          synonym     SLICE_LUT=2784  SLICE_FF=830   BRAM=0 DSP=0
CLASS_ooc_proof_learner HIT  c3_held_out SLICE_LUT=5073  SLICE_FF=3952  BRAM=0 DSP=0
CLASS_ooc_persist HIT        c2_persist  SLICE_LUT=339   SLICE_FF=459   BRAM=0 DSP=0
CLASS_ooc_lm_autoreg HIT     c4_gen      SLICE_LUT=179   SLICE_FF=131   BRAM=0 DSP=0
CLASS_ooc_prod_top HIT       c5_prod_top SLICE_LUT=4093  SLICE_FF=3034  BRAM=0 DSP=0
CLASS_no_a09_top HIT
CLASS_no_mig_synth HIT
CLASS_no_wholechip_wns HIT C6_WHOLECHIP_WNS=NOT_THIS_BAG
CLASS_envelope_reported HIT preferred LUT<=40000 FF<=50000 BRAM36eq<=115 DSP<=32
```

Preferred envelope vs C5 prod-top OOC: LUT 4093 ≤ 40000, FF 3034 ≤ 50000, BRAM 0 ≤ 115, DSP 0 ≤ 32.

## Quality bound (do not promote)

Evidence class **OOC**. Synthesized, not placed/routed. Not MIG PHY. Not unique bit. Not BOARD.
A09R8 is not this co-fit. OOC timing slack is not Master WNS.

## KEEP

No C0/C1/C2 KEEP edited. C3/C4/C5 named modules instantiated as OOC tops, not edited.
