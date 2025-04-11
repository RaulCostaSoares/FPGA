`timescale 1ns/100ps

module tb_display;

  logic[3:0] data;
  
  logic a;
  logic b;
  logic c;
  logic d;
  logic e;
  logic f;
  logic g;

  display display1(
    .a(a), .b(b), .c(c), .d(d),
    .e(e), .f(f), .g(g),
    .data(data)
  );

  initial begin
    for (int i = 0; i < 10; i++) begin
      data <= i; #2;
    end
  end
endmodule
