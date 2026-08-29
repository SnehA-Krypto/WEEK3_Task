#!/bin/bash
set -e

TOP_MODULE="safety_subsystem_top"
RTL_DIR="source_code/rtl"
OUT_DIR="cad_or_hardware/fpga/synthesis"

mkdir -p $OUT_DIR

yosys -p "
    read_verilog -sv ${RTL_DIR}/common/*.sv
    read_verilog -sv ${RTL_DIR}/ecc/*.sv
    read_verilog -sv ${RTL_DIR}/watchdog/*.sv
    read_verilog -sv ${RTL_DIR}/lockstep/*.sv
    read_verilog -sv ${RTL_DIR}/voter/*.sv
    read_verilog -sv ${RTL_DIR}/bist/*.sv
    read_verilog -sv ${RTL_DIR}/top/*.sv
    hierarchy -top ${TOP_MODULE}
    synth_xilinx -top ${TOP_MODULE} -family xc7
    write_json ${OUT_DIR}/${TOP_MODULE}.json
    write_verilog ${OUT_DIR}/${TOP_MODULE}_synth.v
    stat
" 2>&1 | tee ${OUT_DIR}/synth.log

echo "Synthesis complete. Output in ${OUT_DIR}/"
