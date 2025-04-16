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
//sinais internos


typedef enum logic [1:0] {ERRO, PRONTA, OCUPADA} statetype;
statetype estados;

reg [31:0] reg1, reg2, op, saida;
reg set_op; // flag se o op mudou
reg op_equal;
assign status = estados; 
 //estados da calculadora

always @(posedge clock, negedge reset) begin
    if(reset == 1) begin
        estados <= PRONTA;
        reg1 <= 4'b0000;
        reg2 <= 4'b0000;
        op <= 4'b1010;
        saida <= 4'b0000;
        pos <= 4'b0000;
        set_op <= 0;
        op_equal <= 1;
    end
    else begin
        case(estados)
            PRONTA: begin
                if(cmd < 10 && !set_op) begin
                    reg1 <= (reg1 * 10) + cmd;
                end else if (cmd < 10 && set_op) begin 
                    reg2 <= (reg2 * 10) + cmd;
                end
                else begin
                    if(cmd == 1110) begin
                        op_equal = 1;
                    end
                    else begin
                        op <= cmd;
                    end
                    set_op <= 1;
                end
                if(op_equal) begin
                    case (op) 
                        4'b1001: saida <= reg1 + reg2;
                        4'b1010: saida <= reg1 - reg2;
                        4'b1011: // mult
                        4'b1100: // nao sei
                        default: 
                    endcase;
                end
            end
            ERRO: begin
                if (reg1 == 0 ) // se o reg1 tiver lotado e cmd for algum numero entao da erro, 
                // mesma coisa 
            end
            OCUPADA: begin
                // ta multiplicando
            end
            default:
                // default eh mesmo que pronta
            end
        endcase
    end
end 