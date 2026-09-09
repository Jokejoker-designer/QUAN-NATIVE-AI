# Versioned table for qse-v2-role-00. Do not encode exam sentences as ROM.
# Words are lookup entries; subject/object come from grammar, not min-ID.
LAW = "qse-v2-role-00"
MAX_WORD = 12
MAX_BYTES = 48
MAX_WORDS = 8

# class: 1 entity  2 relation-verb  3 context  4 dual rel/ctx ("supply")
#        5 negation  6 skip
CLS_ENTITY = 1
CLS_REL = 2
CLS_CTX = 3
CLS_RELCTX = 4
CLS_NEG = 5
CLS_SKIP = 6

REL_SUPPLY = 1
REL_REQUIRE = 2
REL_CONNECT = 3

# (word, class, id)
LEX = [
    # entities — same family ids as v1, grammar (not min-id) assigns role
    ("chiller", 1, 1), ("condenser", 1, 2), ("condensing", 1, 2),
    ("evaporator", 1, 3), ("evap", 1, 3), ("compressor", 1, 4),
    ("refrigerant", 1, 5), ("r410a", 1, 5), ("r32", 1, 5),
    ("ahu", 1, 6), ("handler", 1, 6), ("handling", 1, 6),
    ("duct", 1, 7), ("ductwork", 1, 7), ("vav", 1, 8), ("variable", 1, 8),
    ("tower", 1, 9), ("ct", 1, 9), ("pump", 1, 10),
    ("valve", 1, 11), ("txv", 1, 11), ("sensor", 1, 12),
    # relation verbs (not v1 class-3 nouns). "supply" is dual, not here.
    ("supplies", 2, REL_SUPPLY),
    ("require", 2, REL_REQUIRE), ("requires", 2, REL_REQUIRE),
    ("connect", 2, REL_CONNECT), ("connects", 2, REL_CONNECT),
    # context (v1 class-4 minus supply)
    ("water", 3, 1), ("air", 3, 1), ("dx", 3, 1), ("scroll", 3, 1),
    ("return", 3, 1), ("chilled", 3, 1), ("pressure", 3, 1), ("temp", 3, 1),
    ("dp", 3, 1), ("expansion", 3, 1), ("solenoid", 3, 1), ("cooling", 3, 1),
    ("cell", 3, 1), ("fan", 3, 1), ("test", 3, 1),
    # dual: relation after a subject, else context ("supply duct")
    ("supply", 4, REL_SUPPLY),
    # negation
    ("not", 5, 1), ("no", 5, 1), ("never", 5, 1),
    # function words
    ("a", 6, 1), ("an", 6, 1), ("the", 6, 1), ("to", 6, 1), ("of", 6, 1),
    ("does", 6, 1), ("what", 6, 1), ("is", 6, 1), ("do", 6, 1),
    ("for", 6, 1), ("and", 6, 1),
]
