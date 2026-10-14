`timescale 1ns / 1ps

module tb_pc_neander;

    reg        clk_50mhz;
    reg        rst;
    reg        run_debug;
    reg        step_btn_n;
    reg        cargaPC;
    reg        incrementaPC;
    reg  [7:0] data_in;
    wire       clk_effective;
    wire [7:0] pc_out;
    wire [6:0] hex3;
    wire [6:0] hex2;

    etapa4_pc_divisor #(.DIVISOR(4)) uut (
        .clk_50mhz    (clk_50mhz),
        .rst          (rst),
        .run_debug    (run_debug),
        .step_btn_n   (step_btn_n),
        .cargaPC      (cargaPC),
        .incrementaPC (incrementaPC),
        .data_in      (data_in),
        .clk_effective(clk_effective),
        .pc_out       (pc_out),
        .hex3         (hex3),
        .hex2         (hex2)
    );

    always #10 clk_50mhz = ~clk_50mhz;

    initial begin
        clk_50mhz = 0;
        rst = 1;
        run_debug = 1;
        step_btn_n = 1;
        cargaPC = 0;
        incrementaPC = 0;
        data_in = 8'h00;

        #40;
        rst = 0;
        #20;

        // Incremento no modo RUN
        incrementaPC = 1;
        repeat (6) @(posedge clk_effective);

        // Salto (carga)
        incrementaPC = 0;
        cargaPC = 1;
        data_in = 8'h80;
        @(posedge clk_effective);

        // Continua incrementando
        cargaPC = 0;
        incrementaPC = 1;
        repeat (2) @(posedge clk_effective);

        // Modo DEBUG
        run_debug = 0;
        #40;
        step_btn_n = 0;
        #40;
        step_btn_n = 1;
        #80;

        $finish;
    end

endmodule
