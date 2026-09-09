#!/usr/bin/env python3
"""E0 collector. Read-only hashes/inventory. Does not rerun XSim/eval inference."""
from __future__ import annotations

import collections
import hashlib
import json
import os
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(r"D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH")
BAG = ROOT / "results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909"
OUT = BAG / "24_C4_C5_ACCEPTANCE_RECONCILE"


def sha256_file(p: Path) -> str:
    h = hashlib.sha256()
    with p.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def mtime_iso(p: Path) -> str:
    ts = p.stat().st_mtime
    return datetime.fromtimestamp(ts).isoformat(timespec="seconds")


def load_json(p: Path):
    return json.loads(p.read_text(encoding="utf-8"))


def main() -> None:
    files = {
        "d32_v2_sv": ROOT / "rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v2.sv",
        "c5_final_sv": ROOT / "rtl/native_graph/integrate/a7ng_astra_c5_prod_top_final_v1.sv",
        "c6_final_sv": ROOT / "rtl/native_graph/integrate/a7ng_astra_c6_wholechip_final_v1.sv",
        "extract_sv": ROOT / "rtl/native_graph/query/a7ng_query_role_extract.sv",
        "wrap_v2_sv": ROOT / "rtl/native_graph/integrate/a7ng_astra_c4_prod_wrap_v2.sv",
        "ooc_timing": BAG / "14_C4_OOC_V2/timing_ooc.rpt",
        "ooc_util": BAG / "14_C4_OOC_V2/util_ooc.rpt",
        "confirm_v2": BAG / "11_C4_BLIND_CONFIRM_V3/confirm_v3.json",
        "eval_v2": BAG / "11_C4_BLIND_CONFIRM_V3/eval_once.json",
        "lock_v2": BAG / "11_C4_BLIND_CONFIRM_V3/CONFIRM_V3_LOCK.json",
        "confirm_v1": BAG / "11_C4_BLIND_CONFIRM/confirm_wo360_v3.json",
        "eval_v1": BAG / "11_C4_BLIND_CONFIRM/eval_wo360_v3_once.py",
        "prereg_causal": BAG / "17_C4_CAUSAL_V2/PREREG.json",
        "g03_causal": BAG / "17_C4_CAUSAL_V2/g03_causal_v2.json",
        "prefix_diag": BAG / "17_C4_CAUSAL_V2/PREFIX_LOGIT_DIAG.json",
        "xsim_21": BAG / "21_C5_UART_SMOKE_V1/xsim.log",
        "xsim_22": BAG / "22_C5_AXI_ERR_V1/xsim.log",
        "xsim_23": BAG / "23_C5_REGRESS_V1/xsim.log",
        "xsim_24_refuse": BAG / "24_C5_REFUSE_FIFO_V1/xsim_refuse.log",
        "xsim_24_baud": BAG / "24_C5_REFUSE_FIFO_V1/xsim_baud.log",
        "diff_xsim": BAG / "13_C4_DIFFERENTIAL_V3/xsim.log",
        "context_v2": ROOT / "rtl/native_graph/integrate/a7ng_astra_c4_context_v2.svh",
        "entity_alias_md": BAG / "19_C4_SURFACE_WRAP_V2/ENTITY_ALIAS_V1.md",
        "c3_id_md": BAG / "19_C4_SURFACE_WRAP_V2/C3_ID_PROOF_IDENTITY.md",
        "eval_v1_py_live": ROOT / "results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/11_C4_BLIND_CONFIRM/eval_wo360_v3_once.py",
        "lock_eval_rescue": Path(r"D:/FPGA/C4_RESCUE_20260909/lock_eval_confirm_v3.py"),
    }
    hashes = {}
    for k, p in files.items():
        if p.exists():
            hashes[k] = {
                "path": str(p).replace("\\", "/"),
                "exists": True,
                "sha256": sha256_file(p),
                "mtime": mtime_iso(p),
                "bytes": p.stat().st_size,
            }
        else:
            hashes[k] = {"path": str(p).replace("\\", "/"), "exists": False}

    hex_dir = ROOT / "rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v2_mem"
    hexes = []
    if hex_dir.is_dir():
        for p in sorted(hex_dir.glob("*.hex")):
            hexes.append({"name": p.name, "sha256": sha256_file(p), "bytes": p.stat().st_size})

    v2 = load_json(files["confirm_v2"])
    v2_rows = v2["rows"]
    v2_groups = dict(collections.Counter(r.get("group") for r in v2_rows))
    u_rows = [r for r in v2_rows if r.get("group") == "U"]
    u_kinds = dict(collections.Counter(r.get("kind") for r in u_rows))
    u_keys = sorted(set().union(*(set(r.keys()) for r in u_rows))) if u_rows else []
    v2_ctx_sample = next((r.get("ctx") for r in v2_rows if r.get("group") == "F"), None)

    v1_info = {"exists": files["confirm_v1"].exists()}
    if files["confirm_v1"].exists():
        v1 = load_json(files["confirm_v1"])
        v1_rows = v1["rows"]
        v1_info.update(
            {
                "n": len(v1_rows),
                "groups": dict(collections.Counter(r.get("group") for r in v1_rows)),
                "u_kinds": dict(collections.Counter(r.get("kind") for r in v1_rows if r.get("group") == "U")),
                "sha256_canonical": v1.get("sha256_canonical"),
                "checkpoint_sha256": v1.get("checkpoint_sha256"),
                "layout": v1.get("layout"),
            }
        )

    ev = load_json(files["eval_v2"])
    g03 = load_json(files["g03_causal"]) if files["g03_causal"].exists() else None
    prefix = load_json(files["prefix_diag"]) if files["prefix_diag"].exists() else None

    payload = {
        "collected_at": datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds"),
        "hashes": hashes,
        "hex_v2": hexes,
        "confirm_v2": {
            "n_rows": len(v2_rows),
            "groups": v2_groups,
            "u_kind_field_present_count": sum(1 for r in u_rows if "kind" in r),
            "u_kinds": u_kinds,
            "u_keys": u_keys,
            "sha256_canonical": v2.get("sha256_canonical"),
            "checkpoint_sha256": v2.get("checkpoint_sha256"),
            "layout": v2.get("layout"),
            "f_ctx_sample": v2_ctx_sample,
        },
        "confirm_v1": v1_info,
        "eval_v2_once": {
            "learned_supported": ev.get("learned_supported"),
            "system_unsupported": ev.get("system_unsupported"),
            "pass_system_safe": ev.get("pass_system_safe"),
            "pass_c4_numerical_wo": ev.get("pass_c4_numerical_wo"),
            "pass_learned_fr": ev.get("pass_learned_fr"),
            "n": ev.get("n"),
            "float_int_seq_eq": ev.get("float_int_seq_eq"),
            "confirm_sha256": ev.get("confirm_sha256"),
            "checkpoint_sha256": ev.get("checkpoint_sha256"),
        },
        "causal": {"g03": g03, "prefix": prefix},
    }
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / "COLLECTED.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print("WROTE", OUT / "COLLECTED.json")
    print("V2 groups", v2_groups, "U kinds", u_kinds)
    print("hex n", len(hexes))
    print("C5 sha", hashes["c5_final_sv"].get("sha256"))
    print("C5 mtime", hashes["c5_final_sv"].get("mtime"))
    print("22 mtime", hashes["xsim_22"].get("mtime"))
    print("21 mtime", hashes["xsim_21"].get("mtime"))
    print("23 mtime", hashes["xsim_23"].get("mtime"))


if __name__ == "__main__":
    main()
