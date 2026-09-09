# 25_C5_EDGE_DIR_V1

PROGRAM=NO. C5_MASTER=OPEN. BOARD_PASS=OPEN.

DUT = `a7ng_astra_c5_prod_top_final_v1`. Modeled AXI.

## Classes

1. 2-hop ANSWER dest=64 (empty alias → UART S_SAFE)
2. `"valve requires pump"` not ANSWER (wrong direction)
3. delete second-hop fact → UNKNOWN
4. replace second-hop dest 64→80 → ANSWER dest=80

Not C5_MASTER. Production dictionary OPEN.
