#!/usr/bin/env python3
"""Independent C1-800k close gate.

Read-only on Grok trees. Writes JSON only under this independent folder.
Does not declare BOARD_PASS. A future 800k XSim PASS is not C1 close unless
every check below is green.

Run:
  python scripts/c1_800k_close_gate.py
"""
from __future__ import annotations

import json
import re
from datetime import datetime, timezone
from pathlib import Path

GROK = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH")
BAGS = GROK / "results" / "A7-NATIVE-GRAPH"
LIVE_RTL = GROK / "rtl" / "native_graph"
OUT = Path(__file__).resolve().parents[1] / "results" / "c1_800k_close_gate.json"

C0_PREFIX = {
    "extract": "cd7baf49",
    "lexicon_file": "38189974",
    "dir": "09334e42",
    "sparse": "5a4ad04d",
    "gate": "49a66da2",
}
MERGE_POST_AR_MAX_DEFAULT = 256
IDS_PER_POST_AR = 4  # STREAM-02 / synonym wrap: 1 beat, 4 nids

KEEP = {
    "stream02": "14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac",
    "ctx_keys": "124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1",
    "ctx_dut": "8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989",
    "page_skip": "dab15d76da42b33a934d8c68c1108665a79b8544d44b4986b840972841135817",
    "unseen16k_corpus": "6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597",
}

MASTER_N = [256, 4096, 16384, 65536, 262144, 800000]
FILL_RE = re.compile(r"^([a-z]+) ([a-z]+) ([a-z]+)(?: ([a-z]+))?$")
TAUTOLOGY_REDUCTION = re.compile(
    r"1\s*-\s*CAND_CAP\s*/\s*N|1-CAND_CAP/N|reduction.*=.*1\s*-\s*16\s*/",
    re.I,
)


def sha256_file(path: Path) -> str | None:
    import hashlib

    if not path.is_file():
        return None
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def read_text(path: Path, limit: int = 2_000_000) -> str:
    if not path.is_file():
        return ""
    data = path.read_bytes()[:limit]
    return data.decode("utf-8", errors="replace")


def banner_n(xsim: str) -> int | None:
    m = re.search(r"_N=(\d+)", xsim)
    if m:
        return int(m.group(1))
    m = re.search(r"(?<![A-Z_])N=(\d+)", xsim)
    return int(m.group(1)) if m else None


def class_occ(xsim: str) -> list[dict]:
    rows = []
    for m in re.finditer(
        r"CLASS_(\w+) .*\bocc=(\d+)\b.*\bemit_n=(\d+)\b.*\bincomp=(\d+)",
        xsim,
    ):
        rows.append(
            {
                "class": m.group(1),
                "occ": int(m.group(2)),
                "emit_n": int(m.group(3)),
                "incomp": int(m.group(4)),
            }
        )
    if rows:
        return rows
    for m in re.finditer(
        r"CLASS_(\w+) gold_n=\d+ emit_n=(\d+) .* occ=(\d+) .* incomp=(\d+)",
        xsim,
    ):
        rows.append(
            {
                "class": m.group(1),
                "occ": int(m.group(3)),
                "emit_n": int(m.group(2)),
                "incomp": int(m.group(4)),
            }
        )
    return rows


def corpus_stats(path: Path) -> dict:
    if not path.is_file():
        return {"present": False}
    # Stream JSON: files can be one-line 16k records.
    raw = path.read_text(encoding="utf-8", errors="replace")
    try:
        obj = json.loads(raw)
    except json.JSONDecodeError as e:
        return {"present": True, "parse_error": str(e)}
    recs = obj.get("records") or []
    n_claim = int(obj.get("n") or 0)
    texts = [str(r.get("text") or "") for r in recs]
    nids = [int(r["nid"]) for r in recs if "nid" in r]
    fill_n = sum(1 for t in texts if FILL_RE.match(t.strip()))
    unique_t = len(set(texts))
    unique_n = len(set(nids))
    return {
        "present": True,
        "n_claim": n_claim,
        "n_records": len(recs),
        "unique_texts": unique_t,
        "unique_nids": unique_n,
        "fill_template_n": fill_n,
        "fill_template_frac": (fill_n / len(texts)) if texts else None,
        "contiguous_from_0": nids == list(range(len(nids))) if nids else False,
        "twelve_entity_flag": bool(obj.get("twelve_entity_clone")),
        "corpus_sha_header": obj.get("corpus_copied_sha") or obj.get("gate"),
    }


def check(name: str, ok: bool, detail: str, blocking: bool = True) -> dict:
    return {
        "id": name,
        "ok": ok,
        "blocking_for_c1_close": blocking,
        "detail": detail,
        "verdict": "PASS" if ok else ("FAIL" if blocking else "WARN"),
    }


def main() -> int:
    findings: list[dict] = []
    bags = {}

    wanted = {
        "n256_stream": BAGS / "ASTRA-C1-STREAM-INTERSECT-02",
        "n4096_stream": BAGS / "ASTRA-C1-N4096-STREAM-02",
        "n16384_semantic": BAGS / "ASTRA-C1-SEMANTIC-16K-01",
        "n65536": BAGS / "ASTRA-C1-N65536-SCALE-01",
        "n262144": BAGS / "ASTRA-C1-N262144-SCALE-01",
        "n800000": BAGS / "ASTRA-C1-SEMANTIC-800K-01",
        "n800000_scale": BAGS / "ASTRA-C1-N800000-SCALE-01",
        "cand_cap_sweep": BAGS / "ASTRA-C1-CAND-CAP-SWEEP-01",
        "synonym": BAGS / "ASTRA-C1-SYNONYM-LAW-01",
        "nl_fail": BAGS / "ASTRA-C1-SEMANTIC-NL-01",
        "unseen_r2": BAGS / "ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01",
        "u5_hist": BAGS / "ASTRA-02-U5-SCALE-SELECTIVITY-800K",
    }
    for k, p in wanted.items():
        xsim = read_text(p / "xsim.log")
        golden = {}
        gp = p / "GOLDEN.json"
        if gp.is_file():
            try:
                golden = json.loads(gp.read_text(encoding="utf-8"))
            except json.JSONDecodeError:
                golden = {"parse_error": True}
        bags[k] = {
            "path": str(p),
            "exists": p.is_dir(),
            "has_xsim": (p / "xsim.log").is_file(),
            "has_closeout": (p / "CLOSEOUT.md").is_file(),
            "banner_n": banner_n(xsim) if xsim else None,
            "golden_n": golden.get("n") if isinstance(golden, dict) else None,
            "search_incomplete": ("SEARCH_INCOMPLETE" in xsim and "ABSENT" not in xsim.split("SEARCH_INCOMPLETE")[0][-40:])
            if xsim
            else None,
            "xsim_has_search_incomplete_line": bool(re.search(r"^SEARCH_INCOMPLETE", xsim, re.M))
            if xsim
            else False,
            "reduction_not_emitted": "REDUCTION_X1000=NOT_EMITTED" in xsim if xsim else None,
            "c1_800k_open": "C1_800K=OPEN" in xsim or "C1_800k=OPEN" in xsim if xsim else None,
            "pass_marker": bool(re.search(r"ASTRA_C1_\w+_XSIM_PASS", xsim)) if xsim else False,
            "classes": class_occ(xsim) if xsim else [],
        }

    findings.append(
        check(
            "LADDER_65536_BAG",
            bags["n65536"]["exists"] and bags["n65536"]["has_xsim"],
            "Master §7 requires N=65536 before 262144 and 800000. Bag ASTRA-C1-N65536-SCALE-01 missing or no xsim.log.",
        )
    )
    findings.append(
        check(
            "LADDER_262144_BAG",
            bags["n262144"]["exists"] and bags["n262144"]["has_xsim"],
            "Master §7 requires N=262144 before 800000. Bag missing or no xsim.log.",
        )
    )
    n800 = bags["n800000"]
    findings.append(
        check(
            "N800K_RESULTS_EXIST",
            n800["exists"] and n800["has_xsim"],
            "ASTRA-C1-SEMANTIC-800K-01 has no results yet (IN_PROGRESS / not started).",
            blocking=True,
        )
    )
    if n800["has_xsim"] and n800["banner_n"] not in (None, 800000):
        findings.append(
            check(
                "N800K_BANNER_IS_800000",
                False,
                f"800k bag xsim banner N={n800['banner_n']} — silent N drop / overclaim.",
            )
        )
    elif n800["has_xsim"]:
        findings.append(
            check(
                "N800K_BANNER_IS_800000",
                n800["banner_n"] == 800000,
                f"banner N={n800['banner_n']}",
            )
        )

    syn_corpus = BAGS / "ASTRA-C1-SYNONYM-LAW-01" / "corpus.json"
    syn_stats = corpus_stats(syn_corpus)
    findings.append(
        check(
            "SYNONYM_STILL_16K_CARTESIAN",
            True,
            (
                f"Current frozen semantic corpus n_claim={syn_stats.get('n_claim')} "
                f"records={syn_stats.get('n_records')} fill_frac={syn_stats.get('fill_template_frac')} "
                "unique_nids={un}. Cloning this as N=800000 is OVERCLAIM."
            ).format(un=syn_stats.get("unique_nids")),
            blocking=False,
        )
    )
    if syn_stats.get("n_records") == 16384:
        findings.append(
            check(
                "NO_16K_CLONE_AS_800K",
                not (
                    n800["has_xsim"]
                    and n800["banner_n"] == 800000
                    and (n800.get("golden_n") in (16384, None))
                ),
                "If 800k bag exists, corpus must have 800000 distinct nids; 16k KEEP copy printed as 800k is FAIL.",
                blocking=n800["has_xsim"],
            )
        )

    occs = []
    for key in ("n16384_semantic", "synonym", "unseen_r2"):
        for row in bags[key]["classes"]:
            if row["occ"] > 0:
                occs.append(row)
    max_occ_16k = max((r["occ"] for r in occs), default=None)
    # Project occupancy if same 120-entity cartesian is 800k/16k times denser.
    proj = None
    if max_occ_16k:
        proj = int(max_occ_16k * (800000 / 16384))
    merge_ids = MERGE_POST_AR_MAX_DEFAULT * IDS_PER_POST_AR
    merge_would_trip = proj is not None and (2 * ((proj + IDS_PER_POST_AR - 1) // IDS_PER_POST_AR) > MERGE_POST_AR_MAX_DEFAULT)
    findings.append(
        check(
            "OCCUPANCY_PROJECTION_800K",
            not merge_would_trip,
            f"Max CLASS occ on 16k bags={max_occ_16k}; naive same-entity 800k projection≈{proj}. "
            f"Synonym wrap MERGE_POST_AR_MAX default={MERGE_POST_AR_MAX_DEFAULT} "
            f"(~{merge_ids} posting IDs). Same 120-entity cartesian at 800k trips SEARCH_INCOMPLETE. "
            "Widen entity namespace, instantiate PAGE-SKIP as a named bag, or a NEW named wrap "
            "with documented MERGE_POST_AR_MAX. Do not silent-edit KEEP stream-02.",
            blocking=False,
        )
    )

    # KEEP 16k/synonym still print NOT_EMITTED; score Master-ladder scale bags instead.
    # Do not require rewriting frozen 16k bags. Grok 800k-01 is ACCEPT_PARTIAL without this metric.
    scale_needles = []
    for key in ("n65536", "n262144", "n800000_scale"):
        xt = read_text(wanted[key] / "xsim.log") if bags[key]["has_xsim"] else ""
        scale_needles.append(
            bool(xt)
            and "REDUCTION_VS_N_X1000=" in xt
            and "REDUCTION_X1000=NOT_EMITTED" not in xt
        )
    findings.append(
        check(
            "REDUCTION_METRIC_EMITTED",
            bags["n65536"]["has_xsim"]
            and bags["n262144"]["has_xsim"]
            and bags["n800000_scale"]["has_xsim"]
            and all(scale_needles),
            "65k/262k/800k-scale bags must print REDUCTION_VS_N_X1000 (occupancy vs N), never 1-CAND_CAP/N. "
            f"scale65={scale_needles[0]} scale262={scale_needles[1]} scale800={scale_needles[2]}. "
            "SEMANTIC-800K-01 historically REDUCTION_X1000=NOT_EMITTED (ACCEPT_PARTIAL only).",
        )
    )

    scale800 = read_text(wanted["n800000_scale"] / "xsim.log") if bags["n800000_scale"]["has_xsim"] else ""
    required_classes = (
        "fill_template",
        "paraphrase",
        "nl_synonym",
        "role_reversal",
        "wrong_relation",
        "wrong_context",
        "distractor",
        "high_occupancy",
        "late_gold",
        "high_id_sentinel",
        "unrelated",
    )
    missing_cls = [c for c in required_classes if f"CLASS_{c}" not in scale800]
    findings.append(
        check(
            "SCALE_800K_XSIM_PASS",
            "ASTRA_C1_N800000_SCALE_XSIM_PASS" in scale800 and "C1_N800000_SCALE_N=800000" in scale800,
            "ASTRA-C1-N800000-SCALE-01 marker/banner missing.",
        )
    )
    findings.append(
        check(
            "SCALE_800K_MASTER_CLASSES",
            bags["n800000_scale"]["has_xsim"] and not missing_cls,
            "Missing Master §7 classes on 800k-scale: " + ",".join(missing_cls)
            if missing_cls
            else "All 11 Master §7 class prints present on N800000-SCALE-01.",
        )
    )

    sweep_txt = read_text(wanted["cand_cap_sweep"] / "xsim.log") if bags["cand_cap_sweep"]["has_xsim"] else ""
    sweep_caps_ok = all(
        f"ASTRA_C1_CAND_CAP_SWEEP_XSIM_PASS cap={c}" in sweep_txt
        and f"CAND_CAP_SWEEP_POINT cap={c}" in sweep_txt
        for c in (16, 64, 128, 256)
    )
    findings.append(
        check(
            "CAND_CAP_SWEEP_BAG",
            bags["cand_cap_sweep"]["has_xsim"] and sweep_caps_ok,
            "ASTRA-C1-CAND-CAP-SWEEP-01 must PASS caps 16/64/128/256 on frozen 800k-scale gold. "
            f"has_xsim={bags['cand_cap_sweep']['has_xsim']} caps_ok={sweep_caps_ok}.",
        )
    )
    aud_p = GROK / "results" / "A7-NATIVE-GRAPH" / "AUDITOR" / "20260907T2148Z" / "REPORT.md"
    aud_txt = read_text(aud_p)
    findings.append(
        check(
            "AUDITOR_ACCEPT_C1_XSIM",
            aud_p.is_file()
            and "C1_XSIM_LAW=ACCEPT" in aud_txt
            and "C1_800K_CLOSED_XSIM=YES" in aud_txt
            and "BOARD_PASS=REJECT" in aud_txt
            and "ACCEPT_BOARD=REJECT" in aud_txt,
            "Need auditor 20260907T2148Z machine lines C1_XSIM_LAW=ACCEPT, "
            "C1_800K_CLOSED_XSIM=YES, BOARD_PASS=REJECT, ACCEPT_BOARD=REJECT. "
            f"present={aud_p.is_file()}",
        )
    )

    tautology_hits = []
    for name, p in wanted.items():
        text = read_text(p / "RESULTS.md") + read_text(p / "CLOSEOUT.md")
        if TAUTOLOGY_REDUCTION.search(text):
            tautology_hits.append(name)
    findings.append(
        check(
            "NO_TAUTOLOGY_REDUCTION",
            len(tautology_hits) == 0,
            "Tautology 1-CAND_CAP/N in RESULTS/CLOSEOUT: " + ",".join(tautology_hits)
            if tautology_hits
            else "No tautology reduction string in sampled CLOSEOUT/RESULTS.",
        )
    )

    # C0 live hashes
    live = {
        "extract": sha256_file(LIVE_RTL / "query" / "a7ng_query_role_extract.sv"),
        "lexicon_file": sha256_file(LIVE_RTL / "query" / "qse_role_lexicon.svh"),
        "dir": sha256_file(LIVE_RTL / "memory" / "a7ng_sparse_dir_axi.sv"),
        "sparse": sha256_file(LIVE_RTL / "integrate" / "a7ng_query_axi_sparse.sv"),
        "gate": sha256_file(LIVE_RTL / "query" / "a7ng_route_valid_gate.sv"),
        "stream02": sha256_file(LIVE_RTL / "integrate" / "a7ng_query_axi_sparse_stream_intersect.sv"),
        "ctx_keys": sha256_file(LIVE_RTL / "query" / "a7ng_query_role_keys_ctx.sv"),
        "ctx_dut": sha256_file(LIVE_RTL / "integrate" / "a7ng_query_axi_sparse_intersect_context.sv"),
        "syn_svh": sha256_file(LIVE_RTL / "query" / "qse_relctx_synonym_01.svh"),
        "syn_mod": sha256_file(LIVE_RTL / "query" / "a7ng_query_role_relctx_synonym.sv"),
        "syn_dut": sha256_file(LIVE_RTL / "integrate" / "a7ng_query_axi_sparse_intersect_synonym.sv"),
    }
    syn_svh = read_text(LIVE_RTL / "query" / "qse_relctx_synonym_01.svh")
    m_syn_n = re.search(r"QSE_SYN_N\s*=\s*(\d+)", syn_svh)
    syn_n = int(m_syn_n.group(1)) if m_syn_n else None
    findings.append(
        check(
            "C0_EXTRACT_UNPATCHED",
            (live["extract"] or "").startswith(C0_PREFIX["extract"]),
            f"live extract sha={live['extract']}",
        )
    )
    findings.append(
        check(
            "C0_LEXICON_FILE_UNPATCHED",
            (live["lexicon_file"] or "").startswith(C0_PREFIX["lexicon_file"]),
            f"live C0 lexicon FILE sha={live['lexicon_file']}",
        )
    )
    findings.append(
        check(
            "C0_DIR_UNPATCHED",
            (live["dir"] or "").startswith(C0_PREFIX["dir"]),
            f"live dir sha={live['dir']}",
        )
    )
    findings.append(
        check(
            "C0_SPARSE_FILE_UNPATCHED",
            (live["sparse"] or "").startswith(C0_PREFIX["sparse"]),
            f"live C0 sparse FILE sha={live['sparse']} (often not compiled as DUT)",
        )
    )
    findings.append(
        check(
            "C0_GATE_UNPATCHED",
            (live["gate"] or "").startswith(C0_PREFIX["gate"]),
            f"live route gate sha={live['gate']}",
        )
    )
    findings.append(
        check(
            "CTX_KEYS_UNEDITED",
            (live["ctx_keys"] or "").startswith("124be808"),
            f"live ctx keys sha={live['ctx_keys']}",
        )
    )
    findings.append(
        check(
            "STREAM02_UNEDITED",
            (live["stream02"] or "").startswith("14f75db7"),
            f"live stream02 sha={live['stream02']}",
        )
    )
    findings.append(
        check(
            "SYNONYM_IS_ONE_PAIR",
            syn_n == 1,
            f"QSE_SYN_N={syn_n}. Growing the table in place is a new law id, not silent C0. "
            "1-pair is not general NL; C1 paraphrase class may use this pair only if gold says so.",
            blocking=False,
        )
    )

    nl_xsim = read_text(wanted["nl_fail"] / "xsim.log")
    findings.append(
        check(
            "NL_FAIL_KEPT",
            "FAIL GOLD_MISS" in nl_xsim and "CAND nl_synonym i=0 id=131" in nl_xsim,
            "SEMANTIC-NL-01 raw FAIL emit 131 kept. Do not relabel gold to 131. Synonym overlay is the named fix.",
            blocking=False,
        )
    )

    u5 = bags["u5_hist"]
    findings.append(
        check(
            "U5_HISTORICAL_NOT_C1",
            True,
            f"Historical U5 path exists={u5['exists']}. Pre-role-law 800k cannot close C1 (Master §6).",
            blocking=False,
        )
    )

    loop_p = GROK / "docs" / "ASTRA" / "LOOP_STATE.json"
    loop = {}
    if loop_p.is_file():
        loop = json.loads(loop_p.read_text(encoding="utf-8"))
    findings.append(
        check(
            "LOOP_NOT_CLAIMING_BOARD",
            loop.get("final_promotion") == "REJECT" and loop.get("board_pass") is False,
            f"LOOP c1_800k={loop.get('c1_800k')} c1_800k_closed={loop.get('c1_800k_closed')} "
            f"final_promotion={loop.get('final_promotion')} board_pass={loop.get('board_pass')}",
            blocking=False,
        )
    )

    blocking_fail = [f for f in findings if f["blocking_for_c1_close"] and not f["ok"]]
    xsim_closed = (not blocking_fail) and ("C1_XSIM_LAW=ACCEPT" in aud_txt)
    report = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "classification": "FACT from live files this run. C1_CLOSE=YES_XSIM is XSim law close only; BOARD_PASS stays REJECT; DDR_QUERY_BOUND_FINAL stays NOT_FROZEN.",
        "c1_close": "YES_XSIM" if xsim_closed else "NO",
        "c2_may_start": "YES" if xsim_closed else "NO",
        "blocking_fail_ids": [f["id"] for f in blocking_fail],
        "findings": findings,
        "bags": bags,
        "synonym_corpus": syn_stats,
        "live_hashes_prefix": {k: (v[:16] if v else None) for k, v in live.items()},
        "occupancy_max_16k": max_occ_16k,
        "occupancy_proj_800k_same_entities": proj,
        "root_causes": [
            {
                "id": "RC-LADDER-SKIP",
                "statement": "20260907T2148Z ACCEPT C1 XSim law (ladder+11 class+sweep). Cartesian procedural AXI and 1-pair synonym remain quality bounds. BOARD_PASS / ACCEPT_BOARD / DDR_QUERY_BOUND_FINAL remain REJECT/NOT_FROZEN.",
                "fix": "C2 may start as persist identity PROGRAM=NO. Do not treat XSim C1 as silicon. Do not claim general NL or semantic mass.",
            },
            {
                "id": "RC-CARTESIAN-16K",
                "statement": "Semantic index is still a 16384 cartesian {ent}{rel}{ent} KEEP copy (6991adc7) plus 8 plants.",
                "fix": "800k bag must address 800000 distinct nids. Procedural gen OK. 16k clone with banner N=800000 = OVERCLAIM.",
            },
            {
                "id": "RC-REDUCTION-ABSENT",
                "statement": "REDUCTION_X1000=NOT_EMITTED on 16k/synonym KEEP. Scale bags print REDUCTION_VS_N_X1000. Cap sweep shows cap is not binding (emit 1–3). Cannot freeze CAND_CAP_FINAL as Master ≥90% cap policy from this cartesian image.",
                "fix": "Auditor may record a candidate cap=16 / DDR bound=1632 bytes. Freeze FINAL only after ACCEPT. Never 1-CAND_CAP/N.",
            },
            {
                "id": "RC-INCOMP-POLICY",
                "statement": "N4096 INTERSECT closed with SEARCH_INCOMPLETE on sentinel; STREAM-02 fixed AND-then-cap. Scale bags must FAIL on incomp for gold_n>=1.",
                "fix": "Keep STREAM-02 instantiate. Late gold n-2 and sentinel n-1 must HIT. incomp=1 = bag FAIL.",
            },
            {
                "id": "RC-NL-ONE-ALIAS",
                "statement": "Frozen QSE cannot bind supply≠feeds; 1-pair overlay remaps id 1→4. Not general NL.",
                "fix": "C1 required paraphrase class: either stay on supported aliases in the frozen synonym table (new named law if more pairs) or FAIL that class honestly. Do not silent-patch C0.",
            },
            {
                "id": "RC-OCCUPANCY-BLOWUP",
                "statement": f"16k max occ={max_occ_16k}; same 120 entities at 800k projects occ≈{proj} → DDR bytes and SEARCH_INCOMPLETE risk.",
                "fix": "Either widen entity namespace (new named corpus, not C0) or prove stream merge + page-skip still HIT late gold within MERGE_POST_AR_MAX and emit SEARCH_INCOMPLETE when not.",
            },
            {
                "id": "RC-MERGE-BUDGET-256",
                "statement": f"Synonym DUT copies STREAM-02 with MERGE_POST_AR_MAX=256. Projected 800k two-list walk exceeds that budget (proj occ={proj}).",
                "fix": "Do not silent-bump the KEEP file. Named wrap parameter or PAGE-SKIP bag first. 65k/262k rungs will show the trip before 800k if occupancy scales with N.",
            },
            {
                "id": "RC-AXI-MEM-NOT-DDR",
                "statement": "C1 bags use axi_mem_model. C2 is persist-to-DDR. Closing C1 XSim does not close C2.",
                "fix": "C1 XSim may close without MIG. C2 first bag is persist identity. Do not freeze DDR_QUERY_BOUND_FINAL from AXI procedural bytes. PROGRAM=NO until persist XSim.",
            },
        ],
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"c1_close": report["c1_close"], "c2_may_start": report["c2_may_start"], "blocking": report["blocking_fail_ids"], "out": str(OUT)}, indent=2))
    return 1 if blocking_fail else 0


if __name__ == "__main__":
    raise SystemExit(main())
