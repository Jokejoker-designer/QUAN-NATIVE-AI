# DeepSeek + Cursor independent accept

Key lives **only** in `C:\Users\phant\.cursor\secrets\deepseek.env` and the user env `DEEPSEEK_API_KEY`.
Never paste the key into this tree, LOOP_STATE, ChatGPT, or live RTL.

## Roles now

| Agent | Job |
|---|---|
| **DeepSeek `deepseek-v4-pro`** | High-complexity architecture / decide-order / Master letter reasoning. Output = draft markdown in `drafts/` |
| **DeepSeek `deepseek-v4-flash`** | Named-bag RTL/TB **drafts only** under `drafts/` |
| **Cursor (this session)** | Independent 验收: hash-gate KEEP, raw XSim, overclaim hunt, unblock when DeepSeek is stuck |
| **Antigravity** | Independent close-gates / WORK_ORDER |

DeepSeek does **not** write live `rtl/` or KEEP bags directly. Cursor copies a draft into a **new named bag** only after 验收 PASS.

## Invoke

```bat
cd /d D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
python scripts\deepseek_consult.py --role reasoner --in prompts\current.md --out drafts\
python scripts\deepseek_consult.py --role rtl --in prompts\current.md --out drafts\
```

`--role reasoner` / `--role checker` / `--role pro` → **`deepseek-v4-pro`**
`--role rtl` / `--role flash` → `deepseek-v4-flash`

Live `GET /models` (2026-09-08 ping): `deepseek-v4-flash`, `deepseek-v4-pro`, `deepseek-v4-flash-vision-exp`.
**There is no `deepseek-v4.1` id.** Do not request it. Checker after every assignment is **v4-pro**.

Auto loop (assign then v4-pro checker):

```bat
python scripts\c3_c6_auto_tick.py
```

## Cursor 验收 (every DeepSeek draft)

FAIL the draft (do not copy to live clone) if any:

1. Touches C0/C1/C2 KEEP hashes in `KEEP_HASHES.json`
2. Edits official `mig.prj` / `ddr3_model` / leftover A09 / prior_store
3. Regenerates GOLDEN after xvlog
4. Claims BOARD_PASS / freezes `DDR_QUERY_BOUND_FINAL` / `PERSIST_SCHEMA_VERSION`
5. Mixes two unknowns in one bag
6. Compiles STREAM-02 / ctx DUT `8255a798` / synth `mig_7series_0_mig.v` as DUT
7. RESULTS overclaims vs raw `xsim.log`

PASS draft → Cursor (or Anh) copies into live `results/A7-NATIVE-GRAPH/<BAG>/` + new named RTL only.

## When DeepSeek is stuck — Cursor unblocks immediately

Do **not** wait. Pick the first matching row:

| Stuck symptom | Cursor action now |
|---|---|
| Loops on same RTL, no new HIT class | Freeze DeepSeek. Cursor writes the **smallest** TB that isolates one CLASS_*; DeepSeek may only comment |
| Invents identity (low16 / 8-bit obj) | Reject draft. Point at persist-commit KEEP pack + `AWADDR=0x06000000`. New named wrap only |
| Wants to edit KEEP / C0 | Reject. New module + instantiate KEEP |
| XSim ACCESS_VIOLATION (MIG) | Cursor: xelab `-mt off -O0`; compile `mig_7series_0_mig_sim.v` not synth `mig.v` |
| Gold drift / fail then rewrite GOLDEN | Copy `xsim_fail_r0.log` once; TB/DUT-wrap fix only |
| Cannot separate C3 vs w0 0→-5 | Cursor writes prereg: 4 arms, disjoint entities; DeepSeek fills stimulus only |
| API 401/429/timeout | Cursor continues as implementer from last WORK_ORDER. Do not idle the ladder |
| Overclaim Master close | Cursor stamps REJECT. Antigravity gate stays red |
| Dead `F_BAD_TXN` style logic | Cursor hunts decide-order in KEEP; do not silent-patch KEEP; document mapping or new named DUT |

Unblock template (Cursor writes `drafts/UNBLOCK_<UTC>.md`):

```text
SYMPTOM:
BLOCKING UNKNOWN (one):
SMALLEST NEXT BAG:
KEEP FILES UNTOUCHED:
DEEPSEEK MAY:
DEEPSEEK MUST NOT:
CURSOR WILL DO NOW:
```

Then Cursor executes that bag. DeepSeek resumes only on the next unknown.

## Cursor model picker

This API does **not** replace Cursor Grok in settings.json (that would break built-in models).
To also use DeepSeek inside Cursor Chat: Cursor Settings → Models → OpenAI Compatible →
base `https://api.deepseek.com/v1` → models `deepseek-v4-pro` (suy luận) and `deepseek-v4-flash` (RTL) → paste key from the secrets file (not from chat).

## Rotate

The key was pasted in chat. After confirm `python scripts\deepseek_consult.py --ping` works, rotate at DeepSeek platform and update **only** `C:\Users\phant\.cursor\secrets\deepseek.env` + user env.
