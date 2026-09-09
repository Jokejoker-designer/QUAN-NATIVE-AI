#!/usr/bin/env python3
"""ASTRA-02 host selectivity: actual QSE keys + independent gold.

FORBIDDEN: nid-derived k2/k3. Occupancy is not recall.
Does not reopen U4A-R4/R5/R6 law. PROGRAM=NO.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

BAG = Path(__file__).resolve().parent
ORCH = BAG.parent / "GROK-ORCH-00"
BAG_U3Q = ORCH / "U3Q-R3-STRUCTURED-QUERY-FEATURE-00"
BAG_R6 = ORCH / "U4A-R6-ROUTE-VALIDITY-00"
sys.path.insert(0, str(BAG_U3Q))
from lexicon import ENTITY_CANON, ADV_SEED  # noqa: E402
from twin import extract  # noqa: E402

LAW = "qse-v1-lexicon-hdc-00"
N_TABLES = 4
N_BUCKETS = 4096
HEAD_CAP = 64
INDEX_HEAD = 32  # overflow page head; CAND_CAP stays 64 (not a TH_RECALL retarget)
CAND_CAP = 64
TH_RECALL = 0.80
ENTRY = 16
LADDER = (256, 4096, 16384, 65536, 262144, 800000)


def feat(text: str) -> dict:
    x = extract(text)
    n_host = x["n_host"]
    if n_host != 0:
        raise SystemExit(f"HOST_SEMANTIC_LEAK twin text={text!r}")
    return {
        "k": [x["k0"], x["k1"], x["k2"], x["k3"]],
        "v": [x["k0_valid"], x["k1_valid"], x["k2_valid"], x["k3_valid"]],
        "eid": x["entity_id"],
        "iid": x["intent_id"],
        "rid": x["relation_id"],
        "xid": x["context_id"],
        "n_host": n_host,
        "text": text,
    }


def adv0() -> str:
    s = ADV_SEED
    ws = []
    for _w in range(2):
        chars = []
        for _k in range(5):
            s = (s * 1103515245 + 12345) & 0x7FFFFFFF
            chars.append(chr(ord("a") + (s % 26)))
        ws.append("".join(chars))
    return " ".join(ws)


def base_docs() -> list[dict]:
    docs = []
    for lab, forms in ENTITY_CANON.items():
        for t in forms:
            info = feat(t)
            docs.append({"nid": len(docs), "label": lab, **info})
    return docs


def cache_templates() -> dict[str, dict]:
    out = {}
    for lab, forms in ENTITY_CANON.items():
        out[lab] = feat(forms[0])
        out[lab]["label"] = lab
    return out


def _clone(nid: int, lab: str, tmpl: dict, **extra) -> dict:
    row = {
        "nid": nid,
        "label": lab,
        "k": list(tmpl["k"]),
        "v": list(tmpl["v"]),
        "eid": tmpl["eid"],
        "iid": tmpl["iid"],
        "rid": tmpl["rid"],
        "xid": tmpl["xid"],
        "n_host": 0,
        "text": tmpl["text"],
        "synth": 1,
    }
    row.update(extra)
    return row


def build_corpus(n: int, templates: dict[str, dict], overflow_relevant: bool) -> tuple[list[dict], dict]:
    """N records, actual QSE keys, independent HVAC labels.

    Synth collide rows share the real 'chiller' QSE keys but are NOT gold.
    Inserted first so HVAC chiller titles land in overflow pages.
    """
    docs: list[dict] = []
    plants = {
        "overflow_relevant_nid": None,
        "overflow_table": 0,
        "overflow_bucket": None,
        "n_chiller_gold": 0,
        "n_synth_collide": 0,
    }
    base = base_docs()
    plants["overflow_bucket"] = base[0]["k"][0] & 0xFFF
    chiller_tmpl = templates["chiller"]
    labs = [k for k in templates if k != "chiller"]

    n_collide = INDEX_HEAD if overflow_relevant else 0
    for _ in range(n_collide):
        docs.append(_clone(len(docs), "synth_collide", chiller_tmpl, synth=1))
    plants["n_synth_collide"] = n_collide

    for d in base:
        rec = dict(d)
        rec["nid"] = len(docs)
        rec["synth"] = 0
        docs.append(rec)
        if rec["label"] == "chiller":
            plants["overflow_relevant_nid"] = rec["nid"]

    i = 0
    while len(docs) < n:
        lab = labs[i % len(labs)]
        docs.append(_clone(len(docs), lab, templates[lab], synth=1))
        i += 1

    plants["n_chiller_gold"] = sum(1 for d in docs if d["label"] == "chiller" and not d.get("synth"))
    return docs, plants


def index_docs(docs: list[dict]):
    heads = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    overflow_ids = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    ovf_flag = [[0] * N_BUCKETS for _ in range(N_TABLES)]
    post_len = [[0] * N_BUCKETS for _ in range(N_TABLES)]
    admitted = [0] * N_TABLES
    excluded = [0] * N_TABLES
    for d in docs:
        for t in range(N_TABLES):
            if d["v"][t] == 0:
                excluded[t] += 1
                continue
            b = d["k"][t] & 0xFFF
            post_len[t][b] += 1
            if len(heads[t][b]) < INDEX_HEAD:
                heads[t][b].append(d["nid"])
                admitted[t] += 1
            else:
                overflow_ids[t][b].append(d["nid"])
                ovf_flag[t][b] = 1
                admitted[t] += 1
    return heads, overflow_ids, ovf_flag, post_len, admitted, excluded


def route(q: dict, heads, overflow_ids, ovf_flag, post_len):
    probed, skipped = [], []
    predup = []
    seen = []
    ndup = ntrunc = 0
    n_dir = 0
    n_post_beats = 0
    ovf_seen = 0
    posting_lens = []
    occupancies = []
    for t in range(N_TABLES):
        if q["v"][t] == 0:
            skipped.append(t)
            continue
        b = q["k"][t] & 0xFFF
        probed.append(t)
        n_dir += 1
        ids = list(heads[t][b])
        occupancies.append(len(ids))
        plen = post_len[t][b]
        posting_lens.append(plen)
        if ovf_flag[t][b]:
            ovf_seen = 1
        if ids:
            n_post_beats += (len(ids) + 3) // 4
        for nid in ids:
            predup.append(nid)
            if nid in seen:
                ndup += 1
            elif len(seen) >= CAND_CAP:
                ntrunc += 1
            else:
                seen.append(nid)
        oids = list(overflow_ids[t][b])
        if oids and len(seen) < CAND_CAP:
            n_post_beats += (len(oids) + 3) // 4
            for nid in oids:
                predup.append(nid)
                if nid in seen:
                    ndup += 1
                elif len(seen) >= CAND_CAP:
                    ntrunc += 1
                else:
                    seen.append(nid)
        if len(seen) >= CAND_CAP:
            break
    bytes_q = (n_dir + n_post_beats) * ENTRY
    return {
        "probed": probed,
        "skipped": skipped,
        "emit": seen,
        "predup": predup,
        "n_dir": n_dir,
        "n_post_beats": n_post_beats,
        "bytes": bytes_q,
        "n_dup": ndup,
        "n_trunc": ntrunc,
        "overflow_flag": ovf_seen,
        "posting_lens": posting_lens,
        "occupancies": occupancies,
        "overflow_ids_in_probed": [
            overflow_ids[t][q["k"][t] & 0xFFF]
            for t in probed
        ],
    }


def eval_query(name, text, docs, heads, overflow_ids, ovf_flag, post_len, plants):
    q = feat(text)
    r = route(q, heads, overflow_ids, ovf_flag, post_len)
    by_nid = {d["nid"]: d for d in docs}
    lab = None
    for L, forms in ENTITY_CANON.items():
        if text in forms or (L == "chiller" and text.split()[:1] == ["chiller"]):
            lab = L
            break
    if name in ("paraphrase",) or text == "water chiller":
        lab = "chiller"
    if name in ("same_entity_diff_intent",) or text == "leak chiller":
        lab = "chiller"
    gold = {d["nid"] for d in docs if d["label"] == lab and not d.get("synth")} if lab else set()
    cset = set(r["emit"])
    rel = gold & cset
    rec = (len(rel) / len(gold)) if gold else (1.0 if not r["emit"] else 0.0)
    prec = (len(rel) / len(r["emit"])) if r["emit"] else (1.0 if not gold else 0.0)
    n = len(docs)
    ovf_rel = []
    if plants.get("overflow_relevant_nid") is not None and lab == "chiller":
        nid = plants["overflow_relevant_nid"]
        in_ovf = any(nid in lst for lst in r["overflow_ids_in_probed"])
        in_head = nid in cset
        ovf_rel = [{"nid": nid, "in_overflow": in_ovf, "retrieved": in_head}]
    return {
        "name": name,
        "text": text,
        "label": lab,
        "k": q["k"],
        "v": q["v"],
        "packet": {"eid": q["eid"], "iid": q["iid"], "rid": q["rid"], "xid": q["xid"]},
        "n_host": q["n_host"],
        "gold_n": len(gold),
        "emit_n": len(r["emit"]),
        "predup_n": len(r["predup"]),
        "precision": prec,
        "recall": rec,
        "reduction": 1.0 - (len(r["emit"]) / n if n else 0.0),
        "n_dir": r["n_dir"],
        "n_post_beats": r["n_post_beats"],
        "bytes": r["bytes"],
        "n_dup": r["n_dup"],
        "n_trunc": r["n_trunc"],
        "overflow_flag": r["overflow_flag"],
        "posting_lens": r["posting_lens"],
        "occupancies": r["occupancies"],
        "returns_entire_corpus": len(r["emit"]) >= n,
        "overflow_relevant": ovf_rel,
        "unrelated_zero": (lab is None) and (len(r["emit"]) == 0),
    }


def freeze_r6_keys():
    r6 = json.loads((BAG_R6 / "METRICS.json").read_text(encoding="utf-8"))
    by = {x["query"]: x for x in r6["queries"]}
    for name, text in (
        ("known_domain", "chiller"),
        ("paraphrase", "water chiller"),
        ("same_entity_diff_intent", "leak chiller"),
        ("unrelated_payroll", "payroll tax form"),
    ):
        q = feat(text)
        g = by[name]
        if [q["k"][0], q["k"][1], q["k"][2], q["k"][3]] != [g["k0"], g["k1"], g["k2"], g["k3"]]:
            raise SystemExit(f"KEY_MISMATCH vs R6 {name}")
        if [q["v"][0], q["v"][1], q["v"][2], q["v"][3]] != [g["v0"], g["v1"], g["v2"], g["v3"]]:
            raise SystemExit(f"VALIDITY_MISMATCH vs R6 {name}")


def main() -> int:
    freeze_r6_keys()
    templates = cache_templates()
    queries = [
        ("known_domain", "chiller"),
        ("paraphrase", "water chiller"),
        ("same_entity_diff_intent", "leak chiller"),
        ("unrelated_payroll", "payroll tax form"),
        ("unrelated_soccer", "soccer match score"),
        ("adversarial", adv0()),
        ("role_a", "pump supplies chiller"),
        ("role_b", "chiller supplies pump"),
    ]
    ladder_out = []
    fail = []
    for n in LADDER:
        ovf_mode = True
        docs, plants = build_corpus(n, templates, overflow_relevant=ovf_mode)
        heads, overflow_ids, ovf_flag, post_len, admitted, excluded = index_docs(docs)
        # bucket skew over occupied buckets
        occ = [len(heads[t][b]) for t in range(N_TABLES) for b in range(N_BUCKETS) if heads[t][b]]
        skew = {
            "occupied_buckets": len(occ),
            "max_head": max(occ) if occ else 0,
            "mean_head": (sum(occ) / len(occ)) if occ else 0.0,
            "overflow_buckets": int(sum(ovf_flag[t][b] for t in range(N_TABLES) for b in range(N_BUCKETS))),
            "admitted": admitted,
            "excluded": excluded,
        }
        qrows = []
        for name, text in queries:
            row = eval_query(name, text, docs, heads, overflow_ids, ovf_flag, post_len, plants)
            qrows.append(row)
        # Independent-gold checks
        kd = next(x for x in qrows if x["name"] == "known_domain")
        if kd["n_host"] != 0:
            fail.append(f"N={n} HOST_LEAK")
        if kd["recall"] is not None and kd["gold_n"] > 0 and kd["recall"] < TH_RECALL:
            fail.append(f"N={n} known_domain recall={kd['recall']:.4f} < {TH_RECALL}")
        for u in qrows:
            if u["name"].startswith("unrelated") or u["name"] == "adversarial":
                if u["emit_n"] != 0:
                    fail.append(f"N={n} {u['name']} emit={u['emit_n']} expected 0")
        if ovf_mode:
            ov = kd["overflow_relevant"]
            if not ov:
                fail.append(f"N={n} overflow plant missing from known_domain eval")
            else:
                if ov[0]["in_overflow"] and not ov[0]["retrieved"]:
                    fail.append(
                        f"N={n} overflow-relevant nid={ov[0]['nid']} NOT retrieved (head-only walker)"
                    )
        ra = next(x for x in qrows if x["name"] == "role_a")
        rb = next(x for x in qrows if x["name"] == "role_b")
        role_same = ra["k"] == rb["k"] and ra["v"] == rb["v"]
        ladder_out.append({
            "n": len(docs),
            "requested_n": n,
            "skew": skew,
            "plants": plants,
            "role_keys_identical": role_same,
            "queries": qrows,
        })
        print(
            f"N={len(docs)} chiller rec={kd['recall']:.4f} prec={kd['precision']:.4f} "
            f"emit={kd['emit_n']} bytes={kd['bytes']} ovf={kd['overflow_flag']} "
            f"role_same={int(role_same)}"
        )

    result = "FAIL" if fail else "PASS"
    out = {
        "gate": "ASTRA-02-U5-SCALE-SELECTIVITY-800K",
        "law": LAW,
        "keys": "actual_qse_extract",
        "nid_derived_keys": False,
        "th_recall": TH_RECALL,
        "head_cap": HEAD_CAP,
        "index_head": INDEX_HEAD,
        "cand_cap": CAND_CAP,
        "n_tables": N_TABLES,
        "n_buckets": N_BUCKETS,
        "result": result,
        "fail_reasons": fail,
        "occupancy_is_not_recall": True,
        "sentinel_alone_not_enough": True,
        "ladder": ladder_out,
    }
    (BAG / "GOLDEN.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("RESULT", result)
    for f in fail:
        print("FAIL", f)
    print("ASTRA02_HOST_SELECTIVITY_DONE")
    return 0 if result == "PASS" else 8


if __name__ == "__main__":
    raise SystemExit(main())
