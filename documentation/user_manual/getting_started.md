# Getting Started with the Safety Subsystem

## Prerequisites
- Ubuntu 20.04+ or WSL2
- Verilator 5.x
- Yosys + nextpnr
- GTKWave
- Python 3.8+ with pandas
- Digilent Nexys A7 (optional, for hardware demo)

## Quick Start
```bash
# Clone repository
cd safety-reliability-subsystem

# Run lint
./source_code/scripts/lint_verilator.sh

# Run unit simulation
cd source_code/tb/ecc
iverilog -g2012 -o ecc_tb hamming_ecc_tb_top.sv ../../rtl/ecc/*.sv
vvp ecc_tb
gtkwave ecc_tb.vcd

# Synthesize for FPGA
./source_code/scripts/synth_yosys.sh

# Program Nexys A7 (with Vivado)
vivado -mode batch -source cad_or_hardware/fpga/implementation/vivado_impl.tcl
