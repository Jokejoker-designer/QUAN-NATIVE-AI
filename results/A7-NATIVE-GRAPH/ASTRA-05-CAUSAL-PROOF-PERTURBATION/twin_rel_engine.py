"""Host twin of a7ng_rel_engine_2hop_v2. PROGRAM=NO.

Nested-loop join + polarity + scan/hop budget. No exam-sentence ROM.
"""
from __future__ import annotations

ST_ANSWER = 0
ST_UNKNOWN = 1
ST_WRONGDIR = 2
ST_NTRANS = 3
ST_CYCLE = 4
ST_CONFLICT = 5
ST_INCOMPLETE = 6

ST_NAME = {
    ST_ANSWER: "ANSWER",
    ST_UNKNOWN: "UNKNOWN",
    ST_WRONGDIR: "WRONGDIR",
    ST_NTRANS: "NTRANS",
    ST_CYCLE: "CYCLE",
    ST_CONFLICT: "CONFLICT",
    ST_INCOMPLETE: "SEARCH_INCOMPLETE",
}


class RelEngine2HopV2:
    def __init__(self, n_edges: int = 16) -> None:
        self.n = n_edges
        self.es = [0] * n_edges
        self.er = [0] * n_edges
        self.eo = [0] * n_edges
        self.eid = [0] * n_edges
        self.et = [0] * n_edges
        self.ep = [1] * n_edges
        self.ev = [0] * n_edges

    def clr(self) -> None:
        self.ev = [0] * self.n

    def load(
        self,
        idx: int,
        s: int,
        r: int,
        o: int,
        eid: int,
        trans: int = 1,
        pol: int = 1,
        keep: int = 1,
    ) -> None:
        if idx < 0 or idx >= self.n:
            return
        if keep:
            self.es[idx] = s
            self.er[idx] = r
            self.eo[idx] = o
            self.eid[idx] = eid
            self.et[idx] = 1 if trans else 0
            self.ep[idx] = 1 if pol else 0
            self.ev[idx] = 1
        else:
            self.ev[idx] = 0

    def tuples(self) -> list[tuple[int, int, int, int, int]]:
        out = []
        for i in range(self.n):
            if self.ev[i]:
                out.append((self.es[i], self.er[i], self.eo[i], self.eid[i], self.ep[i]))
        return out

    def has_tuple(self, s: int, r: int, o: int) -> bool:
        for i in range(self.n):
            if self.ev[i] and self.es[i] == s and self.er[i] == r and self.eo[i] == o and self.ep[i]:
                return True
        return False

    def query(
        self,
        s: int,
        r: int,
        o: int = 0,
        obj_valid: int = 0,
        two_hop: int = 1,
        max_scan: int = 0,
        max_hop: int = 0,
    ) -> dict:
        scan_lim = 65535 if max_scan == 0 else int(max_scan)
        scan_cnt = 0
        incomplete = 0
        conflict = 0
        wrong = 0
        ntrans = 0
        cyc = 0
        saw_neg = 0
        npos = 0
        pos0 = 0
        neg0 = 0
        e1 = 0
        e2 = 0
        ans = 0

        def take() -> bool:
            nonlocal scan_cnt, incomplete
            if scan_cnt >= scan_lim:
                incomplete = 1
                return False
            scan_cnt += 1
            return True

        if two_hop:
            if max_hop != 0 and max_hop < 2:
                incomplete = 1
            else:
                for i in range(self.n):
                    if not self.ev[i]:
                        continue
                    if not take():
                        continue
                    if self.er[i] == r and self.es[i] == s and self.ep[i]:
                        if not self.et[i]:
                            ntrans = 1
                        else:
                            for j in range(self.n):
                                if not self.ev[j]:
                                    continue
                                if not take():
                                    continue
                                if self.er[j] == r and self.es[j] == self.eo[i]:
                                    if self.eo[j] == s:
                                        cyc = 1
                                    elif not self.ep[j]:
                                        if (not obj_valid) or self.eo[j] == o:
                                            saw_neg = 1
                                            neg0 = self.eo[j]
                                            if npos != 0 and pos0 == self.eo[j]:
                                                conflict = 1
                                    elif (not obj_valid) or self.eo[j] == o:
                                        if npos != 0 and pos0 != self.eo[j]:
                                            conflict = 1
                                        if npos == 0:
                                            npos = 1
                                            pos0 = self.eo[j]
                                            e1 = self.eid[i]
                                            e2 = self.eid[j]
                                            ans = self.eo[j]
                                        if saw_neg and neg0 == self.eo[j]:
                                            conflict = 1
            if conflict:
                st = ST_CONFLICT
                ans = e1 = e2 = 0
            elif cyc:
                st = ST_CYCLE
                ans = e1 = e2 = 0
            elif incomplete and npos == 0:
                st = ST_INCOMPLETE
                ans = e1 = e2 = 0
            elif ntrans and npos == 0:
                st = ST_NTRANS
                ans = e1 = e2 = 0
            elif npos != 0:
                st = ST_ANSWER
            else:
                st = ST_UNKNOWN
                ans = e1 = e2 = 0
        else:
            for i in range(self.n):
                if not self.ev[i]:
                    continue
                if not take():
                    continue
                if self.er[i] == r and self.es[i] == s and ((not obj_valid) or self.eo[i] == o):
                    if not self.ep[i]:
                        saw_neg = 1
                        neg0 = self.eo[i]
                        if npos != 0 and pos0 == self.eo[i]:
                            conflict = 1
                    else:
                        if npos != 0 and pos0 != self.eo[i]:
                            conflict = 1
                        if npos == 0:
                            npos = 1
                            pos0 = self.eo[i]
                            e1 = self.eid[i]
                            ans = self.eo[i]
                        if saw_neg and neg0 == self.eo[i]:
                            conflict = 1
                if obj_valid and self.er[i] == r and self.es[i] == o and self.eo[i] == s:
                    wrong = 1
            if conflict:
                st = ST_CONFLICT
                ans = e1 = e2 = 0
            elif incomplete and npos == 0:
                st = ST_INCOMPLETE
                ans = e1 = e2 = 0
            elif npos != 0:
                st = ST_ANSWER
                e2 = 0
            elif wrong:
                st = ST_WRONGDIR
                ans = e1 = e2 = 0
            else:
                st = ST_UNKNOWN
                ans = e1 = e2 = 0

        return {
            "st": st,
            "st_name": ST_NAME[st],
            "ans": ans,
            "p0": e1,
            "p1": e2,
            "scan": scan_cnt,
        }
