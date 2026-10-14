// Decoder de instrucoes do Neander
// Decodifica o opcode (RI[7:4]) para cada uma das 11 instrucoes

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

    assign nop    = (opcode == 4'b0000);
    assign sta    = (opcode == 4'b0001);
    assign lda    = (opcode == 4'b0010);
    assign add    = (opcode == 4'b0011);
    assign or_op  = (opcode == 4'b0100);
    assign and_op = (opcode == 4'b0101);
    assign not_op = (opcode == 4'b0110);
    assign jmp    = (opcode == 4'b1000);
    assign jn     = (opcode == 4'b1001);
    assign jz     = (opcode == 4'b1010);
    assign hlt    = (opcode == 4'b1111);

endmodule
