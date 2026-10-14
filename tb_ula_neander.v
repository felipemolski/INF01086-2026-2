`timescale 1ns / 1ps

module tb_ula_neander;

    reg  [7:0] x;
    reg  [7:0] y;
    reg  [2:0] selUAL;
    wire [7:0] ula_out;
    wire       flag_n;
    wire       flag_z;
    wire [6:0] hex1;
    wire [6:0] hex0;

    etapa3_ula_display uut (
        .x       (x),
        .y       (y),
        .selUAL  (selUAL),
        .ula_out (ula_out),
        .flag_n  (flag_n),
        .flag_z  (flag_z),
        .hex1    (hex1),
        .hex0    (hex0)
    );

    initial begin
        // Y
        x = 8'h55; y = 8'hA3; selUAL = 3'b000; #20;

        // ADD
        x = 8'd15; y = 8'd25; selUAL = 3'b001; #20;

        // ADD gerando zero
        x = 8'hFF; y = 8'h01; selUAL = 3'b001; #20;

        // AND
        x = 8'hF0; y = 8'hAA; selUAL = 3'b010; #20;

        // OR
        x = 8'h0F; y = 8'hF0; selUAL = 3'b011; #20;

        // NOT
        x = 8'hAA; y = 8'h00; selUAL = 3'b100; #20;

        #20;
        $finish;
    end

endmodule
