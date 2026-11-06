## Clock Signal (100 MHz)
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk_100mhz]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_100mhz]

## Switches (SW0 - SW8 for 9-bit data_in, SW15 for circ_en)
set_property -dict { PACKAGE_PIN V17  IOSTANDARD LVCMOS33 } [get_ports {data_in[0]}]
set_property -dict { PACKAGE_PIN V16  IOSTANDARD LVCMOS33 } [get_ports {data_in[1]}]
set_property -dict { PACKAGE_PIN W16  IOSTANDARD LVCMOS33 } [get_ports {data_in[2]}]
set_property -dict { PACKAGE_PIN W17  IOSTANDARD LVCMOS33 } [get_ports {data_in[3]}]
set_property -dict { PACKAGE_PIN W15  IOSTANDARD LVCMOS33 } [get_ports {data_in[4]}]
set_property -dict { PACKAGE_PIN V15  IOSTANDARD LVCMOS33 } [get_ports {data_in[5]}]
set_property -dict { PACKAGE_PIN W14  IOSTANDARD LVCMOS33 } [get_ports {data_in[6]}]
set_property -dict { PACKAGE_PIN W13  IOSTANDARD LVCMOS33 } [get_ports {data_in[7]}]
set_property -dict { PACKAGE_PIN V2   IOSTANDARD LVCMOS33 } [get_ports {data_in[8]}]
set_property -dict { PACKAGE_PIN R2   IOSTANDARD LVCMOS33 } [get_ports circ_en]

## Pushbuttons (BTNC = Reset, BTNU = Load Strobe)
set_property -dict { PACKAGE_PIN U18  IOSTANDARD LVCMOS33 } [get_ports rst]
set_property -dict { PACKAGE_PIN T18  IOSTANDARD LVCMOS33 } [get_ports load_btn]

## PMOD Header JA (For Analog Discovery Capture)
## JA1 = serial_out, JA2 = parity_out, JA3 = clk_5mhz_out
set_property -dict { PACKAGE_PIN J1   IOSTANDARD LVCMOS33 } [get_ports serial_out]
set_property -dict { PACKAGE_PIN L2   IOSTANDARD LVCMOS33 } [get_ports parity_out]
set_property -dict { PACKAGE_PIN J2   IOSTANDARD LVCMOS33 } [get_ports clk_out]
set_property -dict { PACKAGE_PIN G2   IOSTANDARD LVCMOS33 } [get_ports load_strobe_out]

## PMOD Header JB (Shift Register Bits [7:0])
## Top row: JB1-JB4, Bottom row: JB7-JB10
set_property -dict { PACKAGE_PIN A14  IOSTANDARD LVCMOS33 } [get_ports {shift_reg_out[0]}]
set_property -dict { PACKAGE_PIN A16  IOSTANDARD LVCMOS33 } [get_ports {shift_reg_out[1]}]
set_property -dict { PACKAGE_PIN B15  IOSTANDARD LVCMOS33 } [get_ports {shift_reg_out[2]}]
set_property -dict { PACKAGE_PIN B16  IOSTANDARD LVCMOS33 } [get_ports {shift_reg_out[3]}]
set_property -dict { PACKAGE_PIN A15  IOSTANDARD LVCMOS33 } [get_ports {shift_reg_out[4]}]
set_property -dict { PACKAGE_PIN A17  IOSTANDARD LVCMOS33 } [get_ports {shift_reg_out[5]}]
set_property -dict { PACKAGE_PIN C15  IOSTANDARD LVCMOS33 } [get_ports {shift_reg_out[6]}]
set_property -dict { PACKAGE_PIN C16  IOSTANDARD LVCMOS33 } [get_ports {shift_reg_out[7]}]

## PMOD Header JC (Shift Register Bit [8] on JC1)
set_property -dict { PACKAGE_PIN K17  IOSTANDARD LVCMOS33 } [get_ports {shift_reg_out[8]}]