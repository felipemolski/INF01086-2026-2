`timescale 1ns / 1ps

module tb_decoder_neander;

    reg  [3:0] opcode;
    wire       nop, sta, lda, add, or_op, and_op, not_op, jmp, jn, jz, hlt;

    decoder_neander uut (
        .opcode (opcode),
        .nop    (nop),
        .sta    (sta),
        .lda    (lda),
        .add    (add),
        .or_op  (or_op),
        .and_op (and_op),
        .not_op (not_op),
        .jmp    (jmp),
        .jn     (jn),
        .jz     (jz),
        .hlt    (hlt)
    );

    integer i;

    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            opcode = i[3:0];
            #10;
        end
        $finish;
    end

endmodule
