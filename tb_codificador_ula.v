`timescale 1ns / 1ps

module tb_codificador_ula;

    reg        ula_y;
    reg        ula_add;
    reg        ula_and;
    reg        ula_or;
    reg        ula_not;
    wire [2:0] selUAL;

    codificador_ula uut (
        .ula_y   (ula_y),
        .ula_add (ula_add),
        .ula_and (ula_and),
        .ula_or  (ula_or),
        .ula_not (ula_not),
        .selUAL  (selUAL)
    );

    initial begin
        ula_y = 0; ula_add = 0; ula_and = 0; ula_or = 0; ula_not = 0;
        #10;
        ula_y = 1; #10; ula_y = 0;
        ula_add = 1; #10; ula_add = 0;
        ula_and = 1; #10; ula_and = 0;
        ula_or = 1; #10; ula_or = 0;
        ula_not = 1; #10; ula_not = 0;
        #20;
        $finish;
    end

endmodule
