#!/usr/bin/env python3
"""Clone the working 65k scale bag to N=262144 (or 800000) without touching 800k-01."""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import subprocess
import sys
from pathlib import Path

SRC = Path(__file__).resolve().parent
BAGS = SRC.parent

SPECS = {
    262144: {
        "gate": "ASTRA-C1-N262144-SCALE-01",
        "n_stream": 262140,
        "n_ent": 190,
        "n_rel": 8,
        "tag": "C1262K",
        "new_ent": "NEW_ENT = NEW_ENT_16K + NEW_ENT_EXTRA[:70]",
    },
    800000: {
        "gate": "ASTRA-C1-N800000-SCALE-01",
        "n_stream": 799996,
        "n_ent": 201,
        "n_rel": 20,
        "tag": "C1800KS",
        "new_ent": "NEW_ENT = NEW_ENT_16K + NEW_ENT_EXTRA",
    },
}

COPY_AS_IS = [
    "gen_800k.svh",
    "a7ng_axi_mem_proc_800k.sv",
    "qse_relctx_synonym_01.svh",
]


def sha256(p: Path) -> str:
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest().lower()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--n", type=int, required=True, choices=sorted(SPECS))
    args = ap.parse_args()
    n = args.n
    spec = SPECS[n]
    gate = spec["gate"]
    n_stream = spec["n_stream"]
    n_ent = spec["n_ent"]
    n_rel = spec["n_rel"]
    tag = spec["tag"]
    ent0 = 13
    ent_hi = ent0 + n_ent - 1
    sen_s, sen_r, sen_o = ent_hi, n_rel, ent0
    sen_nid = n - 1
    late_nid = n - 2
    tb_mod = f"tb_astra_c1_n{n}_scale"
    host_py = f"host_astra_c1_n{n}_scale.py"
    sim = f"astra_c1_n{n}_scale"
    marker = f"ASTRA_C1_N{n}_SCALE_XSIM_PASS"
    banner = f"C1_N{n}_SCALE_N={n}"
    dest = BAGS / gate
    if dest.exists() and (dest / "xsim.log").exists():
        print(f"REFUSE overwrite existing xsim bag {dest}")
        return 4
    if dest.exists():
        shutil.rmtree(dest)
    dest.mkdir(parents=True)

    for name in COPY_AS_IS:
        shutil.copy2(SRC / name, dest / name)

    host = (SRC / "host_astra_c1_n65536_scale.py").read_text(encoding="utf-8")
    host = host.replace("ASTRA-C1-N65536-SCALE-01", gate)
    host = host.replace("host_astra_c1_n65536_scale.py", host_py)
    host = host.replace("N = 65536\nN_STREAM = 65532", f"N = {n}\nN_STREAM = {n_stream}")
    host = host.replace("ENT_HI = 113", f"ENT_HI = {ent_hi}")
    host = host.replace("N_REL = 8", f"N_REL = {n_rel}", 1)
    host = host.replace(
        "SEN_S, SEN_R, SEN_O = 113, 8, 13",
        f"SEN_S, SEN_R, SEN_O = {sen_s}, {sen_r}, {sen_o}",
    )
    host = host.replace("SEN_NID = 65535", f"SEN_NID = {sen_nid}\nLATE_NID = {late_nid}")
    host = host.replace("NEW_ENT = NEW_ENT_16K[:101]", spec["new_ent"])
    host = host.replace("if N != 65536 or N_STREAM + 3 + 1 != N:", f"if N != {n} or N_STREAM + 3 + 1 != N:")
    host = host.replace("raise SystemExit('N != 65536')", f"raise SystemExit('N != {n}')")
    host = host.replace("if SEN_NID != 65535:", f"if SEN_NID != {sen_nid}:")
    host = host.replace('chk(N == 65536, "N dropped from registered 65536")', f'chk(N == {n}, "N dropped from registered {n}")')
    host = host.replace("== 65534", f"== {late_nid}")
    host = host.replace("[65534]", f"[{late_nid}]")
    host = host.replace("65534 in late_a", f"{late_nid} in late_a")
    host = host.replace("late_a.index(65534)", f"late_a.index({late_nid})")
    host = host.replace("== [65535]", f"== [{sen_nid}]")
    host = host.replace("[65535]", f"[{sen_nid}]")
    host = host.replace('sen_and == [65535]', f"sen_and == [{sen_nid}]")
    host = host.replace('["emit"] == [65535]', f'["emit"] == [{sen_nid}]')
    host = host.replace(
        "        for r in range(1, N_REL + 1):\n            for o in range(ENT0, ENT_HI + 1):",
        "        for r in range(1, N_REL + 1):\n            if r == REL_SUPPLY:\n                continue\n            for o in range(ENT0, ENT_HI + 1):",
    )
    host = host.replace("ASTRA_C1_N65536_SCALE_HOST", f"ASTRA_C1_N{n}_SCALE_HOST")
    host = host.replace('"generator": "cartesian_n65536_v1"', f'"generator": "cartesian_n{n}_v1"')
    host = host.replace('"sentinel_nid": 799999', f'"sentinel_nid": {sen_nid}')
    host = host.replace(
        'f"localparam logic [19:0] G_SEN_NID = 20\'d{SEN_NID};",',
        'f"localparam logic [19:0] G_SEN_NID = 20\'d{SEN_NID};",\n'
        '        f"localparam logic [19:0] G_LATE_NID = 20\'d{LATE_NID};",',
    )
    (dest / host_py).write_text(host, encoding="utf-8")

    tb = (SRC / "tb_astra_c1_n65536_scale.sv").read_text(encoding="utf-8")
    tb = tb.replace("tb_astra_c1_n65536_scale", tb_mod)
    tb = tb.replace("C1 N65536 SCALE", f"C1 N{n} SCALE")
    tb = tb.replace("if (G_N != 65536)", f"if (G_N != {n})")
    tb = tb.replace('diverge("N_DROP", "G_N!=65536 do_not_silently_drop_N");', f'diverge("N_DROP", "G_N!={n} do_not_silently_drop_N");')
    tb = tb.replace("if (G_SEN_NID != 20'd65535)", f"if (G_SEN_NID != 20'd{sen_nid})")
    tb = tb.replace('diverge("SENTINEL", "G_SEN_NID!=65535");', f'diverge("SENTINEL", "G_SEN_NID!={sen_nid}");')
    tb = tb.replace(
        f'if (G_SEN_NID != 20\'d{sen_nid})\n      diverge("SENTINEL", "G_SEN_NID!={sen_nid}");',
        f'if (G_SEN_NID != 20\'d{sen_nid})\n      diverge("SENTINEL", "G_SEN_NID!={sen_nid}");\n'
        f'    if (G_LATE_NID != 20\'d{late_nid})\n      diverge("LATE_NID", "G_LATE_NID!={late_nid}");',
    )
    tb = tb.replace("C1_N65536_SCALE_N=%0d", f"C1_N{n}_SCALE_N=%0d")
    tb = tb.replace("N_ADDRESSABLE=65536", f"N_ADDRESSABLE={n}")
    tb = tb.replace("SEN_NID=65535 LATE_NID=65534", f"SEN_NID={sen_nid} LATE_NID={late_nid}")
    tb = tb.replace("if (got[i] === 20'd65534) late_hit = 1;", "if (got[i] === G_LATE_NID) late_hit = 1;")
    tb = tb.replace(
        'if (late_hit && (n_got == 1) && (got[0] === 20\'d65534))\n          $display("LATE_GOLD_HIT nid=65534 emit_n=%0d tp=%0d", n_got, late_tp);',
        'if (late_hit && (n_got == 1) && (got[0] === G_LATE_NID))\n          $display("LATE_GOLD_HIT nid=%0d emit_n=%0d tp=%0d", G_LATE_NID, n_got, late_tp);',
    )
    tb = tb.replace(
        '$display("FAIL LATE_GOLD_MISS nid_want=65534 emit_n=%0d", n_got);',
        '$display("FAIL LATE_GOLD_MISS nid_want=%0d emit_n=%0d", G_LATE_NID, n_got);',
    )
    tb = tb.replace("N65536_SUMMARY", f"N{n}_SUMMARY")
    tb = tb.replace("&& (G_N == 65536))", f"&& (G_N == {n}))")
    tb = tb.replace("ASTRA_C1_N65536_SCALE_XSIM_PASS", marker)
    tb = tb.replace("ASTRA_C1_N65536_SCALE_XSIM_NO_MARKER", f"ASTRA_C1_N{n}_SCALE_XSIM_NO_MARKER")
    if "G_LATE_NID" not in tb.split("module")[0] and "G_LATE_NID" in tb:
        pass
    (dest / f"{tb_mod}.sv").write_text(tb, encoding="utf-8")

    run = (SRC / "run_xsim.ps1").read_text(encoding="utf-8")
    run = run.replace("C165K_", f"{tag}_")
    run = run.replace("tb_astra_c1_n65536_scale", tb_mod)
    run = run.replace("host_astra_c1_n65536_scale.py", host_py)
    run = run.replace("astra_c1_n65536_scale", sim)
    run = run.replace("ASTRA-C1-N65536-SCALE-01", gate)
    run = run.replace('\'"n": 65536\'', f"'\"n\": {n}'")
    run = run.replace("localparam int unsigned G_N = 65536;", f"localparam int unsigned G_N = {n};")
    run = run.replace("Write-Host \"N=65536 procedural mem;", f"Write-Host \"N={n} procedural mem;")
    run = run.replace("# PROGRAM=NO CAND_CAP=16 N=65536 N_BUCKETS=65536", f"# PROGRAM=NO CAND_CAP=16 N={n} N_BUCKETS=65536")
    run = run.replace("# CAND_CAP_FINAL NOT_FROZEN DDR_QUERY_BOUND_FINAL NOT_FROZEN N=65536", f"# CAND_CAP_FINAL NOT_FROZEN DDR_QUERY_BOUND_FINAL NOT_FROZEN N={n}")
    run = run.replace("N=65536 (not dropped)", f"N={n} (not dropped)")
    run = run.replace("ASTRA_C1_N65536_SCALE_XSIM_PASS", marker)
    run = run.replace("HIGH_ID_HIT nid=65535", f"HIGH_ID_HIT nid={sen_nid}")
    run = run.replace("LATE_GOLD_HIT nid=65534", f"LATE_GOLD_HIT nid={late_nid}")
    run = run.replace("C1_N65536_SCALE_N=65536", banner)
    run = run.replace("ASTRA_C1_N65536_SCALE_RUN_OK PASS N=65536", f"ASTRA_C1_N{n}_SCALE_RUN_OK PASS N={n}")
    (dest / "run_xsim.ps1").write_text(run, encoding="utf-8")

    (dest / "ACK.json").write_text(
        json.dumps(
            {
                "gate": gate,
                "n": n,
                "program": False,
                "board_pass": False,
                "law": "qse-v2-relctx-synonym-01",
                "implementer": "CURSOR_OWNER_OVERRIDE",
                "does_not_edit": "ASTRA-C1-SEMANTIC-800K-01",
            },
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    (dest / "PREREG.md").write_text(
        f"""# PREREG — {gate}

Owner Anh 2026-09-07: Cursor implements Master §7 ladder. Grok 800k-01 stays ACCEPT_PARTIAL; do not edit it.
ONE UNKNOWN: N={n} on frozen synonym-law stack.
Marker {marker} only if FAIL=0 AND N={n} AND late gold {late_nid} HIT AND sentinel {sen_nid} HIT AND fill HIT AND SEARCH_INCOMPLETE absent on gold_n>=1.
Does not close Master C1 / BOARD_PASS / CAND_CAP_FINAL / C2.
""",
        encoding="utf-8",
    )

    proc = subprocess.run([sys.executable, str(dest / host_py)], cwd=str(dest), check=False)
    if proc.returncode != 0:
        print("HOST_FAIL", proc.returncode)
        return proc.returncode

    gold = dest / "GOLDEN.json"
    svh = dest / "query_gold.svh"
    corpus = dest / "corpus.json"
    lex = dest / "qse_role_lexicon_semantic_800k.svh"
    syn = dest / "qse_relctx_synonym_01.svh"
    lines = [
        "# independent gold hashed BEFORE first xvlog — do not regenerate after FAIL",
        f"{sha256(gold)}  GOLDEN.json",
        f"{sha256(svh)}  query_gold.svh",
        f"{sha256(corpus)}  corpus.json",
        f"{sha256(lex)}  qse_role_lexicon_semantic_800k.svh",
        f"{sha256(syn)}  qse_relctx_synonym_01.svh",
        "",
    ]
    (dest / "GOLD_HASH_PRE_XVLOG.txt").write_text("\n".join(lines), encoding="utf-8")
    print("GOLD_HASH_PRE_XVLOG written", dest)
    print("G_LATE_NID in svh", "G_LATE_NID" in svh.read_text(encoding="utf-8"))
    print("G_N", n, "sen", sen_nid, "late", late_nid)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
