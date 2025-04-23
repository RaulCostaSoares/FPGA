module Calculadora_Top(
    input logic [3:0] cmd,
    input logic reset, clock,
    output logic [7:0] d0, d1, d2, d3, d4, d5, d6, d7
);

    reg [3:0] data, pos;
    reg [1:0] status;  
    reg [7:0] a, b, c, d, e, f, g, dp;

    Calculadora calculo (
        .clock(clock),
        .reset(reset),
        .cmd(cmd),
        .data(data),
        .pos(pos),
        .status(status)
    );

    Display_Ctrl controlador(
        .clock(clock),
        .reset(reset),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .dp(dp)
    );

    assign d0 = {dp[0], g[0], f[0], e[0], d[0], c[0], b[0], a[0]};
    assign d1 = {dp[1], g[1], f[1], e[1], d[1], c[1], b[1], a[1]};
    assign d2 = {dp[2], g[2], f[2], e[2], d[2], c[2], b[2], a[2]};
    assign d3 = {dp[3], g[3], f[3], e[3], d[3], c[3], b[3], a[3]};
    assign d4 = {dp[4], g[4], f[4], e[4], d[4], c[4], b[4], a[4]};
    assign d5 = {dp[5], g[5], f[5], e[5], d[5], c[5], b[5], a[5]};
    assign d6 = {dp[6], g[6], f[6], e[6], d[6], c[6], b[6], a[6]};
    assign d7 = {dp[7], g[7], f[7], e[7], d[7], c[7], b[7], a[7]};

endmodule