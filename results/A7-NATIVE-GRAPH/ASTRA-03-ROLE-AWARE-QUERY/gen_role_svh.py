#!/usr/bin/env python3
"""Bag wrapper: generate qse_role_lexicon.svh from RTL qse-v2-role-00 table."""
import runpy
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
runpy.run_path(str(ROOT / "rtl" / "native_graph" / "query" / "gen_role_lexicon.py"), run_name="__main__")
