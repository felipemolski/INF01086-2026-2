// ULA com decodificadores para display de 7 segmentos (HEX1 e HEX0)

module etapa3_ula_display (
    input  wire [7:0] x,
    input  wire [7:0] y,
    input  wire [2:0] selUAL,
    output wire [7:0] ula_out,
    output wire       flag_n,
    output wire       flag_z,
    output wire [6:0] hex1,
    output wire [6:0] hex0
);

    ula_neander ula_inst (
        .x      (x),
        .y      (y),
        .selUAL (selUAL),
        .out    (ula_out),
        .flag_n (flag_n),
        .flag_z (flag_z)
    );

    // Nibble alto [7:4]
    hex_to_7seg dec_hex1 (
        .hex_digit (ula_out[7:4]),
        .seg       (hex1)
    );

    // Nibble baixo [3:0]
    hex_to_7seg dec_hex0 (
        .hex_digit (ula_out[3:0]),
        .seg       (hex0)
    );

endmodule
