#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 -name {clock_50} [get_ports CLOCK_50]
create_clock -period "27 MHz" -name {clock_27}  [get_ports TD_CLK27]

#set_clock_groups -asynchronous -group [get_clocks {clock_50}]
#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks

#set_clock_groups -asynchronous -group [get_clocks {clock_27}] -group [get_clocks {clock_50}]
set_clock_groups -asynchronous\
-group [get_clocks {plla|clocka_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]\
-group [get_clocks {pllb|clockb_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]

#set_false_path -from {clocka_fifo:inbound|dcfifo:*} -to {wumpus:wm|data_out[*]}
#set_false_path -from {clocka_fifo:inbound|dcfifo:dcfifo_component|dcfifo_k4p1:auto_generated*} -to {wumpus:wm|stage*[*]}
#set_false_path -from {clocka_fifo:inbound|dcfifo:dcfifo_component|dcfifo_k4p1:auto_generated|dffpipe_1v8:ws_bwp|dffe13a[1]} -to {wumpus:wm|stage1[2]}

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************
# Board Delay (Data) + Propagation Delay - Board Delay (Clock)
#set_input_delay -max -clock clk_dram -0.048 [get_ports DRAM_DQ*]
#set_input_delay -min -clock clk_dram -0.057 [get_ports DRAM_DQ*]


#**************************************************************
# Set Output Delay
#**************************************************************
# max : Board Delay (Data) - Board Delay (Clock) + tsu (External Device)
# min : Board Delay (Data) - Board Delay (Clock) - th (External Device)
#set_output_delay -max -clock clk_dram 1.452  [get_ports DRAM_DQ*]
#set_output_delay -min -clock clk_dram -0.857 [get_ports DRAM_DQ*]




#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************


# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]




