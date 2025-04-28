/* 
    Módulo: Calculadora
    Função: Calculadora simples com 2 operandos e 1 operador
    Suporta: Soma, Subtração, Multiplicação (somas repetidas) e reset
===============================
    Soma   = 4'b1010;
    Subt   = 4'b1011;
    Mult   = 4'b1100;
    Igual  = 4'b1110;
    Backs  = 4'b1111;
*/

module Calculadora(
    input logic [3:0] cmd,  // comando para receber digito ou operador
    input logic reset,
    input logic clock, 

    output logic [1:0] status, // estado atual
    output logic [3:0] pos,     // posição do display 
    output logic [3:0] dig      // dígito do display
);

    typedef enum logic [1:0] {ERRO, PRONTA, OCUPADA} statetype; //FSM
    statetype estados;

    reg [31:0] reg1, reg2, saida, contador; // a, b, resultado e flag para mult
    reg [3:0] op; // operacao escolhida
    reg set_op, flag, flag_div; // flags para mandar para o display

    assign status = estados[1:0]; // liga estados na saida status

   always @(posedge clock) begin
    if (reset) begin
        estados  <= PRONTA;
        op       <= 4'b1010;
        dig      <= 0;
        pos      <= 0;
        set_op   <= 0;
        flag     <= 0;
        flag_div <= 0;
        reg1     <= 32'd0;
        reg2     <= 32'd0;
        saida    <= 32'b0;
        contador <= 32'd0;
    end else begin
        case (estados)
            PRONTA: begin
                if (cmd < 10 && !set_op) begin
                    reg1 <= (reg1 * 10) + cmd;
                    dig <= cmd;
                    pos <= 0;
                    flag <= 1;
                end 
                else if (cmd < 10 && set_op) begin 
                    reg2 <= (reg2 * 10) + cmd;
                    dig <= cmd;
                    pos <= 0;
                    flag <= 1;
                end 
                else if (cmd == 4'b1110) begin
                    estados <= OCUPADA;
                    case (op)
                        4'b1010: begin // soma
                            saida <= reg1 + reg2;    
                        end                
                        4'b1011: begin // sub
                            saida <= reg1 - reg2;
                        end  
                        4'b1100: begin // mult
                            if (reg1 == 0 || reg2 == 0) begin // se um dos dois forem 0
                                dig <= 0;
                            end else begin
                                saida <= 0;
                                contador <= 0;
                                estados <= OCUPADA;
                            end
                        end
                        4'b1111: begin // backspace
                            if (set_op) begin // se tiver op, precisa ser reg2
                                reg2 <= reg2 / 10;
                            end else begin // se nao tiver, sera reg1
                                reg1 <= reg1 / 10;
                            end
                        end
                        default: estados <= PRONTA;
                    endcase
                end 
                else begin
                    op     <= cmd; // se nao for digito, sera op
                    set_op <= 1; // atualiza flag set_op pois foi selecionado op
                    dig    <= 0;
                    pos    <= 0;
                end

                if ((!set_op && reg1 > 32'd99999999) || (set_op && reg2 > 32'd99999999)) begin
                    estados <= ERRO; //se ultrapassar limite do display
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
                    dig      <= 0;
                    pos      <= 0;
                end
            end

            OCUPADA: begin
                if (op == 4'b1100) begin // multiplicacao
                    if (contador < reg2) begin
                        saida    <= saida + reg1;
                        contador <= contador + 1;
                    end else begin
                        contador <= 0;
                        if (saida > 32'd99999999) begin
                            estados <= ERRO;
                        end else begin
                            estados <= PRONTA;
                            pos <= 0;
                            flag_div <= 0;
                        end
                    end
                end else begin // mostra do display
                    if (!flag_div) begin
                        dig <= saida / 10000000; // pos 0
                        saida <= saida % 10000000; // resto da divisao para o resto dos bits
                        pos <= 0;
                        flag_div <= 1;
                    end else begin
                        case (pos)
                            0: dig <= saida / 10000000;          
                            1: dig <= (saida / 1000000) % 10;    
                            2: dig <= (saida / 100000) % 10;     
                            3: dig <= (saida / 10000) % 10;      
                            4: dig <= (saida / 1000) % 10;       
                            5: dig <= (saida / 100) % 10;        
                            6: dig <= (saida / 10) % 10;         
                            7: dig <= saida % 10;               
                            default: dig <= 0;
                        endcase
                        pos <= pos + 1;
                        if (pos == 8) begin // chegou no final, imprimiu t0dos os bits
                            estados <= PRONTA;
                        end
                    end
                end
            end
        endcase
    end
end

endmodule
