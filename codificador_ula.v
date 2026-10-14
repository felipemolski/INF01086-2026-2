// Codificador de operacoes da ULA
// Gera o seletor selUAL (3 bits) a partir dos comandos da UC

module codificador_ula (
    input  wire       ula_y,    // Passa Y direto
    input  wire       ula_add,  // Soma X + Y
    input  wire       ula_and,  // X and Y
    input  wire       ula_or,   // X or Y
    input  wire       ula_not,  // not X
    output reg  [2:0] selUAL
);

    always @(*) begin
        if (ula_add)
            selUAL = 3'b001; // ADD
        else if (ula_and)
            selUAL = 3'b010; // AND
        else if (ula_or)
            selUAL = 3'b011; // OR
        else if (ula_not)
            selUAL = 3'b100; // NOT
        else if (ula_y)
            selUAL = 3'b000; // Y
        else
            selUAL = 3'b000;
    end

endmodule
