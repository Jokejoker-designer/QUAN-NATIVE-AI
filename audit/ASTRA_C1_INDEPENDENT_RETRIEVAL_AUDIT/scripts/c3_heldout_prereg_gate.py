#!/usr/bin/env python3
"""Independent C3 held-out prereg gate.

C3 is OPEN. This gate must stay red until a real held-out bag exists that
cannot be closed by A09R8 w0 0→-5 or ASTRA-07 historical transfer.

Read-only on the live clone. Writes JSON only under this tree.

Run:
  python scripts/c3_heldout_prereg_gate.py
"""
from __future__ import annotations

import json
import re
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GROK = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH")
BAGS = GROK / "results" / "A7-NATIVE-GRAPH"
OUT = ROOT / "results" / "c3_heldout_prereg_gate.json"


def read_text(path: Path, limit: int = 2_000_000) -> str:
    if not path.is_file():
        return ""
    return path.read_bytes()[:limit].decode("utf-8", errors="replace")


def finding(fid: str, ok: bool, blocking: bool, detail: str) -> dict:
    return {
        "id": fid,
        "ok": ok,
        "blocking_for_c3_close": blocking,
        "detail": detail,
        "verdict": "PASS" if ok else "FAIL",
    }


def main() -> int:
    findings: list[dict] = []
    bag = BAGS / "ASTRA-C3-HELD-OUT-01"
    xsim = read_text(bag / "xsim.log")
    results = read_text(bag / "RESULTS.md")
    findings.append(
        finding(
            "C3_BAG_EXISTS",
            bag.is_dir() and bool(xsim),
            True,
            "ASTRA-C3-HELD-OUT-01 xsim.log missing (C3 not started)"
            if not (bag.is_dir() and xsim)
            else "C3 bag xsim.log present",
        )
    )

    a09 = read_text(BAGS / "ASTRA-11-A09R8-SILICON-UART-01" / "LADDER.txt")
    if not a09:
        a09 = read_text(
            GROK / "docs/ASTRA/authority/CURRENT_EVIDENCE_LEDGER.md"
        )
    w0_reachability = "w0=-5" in a09 or "w0 0→-5" in a09 or "w0 0 -> -5" in a09
    findings.append(
        finding(
            "A09R8_W0_MUST_NOT_CLOSE_C3",
            True,
            False,
            "FACT: A09R8 w0 0→-5 is SGD reachability (Master §9). Using it as C3 transfer is OVERCLAIM.",
        )
    )

    hist = BAGS / "ASTRA-07-HELD-OUT-TRANSFER"
    findings.append(
        finding(
            "ASTRA07_IS_NOT_C3",
            True,
            False,
            f"Historical {hist.name if hist.is_dir() else 'ASTRA-07'} cannot close Master §9 (not frozen C1 law, not 5-seed 4-arm, not production persist reload).",
        )
    )

    required_in_future_log = [
        "CLASS_arm_A_learner",
        "CLASS_arm_B_frozen",
        "CLASS_arm_C_shuffled",
        "CLASS_arm_D_perid",
        "CLASS_entities_disjoint",
        "CLASS_host_winner_zero",
        "CLASS_gain_A_over_B",
    ]
    for name in required_in_future_log:
        findings.append(
            finding(
                "NEED_" + name,
                name in xsim,
                True,
                f"{name} not in C3 xsim.log (required Master §9)",
            )
        )

    overclaim = bool(re.search(r"C3_.*CLOSED|BOARD_PASS\s*=\s*YES", results, re.I))
    findings.append(
        finding(
            "NO_SELF_CLOSE",
            not overclaim,
            True,
            "C3 RESULTS must not self-stamp Master/BOARD close",
        )
    )

    loop = json.loads((GROK / "docs/ASTRA/LOOP_STATE.json").read_text(encoding="utf-8"))
    findings.append(
        finding(
            "LOOP_C3_STILL_OPEN",
            loop.get("c_gate") == "C3_HELD_OUT" or "C3" in str(loop.get("unblocked_item")),
            False,
            f"unblocked_item={loop.get('unblocked_item')} c_gate={loop.get('c_gate')}",
        )
    )

    blocking_fail = [f["id"] for f in findings if f["blocking_for_c3_close"] and not f["ok"]]
    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "classification": "FACT: C3 is OPEN. A09R8 w0 and ASTRA-07 are not C3. This gate stays red until a 5-seed 4-arm disjoint held-out bag HITs Master §9 letter.",
        "c3_close": "NO",
        "board_pass": "REJECT",
        "a09r8_w0_is_c3": False,
        "blocking_fail_ids": blocking_fail,
        "master_section": 9,
        "required_arms": ["A_shared_32_feature", "B_frozen", "C_shuffled_reward", "D_perid_prior"],
        "required_metrics": [
            "gain(A over B) >= 10 pp",
            "paired CI lower bound > 0",
            "A > shuffled",
            "A > or complements per-ID",
            "retention drop after reload <= 5 pp (may be later bag)",
            "host winner/address/weight update = 0",
        ],
        "findings": findings,
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print("C3_CLOSE=NO BOARD_PASS=REJECT a09r8_w0_is_c3=false")
    print(f"blocking={blocking_fail}")
    print(f"wrote {OUT}")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
