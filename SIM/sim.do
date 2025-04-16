if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

vlog -work work ../SVs/display.sv
vlog -work work ../SVs/ctrl.sv
vlog -work work ../SVs/calculadora.sv
vlog -work work ../SVs/calculadora_top.sv
vlog -work work tb_final.sv
vsim -voptargs=+acc work.tb_final

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 100ns

