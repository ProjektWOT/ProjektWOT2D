# Constraints for CLK
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
#create_clock -name external_clock -period 10.00 [get_ports clk]

# Constraints for VS and HS
set_property PACKAGE_PIN R19 [get_ports {vs}]
set_property IOSTANDARD LVCMOS33 [get_ports {vs}]
set_property PACKAGE_PIN P19 [get_ports {hs}]
set_property IOSTANDARD LVCMOS33 [get_ports {hs}]

# Constraints for RED
set_property PACKAGE_PIN G19 [get_ports {r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]
set_property PACKAGE_PIN H19 [get_ports {r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]
set_property PACKAGE_PIN J19 [get_ports {r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[2]}]
set_property PACKAGE_PIN N19 [get_ports {r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[3]}]

# Constraints for GRN
set_property PACKAGE_PIN J17 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
set_property PACKAGE_PIN H17 [get_ports {g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]
set_property PACKAGE_PIN G17 [get_ports {g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[2]}]
set_property PACKAGE_PIN D17 [get_ports {g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[3]}]

# Constraints for BLU
set_property PACKAGE_PIN N18 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
set_property PACKAGE_PIN L18 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property PACKAGE_PIN K18 [get_ports {b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]
set_property PACKAGE_PIN J18 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]

# LEDs
#set_property PACKAGE_PIN U16 [get_ports {LED[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
#set_property PACKAGE_PIN E19 [get_ports {LED[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
#set_property PACKAGE_PIN U19 [get_ports {LED[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
#set_property PACKAGE_PIN V19 [get_ports {LED[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
#set_property PACKAGE_PIN W18 [get_ports {LED[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
#set_property PACKAGE_PIN U15 [get_ports {LED[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
#set_property PACKAGE_PIN U14 [get_ports {LED[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
#set_property PACKAGE_PIN V14 [get_ports {LED[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]


##Pmod Header JA
##Bank = 15, Pin name = IO_L1N_T0_AD0N_15,					Sch name = JA1
set_property PACKAGE_PIN A14 [get_ports {CS}]
set_property IOSTANDARD LVCMOS33 [get_ports {CS}]
##Bank = 15, Pin name = IO_L5N_T0_AD9N_15,					Sch name = JA2
set_property PACKAGE_PIN A16 [get_ports {MOSI}]
set_property IOSTANDARD LVCMOS33 [get_ports {MOSI}]
##Bank = 15, Pin name = IO_L16N_T2_A27_15,					Sch name = JA3
set_property PACKAGE_PIN B15 [get_ports {MISO}]
set_property IOSTANDARD LVCMOS33 [get_ports {MISO}]
##Bank = 15, Pin name = IO_L16P_T2_A28_15,					Sch name = JA4
set_property PACKAGE_PIN B16 [get_ports {SCLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {SCLK}]
##Bank = 15, Pin name = IO_0_15,							Sch name = JA7
#set_property PACKAGE_PIN G13 [get_ports {JA[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JA[4]}]
##Bank = 15, Pin name = IO_L20N_T3_A19_15,					Sch name = JA8
#set_property PACKAGE_PIN C17 [get_ports {JA[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JA[5]}]
##Bank = 15, Pin name = IO_L21N_T3_A17_15,					Sch name = JA9
#set_property PACKAGE_PIN D18 [get_ports {JA[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JA[6]}]
##Bank = 15, Pin name = IO_L21P_T3_DQS_15,					Sch name = JA10
#set_property PACKAGE_PIN E18 [get_ports {JA[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JA[7]}]

## Switches
#set_property PACKAGE_PIN V17 [get_ports {SW[0]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {SW[0]}]
#set_property PACKAGE_PIN V16 [get_ports {SW[1]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]
#set_property PACKAGE_PIN W16 [get_ports {SW[2]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {SW[2]}]

#7 segment display
#set_property PACKAGE_PIN W7 [get_ports {SEG[0]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[0]}]
#set_property PACKAGE_PIN W6 [get_ports {SEG[1]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[1]}]
#set_property PACKAGE_PIN U8 [get_ports {SEG[2]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[2]}]
#set_property PACKAGE_PIN V8 [get_ports {SEG[3]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[3]}]
#set_property PACKAGE_PIN U5 [get_ports {SEG[4]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[4]}]
#set_property PACKAGE_PIN V5 [get_ports {SEG[5]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[5]}]
#set_property PACKAGE_PIN U7 [get_ports {SEG[6]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[6]}]
	
#set_property PACKAGE_PIN U2 [get_ports {AN[0]}]					
 #       set_property IOSTANDARD LVCMOS33 [get_ports {AN[0]}]
 #   set_property PACKAGE_PIN U4 [get_ports {AN[1]}]                    
 #       set_property IOSTANDARD LVCMOS33 [get_ports {AN[1]}]
 #   set_property PACKAGE_PIN V4 [get_ports {AN[2]}]                    
 #       set_property IOSTANDARD LVCMOS33 [get_ports {AN[2]}]
 #   set_property PACKAGE_PIN W4 [get_ports {AN[3]}]                    
 #       set_property IOSTANDARD LVCMOS33 [get_ports {AN[3]}]
	
# Constraints for PCLK_MIRROR
set_property PACKAGE_PIN J1 [get_ports {pclk_mirror}]
set_property IOSTANDARD LVCMOS33 [get_ports {pclk_mirror}]

# Constraints for CFGBVS
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# Constraints for Reset
set_property PACKAGE_PIN W19 [get_ports {rst}]						
set_property IOSTANDARD LVCMOS33 [get_ports {rst}]

# USB HID (PS/2)
set_property PACKAGE_PIN C17 [get_ports ps2_clk]						
	set_property IOSTANDARD LVCMOS33 [get_ports ps2_clk]
	set_property PULLUP true [get_ports ps2_clk]
set_property PACKAGE_PIN B17 [get_ports ps2_data]					
	set_property IOSTANDARD LVCMOS33 [get_ports ps2_data]	
	set_property PULLUP true [get_ports ps2_data]
	
# Connect to input port when clock capable pin is selected for input
create_clock -period 10.000 [get_ports clk]
set_input_jitter [get_clocks -of_objects [get_ports clk]] 0.1
    
set_false_path -to [get_cells  -hier {*seq_reg*[0]} -filter {is_sequential}]
set_property PHASESHIFT_MODE WAVEFORM [get_cells -hierarchical *adv*]
    
set_false_path -to [get_cells  -hier {*seq_reg*[0]} -filter {is_sequential}]
# Clock Period Constraints                                 #
    ############################################################
    #create_clock -period 10.000 [get_ports clk]
