onerror {resume}
quietly WaveActivateNextPane {} 0
# add waves here you want to observe
# Fore more information http://www.tkt.cs.tut.fi/tools/public/tutorials/mentor/modelsim/getting_started/gsms.html

add wave -noupdate -divider {LED Ouputs}
add wave -noupdate /de1_top_tb/dut/u2/input
add wave -noupdate /de1_top_tb/dut/u2/mask
add wave -noupdate /de1_top_tb/dut/u2/output
add wave -noupdate /de1_top_tb/dut/u3/input
add wave -noupdate /de1_top_tb/dut/u3/mask
add wave -noupdate /de1_top_tb/dut/u3/output
add wave -noupdate /de1_top_tb/dut/u4/input
add wave -noupdate /de1_top_tb/dut/u4/mask
add wave -noupdate /de1_top_tb/dut/u4/output
add wave -noupdate /de1_top_tb/dut/u5/input
add wave -noupdate /de1_top_tb/dut/u5/mask
add wave -noupdate /de1_top_tb/dut/u5/output
add wave -noupdate /de1_top_tb/dut/u6/input
add wave -noupdate /de1_top_tb/dut/u6/mask
add wave -noupdate /de1_top_tb/dut/u6/output
add wave -noupdate /de1_top_tb/dut/u7/input
add wave -noupdate /de1_top_tb/dut/u7/mask
add wave -noupdate /de1_top_tb/dut/u7/output

add wave -noupdate -divider {Reset Key}
add wave -noupdate /de1_top_tb/dut/key(0)

add wave -noupdate -divider {Switch Keys}
add wave -noupdate /de1_top_tb/dut/sw(0)
add wave -noupdate /de1_top_tb/dut/sw(1)
add wave -noupdate /de1_top_tb/dut/sw(2)
add wave -noupdate /de1_top_tb/dut/sw(3)
add wave -noupdate /de1_top_tb/dut/sw(9)

add wave -noupdate -divider {Miscellaneous}
add wave -noupdate /de1_top_tb/dut/u8/next_state
add wave -noupdate /de1_top_tb/dut/u8/head_state
add wave -noupdate /de1_top_tb/dut/u8/reset_a
add wave -noupdate /de1_top_tb/dut/u8/count
add wave -noupdate /de1_top_tb/dut/u8/state_out

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
