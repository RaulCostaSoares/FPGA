module Calculadora_Top(
    input logic [3:0] cmd,
    input logic reset, clock,
    output logic [7:0] d0, d1, d2, d3, d4, d5, d6, d7 
);

    logic [3:0] dig, pos;  
    logic [1:0] status;    
    logic [7:0] a, b, c, d, e, f, g, dp;  
    
    Calculadora calculo (
        .clock(clock),
        .reset(reset),
        .cmd(cmd),
        .dig(dig),
        .pos(pos),
        .status(status)
    );

    Display_Ctrl controlador(
        .clock(clock),
        .reset(reset),
        .dig(dig),
        .pos(pos),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .dp(dp)
    );

    assign d0 = {a[0], b[0], c[0], d[0], e[0], f[0], g[0], dp[0]};
    assign d1 = {a[1], b[1], c[1], d[1], e[1], f[1], g[1], dp[1]};
    assign d2 = {a[2], b[2], c[2], d[2], e[2], f[2], g[2], dp[2]};
    assign d3 = {a[3], b[3], c[3], d[3], e[3], f[3], g[3], dp[3]};
    assign d4 = {a[4], b[4], c[4], d[4], e[4], f[4], g[4], dp[4]};
    assign d5 = {a[5], b[5], c[5], d[5], e[5], f[5], g[5], dp[5]};
    assign d6 = {a[6], b[6], c[6], d[6], e[6], f[6], g[6], dp[6]};
    assign d7 = {a[7], b[7], c[7], d[7], e[7], f[7], g[7], dp[7]};

endmodule