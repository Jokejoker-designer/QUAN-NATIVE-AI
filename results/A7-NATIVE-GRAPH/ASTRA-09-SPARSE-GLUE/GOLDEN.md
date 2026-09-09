# GOLDEN — ASTRA-09-SPARSE-GLUE

Independent host twin. Walker plant IDs ≥ 201 are retrieval-only, not 2-hop answers.

v1 QSE SHA = `ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768` (must stay ede064f0…)
v1 lexicon SHA = `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7`

| Case | Query | n_dir | n_emit | st | ans | p0 | p1 |
|------|-------|------:|-------:|----|----:|---:|---:|
| C1_FWD | pump supplies chiller | 4 | 6 | ANSWER | 1 | 3 | 0 |
| C1_REV | chiller supplies pump | 4 | 3 | WRONGDIR | 0 | 0 | 0 |
| C1_NTRANS | pump supplies indirect condenser | 4 | 6 | NTRANS | 0 | 0 | 0 |
| C2_1HOP | pump requires chiller | 4 | 6 | ANSWER | 1 | 1 | 0 |
| C3_2HOP | pump requires indirect compressor | 4 | 6 | ANSWER | 4 | 1 | 2 |
| C3_NO_AC | pump requires compressor | 4 | 6 | UNKNOWN | 0 | 0 | 0 |
| C4_UNREL | payroll tax form | 0 | 0 | UNKNOWN | 0 | 0 | 0 |
| C5_MISS | pump requires indirect compressor | 4 | 6 | UNKNOWN | 0 | 0 | 0 |
| C6_REV1 | chiller requires pump | 4 | 3 | WRONGDIR | 0 | 0 | 0 |
| C6_REV2 | compressor requires indirect pump | 4 | 3 | UNKNOWN | 0 | 0 | 0 |
