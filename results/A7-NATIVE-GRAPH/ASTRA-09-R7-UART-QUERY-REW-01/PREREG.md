# PREREG — ASTRA-09-R7-UART-QUERY-REW-01

Frozen before xvlog. PROGRAM=NO. No board. No JTAG/xsdb/COM12/bitstream.
Does not edit ASTRA-09-R6-UART-ISO-PUBLIC-01 / ASTRA-09-R5-UART-ISO-INNER-01 /
ASTRA-09-R4-UART-ISO-01 / ASTRA-09-R3-UART-XSIM-01 /
ASTRA-12-R3-UART-WRAP-CANDIDATES-01 / ASTRA-11-A09R3-UART-* /
ASTRA-09-R2-CAND-OVF-01 / ASTRA-09-INTEGRATED-PATH-01 / ASTRA-12* /
ASTRA-11-A09-IMPL-ROUTE-01 / F2R-* / F3-* / ASTRA-06-* bags or frozen RTL
(`a7ng_astra_09_integ_path.sv/.svh`, `a7ng_astra_09_r2_cand_ovf.sv/.svh`,
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv`). Does not rerun those bags' `run_*.ps1`.
Does not open LM06 / BOARD / DDR / Master F3. Does not freeze PRODUCTION_TOP.
Does **not** claim ASTRA-09-R6 ISO-opcode numbers as this bag.
Does **not** patch frozen A09-R2.

## Claim this bag may close

One named UART query-learn XSim (this bag only): a new wrap instantiates
frozen `a7ng_astra_09_r2_cand_ovf` (`15a919f1…`) as `u_a09r2`. Host UART
115200 8N1 drives **query tokens + fire** then **matching-txn pending
reward** onto A09-R2 exported `tok_*` / `fire_i` / `retire_i` / `rew_*`
(`load_from_tb=0`). Wrap/TB/plant/svh contain no `force` / `release` /
`deposit`. No second ISO-opcode DUT. Byte stream / hierarchical inner
`u_a09r2.u_sgd.w_o[0]` shows:

- smoke two-proof ANSWER `ans=4 p0=17 p1=34`
- then matching txn reward `-3` → inner w0=`-5` (oracle: smoke phi0=50)
- CAND_CAP overflow INCOMP `ans=0 p0=0` (ntrunc visible)
- UNREL no stale `UNKNOWN ans=0 p0=0`

UNISIM MMCM or behavioral MMCM_STUB. Not silicon MMCM. Not BOARD_PASS.

## One unknown

Can UART 8N1 drive A09-R2 **query** (tokens+fire) then **pending reward**
(`rew_v_i`/`rew_i`/`txn`/`gen` as exported) so a two-proof smoke ANSWER
is followed by inner w0 matching the frozen symmetric-law oracle — with
no force, `load_from_tb=0`?

## Oracle (frozen SGD + A09-R2 phi)

Smoke plant facts 17/34 have conf=200,200. A09-R2 `qphi0=min(c1,c2)[7:2]`.
Winning two-hop phi0 = `200>>2 = 50`. From-zero `v=0`. Reward `-3`:
`err=-768`, `dw0=rsh40(-768*50, 13)=-5`. Inner `w_o[0]` expect `-5`.
If live phi0 differs, fail this PREREG (do not edit golden).

## Registered caps

```text
DUT_MODULE      = a7ng_astra_09_r2_cand_ovf (instantiated, not patched)
WRAP            = a7ng_astra_09_r7_uart_query_rew_wrap (bag-local; not PRODUCTION_TOP)
INNER_SGD       = u_a09r2.u_sgd (frozen a7ng_shared_rank_sgd_q8_sym_f2r2)
CAND_CAP        = 16
MAX_PATH        = 4
OVF_PLANT_N     = 20   (must be > CAND_CAP)
UART            = 115200 8N1
CLK_PIN         = CLK100MHZ 10 ns → MMCM 50 MHz pipe
MAGIC           = A2
EOL             = 0x0A
CMD_REW         = 0xA6
CMD_RET         = 0xA7
OBS_TAG         = 0x57
SMOKE           = "pump requires indirect\n" → ANSWER ans=4 p0=17 p1=34
REW             = matching txn/gen/epoch; rew=-3 → inner w0=-5 phi0=50
OVF             = same query on N=20 plant → ST_INCOMP=6 ans=0 p0=0
UNREL           = "payroll tax form\n" on smoke plant → UNKNOWN ans=0 p0=0
LOAD_FROM_TB    = 0
NO_SIM_OVERRIDE = 1
NO_ISO_PUB_DUT  = 1
FROZEN_A09R2    = 15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23
FROZEN_A09      = 9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c
FROZEN_SGD      = b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac
```

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| SMOKE_UART | sw plant=SMOKE; query smoke string | MAGIC A2; st=0 ans=4 p0=17 p1=34 tbl=0 npath>=2; phi0=50; inner w0=0; pend_acc=1 |
| REW_M3_W0 | HOLD; UART A6 rew=-3 matching txn/gen/epoch | OBS tag 0x57; inner/pub/hier w0=-5; nupd=1 nbad=0 nstale=0 tbl=0 |
| OVF_UART | RET; sw plant=OVF; same query | MAGIC A2; st=6 ans=0 p0=0 tbl=0; ntrunc!=0; not ANSWER 4 |
| UNREL_UART | RET; sw plant=SMOKE; `payroll tax form\n` | MAGIC A2; st=1 ans=0 p0=0 tbl=0 |
| HIER_TBL0 | hierarchical `load_from_tb_o` | 0 on all frames |
| PORT_ONLY | wrap/TB/plant/svh source | no `force` / `release` / `deposit` |

## Out of scope

Master ASTRA-09 production path. ASTRA-13. BOARD_PASS. LM06. wrap-route bit.
`PRODUCTION_TOP` freeze. ASTRA-09-R6 ISO-opcode DUT promotion. ASTRA-09-R5
sim-override inner-port ISO. ASTRA-09-R4 sibling-ISO. Silicon UART.
Patching frozen A09 leftover `ans=4`. Patching frozen A09-R2 DUT.
Patching frozen SGD. Second ISO-opcode DUT.
