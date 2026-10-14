// PC de 8 bits integrado com divisor de clock e displays HEX3 e HEX2

module etapa4_pc_divisor #(
    parameter DIVISOR = 25000000
)(
    input  wire       clk_50mhz,
    input  wire       rst,
    input  wire       run_debug,
    input  wire       step_btn_n,
    input  wire       cargaPC,
    input  wire       incrementaPC,
    input  wire [7:0] data_in,
    output wire       clk_effective,
    output wire [7:0] pc_out,
    output wire [6:0] hex3,
    output wire [6:0] hex2
);

    wire clk_div;

    clock_divider #(.DIVISOR(DIVISOR)) div_inst (
        .clk_in  (clk_50mhz),
        .rst     (rst),
        .clk_out (clk_div)
    );

    run_step_ctrl run_step_inst (
        .clk_fast     (clk_50mhz),
        .rst          (rst),
        .clk_div      (clk_div),
        .run_debug    (run_debug),
        .step_btn_n   (step_btn_n),
        .clk_effective(clk_effective)
    );

    pc_neander pc_inst (
        .clk         (clk_effective),
        .rst         (rst),
        .cargaPC     (cargaPC),
        .incrementaPC(incrementaPC),
        .data_in     (data_in),
        .pc_out      (pc_out)
    );

    // Nibble alto [7:4]
    hex_to_7seg dec_hex3 (
        .hex_digit (pc_out[7:4]),
        .seg       (hex3)
    );

    // Nibble baixo [3:0]
    hex_to_7seg dec_hex2 (
        .hex_digit (pc_out[3:0]),
        .seg       (hex2)
    );

endmodule
