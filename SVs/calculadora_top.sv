module calculadora_top(
    input logic [3:0] cmd;
    input logic reset, clock;
    output logic [7:0] a, b, c, d, e, f, g, dp
);

calculadora calc(
    .clock(clock),
    .reset(reset),
    .data(data),
    .pos(pos),
    .cmd(cmd)
);

ctrl control(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .e(e),
    .f(f),
    .g(g),
    .dp(dp)
);

