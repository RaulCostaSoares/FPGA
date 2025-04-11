module Calac (

input  logic reset,
input  logic clk,
input  logic [3:0] cmd,

output logic [1:0] status,
output logic [3:0] data,
output logic [3:0] positions

);

reg [3:0] reg1, reg2;


always @ (posedge clk, negedge reset)

while (reset == 1)