# PREREG — ASTRA-C4-BIAS-LOAD-DEAD-01

PROGRAM=NO. Instantiates **unedited** `a7ng_astra_c4_lm06_grounded_gen`.
Does not patch the DUT. One unknown: does `load_idx_i < A7NG_C4G_V[5:0]` reject
every bias write because `V=64` slices to 0?

HIT this bag if:
- `A7NG_C4G_V[5:0]==0` displayed
- LD_BIAS idx=1 and idx=63 with weight 200, g_match=g_safe=g_eos=0, evid_obj=10
  first token is **not** 1 or 63 (stays EOS/0)

This bag PASSES when the bug is **observed**. It does not fix the head.
Does not stamp C4_MASTER.
