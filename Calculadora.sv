// ==============================
// Módulo: Calculadora
// Função: Calculadora simples com 2 operandos e 1 operador
// Suporta: Soma, Subtração, Multiplicação (usando soma repetida) e reset
// ===============================

// =========================
//  Soma   = 4'b1010;
//  Subt   = 4'b1011;
//  Mult   = 4'b1100;
//  Igual  = 4'b1110;
//  Backs  = 4'b1111;
// =========================

module Calculadora(
    input logic [3:0] cmd,  // comando para receber digito ou operador
    input logic reset,
    input logic clock, 

    output logic [1:0] status, // estado atual
    output logic [3:0] pos,     // posição do display 
    output logic [3:0] dig      // dígito do display
);


    // ====================
    // Estados possíveis
    // ====================
    typedef enum logic [1:0] {ERRO, PRONTA, OCUPADA} statetype;
    statetype estados;

    // ========================
    // Registradores internos
    // ========================
    reg [31:0] reg1, reg2, saida, contador;
    reg [3:0] op;
    reg set_op, flag, flag_div;


    // ====================
    // Saídas
    // ====================
    assign status   = estados[1:0]; 

    // ======================
    // Lógica principal
    // ======================
    always @(posedge clock ) begin
    if (reset) begin
        estados  <= PRONTA;
        op       <= 4'b1010;
        dig      <= 0;
        pos      <= -1;
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
                //reg1
                if (cmd < 10 && !set_op) begin
                    reg1 <= (reg1 * 10) + cmd;
                    dig <=  cmd;
                    
                //não incrementa pós na primeira vez
                if(flag) 
                begin
                   pos <= pos + 1;
                end

                flag <= 1;
                end 

                //reg2
                else if (cmd < 10 && set_op) begin 
                    reg2 <= (reg2 * 10) + cmd;
                    dig <=  cmd;
                    

                //não incrementa pós na primeira vez
                if(flag) 
                begin
                   pos <= pos + 1;
                end

                flag <= 1;
                end 

                else if (cmd == 4'b1110) begin // teste se digitou igual
                    case (op)

                        //soma
                     4'b1010: begin
                        
                        dig <= reg1 + reg2;
                        pos <= pos + 1;

                        // -----  Lógica Teste ---------//
                        //saida <= reg1 + reg2;
                        // if(flag_div == 0) begin
                        // dig <= saida / 10;
                        // pos <= pos + 1;
                        // flag_div <= 1; 
                        // end
                        // else
                        // dig <= saida % 10;
                        
                end                
                        
                        //sub
                        4'b1011: begin
                                 dig <= reg1 - reg2;
                                 pos <= pos + 1;
                                 end  
                        
                        //mult
                        4'b1100: begin
                            if (reg1 == 0 | reg2 == 0) begin
                                dig <= 0;
                                pos <= pos + 1;
                            end
                            else begin
                                saida <= 0;
                                contador <= 0;
                                estados <= OCUPADA;
                            end
                        end


                        //backspace
                        4'b1111: 
                        begin
                            if (set_op) begin
                                reg2 <= reg2 / 10;
                                pos <= pos - 1;
                            end
                            
                            else begin
                                reg1 <= reg1 / 10;
                                pos <= pos - 1;
                            end

                        end
                        default: estados <= ERRO;

                    endcase
                end else begin
                    op     <= cmd;
                    set_op <= 1;
                end

                if ((!set_op && reg1 > 32'd99999999) || (set_op && reg2 > 32'd99999999)) begin
                    estados <= ERRO;
                    pos <= 0;
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
                if (contador < reg2) begin
                    saida    <= saida + reg1;
                    contador <= contador + 1;
                end else begin
                    contador <= 0;
                    if (saida > 32'd99999999)
                        estados <= ERRO;
                    else
                        estados <= PRONTA;
                        dig <= saida;
                        pos <= pos + 1;
                end
            end


        endcase
    end
end
    
endmodule
