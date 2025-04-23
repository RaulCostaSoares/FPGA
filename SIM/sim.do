if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

vlog -work work ../SVs/Display.sv
vlog -work work ../SVs/Display_Ctrl.sv
vlog -work work ../SVs/Calculadora.sv
vlog -work work ../SVs/Calculadora_Top.sv

vlog -work work tb_final.sv
vsim -voptargs=+acc work.tb_final

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 100ns

