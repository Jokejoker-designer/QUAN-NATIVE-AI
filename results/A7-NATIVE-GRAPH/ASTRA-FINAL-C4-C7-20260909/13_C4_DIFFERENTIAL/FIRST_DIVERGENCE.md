# FIRST_DIVERGENCE — G04 D32 FR XSim vs IntegerModel

**PROGRAM=NO. C4_MASTER=OPEN. BOARD_PASS=OPEN.**

## Observed (XSim 2026.1, frozen GOLDEN.svh)

- Marker: `ASTRA_C4_D32_FR_V1_XSIM_FAIL`
- First check: `N_0` / `TOK_0_0 exp=104 got=103` (`'h'` vs `'g'`)
- SAFE (`n,o,EOS`) and `zero_w` (EOS) cases matched; learned path did not.

## Probe at first `tok_valid` of case 0 (`F drum hose>drum`)

| signal | IntegerModel | RTL (pre-fix) |
|---|---|---|
| We[0], We[70*32], We[104*32] | -9, 15, 48 | -9, 15, 48 |
| toks[0,7,16] | 70, 104, 0 | 70, 104, 0 |
| x[0][0:3] | 167, 219, 212, 590 | 167, 2047, -2047, 590 |
| x[7][0:3] | 518, 445, 63, -372 | 518, 445, -2047, -2047 |
| q[0:3] | -394, -88, 97, -533 | -2047, -1355, 1700, -1141 |
| logits g,h | -16, 90 | 306, -89 |
| argmax | 104 `'h'` | 103 `'g'` |

Hex `We.hex` matches IntegerModel `We` ravel (C order).

## Classification

- **FACT:** First mismatched tensor is embedding `x`, not `$readmemh`, not context load, not S_SAFE.
- **FACT:** Dimensions with matching `x` are consistent with non-negative int8 operands; saturating dimensions are consistent with negative int8.
- **FACT:** S_EMB passed `{{48{i8[7]}}, i8}` (56 bits) into `c4_rq(input signed [63:0])`.
- **INFERENCE:** Verilog concatenation is unsigned; a 56-bit value zero-extends into bit [63:56], so negative weights become ~2^56 before requant and then `c4_sat` clips to ±2047.
- **CONTRAST:** `{{48{i16[15]}}, i16}` in S_Y/S_F2 is already 64 bits (bit-pattern-correct) and was not changed in the same patch.

## One-stage fix

S_EMB only: `{{56{i8[7]}}, i8}` so the rq operand is 64-bit two's complement.

Post-fix XSim 2026.1: `ASTRA_C4_D32_FR_V1_XSIM_PASS n=23`. Probe case 0 matched IntegerModel (`x0=167,219,212,590`, `q=-394,-88,97,-533`, `dots=856,5152,-2767`, `attn7=32767`, `logits g,h,o=-16,90,-33`, `best=104`).

Do not stamp `C4_MASTER` from the 23-case TB. WO still requires RTL==INT on Confirm WO360 and later gates.
