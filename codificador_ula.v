// Codificador de operacoes da ULA do Neander - Descricao Estrutural
// Equacoes logicas booleanas para geracao do barramento selUAL[2:0]

module codificador_ula (
    input  wire       ula_y,
    input  wire       ula_add,
    input  wire       ula_or,
    input  wire       ula_and,
    input  wire       ula_not,
    output wire [2:0] selUAL
);

    // Mapeamento:
    // ula_y   -> 3'b000
    // ula_add -> 3'b001
    // ula_or  -> 3'b010
    // ula_and -> 3'b011
    // ula_not -> 3'b100

    assign selUAL[0] = ula_add | ula_and;
    assign selUAL[1] = ula_or  | ula_and;
    assign selUAL[2] = ula_not;

endmodule
