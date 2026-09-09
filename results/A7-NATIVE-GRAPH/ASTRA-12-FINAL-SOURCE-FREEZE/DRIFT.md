# ASTRA-12 freeze vs live (after SPARSE09 glue)

```text
EXPECTED     = YES (PAUSE_RESUME.md)
FIX_RTL      = NO
PROGRAM      = NO
AUTHORITY    = ASTRA-12B-POST-GLUE-FREEZE
```

Three integrate files changed after ASTRA-12 hash freeze. This is the sparse-glue delta, not silent corruption.

| File | freeze12 | live (12B) |
|------|----------|------------|
| a7ng_query_axi_sparse.sv | 27ea014a… | 5a4ad04d… |
| a7ng_astra09_pipe.sv | 947b8db1… | 48c9e480… |
| a7ng_unified_pipe.sv | 0eb69dca… | 5c82ad95… |

v1 QSE `a7ng_query_struct_extract.sv` still `ede064f0…546768`.
Do not revert these files to freeze12. Next authority = `ASTRA-12B-POST-GLUE-FREEZE`.
