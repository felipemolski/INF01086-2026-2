`timescale 1ns / 1ps

module tb_checkpoint_integrado;

    reg        CLOCK_50;
    reg  [2:0] BUTTON;
    reg  [9:0] SW;
    wire [9:0] LEDG;
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;

    ProjetoFinal uut (
        .CLOCK_50 (CLOCK_50),
        .BUTTON   (BUTTON),
        .SW       (SW),
        .LEDG     (LEDG),
        .HEX0     (HEX0),
        .HEX1     (HEX1),
        .HEX2     (HEX2),
        .HEX3     (HEX3)
    );

    always #10 CLOCK_50 = ~CLOCK_50;

    initial begin
        CLOCK_50 = 0;
        BUTTON = 3'b111;
        SW = 10'b0000000000;

        // Reset
        #50;
        BUTTON[0] = 0;
        #100;
        BUTTON[0] = 1;
        #50;

        // LDA (0x2)
        SW[7:4] = 4'h2;
        SW[0]   = 1'b1;
        SW[3:0] = 4'h7;
        #100;

        // ADD (0x3)
        SW[7:4] = 4'h3;
        SW[9:8] = 2'b01;
        SW[3:0] = 4'h3;
        #100;

        // Teste flag zero
        SW[9:8] = 2'b00;
        SW[7:4] = 4'h5;
        SW[3:0] = 4'h0;
        #100;

        // HLT (0xF)
        SW[7:4] = 4'hF;
        #100;

        // Step manual
        SW[0] = 1'b0;
        SW[7:4] = 4'h0;
        #100;
        BUTTON[1] = 0;
        #60;
        BUTTON[1] = 1;
        #100;

        $finish;
    end

endmodule
