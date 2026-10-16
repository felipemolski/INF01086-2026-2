// Decodificador Hexadecimal para Display de 7 Segmentos - Descricao Estrutural
// Segmentos ativos em nivel baixo (anodo comum da placa Altera DE0)
// Equacoes booleanas minimizadas via Mapas de Karnaugh

module hex_to_7seg (
    input  wire [3:0] hex_digit,
    output wire [6:0] seg
);

    wire A = hex_digit[3];
    wire B = hex_digit[2];
    wire C = hex_digit[1];
    wire D = hex_digit[0];

    wire nA = ~A;
    wire nB = ~B;
    wire nC = ~C;
    wire nD = ~D;

    // Segmento a
    assign seg[0] = (nA & nB & nC &  D) | 
                    (nA &  B & nC & nD) | 
                    ( A &  B & nC &  D) | 
                    ( A & nB &  C &  D);

    // Segmento b
    assign seg[1] = (nA &  B & nC &  D) | 
                    (nA &  B &  C & nD) | 
                    ( A & nB &  C &  D) | 
                    ( A &  B & nC & nD) | 
                    ( A &  B &  C & nD) | 
                    ( A &  B &  C &  D);

    // Segmento c
    assign seg[2] = (nA & nB &  C & nD) | 
                    ( A &  B & nC & nD) | 
                    ( A &  B &  C & nD) | 
                    ( A &  B &  C &  D);

    // Segmento d
    assign seg[3] = (nA & nB & nC &  D) | 
                    (nA &  B & nC & nD) | 
                    (nA &  B &  C &  D) | 
                    ( A & nB &  C & nD) | 
                    ( A &  B &  C &  D);

    // Segmento e
    assign seg[4] = (nA &  D) | 
                    (nA &  B & nC) | 
                    (nB & nC &  D);

    // Segmento f
    assign seg[5] = (nA & nB &  D) | 
                    (nA & nB &  C) | 
                    (nA &  C &  D) | 
                    ( A &  B & nC &  D);

    // Segmento g
    assign seg[6] = (nA & nB & nC) | 
                    (nA &  B &  C &  D) | 
                    ( A &  B & nC & nD);

endmodule
