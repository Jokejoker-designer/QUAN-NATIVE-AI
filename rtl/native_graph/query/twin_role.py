#!/usr/bin/env python3
"""Bit-exact twin of a7ng_query_role_extract, law qse-v2-role-00."""
from __future__ import annotations

from role_lexicon import (
    CLS_CTX,
    CLS_ENTITY,
    CLS_NEG,
    CLS_REL,
    CLS_RELCTX,
    CLS_SKIP,
    LEX,
    MAX_BYTES,
    MAX_WORD,
    MAX_WORDS,
)

ST_IDLE, ST_SUBJ, ST_REL, ST_OBJ = 0, 1, 2, 3


def crc16_byte(crc: int, b: int) -> int:
    crc ^= (b << 8)
    for _ in range(8):
        if crc & 0x8000:
            crc = ((crc << 1) & 0xFFFF) ^ 0x1021
        else:
            crc = (crc << 1) & 0xFFFF
    return crc


def rotl1(c: int) -> int:
    c &= (1 << 64) - 1
    return ((c << 1) | (c >> 63)) & ((1 << 64) - 1)


def bindb(c: int, b: int) -> int:
    return rotl1(c) ^ b


def lookup(word: str) -> tuple[bool, int, int]:
    hit = False
    hcls = hid = 0
    try:
        ascii_w = word.encode("latin1").decode("ascii")
    except UnicodeDecodeError:
        ascii_w = None
    if ascii_w is None:
        return False, 0, 0
    for ww, cls, iid in LEX:
        if ww == ascii_w:
            if not hit:
                hit, hcls, hid = True, cls, iid
            elif cls == hcls and iid < hid:
                hid = iid
    return hit, hcls, hid


def fold_word(word: str, st):
    (
        sid, oid, rid, xid,
        scue, ocue, rcue, xcue,
        sh, oh, rh, xh,
        neg, amb, hyp_alt, st,
    ) = st
    w = word.encode("latin1")
    hit, hcls, hid = lookup(word)
    bcue = 0
    for x in w:
        bcue = bindb(bcue, x)
    cls = hcls
    if hit and hcls == CLS_RELCTX:
        hyp_alt = 1
        if st == ST_SUBJ:
            cls = CLS_REL
        else:
            cls = CLS_CTX
    if (not hit) or cls == CLS_SKIP:
        if not hit:
            xcue ^= bcue
        return (
            sid, oid, rid, xid,
            scue, ocue, rcue, xcue,
            sh, oh, rh, xh,
            neg, amb, hyp_alt, st,
        )
    if cls == CLS_NEG:
        neg = 1
        return (
            sid, oid, rid, xid,
            scue, ocue, rcue, xcue,
            sh, oh, rh, xh,
            neg, amb, hyp_alt, st,
        )
    if cls == CLS_CTX:
        if not xh:
            xid = hid
        xcue ^= bcue
        xh = 1
        return (
            sid, oid, rid, xid,
            scue, ocue, rcue, xcue,
            sh, oh, rh, xh,
            neg, amb, hyp_alt, st,
        )
    if cls == CLS_ENTITY:
        if rh and (not sh) and (not oh):
            oid = hid
            ocue = bcue
            oh = 1
            st = ST_OBJ
        elif not sh:
            sid = hid
            scue = bcue
            sh = 1
            st = ST_REL if rh else ST_SUBJ
        elif rh and not oh:
            oid = hid
            ocue = bcue
            oh = 1
            st = ST_OBJ
        elif not oh:
            oid = hid
            ocue = bcue
            oh = 1
            amb = 1
            st = ST_OBJ
        else:
            amb = 1
        return (
            sid, oid, rid, xid,
            scue, ocue, rcue, xcue,
            sh, oh, rh, xh,
            neg, amb, hyp_alt, st,
        )
    if cls == CLS_REL:
        if not rh:
            rid = hid
            rcue = bcue
            rh = 1
            if sh:
                st = ST_REL
        else:
            amb = 1
        return (
            sid, oid, rid, xid,
            scue, ocue, rcue, xcue,
            sh, oh, rh, xh,
            neg, amb, hyp_alt, st,
        )
    xcue ^= bcue
    return (
        sid, oid, rid, xid,
        scue, ocue, rcue, xcue,
        sh, oh, rh, xh,
        neg, amb, hyp_alt, st,
    )


def extract_bytes(raw: list[int]) -> dict:
    raw = [int(b) & 0xFF for b in raw]
    crc = 0xFFFF
    sid = oid = rid = xid = 0
    scue = ocue = rcue = xcue = 0
    sh = oh = rh = xh = 0
    neg = amb = hyp_alt = 0
    st = ST_IDLE
    n_words = 0
    n_bytes = 0
    cur: list[int] = []

    def flush():
        nonlocal sid, oid, rid, xid, scue, ocue, rcue, xcue
        nonlocal sh, oh, rh, xh, neg, amb, hyp_alt, st, n_words, cur
        if not cur or n_words >= MAX_WORDS:
            cur = []
            return
        w = bytes(cur).decode("latin1")
        (
            sid, oid, rid, xid,
            scue, ocue, rcue, xcue,
            sh, oh, rh, xh,
            neg, amb, hyp_alt, st,
        ) = fold_word(
            w,
            (
                sid, oid, rid, xid,
                scue, ocue, rcue, xcue,
                sh, oh, rh, xh,
                neg, amb, hyp_alt, st,
            ),
        )
        n_words += 1
        cur = []

    for b in raw:
        if n_bytes >= MAX_BYTES or n_words >= MAX_WORDS:
            break
        crc = crc16_byte(crc, b)
        n_bytes += 1
        if b == 0x20:
            flush()
        else:
            lc = b + 32 if 65 <= b <= 90 else b
            if len(cur) < MAX_WORD:
                cur.append(lc)
    flush()
    k0 = ((sid & 0xFF) << 8) | (rid & 0xFF)
    k1 = ((oid & 0xFF) << 8) | (rid & 0xFF)
    k2 = scue & 0xFFFF
    k3 = ocue & 0xFFFF
    v0 = 1 if (sh and rh) else 0
    v1 = 1 if (oh and rh) else 0
    v2 = 1 if sh else 0
    v3 = 1 if oh else 0
    triple = 1 if (sh and rh and oh) else 0
    n_hyp = 2 if hyp_alt else 1
    return {
        "subj_id": sid,
        "obj_id": oid,
        "rel_id": rid,
        "ctx_id": xid,
        "direction": 1 if (rh and oh and not sh) else 0,
        "negation": neg,
        "ambiguity": amb,
        "triple_valid": triple,
        "n_hyp": n_hyp,
        "subj_cue": scue,
        "obj_cue": ocue,
        "rel_cue": rcue,
        "ctx_cue": xcue,
        "crc16_dbg": crc,
        "k0": k0,
        "k1": k1,
        "k2": k2,
        "k3": k3,
        "k0_valid": v0,
        "k1_valid": v1,
        "k2_valid": v2,
        "k3_valid": v3,
        "valid_mask": (v3 << 3) | (v2 << 2) | (v1 << 1) | v0,
        "subj_bind": sh,
        "obj_bind": oh,
        "rel_bind": rh,
        "ctx_bind": xh,
        "n_host": 0,
    }


def extract(text: str) -> dict:
    raw = text.encode("latin1", "ignore")
    return extract_bytes(list(raw))
