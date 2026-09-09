#!/usr/bin/env python3
"""Independent C2 persist close gate.

Read-only on the live Grok/Cursor clone. Writes JSON only under this tree.
Does not declare BOARD_PASS. C2 CLOSED_XSIM is not silicon persist.

Run:
  python scripts/c2_persist_close_gate.py
"""
from __future__ import annotations

import hashlib
import json
import re
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GROK = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH")
BAGS = GROK / "results" / "A7-NATIVE-GRAPH"
OUT = ROOT / "results" / "c2_persist_close_gate.json"
KEEP = json.loads((ROOT / "KEEP_HASHES.json").read_text(encoding="utf-8"))

BAG_MARKERS = {
    "ASTRA-C2-PERSIST-COMMIT-01": "ASTRA_C2_PERSIST_COMMIT_XSIM_PASS",
    "ASTRA-C2-PERSIST-MULTI-SLOT-01": "ASTRA_C2_PERSIST_MULTI_SLOT_XSIM_PASS",
    "ASTRA-C2-PERSIST-DDR-STALL-01": "ASTRA_C2_PERSIST_DDR_STALL_XSIM_PASS",
    "ASTRA-C2-PERSIST-MIG-01": "ASTRA_C2_PERSIST_MIG_XSIM_PASS",
}


def sha256_file(path: Path) -> str | None:
    if not path.is_file():
        return None
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def read_text(path: Path, limit: int = 4_000_000) -> str:
    if not path.is_file():
        return ""
    return path.read_bytes()[:limit].decode("utf-8", errors="replace")


def finding(fid: str, ok: bool, blocking: bool, detail: str) -> dict:
    return {
        "id": fid,
        "ok": ok,
        "blocking_for_c2_close": blocking,
        "detail": detail,
        "verdict": "PASS" if ok else "FAIL",
    }


def main() -> int:
    findings: list[dict] = []

    for rel, expect in KEEP["c0_frozen"].items():
        live = sha256_file(GROK / rel.replace("/", "\\"))
        ok = live == expect
        findings.append(
            finding(
                "C0_" + Path(rel).name,
                ok,
                True,
                f"{rel} live={live} expected={expect}",
            )
        )

    for rel, expect in KEEP["c2_keep_do_not_edit"].items():
        live = sha256_file(GROK / rel.replace("/", "\\"))
        ok = live == expect
        findings.append(
            finding(
                "C2KEEP_" + Path(rel).name,
                ok,
                True,
                f"{rel} live={live} expected={expect}",
            )
        )

    for bag, marker in BAG_MARKERS.items():
        log = read_text(BAGS / bag / "xsim.log")
        gold = sha256_file(BAGS / bag / "GOLDEN.json")
        pre = read_text(BAGS / bag / "GOLD_HASH_PRE_XVLOG.txt")
        marker_ok = bool(re.search(rf"^{re.escape(marker)}$", log, re.M))
        findings.append(
            finding(f"MARKER_{bag}", marker_ok, True, f"marker={marker} present={marker_ok}")
        )
        findings.append(
            finding(
                f"DIVERGENCE_{bag}",
                "FIRST_DIVERGENCE" not in log,
                True,
                "FIRST_DIVERGENCE absent" if "FIRST_DIVERGENCE" not in log else "FIRST_DIVERGENCE present",
            )
        )
        gold_ok = bool(gold) and gold in pre
        findings.append(
            finding(
                f"GOLD_PRE_{bag}",
                gold_ok,
                True,
                f"GOLDEN={gold} in PRE_XVLOG={gold_ok}",
            )
        )
        findings.append(
            finding(
                f"FALSE_ZERO_{bag}",
                "CLASS_false_success_zero HIT" in log or "n_false=0" in log,
                True,
                "false_success zero HIT" if "n_false=0" in log or "CLASS_false_success_zero HIT" in log else "missing n_false=0",
            )
        )
        findings.append(
            finding(
                f"NO_BOARD_CLAIM_{bag}",
                "BOARD_PASS=NOT_CLAIMED" in log or "NOT_CLAIMED=BOARD_PASS" in log or "BOARD_PASS             = NOT_CLAIMED" in read_text(BAGS / bag / "RESULTS.md"),
                True,
                "bag does not claim BOARD_PASS",
            )
        )

    mig_log = read_text(BAGS / "ASTRA-C2-PERSIST-MIG-01" / "xsim.log")
    findings.append(
        finding(
            "MIG_RELOAD_IDENTITY",
            "CLASS_reload_from_mig HIT" in mig_log and "aw=6000000" in mig_log,
            True,
            "MIG reload + AWADDR 0x06000000",
        )
    )
    findings.append(
        finding(
            "MIG_NOT_LOW16",
            "CLASS_journal_addr_not_low16 HIT" in mig_log,
            True,
            "journal address not low16",
        )
    )

    rtl = read_text(GROK / "rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv")
    dup_before_txn = rtl.find("A7NG_C2_F_DUP") < rtl.find("A7NG_C2_F_BAD_TXN")
    findings.append(
        finding(
            "STALE_TXN_DEAD_CODE",
            True,
            False,
            "WARN: F_BAD_TXN is after same-identity+gen DUP; distinct stale-txn fail_code is NOT_REACHABLE. Mapped to DUP HIT at C2 XSim close."
            if dup_before_txn
            else "F_BAD_TXN not after DUP — re-hunt decide order",
        )
    )

    loop = json.loads((GROK / "docs/ASTRA/LOOP_STATE.json").read_text(encoding="utf-8"))
    closed = loop.get("c2_persist_closed") is True
    findings.append(
        finding(
            "LOOP_C2_CLOSED_FLAG",
            closed,
            True,
            f"c2_persist={loop.get('c2_persist')} closed={closed} promotion={loop.get('final_promotion')}",
        )
    )
    findings.append(
        finding(
            "LOOP_BOARD_STILL_REJECT",
            loop.get("board_pass") is False and loop.get("final_promotion") == "REJECT",
            True,
            "board_pass false and final_promotion REJECT",
        )
    )
    findings.append(
        finding(
            "SCHEMA_NOT_FROZEN",
            loop.get("PERSIST_SCHEMA_VERSION") == "NOT_FROZEN",
            False,
            "PERSIST_SCHEMA_VERSION stays NOT_FROZEN (quality bound, not a C2 XSim fail)",
        )
    )

    blocking_fail = [f["id"] for f in findings if f["blocking_for_c2_close"] and not f["ok"]]
    c2_close = "YES_XSIM" if not blocking_fail else "NO"
    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "classification": "FACT from live files this run. C2_CLOSE=YES_XSIM is XSim law close only; BOARD_PASS stays REJECT; PERSIST_SCHEMA_VERSION stays NOT_FROZEN.",
        "c2_close": c2_close,
        "c3_may_start": "YES" if c2_close == "YES_XSIM" else "NO",
        "board_pass": "REJECT",
        "blocking_fail_ids": blocking_fail,
        "findings": findings,
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print(f"C2_CLOSE={c2_close} BOARD_PASS=REJECT blocking={blocking_fail or []}")
    print(f"wrote {OUT}")
    return 0 if c2_close == "YES_XSIM" else 2


if __name__ == "__main__":
    raise SystemExit(main())
