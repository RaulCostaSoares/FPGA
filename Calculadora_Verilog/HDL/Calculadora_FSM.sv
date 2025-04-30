module Calculadora(
    input  logic [3:0] cmd,  
    input  logic reset,
    input  logic clock, 

    output logic [1:0] status, 
    output logic [3:0] pos,     
    output logic [3:0] dig     
);

    typedef enum logic [1:0] {ERRO, PRONTA, OCUPADA} estados_sinal;
    typedef enum logic [2:0] {
        IN_REG1, IN_OP, IN_REG2, IN_EQUAL, SEND_DIS, ERROR
    } estados_calculadora;

    estados_sinal out_states;
    estados_calculadora states;

    assign status = out_states;

    reg [31:0] reg1, reg2, resultado;
    reg [3:0]  operacao;

    reg [31:0] contador_m;
    reg [31:0] aux_resultado;
    reg [3:0]  pos_disp;

    always_ff @ (posedge clock) begin
        if (reset) begin
            states <= IN_REG1;
            out_states <= PRONTA;
            reg1 <= 0;
            reg2 <= 0;
            resultado <= 0;
            operacao <= 0;
            contador_m <= 0;
            aux_resultado <= 0;
            pos_disp <= 0;
            $display("Reset: reg1=%d, reg2=%d, resultado=%d, operacao=%d", reg1, reg2, resultado, operacao);
        end else begin
            $display("DIG = %0d | POS = %0d", dig, pos);
            case (states)

                IN_REG1: begin
                    if (cmd < 10) begin
                        reg1 <= cmd;
                        dig <= cmd;
                        pos <= 0;
                        states <= IN_OP;
                        out_states <= OCUPADA;
                        $display("IN_REG1: reg1=%d", reg1);
                    end
                end

                IN_OP: begin
                    if (cmd > 9 && cmd != 4'b1111) begin
                        operacao <= cmd;
                        states <= IN_REG2;
                        $display("IN_OP: operacao=%d", operacao);
                    end else if (cmd == 4'b1111) begin
                        reg1 <= reg1 / 10;
                        $display("IN_OP (cmd 4'b1111): reg1=%d", reg1);
                    end else if (cmd < 10) begin
                        reg1 <= (reg1 * 10) + cmd;
                        dig <= cmd;
                        pos <= 0;
                        out_states <= OCUPADA;
                        $display("IN_OP (cmd < 10): reg1=%d", reg1);
                    end
                end

                IN_REG2: begin
                    if (cmd < 10) begin
                        reg2 <= cmd;
                        dig <= cmd;
                        pos <= 0;
                        states <= IN_EQUAL;
                        out_states <= OCUPADA;
                        $display("IN_REG2: reg2=%d", reg2);
                    end
                end

                IN_EQUAL: begin
                    if (cmd == 4'b1111) begin
                        reg2 <= reg2 / 10;
                        $display("IN_EQUAL (cmd 4'b1111): reg2=%d", reg2);
                    end else if (cmd < 10) begin
                        reg2 <= (reg2 * 10) + cmd;
                        dig <= cmd;
                        pos <= 0;
                        out_states <= OCUPADA;
                        $display("IN_EQUAL (cmd < 10): reg2=%d", reg2);
                    end else if (cmd == 4'b1110) begin
                        case (operacao)
                            4'b1010: begin
                                resultado <= reg1 + reg2;
                                $display("IN_EQUAL (Soma): resultado=%d", resultado);
                            end
                            4'b1011: begin
                                resultado <= reg1 - reg2;
                                $display("IN_EQUAL (Subtração): resultado=%d", resultado);
                            end
                            4'b1100: begin
                                resultado <= 0;
                                contador_m <= 0;
                                $display("IN_EQUAL (Multiplicação zerada): resultado=%d", resultado);
                            end
                            default: begin
                                states <= ERROR;
                                out_states <= ERRO;
                            end
                        endcase
                        pos_disp <= 0;
                        states <= SEND_DIS;
                    end else begin
                        states <= ERROR;
                        out_states <= ERRO;
                    end
                end

                SEND_DIS: begin
                    if (operacao == 4'b1100 && contador_m < reg2) begin
                        resultado <= resultado + reg1;
                        contador_m <= contador_m + 1;
                        out_states <= OCUPADA;
                        $display("SEND_DIS (Multiplicação em andamento): resultado=%d, contador_m=%d", resultado, contador_m);
                    end 
                    else if (operacao == 4'b1100 && contador_m == reg2) begin
                        if (resultado > 32'd99999999) begin
                            states <= ERROR;
                            out_states <= ERRO;
                        end else begin
                            aux_resultado <= resultado;
                            pos_disp <= 0;
                            operacao <= 0; // limpa para não reentrar
                            $display("SEND_DIS (Multiplicação concluída): aux_resultado=%d", aux_resultado);
                        end
                    end 
                    // Soma/sub: copia resultado no primeiro ciclo
                    else if (pos_disp == 0 && operacao != 4'b1100) begin
                        if (resultado > 32'd99999999) begin
                            states <= ERROR;
                            out_states <= ERRO;
                        end else begin
                            aux_resultado <= resultado;
                            $display("SEND_DIS (Soma/Subtracao): aux_resultado=%d", aux_resultado);
                        end
                    end 
                    // Exibição do resultado
                    else if (pos_disp < 8) begin
                        dig <= aux_resultado % 10;
                        aux_resultado <= aux_resultado / 10;
                        pos <= 7 - pos_disp;
                        pos_disp <= pos_disp + 1;
                        out_states <= OCUPADA;
                        $display("SEND_DIS (Exibição): aux_resultado=%d, dig=%d, pos=%d", aux_resultado, dig, pos);
                    end 
                    // Fim da exibição
                    else begin
                        resultado <= 0;
                        operacao <= 0;
                        contador_m <= 0;
                        states <= IN_REG1;
                        out_states <= PRONTA;
                        $display("SEND_DIS (Fim): resultado=%d", resultado);
                    end
                end

                ERROR: begin
                    out_states <= ERRO;
                    $display("ERROR: reg1=%d, reg2=%d, resultado=%d, operacao=%d", reg1, reg2, resultado, operacao);
                end
            endcase
        end
    end
endmodule