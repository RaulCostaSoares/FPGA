module display(
  input logic [3:0] data,
  output logic a,
  output logic b,
  output logic c,
  output logic d,
  output logic e,
  output logic f,
  output logic g,
  output logic dp
);

  logic [7:0] ff [0:9] = {
    8'b1111110_0, // 0
    8'b0110000_0, // 1
    8'b1101101_0, // 2
    8'b1111001_0, // 3
    8'b0110011_0, // 4
    8'b1011011_0, // 5
    8'b0011111_0, // 6
    8'b1110000_0, // 7
    8'b1111111_0, // 8
    8'b1110011_0  // 9
  };
  always_comb begin
    {a, b, c, d, e, f, g, dp} = 8'b00000000;
    if (data < 10) begin
      {a, b, c, d, e, f, g, dp} = ff[data];
    end 
  end


endmodule
