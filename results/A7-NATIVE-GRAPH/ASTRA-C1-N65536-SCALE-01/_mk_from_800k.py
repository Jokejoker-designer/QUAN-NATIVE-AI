#!/usr/bin/env python3
"""One-shot: retarget copied 800k templates to N=65536 scale bag."""
from __future__ import annotations

from pathlib import Path

BAG = Path(__file__).resolve().parent
N = 65536
N_STREAM = 65532
N_ENT = 101
ENT0 = 13
ENT_HI = ENT0 + N_ENT - 1  # 113
N_REL = 8
SEN_S = ENT_HI
SEN_R = N_REL
SEN_O = ENT0
SEN_NID = N - 1
LATE_NID = N - 2
GATE = "ASTRA-C1-N65536-SCALE-01"
MARKER = "ASTRA_C1_N65536_SCALE_XSIM_PASS"
TB_MOD = "tb_astra_c1_n65536_scale"
SIM = "astra_c1_n65536_scale"


def main() -> None:
    host = (BAG / "host_astra_c1_semantic_800k.py").read_text(encoding="utf-8")
    host = host.replace("ASTRA-C1-SEMANTIC-800K-01", GATE)
    host = host.replace("host_astra_c1_semantic_800k.py", "host_astra_c1_n65536_scale.py")
    host = host.replace("N = 800000", f"N = {N}")
    host = host.replace("N_STREAM = 799996", f"N_STREAM = {N_STREAM}")
    host = host.replace("ENT_HI = 213", f"ENT_HI = {ENT_HI}")
    host = host.replace("N_REL = 20", f"N_REL = {N_REL}")
    host = host.replace("SEN_S, SEN_R, SEN_O = 213, 20, 13", f"SEN_S, SEN_R, SEN_O = {SEN_S}, {SEN_R}, {SEN_O}")
    host = host.replace("SEN_NID = 799999", f"SEN_NID = {SEN_NID}")
    host = host.replace("NEW_ENT = NEW_ENT_16K + NEW_ENT_EXTRA", f"NEW_ENT = NEW_ENT_16K[:{N_ENT}]")
    host = host.replace('if NEW_ENT[-1] != "hatchway":\n        raise SystemExit("sentinel entity word drifted")\n    ', "")
    host = host.replace(
        'if FILL_CIDX != 600 or SENT_CIDX != 803800:\n        raise SystemExit(f"cidx drift fill={FILL_CIDX} sent={SENT_CIDX}")\n    if N != 800000 or N_STREAM + 3 + 1 != N:\n        raise SystemExit("N != 800000")\n    if SEN_NID != 799999:\n        raise SystemExit("sentinel nid")\n',
        f"if N != {N} or N_STREAM + 3 + 1 != N:\n        raise SystemExit('N != {N}')\n    if SEN_NID != {SEN_NID}:\n        raise SystemExit('sentinel nid')\n",
    )
    host = host.replace('chk(N == 800000, "N dropped from registered 800000")', f'chk(N == {N}, "N dropped from registered {N}")')
    host = host.replace('chk(N_ENT >= 200, "800k unique cartesian needs >=200 subjects")\n    chk(N_REL >= 16, "800k unique cartesian needs extra rels vs 16k")\n    ', "")
    host = host.replace(
        "chk(stream_to_nid(N_STREAM - 1) == 799998, \"last stream nid\")",
        f"chk(stream_to_nid(N_STREAM - 1) == {LATE_NID}, \"last stream nid\")",
    )
    host = host.replace("chk(nids_of_sro(SEN_S, SEN_R, SEN_O) == [799999], \"sentinel nid\")", f'chk(nids_of_sro(SEN_S, SEN_R, SEN_O) == [{SEN_NID}], "sentinel nid")')
    host = host.replace("chk(sen_and == [799999], f\"sent AND {sen_and}\")", f'chk(sen_and == [{SEN_NID}], f"sent AND {{sen_and}}")')
    old_spec = '''    queries_spec = [
        ("fill_template", triple_text(DIR_S, DIR_R, DIR_O), [120, 121, 122]),
        ("nl_synonym", NL_TEXT, [120, 121, 122]),
        ("high_id_sentinel", sen_text, [799999]),
        ("unrelated", "payroll tax form", []),
    ]'''
    new_spec = f'''    late_sro = None
    for s in range(ENT0, ENT_HI + 1):
        for r in range(1, N_REL + 1):
            for o in range(ENT0, ENT_HI + 1):
                if o == s:
                    continue
                if nids_of_sro(s, r, o) == [{LATE_NID}]:
                    late_sro = (s, r, o)
                    break
            if late_sro:
                break
        if late_sro:
            break
    if late_sro is None:
        raise SystemExit("late gold sro missing")
    late_text = triple_text(*late_sro)
    late_a = posting_k0(late_sro[0], late_sro[1])
    chk({LATE_NID} in late_a, "late nid not on k0 list")
    chk(late_a.index({LATE_NID}) >= 16, f"late k0_idx={{late_a.index({LATE_NID})}} < 16")
    queries_spec = [
        ("fill_template", triple_text(DIR_S, DIR_R, DIR_O), [120, 121, 122]),
        ("nl_synonym", NL_TEXT, [120, 121, 122]),
        ("late_gold", late_text, [{LATE_NID}]),
        ("high_id_sentinel", sen_text, [{SEN_NID}]),
        ("unrelated", "payroll tax form", []),
    ]'''
    if old_spec not in host:
        raise SystemExit("queries_spec block not found")
    host = host.replace(old_spec, new_spec)
    host = host.replace(
        '    hi_i = next(i for i, q in enumerate(queries) if q["name"] == "high_id_sentinel")\n    unrel_i = next(i for i, q in enumerate(queries) if q["name"] == "unrelated")',
        '    late_i = next(i for i, q in enumerate(queries) if q["name"] == "late_gold")\n    hi_i = next(i for i, q in enumerate(queries) if q["name"] == "high_id_sentinel")\n    unrel_i = next(i for i, q in enumerate(queries) if q["name"] == "unrelated")',
    )
    host = host.replace(
        '        f"localparam int unsigned G_HIGH_Q = {hi_i};",\n        f"localparam int unsigned G_UNRELATED_Q = {unrel_i};",',
        '        f"localparam int unsigned G_LATE_Q = {late_i};",\n        f"localparam int unsigned G_HIGH_Q = {hi_i};",\n        f"localparam int unsigned G_UNRELATED_Q = {unrel_i};",',
    )
    host = host.replace('chk(qd["high_id_sentinel"]["emit"] == [799999], f"high emit {qd[\'high_id_sentinel\'][\'emit\']}")', f'chk(qd["high_id_sentinel"]["emit"] == [{SEN_NID}], f"high emit {{qd[\'high_id_sentinel\'][\'emit\']}}")')
    host = host.replace("print(\"ASTRA_C1_SEMANTIC_800K_HOST_OK\")", 'print("ASTRA_C1_N65536_SCALE_HOST_OK")')
    host = host.replace("print(\"ASTRA_C1_SEMANTIC_800K_HOST_FAIL\")", 'print("ASTRA_C1_N65536_SCALE_HOST_FAIL")')
    host = host.replace('"reduction_x1000": "NOT_EMITTED"', '"reduction_x1000": "VS_N"')
    host = host.replace('"reduction_x1000_emitted": False', '"reduction_x1000_emitted": True')
    host = host.replace('"generator": "cartesian_new_subj_800k_v1"', '"generator": "cartesian_n65536_v1"')
    host = host.replace('"sentinel_nid": 799999', f'"sentinel_nid": {SEN_NID}')
    (BAG / "host_astra_c1_n65536_scale.py").write_text(host, encoding="utf-8")
    print("wrote host_astra_c1_n65536_scale.py")


if __name__ == "__main__":
    main()
