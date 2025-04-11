/*
protocolo da calculadora:
0000 - 0
0001 - 1
0010 - 2
0011 - 3
0100 - 4
0101 - 5
0110 - 6
0111 - 7
1000 - 8
1001 - 9
1010 - soma
1011 - sub
1100 - mult
1101 - -----
1110 - igual
1111 - apagar
*/

/*  ESTADOS
ERRO: quando digit digitado for maior que 8
PRONTA: nenhuma operacao sendo executada
OCUPADA:  enquanto tiver nos ciclos de multiplicacao
*/
module calculadora(
    input logic [3:0] cmd,
    input logic reset,
    input logic clock, 

    output logic [1:0] status,
    output logic [3:0] pos, 
    output logic [3:0] data, 

);

ctrl controlador(
    .clock(clock),
    .reset(reset),
    .data(data),
    .pos(pos)
);

always @(posedge clock, negedge reset) begin
    if(reset = 1) begin
    end

end 