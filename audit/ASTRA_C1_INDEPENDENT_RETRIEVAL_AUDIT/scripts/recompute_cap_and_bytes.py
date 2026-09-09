#!/usr/bin/env python3
"""Read-only recompute of N=256 (and optional N=4096) cap-before-AND vs AND-then-cap.

Writes only into this independent folder. Does not modify Grok bags.
"""
from __future__ import annotations

import json
import math
from pathlib import Path

CAND_CAP = 16
INDEX_HEAD = 4
ENTRY = 16
IDS_PER_BEAT = 4

N256_GOLDEN = Path(
    r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C1-KEY-INTERSECT-01\GOLDEN.json"
)
N256_CORPUS = Path(
    r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C1-KEY-INTERSECT-01\corpus.json"
)
N4096_GOLDEN = Path(
    r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C1-N4096-INTERSECT-01\GOLDEN.json"
)
N4096_CORPUS = Path(
    r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C1-N4096-INTERSECT-01\corpus.json"
)
OUT = Path(__file__).resolve().parents[1] / "results" / "recompute.json"


def posting(docs: list[dict], field: str, key: int) -> list[int]:
    return [d["nid"] for d in docs if int(d[field]) == int(key)]


def beats_for_occ(occ: int) -> int:
    """Model: 1 head AR covering min(INDEX_HEAD, occ) IDs, then overflow AR for the rest.

    Matches a7ng_sparse_dir_axi: arlen = ceil(post_count/4)-1 per AR, S_DRAIN
    consumes remaining beats after CAND_CAP. Independent of emit length.
    """
    if occ <= 0:
        return 0
    head = min(INDEX_HEAD, occ)
    head_beats = math.ceil(head / IDS_PER_BEAT)
    rest = occ - head
    ovf_beats = math.ceil(rest / IDS_PER_BEAT) if rest > 0 else 0
    return head_beats + ovf_beats


def analyze_query(docs: list[dict], q: dict) -> dict:
    k0, k1 = q["k0"], q["k1"]
    gold = list(q.get("relevant") or [])
    p0 = posting(docs, "k0", k0)
    p1 = posting(docs, "k1", k1)
    full_and = [nid for nid in p0 if nid in set(p1)]
    cap_then_and = [nid for nid in p0[:CAND_CAP] if nid in set(p1[:CAND_CAP])][:CAND_CAP]
    and_then_cap = full_and[:CAND_CAP]
    occ = [len(p0), len(p1)]
    n_dir = 2 if (q.get("k0_valid") and q.get("k1_valid")) else int(bool(q.get("k0_valid"))) + int(bool(q.get("k1_valid")))
    reported_ar = int(q.get("n_dir") or 0) + int(q.get("n_post") or 0)
    reported_bytes = int(q.get("bytes") or reported_ar * ENTRY)
    model_post_beats = beats_for_occ(occ[0]) + beats_for_occ(occ[1])
    model_r_beats = n_dir + model_post_beats
    model_bytes = model_r_beats * ENTRY
    gold_pos_p0 = [p0.index(g) if g in p0 else None for g in gold]
    gold_pos_p1 = [p1.index(g) if g in p1 else None for g in gold]
    return {
        "name": q["name"],
        "occupancies": occ,
        "gold": gold,
        "gold_index_in_p0": gold_pos_p0,
        "gold_index_in_p1": gold_pos_p1,
        "gold_in_full_and": [g in full_and for g in gold],
        "gold_in_cap_then_and": [g in cap_then_and for g in gold],
        "gold_in_and_then_cap": [g in and_then_cap for g in gold],
        "n_full_and": len(full_and),
        "n_cap_then_and": len(cap_then_and),
        "n_and_then_cap": len(and_then_cap),
        "cap_then_and_equals_and_then_cap": cap_then_and == and_then_cap,
        "emit_golden": q.get("emit"),
        "n_trunc_golden": q.get("n_trunc"),
        "reported_n_dir": q.get("n_dir"),
        "reported_n_post": q.get("n_post"),
        "reported_bytes": reported_bytes,
        "model_r_beats": model_r_beats,
        "model_bytes": model_bytes,
        "undercount_x": (None if reported_bytes == 0 else round(model_bytes / reported_bytes, 3)),
        "bucket12_k0": k0 & 0xFFF,
        "bucket12_k1": k1 & 0xFFF,
        "full16_k0": k0,
        "full16_k1": k1,
        "bucket_drops_high_nibble": ((k0 >> 12) != 0) or ((k1 >> 12) != 0),
    }


def run_bag(golden_path: Path, corpus_path: Path, label: str) -> dict:
    if not golden_path.is_file() or not corpus_path.is_file():
        return {"label": label, "present": False}
    golden = json.loads(golden_path.read_text(encoding="utf-8"))
    corpus = json.loads(corpus_path.read_text(encoding="utf-8"))
    docs = corpus["records"]
    subj = {int(d["subj_id"]) for d in docs}
    rel = {int(d["rel_id"]) for d in docs}
    queries = [analyze_query(docs, q) for q in golden["queries"]]
    return {
        "label": label,
        "present": True,
        "n": golden.get("n"),
        "n_records": len(docs),
        "n_subj_ids": len(subj),
        "max_subj_id": max(subj) if subj else None,
        "n_rel_ids": len(rel),
        "overflow_buckets": golden.get("overflow_buckets"),
        "queries": queries,
    }


def main() -> None:
    OUT.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "cand_cap": CAND_CAP,
        "index_head": INDEX_HEAD,
        "note": "model_bytes assumes full posting R-beats are drained (RTL S_DRAIN). Host/TB bytes = (n_dir+n_post)*16 AR-count.",
        "n256": run_bag(N256_GOLDEN, N256_CORPUS, "ASTRA-C1-KEY-INTERSECT-01"),
        "n4096": run_bag(N4096_GOLDEN, N4096_CORPUS, "ASTRA-C1-N4096-INTERSECT-01"),
    }
    OUT.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    print("wrote", OUT)
    for bag_key in ("n256", "n4096"):
        bag = payload[bag_key]
        if not bag.get("present"):
            print(bag_key, "ABSENT")
            continue
        print("---", bag["label"], "n=", bag["n"], "subj", bag["n_subj_ids"], "max_subj", bag["max_subj_id"])
        for q in bag["queries"]:
            if q["name"] in (
                "direct",
                "wrong_relation",
                "wrong_context",
                "high_occupancy",
                "high_id_sentinel",
                "overflow_page",
            ):
                print(
                    q["name"],
                    "occ",
                    q["occupancies"],
                    "full_and",
                    q["n_full_and"],
                    "cap_then",
                    q["n_cap_then_and"],
                    "and_then",
                    q["n_and_then_cap"],
                    "equal",
                    q["cap_then_and_equals_and_then_cap"],
                    "gold_cap",
                    q["gold_in_cap_then_and"],
                    "gold_full",
                    q["gold_in_full_and"],
                    "repB",
                    q["reported_bytes"],
                    "modelB",
                    q["model_bytes"],
                    "x",
                    q["undercount_x"],
                )


if __name__ == "__main__":
    main()
