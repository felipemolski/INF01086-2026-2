// ULA de 8 bits do Neander - Descricao Estrutural
// Instancia somador RCA (somador8) e multiplexador (mux8_8to1)

module ula_neander (
    input  wire [7:0] x,
    input  wire [7:0] y,
    input  wire [2:0] selUAL,
    output wire [7:0] out,
    output wire       flag_n,
    output wire       flag_z
);

    // Operacao Y direta (sel = 3'b000)
    wire [7:0] res_y = y;

    // Operacao ADD estrutural (sel = 3'b001) via Somador Ripple Carry
    wire [7:0] res_add;
    wire       cout_add;
    somador8 somador_add (
        .a   (x),
        .b   (y),
        .cin (1'b0),
        .s   (res_add),
        .cout(cout_add)
    );

    // Operacao OU logico (sel = 3'b010)
    wire [7:0] res_or = x | y;

    // Operacao E logico (sel = 3'b011)
    wire [7:0] res_and = x & y;

    // Operacao NOT (sel = 3'b100)
    wire [7:0] res_not = ~x;

    // Operacao NEG (sel = 3'b101) via complemento de 2 (~x + 1)
    wire [7:0] res_neg;
    wire       cout_neg;
    somador8 somador_neg (
        .a   (~x),
        .b   (8'h00),
        .cin (1'b1),
        .s   (res_neg),
        .cout(cout_neg)
    );

    // Multiplexador estrutural de saida
    mux8_8to1 mux_operacoes (
        .sel(selUAL),
        .in0(res_y),
        .in1(res_add),
        .in2(res_or),
        .in3(res_and),
        .in4(res_not),
        .in5(res_neg),
        .in6(8'h00),
        .in7(8'h00),
        .out(out)
    );

    // Deteccao estrutural de flags
    assign flag_n = out[7];
    assign flag_z = ~(|out);

endmodule
