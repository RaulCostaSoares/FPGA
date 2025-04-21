`timescale 1ns/100ps
module tb_final;

  logic [3:0] cmd;
  logic reset;
  logic clock;

  logic [7:0] d0, d1, d2, d3, d4, d5, d6, d7;

  // Instancia o módulo principal
  calculadora_top topo(
    .cmd(cmd),
    .reset(reset),
    .clock(clock),
    .d0(d0),
    .d1(d1),
    .d2(d2),
    .d3(d3),
    .d4(d4),
    .d5(d5),
    .d6(d6),
    .d7(d7)
  );

  // Geração do clock: período de 10ns (100 MHz)
  initial clock = 0;
  always #5 clock = ~clock;

  // Variáveis para monitorar estado interno da calculadora
  logic [1:0] status;
  logic [31:0] reg1, reg2, saida;
  logic [3:0] op;
  logic set_op;

  // Acesso aos sinais internos do módulo Calculadora
  assign status = topo.calculo.estados;
  assign reg1 = topo.calculo.reg1;
  assign reg2 = topo.calculo.reg2;
  assign saida = topo.calculo.saida;
  assign op = topo.calculo.op;
  assign set_op = topo.calculo.set_op;

  // Task para enviar comando cmd como pulso de um ciclo de clock
  task send_cmd(input logic [3:0] val);
  begin
    cmd = val;
    @(posedge clock);
    cmd = 4'd0;
    @(posedge clock);
  end
  endtask

  // Inicialização e estímulos
  initial begin
    // Inicializa sinais
    reset = 1;
    cmd = 4'd0;
    $display("Iniciando simulação...");
    #20;
    reset = 0;
    $display("Reset desativado.");
    $display("\n ERRO = 0\n PRONTA = 1\n OCUPADA = 2 \n");

    // Envia comandos para testar a calculadora
    $display("\n -------------------- \n");
    $display(" > Testando somas 12 + 3\n");

    send_cmd(4'd1);
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d\n", status, reg1, reg2, op, set_op, saida);

    send_cmd(4'd2);
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d\n", status, reg1, reg2, op, set_op, saida);

    send_cmd(4'b1010); // soma +
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d\n", status, reg1, reg2, op, set_op, saida);

    send_cmd(4'd3);
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d\n", status, reg1, reg2, op, set_op, saida);

    send_cmd(4'd4);
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d\n", status, reg1, reg2, op, set_op, saida);

    send_cmd(4'b1110); // igual =
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d", status, reg1, reg2, op, set_op, saida);
    $display("\n -------------------- \n");

    // Testa backspace
    $display("\n -------------------- \n");
    $display(" > Testando backspace\n");

    send_cmd(4'b1111); // backspace
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d\n", status, reg1, reg2, op, set_op, saida);

    send_cmd(4'b1111); // backspace
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d", status, reg1, reg2, op, set_op, saida);
    $display("\n -------------------- \n");

    // Testa subtração: 56 - 7 =
    $display("\n -------------------- \n");
    $display(" > Testando subtração 56 - 7 =\n");

    send_cmd(4'd5);
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d\n", status, reg1, reg2, op, set_op, saida);

    send_cmd(4'd6);
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d", status, reg1, reg2, op, set_op, saida);

    send_cmd(4'b1011); // subtração -
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d\n", status, reg1, reg2, op, set_op, saida);

    send_cmd(4'd7);
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d", status, reg1, reg2, op, set_op, saida);
    $display("\n -------------------- \n");

    send_cmd(4'b1110); // igual =
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d", status, reg1, reg2, op, set_op, saida);

    // Testa multiplicação: 3 * 4 =
    $display("\n -------------------- \n");
    $display(" > Testando multiplicação 3 * 4 = \n");

    send_cmd(4'd3);
    send_cmd(4'd0); // para limpar reg2 antes
    send_cmd(4'b1100); // multiplicação *
    send_cmd(4'd4);
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d\n", status, reg1, reg2, op, set_op, saida);

    send_cmd(4'b1110); // igual =
    $display("Estado: %0d, reg1: %0d, reg2: %0d, op: %b, set_op: %b, saida: %0d", status, reg1, reg2, op, set_op, saida);

    $display("\n -------------------- \n");

    $display("Simulação finalizada.");
    $stop;
  end

endmodule
