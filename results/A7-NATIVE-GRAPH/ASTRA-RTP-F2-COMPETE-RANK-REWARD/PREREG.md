# PREREG — F2/F3 competing proofs + rank-before-select + scalar reward

```text
PROGRAM=NO
GOLD_AFTER_REWARD = valve path eid 18,35 mid=8
TIE_BREAK = lower proof0
CONTROL = validity-only (phi[2]) cannot uniquely pick gold
```

Two legal 2-hop proofs, same query `pump requires indirect`, same answer object 4:
- A chiller: 10-1-4 eids 17,34 mid=1
- B valve:   10-8-4 eids 18,35 mid=8

phi[0]=64 iff mid=1; phi[1]=64 iff mid=8; phi[2]=64 iff complete (both).

Round0 freeze=0 w=0: scores equal, pick min p0=17.
TB applies scalar reward -3 to **selected** pending phi.
Round1 same query: learned should pick 18 (valve).
Control argmax(phi[2]) stays tied → still 17. Control does not switch.
