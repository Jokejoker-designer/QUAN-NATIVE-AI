#!/usr/bin/env python3
"""Call DeepSeek for Astra drafts. Key from env or user secrets file — never from git.

  python scripts/deepseek_consult.py --ping
  python scripts/deepseek_consult.py --role reasoner --in prompts/current.md --out drafts
  python scripts/deepseek_consult.py --role rtl --in prompts/current.md --out drafts
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import urllib.error
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SECRETS = Path.home() / ".cursor" / "secrets" / "deepseek.env"
BASE = "https://api.deepseek.com"
MODELS = {
    "reasoner": "deepseek-v4-pro",
    "checker": "deepseek-v4-pro",
    "rtl": "deepseek-v4-flash",
    "chat": "deepseek-v4-flash",
    "pro": "deepseek-v4-pro",
    "flash": "deepseek-v4-flash",
}

# User correction 2026-09-08: checker/reasoner is deepseek-v4-pro.
# Live GET /models has no v4.1 id. Do not request deepseek-v4.1.
assert "v4.1" not in "".join(MODELS.values())


def _stdio_utf8() -> None:
    for stream in (sys.stdout, sys.stderr):
        reconf = getattr(stream, "reconfigure", None)
        if reconf is not None:
            try:
                reconf(encoding="utf-8", errors="replace")
            except (OSError, ValueError):
                pass


_stdio_utf8()

SYSTEM_REASONER = """You are DeepSeek-reasoner on Astra Native AI (Arty A7-100T).
Authority: Master V1.1 POST_SILICON C0-C7. Live C1/C2 are CLOSED_XSIM only; C3-C7 OPEN.
Do not stamp BOARD_PASS. Do not edit KEEP C0/C1/C2 hashes. Do not freeze
DDR_QUERY_BOUND_FINAL or PERSIST_SCHEMA_VERSION. One unknown per bag.
Classify FACT/INFERENCE/HYPOTHESIS/UNKNOWN. Output a WORK_ORDER or analysis, not live RTL."""

SYSTEM_RTL = """You are DeepSeek-chat writing Astra SystemVerilog drafts.
Output only a new named module/TB for one unknown. Instantiate KEEP; do not edit KEEP.
No low8/low16 canonical identity. PROGRAM=NO. Gold hashed before xvlog; never regenerate gold.
Do not compile leftover A09, STREAM-02, prior_store, synth mig_7series_0_mig.v as DUT.
MIG xelab must be -mt off -O0. Journal AWADDR base 0x06000000.
Mark files as DRAFT — Cursor copies to the live clone only after independent accept."""

SYSTEM_CHECKER = """You are DeepSeek-v4-pro, independent 验收 after each Astra assignment.
Live C1/C2 are CLOSED_XSIM only. Goal is C3-C6 Master letter PASS with RAW evidence.
You do NOT implement. You hunt tautology, KEEP edits, overclaim, mixed unknowns.
REJECT if CLASS_* are TB-fed scorecards (acc_a_pp in, HIT out) rather than measured
on parser→retrieval→32-feature learner vs frozen/shuffled/per-ID.
REJECT if BOARD_PASS, GOLDEN regen, KEEP/C0 patch, low16 identity, A09R8 as C3/C5/C6.
REJECT if KEEP names are invented (parser_keep.sv, retrieval_keep.sv, learner_keep.sv).
Real KEEP is KEEP_HASHES.json: C1 synonym a7ng_query_role_relctx_synonym.sv +
a7ng_query_axi_sparse_intersect_synonym.sv; learner a7ng_shared_rank_sgd_q8_sym_f2r2.sv;
C2 persist a7ng_astra_c2_persist_*.sv. Instantiate, do not edit.
ACCEPT means the draft is safe to copy into a NEW named bag for XSim — not Master close.
Always end with exactly these lines:
VERDICT=ACCEPT
or
VERDICT=REJECT
TAUTOLOGY=YES|NO
KEEP_SAFE=YES|NO
MASTER_CLOSE=NO
NEXT_UNKNOWN=<one sentence>
"""


def load_key() -> str:
    key = os.environ.get("DEEPSEEK_API_KEY", "").strip()
    if key:
        return key
    if SECRETS.is_file():
        for line in SECRETS.read_text(encoding="utf-8").splitlines():
            if line.startswith("DEEPSEEK_API_KEY="):
                return line.split("=", 1)[1].strip()
    raise SystemExit("DEEPSEEK_API_KEY missing. Set env or C:\\Users\\phant\\.cursor\\secrets\\deepseek.env")


def api(path: str, payload: dict | None = None) -> dict:
    key = load_key()
    data = None if payload is None else json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        BASE + path,
        data=data,
        headers={
            "Authorization": "Bearer " + key,
            "Content-Type": "application/json",
        },
        method="GET" if payload is None else "POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=360) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", errors="replace")[:800]
        raise SystemExit(f"DeepSeek HTTP {e.code}: {body}") from e


def ping() -> int:
    body = api("/models")
    ids = [m.get("id") for m in body.get("data", [])]
    print("DEEPSEEK_PING=OK models=" + ",".join(ids[:12]))
    return 0


def consult(role: str, src: Path, out_dir: Path) -> int:
    text = src.read_text(encoding="utf-8")
    model = MODELS[role]
    if role == "checker":
        system = SYSTEM_CHECKER
        temp = 0.0
    elif role in ("reasoner", "pro"):
        system = SYSTEM_REASONER
        temp = 0.2
    else:
        system = SYSTEM_RTL
        temp = 0.0
    body = api(
        "/chat/completions",
        {
            "model": model,
            "messages": [
                {"role": "system", "content": system},
                {"role": "user", "content": text},
            ],
            "temperature": temp,
        },
    )
    content = body["choices"][0]["message"]["content"]
    out_dir.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%MZ")
    dest = out_dir / f"{stamp}_{role}_{src.stem}.md"
    dest.write_text(content, encoding="utf-8")
    usage = body.get("usage", {})
    print(f"DEEPSEEK_DRAFT={dest} model={model} tokens={usage}")
    if role == "checker":
        verdict = "UNKNOWN"
        for line in content.strip().splitlines()[::-1]:
            if line.startswith("VERDICT="):
                verdict = line.split("=", 1)[1].strip()
                break
        print(f"CHECKER_VERDICT={verdict} CHECKER_MODEL=deepseek-v4-pro")
    else:
        print("ACCEPT=PENDING_CHECKER  checker_model=deepseek-v4-pro next")
    return 0


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--ping", action="store_true")
    p.add_argument("--role", choices=sorted(MODELS), default="reasoner")
    p.add_argument("--in", dest="infile", type=Path)
    p.add_argument("--out", dest="outdir", type=Path, default=ROOT / "drafts")
    args = p.parse_args()
    if args.ping:
        return ping()
    if not args.infile:
        print("need --in prompt.md or --ping", file=sys.stderr)
        return 2
    return consult(args.role, args.infile, args.outdir)


if __name__ == "__main__":
    raise SystemExit(main())
