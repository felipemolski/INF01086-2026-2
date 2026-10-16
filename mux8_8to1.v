// Multiplexador 8 para 1 de palavras de 8 bits
// Utilizado para selecao de operacao na ULA estrutural

module mux8_8to1 (
    input  wire [2:0] sel,
    input  wire [7:0] in0,
    input  wire [7:0] in1,
    input  wire [7:0] in2,
    input  wire [7:0] in3,
    input  wire [7:0] in4,
    input  wire [7:0] in5,
    input  wire [7:0] in6,
    input  wire [7:0] in7,
    output wire [7:0] out
);

    assign out = (sel == 3'b000) ? in0 :
                 (sel == 3'b001) ? in1 :
                 (sel == 3'b010) ? in2 :
                 (sel == 3'b011) ? in3 :
                 (sel == 3'b100) ? in4 :
                 (sel == 3'b101) ? in5 :
                 (sel == 3'b110) ? in6 : in7;

endmodule
