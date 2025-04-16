`timescale 1ns/100ps
//tem que terminar
module tb_final;

  logic[3:0] cmd;
  
  logic d0;
  logic d1;
  logic d2;
  logic d3;
  logic d4;
  logic d5;
  logic d6;
  logic d7;

  calculadora_top topo(
    .d0(d0), //aquilo tudo e mais o reset e o clock
    .cmd(cmd)
  );
//fazer logica do clock 

  initial begin
    for (int i = 0; i < 10; i++) begin
      data <= i; #2;
    end
  end
endmodule
