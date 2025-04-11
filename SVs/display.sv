module display(
  input logic[3:0] data,
  output logic a,
  output logic b,
  output logic c,
  output logic d,
  output logic e,
  output logic f,
  output logic g,
);

  logic[7:0][10] ff = {
    "1111110_0", // 0
    "1100000_0", // 1
    "1101101_0", // 2
    "1111001_0", // 3
    "0110011_0", // 4
    "1011011_0", // 5
    "0011111_0", // 6
    "1110000_0", // 7
    "1111111_0", // 8
    "1110011_0"  // 9
  };

  assign a = ff[0][data];
  assign b = ff[1][data];
  assign c = ff[2][data];
  assign d = ff[3][data];
  assign e = ff[4][data];
  assign f = ff[5][data];
  assign g = ff[6][data];
  

endmodule
