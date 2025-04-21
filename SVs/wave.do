onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate Calculadora_tb/cmd
add wave -noupdate Calculadora_tb/reset 
add wave -noupdate Calculadora_tb/clock
add wave -noupdate Calculadora_tb/data 
add wave -noupdate Calculadora_tb/d0
add wave -noupdate Calculadora_tb/d1
add wave -noupdate Calculadora_tb/d2
add wave -noupdate Calculadora_tb/d3
add wave -noupdate Calculadora_tb/d4
add wave -noupdate Calculadora_tb/d5
add wave -noupdate Calculadora_tb/d6
add wave -noupdate Calculadora_tb/d7

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
WaveRestoreZoom {0 ns} {1050 us}
view wave 
WaveCollapseAll -1
