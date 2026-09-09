# PREREG — ASTRA-C5-QPTEXT-HELDOUT-MIG-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, live C3 wrap,
live `a7ng_astra_c5_prod_top.sv`, `a7ng_astra_c5_prod_top_c4q.sv`, TinyGPT,
or official `mig.prj`. Does not freeze `DDR_QUERY_BOUND_FINAL`.

## One unknown

After official MIG `init_calib_complete`, on existing `a7ng_astra_c5_prod_top_c4q`
(not edited), does a frozen held-out query return the low-conf 2-hop distractor
(ans=144), and after one learn-mode train query with auto +3 reward, does the
same held-out query return the high-conf dest (ans=112)?

TB-only `defparam TO_CYC=65535`. Plant stays in TB.

## FAIL if

KEEP / live prod_top / c4q hashes drift, GOLDEN edited after xvlog, PROGRAM=YES,
TinyGPT / grounded_gen / live prod_top compiled as DUT.
