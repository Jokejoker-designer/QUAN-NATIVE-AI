import numpy as np
import random

V, E, H, SCALE, MAX = 256, 8, 32, 16.0, 6
EOS = 0
TRAIN = ["pump", "valv", "tank", "pipe"]
HELD = ["hose", "drum", "vent", "bolt"]


def ctx_f(dst, src):
    s = f"F {dst} {src}>{dst}"
    assert len(s) == 16
    return s.encode()


def rows(ents):
    o = []
    for src in ents:
        for dst in ents:
            if src == dst:
                continue
            o.append((ctx_f(dst, src), src))
    return o


train = rows(TRAIN)
held = rows(HELD)
rng = np.random.default_rng(3)
We = rng.normal(0, 0.15, (V, E))
Wxh = rng.normal(0, 0.1, (H, E))
np.fill_diagonal(Wxh[:E, :], 0.8)
Whh = rng.normal(0, 0.05, (H, H))
np.fill_diagonal(Whh, 0.4)
bh = np.zeros(H)
by = np.full(V, -4.0)
by[32:127] = 0
by[EOS] = -0.5


def step(h, tok):
    e = We[tok]
    acc = bh + Wxh @ e + Whh @ h
    return np.clip(acc / SCALE, -127, 127), e


def softmax(x):
    z = x - x.max()
    e = np.exp(np.clip(z, -30, 30))
    return e / e.sum()


def train_one(ctx, ans, lr):
    global We, Wxh, Whh, bh, by
    h = np.zeros(H)
    hs = [h.copy()]
    toks = []
    for b in ctx:
        h, _ = step(h, b)
        hs.append(h.copy())
        toks.append(int(b))
    tgt = [ord(c) for c in ans] + [EOS]
    last = 0
    dh = [hs[-1].copy()]
    dtok = [last]
    des = []
    loss = 0.0
    for t in tgt:
        e = We[last]
        acc = bh + Wxh @ e + Whh @ dh[-1]
        h = np.clip(acc / SCALE, -127, 127)
        lg = by + We[:, :E] @ h[:E]
        p = softmax(lg)
        loss += -np.log(max(p[t], 1e-12))
        dh.append(h)
        dtok.append(t)
        des.append(e)
        last = t
    gWe = np.zeros_like(We)
    gWxh = np.zeros_like(Wxh)
    gWhh = np.zeros_like(Whh)
    gbh = np.zeros_like(bh)
    gby = np.zeros_like(by)
    gh = np.zeros(H)
    for i in range(len(tgt) - 1, -1, -1):
        h = dh[i + 1]
        hprev = dh[i]
        e = des[i]
        t = tgt[i]
        last = dtok[i]
        lg = by + We[:, :E] @ h[:E]
        p = softmax(lg)
        ds = p.copy()
        ds[t] -= 1
        gby += ds
        gWe[:, :E] += np.outer(ds, h[:E])
        gh_out = np.zeros(H)
        gh_out[:E] += We[:, :E].T @ ds
        gh_out += gh
        gacc = gh_out / SCALE
        gbh += gacc
        gWxh += np.outer(gacc, e)
        gWhh += np.outer(gacc, hprev)
        gWe[last] += Wxh.T @ gacc
        gh = Whh.T @ gacc
    for i in range(len(ctx) - 1, -1, -1):
        hprev = hs[i]
        tok = toks[i]
        e = We[tok]
        gacc = gh / SCALE
        gbh += gacc
        gWxh += np.outer(gacc, e)
        gWhh += np.outer(gacc, hprev)
        gWe[tok] += Wxh.T @ gacc
        gh = Whh.T @ gacc
    for arr, g in ((We, gWe), (Wxh, gWxh), (Whh, gWhh), (bh, gbh), (by, gby)):
        arr -= lr * np.clip(g, -8, 8)
        np.clip(arr, -20, 20, out=arr)
    return loss


def greedy(ctx):
    h = np.zeros(H)
    for b in ctx:
        h, _ = step(h, int(b))
    last = 0
    out = []
    for _ in range(MAX):
        e = We[last]
        acc = bh + Wxh @ e + Whh @ h
        h = np.clip(acc / SCALE, -127, 127)
        lg = by + We[:, :E] @ h[:E]
        v = int(lg.argmax())
        out.append(v)
        last = v
        if v == EOS:
            break
    return out


def body(seq):
    return "".join(chr(t) for t in seq if t != EOS and 32 <= t <= 126)


def acc(data):
    ok = 0
    for ctx, ans in data:
        if body(greedy(ctx)).startswith(ans):
            ok += 1
    return ok / len(data)


py = random.Random(3)
for ep in range(80):
    py.shuffle(train)
    tot = 0.0
    lr = 0.08 if ep < 25 else 0.03 if ep < 50 else 0.01
    for ctx, ans in train:
        tot += train_one(ctx, ans, lr)
    if ep % 10 == 0 or ep == 79:
        print(
            f"EP {ep} loss={tot/len(train):.3f} train={acc(train):.3f} held={acc(held):.3f}",
            flush=True,
        )
print("EX", [(a, body(greedy(c))) for c, a in held[:4]])
