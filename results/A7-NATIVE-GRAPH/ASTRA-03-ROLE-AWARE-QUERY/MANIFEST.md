# MANIFEST — ASTRA-03

```text
PREREG.md
LOCK.txt
RESULTS.md
CLOSEOUT.md
METRICS.json
GOLDEN.json
query_gold.svh
host_astra03.py
twin_role.py
role_lexicon.py
gen_role_lexicon.py
tb_astra03_role_query.sv
run_xsim.tcl
xsim.log
SHA256.txt
INDEX.md
```

RTL authority: `rtl/native_graph/query/a7ng_query_role_extract.sv`
Lex: `rtl/native_graph/query/qse_role_lexicon.svh` (`qse-v2-role-00`)
Wrapper: `rtl/native_graph/integrate/a7ng_query_axi_sparse.sv` `LAW_SEL` default 0 (v1)
Control unchanged: `a7ng_query_struct_extract.sv` / `qse_lexicon.svh`

`a7ng_query_role_parse.sv` is a non-authority draft (not the ASTRA-03 closeout path).
