onerror {resume}
quietly WaveActivateNextPane {} 0
# add waves here you want to observe
# Fore more information http://www.tkt.cs.tut.fi/tools/public/tutorials/mentor/modelsim/getting_started/gsms.html

add wave -noupdate -divider {LED Ouputs}
add wave -noupdate /de1_top_tb/dut/hex0
add wave -noupdate /de1_top_tb/dut/hex1

add wave -noupdate -divider {Reset Key}
add wave -noupdate /de1_top_tb/dut/key(0)
add wave -noupdate /de1_top_tb/dut/key(1)

add wave -noupdate -divider {Switches}
add wave -noupdate /de1_top_tb/dut/sw(0)
add wave -noupdate /de1_top_tb/dut/sw(1)

add wave -noupdate -divider {Washing Control}
add wave -noupdate /de1_top_tb/dut/u4/current_state
add wave -noupdate /de1_top_tb/dut/u4/next_state
add wave -noupdate /de1_top_tb/dut/u4/donesig
add wave -noupdate /de1_top_tb/dut/u4/donesig2
add wave -noupdate /de1_top_tb/dut/u4/donesig3
add wave -noupdate /de1_top_tb/dut/u4/start
add wave -noupdate /de1_top_tb/dut/u4/stop
add wave -noupdate /de1_top_tb/dut/u4/started

add wave -noupdate -divider {Fill Control}
add wave -noupdate /de1_top_tb/dut/u5/head_state
add wave -noupdate /de1_top_tb/dut/u5/next_state
add wave -noupdate /de1_top_tb/dut/u5/next_cycle

add wave -noupdate -divider {Wash Control}
add wave -noupdate /de1_top_tb/dut/u7/head_state
add wave -noupdate /de1_top_tb/dut/u7/next_state
add wave -noupdate /de1_top_tb/dut/u7/next_cycle
add wave -noupdate /de1_top_tb/dut/u7/second_stage

add wave -noupdate -divider {Spin Control}
add wave -noupdate /de1_top_tb/dut/u6/head_state
add wave -noupdate /de1_top_tb/dut/u6/next_state
add wave -noupdate /de1_top_tb/dut/u6/next_cycle

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20940 ns} 0}
quietly wave cursor active 1

configure wave -namecolwidth 260
configure wave -valuecolwidth 100
configure wave -justifyvalue right
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {18271 ns} {35307 ns}
