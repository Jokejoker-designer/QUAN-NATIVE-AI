#!/usr/bin/env python3
"""Draft C6 source hasher. Never sets freeze_allowed true. PROGRAM=NO."""
from __future__ import annotations

import hashlib
import json
import re
import subprocess
from datetime import datetime, timedelta, timezone
from pathlib import Path

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[3]
FINAL_BAG = BAG.parent
TZ7 = timezone(timedelta(hours=7))


def sha256_file(p: Path) -> str | None:
    if not p.is_file():
        return None
    return hashlib.sha256(p.read_bytes()).hexdigest()


def rel(p: Path) -> str:
    try:
        return p.resolve().relative_to(ROOT).as_posix()
    except ValueError:
        return str(p.resolve())


def parse_rtl_from_tcl(tcl: Path) -> list[Path]:
    lines = tcl.read_text(encoding="utf-8", errors="replace").splitlines()
    out: list[Path] = []
    in_rtl = False
    for line in lines:
        if line.startswith("set rtl [list"):
            in_rtl = True
            continue
        if in_rtl:
            if line.strip() == "]":
                break
            m = re.search(r"file join \$root (\S+)\]", line)
            if m:
                out.append(ROOT / m.group(1).replace("\\", "/"))
    return out


def git_state() -> dict:
    def run(args: list[str]) -> str:
        r = subprocess.run(
            args,
            cwd=str(ROOT),
            capture_output=True,
            text=True,
            check=False,
        )
        return (r.stdout or "").strip()

    head = run(["git", "rev-parse", "HEAD"])
    porcelain = run(["git", "status", "--porcelain"])
    n = len([ln for ln in porcelain.splitlines() if ln.strip()])
    return {
        "commit": head,
        "dirty_count": n,
        "git_clean": n == 0,
    }


def collect() -> dict:
    now = datetime.now(TZ7).strftime("%Y-%m-%dT%H:%M:%S+07:00")
    tcl = BAG / "run_impl.tcl"
    files: list[Path] = []
    files.extend(parse_rtl_from_tcl(tcl))
    files.extend(
        [
            ROOT / "constraints/arty_a7_100.xdc",
            ROOT / "constraints/a7ng03_cdc.xdc",
            BAG / "c6_wholechip.xdc",
            tcl,
            BAG / "run_impl.ps1",
            BAG / "finish_c6_impl.py",
            BAG / "collect_c6_source_manifest.py",
            ROOT / "vivado/ip/mig_7series_0/mig_7series_0.xci",
            ROOT / "vivado/ip/mig_7series_0/mig_7series_0/mig.prj",
            FINAL_BAG / "C7_BOARD_EXAM_V1.json",
            FINAL_BAG / "C7_BOARD_EXAM_V1.md",
            FINAL_BAG / "c7_board_exam_run.py",
        ]
    )
    hexdir = ROOT / "rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v2_mem"
    if hexdir.is_dir():
        files.extend(sorted(hexdir.glob("*.hex")))
    hashes: dict[str, str | None] = {}
    missing: list[str] = []
    for p in files:
        key = rel(p)
        h = sha256_file(p)
        hashes[key] = h
        if h is None:
            missing.append(key)
    git = git_state()
    bit = BAG / "a7ng_astra_c6_wholechip_final_v1.bit"
    letters_p = BAG / "ROUTE_LETTERS.txt"
    letters: dict[str, str] = {}
    if letters_p.is_file():
        for line in letters_p.read_text(encoding="utf-8", errors="replace").splitlines():
            if "=" in line:
                k, v = line.split("=", 1)
                letters[k.strip()] = v.strip()
    payload = {
        "schema": "FINAL_SOURCE_MANIFEST_V1",
        "freeze_status": "DRAFT_NOT_FROZEN",
        "freeze_allowed": False,
        "PROGRAM": "NO",
        "C4_MASTER": "OPEN",
        "C5_MASTER": "OPEN",
        "C6_MASTER": "OPEN",
        "ASTRA_NATIVE_AI_BOARD_PASS": "NOT_EVIDENCED",
        "wo": "§18 draft hasher only; git dirty or missing letters keeps freeze false",
        "part": "xc7a100tcsg324-1",
        "top": "a7ng_astra_c6_wholechip_final_v1",
        "vivado": {"version": "2026.1", "sw_build": "6511674"},
        "git": git,
        "files": hashes,
        "missing": missing,
        "bitstream": {
            "exists": bit.is_file(),
            "sha256": sha256_file(bit),
        },
        "route_letters": letters,
        "dictionary_image_sha256": None,
        "alias_wr": "tied 0",
        "bank_r_i": "tied 0",
        "updated": now,
    }
    out = BAG / "FINAL_SOURCE_MANIFEST.json"
    out.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    freeze_p = FINAL_BAG / "C6_FREEZE_PRECHECK.json"
    freeze = {}
    if freeze_p.is_file():
        freeze = json.loads(freeze_p.read_text(encoding="utf-8"))
    pins = freeze.get("required_pins") or {}
    pins.update(
        {
            "git_clean": git["git_clean"],
            "source_commit": f"{git['commit'][:12]} dirty {git['dirty_count']}",
            "c6_source": hashes.get("rtl/native_graph/integrate/a7ng_astra_c6_wholechip_final_v1.sv"),
            "dictionary_image_sha": None,
            "mig_prj_untouched": "hashed; do not hand-edit",
            "wns_ge_0": False,
            "learned_and_safe_reachable": False,
        }
    )
    freeze.update(
        {
            "schema": "C6_FREEZE_PRECHECK_V1",
            "wo": "§18–19 then §21",
            "PROGRAM": "NO",
            "C6_MASTER": "OPEN",
            "freeze_allowed": False,
            "required_pins": pins,
            "bitstream": payload["bitstream"],
            "draft_manifest": str(out.relative_to(ROOT)).replace("\\", "/"),
            "updated": now,
        }
    )
    if not git["git_clean"]:
        freeze["reason"] = (
            "C4/C5 acceptance OPEN; git not clean; no unique frozen bit; "
            "post-route C6 letters missing or not a freeze; alias_wr=0; E1c dict OPEN; PROGRAM=NO"
        )
    freeze_p.write_text(json.dumps(freeze, indent=2) + "\n", encoding="utf-8")
    print("C6F_MANIFEST_DRAFT PROGRAM=NO freeze_allowed=false files", len(hashes), "missing", len(missing), "dirty", git["dirty_count"])
    return payload


if __name__ == "__main__":
    collect()
