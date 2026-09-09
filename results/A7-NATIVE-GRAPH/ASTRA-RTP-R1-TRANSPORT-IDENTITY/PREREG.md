# PREREG — RTP-R1 transport / identity / uncertainty

Registered **before** XSim. Original RTP bag remains PASS_NARROW and is not rewritten.

```text
GATE        = ASTRA-RTP-R1-TRANSPORT-IDENTITY
KEEP        = ASTRA-RTP-RETRIEVAL-TO-PROOF PASS_NARROW
ID_W        = 20
CAND_CAP    = 16
N_EDGES     = 16
SCHEMA      = rtp-desc-v1
FETCH_TO    = 64 cycles
PROGRAM     = NO
```

## rtp-desc-v1 (128-bit, freeze)

| bits | field |
|------|--------|
| 19:0 | subject_id |
| 39:20 | object_id |
| 47:40 | relation_id |
| 67:48 | eid (must equal fetched cand_id) |
| 68 | trans |
| 69 | pol |
| 70 | valid |
| 75:72 | schema_ver = 1 |

Do not load a beat if: RRESP!=OKAY, RLAST!=1, RID!=ARID(2), timeout, valid=0, schema_ver!=1, or eid!=cand_id.

## Status policy (4-bit)

| code | when |
|------|------|
| 7 AMBIGUOUS | qse_amb |
| 8 NEGATED | qse_neg |
| 6 INCOMPLETE | w_ovf or AXI fetch error/timeout |
| else | engine status 0..6 |

Amb/neg skip engine issue.

## Cases (before run)

Causal query: `pump requires indirect`. IDs 20-bit (17, 34).

| name | setup | expect |
|------|--------|--------|
| BASE | posting {17,34} good desc | ANSWER ans=4 p0=17 p1=34 |
| POST_DROP_BC | posting {17}, desc 34 still in RAM | UNKNOWN not keep 4 |
| DESC_SWAP | desc 34 object=7 | ANSWER 7 |
| UNREL | payroll | UNKNOWN **and** nc=nload=n_fact_ar=0 |
| AXI_BAD_RID | fact R channel RID=7 | that fact not loaded; if only BC poisoned → UNKNOWN |
| AXI_SLVERR | fact RRESP=2 | not loaded |
| AXI_NOLAST | RLAST=0 | not loaded |
| AXI_TIMEOUT | no fact RVALID | INCOMPLETE, n_to>=1 |
| OVF | directory ovf=1 | INCOMPLETE |
| NEG | `not pump requires indirect` | NEGATED (8), no ANSWER |
| AMB | `pump requires chiller or valve` | AMBIGUOUS (7), no ANSWER |

SHA256.txt is written before xvlog.
