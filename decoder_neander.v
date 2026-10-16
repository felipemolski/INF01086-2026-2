// Decodificador de instrucoes do Neander - Descricao Estrutural
// Mintermos decodificados a partir do nibble de opcode RI[7:4]

module decoder_neander (
    input  wire [3:0] opcode,
    output wire       nop,
    output wire       sta,
    output wire       lda,
    output wire       add,
    output wire       or_op,
    output wire       and_op,
    output wire       not_op,
    output wire       jmp,
    output wire       jn,
    output wire       jz,
    output wire       hlt
);

    wire op3_n = ~opcode[3];
    wire op2_n = ~opcode[2];
    wire op1_n = ~opcode[1];
    wire op0_n = ~opcode[0];

    // Equacoes dos mintermos estruturais
    assign nop    = op3_n     & op2_n     & op1_n     & op0_n;     // 4'h0 (0000)
    assign sta    = op3_n     & op2_n     & op1_n     & opcode[0]; // 4'h1 (0001)
    assign lda    = op3_n     & op2_n     & opcode[1] & op0_n;     // 4'h2 (0010)
    assign add    = op3_n     & op2_n     & opcode[1] & opcode[0]; // 4'h3 (0011)
    assign or_op  = op3_n     & opcode[2] & op1_n     & op0_n;     // 4'h4 (0100)
    assign and_op = op3_n     & opcode[2] & op1_n     & opcode[0]; // 4'h5 (0101)
    assign not_op = op3_n     & opcode[2] & opcode[1] & op0_n;     // 4'h6 (0110)
    assign jmp    = opcode[3] & op2_n     & op1_n     & op0_n;     // 4'h8 (1000)
    assign jn     = opcode[3] & op2_n     & op1_n     & opcode[0]; // 4'h9 (1001)
    assign jz     = opcode[3] & op2_n     & opcode[1] & op0_n;     // 4'ha (1010)
    assign hlt    = opcode[3] & opcode[2] & opcode[1] & opcode[0]; // 4'hf (1111)

endmodule
