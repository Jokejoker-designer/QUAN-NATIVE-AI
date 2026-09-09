# 24_C5_REFUSE_FIFO_V1

PROGRAM=NO. C5_MASTER=OPEN. BOARD_PASS=OPEN. PROD_DICT=OPEN.

## DUT

`a7ng_astra_c5_prod_top_final_v1` only. No live `prod_top`. No `grounded_gen`.

## Classes (WO §15 6–9, 16 plus NEG)

1. AMBIGUOUS `"pump valve requires"` → `st=7`, UART `n,o,EOS`
2. NEG `"pump not requires valve"` → `st=8`, UART `n,o,EOS`
3. SEARCH_INCOMPLETE via directory `rdata[48]` overflow on 2-hop keys → `st=6`, UART `n,o,EOS`
4. FIFO full-sequence: synthetic TB alias on 1-hop ANSWER; pin tokens equal `n_stream`; `n_fifo_ovf=0`; not `last_gen`-only
5. Hierarchy defaults `CLK_HZ=83333333` `BAUD=115200`; one UNKNOWN query at those parameters (separate TB)

## Not claimed

C5_MASTER, production dictionary, parser reverse (`direction_o` remains `2'd0`), BOARD_PASS, PROGRAM.
