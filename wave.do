onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate tb_final/cmd
add wave -noupdate tb_final/reset 
add wave -noupdate tb_final/clock 
add wave -noupdate tb_final/d0
add wave -noupdate tb_final/d1
add wave -noupdate tb_final/d2
add wave -noupdate tb_final/d3
add wave -noupdate tb_final/d4
add wave -noupdate tb_final/d5
add wave -noupdate tb_final/d6
add wave -noupdate tb_final/d7
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {377768 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
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


WaveRestoreZoom {0 ns} {200 ns}
view wave 
WaveCollapseAll -1
