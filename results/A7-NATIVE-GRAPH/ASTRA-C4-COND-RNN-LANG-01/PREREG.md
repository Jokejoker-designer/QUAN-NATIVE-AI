# PREREG — ASTRA-C4-COND-RNN-LANG-01

PROGRAM=NO. Language measurement of unedited rival-1 `a7ng_astra_c4_cond_rnn`
with a bag-local locally trained int8 hex. Does not edit KEEP grounded_gen,
live prod_top, TinyGPT hex, or rival-1 causality hex `46b81cd7…`.

Corpus: 16-byte packed QUERY/PROOF (`F dst src>dst` answer=src;
`R src src>dst` answer=dst). Train entities pump/valv/tank/pipe. Held-out
entities hose/drum/vent/bolt. No cloud. No answer field at query time;
the answer entity appears only inside the proof span.

Unknown: held-out grounded accuracy >=90%, evid_has=0 safe >=95%,
unrelated evid_has=1 hallucinated fact <=5%.

Does not stamp C4_MASTER even if those thresholds HIT.
