`timescale 1ns/100ps

module tb_calc;

  // ins
  logic clock = 0;
  logic reset;
  logic[3:0] cmd;
  // outs
  logic[1:0] status;
  logic[7:0] data;
  logic[7:0] pos;


  always #1 clock = ~clock; 

  caclc master1(
    .clock(clock),
    .reset(reset),
    .cmd(cmd),
    .status(status),
    .data(data),
    .pos(pos)
  );

  initial begin
    cmd = 0;
    reset = 1; #1 reset = 0;
  end  
  always @(posedge clock) begin
    // dig <= dig + 1;

    // if(dig == 4'b1111) begin
    //   pos = pos +1;
    // end

  cmd = 4'd2;
  #2
  cmd = 4'd1;
  #2
  cmd = 4'b1010;
  #2
  cmd = 4'd1;
  #2
  cmd = 4'b1110;

  end

endmodule
