// ==============================
// Módulo: Calculadora
// Função: Controla a lógica de uma calculadora simples (2 operandos e 1 operador)
// Suporta: Soma (+), Subtração (-), Multiplicação (*), Reset e Backspace
// Mostra resultado no display via sinais "data" e "pos"
// ==============================

module Calculadora(
    input  logic       clock,     
    input  logic       reset,     
    input  logic [3:0] cmd,       // comando
    output logic [1:0] status,    // estado da calculadora
    output logic [3:0] pos,       // posição do display
    output logic [3:0] data       // digito do display
);

    // =====================
    // Estados possíveis
    // =====================
    typedef enum logic [1:0] {
        PRONTA  = 2'b00,
        OCUPADA = 2'b01,
        ERRO    = 2'b10
    } estado_t;

    estado_t estado;

    // ======================
    // Registradores internos
    // ======================
    logic [3:0] reg1;  // primeiro num
    logic [3:0] reg2;  // segundo num
    logic [3:0] op;    // operação

    // =====================
    // Lógica sequencial principal
    // =====================
    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            //reinicia tudo
            estado <= PRONTA;
            reg1 <= 0;
            reg2 <= 0;
            op <= 0;
            data <= 0;
            pos <= 0;
            status <= PRONTA;

        end else begin
            case (estado)

                PRONTA: begin
                    status <= PRONTA;

                    // entrada de número (0 a 9)
                    if (cmd <= 4'd9) begin
                        if (op == 0) begin
                            reg1 <= cmd;
                            pos <= 0;
                        end else begin
                            reg2 <= cmd;
                            pos <= 1;
                        end
                        data <= cmd;
                    end

                    // operadores
                    else if (cmd == 4'd10 || cmd == 4'd11 || cmd == 4'd12) begin
                        op <= cmd;
                    end

                    // igual -> realiza a operação
                    else if (cmd == 4'd14) begin
                        estado <= OCUPADA;
                        status <= OCUPADA;
                    end

                    // backspace -> reseta tudo
                    else if (cmd == 4'd15) begin
                        reg1 <= 0;
                        reg2 <= 0;
                        op <= 0;
                        data <= 0;
                        pos <= 0;
                    end
                end

                OCUPADA: begin
                    case (op)
                        4'd10: data <= reg1 + reg2;  // soma
                        4'd11: data <= reg1 - reg2;  // subtração
                        4'd12: data <= reg1 * reg2;  // multiplicação
                        default: begin
                            estado <= ERRO;
                            status <= ERRO;
                        end
                    endcase
                    pos <= 2;  // resultado na posição 2
                    estado <= PRONTA;
                    status <= PRONTA;
                end

                ERRO: begin
                    data <= 4'd14; // código para mostrar "E" no display
                    pos <= 0;
                    if (cmd == 4'd15) begin
                        estado <= PRONTA;
                        status <= PRONTA;
                        reg1 <= 0;
                        reg2 <= 0;
                        op <= 0;
                        data <= 0;
                        pos <= 0;
                    end
                end
            endcase
        end
    end
endmodule
