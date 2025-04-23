`timescale 1ns/1ps

module tb_final #();

  reg[3:0] cmd;
  reg reset;
  reg clock;
  
  reg [7:0] d0, d1, d2, d3, d4, d5, d6, d7;

  Calculadora_Top topo(
    .cmd(cmd),
    .reset(reset),
    .clock(clock),
    .d0(d0),
    .d1(d1),
    .d2(d2),
    .d3(d3),
    .d4(d4),
    .d5(d5),
    .d6(d6),
    .d7(d7)
  );

  initial clock = 0;
  always #5 clock = ~clock;

  initial begin
    reset = 1;
    #10
    reset = 0;
    #10
    cmd = 0001;  //  entrada 1
    #10
    cmd = 1010; // entrada operacao +
    #10
    cmd = 0001; // entrada 1
    #10
    cmd = 1110; // entrada =
    #10
    cmd = 0011; // entrada 3
    #10
    cmd = 1011; // entrada - 
    #10
    cmd = 0010; // entrada 1
    #10
    cmd = 1110; // entrada =
    #10 $finish
  end 

endmodule: tb_final