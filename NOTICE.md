# NOTICE

**QUAN NATIVE AI** is a public research export of the Astra Native AI / Arty A7-100T project.

## Research publication

RTL, contracts, testbenches, closeouts, and audit notes in this tree are published so independent engineers and other AI systems can follow the design and locate remaining errors.

This snapshot does **not** grant:

- a right to redistribute Xilinx, AMD, Digilent, or Micron IP
- a `BOARD_PASS` or product warranty
- permission to treat chat summaries as frozen contracts

## Third-party IP

- **Xilinx / AMD Vivado MIG** is not shipped as generated `user_design` RTL. Only `mig_7series_0.xci`, `mig.prj`, and user constraints are included. Regenerate MIG inside your licensed Vivado install (Digilent Arty A7 official AXI MIG).
- Board pinouts follow Digilent Arty A7-100T documentation. Confirm against the current board manual before programming silicon.
- Do not commit license keys, `mcp.json` secrets, or UART dumps that contain private teacher content.

## Evidence honesty

XSim PASS ≠ board PASS. Named this-gate bags ≠ Master C3–C6 CLOSED. If `CLOSEOUT.md` and a later plan disagree, the recorded command+marker wins until a new run is logged.

## Contact / lineage

GitHub account: [Jokejoker-designer](https://github.com/Jokejoker-designer).  
Historical working remotes: `FPGG_ART_Y`, `arty-a7-online-lm`.
