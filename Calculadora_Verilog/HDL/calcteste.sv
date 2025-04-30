module Calculadora(
    input  logic [3:0] cmd,  
    input  logic reset,
    input  logic clock, 

    output logic [1:0] status, 
    output logic [3:0] pos,     
    output logic [3:0] dig     
);
    typedef enum logic [1:0] {
        ERRO, PRONTA, OCUPADA
    } estados_sinal;

    typedef enum logic [3:0] {
        IN_REG1, IMPRIME_REG1, IN_OP, IN_REG2, IMPRIME_REG2, IN_EQUAL, EXEC_MULT, IMPRIME, ERROR
    } estados_calculadora;

    estados_sinal estados_de_saida;
    estados_calculadora internal_states;

    assign status = estados_de_saida;

    reg [31:0] reg1, reg2, resultado, contador_mult;
    reg [31:0] aux_resultado, aux_reg1, aux_reg2;
    reg [3:0]  operacao, pos_disp;

    always_ff @ (posedge clock) begin
        if (reset) begin
            internal_states     <= IN_REG1;
            estados_de_saida    <= PRONTA;
            reg1                <= 0;
            reg2                <= 0;
            resultado           <= 0;
            operacao            <= 0;
            contador_mult       <= 0;
            aux_resultado       <= 0;
            aux_reg1            <= 0;
            aux_reg2            <= 0;
            pos_disp            <= 0;
            pos                 <= 0;
            dig                 <= 0;
        end else begin
            case (internal_states)
                IN_REG1: begin
                    if (cmd < 10) begin
                        reg1 <= cmd;
                        aux_reg1 <= cmd;
                        pos_disp <= 0;
                        internal_states <= IMPRIME_REG1;
                    end
                end

                IMPRIME_REG1: begin
                    dig <= aux_reg1 % 10;
                    pos <= pos_disp;
                    aux_reg1 <= aux_reg1 / 10;
                    pos_disp <= pos_disp + 1;
                    if (aux_reg1 == 0 || pos_disp == 8)
                        internal_states <= IN_OP;
                end

                IN_OP: begin
                    if (cmd >= 4'b1010 && cmd <= 4'b1100) begin
                        operacao <= cmd;
                        internal_states <= IN_REG2;
                    end else if (cmd == 4'b1111) begin
                        reg1 <= reg1 / 10;
                    end else if (cmd < 10) begin
                        reg1 <= (reg1 * 10) + cmd;
                        aux_reg1 <= (reg1 * 10) + cmd;
                        pos_disp <= 0;
                        internal_states <= IMPRIME_REG1;
                    end else begin
                        internal_states <= ERROR;
                        estados_de_saida <= ERRO;
                    end
                end

                IN_REG2: begin
                    if (cmd < 10) begin
                        reg2 <= cmd;
                        aux_reg2 <= cmd;
                        pos_disp <= 0;
                        internal_states <= IMPRIME_REG2;
                        estados_de_saida <= OCUPADA;
                    end
                end

                IMPRIME_REG2: begin
                    dig <= aux_reg2 % 10;
                    pos <= pos_disp;
                    aux_reg2 <= aux_reg2 / 10;
                    pos_disp <= pos_disp + 1;
                    if (aux_reg2 == 0 || pos_disp == 8)
                        internal_states <= IN_EQUAL;
                end

                IN_EQUAL: begin
                    if (cmd == 4'b1111) begin
                        reg2 <= reg2 / 10;
                    end else if (cmd < 10) begin
                        reg2 <= (reg2 * 10) + cmd;
                        aux_reg2 <= (reg2 * 10) + cmd;
                        pos_disp <= 0;
                        internal_states <= IMPRIME_REG2;
                    end else if (cmd == 4'b1110) begin
                        case (operacao)
                            4'b1010: begin // soma
                                resultado <= reg1 + reg2;
                                aux_resultado <= reg1 + reg2;
                                pos_disp <= 0;
                                internal_states <= IMPRIME;
                            end
                            4'b1011: begin // sub
                                resultado <= reg1 - reg2;
                                aux_resultado <= reg1 - reg2;
                                pos_disp <= 0;
                                internal_states <= IMPRIME;
                            end
                            4'b1100: begin // mult
                                contador_mult <= 0;
                                resultado <= 0;
                                estados_de_saida <= OCUPADA;
                                internal_states <= EXEC_MULT;
                            end
                            default: begin
                                internal_states <= ERROR;
                                estados_de_saida <= ERRO;
                            end
                        endcase
                    end else begin
                        internal_states <= ERROR;
                        estados_de_saida <= ERRO;
                    end
                end

                EXEC_MULT: begin
                    if (contador_mult < reg2) begin
                        resultado <= resultado + reg1;
                        contador_mult <= contador_mult + 1;
                    end else begin
                        aux_resultado <= resultado;
                        pos_disp <= 0;
                        internal_states <= IMPRIME;
                    end
                end

                IMPRIME: begin
                    if (resultado > 32'd99999999) begin
                        internal_states <= ERROR;
                        estados_de_saida <= ERRO;
                    end else begin
                        dig <= aux_resultado % 10;
                        pos <= pos_disp;
                        aux_resultado <= aux_resultado / 10;
                        pos_disp <= pos_disp + 1;
                        if (pos_disp == 8) begin
                            internal_states <= IN_REG1;
                            estados_de_saida <= PRONTA;
                            reg1 <= 0;
                            reg2 <= 0;
                            operacao <= 0;
                            resultado <= 0;
                            contador_mult <= 0;
                            aux_resultado <= 0;
                            aux_reg1 <= 0;
                            aux_reg2 <= 0;
                            pos_disp <= 0;
                        end
                    end
                end

                ERROR: begin
                    internal_states <= ERROR;
                    estados_de_saida <= ERRO;
                end
            endcase
        end
    end
endmodule
