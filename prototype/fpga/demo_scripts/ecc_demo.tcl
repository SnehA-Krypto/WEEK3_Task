# ECC Demo Script for Vivado Hardware Manager
# Connect to Nexys A7 and demonstrate ECC correction/detection

open_hw_manager
connect_hw_server
open_hw_target
set_property PROGRAM.FILE {./prototype/fpga/bitstreams/safety_subsystem.bit} [get_hw_devices xc7a100t_0]
program_hw_devices [get_hw_devices xc7a100t_0]

# Set initial data
set data 0x12345678
puts "Writing test data: $data"

# Inject 1-bit error
set error_data [expr {$data ^ 0x00000004}]
puts "Injecting 1-bit error: $error_data"

# Read corrected output
# (Implementation depends on ILA/VIO integration)

puts "ECC Demo complete. Check LEDs for corrected output and panic signal."
