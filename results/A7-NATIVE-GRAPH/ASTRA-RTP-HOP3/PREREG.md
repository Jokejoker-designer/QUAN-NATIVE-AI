# PREREG — typed 3-hop (HANDOFF §6 / DESIGN)

```text
PROGRAM=NO
HOPS=3
ID_W=20
```

Query: `pump requires indirect`. Facts from AXI descriptors only (no TB load_v).

Chain: 10 --17--> 1 --34--> 4 --51--> 7 (all rel=requires, trans=1).

| Case | Setup | Expect |
|------|--------|--------|
| BASE | posting {17,34,51} | ANSWER 7 proof 17,34,51 n_hop=3 |
| DROP_LAST | posting {17,34}; desc 51 still in RAM | UNKNOWN not keep 7 |
| TWO_ONLY | posting {17,34} as 2-edge chain (no 3rd) | UNKNOWN for hop3 (must not report 2-hop ans=4 as 3-hop) |
| UNREL | payroll | UNKNOWN n_fact_ar=0 |

Do not retarget RTP-R1/R2 pipes.
