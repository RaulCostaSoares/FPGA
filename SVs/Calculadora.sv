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
    input  logic       clock,     
    input  logic       reset,     
    input  logic [3:0] cmd,       // comando para receber digito ou operador

    output logic [1:0] status,    // estado atual
    output logic [3:0] pos,       // posição do display 
    output logic [3:0] data       // dígito do display
);

    // ====================
    // Estados possíveis
    // ====================
    typedef enum logic [1:0] {
        ERRO    = 2'b00,
        PRONTA  = 2'b01,
        OCUPADA = 2'b10
    } estado_t;

    estado_t estado_atual;

    // ========================
    // Registradores internos
    // ========================
    reg [31:0] reg1, reg2, saida, contador;
    reg [3:0]  op;
    reg        set_op;

    // ====================
    // Saídas
    // ====================
    assign status = estado_atual;
    assign data   = saida[3:0];  //digito do display
    assign pos    = 4'd0;        // Posição do display

    // ======================
    // Lógica principal
    // ======================
    always @(posedge clock or negedge reset) begin
        if (!reset) begin
            // Reset geral
            estado_atual <= PRONTA;
            reg1         <= 0;
            reg2         <= 0;
            saida        <= 0;
            op           <= 4'b1010; // padrão: soma
            set_op       <= 0;
            contador     <= 0;
        end else begin
            case (estado_atual)

                // pronta para receber digito/operador
                PRONTA: begin
                    if (cmd < 10) begin
                        if (!set_op)
                            reg1 <= (reg1 * 10) + cmd;
                        else
                            reg2 <= (reg2 * 10) + cmd;
                    end 

                    //Quando o cmd for "=", realiza as operações
                    else if (cmd == 4'b1110) begin 
                        case (op)
                            //Soma
                            4'b1010: saida <= reg1 + reg2; 

                            // Subtração
                            4'b1011: saida <= reg1 - reg2;  

                            // Multiplicação
                            4'b1100: begin                   
                                if (reg2 == 0) begin
                                    saida <= 0;
                                end else begin
                                    saida        <= 0;
                                    contador     <= 0;
                                    estado_atual <= OCUPADA;  //fica ocupada e faz as operações com soma repetidas
                                end
                            end
                            4'b1111: begin  // Backspace
                                if (set_op)
                                    reg2 <= reg2 / 10;
                                else
                                    reg1 <= reg1 / 10;
                            end
                            default: estado_atual <= ERRO;
                        endcase
                    end 


                    //Se não for número nem "igual", só pode ser um operador.
                    else begin
                        // Se for operador válido
                        op     <= cmd;
                        set_op <= 1;
                    end

                    // Checa overflow de 8 dígitos
                    if ((!set_op && reg1 > 32'd99999999) || (set_op && reg2 > 32'd99999999)) begin
                        estado_atual <= ERRO;
                    end
                end

                // Erro em caso de overflow
                ERRO: begin
                    if (cmd == 4'b1111) begin
                        estado_atual <= PRONTA;
                        reg1         <= 0;
                        reg2         <= 0;
                        saida        <= 0;
                        op           <= 4'b1010;
                        set_op       <= 0;
                        contador     <= 0;
                    end
                end

                // Multiplicação sendo feita por somas repetidas
                OCUPADA: begin
                    if (contador < reg2) begin
                        saida    <= saida + reg1;
                        contador <= contador + 1;
                    end else begin
                        contador <= 0;
                        if (saida > 32'd99999999)
                            estado_atual <= ERRO;
                        else
                            estado_atual <= PRONTA;
                    end
                end

            endcase
        end
    end

endmodule
