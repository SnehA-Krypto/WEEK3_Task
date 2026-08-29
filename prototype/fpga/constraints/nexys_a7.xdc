## Nexys A7 (XC7A100T) Constraints for Safety Subsystem

## Clock
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports sys_clk]
create_clock -period 10.000 -name sys_clk [get_ports sys_clk]

## Independent Watchdog Clock (simulated via divided clock)
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports iwdg_clk]

## Reset
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports rst_n]

## Watchdog Feed (btnC)
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports wdi]

## ECC Data In (switches)
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {ecc_data_in[0]}]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {ecc_data_in[1]}]
# ... (continue for all 39 bits, mapped to switches + buttons)

## ECC Data Out (LEDs)
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {ecc_data_out[0]}]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {ecc_data_out[1]}]
# ... (continue for all 32 bits)

## Error Outputs (RGB LED)
set_property -dict {PACKAGE_PIN R11 IOSTANDARD LVCMOS33} [get_ports error_n]
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports ecc_panic]

## Voter Inputs (buttons)
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports voter_a]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports voter_b]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports voter_c]

## Voter Output (LED)
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports voter_out]

## Configuration
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
