module Calculadora(
    input  logic [3:0] cmd,  
    input  logic reset,
    input  logic clock, 

    output logic [1:0] status, 
    output logic [3:0] pos,     
    output logic [3:0] dig     
);
/*  status possiveis estados
    ERRO:    00 
    PRONTA:  01
    OCUPADA: 10 
    IMPRIME: 11

    estados_calculadora possiveis estados
*/
    typedef enum logic [1:0] {ERRO, PRONTA, OCUPADA, IMPRIME} estados_sinal;

    typedef enum logic [2:0] {
        IN_REG1, IN_OP, IN_REG2, IN_EQUAL, SEND_DIS, ERROR
    } estados_calculadora;

    estados_sinal estados_de_saida;
    estados_calculadora internal_states;

    assign status = estados_de_saida;

    reg [31:0] reg1, reg2, resultado, contador_mult, aux_resultado;
    reg [3:0]  operacao, pos_disp;

    always_ff @ (posedge clock) begin
        if (reset) begin
            internal_states <= IN_REG1;
            estados_de_saida <= PRONTA;
            reg1 <= 0;
            reg2 <= 0;
            resultado <= 0;
            operacao <= 0;
            contador_mult <= 0;
            aux_resultado <= 0;
            pos_disp <= 0;
        end else begin
            case (internal_states)
                IN_REG1: begin
                    if (cmd < 10) begin
                        reg1 <= cmd;
                        internal_states <= IN_OP;
                    end else begin
                        internal_states <= IN_REG1;
                    end
                end

                IN_OP: begin
                    if (cmd >= 4'b1010 && cmd <= 4'b1100) begin
                        operacao <= cmd;
                        internal_states <= IN_REG2;
                    end else if (cmd == 4'b1111) begin
                        reg1 <= reg1 / 10;
                        internal_states <= IN_OP;
                    end else if (cmd < 10) begin
                        reg1 <= (reg1 * 10) + cmd;
                        internal_states <= IN_OP:
                    end else begin
                        internal_states <= ERROR; // op invalido
                    end
                end

                IN_REG2: begin
                    if (cmd < 10) begin
                        reg2 <= cmd;
                        internal_states <= IN_EQUAL;
                        estados_de_saida <= OCUPADA;
                    end else begin
                        internal_states <= IN_REG2;
                    end
                end

                IN_EQUAL: begin
                    if (cmd == 4'b1111) begin
                        reg2 <= reg2 / 10;
                        internal_states <= IN_EQUAL;
                    end else if (cmd < 10) begin
                        reg2 <= (reg2 * 10) + cmd;
                        internal_states <= IN_EQUAL;
                    end else if (cmd == 4'b1110) begin
                        case (operacao)
                            4'b1010: begin // soma
                                resultado <= reg1 + reg2;
                            end
                            4'b1011: begin // sub
                                resultado <= reg1 - reg2;
                            end 
                            4'b1100: begin // mult
                                contador_mult <= 0;
                                resultado <= 0;
                                estados_de_saida <= OCUPADA;
                            end
                            default: begin // erro
                                internal_states <= ERROR;
                            end
                        endcase
                        internal_states <= SEND_DIS;
                    end else begin
                        internal_states <= ERROR;
                        estados_de_saida <= ERRO;
                    end
                end

                SEND_DIS: begin

                end

                ERROR: begin // espera reset
                    internal_states <= ERROR;
                    estados_de_saida <= ERRO;
                end
            endcase

            case (estados_de_saida)
                ERRO: begin
                    estados_de_saida <= ERRO;
                end
                PRONTA: begin 
                    estados_de_saida <= PRONTA;
                end 
                OCUPADA: begin
                
                end
                IMPRIME: begin
                    estados_de_saida <= IMPRIME;
                end
            endcase
        end
    end
endmodule