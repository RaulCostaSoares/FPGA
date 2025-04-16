// PARA TERMINAR --> logica para as posicoes no display
module Calculadora(
    input logic [3:0] cmd,
    input logic reset,
    input logic clock, 

    output logic [1:0] status,
    output logic [3:0] pos, 
    output logic [3:0] data
);

typedef enum logic [1:0] {ERRO, PRONTA, OCUPADA} statetype;
statetype estados;

// Sinais internos
reg [31:0] reg1, reg2, saida, contador;
reg [3:0] op;
reg set_op;

assign status = estados; 
assign data = saida;

always @(posedge clock or negedge reset) begin
    if (reset == 1) begin
        estados  <= PRONTA;
        op       <= 4'b1010;
        pos      <= 4'b0000;
        set_op   <= 0;
        reg1     <= 32'd0;
        reg2     <= 32'd0;
        saida    <= 32'd0;
        contador <= 32'd0;
    end else begin
        case (estados)
            PRONTA: begin
                if (cmd < 10 && !set_op) begin
                    reg1 <= (reg1 * 10) + cmd;
                end 
                else if (cmd < 10 && set_op) begin 
                    reg2 <= (reg2 * 10) + cmd;
                end 
                else if (cmd == 4'b1110) begin // teste se digitou igual
                    case (op)
                        4'b1010: saida <= reg1 + reg2;
                        4'b1011: saida <= reg1 - reg2;
                        4'b1100: begin
                            if (reg2 == 0) begin
                                saida <= 0;
                            end
                            else begin
                                saida <= 0;
                                contador <= 0;
                                estados <= OCUPADA;
                            end
                        end
                        4'b1111: begin
                            if (set_op)
                                reg2 <= reg2 / 10;
                            else
                                reg1 <= reg1 / 10;
                        end
                        default: estados <= ERRO;
                    endcase
                end else begin
                    op     <= cmd;
                    set_op <= 1;
                end

                if ((!set_op && reg1 > 32'd99999999) || (set_op && reg2 > 32'd99999999)) begin
                    estados <= ERRO;
                end
            end

            ERRO: begin
                if (cmd == 4'b1111) begin
                    estados  <= PRONTA;
                    reg1     <= 0;
                    reg2     <= 0;
                    saida    <= 0;
                    op       <= 0;
                    set_op   <= 0;
                    contador <= 0;
                end
            end

            OCUPADA: begin
                if (contador < reg2) begin
                    saida    <= saida + reg1;
                    contador <= contador + 1;
                end else begin
                    contador <= 0;
                    if (saida > 32'd99999999)
                        estados <= ERRO;
                    else
                        estados <= PRONTA;
                end
            end
        endcase
    end
end
    
endmodule
