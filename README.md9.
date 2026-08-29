# Safety & Reliability Subsystem

## Overview
This repository contains the complete design, verification, and documentation for a safety-critical subsystem targeting **SIL 3 / ASIL-D** compliance. The subsystem integrates:

- **Hamming (39,32) SEC-DED ECC** — Single-bit correction, double-bit detection
- **Independent Watchdog (IWDG)** — 500 ms timeout with independent RC oscillator
- **Dual-Core Lockstep Comparator** — Cycle-by-cycle pipeline output comparison
- **2-out-of-3 Voter** — Safety-critical output voting with diagnostic coverage
- **LBIST Controller** — STUMPS-based scan BIST with MISR signature analysis

## Repository Structure
| Directory | Contents |
|-----------|----------|
| `research/` | Academic papers, terminology glossary |
| `literature_review/` | Comparative surveys of ECC, watchdogs, fault tolerance |
| `benchmarking/` | Overhead analysis, latency comparisons, area estimates |
| `system_architecture/` | Architecture specs, interface control docs, SysML models, diagrams |
| `prototype/` | FPGA constraints (Nexys A7, Arty A7), demo scripts, testbench |
| `source_code/` | SystemVerilog RTL, UVM testbenches, synthesis scripts |
| `cad_or_hardware/` | Yosys synthesis scripts, Vivado implementation TCL |
| `documentation/` | Engineering report, testing report, user manual, presentations |
| `testing/` | Unit tests, integration plans, formal properties, regression configs |

## Quick Start
```bash
# Install toolchain (Ubuntu/WSL)
sudo apt install verilator yosys gtkwave python3-pandas

# Run lint on ECC encoder
verilator --lint-only source_code/rtl/ecc/hamming_ecc_encoder.sv

# Run synthesis
yosys -s source_code/scripts/synth_yosys.sh
