#******************************************************************************
#                                                                             *
#                  Copyright (C) 2009 Altera Corporation                      *
#                                                                             *
# ALTERA, ARRIA, CYCLONE, HARDCOPY, MAX, MEGACORE, NIOS, QUARTUS & STRATIX    *
# are Reg. U.S. Pat. & Tm. Off. and Altera marks in and outside the U.S.      *
#                                                                             *
# All information provided herein is provided on an "as is" basis,            *
# without warranty of any kind.                                               *
#                                                                             *
# File Name: adder_tb.do          											  *
#                                                                             *
# Function: Script file for Introduction to VHDL lab 1a                  	  *
#                                                                             *
# REVISION HISTORY:                                                           *
#  Revision 1.0    12/05/2009 - Initial Revision  for QII 9.1                 *
#******************************************************************************

vlib work
vcom snake_segment_cntrl.vhd
vcom snake_controller.vhd
vcom counter.vhd 
vcom de1_top.vhd 
# Add any additional files here 
vcom de1_top_vhdl_tb.vhd 
vsim -t ns work.de1_top_tb
view wave
do wave.do
run 100000 ns