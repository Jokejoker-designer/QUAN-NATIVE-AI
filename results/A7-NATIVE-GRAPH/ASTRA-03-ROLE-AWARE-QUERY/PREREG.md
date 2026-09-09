# PREREG — ASTRA-03 ROLE-AWARE-QUERY-REPRESENTATION

```text
GATE            = ASTRA-03-ROLE-AWARE-QUERY-REPRESENTATION
LAST_PASS       = ASTRA-02 PASS_NARROW
HEAD            = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
QUERY_LAW_OLD   = qse-v1-lexicon-hdc-00  (control; do not silently edit)
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
```

## Primary unknown

Can the parser preserve ordered semantic roles?

ASTRA-02 measured `role_keys_identical=YES` for:

- `pump supplies chiller`
- `chiller supplies pump`

Mandatory falsifiers (same words, different direction):

```text
A supplies B    vs    B supplies A
A requires B    vs    B requires A
```

PASS requires different query packets (subject/object/direction) and different
candidate/proof obligations. Same bag-of-lexicon keys is FAIL, not a paraphrase win.

Do not encode the exam pair as a ROM. New representation must be versioned;
do not retarget frozen qse-v1 keys in place if that breaks ASTRA-01/02 regression.

```text
QUERY_LAW_NEW   = qse-role-v1-00
CONTROL_LAW     = qse-v1-lexicon-hdc-00  UNCHANGED
GRAMMAR         = first entity=subject, relation word, second entity=object
LOWEST_ID_PICK  = FORBIDDEN
```

Cuts (stop at first divergence):

| Cut | Requirement |
|-----|-------------|
| R1 | `pump supplies chiller` packet != `chiller supplies pump` |
| R2 | `pump requires chiller` packet != `chiller requires pump` |
| R3 | qse-v1 control still collapses both supplies pairs (regression) |
| R4 | RTL twin-exact vs host `qse-role-v1-00` |
| R5 | n_host_*=0; no exam-phrase ROM |

## Not this gate

2-hop engine (ASTRA-04), board program, 800k precision retarget.
