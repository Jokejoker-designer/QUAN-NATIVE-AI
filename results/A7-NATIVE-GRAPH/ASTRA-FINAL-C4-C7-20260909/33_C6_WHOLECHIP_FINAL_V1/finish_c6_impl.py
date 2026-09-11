#!/usr/bin/env python3
"""Finish C6 wholechip_final_v1 impl. Never stamps MASTER or freeze_allowed."""
from __future__ import annotations

import json
from datetime import datetime, timedelta, timezone
from pathlib import Path

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[3]
TZ7 = timezone(timedelta(hours=7))


def sha256_file(p: Path) -> str | None:
    if not p.is_file():
        return None
    import hashlib

    return hashlib.sha256(p.read_bytes()).hexdigest()


def parse_letters(p: Path) -> dict:
    out: dict[str, str] = {}
    if not p.is_file():
        return out
    text = p.read_text(encoding="utf-8", errors="replace")
    if "STALE_NOT_THIS_RUN" in text.splitlines()[:3]:
        return {"STALE": "1"}
    for line in text.splitlines():
        if "=" in line:
            k, v = line.split("=", 1)
            out[k.strip()] = v.strip()
    return out


def dest_family(name: str) -> str:
    n = name.lower()
    if "u_sgd/w_reg" in n:
        return "c3_sgd_w"
    if "pend_phi_reg" in n:
        return "c3_pend_phi"
    if "elut_reg" in n or "/elut[" in n:
        return "smres"
    if "rq_" in n:
        return "rq_snap"
    if "u_c4" in n or "d32" in n or "lm06" in n:
        return "d32"
    return "other"


def classify_n20(p: Path) -> dict:
    dests: list[str] = []
    if not p.is_file():
        return {"n_dest": 0, "auto_start_next_pipe": False, "missing": True}
    text = p.read_text(encoding="utf-8", errors="replace")
    if text.startswith("STALE_NOT_THIS_RUN"):
        return {"n_dest": 0, "auto_start_next_pipe": False, "stale": True}
    for line in p.read_text(encoding="utf-8", errors="replace").splitlines():
        s = line.strip()
        if s.startswith("Destination:"):
            dests.append(s.split(":", 1)[1].strip().split()[0])
    counts: dict[str, int] = {}
    for d in dests:
        fam = dest_family(d)
        counts[fam] = counts.get(fam, 0) + 1
    n = len(dests)
    wreg = counts.get("c3_sgd_w", 0)
    if n == 0:
        case = "NO_DEST"
    elif wreg == n:
        case = "A_OR_B_STILL_C3_SGD_W"
    elif wreg == 0:
        case = "NEW_FAMILY"
    else:
        case = "MIXED"
    top = max(counts, key=counts.get) if counts else None
    return {
        "n_dest": n,
        "family_counts": counts,
        "top_family": top,
        "case_vs_prior_c3_sgd_w": case,
        "auto_start_next_pipe": False,
        "E3AB": "DO_NOT_START",
        "dests_head": dests[:8],
        "n20_sha256": sha256_file(p),
    }


def finish() -> int:
    now = datetime.now(TZ7).strftime("%Y-%m-%dT%H:%M:%S+07:00")
    letters = parse_letters(BAG / "ROUTE_LETTERS.txt")
    stale = letters.get("STALE") == "1"
    if stale:
        letters = {}
    n20 = classify_n20(BAG / "timing_n20_route.rpt")
    (BAG / "C6_N20_FAMILY.json").write_text(json.dumps(n20, indent=2) + "\n", encoding="utf-8")
    bit = BAG / "a7ng_astra_c6_wholechip_final_v1.bit"
    bit_sha = sha256_file(bit)
    fit = (not stale) and letters.get("FIT_OK") == "1"
    log = BAG / "vivado.log"
    route_pass = False
    if log.is_file():
        for line in log.read_text(encoding="utf-8", errors="replace").splitlines():
            if line.startswith("ASTRA_C6_WHOLECHIP_FINAL_V1_ROUTE_PASS"):
                route_pass = True
                break
    payload = {
        "PROGRAM": "NO",
        "C4_MASTER": "OPEN",
        "C5_MASTER": "OPEN",
        "C6_MASTER": "OPEN",
        "ASTRA_NATIVE_AI_BOARD_PASS": "NOT_EVIDENCED",
        "freeze_allowed": False,
        "top": "a7ng_astra_c6_wholechip_final_v1",
        "letters": letters,
        "fit_ok": fit,
        "stale_letters_ignored": stale,
        "n20": n20,
        "route_pass_marker": route_pass,
        "bit_exists": bit.is_file(),
        "bit_sha256": bit_sha,
        "note": "Routed letters are not a freeze. TIMING_OR_FIT miss is not a bit. Do not program. Do not auto-start next pipe.",
        "updated": now,
    }
    (BAG / "C6_IMPL_RESULT.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    try:
        from collect_c6_source_manifest import collect as collect_manifest

        collect_manifest()
    except Exception as exc:  # noqa: BLE001 — finish must still emit letters
        print("C6F_MANIFEST_DRAFT_FAIL", type(exc).__name__, exc)
    live_p = ROOT / "results/A7-NATIVE-GRAPH/STATUS/ASTRA_C4_C7_LIVE.json"
    if live_p.is_file():
        live = json.loads(live_p.read_text(encoding="utf-8"))
        live.update(
            {
                "PROGRAM": "NO",
                "C6_MASTER": "OPEN",
                "ASTRA_NATIVE_AI_BOARD_PASS": "NOT_EVIDENCED",
                "G14": "BLOCKED_PRE_BOARD",
                "c6_final_v1_impl": (
                    "POSTROUTE_SETUP_MISS"
                    if letters and letters.get("FIT_OK") == "0"
                    else ("DONE" if letters and not stale else "INCOMPLETE")
                ),
                "c6_final_v1_wns": letters.get("WNS"),
                "c6_final_v1_tns": letters.get("TNS"),
                "c6_final_v1_whs": letters.get("WHS"),
                "c6_final_v1_ths": letters.get("THS"),
                "c6_final_v1_fit_ok": fit,
                "c6_final_v1_bit_sha256": bit_sha,
                "c6_final_v1_n20_family": n20.get("top_family"),
                "c6_final_v1_n20_case": n20.get("case_vs_prior_c3_sgd_w"),
                "c6_final_v1_auto_next_pipe": False,
                "e3ab": "DO_NOT_START",
                "updated": now,
            }
        )
        live_p.write_text(json.dumps(live, indent=2) + "\n", encoding="utf-8")
    print(
        "C6F_PARSED PROGRAM=NO",
        "fit",
        fit,
        "wns",
        letters.get("WNS"),
        "tns",
        letters.get("TNS"),
        "bit",
        bool(bit_sha),
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(finish())
