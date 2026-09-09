// qse_relctx_synonym_01.svh — law qse-v2-relctx-synonym-01
// Named overlay. Not a C0 extract patch (cd7baf49). Not a C0 lexicon FILE
// rewrite (38189974). Not a named 187-word lexicon rewrite (df0e8833).
// Alias: REL/RELCTX id 1 (supply/supplies) → canonical REL id 4 (feeds/feed).
// Fill-meaning retrieve of {120,121,122} uses feeds keys after this bind.
// PROGRAM=NO.
`ifndef QSE_RELCTX_SYNONYM_01_SVH
`define QSE_RELCTX_SYNONYM_01_SVH
localparam int unsigned QSE_SYN_N = 1;
localparam logic [7:0] QSE_SYN_FROM [0:QSE_SYN_N-1] = '{8'd1};
localparam logic [7:0] QSE_SYN_TO   [0:QSE_SYN_N-1] = '{8'd4};
localparam logic [7:0] QSE_SYN_CANON_FEEDS  = 8'd4;
localparam logic [7:0] QSE_SYN_ALIAS_SUPPLY = 8'd1;
`endif
