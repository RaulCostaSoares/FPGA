if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

vlog -work work -sv Display.sv
vlog -work work -sv Display_Ctrl.sv
vlog -work work -sv Calculadora.sv
vlog -work work -sv Calculadora_Top.sv


#TA DANDO ERRO
vlog -work work -sv Calculadora_tb

#ERROOOO
vsim work.Calculadora_tb


quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do

run 1ns
