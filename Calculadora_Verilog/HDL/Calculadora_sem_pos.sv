module Calculadora(
    input logic [3:0] cmd,  // comando para receber digito ou operador
    input logic reset,
    input logic clock, 

    output logic [1:0] status, // estado atual
    output logic [3:0] pos,     // posição do display 
    output logic [3:0] dig      // dígito do display
);

    typedef enum logic [1:0] {ERRO, PRONTA, OCUPADA} statetype;
    statetype estados;

    reg [31:0] reg1, reg2, saida, contador;
    reg [3:0] op;
    reg set_op, flag, flag_div;

    assign status   = estados[1:0]; 

    always @(posedge clock ) begin
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
                    dig <=  cmd;
                    flag <= 1;
                end else if (cmd < 10 && set_op) begin 
                    reg2 <= (reg2 * 10) + cmd;
                    dig <=  cmd;
                    flag <= 1;
                end else if (cmd == 4'b1110) begin
                    case (op)
                        4'b1010: begin
                            saida <= reg1 + reg2;
                        end                
                        4'b1011: begin
                            saida <= reg1 - reg2;    
                        end  
                        4'b1100: begin
                            if (reg1 == 0 | reg2 == 0) begin
                                dig <= 0;
                            end else begin
                                saida <= 0;
                                contador <= 0;
                                estados <= OCUPADA;
                            end
                        end
                        4'b1111: begin
                            if (set_op) begin
                                reg2 <= reg2 / 10;
                            end
                            
                            else begin
                                reg1 <= reg1 / 10;
                            end
                        end
                        default: estados <= PRONTA;
                    endcase
                end else if ((!set_op && reg1 > 32'd99999999) || (set_op && reg2 > 32'd99999999)) begin
                    estados <= ERRO;
                    pos <= 0;
                end else begin
                    op     <= cmd;
                    set_op <= 1;
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
                    if (saida > 32'd99999999) begin
                        estados <= ERRO;
                    end else begin
                        estados <= PRONTA;
                        dig <= (saida / 1) % 10; 
                        pos <= 0;
                    end
                end
            end
        endcase
    end
end
    
endmodule
