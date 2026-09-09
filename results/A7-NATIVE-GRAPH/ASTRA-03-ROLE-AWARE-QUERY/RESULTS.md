# RESULTS — ASTRA-03 ROLE-AWARE-QUERY

```text
GATE            = ASTRA-03-ROLE-AWARE-QUERY
HOST            = ASTRA03_HOST_PASS
XSIM            = ASTRA03_ROLE_AWARE_XSIM_PASS
V1_SMOKE        = PASS (chiller eid=1, n_host=0)
V1_CONTROL      = ROLE_COLLAPSE unchanged (identical keys both directions)
FIRST_DIVERGENCE= none
LAW             = qse-v2-role-00
CONTROL_LAW     = qse-v1-lexicon-hdc-00 UNCHANGED
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
V31_WRITES      = 0
N_HOST          = 0
OPEN_NLU        = NOT CLAIMED
```

## What was measured

v2 streaming grammar binds first entity as subject and the entity after a relation as object.
Reverse pairs swap `subj/obj`, `k0/k1={role,rel}`, and `k2/k3` cues. v1 control still collapses.

| pair | subj/obj A | subj/obj B | k0 A | k0 B | emit A | emit B |
|---|---|---|---|---|---|---|
| `pump supplies chiller` vs `chiller supplies pump` | 10/1 | 1/10 | 0A01 | 0101 | [101, 105, 109, 103, 111] | [102, 104, 106, 110, 112] |
| `ahu requires chiller` vs `chiller requires ahu` | 6/1 | 1/6 | 0602 | 0102 | [103, 105, 111, 101, 109] | [104, 106, 102, 110, 112] |
| `pump requires chiller` vs `chiller requires pump` | 10/1 | 1/10 | 0A02 | 0102 | [105, 103, 101, 109, 111] | [104, 106, 102, 110, 112] |
| `compressor requires refrigerant` vs `refrigerant requires compressor` | 4/5 | 5/4 | 0402 | 0502 | [107] | [108] |
| `pump supply chiller` vs `chiller supply pump` | 10/1 | 1/10 | 0A01 | 0101 | [101, 105, 109, 103, 111] | [102, 104, 106, 110, 112] |
| `pump connects chiller` vs `chiller connects pump` | 10/1 | 1/10 | 0A03 | 0103 | [109, 111, 101, 105, 103] | [110, 112, 102, 104, 106] |
| `ahu connects to chiller` vs `chiller connects to ahu` | 6/1 | 1/6 | 0603 | 0103 | [111, 109, 103, 101, 105] | [110, 112, 102, 104, 106] |

Single-entity `chiller`: subject=1, object empty, n_host=0, not a triple.
`supply duct`: context+entity (duct subject, supply not a verb here).
Unrelated `payroll tax form` / `soccer match score`: no domain triple, walker emit=0.
`pump chiller` (no relation): subject=pump(10), object=chiller(1), ambiguity=1 — not min-ID collapse.

## Narrow claim

Same words, different direction produce different structured packets and different candidate IDs
under `qse-v2-role-00`. Frozen `qse-v1-lexicon-hdc-00` is unchanged and still bag-of-lexicon.

## Not claimed

- Open NLU / Vietnamese / unseen synonyms
- 2-hop reasoning (ASTRA-04)
- Board / Gate14 / 800k precision retarget
