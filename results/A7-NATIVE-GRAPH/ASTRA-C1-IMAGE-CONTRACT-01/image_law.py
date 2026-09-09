#!/usr/bin/env python3
"""Independent replica of gen_800k.svh g_rdata_of. PROGRAM=NO.
Does not freeze DDR_QUERY_BOUND_FINAL. Does not dump 800k bytes.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

G_ENT0, G_ENT_HI, G_N_REL = 13, 213, 20
G_N_STREAM = 799996
G_FILL_CIDX, G_SENT_CIDX = 600, 803800
G_SEN_S, G_SEN_R, G_SEN_O, G_SEN_NID = 213, 20, 13, 799999
G_STRIDE = 64
G_POST_HEAP = 0x05400000
G_DIR_LO = 0x05000000
G_DIR_HI = 0x053FFFF0
G_EPOCH = 7
G_N = 800000


def g_oi(s: int, o: int) -> int:
    return o - G_ENT0 if o < s else o - G_ENT0 - 1


def g_cidx(s: int, r: int, o: int) -> int:
    return ((s - G_ENT0) * G_N_REL + (r - 1)) * (G_ENT_HI - G_ENT0) + g_oi(s, o)


def g_cidx_to_stream(cidx: int) -> int:
    if cidx in (G_FILL_CIDX, G_SENT_CIDX):
        return -1
    skip = 0
    if cidx > G_FILL_CIDX:
        skip += 1
    if cidx > G_SENT_CIDX:
        skip += 1
    si = cidx - skip
    if si < 0 or si >= G_N_STREAM:
        return -1
    return si


def g_stream_to_nid(si: int) -> int:
    return si if si < 120 else si + 3


def g_nid_primary(s: int, r: int, o: int) -> int:
    if s == 13 and r == 4 and o == 14:
        return 120
    if s == G_SEN_S and r == G_SEN_R and o == G_SEN_O:
        return G_SEN_NID
    st = g_cidx_to_stream(g_cidx(s, r, o))
    return -1 if st < 0 else g_stream_to_nid(st)


def g_key_ok(i: int, r: int) -> bool:
    return G_ENT0 <= i <= G_ENT_HI and 1 <= r <= G_N_REL


def g_collect_k0(s: int, r: int) -> list[int]:
    if not g_key_ok(s, r):
        return []
    ids: list[int] = []
    for o in range(G_ENT0, G_ENT_HI + 1):
        if o == s:
            continue
        if s == 13 and r == 4 and o == 14:
            ids.extend([120, 121, 122])
        else:
            nid = g_nid_primary(s, r, o)
            if nid >= 0:
                ids.append(nid)
    return ids


def g_collect_k1(o: int, r: int) -> list[int]:
    if not g_key_ok(o, r):
        return []
    ids: list[int] = []
    for s in range(G_ENT0, G_ENT_HI + 1):
        if s == o:
            continue
        if s == 13 and r == 4 and o == 14:
            ids.extend([120, 121, 122])
        else:
            nid = g_nid_primary(s, r, o)
            if nid >= 0:
                ids.append(nid)
    return ids


def g_occ_of(tbl: int, key: int) -> int:
    if (tbl == 0 and key == 3380) or (tbl == 1 and key == 3636):
        return 1
    s = (key >> 8) & 0xFF
    r = key & 0xFF
    if tbl == 0:
        return len(g_collect_k0(s, r))
    if tbl == 1:
        return len(g_collect_k1(s, r))
    return 0


def g_pack_dir(tbl: int, key: int) -> int:
    occ = g_occ_of(tbl, key)
    if occ <= 0:
        return 0
    hcnt = 4 if occ >= 4 else occ
    ocnt = (occ - 4) if occ > 4 else 0
    hbase = G_POST_HEAP + ((((tbl << 16) + key) * G_STRIDE) << 4)
    obase = hbase + 16
    return (
        (ocnt & 0xFFFF) << 108
        | (obase & 0xFFFFFFF) << 80
        | G_EPOCH << 64
        | (1 if ocnt else 0) << 48
        | (hcnt & 0xFFFF) << 32
        | (hbase & 0xFFFFFFF)
    )


def g_pack_post(tbl: int, key: int, beat: int) -> int:
    if (tbl == 0 and key == 3380) or (tbl == 1 and key == 3636):
        return 121 if beat == 0 else 0
    s = (key >> 8) & 0xFF
    r = key & 0xFF
    if tbl == 0:
        ids = g_collect_k0(s, r)
    elif tbl == 1:
        ids = g_collect_k1(s, r)
    else:
        ids = []
    ids.sort()
    base = beat * 4
    v = 0
    for i in range(4):
        if base + i < len(ids):
            v |= (ids[base + i] & 0xFFFFFFFF) << (32 * i)
    return v


def g_rdata_of(addr: int) -> int:
    if G_DIR_LO <= addr <= G_DIR_HI:
        rel = (addr - 0x05000000) >> 4
        t = rel // 65536
        key = rel % 65536
        return g_pack_dir(t, key)
    if addr >= G_POST_HEAP:
        off = (addr - G_POST_HEAP) >> 4
        slot = off // G_STRIDE
        beat = off % G_STRIDE
        t = slot // 65536
        key = slot % 65536
        return g_pack_post(t, key, beat)
    return 0


def dir_addr(tbl: int, key: int) -> int:
    return 0x05000000 + ((tbl * 65536 + key) << 4)


def post_addr(tbl: int, key: int, beat: int) -> int:
    slot = tbl * 65536 + key
    return G_POST_HEAP + (((slot * G_STRIDE) + beat) << 4)


def _unpack_dir(d: int) -> tuple[int, int, int, int, int]:
    hbase = d & 0xFFFFFFF
    hcnt = (d >> 32) & 0xFFFF
    ocnt = (d >> 108) & 0xFFFF
    epoch = (d >> 64) & 0xFFFF
    obase = (d >> 80) & 0xFFFFFFF
    return hbase, hcnt, ocnt, epoch, obase


def _self_check() -> dict:
    fill_ids = sorted(g_collect_k0(13, 4))
    high_ids = sorted(g_collect_k0(213, 20))
    late_ids = sorted(g_collect_k0(212, 20))
    checks = {
        "occ_fill_k0_0d04": g_occ_of(0, 0x0D04),
        "occ_fill_k1_0e04": g_occ_of(1, 0x0E04),
        "occ_special_3380": g_occ_of(0, 3380),
        "occ_special_3636": g_occ_of(1, 3636),
        "occ_high_k0_d514": g_occ_of(0, 0xD514),
        "occ_high_k1_0d14": g_occ_of(1, 0x0D14),
        "occ_late_k0_d414": g_occ_of(0, 0xD414),
        "fill_head3": fill_ids[:3],
        "high_has_799999": 799999 in high_ids,
        "late_has_799998": 799998 in late_ids,
        "n_fill": len(fill_ids),
        "n_high_k0": len(high_ids),
        "n_late_k0": len(late_ids),
    }
    assert checks["occ_fill_k0_0d04"] == 202, checks
    assert checks["occ_fill_k1_0e04"] == 201, checks
    assert checks["occ_special_3380"] == 1, checks
    assert checks["occ_special_3636"] == 1, checks
    assert checks["occ_high_k0_d514"] == 1, checks
    assert checks["occ_high_k1_0d14"] == 200, checks
    assert checks["occ_late_k0_d414"] == 197, checks
    assert checks["fill_head3"] == [120, 121, 122], checks
    assert checks["high_has_799999"]
    assert checks["late_has_799998"]
    d = g_pack_dir(0, 0x0D04)
    hbase, hcnt, ocnt, epoch, obase = _unpack_dir(d)
    assert hcnt == 4 and ocnt == 198 and epoch == 7, (hcnt, ocnt, epoch)
    assert obase == hbase + 16
    assert g_rdata_of(0x10) == 0
    assert g_rdata_of(dir_addr(2, 0)) == 0
    return checks


def main() -> None:
    bag = Path(__file__).resolve().parent
    checks = _self_check()
    addrs = [
        0x00000010,
        dir_addr(0, 0),
        dir_addr(0, 0x0D04),
        dir_addr(0, 3380),
        dir_addr(1, 0x0E04),
        dir_addr(1, 3636),
        dir_addr(2, 0),
        dir_addr(3, 100),
        post_addr(0, 0x0D04, 0),
        post_addr(0, 0x0D04, 1),
        post_addr(0, 0x0D04, 50),
        post_addr(0, 3380, 0),
        post_addr(1, 0x0E04, 0),
        post_addr(0, 0xD514, 0),
        post_addr(0, 0xD414, 0),
        post_addr(1, 0x0D14, 0),
        dir_addr(1, 0x0D14),
        G_DIR_HI,
        G_POST_HEAP,
        0x05300000,
        dir_addr(0, 0xD514),
        dir_addr(0, 0xD414),
        dir_addr(0, 0x1107),
    ]
    samples = []
    regions = {
        "below_dir": 0,
        "dir_tbl0": 0,
        "dir_tbl1": 0,
        "dir_tbl2plus": 0,
        "post_heap": 0,
        "nonzero": 0,
        "zero": 0,
    }
    for a in addrs:
        d = g_rdata_of(a)
        samples.append({"addr": f"{a:07x}", "data": f"{d:032x}"})
        if a < G_DIR_LO:
            regions["below_dir"] += 1
        elif a <= G_DIR_HI:
            rel = (a - 0x05000000) >> 4
            t = rel // 65536
            if t == 0:
                regions["dir_tbl0"] += 1
            elif t == 1:
                regions["dir_tbl1"] += 1
            else:
                regions["dir_tbl2plus"] += 1
        else:
            regions["post_heap"] += 1
        if d:
            regions["nonzero"] += 1
        else:
            regions["zero"] += 1
    root = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH")
    gen = root / "results" / "A7-NATIVE-GRAPH" / "ASTRA-C3-HELD-OUT-800K-01" / "gen_800k.svh"
    qg = root / "results" / "A7-NATIVE-GRAPH" / "ASTRA-C3-HELD-OUT-800K-01" / "query_gold.svh"
    lex = root / "rtl" / "native_graph" / "query" / "qse_role_lexicon.svh"
    extract = root / "rtl" / "native_graph" / "query" / "a7ng_query_role_extract.sv"
    law_hash = {
        "gen_800k.svh": hashlib.sha256(gen.read_bytes()).hexdigest(),
        "query_gold.svh": hashlib.sha256(qg.read_bytes()).hexdigest(),
        "qse_role_lexicon.svh": hashlib.sha256(lex.read_bytes()).hexdigest() if lex.exists() else "MISSING",
        "a7ng_query_role_extract.sv": hashlib.sha256(extract.read_bytes()).hexdigest() if extract.exists() else "MISSING",
    }
    lines = [
        "`ifndef ASTRA_C1_IMAGE_SAMPLES_SVH",
        "`define ASTRA_C1_IMAGE_SAMPLES_SVH",
        f"localparam int C1IMG_N = {len(samples)};",
        "localparam logic [27:0] C1IMG_ADDR [0:C1IMG_N-1] = '{",
        ", ".join(f"28'h{s['addr']}" for s in samples) + "};",
        "localparam logic [127:0] C1IMG_DATA [0:C1IMG_N-1] = '{",
        ", ".join(f"128'h{s['data']}" for s in samples) + "};",
        "`endif",
    ]
    (bag / "tb_samples.svh").write_text("\n".join(lines) + "\n", encoding="ascii")
    cov = {
        "program": False,
        "full_byte_dump": False,
        "n_triples_claimed": G_N,
        "n_stream": G_N_STREAM,
        "sample_n": len(samples),
        "regions": regions,
        "occ_vs_query_gold": {
            "G_OCC_is_query_not_always_k0_dir": True,
            "G_OCC_fill_q0": 202,
            "replica_fill_k0": checks["occ_fill_k0_0d04"],
            "G_OCC_high_q9": 200,
            "replica_high_k0_d514": checks["occ_high_k0_d514"],
            "replica_high_k1_0d14": checks["occ_high_k1_0d14"],
            "G_OCC_late_q8": 199,
            "replica_late_k0_d414": checks["occ_late_k0_d414"],
        },
        "overflow_page_sampled": True,
        "high_id_page_sampled": True,
        "special_dir_keys": [3380, 3636],
        "dictionary_ddr_image": "NOT_PINNED",
        "query_lexicon_rtl": "PINNED_FILE_NOT_A_DDR_DICT",
        "DDR_QUERY_BOUND_FINAL": "NOT_FROZEN",
        "note": "Coverage is sample/range, not a dump of 800000 records.",
    }
    (bag / "COVERAGE.json").write_text(json.dumps(cov, indent=2) + "\n", encoding="ascii")
    man = {
        "program": False,
        "BOARD_PASS": False,
        "C1_MASTER": "OPEN",
        "DDR_QUERY_BOUND_FINAL": "NOT_FROZEN",
        "image_class": "procedural_cartesian_800k",
        "N": G_N,
        "n_stream": G_N_STREAM,
        "index_base": "0x05000000",
        "post_heap": "0x05400000",
        "dir_hi": "0x053FFFF0",
        "cand_cap_in_law": 16,
        "cand_cap_frozen_from_this_bag": False,
        "dictionary_image": "NOT_PINNED",
        "query_role_lexicon_rtl": law_hash["qse_role_lexicon.svh"],
        "c1_extract_keep": law_hash["a7ng_query_role_extract.sv"],
        "full_byte_dump": False,
        "sample_n": len(samples),
        "law_files": law_hash,
        "samples": samples,
        "self_check": {
            "occ_fill_k0_0d04": checks["occ_fill_k0_0d04"],
            "occ_high_k0_d514": checks["occ_high_k0_d514"],
            "occ_high_k1_0d14": checks["occ_high_k1_0d14"],
            "occ_late_k0_d414": checks["occ_late_k0_d414"],
            "fill_head3": checks["fill_head3"],
        },
        "note": "Sample byte cross-check of procedural law vs independent Python. Not a freeze of DDR_QUERY_BOUND_FINAL. Dictionary DDR image remains unpinned.",
    }
    (bag / "IMAGE_MANIFEST.json").write_text(json.dumps(man, indent=2) + "\n", encoding="ascii")
    print(f"C1IMG_SAMPLES n={len(samples)}")
    print("LAW", json.dumps(law_hash))
    for s in samples:
        print(s["addr"], s["data"][:16])


if __name__ == "__main__":
    main()
