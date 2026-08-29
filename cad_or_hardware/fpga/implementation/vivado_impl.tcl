# Vivado Implementation TCL for Nexys A7 (XC7A100T)

set project_name "safety_subsystem"
set part "xc7a100tcsg324-1"

create_project $project_name ./vivado_project -part $part -force

# Add sources
add_files [glob source_code/rtl/*/*.sv]
set_property file_type SystemVerilog [get_files *.sv]

# Add constraints
add_files prototype/fpga/constraints/nexys_a7.xdc

# Run synthesis
synth_design -top safety_subsystem_top -part $part

# Run implementation
opt_design
place_design
route_design

# Generate bitstream
write_bitstream -force ./prototype/fpga/bitstreams/safety_subsystem.bit

# Reports
report_utilization -file ./documentation/testing_report/utilization.rpt
report_timing -file ./documentation/testing_report/timing.rpt
report_power -file ./documentation/testing_report/power.rpt

close_project
